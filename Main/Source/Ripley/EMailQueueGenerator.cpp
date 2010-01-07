#include "stdafx.h"
#include ".\emailqueuegenerator.h"
#include ".\xslt.h"
#include ".\tdvassert.h"
#include ".\sitedata.h"
#include ".\tdvdatetime.h"
#include "StoredProcedure.h"
#include ".\EventQueue.h"
#include "User.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CEMailQueueGenerator::CEMailQueueGenerator(CInputContext& inputContext) : CXMLObject(inputContext),
m_InputContext(inputContext), m_iSentEMails(0), m_iFailedAlerts(0), m_iSentPrivateMsgs(0)
{
}

CEMailQueueGenerator::~CEMailQueueGenerator(void)
{
}

/*********************************************************************************

	bool CEMailQueueGenerator::UpdateAndSendEMailAlerts(eEMailUpdateType UpdateType)

		Author:		Mark Howitt
        Created:	24/08/2004
        Inputs:		UpdateType - The type of alerts you want to process.
								 EUT_NORMAL = normal, EUT_INSTANT = instant.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates the email queue from the event queue and Users
					EMail Alert lists.
					The emails are XML based so that they can be skined per site.

*********************************************************************************/
bool CEMailQueueGenerator::UpdateAndSendEMailAlerts(eEMailUpdateType UpdateType)
{
	// Setup the correct itemlist type
	int iEMailType = 0;
	if (UpdateType == EUT_NORMAL)
	{
		iEMailType = 1;
	}
	else if (UpdateType == EUT_INSTANT)
	{
		iEMailType = 2;
	}

	// Start by getting the alerts to send  the EmailEventQueue.
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetAlertsToSend())
	{
		// Problems!
		return SetDNALastError("CEMailQueueGenerator::CreateEMailQueue","GetAlertsToSendFailed","Failed to get alerts to send from the EmailAlertQueue!!!");
	}

	// Setup the error xml
	InitialiseXMLBuilder(&m_sErrorXML);
	OpenXMLTag("EMAIL-ERRORS");

	// Setup the sting that will take the XML and initialise the XML Builder
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = true;
	int iSiteID = 0, iLastSiteID = 0;
	int iUserID = 0, iLastUserID = 0;
	int iNotifyType = 0, iCurrentNotifyType = 0, iEventType = 0;
	CTDVString sEMail;

	// Setup the first userid and siteid
	if (!SP.IsEOF())
	{
		iSiteID = SP.GetIntField("SiteID");
		iUserID = SP.GetIntField("UserID");
	}

	// Now go through the list and create the emails for each user
	bool bAddedEvent = false;
	CEmailAlertList::eNotifyType NotifyType = CEmailAlertList::NT_EMAIL;
	while (bOk && !SP.IsEOF())
	{
		// Create a single email for the current site
		sXML.Empty();
		sEMail.Empty();
		bAddedEvent = false;
		OpenXMLTag("EMAILALERT");
		OpenXMLTag("USERDETAILS");
		bOk = bOk && AddDBXMLIntTag("SITEID");
		bOk = bOk && AddDBXMLIntTag("USERID");
		bOk = bOk && AddDBXMLTag("USERNAME");
		bOk = bOk && AddDBXMLTag("FIRSTNAMES",NULL,false);
		bOk = bOk && AddDBXMLTag("LASTNAME",NULL,false);
		bOk = bOk && AddDBXMLTag("TITLE",NULL,false);
		bOk = bOk && AddDBXMLTag("SITESUFFIX",NULL,false);
		bOk = bOk && AddDBXMLTag("EMAIL",NULL,false,false,&sEMail);
		bOk = bOk && AddDBXMLTag("LISTID");
		CloseXMLTag("USERDETAILS");

		// Get the current notification type
		iCurrentNotifyType = SP.GetIntField("NotifyType");

		// Now loop through the events
		while (bOk && !SP.IsEOF() && iSiteID != 0 && iUserID != 0 &&
					(iLastSiteID == iSiteID || iLastSiteID == 0) &&
					(iLastUserID == iUserID || iLastUserID == 0) &&
					(iCurrentNotifyType == iNotifyType || iNotifyType == 0))
		{
			// Only get the events for the given EMail Type and notification.
			if (SP.GetIntField("EMailType") == iEMailType && SP.GetIntField("NotifyType") == iCurrentNotifyType)
			{
				// Update the XML with the current entry
				OpenXMLTag("ITEMEVENT");
				bOk = bOk && AddDBXMLIntTag("EVENTTYPE",NULL,true,&iEventType);
				bOk = bOk && AddDBXMLDateTag("EVENTDATE",NULL,true,true);
				bOk = bOk && AddDBXMLIntTag("ISOWNER","CONTENTOWNER");
				bOk = bOk && AddDBXMLIntTag("ITEMID");
				bOk = bOk && AddDBXMLIntTag("ITEMTYPE");
				bOk = bOk && AddDBXMLTag("ITEMNAME");
				bOk = bOk && AddDBXMLIntTag("ITEMID2",NULL,false);
				bOk = bOk && AddDBXMLIntTag("ITEMTYPE2",NULL,false);
				bOk = bOk && AddDBXMLTag("ITEMNAME2",NULL,false);

				// If we're a vote event, add the vote response.
				if (iEventType == CEventQueue::ET_VOTEADDED)
				{
					bOk = bOk && AddDBXMLIntTag("VOTERESPONSE",NULL,false);
				}

				// Check to see if we've got one of the post thread events. If so add the forumsource info
				if (iEventType == CEventQueue::ET_FORUMEDITED ||
					iEventType == CEventQueue::ET_POSTNEWTHREAD ||
					iEventType == CEventQueue::ET_POSTREPLIEDTO)
				{
					bOk = bOk && AddDBXMLTag("ITEMID3",NULL,false);
					bOk = bOk && AddDBXMLTag("ITEMTYPE3",NULL,false);
					bOk = bOk && AddDBXMLTag("ITEMNAME3",NULL,false);
				}

				bOk = bOk && OpenXMLTag("EVENTUSER");
				bOk = bOk && AddDBXMLIntTag("EVENTUSERID");
				bOk = bOk && AddDBXMLTag("EVENTUSERNAME");
				bOk = bOk && AddDBXMLTag("EVENTUSERFIRSTNAMES",NULL,false);
				bOk = bOk && AddDBXMLTag("EVENTUSERLASTNAME",NULL,false);
				bOk = bOk && AddDBXMLTag("EVENTUSERTITLE",NULL,false);
				bOk = bOk && AddDBXMLTag("EVENTUSERSITESUFFIX",NULL,false);
				bOk = bOk && CloseXMLTag("EVENTUSER");
				bOk = bOk && CloseXMLTag("ITEMEVENT");
				bAddedEvent = true;
			}

			// Get the next entry and update the SiteID and UserID variables
			SP.MoveNext();
			iLastSiteID = iSiteID;
			iLastUserID = iUserID;
			if (!SP.IsEOF())
			{
				iSiteID = SP.GetIntField("SiteID");
				iUserID = SP.GetIntField("UserID");
				iNotifyType = SP.GetIntField("NotifyType");
			}
		}

		// Close the mail and send it to the mail servers
		CloseXMLTag("EMAILALERT");

		// Check to see if we actually added anything to the email.
		if (bAddedEvent)
		{
			// Now set the NotifyType
			if (iCurrentNotifyType == 1)
			{
				NotifyType = CEmailAlertList::NT_EMAIL;
			}
			else if (iCurrentNotifyType == 2)
			{
				NotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
			}
			else
			{
				NotifyType = CEmailAlertList::NT_DISABLED;
			}

			// Now send the email and remove the events we have just covered
			if (!SendEMailAndDeleteEvents(sXML,sEMail,iLastUserID,iLastSiteID,UpdateType,NotifyType))
			{
				// Problems!
				return false;
			}

			// Put back the original XML string
			InitialiseXMLBuilder(&sXML,&SP);
		}

		// reset the site and user ids
		iLastSiteID = 0;
		iLastUserID = 0;
	}

	// Finaly close the xml errors
	InitialiseXMLBuilder(&m_sErrorXML);
	CloseXMLTag("EMAIL-ERRORS");

	// Update the email alerts stats table. First check to see if we actually sent something first. If not then don't update the table
	if (m_iFailedAlerts > 0 || m_iSentEMails > 0 || m_iSentPrivateMsgs > 0)
	{
		// Setup the storedprocedure and update the table
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.UpdateEmailAlertStats(m_iSentEMails,m_iSentPrivateMsgs,m_iFailedAlerts,iEMailType))
		{
			// Problems!
			SetDNALastError("CEMailQueueGenerator::CreateEMailQueue","FailedToUpdateTheStats","Failed to update the email alert stats!!!");
		}
	}

	// if we here, everything went ok!
	return true;
}

