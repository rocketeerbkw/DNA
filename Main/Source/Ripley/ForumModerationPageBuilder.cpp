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
#include "SiteData.h"
#include "ForumModerationPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "./emailtemplate.h"
#include "./modreasons.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CForumModerationPageBuilder::CForumModerationPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CForumModerationPageBuilder object.

*********************************************************************************/

CForumModerationPageBuilder::CForumModerationPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_sCommand("View"),
	m_sErrorXML(""),
	m_bErrors(false),
	m_RefereeList(inputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CForumModerationPageBuilder::~CForumModerationPageBuilder()

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CForumModerationPageBuilder::~CForumModerationPageBuilder()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CForumModerationPageBuilder::Build()

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate forum postings.

*********************************************************************************/

bool CForumModerationPageBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "FORUM-MODERATION", true);
	bool bSuccess = true;

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
	}
	else
	{
		// find out what command
		if (m_InputContext.ParamExists("Done"))
		{
			m_sCommand = "Done";
		}
		else
		{
			m_sCommand = "Next";
		}
		// first process any submission that may have been made
		bSuccess = bSuccess && ProcessSubmission(pViewer);
		if (bSuccess && m_sCommand.CompareText("Next"))
		{
			// then create the XML for the form to be displayed
			CTDVString	sFormXML = "";
			bSuccess = bSuccess && CreateForm(pViewer, &sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);

			CTDVString sSiteXML;
			bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

			bSuccess = bSuccess && m_RefereeList.FetchTheList();
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", &m_RefereeList);

			CModReasons modReasons(m_InputContext);
			modReasons.GetModReasons(0);
			pWholePage->AddInside("H2G2", &modReasons);
		}
		else
		// if a successful 'Done' request then redirect to the Moderation Home Page
		if (bSuccess && !m_bErrors)
		{
			int iFastMod = m_InputContext.GetParamInt("fastmod");
			int iNotFastMod = m_InputContext.GetParamInt("notfastmod");

			CTDVString sRedirect;
			if (iFastMod == 1)
			{
				sRedirect += "fastmod=1&";
			}
			if (iNotFastMod == 1)
			{
				sRedirect += "notfastmod=1";
			}
			
			pWholePage->Redirect("Moderate?" + sRedirect);
			
		}
	}
	TDVASSERT(bSuccess, "CForumModerationPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CForumModerationPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CForumModerationPageBuilder::ProcessSubmission(CUser* pViewer)
{
	bool	bAuthorEmailOK = false;
	bool	bComplainantEmailOK = false;
	bool	bSuccess = true;
	// if the command involves a submission then proceed
	int			iNumberOfPosts = 0;
	int			iForumID = 0;
	int			iThreadID = 0;
	int			iPostID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			iReferTo = 0;
	int			iIsLegacy = 0;
	int			iSiteID = -1;
	CTDVString	sNotes;
	int			i = 0;
	int			iPremoderate = 0;
	int			iAuthorID = 0; 
	int			iComplainantID = 0; 
	CTDVString	sEmailType;
	CTDVString	sAuthorsEmail;
	CTDVString	sAuthorEmailSubject;
	CTDVString	sAuthorEmailText;
	CTDVString	sInsertText;
	CTDVString	sComplainantsEmail;
	CTDVString	sComplainantEmailSubject;
	CTDVString	sComplainantEmailText;
	CTDVString	sCustomText;
	CTDVString	sTemp;

	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}
	// first get the total number of post IDs in the submission
	// - there should be an equal number of all the other parameters
	iNumberOfPosts = m_InputContext.GetParamCount("PostID");
	// need to do an update for each of the posts that has been moderated
	// so go through all the appropriate parameters in the URL and process them
	i = 0;
	while (i < iNumberOfPosts && bSuccess)
	{
		// get the PostID and corresponding decision, plus notes if any
		iForumID = m_InputContext.GetParamInt("ForumID", i);
		iThreadID = m_InputContext.GetParamInt("ThreadID", i);
		iPostID = m_InputContext.GetParamInt("PostID", i);
		iModID = m_InputContext.GetParamInt("ModID", i);
		iStatus = m_InputContext.GetParamInt("Decision", i);
		iReferTo = m_InputContext.GetParamInt("ReferTo", i);
		iSiteID = m_InputContext.GetParamInt("SiteID", i);
		iPremoderate = m_InputContext.GetParamInt("Premoderate");
		if (!m_InputContext.GetParamString("Notes", sNotes, i))
		{
			sNotes = "";
		}
		if (!m_InputContext.GetParamString("EmailType", sEmailType, i))
		{
			sEmailType = "None";
		}

		// Check to see if we're a premod posting post.
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
				// Check the PreModPosting tables
				if (!SP.CheckPreModPostingExists(iModID))
				{
					SetDNALastError("CForumModerationPageBuilder::ProcessSubmission","FailedCheckingForModID","Failed checking for modid!!!");
				}

				// Did we find it or not?
				bIsPreModPosting = !SP.IsEOF() && SP.FieldExists("ModID");
			}
		}

		// do an update for this post only if we have all necessary data
		if (iModID > 0 && (bIsPreModPosting || (iPostID > 0 && iThreadID > 0)) && iForumID > 0 &&
			!((iStatus == 4 || iStatus == 6) && sEmailType.CompareText("None")))
		{
			if (iStatus == 5)
			{
				// unreferring is treated as a status, but is really a different kind of action
				bSuccess = bSuccess && m_pSP->UnreferPost(iModID, sNotes);
			}
			else
			{
				CTDVString sModeratorsEmail;
				CTDVString sSiteShortName;
				m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
				m_InputContext.GetShortName(sSiteShortName, iSiteID);

				// Get the text in the custom box
				bSuccess = bSuccess && m_InputContext.GetParamString("CustomEmailText", sCustomText, i);
				if (sCustomText.GetLength() > 0)
				{
					sNotes << "\r\n-----email insert------\r\n" << sCustomText;
				}
				
				bSuccess = bSuccess && m_pSP->UpdatePostingsModeration(iForumID, 
					iThreadID, iPostID, iModID, iStatus, sNotes, iReferTo,
					pViewer->GetUserID(), iPremoderate);

				// get the details of the author and complainant
				bSuccess = bSuccess && m_pSP->GetField("AuthorsEmail", sAuthorsEmail);
				iAuthorID = m_pSP->GetIntField("AuthorID");
				bSuccess = bSuccess && m_pSP->GetField("ComplainantsEmail", sComplainantsEmail);
				iComplainantID = m_pSP->GetIntField("ComplainantID");
				// also get field saying if this is a legacy item
				iIsLegacy = m_pSP->GetIntField("IsLegacy");

				// Check to see if we were called a PreModPosting
				if (bSuccess && iPostID == 0 && bIsPreModPosting)
				{
					// Get the value from the Procedure
					iPostID = m_pSP->GetIntField("PostID");
				}
				if (bSuccess && iThreadID == 0 && bIsPreModPosting)
				{
					// Get the value from the Procedure
					iThreadID = m_pSP->GetIntField("ThreadID");
				}

				// don't notify author of legacy moderations
				// send the appropriate emails to the author and/or complainant if necessary
				// first if failed and we have a reason (which we always should) send an explanation to the author
				// use new email template class
				CEmailTemplate m_Email(m_InputContext);

				if (iIsLegacy == 0 && (iStatus == 4 || iStatus == 6)
					&& !sEmailType.CompareText("None"))
				{
					CTDVString	sPostSubject;
					CTDVString	sPostText;
					CTDVString	sPageURL;
					bSuccess = bSuccess && m_pSP->FetchPostDetails(iPostID);
					bSuccess = bSuccess && m_pSP->GetField("Subject", sPostSubject);
					bSuccess = bSuccess && m_pSP->GetField("Text", sPostText);
					bSuccess = bSuccess && m_pSP->GetField("HOSTPAGEURL", sPageURL);
					if (iStatus == 4)
					{
						bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID,
							"ContentRemovedEmail", sAuthorEmailSubject, sAuthorEmailText);
					}
					else if (iStatus == 6)
					{
						bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID,
							"ContentFailedAndEditedEmail", sAuthorEmailSubject, sAuthorEmailText);

					}

					CXMLObject::UnEscapeXMLText(&sAuthorEmailSubject);
					CXMLObject::UnEscapeXMLText(&sAuthorEmailText);
					
					// then get the specific reason text
					bSuccess = bSuccess && m_Email.FetchInsertText(iSiteID,
							sEmailType, sInsertText);
					CXMLObject::UnEscapeXMLText(&sInsertText);

					if (bSuccess)
					{
						// do any necessary translations
						CTDVString	sURL = "http://";
						CTDVString	sSiteRootURL;

						if(sPageURL == "")
						{
							// construct the URL for the post
							m_InputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
							sURL << sSiteRootURL << "F" << iForumID << "?Thread=" << iThreadID << "&post=" << iPostID << "#P" << iPostID;
						}
						else
						{//it is a comment post so change use the movable type url
							sURL << sPageURL << "#P" << iPostID;
						}
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
						bAuthorEmailOK = SendMailOrSystemMessage(sAuthorsEmail, sAuthorEmailSubject, 
							sAuthorEmailText, sModeratorsEmail, sSiteShortName, false, iAuthorID, iSiteID);
					}
					else
					{
						bAuthorEmailOK = false;
					}

					if(!bAuthorEmailOK)
					{
						m_sErrorXML << "<ERROR TYPE='AUTHOR-EMAIL-FAILED'>Email failed to be sent to author of failed post (ID=" << iPostID << "), email address " << sAuthorsEmail << "</ERROR>";
						m_bErrors = true;
					}
				}
				// second, if a complaint and either passed or failed, then let the complainant know the decision
				if ((sComplainantsEmail.GetLength() > 0 || (m_InputContext.IsSystemMessagesOn(iSiteID)&& iComplainantID > 0)) && 
					(iStatus == 3 || iStatus == 4 || iStatus == 6))
				{
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
						bComplainantEmailOK = SendMailOrSystemMessage(sComplainantsEmail, 
							sComplainantEmailSubject, sComplainantEmailText, 
							sModeratorsEmail, sSiteShortName, false, iComplainantID, iSiteID);
					}
					else
					{
						bComplainantEmailOK = false;
					}

					if(!bComplainantEmailOK)
					{
						m_sErrorXML << "<ERROR TYPE='COMPLAINANT-EMAIL-FAILED'>Email failed to be sent to complainant for post (ID=" << iPostID << "), email address " << sComplainantsEmail << "</ERROR>";
						m_bErrors = true;
					}
				}
			}
		}
		else
		{
			// some kind of error so set the errors flag
			m_bErrors = true;
			// append some appropriate XML to the errors text
			// some missing data so give some kind of error report
			if (iModID <= 0 || iPostID <= 0 || iForumID <= 0 || iThreadID <= 0)
			{
				// data somehow lost
				m_sErrorXML << "<ERROR TYPE='MISSING-DATA'>There was some data missing from the request: either the ModID, PostID, ForumID or ThreadID</ERROR>";
			}
			if ((iStatus == 4 || iStatus == 6) && sEmailType.CompareText("None"))
			{
				// a failed posting was not given a reason
				m_sErrorXML << "<ERROR TYPE='MISSING-FAILURE-REASON'>No failure reason was provided for failed post (ID=" << iPostID << ")</ERROR>";
			}
		}
		// proceed to the next post to be processed
		i++;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CForumModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the posts moderation page.

