#include "stdafx.h"
#include "tdvassert.h"
#include ".\moderatenicknamesbuilder.h"
#include "moderatenicknames.h"
#include "user.h"
#include "emailtemplate.h"
#include "SiteData.h"	//Definition of EMAIL_MODERATORS
#include "userstatuses.h"
#include "moderationclasses.h"

CModerateNickNamesBuilder::CModerateNickNamesBuilder( CInputContext& InputContext) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

CModerateNickNamesBuilder::~CModerateNickNamesBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CModerateNickNames()

	Author:		Martin Robb
	Created:	25/11/2005
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate nicknames

*********************************************************************************/

bool CModerateNickNamesBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "NICKNAME-MODERATION", true);
	bool bSuccess = true;
	
	CUser* pViewer = NULL;
	pViewer = m_InputContext.GetCurrentUser();
	

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator() || pViewer->IsUserInGroup("HOST")) )
	{
		bSuccess = bSuccess && pPage->SetPageType("ERROR");
		bSuccess = bSuccess && pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
		return bSuccess;
	}

	// first process any submission that may have been made
	bSuccess = bSuccess && ProcessSubmission(pViewer,pPage);

	//Handle 'Oldstyle' redirect - necessary to handle multiple submit buttons for the same form.
	if ( m_InputContext.ParamExists("Done") )
	{
		CTDVString sRedirect = "Moderate?newstyle=1";
		if ( m_InputContext.GetParamInt("fastmod") == 1 )
			sRedirect += "&fastmod=1";
		return pPage->Redirect(sRedirect);
	}

	//Add Site List
	CTDVString sSiteXML;
	bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
	bSuccess = bSuccess && pPage->AddInside("H2G2", sSiteXML);

	//Add Moderation Classes
	CModerationClasses modclasses(m_InputContext);
	if ( modclasses.GetModerationClasses() )
		bSuccess = bSuccess && pPage->AddInside("H2G2",&modclasses);
	else if ( modclasses.ErrorReported() )
		bSuccess && bSuccess && pPage->AddInside("H2G2",modclasses.GetLastErrorAsXMLString() );

	//Add User Status'
	CUserStatuses userstatus(m_InputContext);
	if ( userstatus.GetUserStatuses() )
		bSuccess = bSuccess && pPage->AddInside("H2G2",&userstatus);
	else if ( userstatus.ErrorReported() )
		pPage->AddInside("H2G2",userstatus.GetLastErrorAsXMLString() );

	bool bHeldItems = m_InputContext.GetParamInt("helditems") == 1;
	bool bAlerts = m_InputContext.GetParamInt("alerts") == 1;
	bool bLockedItems = m_InputContext.GetParamInt("locked") == 1;

	int iShow = 10;
	if ( m_InputContext.ParamExists("show") )
		iShow = m_InputContext.GetParamInt("show");

	//Filter on Mod Class of site of users masthead.
	int iModClassId = 0;
	if ( m_InputContext.ParamExists("modclassid") )
		iModClassId = m_InputContext.GetParamInt("modclassid");
		
	CModerateNickNames nicknames(m_InputContext);
	if ( nicknames.GetNickNames( pViewer->GetUserID(), bAlerts, bHeldItems, bLockedItems, iModClassId, iShow) )
		pPage->AddInside("H2G2",&nicknames);
	else
		pPage->AddInside("H2G2", nicknames.GetLastErrorAsXMLString());
			
	
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CNickNameModerationPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CNickNameModerationPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CModerateNickNamesBuilder::ProcessSubmission( CUser* pViewer, CWholePage* pPage )
{
	bool	bSuccess = true;
	bool	bEmailSentOK = false;
	// if the command involves a submission then proceed
	CTDVString	sOldNickname;
	CTDVString	sUserID;
	CTDVString	sUsersEmail;
	int			iNumberOfNicknames = 0;
	int			iUserID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			i = 0; 
	int			iUsersSiteID = 0;

	
	CModerateNickNames NickNames(m_InputContext);
	iNumberOfNicknames = m_InputContext.GetParamCount("ModID");
	int iProcessed = 0;
	for ( int i = 0; i < iNumberOfNicknames; ++i )
	{
		// get the UserID and corresponding decision
		iUsersSiteID = m_InputContext.GetParamInt("SiteID", i);
		iUserID = m_InputContext.GetParamInt("UserID", i);
		iModID = m_InputContext.GetParamInt("ModID", i);
		if (!m_InputContext.GetParamString("UserName", sOldNickname, i))
		{
			sOldNickname = "Unknown";
		}

		int iStatus = m_InputContext.GetParamInt("Status", i);
		if ( !NickNames.Update(iModID, iStatus, sUsersEmail ) )
			pPage->AddInside( "H2G2",NickNames.GetLastErrorAsXMLString() );
		else
			iProcessed++;
		
		// if nickname was failed and reset then inform the user
		if (iStatus == 4)
		{
			if ( !SendMailOrSystemMessage(iUserID, sOldNickname, sUsersEmail, iUsersSiteID) )
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	//Create some Feedback XML.
	CTDVString sXML;
	sXML << "<FEEDBACK PROCESSED='" << iProcessed << "'/>";
	pPage->AddInside("H2G2",sXML); 
	return bSuccess;
}

bool CModerateNickNamesBuilder::SendEmail( int iUserID, CTDVString sOldNickname, CTDVString sUsersEmail )
{
	CTDVString	sEmailSubject;
	CTDVString	sEmailText;

	// first get the overall email template
	int iThisSiteID = m_InputContext.GetSiteID();
	CEmailTemplate email(m_InputContext);
	if ( !email.FetchEmailText(iThisSiteID, "NicknameResetEmail", sEmailSubject, sEmailText) )
	{
		CTDVString sErr = "Unable to fetch email text for site ";
		sErr << iThisSiteID;
		SetDNALastError("CModerateNicknamesBuilder::SendEmail","SendEmail",sErr);
		return false;
	}
	CXMLObject::UnEscapeXMLText(&sEmailSubject);
	CXMLObject::UnEscapeXMLText(&sEmailText);
	
	// get user ID in a string
	CTDVString sUserID;
	sUserID << iUserID;
	
	// do any necessary substitutions
	sEmailSubject.Replace("++**nickname**++", sOldNickname);
	sEmailText.Replace("++**nickname**++", sOldNickname);
	sEmailSubject.Replace("++**userid**++", sUserID);
	sEmailText.Replace("++**userid**++", sUserID);
	
	// then send the email
	CTDVString m_ModeratorsEmail;
	m_InputContext.GetEmail(EMAIL_MODERATORS, m_ModeratorsEmail, iThisSiteID);
	CTDVString m_SiteShortName;
	m_InputContext.GetShortName(m_SiteShortName, iThisSiteID);
	if ( !SendMail(sUsersEmail, sEmailSubject, sEmailText, m_ModeratorsEmail, m_SiteShortName) )
	{
		CTDVString sErr = "Unable to send email ";
		sErr << sUsersEmail;
		SetDNALastError("CModerateNickNamesBuilder::SendEmail","SendEmail",sErr );
		return false;
	}

	// Send Email to complainant if complaint.
	/*if (sComplainantsEmail.GetLength() > 0 &&  (iStatus == 3 || iStatus == 4 || iStatus == 6))
	{
		CTDVString sComplainantEmailSubject;
		CTDVString sComplainantEmailText;

		// get the appropriate email template depending on whether it is a pass or fail
		if (iStatus == 3)
		{
			// pass => complaint was overruled
			bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID,
				"RejectComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 4)
		{
			// fail => complaint was upheld

			bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID,
				"UpholdComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 6)
		{
			// fail => complaint was upheld
		
			bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID,
				"UpholdComplaintEditEntryEmail", sComplainantEmailSubject, 
				sComplainantEmailText);
		}

		CXMLObject::UnEscapeXMLText(&sComplainantEmailSubject);
		CXMLObject::UnEscapeXMLText(&sComplainantEmailText);

		if (bSuccess)
		{
			// do any necessary template substitutions
			// => just putting in the complaint reference number currently
			CTDVString	sRefNumber = "P";
			sRefNumber << iModID;
			sComplainantEmailSubject.Replace("++**reference_number**++", sRefNumber);
			sComplainantEmailText.Replace("++**reference_number**++", sRefNumber);

			// Allow rejected complaints to have some custom text
			// For now re-using the 'CustomEmailText' field since it wouldn't have
			// been used to send something to the author.
			//
			if (iStatus == 3)
			{
				sComplainantEmailText.Replace("++**inserted_text**++", sCustomText);
			}
			// send the email
			bSuccess = SendMail(sComplainantsEmail, 
				sComplainantEmailSubject, sComplainantEmailText, 
				sModeratorsEmail, sSiteShortName);
		}

		if(!bSuccess)
		{
			CTDVString sErrorXML = "Email failed to be sent to complainant for post (ID=";
			sErrorXML << iPostID << "), email address " << sComplainantsEmail;
			SetDNALastError("ModeratePosts::SendEmail","SendEmail",sErrorXML);
		}
	}*/
	return true;
}

bool CModerateNickNamesBuilder::SendMailOrSystemMessage(int iUserID, CTDVString sOldNickname, CTDVString sUsersEmail, int iSiteID)
{
	CTDVString	sEmailSubject;
	CTDVString	sEmailText;

	// first get the overall email template
	CEmailTemplate email(m_InputContext);
	if ( !email.FetchEmailText(iSiteID, "NicknameResetEmail", sEmailSubject, sEmailText) )
	{
		CTDVString sErr = "Unable to fetch email text for site ";
		sErr << iSiteID;
		SetDNALastError("CModerateNicknamesBuilder::SendEmail","SendEmail",sErr);
		return false;
	}
	CXMLObject::UnEscapeXMLText(&sEmailSubject);
	CXMLObject::UnEscapeXMLText(&sEmailText);
	
	// get user ID in a string
	CTDVString sUserID;
	sUserID << iUserID;
	
	// do any necessary substitutions
	sEmailSubject.Replace("++**nickname**++", sOldNickname);
	sEmailText.Replace("++**nickname**++", sOldNickname);
	sEmailSubject.Replace("++**userid**++", sUserID);
	sEmailText.Replace("++**userid**++", sUserID);
	
	// then send the email
	CTDVString m_ModeratorsEmail;
	m_InputContext.GetEmail(EMAIL_MODERATORS, m_ModeratorsEmail, iSiteID);
	CTDVString m_SiteShortName;
	m_InputContext.GetShortName(m_SiteShortName, iSiteID);

	if ( !m_InputContext.SendMailOrSystemMessage(sUsersEmail, sEmailSubject, sEmailText, m_ModeratorsEmail, m_SiteShortName, false, iUserID, iSiteID) )
	{
		CTDVString sErr = "Unable to send email ";
		sErr << sUsersEmail;
		SetDNALastError("CModerateNickNamesBuilder::SendMailOrSystemMessage","SendMailOrSystemMessage",sErr );
		return false;
	}

	return true;
}
//#endif // _ADMIN_VERSION

