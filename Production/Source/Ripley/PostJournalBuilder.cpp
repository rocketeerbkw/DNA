// PostJournalBuilder.cpp: implementation of the CPostJournalBuilder class.
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
#include "PostJournalBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPostJournalBuilder::CPostJournalBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CPostJournalBuilder::~CPostJournalBuilder()
{

}

bool CPostJournalBuilder::Build(CWholePage* pPage)
{
	// Fetch all the parameters, we'll cope with the missing ones later
	CTDVString sBody;
	CTDVString sSubject;
	m_InputContext.GetParamString("subject", sSubject);
	m_InputContext.GetParamString("body", sBody);
	bool bPreview = m_InputContext.ParamExists("preview");
	bool bPost = m_InputContext.ParamExists("post");
	int iPostStyle = m_InputContext.GetParamInt("style");
	int iProfanityTriggered = m_InputContext.GetParamInt("profanitytriggered");
	int iNonAllowedURLsTriggered = m_InputContext.GetParamInt("nonallowedurltriggered");
	int iEmailAddressTriggered = m_InputContext.GetParamInt("nonallowedemailtriggered");

	if (iPostStyle < 1 || iPostStyle > 2) 
	{
		iPostStyle = 2;
	}

	CTDVString sWarning = "";		// Warning for errors

	CTDVString sInReplyToXML;
	
	CForum Forum(m_InputContext);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
		
	bool bPageSuccess = true;
	bPageSuccess = InitPage(pPage, "ADDJOURNAL",true);
	
	bool bSuccess = bPageSuccess;

	int iForumID = 0;
	if (pViewingUser != NULL)
	{
		pViewingUser->GetJournal(&iForumID);
	
	
	int site = 0;
	Forum.GetForumSiteID(iForumID,0,site);
	
		CTDVString sURL;
		sURL << "PostJournal";
		
		if (site > 0 && DoSwitchSites(pPage, sURL, m_InputContext.GetSiteID(), site, &pViewingUser))
		{
			return true;
		}
	}
	bool bUserIsPremoderated = false;
	if (pViewingUser != NULL && pViewingUser->GetIsPreModerated())
	{
		bUserIsPremoderated = true;
	}
	
	CTDVString sErrorMessage;
	CTDVString sPreviewBody = sBody;
	
	if (pViewingUser == NULL || pViewingUser->GetIsBannedFromPosting())
	{		
		CTDVString sXML;
		sXML = "<POSTJOURNALUNREG";
		if (pViewingUser != NULL)
		{
			if (pViewingUser->GetIsBannedFromPosting())
			{
				sXML << " RESTRICTED='1'";
			}
			sXML << " REGISTERED='1'";
		}
		sXML << "/>";
		pPage->AddInside("H2G2", sXML);
		
		return true;
	}
	else if ((bPost || bPreview) && (iPostStyle == 1))
	{
		CTDVString sCheckPreview = "<PREVIEWBODY>";
		sCheckPreview << sPreviewBody << "</PREVIEWBODY>";
		CTDVString ParseErrors = CForum::ParseXMLForErrors(sCheckPreview);
		if (ParseErrors.GetLength() > 0) 
		{
			sPreviewBody = "<PREVIEWBODY>";
			sPreviewBody << ParseErrors << "</PREVIEWBODY>";
			bPost = false;
		}
		else
		{
			sCheckPreview = "<PREVIEWBODY><RICHPOST>";
			sCheckPreview << sPreviewBody << "</RICHPOST></PREVIEWBODY>";
			sPreviewBody = sCheckPreview;
		}
	}
	if ((bPost || bPreview) && (sSubject.GetLength() == 0))
	{
		sWarning = "<WARNING TYPE='NOSUBJECT'>You must type a Subject for your Journal Entry</WARNING>";
	}
	else if ((bPost || bPreview) && (sBody.GetLength() == 0))
	{
		sWarning = "<WARNING TYPE='EMPTYBODY'>Your Journal Entry cannot be empty</WARNING>";
	}
	else if ((bPost || bPreview) && (sPreviewBody.GetLength() > 200*1024))
	{
		sWarning << "<WARNING TYPE='TOOLONG'>Your posting is too long.</WARNING>\n";
	}
	else if (iPostStyle != 1 && (bPost || bPreview) && (!m_InputContext.ConvertPlainText(&sPreviewBody, 200)))
	{
		sWarning << "<WARNING TYPE='TOOMANYSMILEYS'>Your posting contained too many smileys.</WARNING>\n";
	}
	else if (bPost && bSuccess)
	{
		// TODO Actually post the page
		int iUserID = 0;
		int iJournalID = 0;
		CTDVString sUsername;

		bSuccess = pViewingUser->GetUserID(&iUserID);
		bSuccess = bSuccess && pViewingUser->GetJournal(&iJournalID);
		bSuccess = bSuccess && pViewingUser->GetUsername(sUsername);

		bool bProfanityFound = false;
		bool bNonAllowedURLsFound = false;
		bool bEmailAddressFound = false;
		bSuccess = bSuccess && Forum.PostToJournal(iUserID, iJournalID, sUsername, sSubject,
			sBody, m_InputContext.GetSiteID(), iPostStyle, &bProfanityFound, &bNonAllowedURLsFound, &bEmailAddressFound );
		if (!bSuccess && bProfanityFound && !iProfanityTriggered)
		{
			iProfanityTriggered = 1;
		}
		else if (!bSuccess && bNonAllowedURLsFound && !iNonAllowedURLsTriggered)
		{
			iNonAllowedURLsTriggered = 1;
		}
		else if ( !bSuccess && bEmailAddressFound && !iEmailAddressTriggered )
		{
			iEmailAddressTriggered = 1;
		}
		else 
		{
			CTDVString sRedirect;
			sRedirect << "U" << iUserID;
			pPage->Redirect(sRedirect);

			return true;
		}		
	}

	// First, just output the form
	CTDVString sPage = "<POSTJOURNALFORM";
	sPage << " STYLE='" << iPostStyle << "' PROFANITYTRIGGERED='" << iProfanityTriggered << "' NONALLOWEDURLSTRIGGERED='" << iNonAllowedURLsTriggered << "' NONALLOWEDEMAILSTRIGGERED='" << iEmailAddressTriggered << "'>";

	CXMLObject::MakeSubjectSafe(&sSubject);
	CXMLObject::MakeSubjectSafe(&sBody);
	sPage << "<SUBJECT>" << sSubject << "</SUBJECT>\n";
	sPage << "<BODY>" << sBody << "</BODY>\n";
	if (sPreviewBody.GetLength() > 0 || sSubject.GetLength() > 0)
	{
		if (iPostStyle == 1) 
		{
			sPage << sPreviewBody;
		}
		else
		{
			sPage << "<PREVIEWBODY>" << sPreviewBody << "</PREVIEWBODY>";
		}
	}
	// Add any warning we might have generated
	if (sWarning.GetLength() > 0)
	{
		sPage << sWarning;
	}
	sPage << sInReplyToXML;

	if (m_InputContext.GetPreModerationState())
	{
		sPage << "<PREMODERATION>1</PREMODERATION>";
	}
	else if (bUserIsPremoderated)
	{
		sPage << "<PREMODERATION USER='1'>1</PREMODERATION>";
	}

	sPage << "</POSTJOURNALFORM>";
	bSuccess = pPage->AddInside("H2G2", sPage);
	TDVASSERT(bSuccess, "Failed to add inside in AddThreadBuilder");
	
	return bPageSuccess;
}