*********************************************************************************/

bool CForumModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CForumModerationPageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

	CTDVString	sMessageXML;
	CTDVString	sShowType;
	CTDVString	sSubject;
	CTDVString	sText;
	CTDVString	sNotes;
	CTDVString	sCorrespondenceEmail;
	CTDVString	sComplaintText;
	CTDVString	sReferrerName;
	int			iReferrerID = 0;
	int			iComplainantID = 0;
	int			iReferrals = 0;
	int			iModID = 0;
	int			iPostID = 0;
	int			iThreadID = 0;
	int			iForumID = 0;
	int			iStatus = 0;
	bool		bSuccess = true;

	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}

	// find out what types of postings we are to fetch
	if (!m_InputContext.GetParamString("Show", sShowType))
	{
		sShowType = "LEGACY";
	}
	// make sure show type is all capitalised
	sShowType.MakeUpper();
	// find out if we are processing referrals or not
	iReferrals = m_InputContext.GetParamInt("Referrals");


	bool bFastMod = m_InputContext.GetParamInt("fastmod") != 0;
	bool bNotFastMod = true;	//defaults to true in case param is not provided
	if (m_InputContext.ParamExists("notfastmod"))
	{
		bNotFastMod = m_InputContext.GetParamInt("notfastmod") != 0;
	}

	// if we are fetching the next batch then do so, otherwise simply fetch
	// any posts that are currently locked by this user (hopefully none)
	bSuccess = bSuccess && m_pSP->FetchNextPostModerationBatch(
		pViewer->GetUserID(), sShowType, iReferrals, bFastMod, bNotFastMod);
	// create an appropriate message if there are no results
	if (m_pSP->IsEOF())
	{
		sMessageXML = "<MESSAGE TYPE='EMPTY-QUEUE'/>";
	}

	// now build the form XML
	int iFastMod = 0;
	int iNotFastMod = 0;
	if (bFastMod)
	{
		iFastMod = 1;
	}
	if (bNotFastMod)
	{
		iNotFastMod = 1;
	}
	*psFormXML = "";
	*psFormXML << "<POST-MODERATION-FORM TYPE='" << sShowType << "' REFERRALS='" << iReferrals << "' FASTMOD='" << iFastMod << "' NOTFASTMOD='" << iNotFastMod << "'>";
	*psFormXML << m_sErrorXML;
	*psFormXML << sMessageXML;
	while (bSuccess && !m_pSP->IsEOF())
	{
		iModID = m_pSP->GetIntField("ModID");
		iPostID = m_pSP->GetIntField("EntryID");
		iThreadID = m_pSP->GetIntField("ThreadID");
		iForumID = m_pSP->GetIntField("ForumID");
		m_pSP->GetField("Subject", sSubject);
		m_pSP->GetField("Text", sText);
		
		/*
			I've removed this, as it doesn't and never has existed in any of the result sets from the storedprocedures!
			This also begs the question of why are we putting this in the XML when it's always set to 0!!!
			iStatus = m_pSP->GetIntField("Status");
		*/
		
		m_pSP->GetField("Notes", sNotes);
		m_pSP->GetField("CorrespondenceEmail", sCorrespondenceEmail);
		m_pSP->GetField("ComplaintText", sComplaintText);
		iComplainantID = m_pSP->GetIntField("ComplainantID");
		int iSiteID = m_pSP->GetIntField("SiteID"); 
		bool bIsComplainantEditor = m_pSP->GetBoolField("IsEditor");
		// if referrals then get the referrers details
		if (iReferrals == 1)
		{
			iReferrerID = m_pSP->GetIntField("ReferrerID");
			m_pSP->GetField("ReferrerName", sReferrerName);
		}
		// escape any text before putting it in the form
		CXMLObject::EscapeAllXML(&sSubject);
		CXMLObject::EscapeAllXML(&sNotes);
		CXMLObject::EscapeAllXML(&sCorrespondenceEmail);
		CXMLObject::EscapeAllXML(&sComplaintText);
		// do all the translations on the text - smilies, links, etc.
		if (m_pSP->GetIntField("PostStyle") != 1) 
		{
			CXMLObject::DoPlainTextTranslations(&sText);
		}
		*psFormXML << "<POST>";
		*psFormXML << "<MODERATION-ID>" << iModID << "</MODERATION-ID>";
		*psFormXML << "<POST-ID>" << iPostID << "</POST-ID>";
		*psFormXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
		*psFormXML << "<FORUM-ID>" << iForumID << "</FORUM-ID>";
		*psFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		*psFormXML << "<TEXT>" << sText << "</TEXT>";
		*psFormXML << "<MODERATION-STATUS>" << iStatus << "</MODERATION-STATUS>";
		*psFormXML << "<NOTES>" << sNotes << "</NOTES>";

		if ( bIsComplainantEditor )
		{
			*psFormXML << "<COMPLAINANT-ID EDITOR='1'>" << iComplainantID << "</COMPLAINANT-ID>";
		}
		else
		{
			*psFormXML << "<COMPLAINANT-ID>" << iComplainantID << "</COMPLAINANT-ID>";
		}

		*psFormXML << "<CORRESPONDENCE-EMAIL>" << sCorrespondenceEmail << "</CORRESPONDENCE-EMAIL>";
		*psFormXML << "<COMPLAINT-TEXT>" << sComplaintText << "</COMPLAINT-TEXT>";
		*psFormXML << "<SITEID>" << iSiteID << "</SITEID>";

		// if referrals then output the referrers details
		if (iReferrals == 1)
		{
			*psFormXML << "<REFERRED-BY>";
			*psFormXML << "<USER>";
			*psFormXML << "<USERID>" << iReferrerID << "</USERID>";
			*psFormXML << "<USERNAME>" << sReferrerName << "</USERNAME>";
			*psFormXML << "</USER>";
			*psFormXML << "</REFERRED-BY>";
		}
		*psFormXML << "<ISPREMODPOSTING>" << m_pSP->GetIntField("IsPreModPosting") << "</ISPREMODPOSTING>";
		*psFormXML << "</POST>";
		m_pSP->MoveNext();
	}
	*psFormXML << "</POST-MODERATION-FORM>";
	return bSuccess;
}

#endif // _ADMIN_VERSION
