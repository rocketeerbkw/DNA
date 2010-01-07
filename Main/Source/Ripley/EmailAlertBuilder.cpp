#include "stdafx.h"
#include ".\emailalertbuilder.h"
#include ".\emailalertlist.h"
#include ".\tdvassert.h"
#include ".\EMailQueueGenerator.h"
#include ".\EventQueue.h"
#include "User.h"

CEmailAlertBuilder::CEmailAlertBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext),
m_iUserID(0), m_iSiteID(0), m_pWholePage(NULL), m_EMailAlert(m_InputContext), m_ListType(CEmailAlertList::LT_EMAILALERT), m_NotifyType(CEmailAlertList::NT_PRIVATEMESSAGE)
{
}

CEmailAlertBuilder::~CEmailAlertBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CEmailAlertBuilder::Build(void)

		Author:		Mark Howitt
        Created:	12/08/2004
        Inputs:		-
        Outputs:	-
        Returns:	The page for the email alert builder.
        Purpose:	This is the admin/view page for the email alert page

*********************************************************************************/
bool CEmailAlertBuilder::Build(CWholePage* pPage)
{
	m_pWholePage = pPage;
	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(m_pWholePage, "EMAILALERTPAGE",false,true);
	if (!bPageOk)
	{
		TDVASSERT(false,"EMailAlertBuilder - Failed to create Whole Page object!");
		return false;
	}

	// URL driven email status. Monitoring functionality!
	if (m_InputContext.ParamExists("CheckStatus"))
	{
		// Call the send email function
		CheckStatus();
		return true;
	}

	// Check to see if we've been asked to disable a users email alerts
	if (m_InputContext.ParamExists("disablealerts"))
	{
		// Call the disable alerts function
		return DisableUserAlerts();
	}

	// Check to make sure we have a logged in user or editor
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		// We need a userid!
		SetDNALastError("CEmailAlertBuilder::Build","UserNotLoggedIn","User Not Logged In");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}

	// URL driven email send process. Only for superusers!
	if (m_InputContext.ParamExists("SendEmail") && pUser->GetIsSuperuser())
	{
		// Call the send email function
		SendEmails();
		return true;
	}

	// URL driven email send process. Only for superusers!
	if (m_InputContext.ParamExists("EmailStats") && pUser->GetIsEditor())
	{
		// See if we want the stats for all sites?
		int iSiteID = m_InputContext.GetSiteID();
		if (m_InputContext.ParamExists("allsites"))
		{
			// Set it to 0 for all sites stats
			iSiteID = 0;
		}

		// Call the Get Stats function
		if (m_EMailAlert.GetEmailStats(iSiteID))
		{
			// Insert the object into the XML
			return pPage->AddInside("H2G2",&m_EMailAlert);
		}
		else
		{
			// Put the error into the page and return
			return pPage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
		}
	}

	// Get the UserID From the input
	m_iUserID = m_InputContext.GetParamInt("userid");
	if (m_iUserID == 0)
	{
		// Get the UserID from the User object
		m_iUserID = pUser->GetUserID();
	}

	// Get the editor status, and check to make sure the current user matches the input or they are an editor!
	bool bIsEditor = pUser->GetIsEditor();
	if (!bIsEditor && pUser->GetUserID() != m_iUserID)
	{
		SetDNALastError("CEmailAlertBuilder::Build","UserNotAuthorised","User Is Not Authorised");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}

	// Get the current site id
	m_iSiteID = m_InputContext.GetSiteID();

	// Check to see what opperation we're doing
	CTDVString sCmd,sGUID;
	if (m_InputContext.GetParamString("cmd",sCmd))
	{
		// Get the type of list we're trying to deal with
		CTDVString sType;
		m_InputContext.GetParamString("ListType",sType);
		if (sType.CompareText("normal"))
		{
			m_ListType = CEmailAlertList::LT_EMAILALERT;
		}
		else if (sType.CompareText("instant"))
		{
			m_ListType = CEmailAlertList::LT_INSTANTEMAILALERT;
		}
		else
		{
			// No valid m_ListType given!!
			SetDNALastError("CEmailAlertBuilder::Build","InvalidListTypeGiven","Invalid Email List Type Given");
			m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}

		// Get the notification method from the URL if present. Default to Email Alert
		CTDVString sNotifyType;
		m_InputContext.GetParamString("notifytype",sNotifyType);
		// Now set the member variable
		if (sNotifyType.CompareText("email"))
		{
			m_NotifyType = CEmailAlertList::NT_EMAIL;
		}
		else if (sNotifyType.CompareText("privatemessage"))
		{
			m_NotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
		}
		else
		{
			// No valid Notification Type given!!
			SetDNALastError("CEmailAlertBuilder::Build","InvalidNotificationTypeGiven","Invalid Notification Type Given");
			m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}

		// Check what command we want to do!
		if (sCmd.CompareText("create"))
		{
			// Call the create function and check for errors
			if (CreateEMailList())
			{
				m_pWholePage->AddInside("H2G2",&m_EMailAlert);
			}
			else
			{
				// Problems!!! Get the last Error and return the page!
				m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
			}
		}
		else if (sCmd.CompareText("add"))
		{
			// Check to see what we are trying to add!
			bool bAddedOk = true;
			CTDVString sItemType;
			m_InputContext.GetParamString("itemtype",sItemType);

			// Now get the Items ID
			int iItemID = m_InputContext.GetParamInt("itemid");
			if (sItemType.CompareText("node"))
			{
				// Get the nodeid value
				bAddedOk = AddCategoryToEmailList(iItemID);
			}
			else if (sItemType.CompareText("h2g2"))
			{
				// Get the h2g2id value
				bAddedOk = AddArticleToEMailList(iItemID);
			}
			else if (sItemType.CompareText("forum"))
			{
				// Get the Forum ID value
				bAddedOk = AddForumToEmailList(iItemID);
			}
			else if (sItemType.CompareText("club"))
			{
				// Get the Club ID value
				bAddedOk = AddClubToEMailList(iItemID);
			}
			else if (sItemType.CompareText("post"))
			{
				// Get the Post ID value
				bAddedOk = AddPostToEMailList(iItemID);
			}
			else if (sItemType.CompareText("thread"))
			{
				// Get the Thread ID value
				bAddedOk = AddThreadToEMailList(iItemID);
			}
			else
			{
				// No valid m_ListType given!!
				SetDNALastError("CEmailAlertBuilder::Build","InvalidAddItemTypeGiven","Invalid Add Item Type Given");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			}

			// Check to see if everything went ok
			if (bAddedOk)
			{
				m_pWholePage->AddInside("H2G2",&m_EMailAlert);
			}
			else
			{
				// Problems!!! Get the last Error and return the page!
				m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
			}
		}
		else if (sCmd.CompareText("remove"))
		{
			// Check to see what we are trying to add!
			bool bRemovedOk = true;
			if (m_InputContext.ParamExists("memberid"))
			{
				// Get the Member Id form the URL
				int iMemberID = m_InputContext.GetParamInt("memberid");

				// Check which list to remove the item from
				if (m_ListType == CEmailAlertList::LT_EMAILALERT)
				{
					// Try to remove the Article from the Email list
					bRemovedOk = m_EMailAlert.RemoveItemFromNormalEmailList(iMemberID,m_iUserID,m_iSiteID);
				}
				else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
				{
					// Try to remove the Article from the instant email list
					bRemovedOk = m_EMailAlert.RemoveItemFromInstantEmailList(iMemberID,m_iUserID,m_iSiteID);
				}
			}
			else
			{
				// No valid m_ListType given!!
				SetDNALastError("CEmailAlertBuilder::Build","InvalidRemoveItemTypeGiven","Invalid Remove Item Type Given");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			}

			// Check to see if everything went ok
			if (bRemovedOk)
			{
				m_pWholePage->AddInside("H2G2",&m_EMailAlert);
			}
			else
			{
				// Problems!!! Get the last Error and return the page!
				m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
			}
		}
		else if (sCmd.CompareText("setnotifytype") && m_InputContext.ParamExists("memberid"))
		{
			// Get the Member Id form the URL
			int iMemberID = m_InputContext.GetParamInt("memberid");

			// Set the type for the normal email item.
			if (m_EMailAlert.ChangeItemsNotificationType(m_ListType,iMemberID,m_iUserID,m_iSiteID,m_NotifyType))
			{
				m_pWholePage->AddInside("H2G2",&m_EMailAlert);
			}
			else
			{
				// Problems!!! Get the last Error and return the page!
				m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
			}
		}
		else if (sCmd.CompareText("changeitemlisttype") && m_InputContext.ParamExists("memberid"))
		{
			// Get the Member Id form the URL
			int iMemberID = m_InputContext.GetParamInt("memberid");
			
			// Now get the new list the item should belong to
			CEmailAlertList::eEMailListType NewList = CEmailAlertList::LT_EMAILALERT;
			CTDVString sNewListType;
			m_InputContext.GetParamString("newlist",sNewListType);

			// Make sure it's either normal or instant!
			if (sNewListType.CompareText("normal"))
			{
				NewList = CEmailAlertList::LT_EMAILALERT;
			}
			else if (sNewListType.CompareText("instant"))
			{
				NewList = CEmailAlertList::LT_INSTANTEMAILALERT;
			}

			// Change the list type
			ChangeItemListType(iMemberID,NewList);
		}
		else if (sCmd.CompareText("UpdateAlert") && m_InputContext.ParamExists("memberid"))
		{
			// Get the Member Id form the URL
			int iMemberID = m_InputContext.GetParamInt("memberid");

			// See if we're changing the list type
			if (m_InputContext.ParamExists("newlist"))
			{
				// Now get the new list the item should belong to
				CEmailAlertList::eEMailListType NewList = CEmailAlertList::LT_EMAILALERT;
				CTDVString sNewListType;
				m_InputContext.GetParamString("newlist",sNewListType);

				// Make sure it's either normal or instant!
				if (sNewListType.CompareText("normal"))
				{
					NewList = CEmailAlertList::LT_EMAILALERT;
				}
				else if (sNewListType.CompareText("instant"))
				{
					NewList = CEmailAlertList::LT_INSTANTEMAILALERT;
				}

				// Change the list type
				ChangeItemListType(iMemberID,NewList);
				m_ListType = NewList;
			}

			// Get the new notification type if any
			if (m_InputContext.ParamExists("newnotifytype"))
			{
				// Get the notification method from the URL if present. Default to Email Alert
				CTDVString sNotifyType;
				CEmailAlertList::eNotifyType NewNotifyType = CEmailAlertList::NT_EMAIL;
				if (m_InputContext.GetParamString("newnotifytype",sNotifyType))
				{
					// Now set the member variable
					if (sNotifyType.CompareText("email"))
					{
						NewNotifyType = CEmailAlertList::NT_EMAIL;
					}
					else if (sNotifyType.CompareText("private"))
					{
						NewNotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
					}
				}

				// Set the type for the normal email item.
				if (m_EMailAlert.ChangeItemsNotificationType(m_ListType,iMemberID,m_iUserID,m_iSiteID,NewNotifyType))
				{
					m_pWholePage->AddInside("H2G2",&m_EMailAlert);
				}
				else
				{
					// Problems!!! Get the last Error and return the page!
					m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
				}
			}
		}
	}

	// Get the users current EMail list
	m_pWholePage->AddInside("H2G2","<EMAILALERTLISTS></EMAILALERTLISTS>");
	if (!m_EMailAlert.GetEmailListForUser(CEmailAlertList::LT_EMAILALERT,m_iUserID,m_iSiteID,sGUID,bIsEditor))
	{
		// Problems!
		m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
	}
	else
	{
		// Insert the object into the page
		m_pWholePage->AddInside("EMAILALERTLISTS",&m_EMailAlert);
	}

	// Now Get the users current Instant EMail list
	if (!m_EMailAlert.GetEmailListForUser(CEmailAlertList::LT_INSTANTEMAILALERT,m_iUserID,m_iSiteID,sGUID,bIsEditor))
	{
		// Problems!
		m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
	}
	else
	{
		// Insert the object into the page
		m_pWholePage->AddInside("EMAILALERTLISTS",&m_EMailAlert);
	}

	// Return the page
	return true;
}

