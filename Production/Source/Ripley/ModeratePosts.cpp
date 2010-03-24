#include "stdafx.h"
#include "SiteData.h"
#include "ForumModerationPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "./emailtemplate.h"
#include "ModerationClasses.h"
#include "ModReasons.h"
#include "UserStatuses.h"
#include "ForumPostEditForm.h"
#include ".\moderationdistressmessages.h"
#include ".\BasicSiteList.h"
#include "SiteOptions.h"

#if defined (_ADMIN_VERSION)

// ForumModerationPageBuilder.cpp: implementation of the CForumModerationPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#include "stdafx.h"
#include ".\moderateposts.h"

CModeratePostsBuilder::CModeratePostsBuilder(CInputContext& InputContext) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

CModeratePostsBuilder::~CModeratePostsBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CForumModerationPageBuilder::Build()

	Author:		Martin Robb
	Created:	01/03/2006
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate forum postings.

*********************************************************************************/

bool CModeratePostsBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "POST-MODERATION", true);
	bool bSuccess = true;

	// do an error page if not an editor or moderator.
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()) )
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
		return true;
	}

	//Process Actions.
	if ( ! Process(pWholePage,pViewer) )
	{
		SetDNALastError("CModeratePostsBuilder::Build","Build","Unable to process");
		pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	//Handle s_returnto.
	if ( bSuccess && CheckAndUseRedirectIfGiven(pWholePage) )
		return bSuccess;

	//Handle 'Oldstyle' redirect - necessary to handle multiple submit buttons for the same form.  
	if ( m_InputContext.ParamExists("Done") )
	{
		CTDVString sRedirect = "Moderate?newstyle=1";
		if ( m_InputContext.GetParamInt("fastmod") == 1 )
			sRedirect += "&fastmod=1";
		return pWholePage->Redirect(sRedirect);
	}

	//Produce XML for page.

	// find out if we are processing referrals or not
	bool bReferrals = m_InputContext.GetParamInt("Referrals") == 1;
	bool bAlerts = m_InputContext.GetParamInt("Alerts") == 1;
	bool bLockedItems = m_InputContext.GetParamInt("Locked") == 1; //Viewing users locked items only.
	bool bHeldItems = m_InputContext.GetParamInt("Held") == 1;
	int iShow = 10;
	if ( m_InputContext.ParamExists("show") )
		iShow = m_InputContext.GetParamInt("show");
	
	bool bFastMod = m_InputContext.GetParamInt("fastmod") != 0;

	int iModClassId = 0;
	if ( m_InputContext.ParamExists("ModClassId") )
		iModClassId = m_InputContext.GetParamInt("ModClassId");

	//Filter on moderation items for a specific post.
	int iPostId = 0;
	if ( m_InputContext.ParamExists("PostFilterId") )
		iPostId = m_InputContext.GetParamInt("PostFilterId");

	//Add Moderation Classes
	CModerationClasses modclasses(m_InputContext);
	if ( modclasses.GetModerationClasses() )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&modclasses);
	else if ( modclasses.ErrorReported() )
		bSuccess && bSuccess && pWholePage->AddInside("H2G2",modclasses.GetLastErrorAsXMLString() );

	//Add Moderation Failure - Reasons
	CModReasons reasons(m_InputContext);
	if ( reasons.GetModReasons(iModClassId) )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&reasons);

	//Add Refereee List
	CRefereeList referees(m_InputContext);
	if ( referees.FetchTheList() )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&referees);

	//Add Site List
	//CTDVString sSiteXML;
	//bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
	//bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);
	CBasicSiteList sitelist(m_InputContext);
	if ( !sitelist.PopulateList() )
		pWholePage->AddInside("H2G2",sitelist.GetLastErrorAsXMLString());
	else
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",sitelist.GetAsXML2());

	//Add User Moderation Statuses
	CUserStatuses modstatuses(m_InputContext);
	if ( modstatuses.GetUserStatuses() )
		pWholePage->AddInside("H2G2",&modstatuses);
	else if ( modstatuses.ErrorReported() )
		pWholePage->AddInside("H2G2",modstatuses.GetLastErrorAsXMLString());

	//Add Distress Messages
	CModerationDistressMessages distressmsgs(m_InputContext);
	if ( distressmsgs.GetDistressMessages(iModClassId) )
		pWholePage->AddInside("H2G2",&distressmsgs);
	else
		pWholePage->AddInside("H2G2",distressmsgs.GetLastErrorAsXMLString() );


	CModeratePosts moderate(m_InputContext);
	if ( !moderate.GetPosts( pViewer->GetUserID(), bAlerts, bReferrals, bLockedItems, bHeldItems, iModClassId, iPostId,  iShow, bFastMod ) )
		pWholePage->AddInside("H2G2",moderate.GetLastErrorAsXMLString() );
	else
		pWholePage->AddInside("H2G2",&moderate);
	

	TDVASSERT(bSuccess, "CModeratePostsBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CForumModerationPageBuilder::Process(CWholePage* pPage,CUser* pViewer)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CModeratePostsBuilder::Process(CWholePage* pPage, CUser* pViewer)
{
	bool	bSuccess = true;
	
	int			iNumberOfPosts = 0;
	int			iForumID = 0;
	int			iThreadID = 0;
	int			iPostID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			iReferTo = 0;
	int			iSiteID = -1;
	CTDVString	sNotes;
	int			i = 0;
	int			iThreadModStatus = 0;
	CTDVString	sEmailType;
	CTDVString	sCustomText;
	bool		bDoNotSendEmail = false;
	
	CSiteOptions* pSiteOptions = m_InputContext.GetSiteOptions();	

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CModeratePosts moderate(m_InputContext);

	// first get the total number of post IDs in the submission
	// - there should be an equal number of all the other parameters
	iNumberOfPosts = m_InputContext.GetParamCount("PostID");
	int iTotalProcessed = 0;
	CTDVString sFeedback;
	for ( int i = 0; i < iNumberOfPosts; ++i )
	{
		if ( !bSuccess )
			break;

		// get the PostID and corresponding decision, plus notes if any
		iForumID = m_InputContext.GetParamInt("ForumID", i);
		iThreadID = m_InputContext.GetParamInt("ThreadID", i);
		iPostID = m_InputContext.GetParamInt("PostID", i);
		iModID = m_InputContext.GetParamInt("ModID", i);
		iStatus = m_InputContext.GetParamInt("Decision", i);
		iReferTo = m_InputContext.GetParamInt("ReferTo", i);
		iSiteID = m_InputContext.GetParamInt("SiteID", i);
		bDoNotSendEmail = pSiteOptions->GetValueBool(iSiteID, "Moderation", "DoNotSendEmail");
		if ( m_InputContext.ParamExists("ThreadModerationStatus",i) )
			iThreadModStatus = m_InputContext.GetParamInt("ThreadModerationStatus",i);
		if (!m_InputContext.GetParamString("Notes", sNotes, i))
		{
			sNotes = "";
		}

		// Check to see if we're dealing with a PreModPosting Entry!
		bool bIsPreModPosting = false;
		if (iPostID == 0)
		{
			// Check PreModPosting Table to see if we've got a match on the ModID!
			CStoredProcedure SP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
			{
				SetDNALastError("CForumModerationPageBuilder::ProcessSubmission","FailedCheckingForModID","Failed checking for modid!!!");
			}
			else
			{
				// Check to see if we need to create the post if it exists. If we're editing the post before moderation, then create it
				bool bCreateIfExists = (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSANDEDIT);

				// Check the PreModPosting tables
				if (!SP.CheckPreModPostingExists(iModID,bCreateIfExists))
				{
					SetDNALastError("CForumModerationPageBuilder::ProcessSubmission","FailedCheckingForModID","Failed checking for modid!!!");
				}

				// Did we find it or not?
				bIsPreModPosting = !SP.IsEOF() && SP.FieldExists("ModID");
				if (bCreateIfExists && !SP.IsEOF())
				{
					// Get the postid and threadid for the new post
					iPostID = SP.GetIntField("postid");
					iThreadID = SP.GetIntField("threadid");
				}
			}
		}

		// do an update for this post only if we have all necessary data
		if (iModID == 0 || iForumID == 0 || ((iPostID == 0 || iThreadID == 0) && !bIsPreModPosting) || 
			( (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILED) && !m_InputContext.ParamExists("EmailType") ) )
		{
			CTDVString sErr = "Error processing post ";
			sErr << iPostID << " - Insufficient Details";
			pPage->AddInside("H2G2",CreateErrorXMLString("ModeratePosts::Process","Process",sErr));
			continue;
		}

		CTDVString sCustomText;
		//The value of the drop down entry selected
		m_InputContext.GetParamString("EmailType", sEmailType, i);
		if (sEmailType.CompareText("URLInsert"))
		{
			m_InputContext.GetParamString("UrlEmailText", sCustomText, i);
		}
		else
		{
			m_InputContext.GetParamString("CustomEmailText", sCustomText, i);
		}
		if ( iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSANDEDIT  )
		{
			if (m_InputContext.ParamExists("EditPostSubject",i) && m_InputContext.ParamExists("EditPostText",i))
			{
				CTDVString sBody, sSubject;
				m_InputContext.GetParamString("EditPostSubject", sSubject, i);
				m_InputContext.GetParamString("EditPostText",sBody,i);
				CForumPostEditForm editpost(m_InputContext);
				editpost.SetPostID(iPostID);
				if ( !editpost.ProcessForumPostUpdate(pViewer,sSubject,sBody,NULL,true,false,true ) )
				{
					pPage->AddInside("H2G2",editpost.GetLastErrorAsXMLString());
					continue;
				}
			}
			else
			{
				CTDVString err = "Unable to edit post " ;
				err << iPostID << " Missing Subject/Body";
				pPage->AddInside("H2G2",CXMLError::CreateErrorXMLString("CModeratePosts::Process","ModeratePosts",err));
				continue;
			}
		}
		
		CTDVString	sAuthorsEmail;
		std::vector<CTDVString> vComplainantsEmail;
		std::vector<int> vComplainantsID;
		std::vector<int> vComplaintModID;
		int IsLegacy = 0;
		int iProcessed = 0;
		int iAuthorID = 0; 
		int iComplainantID = 0; 

		//Moderate the post.
		if ( moderate.Update(iModID, iSiteID, iForumID, iThreadID, iPostID, pViewer->GetUserID(), iStatus, iReferTo, iThreadModStatus, sNotes, IsLegacy, iProcessed, sAuthorsEmail, vComplainantsEmail, iAuthorID, vComplainantsID, vComplaintModID) )
		{
			if ( moderate.ErrorReported() )
			{
				pPage->AddInside("H2G2",moderate.GetLastErrorAsXMLString());
				moderate.ClearError();
			}

			iTotalProcessed += iProcessed;

			//Distress Message Processing.
			CTDVString sSubject, sBody;
			int iDistressMessageId = m_InputContext.GetParamInt("distressmessageId",i);
			if ( iDistressMessageId > 0 )
			{
				//Get specified Distress Message
				CModerationDistressMessages distressmsgs(m_InputContext);
				CTDVString sSubject, sBody;
				if ( !distressmsgs.GetDistressMessage(iDistressMessageId, sSubject, sBody ) )
				{
					pPage->AddInside("H2G2",distressmsgs.GetLastErrorAsXMLString());
				}
				else 
				{
					int iUserId;
					if ( m_InputContext.DoesSiteHaveDistressMsgUserId(iSiteID, iUserId) )
					{
						//Site concerned has an account specified for posting distress messages.
						CUser postinguser(m_InputContext);
						if ( !postinguser.CreateFromID(iUserId) )
						{
							CTDVString sErr = "Unable to create user for distress message user account ";
							sErr << iUserId;
							CreateErrorXMLString("ModeratePosts", "Process", sErr);
						}

						if ( !distressmsgs.PostDistressMessage(&postinguser,iSiteID,iForumID,iThreadID,iPostID,sSubject,sBody) )
						{
							pPage->AddInside("H2G2", distressmsgs.GetLastErrorAsXMLString());
						}

					}
					else 
					{
						//Send Distress Mesage using current user.
						if ( !distressmsgs.PostDistressMessage(m_InputContext.GetCurrentUser(),iSiteID,iForumID,iThreadID,iPostID,sSubject,sBody) )
							pPage->AddInside("H2G2", distressmsgs.GetLastErrorAsXMLString());
					}
				}
			}
 
			if ( !bDoNotSendEmail )
			{
				//Only send one email to the author if it was the result of a complaint and site option to send emails is not on.
				if (  !SendAuthorEmail(iModID, iStatus, iSiteID, iForumID, iThreadID, iPostID, IsLegacy, sCustomText, sEmailType, sAuthorsEmail, iAuthorID) )
					pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}

			//Multiple Complaint Handling - Notify each complainant of decision.
			for (unsigned int i = 0; i < vComplainantsEmail.size(); i++) 
			{
				if ( !vComplainantsEmail[i].IsEmpty() && vComplaintModID.size() > i )
				{
					if ( !SendComplainantEmail(vComplaintModID[i], iStatus, iSiteID, iForumID, iThreadID, iPostID, IsLegacy, sNotes, sCustomText, vComplainantsEmail[i], vComplainantsID[i]) )
						pPage->AddInside("H2G2", GetLastErrorAsXMLString());
				}
			}
		}
		else
		{
			pPage->AddInside("H2G2", moderate.GetLastErrorAsXMLString());
		}
	}

	//Create some Feedback XML.
	CTDVString sXML;
	sXML << "<FEEDBACK PROCESSED='" << iTotalProcessed << "'>" << sFeedback << "</FEEDBACK>";
	pPage->AddInside("H2G2",sXML); 
	return bSuccess;
}

/*********************************************************************************

	bool CForumModerationPageBuilder::SendEmail()

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Sends an email Informing author of moderation decision.

*********************************************************************************/
bool CModeratePostsBuilder::SendComplainantEmail(int iModID, int iStatus, int iSiteID, int iForumID, int iThreadID, int iPostID, int IsLegacy, CTDVString sNotes,CTDVString sCustomText, CTDVString sComplainantsEmail, int iComplainantID)
{
	bool bSuccess = true;
	CTDVString sErrorXML;
	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
	m_InputContext.GetShortName(sSiteShortName, iSiteID);

	// Get the text in the custom box
	if (sCustomText.GetLength() > 0)
		sNotes << "\r\n-----email insert------\r\n" << sCustomText;

	// don't notify author of legacy moderations
	// send the appropriate emails to the author and/or complainant if necessary
	// first if failed and we have a reason (which we always should) send an explanation to the author
	// use new email template class
	

	// second, if a complaint and either passed or failed, then let the complainant know the decision
	if (sComplainantsEmail.GetLength() > 0 && 
		( (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSED) || 
			(iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILED) || 
			(iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILANDEDIT) ||
			(iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSANDEDIT) ) )
	{
		CTDVString sComplainantEmailSubject;
		CTDVString sComplainantEmailText;

		CEmailTemplate Email(m_InputContext);

		// get the appropriate email template depending on whether it is a pass or fail
		if (iStatus ==  CModeratePosts::MODERATEPOSTS_CONTENTPASSED )
		{
			// pass => complaint was overruled
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"RejectComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus ==  CModeratePosts::MODERATEPOSTS_CONTENTPASSANDEDIT )
		{
			// pass => complaint was overruled
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"RejectComplaintEditEntryEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILED)
		{
			// fail => complaint was upheld

			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILANDEDIT)
		{
			// fail => complaint was upheld
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEditEntryEmail", sComplainantEmailSubject, 
				sComplainantEmailText);
		}

		//Check - have email text.
		if ( sComplainantEmailText.IsEmpty() )
		{
			sErrorXML << "No Complainant Email Text Found.";
			bSuccess = false;
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
			if ( (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSED) || (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTPASSANDEDIT) )
			{
				sComplainantEmailText.Replace("++**inserted_text**++", sCustomText);
			}

			// send the email
			bSuccess = SendMailOrSystemMessage(sComplainantsEmail, 
				sComplainantEmailSubject, sComplainantEmailText, 
				sModeratorsEmail, sSiteShortName, false, iComplainantID, iSiteID);
		}

		if(!bSuccess)
		{
			sErrorXML << "Email failed to be sent to complainant for post (ID=";
			sErrorXML << iPostID << "), email address " << sComplainantsEmail << ".\n";
		}
	}

	if ( !bSuccess )
		SetDNALastError("ModeratePosts::SendEmail","SendEmail",sErrorXML);

	return bSuccess;
}

bool CModeratePostsBuilder::SendAuthorEmail(int iModID, int iStatus, int iSiteID, int iForumID, int iThreadID, int iPostID, int IsLegacy,  CTDVString sCustomText,  CTDVString sEmailType, CTDVString sAuthorsEmail, int iAuthorID)
{
	CTDVString sErrorXML;
	CEmailTemplate Email(m_InputContext);
	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
	m_InputContext.GetShortName(sSiteShortName, iSiteID);

	bool bSuccess = true;
	if (IsLegacy == 0 && ( (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILED) || (iStatus ==  CModeratePosts::MODERATEPOSTS_CONTENTFAILANDEDIT) )
		&& !sEmailType.CompareText("None") )
	{
		CTDVString sAuthorEmailSubject;
		CTDVString sAuthorEmailText;
		CTDVString	sPostSubject;
		CTDVString	sPostText;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		bSuccess =  SP.FetchPostDetails(iPostID);
		
		bSuccess = bSuccess && SP.GetField("Subject", sPostSubject);
		bSuccess = bSuccess && SP.GetField("Text", sPostText);
		if (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILED)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentRemovedEmail", sAuthorEmailSubject, sAuthorEmailText);
		}
		else if (iStatus == CModeratePosts::MODERATEPOSTS_CONTENTFAILANDEDIT)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentFailedAndEditedEmail", sAuthorEmailSubject, sAuthorEmailText);

		}

		//Check have author email text.
		if ( sAuthorEmailText.IsEmpty() )
		{
			sErrorXML << "No Author Email Text Found.";
			bSuccess = false;
		}

		CXMLObject::UnEscapeXMLText(&sAuthorEmailSubject);
		CXMLObject::UnEscapeXMLText(&sAuthorEmailText);
		
		// then get the specific reason text
		CTDVString sInsertText;
		bSuccess = bSuccess && Email.FetchInsertText(iSiteID,sEmailType, sInsertText);
		CXMLObject::UnEscapeXMLText(&sInsertText);

		if (bSuccess)
		{
			// do any necessary translations
			CTDVString	sURL = "http://";
			CTDVString	sSiteRootURL;

			// construct the URL for the post
			m_InputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
			sURL << sSiteRootURL << "F" << iForumID << "?Thread=" << iThreadID << "&post=" << iPostID << "#p" << iPostID;
			// first place the insert text before doing any of the other translations, so
			// that any place holders in the inserted text will also be translated
			sAuthorEmailText.Replace("++**inserted_text**++", sInsertText);
			sAuthorEmailText.Replace("++**inserted_text**++", sCustomText);
			// now do the other replacements
			sAuthorEmailSubject.Replace("++**content_type**++", "Posting");
			sAuthorEmailText.Replace("++**content_type**++", "Posting");
			sAuthorEmailText.Replace("++**add_content_method**++", "post it");
			sAuthorEmailText.Replace("++**content_url**++", sURL);
			sAuthorEmailSubject.Replace("++**content_subject**++", sPostSubject);
			sAuthorEmailText.Replace("++**content_subject**++", sPostSubject);
			sAuthorEmailText.Replace("++**content_text**++", sPostText);
			
			// then send the email
			bSuccess = SendMailOrSystemMessage(sAuthorsEmail, sAuthorEmailSubject, sAuthorEmailText, sModeratorsEmail, sSiteShortName, false, iAuthorID, iSiteID);
		}

		if(!bSuccess)
		{
			sErrorXML << "Email failed to be sent to author of failed post (ID=";
			sErrorXML << iPostID <<  "), email address " <<  sAuthorsEmail << ".\n";
			SetDNALastError("CModeratePostsBuilder::SendAuthorEmail","SendAuthorEmail",sErrorXML);
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CModeratePosts::Update()
	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		-
	Outputs:	-	vComplainantsId - Multiple complaints for the same post are processed - vector of complainant user ids processed.
					vComplaintModId - vector of complainant modIds processed
					vComplainantsEmail - vector of complainant email addresses processed.
					Authors Email, AuthorId - post author email and author userid.
	Returns:	true for success
	Purpose:	Updates an item in the moderation queue with th emoderators decision.

*********************************************************************************/
bool CModeratePosts::Update(int iModID, int iSiteID, int iForumID, int& iThreadID, 
							int& iPostID, int iUserID, int iStatus, int iReferTo,int iThreadModStatus,  CTDVString sNotes,
							int& IsLegacy, int& iProcessed, CTDVString& sAuthorsEmail, std::vector<CTDVString>& vComplainantsEmail, 
							int& iAuthorID, std::vector<int>& vComplainantsID, std::vector<int>& vModIDs )
{
	bool bSuccess = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	bSuccess = bSuccess && SP.UpdatePostingsModeration(iForumID, iThreadID, iPostID, iModID, iStatus, sNotes, iReferTo, iUserID, iThreadModStatus,true);

	CTDVString sComplainantsEmail;
	
	while ( !SP.IsEOF() )
	{
		bSuccess = bSuccess && SP.GetField("AuthorsEmail", sAuthorsEmail);
		iAuthorID = SP.GetIntField("AuthorID");
		IsLegacy = SP.GetIntField("IsLegacy");
		iProcessed = SP.GetIntField("processed");
		bSuccess = bSuccess && SP.GetField("ComplaintsEmail", sComplainantsEmail);

		//Multiple Complaint Handling - Handle resultset of complaints processed 
		vComplainantsEmail.push_back(sComplainantsEmail);
		vComplainantsID.push_back(SP.GetIntField("ComplainantID"));
		vModIDs.push_back(SP.GetIntField("ModId"));
		iPostID = SP.GetIntField("PostID");
		iThreadID = SP.GetIntField("ThreadID");
		SP.MoveNext();
	}

	if ( iProcessed != vModIDs.size() )
	{
		//Sanity check that results processed matches mod ids returned.
		CTDVString sErr = "Results processed does not match returned results: ";
		sErr << "Processed " << iProcessed << "Moderation Items: ";
		for ( std::vector<int>::iterator iter = vModIDs.begin(); iter != vModIDs.end(); ++iter )
			sErr << *iter << "  "; 
		SetDNALastError("CModeratePosts::Update","Update",sErr);
		TDVASSERT(false, sErr);
	}

	return bSuccess;
}

/*********************************************************************************

	bool CModeratePosts::GetPosts()
	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Retrieves ( and locks to the viewing user ) posts for moderation.
				Only posts for sites where the viewer is a superuser/moderator/referee/Host are fetched.
				XML is also filtered depending on users permissions eg usernames are not visible to moderators.
*********************************************************************************/
bool CModeratePosts::GetPosts( int iUserID, bool bAlerts, bool bReferrals, bool bLockedItems, bool bHeldItems, int iModClassId, int iPostId, int iShow, bool bFastMod )
{
	bool bSuperUser  = m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser();

	//Allow duplicate complaints only where a postId filter has been given.
	bool bDuplicateComplaints = bAlerts && iPostId > 0;

	//Get Posts for Moderation.
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetModerationPosts( iUserID, bSuperUser, bAlerts, bReferrals, bHeldItems, bLockedItems, iModClassId, iPostId, bDuplicateComplaints, iShow, bFastMod );

	CTDVString		sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	OpenXMLTag("POSTMODERATION", true );

	if ( bAlerts )
		AddXMLIntAttribute("ALERTS",1, false);
	
	if ( bReferrals )
		AddXMLIntAttribute("REFERRALS",1, false);

	if ( bLockedItems )
		AddXMLIntAttribute("LOCKEDITEMS",1, false);

	if ( bFastMod )
		AddXMLIntAttribute("FASTMOD", 1, false);

	AddXMLIntAttribute("COUNT", SP.IsEOF() ? 0 : SP.GetIntField("count"), true );

	while (!SP.IsEOF())
	{	
		OpenXMLTag("POST",true);
		AddDBXMLIntAttribute("EntryID","POSTID");
		AddDBXMLIntAttribute("ModID","MODERATIONID");

		AddDBXMLIntAttribute("ThreadId");
		AddDBXMLIntAttribute("ForumId","FORUMID");
		AddDBXMLIntAttribute("ISPREMODPOSTING","ISPREMODPOSTING",false);

		if (!(SP.IsNULL("CommentForumUrl")))
		{
			//GenerateCommentForumPostUrl
			CTDVString sCommentForumUrl;
			SP.GetField("CommentForumUrl",sCommentForumUrl);

			int iEntryID = SP.GetIntField("Entryid");
			int iCommentForumPostIndex = SP.GetIntField("PostIndex");
			
			if (iCommentForumPostIndex >= 0)
			{
				int iCommentForumDefaultShow = m_InputContext.GetDefaultShow(SP.GetIntField("siteid")); 
				int iDnaFrom = (iCommentForumPostIndex / iCommentForumDefaultShow) * iCommentForumDefaultShow; 
				int iDnaTo = iDnaFrom + iCommentForumDefaultShow - 1; 
				sCommentForumUrl << "?dnafrom=" << iDnaFrom << "&dnato=" << iDnaTo << "#P" << iEntryID; 
			}
			AddXMLAttribute("COMMENTFORUMURL", sCommentForumUrl, false);
		}

		AddDBXMLIntAttribute("Parent","INREPLYTO",false,true);

		AddDBXMLIntTag("modclassId");
		AddDBXMLIntTag("ThreadModerationStatus","MODERATION-STATUS");

		int iSiteId = SP.GetIntField("siteid");
		AddXMLIntTag("siteid",iSiteId);


		if ( !SP.IsNULL("TopicTitle") )
			AddDBXMLTag("TopicTitle");
		
		AddDBXMLTag("SUBJECT");

		if (SP.GetIntField("PostStyle") != 1)
		{
			CTDVString sText;
			SP.GetField("TEXT", sText);
			CTDVString sRawText(sText);
			CXMLObject::DoPlainTextTranslations(&sText);
			AddXMLTag("TEXT", sText);
			CXMLObject::EscapeEverything(&sRawText);
			AddXMLTag("RAWTEXT", sRawText);
		}
		else 
		{
			AddDBXMLTag("TEXT",NULL, true, false);
		}

		
		//Details of locking moderator.
		OpenXMLTag("LOCKED");
		AddDBXMLDateTag("DATELOCKED");
		OpenXMLTag("USER");
		AddDBXMLIntTag("LOCKEDBY","USERID");
		AddDBXMLTag("LOCKEDNAME","USERNAME",false);
		AddDBXMLTag("LOCKEDFIRSTNAMES", "FIRSTNAMES",false);
		AddDBXMLTag("LOCKEDLASTNAME","LASTNAME",false);
		CloseXMLTag("USER");
		CloseXMLTag("LOCKED");

        // Add Notes
        CTDVString sNotes;
        SP.GetField("Notes",sNotes);
        EscapeAllXML(&sNotes);
	    AddXMLTag("NOTES",sNotes);

		int iComplainantID = 0;
		CTDVString sComplainantName;
		CTDVString sComplainantFirstNames;
		CTDVString sComplainantLastName;
		CTDVString sComplaintText;
		int iComplainantIDViaEmail = 0;
		CTDVDateTime dDateSubmitted;
		int iComplainantUserStatus= 0;
		CTDVDateTime dComplainantUserStatusDate;
		int iComplainantUserStatusDuration = 0;
		int iComplaintCount = 0;
		if ( bAlerts )
		{
			iComplainantID = SP.GetIntField("ComplainantId");
			SP.GetField("ComplainantName",sComplainantName);
			SP.GetField("ComplainantFirstNames",sComplainantFirstNames);
			SP.GetField("ComplainantLastName", sComplainantLastName);
			iComplainantIDViaEmail = SP.GetIntField("ComplainantIDViaEmail");
			dDateSubmitted = SP.GetDateField("DateQueued");
			SP.GetField("ComplaintText",sComplaintText);

			iComplainantUserStatus = SP.GetIntField("ComplainantPrefStatus");
			if ( !SP.IsNULL("ComplainantPrefStatusChangedDate") )
            {
			    dComplainantUserStatusDate = SP.GetDateField("ComplainantPrefStatusChangedDate");
            }
			iComplainantUserStatusDuration = SP.GetIntField("ComplainantPrefStatusDuration");
			iComplaintCount = SP.GetIntField("complaintcount");
		}

		int iReferrerID;
		CTDVString sReferrerName;
		CTDVString sReferrerFirstNames;
		CTDVString sReferrerLastName;
		int iReferrerStatus;
		CTDVDateTime dDateReferred;
		if ( bReferrals )
		{
			iReferrerID = SP.GetIntField("ReferrerId");
			SP.GetField("ReferrerName",sReferrerName);
			SP.GetField("ReferrerFirstNames",sReferrerFirstNames);
			SP.GetField("ReferrerLastName", sReferrerLastName);
			iReferrerStatus = SP.GetIntField("ReferrerStatus");
			dDateReferred = SP.GetDateField("DateReferred");
		}

		//Usernames are only visible by Editors / Superusers and Hosts.
		bool bIsSiteEditor = SP.GetIntField("IsEditor") == 1;
		bool bIsReferee = SP.GetIntField("IsReferee") == 1;
		bool bIsHost = SP.GetIntField("IsHost") == 1;
		bool bIncludeAuthorXML = bIsSiteEditor || bIsReferee || bIsHost || bSuperUser;
		if ( bIncludeAuthorXML )
		{
			//User details of post editor.
			OpenXMLTag("USER");
			int iAuthorID = SP.GetIntField("userid");
			AddXMLIntTag("USERID",iAuthorID);
			AddDBXMLTag("username","USERNAME",false);
			AddDBXMLTag("firstnames","FIRSTNAMES",false);
			AddDBXMLTag("lastname","LASTNAME",false);
			
			//User Moderation Status
			if ( !SP.IsNULL("PrefStatus") )
			{
				OpenXMLTag("STATUS", true);
				AddDBXMLIntAttribute("PrefStatus", "StatusID", false, false);
				AddDBXMLIntAttribute("PrefStatusDuration", "Duration", false, true);
				AddDBXMLDateTag("PrefStatusChangedDate","StatusChangedDate", false);
				CloseXMLTag("STATUS");	
			}

			//Add Author User Groups 
			CTDVString sUserGroupsXML;
			m_InputContext.GetUserGroups(sUserGroupsXML,iAuthorID, iSiteId );
			sXML += sUserGroupsXML;
		}
		

		//Get Member Tags.
		std::set<CTDVString> usermembertags;
		std::set<CTDVString> complainantmembertags;
		int iModID = SP.GetIntField("ModID");
		while ( !SP.IsEOF() && (SP.GetIntField("ModID") == iModID) )
		{
			if ( !SP.IsNULL("UserMemberTag") ) 
			{
				CTDVString sUserMemberTag;
				SP.GetField("UserMemberTag",sUserMemberTag);
				if ( usermembertags.find(sUserMemberTag) == usermembertags.end() )
					usermembertags.insert(sUserMemberTag);
			}

			if ( !SP.IsNULL("ComplainantMemberTag") ) 
			{
				CTDVString sComplainantMemberTag;
				SP.GetField("ComplainantMemberTag",sComplainantMemberTag);
				if ( complainantmembertags.find(sComplainantMemberTag) == complainantmembertags.end() )
					complainantmembertags.insert(sComplainantMemberTag);
			}
			SP.MoveNext();
		}

		if ( !usermembertags.empty() )
		{
			OpenXMLTag("USERMEMBERTAGS");
			for ( std::set<CTDVString>::iterator iter = usermembertags.begin(); iter != usermembertags.end(); ++iter )
				AddXMLTag("USERMEMBERTAG",*iter);
			CloseXMLTag("USERMEMBERTAGS");
		}

		if ( bIncludeAuthorXML ) 
			CloseXMLTag("USER");

		//Create the XML from the gathered data.
		if ( bAlerts )
		{
			OpenXMLTag("ALERT");

			//Username only shown for editors/superusers/hosts
			OpenXMLTag("USER");
			AddXMLIntTag("USERID",iComplainantID);
			AddXMLTag("USERNAME",sComplainantName);
			AddXMLTag("FIRSTNAMES", sComplainantFirstNames);
			AddXMLTag("LASTNAME", sComplainantLastName);
			AddXMLIntTag("COMPLAINANTIDVIAEMAIL", iComplainantIDViaEmail); 
			
			//User Moderation Status
			if ( !SP.IsNULL("PrefStatus") )
			{
				OpenXMLTag("STATUS", true);
				AddXMLIntAttribute("STATUSID", iComplainantUserStatus, false);
				AddXMLIntAttribute("DURATION", iComplainantUserStatusDuration, true);
				AddXMLDateTag("STATUSCHANGEDDATE", dComplainantUserStatusDate, false);
				CloseXMLTag("STATUS");	
			}

			//Add the member tags.
			if ( !complainantmembertags.empty() ) 
			{
				OpenXMLTag("USERMEMBERTAGS");
				for ( std::set<CTDVString>::iterator iter = complainantmembertags.begin(); iter != complainantmembertags.end(); ++iter )
					AddXMLTag("USERMEMBERTAG",*iter);
				CloseXMLTag("USERMEMBERTAGS");
			}

			//Add Complainant User Groups 
			CTDVString sUserGroupsXML;
			m_InputContext.GetUserGroups(sUserGroupsXML,iComplainantID, iSiteId );
			sXML += sUserGroupsXML;
			

			CloseXMLTag("USER");

			CXMLObject::DoPlainTextTranslations(&sComplaintText);
			AddXMLTag("TEXT",sComplaintText);
			AddXMLDateTag("DATEQUEUED",dDateSubmitted);
			AddXMLIntTag("ALERTCOUNT", iComplaintCount);
			CloseXMLTag("ALERT");
		}


		if ( bReferrals )
		{
			OpenXMLTag("REFERRED");

			//Only referrees / editors / superusers can see referred items - stored procedure checks permissions.
			OpenXMLTag("USER");
			AddXMLIntTag("USERID",iReferrerID);
			AddXMLTag("USERNAME",sReferrerName);
			AddXMLTag("FIRSTNAMES", sReferrerFirstNames);
			AddXMLTag("LASTNAME", sReferrerLastName);
			AddXMLIntTag("STATUS",iReferrerStatus);
			CloseXMLTag("USER");
			AddXMLDateTag("DATEREFERRED",dDateReferred);
			CloseXMLTag("REFERRED");
		}

		CloseXMLTag("POST");
	}

	CloseXMLTag("POSTMODERATION");
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CModeratePosts::UnlockModeratePostsForUser( int iUserID )
	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		- int iUserId - UserId to unlock
				  int iModClassId - Unlock only sites with specified ModClassId 
	Outputs:	-
	Returns:	true for success
	Purpose:	Unlocks all moderation items for a user.

*********************************************************************************/
bool CModeratePosts::UnlockModeratePostsForUser( int iUserID, int iModClassId )
{

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	return SP.UnlockModeratePostsForUser( iUserID, iModClassId );
}
	
/*********************************************************************************

	bool CModeratePosts::UnlockModeratePostsForSite( int iSiteID )
	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		- userid of editor, siteid to unlock, users superuser status
	Outputs:	-
	Returns:	true for success
	Purpose:	Unlocks all moderation items for a site

*********************************************************************************/
bool CModeratePosts::UnlockModeratePostsForSite( int iUserID, int iSiteID, bool bIsSuperUser )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	return SP.UnlockModeratePostsForSite( iUserID, iSiteID, bIsSuperUser );
}

/*********************************************************************************

	bool CModeratePosts::UnlockModeratePosts( int iUserID )
	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		- UserId of editor, superuser status
	Outputs:	-
	Returns:	true for success
	Purpose:	Unlocks all moderation items for all sites

*********************************************************************************/
bool CModeratePosts::UnlockModeratePosts( int iUserID, bool bSuperUser )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	return SP.UnlockModeratePosts( iUserID, bSuperUser );
}

#endif // _ADMIN_VERSION