/*********************************************************************************

	bool CEMailQueueGenerator::SendEMailAndDeleteEvents(CTDVString& sXML, CTDVString& sEMail, int iUserID, int iSiteID, eEMailUpdateType EMailType, CEmailAlertList::eNotifyType NotifyType)

		Author:		Mark Howitt
        Created:	25/08/2004
        Inputs:		sXML - The XML that forms the email body.
					sEMail  - The EMail address to send the mail to.
					iUserID - The ID of the user.
					iSiteID - The ID of the site.
					EMailType - The Type of email to delete.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Send an email to the given user and then removes the events processed to make the email.

*********************************************************************************/
bool CEMailQueueGenerator::SendEMailAndDeleteEvents(CTDVString& sXML, CTDVString& sEMail, int iUserID, int iSiteID, eEMailUpdateType EMailType, CEmailAlertList::eNotifyType NotifyType)
{
	// Check to make sure the users email is valid
	// Setup the error xml
	InitialiseXMLBuilder(&m_sErrorXML);
	CTDVString sError;
	bool bVerified = true;
	//CUser ThisUser(m_InputContext);
	//if (!ThisUser.CreateFromID(iUserID) || !ThisUser.IsUsersEMailVerified(bVerified))
	//{
	//	// Problems!
	//	sError << "Failed To Get Users Details For U" << iUserID << " On Site " << iSiteID;
	//	AddXMLTag("ERROR",sError);
	//	TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
	//	return true;
	//}

	// Check the status
	if (!bVerified || sEMail.IsEmpty() || NotifyType == CEmailAlertList::NT_DISABLED)
	{
		// Check to see if we failed validation. If so, report the error. We don't care about disabled items, just remove them.
		if (!bVerified || sEMail.IsEmpty())
		{
			// Users email not valid!
			sError << "Users EMail Not Valid For U" << iUserID << " On Site " << iSiteID;
			AddXMLTag("ERROR",sError);
			TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
		}

		// Finally remove the email events for the user
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.DeleteEMailEventsForUserAndSite(iUserID,iSiteID,EMailType,(int)NotifyType))
		{
			sError << "Failed To Remove the Events For U" << iUserID << " On Site " << iSiteID;
			AddXMLTag("ERROR",sError);
			TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
			return true;
		}
		return true;
	}

	// Transform the XML into HTML for the email.
	if (!CreateFromXMLText(sXML,NULL,true))
	{
		// Problems!
		sError << "Failed To create EMAil XML For U" << iUserID << " On Site " << iSiteID;
		AddXMLTag("ERROR",sError);
		TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
		return true;
	}

	// Now get the correct Style Sheet for the site.
	// Start with the home directory
	CTDVString sSiteName, sStyleSheetName;
	if (!m_InputContext.GetStylesheetHomePath(sStyleSheetName))
	{
		// Problems!
		sError << "Failed To Get XSLT File Home Path For Site " << iSiteID;
		AddXMLTag("ERROR",sError);
		TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
		return true;
	}
	sStyleSheetName << "\\Skins\\";

	// Now the site name
	m_InputContext.GetNameOfSite(iSiteID,&sSiteName);

	// Get the correct file for the type of notification we're about to do
	CTDVString sXSLTFileName;
	if (NotifyType == CEmailAlertList::NT_EMAIL)
	{
		sXSLTFileName = "AlertEMail.xsl";
	}
	else if (NotifyType == CEmailAlertList::NT_PRIVATEMESSAGE)
	{
		sXSLTFileName = "PrivateAlertMessage.xsl";
	}

	// Check to see if we have an overriding file
	FILE* fp;
	fp = fopen(sStyleSheetName + sSiteName + "\\" + sXSLTFileName, "r");
	if (fp == NULL)
	{
		// No! Use the base xsl file
		sStyleSheetName << sXSLTFileName;
		fp = fopen(sStyleSheetName, "r");
		if (fp == NULL)
		{
			// Problems!!! We can't find a valid xslt file to do the email transform with!
			sError << "Failed To Find the XSLT File For Site " << iSiteID;
			AddXMLTag("ERROR",sError);
			TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
			return true;
		}
		fclose(fp);
	}
	else
	{
		// Yes! close the file and set the style sheet name
		fclose(fp);
		sStyleSheetName << sSiteName << "\\" << sXSLTFileName;
	}

	// Now Transform the XMLObject into the HTML
	CXSLT XSLT;
	CTDVString sHTML;
	if (!XSLT.ApplyCachedTransform(sStyleSheetName,this,sHTML))
	{
		// Problems!
		CTDVString sError;
		int iError = XSLT.GetLastError(sError);
		if (iError == CXSLT::XSLT_DOCLOAD_ERROR)
		{
			TDVASSERT(false,"XSLT_DOCLOAD_ERROR - " + sError);
		}
		else if (iError == CXSLT::XSLT_XMLDOC_ERROR)
		{
			TDVASSERT(false,"XSLT_XMLDOC_ERROR - " + sError);
		}
		else if (iError == CXSLT::XSLT_XMLLOAD_ERROR)
		{
			TDVASSERT(false,"XSLT_XMLLOAD_ERROR - " + sError);
		}
		else
		{
			TDVASSERT(false,"XSLT Error - " + sError);
		}

		sError << "Error in XSLT File For Site " << iSiteID;
		AddXMLTag("ERROR",sError);
		TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
		return true;
	}

	// Check to see what method of notification we want to use!
	bool bSentOk = true;
	if (NotifyType == CEmailAlertList::NT_EMAIL)
	{
		// Setup the connection to the email server
		CTDVString sEditorsEmail;
		CTDVString sSiteShortName;
		CTDVString sEMailSubject = "EMail Alert";
		m_InputContext.GetEmail(EMAIL_EDITORS, sEditorsEmail,iSiteID);
		m_InputContext.GetShortName(sSiteShortName,iSiteID);
		m_InputContext.GetSitesEMailAlertSubject(iSiteID,sEMailSubject);

		// Now send the message!
		bSentOk = m_InputContext.SendMail(sEMail,sEMailSubject,sHTML,sEditorsEmail,sSiteShortName);
		if (bSentOk)
		{
			// Update the number of sent emails
			m_iSentEMails++;
		}
	}
	else if (NotifyType == CEmailAlertList::NT_PRIVATEMESSAGE)
	{
		// Setup the Subject
		CTDVString sSubject;
		if (EMailType == EUT_NORMAL)
		{
			sSubject = "Daily Alert Message";
		}
		else
		{
			sSubject = "Instant Alert Message";
		}

		// Create the procedure that sends the private message
		int iAutoUserID = 0;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		bSentOk = bSentOk && SP.PostPrivateAlertMessage(iUserID,iSiteID,sSubject,sHTML);
		if (bSentOk)
		{
			// Update the number of sent Private Messages
			m_iSentPrivateMsgs++;
		}
	}

	// Check to see if everything went ok
	if (bSentOk)
	{
		// Get the correct listtype to remove the mails from
		int iEmailType = (int)CEmailAlertList::LT_EMAILALERT;
		if (EMailType == EUT_NORMAL)
		{
			iEmailType = (int)CEmailAlertList::LT_EMAILALERT;
		}
		else
		{
			iEmailType = (int)CEmailAlertList::LT_INSTANTEMAILALERT;
		}

		// Finally remove the email events for the user
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.DeleteEMailEventsForUserAndSite(iUserID,iSiteID,iEmailType,(int)NotifyType))
		{
			sError << "Failed To Remove the Events For U" << iUserID << " On Site " << iSiteID;
			AddXMLTag("ERROR",sError);
			TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);
			return true;
		}
	}
	else
	{
		// Put a tag in the error xml to say we failed to send the email!
		sError << "Failed To Send EMail For U" << iUserID << " On Site " << iSiteID;
		AddXMLTag("ERROR",sError);
		TDVASSERT(false,"CEMailQueueGenerator::SendEMailAndDeleteEvents - " + sError);

		// Increament the number of fails emails
		m_iFailedAlerts++;
	}

	return true;
}