/*********************************************************************************

	void CEmailAlertBuilder::SendEmails()

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Sends the emails from the event queue.

*********************************************************************************/
void CEmailAlertBuilder::SendEmails()
{
	// Check the page pointer
	if (m_pWholePage->IsEmpty())
	{
		TDVASSERT(false,"CEmailAlertBuilder::SendEmails - NULL Page pointer given!!!");
		return;
	}

	// Create the EMailQueueGenerator object
	CEMailQueueGenerator EMQG(m_InputContext);

	// Get the type of update we are wanting to do!
	bool bSentOk = true;
	CTDVString sError;
	CEMailQueueGenerator::eEMailUpdateType UpdateType = CEMailQueueGenerator::EUT_NORMAL;
	CTDVString sUpdateType;
	m_InputContext.GetParamString("UpdateType",sUpdateType);
	if (sUpdateType.CompareText("normal"))
	{
		UpdateType = CEMailQueueGenerator::EUT_NORMAL;
	}
	else if (sUpdateType.CompareText("instant"))
	{
		UpdateType = CEMailQueueGenerator::EUT_INSTANT;
	}
	else
	{
		// Incorrect update type
		sError = "Invalid Update Type Given";
		bSentOk = false;
	}

	// Call the update function
	if (bSentOk && !EMQG.UpdateAndSendEMailAlerts(UpdateType))
	{
		m_pWholePage->AddInside("H2G2",EMQG.GetLastErrorAsXMLString());
		bSentOk = false;
	}

	// Create some result xml
	CTDVString sXML;
	CDBXMLBuilder DBXML;
	DBXML.Initialise(&sXML);
	DBXML.OpenTag("EMAILALERTGENERATOR");
	DBXML.OpenTag("SENDEMAILS");
	if (bSentOk)
	{
		DBXML.AddIntTag("SENT-EMAILS",EMQG.GetNumberOfSentEmails());
		DBXML.AddIntTag("SENT-PRIVATEMSGS",EMQG.GetNumberOfSentPrivateMessages());
		DBXML.AddIntTag("FAILED-EMAILS",EMQG.GetNumberOfFailedEmails());
	}
	else
	{
		DBXML.AddTag("RESULT",sError);
	}
	DBXML.AddTag("UPDATE-TYPE",sUpdateType);
	sXML << EMQG.GetMinorErrorsXML();
	DBXML.CloseTag("SENDEMAILS");
	DBXML.CloseTag("EMAILALERTGENERATOR");

	// Add the xml and return
	m_pWholePage->AddInside("H2G2",sXML);
	return;
}

