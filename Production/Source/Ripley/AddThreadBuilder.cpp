// AddThreadBuilder.cpp: implementation of the CAddThreadBuilder class.
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
#include "tdvassert.h"
#include "Forum.h"
#include "PageUI.h"
#include "User.h"
#include "AddThreadBuilder.h"
#include "ReviewForum.h"
#include "GuideEntry.h"
#include "ThreadSearchPhrase.h"
#include "StoredProcedure.h"
#include ".\EmailAlertList.h"
#include "team.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CAddThreadBuilder::CAddThreadBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CAddThreadBuilder::~CAddThreadBuilder()
{

}

/*********************************************************************************

	CWholePage* CAddThreadBuilder::Build()

	Author:		Jim Lynn
	Created:	19/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	CWholePage containing the page the output.
	Purpose:	Performs the Forum posting and preview. The parameters it will be
				expecting are:
				forum: which forum is this posting for?
				threadid: thread in the forum
				inreplyto: PostID we're replying to
				article: h2g2id of the article we linked from so that we can
						return to the article rather than the forum
				userid: id of the user whose page we're responding to
				subject: subject of the post
				body: body of the post
				preview: name of preview button
				post: name of Post button.

				The XML output looks like this:
				<H2G2 TYPE="ADDTHREAD">
					<VIEWING-USER/>
					<PAGEUI/>
					<POSTTHREADFORM FORUMID='123' THREADID='123'>
						<RETURNTO>
							<H2G2ID>123</H2G2ID>
							or 
							<USERID>123</USERID>
						</RETURNTO>
						<SUBJECT></SUBJECT>
						<BODY></BODY>
						<PREVIEWBODY></PREVIEWBODY>
						<INREPLYTO>
							<POSTID>123</POSTID>
							<USERNAME>123</USERNAME>
							<BODY></BODY>
						</INREPLYTO>
					</POSTTHREADFORM>
				</H2G2>

*********************************************************************************/