/*********************************************************************************

	bool CEMailQueueGenerator::GetCurrentWorkingStatus(int iInstantTimeRange, int iNormalTimeRange)

		Author:		Mark Howitt
        Created:	30/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Checks the state of the emaileventqueue to see if there are
					any emails that are over dues. This could mean there is a user
					with invalid email, no email, mail server connection problems or
					something a bit more sinister!
					This function is called from the EMailAlertBuilder as a monitoring
					system.

*********************************************************************************/
bool CEMailQueueGenerator::GetCurrentWorkingStatus(int iInstantTimeRange, int iNormalTimeRange)
{
	// Setup the error string and stored procedure.
	m_sErrorXML.Empty();
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	InitialiseXMLBuilder(&m_sErrorXML,&SP);

	// Call the procedure
	if (!SP.CheckEMailAlertStatus(iInstantTimeRange, iNormalTimeRange))
	{
		// Problems!!!
		return SetDNALastError("CEMailQueueGenerator::GetCurrentWorkingStatus","CheckEmailAlertStatusFailed","Failed while checking EMail Alert Status!!!");
	}

	// Open the XML Tag and fill in the data
	int iCount = 0;
	bool bOk = OpenXMLTag("EMAIL-STATUS");
	bOk = bOk && AddDBXMLIntTag("OverDueEmails","OverDue-Emails",true,&iCount);
	if (iCount > 0)
	{
		AddXMLTag("STATUS","ERROR");
	}
	else
	{
		AddXMLTag("STATUS","OK");
	}
	bOk = bOk && CloseXMLTag("EMAIL-STATUS");

	// Check to make sure everything went ok
	if (!bOk)
	{
		// Problems creating the XML!!!
		return SetDNALastError("CEMailQueueGenerator::GetCurrentWorkingStatus","FailedToCreateXML","Failed to create the XML!!!");
	}
	return bOk;
}