/*********************************************************************************

	void CEmailAlertBuilder::CheckStatus(void)

		Author:		Mark Howitt
        Created:	30/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Calls the stored procedure that checks the emaileventqueue
					for overdue emails

*********************************************************************************/
void CEmailAlertBuilder::CheckStatus(void)
{
	// Check the page pointer
	if (m_pWholePage == NULL)
	{
		TDVASSERT(false,"CEmailAlertBuilder::SendEmails - NULL Page pointer given!!!");
		return;
	}

	// Get the instant and normal values from the URL
	int iInstantTimeRange = 30;
	if (m_InputContext.ParamExists("InstantLimit"))
	{
		// Get the value
		iInstantTimeRange = m_InputContext.GetParamInt("InstantLimit");
	}
	
	int iNormalTimeRange = 36;
	if (m_InputContext.ParamExists("NormalLimit"))
	{
		// Get the value
		iInstantTimeRange = m_InputContext.GetParamInt("NormalLimit");
	}

	// Create the EMailQueueGenerator object
	CEMailQueueGenerator EMQG(m_InputContext);

	// Call the status function to see if we're working ok  or not
	if (!EMQG.GetCurrentWorkingStatus(iInstantTimeRange, iNormalTimeRange))
	{
		// We've had a problem. Put the error into the Page
		m_pWholePage->AddInside("H2G2",EMQG.GetLastErrorAsXMLString());
	}

	// Set up the XML builder
	CTDVString sXML;
	CDBXMLBuilder DBXML;
	DBXML.Initialise(&sXML);
	DBXML.OpenTag("EMAILALERTGENERATOR");
	DBXML.AddIntTag("INSTANT-TIME-RANGE",iInstantTimeRange);
	DBXML.AddIntTag("NORMAL-TIME-RANGE",iNormalTimeRange);
	sXML << EMQG.GetMinorErrorsXML();
	DBXML.CloseTag("EMAILALERTGENERATOR");

	// Add the xml and return
	m_pWholePage->AddInside("H2G2",sXML);
	return;
}