bool CAddThreadBuilder::Build(CWholePage* pPage)
{
	// Fetch all the parameters, we'll cope with the missing ones later
	int iForumID = m_InputContext.GetParamInt("forum");
	int iThreadID = m_InputContext.GetParamInt("threadid");
	int iReplyTo = m_InputContext.GetParamInt("inreplyto");
	int iArticle = m_InputContext.GetParamInt("article");
	int iClub = m_InputContext.GetParamInt("club");
	int iUserID = m_InputContext.GetParamInt("userid");
	int iUserForumID = m_InputContext.GetParamInt("userforumid");
	int iUserForumPublic = m_InputContext.GetParamInt("userforumpublic");
	int iPostStyle = m_InputContext.GetParamInt("style");
	
	// We don't care about this parameter any more. It used be used to implement
	// a 'one strike and you're out' flow, but this was removed pretty quickly
	// so we no longer care that this flag is being sent back to us.
	int iProfanityTriggered = 0;   // m_InputContext.GetParamInt("profanitytriggered");
	int iNonAllowedURLsTriggered = m_InputContext.GetParamInt("nonallowedurltriggered");

	{//This code section is used for sending private messages to other users using their userids 
		//Added code to extract the ‘posttothisuser’ parameter if it is available. This parameter’s value if the userID of the user a private message is intended for. This value is
		//Used to obtain the user’s team forum id and the user’s article’s guide entry id. Both of these fields are need for sending private message. If the user id is invalid or if any of 
		//these two values can’t be obtained, an error message is returned to the client 

		int iPostToUser = m_InputContext.GetParamInt("posttothisuser");
		if ( iPostToUser > 0 )
		{
			CUser oUser(m_InputContext);
			if( oUser.CreateFromID(iPostToUser) == true)
			{
				if ( oUser.GetMasthead( &iArticle) == false)
				{
					return SetDNALastError("CAddThreadBuilder::Build","UnableToObtainUserMastHead","Was unable to obtain user mastHead!");
				}

				int iTeamID = 0;
				if ( oUser.GetTeamID(&iTeamID ) == false)
				{
					return SetDNALastError("CAddThreadBuilder::Build","UnableToObtainUserTeamID","Was unable to obtain user team id !");
				}

				CTeam oTeam ( m_InputContext);
				if ( oTeam.GetForumIDForTeamID(iTeamID, iForumID) == false)
				{
					return SetDNALastError("CAddThreadBuilder::Build","UnableToObtainForumIDForTeam","Was unable to obtain forumid for team!");
				}
			}
			else
			{
				return SetDNALastError("CAddThreadBuilder::Build","UnableToObtainUserDetailsFromID","Was unable to obtain user details from id!");
			}
		}
	}

	int iPostIndex = 0;
	if (iPostStyle < 1 || iPostStyle > 2) 
	{
		iPostStyle = 2;
	}
	CTDVString sAction;
	bool bGotAction = m_InputContext.GetParamString("action",sAction);
	CTDVString sBody;
	CTDVString sSubject;
	CTDVString sReplyToUsername;
	CTDVString sReplyToSiteSuffix;
	CTDVString sReplyToBody;
	CTDVString sReplyToSubject;
	m_InputContext.GetParamString("subject", sSubject);
	m_InputContext.GetParamString("body", sBody);

	bool bPreview = m_InputContext.ParamExists("preview");
	bool bPost = m_InputContext.ParamExists("post");
	

	// Check to see if they want to add the previous quote in their message
	bool bQuotePreviousMessage = m_InputContext.ParamExists("AddQuote");

	// See if we're wanting to be alerted on replies to the thread?
	CTDVString sAlertOnRelpy;
	m_InputContext.GetParamString("AlertOnReply",sAlertOnRelpy);

	// If a user's forum has been specified, override the other forum id (if it's passed it at all)
	if (iUserForumID > 0 && iReplyTo == 0)
	{
		CUser User(m_InputContext);
		if (User.CreateFromID(iUserForumID))
		{
			if (iUserForumPublic == 0)
			{
				// Use the user's private forum
				int iPrivateForum = 0;
				if (User.GetPrivateForum(&iPrivateForum))
				{
					iForumID = iPrivateForum;
					iThreadID = 0;
				}
			}
			else
			{
				// User the user's public forum, which is the forum attached to the
				// user page article (i.e. mast head)
				int iMastHead = 0;
				if (User.GetMasthead(&iMastHead))
				{
					CGuideEntry GuideEntry(m_InputContext);
					GuideEntry.Initialise(iMastHead,m_InputContext.GetSiteID(), 0);
					iForumID = GuideEntry.GetForumID();
					iThreadID = 0;
				}
			}
		}
	}

	CForum Forum(m_InputContext);
	
	CTDVString sInReplyToXML;
	
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (iReplyTo > 0)
	{
		int iOldPostStyle = 2;
		int iReplyToUserID = 0;
		Forum.GetPostContents(pViewingUser, iReplyTo, &iForumID, &iThreadID, &sReplyToUsername, &sReplyToBody, &sReplyToSubject, &iOldPostStyle, &iPostIndex, &iReplyToUserID, &sReplyToSiteSuffix);

		// If required add the previous quote
		if (bQuotePreviousMessage)
		{
			// Put the opening quote tag in first
			sBody << "<quote";

			// See if we need to put the quote id in
			if (m_InputContext.ParamExists("AddQuoteID"))
			{
				sBody << " postid='" << iReplyTo << "'";
			}
			
			// Check to see if we're required to add the user detials
			if (m_InputContext.ParamExists("AddQuoteUser"))
			{
				sBody << " user='" << sReplyToUsername << "' userid='" << iReplyToUserID << "'";
			}

			// Now close the quote with the previous message text
			sBody << ">" << sReplyToBody << "</quote>";
		}

		if (iOldPostStyle != 1) 
		{
			CForum::MakeTextSafe(sReplyToBody);
		}
		CDBXMLBuilder XML;
		XML.Initialise(&sInReplyToXML);
		XML.OpenTag("INREPLYTO");
		XML.AddTag("USERNAME",sReplyToUsername);
		XML.AddTag("SITESUFFIX",sReplyToSiteSuffix);
		XML.AddIntTag("USERID",iReplyToUserID);

		// Make a copy of the body before it gets made safe, as we want to supply the raw text back to the XML
		CTDVString sRawBody = sReplyToBody;

		CXMLObject::MakeSubjectSafe(&sReplyToUsername);
		XML.AddTag("BODY",sReplyToBody);

		CXMLObject::EscapeXMLText(&sRawBody);
		XML.AddTag("RAWBODY",sRawBody);
		XML.CloseTag("INREPLYTO");

/*
		sInReplyToXML << "<INREPLYTO>"
			<< "<USERNAME>" << sReplyToUsername << "</USERNAME>"
			<< "<USERID>" << iUserID << "</USERID>"
			<< "<BODY>" << sReplyToBody << "</BODY>"
			<< "<RAWBODY>" << sRawBody << "</RAWBODY>"
			<< "</INREPLYTO>";
*/
		if (sSubject.GetLength() == 0)
		{
			sSubject = sReplyToSubject;
		}
	}

	InitPage(pPage, "ADDTHREAD", true);
	//pPage->Initialise();
	//pPageUI->Initialise(pViewingUser);
	
	//pPage->AddInside("H2G2", pPageUI);
	
	//check if we are dealing with posting to a review forum at the top level
	if (iForumID > 0 && iReplyTo == 0)
	{
		CTDVString sReviewForumDetails;
		if (IsReviewForum(iForumID,sReviewForumDetails))
		{
			pPage->AddInside("H2G2",sReviewForumDetails);
			pPage->SetPageType("ADDTHREAD");
			return true;
		}
	}

	CTDVString sTempSubject = "";	// Subject of article
	int ID = 0;
	int type = 0;
	int site = 0;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	Forum.GetTitle(iForumID, iThreadID, true, &type, &ID, &sTempSubject, &site);
	pPage->AddInside("H2G2", &Forum);
	

	CTDVString sURL;
	sURL << "AddThread?forum=";
	sURL << iForumID;
	if (iThreadID > 0)
	{
		sURL << "&amp;thread=" << iThreadID;
	}
	if (iReplyTo > 0)
	{
		sURL << "&amp;inreplyto=" << iReplyTo;
	}
	if (iArticle > 0)
	{
		sURL << "&amp;article=" << iArticle;
	}
	if ( iClub > 0 )
	{
		sURL << "&amp;club=" << iClub;
	}
	if (iUserID > 0)
	{
		sURL << "&amp;userid=" << iUserID;
	}
	
//	bool bSwapSkins = true;
//	if (type == 0 || type == 2 || type == 4)
//	{
//		bSwapSkins = false;
//	}
	
	// Check to see if we're needed to change sites or skins?-
	if (DoSwitchSites(pPage, sURL, m_InputContext.GetSiteID(), site, &pViewingUser))
	{
		return true;
	}

	bool bProfanityFound = false;
	bool bNonAllowedURLsFound = false;
	bool bEmailAddressFound = false;

	bool bUserIsPremoderated = false;
	if  ( pViewingUser != NULL && pViewingUser->GetIsPreModerated() )
	{
		bUserIsPremoderated = true;
	}
	
	bool bSuccess = true;
	CTDVString sErrorMessage;
	CTDVString sPostingError;

	// Create the preview body text, so we don't change anything the user has typed in!
	/*
		FROM HERE ON IT GETS MISSLEADING AS PREVIEWTAGS ARE USED EVEN THOUGH WE MAY NOT BE IN PREVIEW MODE!!!
		DO NOT CHANGE THIS AS IT@S BEEN LIKE THIS FROM DAY 1!!!
	*/
	CTDVString sPreviewBody = sBody;

	// Check to see if the posting is allowed because of length issues
	if (sPreviewBody.GetLength() > 200*1024)
	{
		sPostingError << "<PREVIEWERROR TYPE='TOOLONG'>Your posting is too long.</PREVIEWERROR>\n";
	}
	else if (iPostStyle == 1 && sPreviewBody.GetLength() > 0)
	{
		CTDVString RichPreview;
		RichPreview << "<PREVIEWBODY><RICHPOST>" << sPreviewBody << "</RICHPOST></PREVIEWBODY>";

		CTDVString sCheckPreview;
		sCheckPreview << "<PREVIEWBODY>" << sPreviewBody << "</PREVIEWBODY>";

		CTDVString ParseErrors = CForum::ParseXMLForErrors(sCheckPreview);
		if (ParseErrors.GetLength() > 0) 
		{
			sPreviewBody = "<PREVIEWBODY>";
			sPreviewBody << ParseErrors << "</PREVIEWBODY>";
			bPost = false;
		}
		else
		{
			sPreviewBody = RichPreview;
		}
	}
	else if (!m_InputContext.ConvertPlainText(&sPreviewBody, 200))
	{
		sPostingError << "<PREVIEWERROR TYPE='TOOMANYSMILEYS'>Your posting contained too many smileys.</PREVIEWERROR>\n";
	}

	// Now sPreviewBody is converted (or not) and sPostingError is blank or contains the error
	
	if (iPostStyle != 1 && sPreviewBody.GetLength() > 0) 
	{
		CTDVString sTemp = sPreviewBody;
		sPreviewBody.Empty();
		sPreviewBody << "<PREVIEWBODY>" << sTemp << "</PREVIEWBODY>";
	}

	if (pViewingUser == NULL || !pViewingUser->GetIsPostingAllowed() )
	{
//		if (iReplyTo > 0)
//		{
//			pForum->GetPostContents(iReplyTo, &iForumID, &iThreadID, &sReplyToUsername, &sReplyToBody, &sReplyToSubject);
//		}
		
		CTDVString sXML;
		sXML = "<POSTTHREADUNREG";
		sXML << " FORUMID='" << iForumID << "' THREADID='" << iThreadID;
		sXML << "' POSTID='";
		sXML << iReplyTo << "'";
		if (pViewingUser != NULL)
		{
			if ( pViewingUser->GetIsBannedFromPosting())
			{
				sXML << " RESTRICTED='1'";
			}
			sXML << " REGISTERED='1'";
		}
		sXML << "/>";
		pPage->AddInside("H2G2", sXML);
		pPage->SetPageType("ADDTHREAD");
		
		return true;
	}
	else if (bPreview || sPostingError.GetLength() > 0)
	{
		// TODO: Do the preview stuff
	}
	else if (bPost)
	{
		// TODO Actually post the page
		int iUserID = 0;
		int iNewThreadID = 0;
		int iNewPostID = 0;
		bSuccess = pViewingUser->GetUserID(&iUserID);
		
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CThreadSearchPhrase threadkeyphrases(m_InputContext, delimit);
		CTDVString sInputPhrases, sValidPhrases;
		if (m_InputContext.ParamExists("phrase"))
		{
			threadkeyphrases.BuildValidKeyPhraseList(sInputPhrases, sValidPhrases);
		}
		
		// Note that PostToForum will return false if the posting was queued, so
		// we should detect that fact and handle it differently

		bool bWasQueued = false;
		int bPreModPostingModId = false;
		bool bIsPreModerated = false;
		int iSeconds = 0;
		
		bool bIgnoreModeration = pViewingUser && (pViewingUser->GetIsSuperuser() || pViewingUser->GetIsEditor());
		bSuccess = bSuccess && Forum.PostToForum(pViewingUser, iForumID, iReplyTo,
			iThreadID, sSubject, sBody, iPostStyle, &iNewThreadID, &iNewPostID, 
			NULL, NULL, &bProfanityFound, iClub, 0, sValidPhrases, true, &bWasQueued,
			bIgnoreModeration, &iSeconds, &bNonAllowedURLsFound, &bPreModPostingModId, &bIsPreModerated,  &bEmailAddressFound );

		//Handle key phrases  associated with discussion.
		if ( bSuccess && m_InputContext.ParamExists("phrase") )
		{
			if ( pViewingUser && pViewingUser->IsUserLoggedIn()  )
			{
				for ( int index = 0; index < m_InputContext.GetParamCount("phrase"); ++index )
				{
					CTDVString sPhrase;
					m_InputContext.GetParamString("phrase",sPhrase,index);
					threadkeyphrases.ParsePhrases(sPhrase,true);
				}

				//Attempt to add key phrases.
				if ( !threadkeyphrases.AddKeyPhrases( iNewThreadID ) )
				{
					pPage->SetPageType("ADDTHREAD");
					pPage->AddInside("H2G2",threadkeyphrases.GetLastErrorAsXMLString());
				}
			}
			else
			{
				//User not authorised.
				SetDNALastError("CAddThread::Build","AddThread::Build","Unable to add key phrase(s) - user is not logged in.");
				pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
		}

		if (bWasQueued)
		{
			CTDVString sPreModMessage;
			sPreModMessage << "<POSTQUEUED FORUM='" << iForumID << "'";
			if (iThreadID == 0)
			{
				sPreModMessage << " NEWCONVERSATION='1'";
			}
			else
			{
				sPreModMessage << " THREAD='" << iThreadID << "'";
				sPreModMessage << " POST='" << iReplyTo << "'";
			}
			sPreModMessage << "/>";
			// premodertion is on
			pPage->AddInside("H2G2", sPreModMessage);
			pPage->SetPageType("ADDTHREAD");
		}
		else if (!bSuccess)
		{
			//Report Error / Validation Failure.
			if ( Forum.ErrorReported() )
			{
				pPage->AddInside("H2G2",Forum.GetLastErrorAsXMLString());
			}

			if (iArticle == 0)
			{
				SP.GetH2G2IDFromForumID(iForumID, &iArticle);
			}

			// GetPosting Permission
			bool bCanRead = true;
			bool bCanWrite = true;
			Forum.GetPostingPermission(pViewingUser, iForumID, iThreadID, bCanRead, bCanWrite);

			//post failed - check if this was because of a profanity filter block
			//05/07/05 - DJW - New behaviour - just keep looping til profanity not entered.
			if (bProfanityFound)
			{
				//if the profanity hasn't been triggered yet indicate now it has
				iProfanityTriggered = 1;
			}

			//post failed - check if this was because of a non allowed url filter block
			//just keep looping til non allowed url is not entered.
			if (bNonAllowedURLsFound)
			{
				//if the non allowed url hasn't been triggered yet indicate now it has
				iNonAllowedURLsTriggered = 1;
			}

			// iSeconds will be > 0 if the user posted before they are allowed to in this site

			CTDVString sXML;
			BuildPostThreadFormXML(sXML,iForumID,iThreadID,iReplyTo,iPostIndex,iProfanityTriggered,iSeconds,bCanWrite,iPostStyle,iArticle,iUserID,sSubject,sBody,sInReplyToXML,iNonAllowedURLsTriggered, int(bEmailAddressFound) );
			bSuccess = pPage->AddInside("H2G2", sXML);
		}
		else if ( bIsPreModerated )
		{
			CTDVString sPreModMessage;
			sPreModMessage << "<POSTPREMODERATED FORUM='" << iForumID << "' THREAD='" << iNewThreadID << "' POST='" << iNewPostID << "'";
			if (iThreadID == 0)
			{
				sPreModMessage << " NEWCONVERSATION='1'";
			}
			if (bUserIsPremoderated && !m_InputContext.GetPreModerationState())
			{
				sPreModMessage << " USERPREMODERATED='1'";
			}
			else if (pViewingUser->GetIsAutoSinBin())
			{
				sPreModMessage << " USERPREMODERATED='1' AUTOSINBIN='1'";
			}
			/*
			if (bProfanityFound)
			{
				sPreModMessage << " PROFANITYFOUND='1'";
			}
			*/
			if (bPreModPostingModId > 0)
			{
				sPreModMessage << " ISPREMODPOSTING='1'";
			}
			sPreModMessage << "/>";
			// premodertion is on
			pPage->AddInside("H2G2", sPreModMessage);
			pPage->SetPageType("ADDTHREAD");
		}
		else if (bGotAction) 
		{
			sAction.Replace("&","&amp;");
			sAction.Replace("<","&lt;");
			sAction.Replace(">","&gt;");
			pPage->Redirect(sAction);
		}
		else
		{
			CTDVString sRedirect;
			sRedirect << "F" << iForumID << "?thread=" << iNewThreadID << "&amp;post=" << iNewPostID << "#p" << iNewPostID;
			//if ( m_InputContext.ParamExists("phrase") )
			//{
			//	sRedirect << "&amp;phrase=";
			//}
			pPage->Redirect(sRedirect);
		}

		return true;
	}
	else
	{
		// This is the first time we've called the page
		// If we don't have a forumID, try and get it from the CForum object
		if (iForumID == 0)
		{
			// What if we get no replyto ID?
			if (iReplyTo == 0)
			{
				bSuccess = false;
				sErrorMessage = "No Forum or Post number was specified to reply to";
			}
			else
			{
//				bSuccess = pForum->GetPostContents(iReplyTo, &iForumID, &iThreadID, &sReplyToUsername, &sReplyToBody, &sReplyToSubject);
			}
		}
	}
	// GetPosting Permission
	bool bCanRead = true;
	bool bCanWrite = true;
	Forum.GetPostingPermission(pViewingUser, iForumID, iThreadID, bCanRead, bCanWrite);	

	// First, just output the form
	CTDVString sPage = "<POSTTHREADFORM";
	sPage << " FORUMID='" << iForumID << "' THREADID='" << iThreadID << "' INREPLYTO='" << iReplyTo << "' POSTINDEX='" << iPostIndex << "'"
		<< " PROFANITYTRIGGERED='" << iProfanityTriggered << "' NONALLOWEDURLSTRIGGERED='" << iNonAllowedURLsTriggered << "'";
	if (bCanWrite)
	{
		sPage << " CANWRITE='1'";
	}
	else
	{
		sPage << " CANWRITE='0'";
	}
	sPage << " STYLE='" << iPostStyle << "'";
	sPage << ">";
	if (iArticle > 0)
	{
		sPage << "<RETURNTO>\n<H2G2ID>" << iArticle << "</H2G2ID>\n</RETURNTO>\n";
	}
	else if (iUserID > 0)
	{
		sPage << "<RETURNTO>\n<USERID>" << iUserID << "</USERID>\n</RETURNTO>\n";
	}
	
	if (bGotAction) 
	{
		sAction.Replace("&","&amp;");
		sAction.Replace("<","&lt;");
		sAction.Replace(">","&gt;");
		sPage << "<ACTION>" << sAction << "</ACTION>\n";
	}

	//CXMLObject::MakeSubjectSafe(&sSubject);
	CXMLObject::EscapeAllXML(&sSubject);
	CXMLObject::EscapeAllXML(&sBody);
	sPage << "<SUBJECT>" << sSubject << "</SUBJECT>\n";
	sPage << "<BODY>" << sBody << "</BODY>\n";
	if (sPostingError.GetLength() > 0)
	{
		sPage << sPostingError;
	}
	else if (sPreviewBody.GetLength() > 0)
	{
		sPage << sPreviewBody;
	}

	// Add the added quote tag if we just have!
	if (bQuotePreviousMessage)
	{
		sPage << "<QUOTEADDED>1</QUOTEADDED>";
	}
	sPage << sInReplyToXML;

//	CStoredProcedure* pSP = m_InputContext.CreateStoredProcedureObject();
//	if (pSP != NULL)
//	{
		if (m_InputContext.GetPreModerationState())
		{
			sPage << "<PREMODERATION>1</PREMODERATION>";
		}
		else if (bUserIsPremoderated)
		{
			sPage << "<PREMODERATION USER='1'>1</PREMODERATION>";
		}
		/*
		else if (bProfanityFound)
		{
			sPage << "<PREMODERATION PROFANITY='1'>1</PREMODERATION>";
		}
		*/
//		delete pSP;
//		pSP = NULL;
//	}

	if (!pViewingUser->GetIsEditor() && !pViewingUser->GetIsNotable())
	{
		int iSeconds = 0;
		if (SP.CheckUserPostFreq(pViewingUser->GetUserID(),m_InputContext.GetSiteID(),iSeconds))
		{
			if (iSeconds > 0)
			{
				sPage << "<SECONDSBEFOREREPOST>" << iSeconds << "</SECONDSBEFOREREPOST>\n";
			}
		}
	}

	sPage << "</POSTTHREADFORM>";
	bSuccess = pPage->AddInside("H2G2", sPage);

	//Optimisation - Only pull out phrases if we are interested - thi sis only the england site
	//Need to use a site options mechanism when it becomes available.
	if ( m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","ThreadKeyPhrases") )
	{
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CThreadSearchPhrase searchphrase(m_InputContext,delimit);

		//Add Site Key Phrases.
		pPage->AddInside("H2G2","<THREADSEARCHPHRASE/>");
		if ( searchphrase.GetSiteKeyPhrasesXML() )
			pPage->AddInside( "H2G2/THREADSEARCHPHRASE",&searchphrase);

		//Create XML for current phrase search
		if ( m_InputContext.ParamExists("phrase") )
		{
			CTDVString sPhrases;
			for	( int index = 0; index < m_InputContext.GetParamCount("phrase"); ++index )
			{
				CTDVString sPhrase;
				m_InputContext.GetParamString("phrase",sPhrase,index);
				searchphrase.ParsePhrases(sPhrase,true);
			}
			bSuccess = pPage->AddInside("H2G2/THREADSEARCHPHRASE",searchphrase.GeneratePhraseListXML());
		}

		//Get all Phrases this thread belongs to
		if ( iReplyTo  && iThreadID )
		{
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CThreadSearchPhrase searchphrase(m_InputContext,delimit);
			if ( searchphrase.GetKeyPhrasesFromThread(iForumID, iThreadID) )
				pPage->AddInside("H2G2/POSTTHREADFORM",&searchphrase);
		}
	}

	//bSuccess = bSuccess && pPage->AddInside("VIEWING-USER",pViewingUser);
	TDVASSERT(bSuccess, "Failed to add inside in AddThreadBuilder");
	
	if (bSuccess)
	{
		pPage->SetPageType("ADDTHREAD");
		return true;
	}
	else
	{
		return false;
	}
}

bool CAddThreadBuilder::IsReviewForum(int iForumID,CTDVString& sReviewForumDetails)
{
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetReviewForumThreadList");
		sReviewForumDetails = "<ERROR TYPE='DBERROR'>There was a database error</ERROR>";
		return true;
	}

	int iReviewForumID = 0;
	CTDVString sReviewForumName;
	CTDVString sURLFriendlyName;

	if (mSP.IsForumAReviewForum(iForumID,&iReviewForumID))
	{
		CReviewForum mReviewForum(m_InputContext);
		if (mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
		{
			sReviewForumName = mReviewForum.GetReviewForumName();
			sURLFriendlyName = mReviewForum.GetURLFriendlyName();
			
			sReviewForumDetails = "<ERROR TYPE='REVIEWFORUM'>";
			sReviewForumDetails << "<REVIEWFORUM ID='" << iReviewForumID << "'>";
			sReviewForumDetails << "<REVIEWFORUMNAME>" << sReviewForumName << "</REVIEWFORUMNAME>";
			sReviewForumDetails << "<URLFRIENDLYNAME>" << sURLFriendlyName << "</URLFRIENDLYNAME>";
			sReviewForumDetails << "</REVIEWFORUM></ERROR>";

			return true;
		}
		else
		{
			sReviewForumDetails = "<ERROR TYPE='BADREVIEWFORUM'>Failed to Initialise Review Forum</ERROR>";
			return true;
		}
	}

	return false;
}

void CAddThreadBuilder::BuildPostThreadFormXML(CTDVString& sXML,int iForumID, int iThreadID,int iReplyTo, int iPostIndex,
												int iProfanityTriggered, int iSeconds, bool bCanWrite, int iPostStyle, int iArticle, int iUserID, 
												CTDVString& sSubject, CTDVString& sBody, CTDVString& sInReplyToXML, int iNonAllowedURLsTriggered, int iEmailAddressTriggered )
{
	sXML = "<POSTTHREADFORM";
	sXML << " FORUMID='" << iForumID << "' THREADID='" << iThreadID << "' INREPLYTO='" << iReplyTo << "' POSTINDEX='" << iPostIndex << "'"
		<< " PROFANITYTRIGGERED='" << iProfanityTriggered << "' NONALLOWEDURLSTRIGGERED='" << iNonAllowedURLsTriggered << "' NONALLOWEDEMAILSTRIGGERED='" << iEmailAddressTriggered << "'";
	if (iSeconds > 0)
	{
		sXML << " POSTEDBEFOREREPOSTTIMEELAPSED='1'";
	}
	if (bCanWrite)
	{
		sXML << " CANWRITE='1'";
	}
	else
	{
		sXML << " CANWRITE='0'";
	}
	sXML << " STYLE='" << iPostStyle << "'";
	sXML << ">";
	if (iArticle > 0)
	{
		sXML << "<RETURNTO>\n<H2G2ID>" << iArticle << "</H2G2ID>\n</RETURNTO>\n";
	}
	else if (iUserID > 0)
	{
		sXML << "<RETURNTO>\n<USERID>" << iUserID << "</USERID>\n</RETURNTO>\n";
	}
	
	CXMLObject::EscapeAllXML(&sSubject);
	CXMLObject::EscapeAllXML(&sBody);
	sXML << "<SUBJECT>" << sSubject << "</SUBJECT>\n";
	sXML << "<BODY>" << sBody << "</BODY>\n";
	
	if (iSeconds > 0)
	{
		sXML << "<SECONDSBEFOREREPOST>" << iSeconds << "</SECONDSBEFOREREPOST>\n";
	}

	bool bSiteClosed = false;
	if (m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(), bSiteClosed))
	{
		sXML << "<SITECLOSED>" << (bSiteClosed ? 1 : 0) << "</SITECLOSED>\n";
	}

	sXML << sInReplyToXML;

	sXML << "</POSTTHREADFORM>";
}
