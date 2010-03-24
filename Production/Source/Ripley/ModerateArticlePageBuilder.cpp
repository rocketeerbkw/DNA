// ModerateArticlePageBuilder.cpp: implementation of the CModerateArticlePageBuilder class.
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
#include "ModerateArticlePageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "GuideEntry.h"
#include "Club.h"
#include "TDVAssert.h"
#include "emailtemplate.h"
#include "MediaAsset.h"
#include "ArticleSearchPhrase.h"
#include "modreasons.h"
#include "moderatemediaassetsbuilder.h"
#include "mediaassetsearchphrase.h"
#include "mediaassetmodcontroller.h"
#include "UserGroups.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CModerateArticlePageBuilder::CModerateArticlePageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	05/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CModerateArticlePageBuilder object.

*********************************************************************************/

CModerateArticlePageBuilder::CModerateArticlePageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_sCommand(""),
	m_sErrorXML(""),
	m_ih2g2ID(0),
	m_bErrors(false),
	m_RefereeList(inputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CModerateArticlePageBuilder::~CModerateArticlePageBuilder()

	Author:		Kim Harries
	Created:	05/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CModerateArticlePageBuilder::~CModerateArticlePageBuilder()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CModerateArticlePageBuilder::AddArticleData(CWholePage* pWholePage, 
												 CTDVString& sEditLink,
												 bool& bEditable)

	Author:		Igor Loboda
	Created:	11/02/2002
	Inputs:		pWholePage - the page object to output the article data
	Outputs:	sEditLink - text for edit link
				bEditable - true if article could be edited
	Returns:	true on success
	Purpose:	To get the article data for the article being moderated

*********************************************************************************/

bool CModerateArticlePageBuilder::AddArticleData(CWholePage* pWholePage, 
												 CTDVString& sEditLink,
												 bool& bEditable)
{
	CGuideEntry entry(m_InputContext);
	bool bSuccess = true;
	if (m_ih2g2ID > 0)
	{
		// check for edit permission first
		CUser* pViewer = m_InputContext.GetCurrentUser();

		// need the h2g2ID to get the data
		bSuccess = bSuccess && entry.Initialise(m_ih2g2ID, m_InputContext.GetSiteID(), pViewer, true, true, true, false, true);

		if (bSuccess && entry.HasEditPermission(pViewer))
		{
			bEditable = true;
			sEditLink << m_ih2g2ID;
		}
		if (bSuccess)
		{
			CTDVString sArticleXML;
			CTDVString sErrors;
			CTDVString sErrorLine;
			int iLine;
			int iChar;

			// get the article in text form and see if the xslt parser chokes on it
			entry.GetAsString(sArticleXML);
			if (m_InputContext.GetParsingErrors(sArticleXML, &sErrors, &sErrorLine, 
												&iLine, &iChar))
			{
				bSuccess = bSuccess && pWholePage->AddInside("H2G2", &entry);
			}
			else
			{
				bSuccess = bSuccess && pWholePage->AddInside("H2G2", 
					"<ARTICLE><ERROR TYPE='XML-PARSE-ERROR'>Error parsing GuideML</ERROR></ARTICLE>");
			}
		}

		if (bSuccess)
		{
			if (entry.IsTypeOfClub())
			{
				CClub Club(m_InputContext);
				if (Club.InitialiseViaH2G2ID(m_ih2g2ID,true))
				{
					bSuccess = bSuccess && pWholePage->AddInside("H2G2", &Club);
				}
			}
		}
		// then add the guide entry XML into the page
	}
	else
	{
		// if no h2g2ID then put some XML in to that effect
		bSuccess = bSuccess && pWholePage->AddInside("ARTICLE-MODERATION-FORM", 
													"<MESSAGE TYPE='NO-ARTICLE'/>");
	}

	return bSuccess;
}

/*********************************************************************************

	CWholePage* CModerateArticlePageBuilder::Build()

	Author:		Kim Harries
	Created:	05/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate articles.

*********************************************************************************/

bool CModerateArticlePageBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "ARTICLE", false);
	// get current user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	// create UI object
	CPageUI UI(m_InputContext);
	bool bSuccess = UI.Initialise(pViewer);

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", 
			"<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor.</ERROR>");
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
		// then create the XML for the form to be displayed
		if (bSuccess && m_sCommand.CompareText("Next"))
		{
			// now build the form XML
			CTDVString	sEditLink = "UserEdit";
			bool		bEditable = false;
			CTDVString	sFormXML = "";
			bSuccess = bSuccess && CreateForm(pViewer, &sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);
			// insert the article data into the page
			bSuccess = bSuccess && AddArticleData(pWholePage, sEditLink, bEditable);
			// set the edit button visibility and link
			bSuccess = bSuccess && UI.SetEditPageVisibility(bEditable, sEditLink);

			
			if (bSuccess && m_ih2g2ID != 0)
			{
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CArticleSearchPhrase oArticleKeyPhrase(m_InputContext,delimit);

				// Fetch and add media asset xml
				if(!oArticleKeyPhrase.GetKeyPhrasesFromArticle(m_ih2g2ID))
				{
					TDVASSERT(false, "CModerateArticlePageBuilder::Build() oArticleKeyPhrase.GetKeyPhrasesFromArticle() failed");
					bSuccess = false;
				}
				else
				{
					if(!pWholePage->AddInside("H2G2", &oArticleKeyPhrase))
					{
						TDVASSERT(false, "CModerateArticlePageBuilder::Build() oArticleKeyPhrase pWholePage->AddInside failed");
						bSuccess = false;
					}
				}
			}

			if (bSuccess && m_ih2g2ID != 0)
			{
				CMediaAsset oMediaAssets(m_InputContext); //For handling linked media assets
				// Fetch and add media asset xml
				if(!oMediaAssets.ExternalGetLinkedArticleAsset(m_ih2g2ID, m_InputContext.GetSiteID()))
				{
					TDVASSERT(false, "CModerateArticlePageBuilder::Build() oMediaAssets.ExternalGetLinkedArticleAsset() failed");
					bSuccess = false;
				}
				else
				{
					if(!pWholePage->AddInside("H2G2", &oMediaAssets))
					{
						TDVASSERT(false, "CModerateArticlePageBuilder::Build() oMediaAssets pWholePage->AddInside failed");
						bSuccess = false;
					}
				}
			}

			CTDVString sSiteXML;
			bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

			bSuccess = bSuccess && m_RefereeList.FetchTheList();
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", &m_RefereeList);
		}
		else //this is for Done command
		if (bSuccess && !m_bErrors)
		{
			if ( CheckAndUseRedirectIfGiven(pWholePage) )
				return bSuccess;

			if ( m_InputContext.GetParamInt("NewStyle") == 1 )
				pWholePage->Redirect("Moderate?NewStyle=1");
			else
				pWholePage->Redirect("Moderate");
		}
	}

	bSuccess = bSuccess && pWholePage->AddInside("H2G2", &UI);
	CModReasons modReasons(m_InputContext);
	modReasons.GetModReasons(0);
	pWholePage->AddInside("H2G2", &modReasons);

	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CModerateArticlePageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CModerateArticlePageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CModerateArticlePageBuilder::ProcessSubmission(CUser* pViewer)
{
	bool	bSuccess = true;
	bool	bAuthorMailSent = false;
	bool	bComplainantMailSent = false;
	// if we have a decision then process it
	int			ih2g2ID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			iReferTo = 0;
	int			iIsLegacy = 0;
	int			iEntryStatus = 0;
	CTDVString	sNotes;
	CTDVString	sEmailType;
	CTDVString	sAuthorsEmail;
	CTDVString	sAuthorEmailSubject;
	CTDVString	sAuthorEmailText;
	CTDVString	sInsertText;
	CTDVString	sComplainantsEmail;
	CTDVString	sComplainantEmailSubject;
	CTDVString	sComplainantEmailText;
	CTDVString	sArticleSubject;
	CTDVString	sArticleText;
	CTDVString	sTemp;
	CTDVString	sCustomText;
	CTDVString  sMimeType;

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
	// get all the relevant data on the decision
	ih2g2ID = m_InputContext.GetParamInt("h2g2ID");
	iModID = m_InputContext.GetParamInt("ModID");
	iStatus = m_InputContext.GetParamInt("Decision");
	iReferTo = m_InputContext.GetParamInt("ReferTo");
	if (!m_InputContext.GetParamString("Notes", sNotes))
	{
		sNotes = "";
	}
	if (!m_InputContext.GetParamString("EmailType", sEmailType))
	{
		sEmailType = "None";
	}
	if (!m_InputContext.GetParamString("MimeType", sMimeType))
	{
		sMimeType = "";
	}

	// do an update for this article if we have an h2g2ID and ModID
	if (ih2g2ID > 0 && iModID > 0)
	{
		// make sure there is no missing data
		if (iStatus == 4 && sEmailType.CompareText("None"))
		{
			// some data was missing so provide an error report
			// set the errors flag
			m_bErrors = true;
			// append some appropriate XML to the errors text
			// some missing data so give some kind of error report
			if (iStatus == 4 && sEmailType.CompareText("None"))
			{
				// a failed posting was not given a reason
				m_sErrorXML << "<ERROR TYPE='MISSING-FAILURE-REASON'>No failure reason was provided for failed entry A" << ih2g2ID << "</ERROR>";
			}
		}
		else if (iStatus == 5)
		{
			// unreferring an item is not quite the same as making a decision on it
			bSuccess = bSuccess && m_pSP->UnreferArticle(iModID, pViewer->GetUserID(), sNotes);
		}
		else
		{
			//this is for sending email
			int iSiteID;
			iSiteID = m_InputContext.GetParamInt("SiteID");
			int	iAuthorID = 0; 
			int	iComplainantID = 0; 

			CTDVString sModeratorsEmail;
			CTDVString sSiteShortName;
			m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
			m_InputContext.GetShortName(sSiteShortName, iSiteID);

			// Get the text in the custom box
			bSuccess = bSuccess && m_InputContext.GetParamString("CustomEmailText", 
				sCustomText);
			if (sCustomText.GetLength() > 0)
			{
				sNotes << "\r\n-----email insert------\r\n" << sCustomText;
			}

			bSuccess = bSuccess && m_pSP->UpdateArticleModeration(ih2g2ID, iModID, 
				iStatus, sNotes, iReferTo, pViewer->GetUserID());


			// get the details of the author and complainant
			bSuccess = bSuccess && m_pSP->GetField("AuthorsEmail", sAuthorsEmail);
			iAuthorID = m_pSP->GetIntField("AuthorID");
			bSuccess = bSuccess && m_pSP->GetField("ComplainantsEmail", sComplainantsEmail);
			iComplainantID = m_pSP->GetIntField("ComplainantID");
			// also get field saying if this is a legacy item
			iIsLegacy = m_pSP->GetIntField("IsLegacy");
			// get the entry status so we can check if it is an edited entry
			iEntryStatus = m_pSP->GetIntField("EntryStatus");
			// also need to get subject and text of guide entry
			bSuccess = bSuccess && m_pSP->FetchArticleDetails(ih2g2ID / 10);
			bSuccess = bSuccess && m_pSP->GetField("Subject", sArticleSubject);
			bSuccess = bSuccess && m_pSP->GetField("Text", sArticleText);

			bool bComplaint = false;
			if (sComplainantsEmail.GetLength() > 0 || (m_InputContext.IsSystemMessagesOn(iSiteID) && iComplainantID > 0))
			{
				bComplaint = true;
			}

			//Moderate media asset if one exists.
			int iMediaAssetId = m_InputContext.GetParamInt("MediaAssetID");
			int iMediaAssetHiddenStatus=0;

			if (iMediaAssetId)
			{
				CMediaAssetModController oMediaAssetModController(m_InputContext);
				if (iStatus == 4 || iStatus == 6)
				{
					iMediaAssetHiddenStatus = 1;
					oMediaAssetModController.Reject(iMediaAssetId, sMimeType, bComplaint);
				}
				else if (iStatus == 2)
				{
					iMediaAssetHiddenStatus = 2;
					oMediaAssetModController.Requeue(iMediaAssetId, sMimeType, bComplaint);
				}
				else
				{
					iMediaAssetHiddenStatus = 0;
					oMediaAssetModController.Approve(iMediaAssetId, sMimeType, bComplaint);
				}
				bSuccess = bSuccess && m_pSP->HideMediaAsset(iMediaAssetId, iMediaAssetHiddenStatus);
			}

			// don't notify author of legacy moderations
			// send the appropriate emails to the author and/or complainant if necessary
			// first if failed and we have a reason (which we always should) send an explanation to the author
			CEmailTemplate m_Email(m_InputContext);

			if (iIsLegacy == 0 && (iStatus == 4 || iStatus == 6) 
				&& !sEmailType.CompareText("None"))
			{
				// This section sends mail to authors of the offending article only
				//-----------------------------------------------------------------

				// first get the overall email template
				if (iStatus == 4)
				{
					bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID, "ContentRemovedEmail", 
						sAuthorEmailSubject, sAuthorEmailText);
				}
				else if (iStatus == 6)
				{
					bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID, "ContentFailedAndEditedEmail", 
						sAuthorEmailSubject, sAuthorEmailText);
				}

				CXMLObject::UnEscapeXMLText(&sAuthorEmailSubject);
				CXMLObject::UnEscapeXMLText(&sAuthorEmailText);

				// then get the specific reason text
				bSuccess = bSuccess && m_Email.FetchInsertText(iSiteID, sEmailType, 
						sInsertText);

				CXMLObject::UnEscapeXMLText(&sInsertText);

				if (bSuccess)
				{
					// do any necessary translations
					CTDVString	sURL = "http://";
					CTDVString	sSiteRootURL;
					// construct the URL for the post
					m_InputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
					sURL << sSiteRootURL << "A" << ih2g2ID;
					// first place the insert text before doing any of the other translations, so
					// that any place holders in the inserted text will also be translated
					sAuthorEmailText.Replace("++**inserted_text**++", sInsertText);
					sAuthorEmailText.Replace("++**inserted_text**++", sCustomText);
					// now do the other replacements
					sAuthorEmailSubject.Replace("++**content_type**++", "Content");
					sAuthorEmailText.Replace("++**content_type**++", "Content");
					sAuthorEmailText.Replace("++**add_content_method**++", "contribute it");
					sAuthorEmailText.Replace("++**content_url**++", sURL);
					sAuthorEmailSubject.Replace("++**content_subject**++", sArticleSubject);
					sAuthorEmailText.Replace("++**content_subject**++", sArticleSubject);
					sAuthorEmailText.Replace("++**content_text**++", sArticleText);
					// if entry is an edited one then send email only in house
					if (iEntryStatus == 1 || iEntryStatus == 9 || iEntryStatus == 10)
					{
						sAuthorsEmail = sModeratorsEmail;
					}
					// then send the message
					bAuthorMailSent = SendMailOrSystemMessage(sAuthorsEmail, sAuthorEmailSubject, 
						sAuthorEmailText, sModeratorsEmail, 
						sSiteShortName, false, iAuthorID, iSiteID);
				}
				else
				{
					bAuthorMailSent = false;
				}

				if (!bAuthorMailSent)
				{
					m_sErrorXML << "<ERROR TYPE='AUTHOR-EMAIL-FAILED'>Email notification to author was not successful</ERROR>";
				}
			}

			// second, if a complaint and either passed or failed, then let the complainant know the decision
			//-----------------------------------------------------------------------------------------------

			if (bSuccess && (sComplainantsEmail.GetLength() > 0 || (m_InputContext.IsSystemMessagesOn(iSiteID) && iComplainantID >  0))
				&& (iStatus == 3 || iStatus == 4 || iStatus == 6))
			{
				// get the appropriate email template depending on whether it is a pass or fail
				if (iStatus == 3)
				{
					// pass => complaint was overruled
					bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID, "RejectComplaintEmail",
						sComplainantEmailSubject, sComplainantEmailText);
				}
				else 
				if (iStatus == 4)
				{
					// fail => complaint was upheld
					bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID, "UpholdComplaintEmail",
						sComplainantEmailSubject, sComplainantEmailText);
				}
				else 
				if (iStatus == 6)
				{
					// fail => complaint was upheld, but entry was edited and left in the 
					// guide
					bSuccess = bSuccess && m_Email.FetchEmailText(iSiteID, 
						"UpholdComplaintEditEntryEmail",
						sComplainantEmailSubject, sComplainantEmailText);
				}

				CXMLObject::UnEscapeXMLText(&sComplainantEmailSubject);
				CXMLObject::UnEscapeXMLText(&sComplainantEmailText);

				if (bSuccess)
				{
					// do any necessary template substitutions
					// => just putting in the complaint reference number currently
					CTDVString	sRefNumber = "A";
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
					bComplainantMailSent = SendMailOrSystemMessage(sComplainantsEmail, 
						sComplainantEmailSubject, sComplainantEmailText, 
						sModeratorsEmail, sSiteShortName, false, iComplainantID, iSiteID);
				}
				else
				{
					bComplainantMailSent = false;
				}

				if (!bComplainantMailSent)
				{
					m_sErrorXML << "<ERROR TYPE='COMPLAINANT-EMAIL-FAILED'>Email notification to complainant was not successful</ERROR>";
				}

			}
			if (bSuccess)
			{	
				//Add phrases and associated namespaces to parser.
				int iKeyPhrasesToRemove = m_InputContext.GetParamCount("DisassociatePhraseNameSpaceIds");
				std::vector<int> ids;
				for (int i = 0; i < iKeyPhrasesToRemove; i++)
				{
					ids.push_back(m_InputContext.GetParamInt("DisassociatePhraseNameSpaceIds", i));
				}


				//If there are any phrases remove from article and assest if if exists.
				//Collect the phrases removed and apply to media assets.
				CTDVString sPhrasesRemoved;
				if ( !ids.empty() )
				{
					CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
					CArticleSearchPhrase oArticleKeyPhrase(m_InputContext,delimit);
					if ( oArticleKeyPhrase.RemoveKeyPhrasesFromArticle(ih2g2ID, ids) )
					{
						sPhrasesRemoved = oArticleKeyPhrase.GetPhraseListAsString();
					}
				}
                    
					if (iMediaAssetId)
					{
					CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
					CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);
					oMediaAssetSearchPhrase.RemoveKeyPhrasesFromAsset(iMediaAssetId, sPhrasesRemoved);
				}
			}
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CModerateArticlePageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the moderate article page.