/*********************************************************************************

	bool CEmailAlertBuilder::DisableUserAlerts()

		Author:		Mark Howitt
		Created:	10/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Disables a users Alerts, even if they are not logged in.
					This works by using the unique GUID for the users list.

					This function can be called without the user being logged in as the
					GUID acts as the unique key for the list.
					The worst it does is to disable the alerts, not delete or remove.

*********************************************************************************/
bool CEmailAlertBuilder::DisableUserAlerts()
{
	// Get the userid and the guid from the input.
	CTDVString sGUID;
	int iUserID = m_InputContext.GetParamInt("UserID");
	if (!m_InputContext.GetParamString("GUID",sGUID) || iUserID == 0)
	{
		// Ok, We either did't get the userid or the GUID. Report the error.
		SetDNALastError("CEmailAlertBuilder::DisableUserAlerts","FailedToDisableUserAlerts","Failed to disable user alerts!!!");
		return m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	// Create an EmailAlert object and call the disable alerts
	CEmailAlertList Alert(m_InputContext);
	if (!Alert.DisableUserAlerts(iUserID,sGUID))
	{
		// Report the error
		return m_pWholePage->AddInside("H2G2",Alert.GetLastErrorAsXMLString());
	}

	// Insert the result into the XML Page
	return m_pWholePage->AddInside("H2G2",&Alert);
}

/*********************************************************************************

	bool CEmailAlertBuilder::CreateEMailList()

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates a new list of the given type for the userid and siteid

*********************************************************************************/
bool CEmailAlertBuilder::CreateEMailList()
{
	// Check to see if the user already has an email alert list! They can only have the one!
	// Safe to create the new list
	// Check to see what type of list they want? Normal or instant?
	bool bCreatedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to create a normal email list for the user
		bCreatedOk = m_EMailAlert.CreateNormalEMailAlertList(m_iUserID,m_iSiteID);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to create an instant email list for the user
		bCreatedOk = m_EMailAlert.CreateInstantEMailAlertList(m_iUserID,m_iSiteID);
	}

	// return the verdict
	return bCreatedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::AddCategoryToEmailList(int iNodeID)

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		iNodeID - The ID of the category you want to add to the list
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Adds the given node to either the email list or instant email list

*********************************************************************************/
bool CEmailAlertBuilder::AddCategoryToEmailList(int iNodeID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the node to the EMail list
		bAddedOk = m_EMailAlert.AddCategoryToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,iNodeID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the Node to the instant email list
		bAddedOk = m_EMailAlert.AddCategoryToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,iNodeID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::AddArticleToEMailList(int ih2g2ID)

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		ih2g2ID - The ID of the article you want to add to the list
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Adds the given node to either the email list or instant email list

*********************************************************************************/
bool CEmailAlertBuilder::AddArticleToEMailList(int ih2g2ID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the Article to the EMail list
		bAddedOk = m_EMailAlert.AddArticleToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,ih2g2ID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the Article to the instant email list
		bAddedOk = m_EMailAlert.AddArticleToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,ih2g2ID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;

}

/*********************************************************************************

	bool CEmailAlertBuilder::AddForumToEmailList(int iForumID)

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		iForumID - The ID of the forum you want to add to the list
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Adds the given node to either the email list or instant email list

*********************************************************************************/
bool CEmailAlertBuilder::AddForumToEmailList(int iForumID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the Forum to the EMail list
		bAddedOk = m_EMailAlert.AddForumToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,iForumID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the Forum to the instant email list
		bAddedOk = m_EMailAlert.AddForumToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,iForumID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::AddClubToEMailList(int iClubID)

		Author:		Mark Howitt
        Created:	18/10/2004
        Inputs:		iClubID - The ID for the given club that you want add to the email list.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the the club that you want to watch for.

*********************************************************************************/
bool CEmailAlertBuilder::AddClubToEMailList(int iClubID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the Club to the EMail list
		bAddedOk = m_EMailAlert.AddClubToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,iClubID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the Club to the instant email list
		bAddedOk = m_EMailAlert.AddClubToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,iClubID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::AddPostToEMailList(int iPostID)

		Author:		Mark Howitt
        Created:	18/10/2004
        Inputs:		iPostID - The ID for the given post that you want add to the email list.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the the post that you want to watch for replies.

*********************************************************************************/
bool CEmailAlertBuilder::AddPostToEMailList(int iPostID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the post to the EMail list
		bAddedOk = m_EMailAlert.AddPostToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,iPostID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the post to the instant email list
		bAddedOk = m_EMailAlert.AddPostToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,iPostID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::AddThreadToEMailList(int iThreadID)

		Author:		Mark Howitt
        Created:	18/10/2004
        Inputs:		iThreadID - The ID for the given thread that you want add to the email list.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the the post that you want to watch for replies.

*********************************************************************************/
bool CEmailAlertBuilder::AddThreadToEMailList(int iThreadID)
{
	// Check to see what type of list they want? Normal or instant?
	bool bAddedOk = false;
	if (m_ListType == CEmailAlertList::LT_EMAILALERT)
	{
		// Try to add the post to the EMail list
		bAddedOk = m_EMailAlert.AddThreadToUsersNormalEmailAlertList(m_iUserID,m_iSiteID,iThreadID,m_NotifyType,true);
	}
	else if (m_ListType == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Try to add the post to the instant email list
		bAddedOk = m_EMailAlert.AddThreadToUsersInstantEmailAlertList(m_iUserID,m_iSiteID,iThreadID,m_NotifyType,true);
	}

	// Return the verdict
	return bAddedOk;
}

/*********************************************************************************

	bool CEmailAlertBuilder::ChangeItemListType(int iMemberID, CEmailAlertList::eEMailListType NewListTYpe)

		Author:		Mark Howitt
        Created:	25/05/2005
        Inputs:		iMemberID - The id of the member in the list to change.
					NewListType - the new type of list the member should be changed to.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Changes the frequency for a given alert member

*********************************************************************************/
bool CEmailAlertBuilder::ChangeItemListType(int iMemberID, CEmailAlertList::eEMailListType NewListTYpe)
{
	// Only do changes for instant and normal email lists
	if (NewListTYpe == CEmailAlertList::LT_EMAILALERT || NewListTYpe == CEmailAlertList::LT_INSTANTEMAILALERT)
	{
		// Now change the type of list for the item
		if (m_EMailAlert.ChangeItemMembersListType(m_iUserID,m_iSiteID,iMemberID,m_ListType,NewListTYpe))
		{
			// Insert the result into the page
			m_pWholePage->AddInside("H2G2",&m_EMailAlert);
		}
		else
		{
			// Problems!!! Get the last Error and return the page!
			m_pWholePage->AddInside("H2G2",m_EMailAlert.GetLastErrorAsXMLString());
		}
	}
	else
	{
		// Problems!!! Don't know what type of list type we want!
		SetDNALastError("","InvalidListTypeGiven","Invalid List Type Given!");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	return true;
}