*********************************************************************************/

bool CModerateArticlePageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CModerateArticlePageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

	CTDVString	sShowType;
	CTDVString	sMessageXML = "";
	CTDVString	sNotes;
	CTDVString	sComplaintText;
	CTDVString	sCorrespondenceEmail;
	CTDVString	sReferrerName;
	int			iReferrerID = 0;
	int			iComplainantID = 0;
	int			iModID = 0;
	int			iEntryID = 0;
	int			iStatus = 0;
	int			iReferrals = 0;
	bool		bIsComplaint = false;
	bool		bSuccess = true;
    int         iSiteID = 0;

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
	// find out what types of article we are fetching
	if (!m_InputContext.GetParamString("Show", sShowType))
	{
		sShowType = "LEGACY";
	}
	// make sure show type is all uppercase
	sShowType.MakeUpper();
	
	// see if we are processing referrals or not
	iReferrals = m_InputContext.GetParamInt("Referrals");

	//New Style Moderation grants access to superusers.
	bool bAllowSuperUserAccess = m_InputContext.GetParamInt("NewStyle") == 1;
	bAllowSuperUserAccess = bAllowSuperUserAccess && m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser();

	// produce appropriate form depending on the command
	// fetch the next article for moderation from the queue
	if ( m_InputContext.GetParamInt("NewStyle") == 1 )
	{
		bool bIsSuperUser = m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser();
		bool bAlerts = m_InputContext.GetParamInt("alerts") == 1;
		bool bLockedItems = m_InputContext.GetParamInt("locked") == 1;
		int iModClassId = m_InputContext.GetParamInt("ModClassId");
		bSuccess = bSuccess && m_pSP->GetModerationArticles(pViewer->GetUserID(), bIsSuperUser, bAlerts, iReferrals != 0, bLockedItems, iModClassId );
		
		if ( bAlerts )
			sShowType = "COMPLAINTS";
		else
			sShowType = "NEW";
	}
	else
	{
		bSuccess = bSuccess && m_pSP->FetchNextArticleModerationBatch(pViewer->GetUserID(), sShowType, iReferrals );

	}

	// build the XML
	if (bSuccess)
	{
		if (m_pSP->IsEOF())
		{
			sMessageXML = "<MESSAGE TYPE='EMPTY-QUEUE'>There are no more articles of this type waiting to be processed at this time.</MESSAGE>";
		}
		else
		{
			iModID = m_pSP->GetIntField("ModID");
			iEntryID = m_pSP->GetIntField("EntryID");
			m_ih2g2ID = m_pSP->GetIntField("h2g2ID");
			iStatus = m_pSP->GetIntField("Status");
            iSiteID = m_pSP->GetIntField("SiteId");

			// if referrals then get the referrers details
			if (iReferrals == 1)
			{
				iReferrerID = m_pSP->GetIntField("ReferrerID");
				m_pSP->GetField("ReferrerName", sReferrerName);
			}
			if (m_pSP->FieldExists("Notes"))
			{
				m_pSP->GetField("Notes", sNotes);
			}
			else
			{
				sNotes = "";
			}
			bIsComplaint = !m_pSP->IsNULL("ComplaintID");
			iComplainantID = m_pSP->GetIntField("ComplainantID");
			if (m_pSP->FieldExists("ComplaintText"))
			{
				m_pSP->GetField("ComplaintText", sComplaintText);
			}
			else
			{
				sComplaintText = "";
			}
			if (m_pSP->FieldExists("CorrespondenceEmail"))
			{
				m_pSP->GetField("CorrespondenceEmail", sCorrespondenceEmail);
			}
			else
			{
				sCorrespondenceEmail = "";
			}
		}

		// now build the form XML
		*psFormXML = "";
		*psFormXML << "<ARTICLE-MODERATION-FORM TYPE='" << sShowType << "' REFERRALS='" << iReferrals << "'>";
		*psFormXML << m_sErrorXML;
		*psFormXML << sMessageXML;
		*psFormXML << "<ARTICLE>";
		*psFormXML << "<MODERATION-ID>" << iModID << "</MODERATION-ID>";
		*psFormXML << "<ENTRY-ID>" << iEntryID << "</ENTRY-ID>";
		*psFormXML << "<H2G2-ID>" << m_ih2g2ID << "</H2G2-ID>";
		*psFormXML << "<MODERATION-STATUS>" << iStatus << "</MODERATION-STATUS>";
		CXMLObject::EscapeAllXML(&sNotes);
		*psFormXML << "<NOTES>" << sNotes << "</NOTES>";

        // Complainant XML
        *psFormXML << "<COMPLAINT>";
        *psFormXML << "<USER>";
        *psFormXML << "<USERID>" << iComplainantID << "</USERID>";
		CXMLObject::EscapeAllXML(&sCorrespondenceEmail);
		*psFormXML << "<EMAIL>" << sCorrespondenceEmail << "</EMAIL>";
        if ( bIsComplaint )
        {
            CTDVString sGroupsXML;
            if ( m_InputContext.GetUserGroups(sGroupsXML,iComplainantID, iSiteID) )
            {
                *psFormXML << sGroupsXML;
            }
        }
        *psFormXML << "</USER>";

		CXMLObject::EscapeAllXML(&sComplaintText);
		*psFormXML << "<COMPLAINT-TEXT>" << sComplaintText << "</COMPLAINT-TEXT>";
        *psFormXML << "</COMPLAINT>";

		// if referrals then output the referrers details
		if (iReferrals == 1)
		{
			*psFormXML << "<REFERRED-BY>";
			*psFormXML << "<USER>";
			*psFormXML << "<USERID>" << iReferrerID << "</USERID>";
			*psFormXML << "<USERNAME>";
			if (iReferrerID == 0)
			{
				*psFormXML << "No referrer details";
			}
			else
			{
				*psFormXML << sReferrerName;
			}
			*psFormXML << "</USERNAME>";
			*psFormXML << "</USER>";
			*psFormXML << "</REFERRED-BY>";
		}
		*psFormXML << "</ARTICLE>";
		*psFormXML << "</ARTICLE-MODERATION-FORM>";
	}
	return bSuccess;
}

#endif // _ADMIN_VERSION
