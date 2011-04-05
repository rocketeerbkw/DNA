// XMLBuilder.cpp: implementation of the CXMLBuilder class.
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
#include "RipleyServer.h"
#include "XMLBuilder.h"
#include "PageBody.h"
#include "PageUI.h"
#include "tdvassert.h"
#include "WholePage.h"
#include "Link.h"
#include "Club.h"
#include "Topic.h"
#include "UnauthorisedBuilder.h"
#include "SiteConfigPreview.h"
#include "SiteOptions.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CXMLBuilder::~CXMLBuilder()
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CXMLBuilder class. No functionality in the base

*********************************************************************************/

CXMLBuilder::~CXMLBuilder()
{

}

/*********************************************************************************

	CXMLBuilder::CXMLBuilder(CInputContext& inputContext)

	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	23/02/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	constructs the CXMLBuilder base class. Takes a CGI InputContext ptr and a Database
				context pointer and stores them as member variables.

*********************************************************************************/

CXMLBuilder::CXMLBuilder(CInputContext& inputContext)
	:
	m_InputContext(inputContext)
{
	// set the context member variables

	m_AllowedUsers = USER_ANY;
}

/*********************************************************************************

	CWholePage* CXMLBuilder::Build()
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML representation of a page, NULL for failure
	Purpose:	Builds the Page using CXMLObject functions representing the page based on 
				the request (which is contained in a member variable).

*********************************************************************************/

bool CXMLBuilder::Build(CWholePage* pWholePage)
{
	CPageBody	PageBody(m_InputContext);

// Build a very basic default output indicating that the base class builder has been used
// changed 01/03/2000 to use PageBody instead of CreateFromXMLText - Kim
	bool bSuccess = InitPage(pWholePage, "",false,false);

	if (bSuccess)
	{
		bSuccess = PageBody.CreatePageFromPlainText("Request could not be processed","Your request did not contain a recognised command. You may wish to check the URL for mistakes and try again.");
	}
	if (bSuccess)
	{
		bSuccess = pWholePage->AddInside("H2G2", &PageBody);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CXMLBuilder::CreateSimplePage(CWholePage* pWholePage, const TDVCHAR* pSubject, const TDVCHAR* pContent)

	Author:		Kim Harries
	Created:	11/04/2000
	Inputs:		pWholePage - the page to initialise
				pSubject - the subject for the simple page
				pContent - the content for the simple page
	Outputs:	-
	Returns:	true, or false if something seriously wrong.
	Purpose:	Initialises a CWholePage object for a very simple page using the subject
				and content provided. If the content string has a <GUIDE><BODY>
				sequence in it will create the page body as XML otherwise as plain
				text.

*********************************************************************************/

bool CXMLBuilder::CreateSimplePage(CWholePage* pWholePage, const TDVCHAR* pSubject, const TDVCHAR* pContent)
{
	CPageBody		PageBody(m_InputContext);

	CTDVString sSubject = pSubject;
	CTDVString sContent = pContent;
	bool bSuccess = InitPage(pWholePage, "SIMPLEPAGE",true);
	// use appropriate create method from CPageBody depending on whether message
	// is XML or not
	if (sContent[0] != '<')
	{
		bSuccess = bSuccess && PageBody.CreatePageFromPlainText(sSubject, sContent);
	}
	else
	{
		bSuccess = bSuccess && PageBody.CreatePageFromXMLText(sSubject, sContent);
	}
	bSuccess = bSuccess && pWholePage->AddInside("H2G2", &PageBody);
	// if something wrong then delete page and return NULL
	TDVASSERT(bSuccess, "CXMLBuilder::CreateSimplePage(..) failed to produce page");
	return bSuccess;
}

#define REQUIRED_WINSOCK_VERSION 0x0101

bool CXMLBuilder::SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks)
{
	return m_InputContext.SendMail(pEmail, pSubject, pBody, pFromAddress, pFromName);
}

bool CXMLBuilder::SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks, int piUserID, int piSiteID)
{
	return m_InputContext.SendMailOrSystemMessage(pEmail, pSubject, pBody, pFromAddress, pFromName, bInsertLineBreaks, piUserID, piSiteID);
}

/*********************************************************************************

	bool CXMLBuilder::DoSwitchSites(CWholePage* pPage)

	Author:		Jim Lynn
	Created:	26/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	returns true if the site cannot switch - the builder should return the
				wholepage immediately. otherwise continue.

*********************************************************************************/

bool CXMLBuilder::DoSwitchSites(CWholePage* pPage, const TDVCHAR* pURL, int iCurrentSiteID, int iContentSiteID, CUser** ppUser)
{
	if (iContentSiteID == 0)
	{
		return false;
	}

	
	if (iCurrentSiteID != iContentSiteID)
	{
		if (m_InputContext.GetNoAutoSwitch())
		{
			CTDVString sSiteName;
			m_InputContext.GetNameOfSite(iContentSiteID, &sSiteName);
			CTDVString sXML;
			sXML << "<SITECHANGE><REASON>NoAutoSwitchingAllowed</REASON><SITEID>" << iContentSiteID << "</SITEID>";
			sXML << "<SITENAME>" << sSiteName << "</SITENAME>";
			sXML << "<URL>" << pURL << "</URL></SITECHANGE>";
			// Some kind of error
			pPage->AddInside("H2G2",sXML);
			pPage->SetPageType("SITECHANGE");
			return true;
		}
		else if (m_InputContext.GetSiteOptions()->GetValue(iContentSiteID, "General","SiteIsPrivate").CompareText("1"))
		{
			CTDVString sSiteName;
			m_InputContext.GetNameOfSite(iContentSiteID, &sSiteName);
			CTDVString sXML;
			sXML << "<SITECHANGE><REASON>SiteIsPrivate</REASON><SITEID>" << iContentSiteID << "</SITEID>";
			sXML << "<SITENAME>" << sSiteName << "</SITENAME>";
			sXML << "<URL>" << pURL << "</URL></SITECHANGE>";
			// Some kind of error
			pPage->AddInside("H2G2",sXML);
			pPage->SetPageType("SITECHANGE");
			return true;
		}
		else
		{
			m_InputContext.ChangeSite(iContentSiteID);
			*ppUser = m_InputContext.GetCurrentUser();
			
			//the user has now changed so we had better update the viewing user
			//xml in the page as it may not reflect this

			if (pPage->FindFirstNode("VIEWING-USER", NULL, false))
			{
				pPage->RemoveTagIfItsAChild("USER");

				if (*ppUser != NULL)
				{
					pPage->AddInside("VIEWING-USER",*ppUser);
				}
			}
			
			if (m_InputContext.IsSitePassworded(iContentSiteID))
			{
				if (!m_InputContext.IsUserAllowedInPasswordedSite())
				{
					CUnauthorisedBuilder UnauthorisedBuilder(m_InputContext);
					UnauthorisedBuilder.Build(pPage);
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	CWholePage* CXMLBuilder::CreateAndInitPage(const TDVCHAR *pPageName)

	Author:		Jim Lynn
	Created:	30/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Create and initialise a WholePage object. Create the UI if
				bDefaultUI = true otherwise don't and leave it to the subclass.

*********************************************************************************/

/*
CWholePage* CXMLBuilder::CreateAndInitPage(const TDVCHAR *pPageName, bool bDefaultUI, bool* pbOK, bool bIncludeUser)
{
	CWholePage* pPage = NULL;
	try
	{
		pPage = new CWholePage(m_InputContext);
	}
	catch (...)
	{
		TDVASSERT(false, "Memory allocation failed in CXMLBuilder::CreateAndInitPage()");
		// if out of memory return NULL to indicate failure
		// but first delete any memory that has been allocated
		delete pPage;
		pPage = NULL;
		return NULL;
	}
	if(InitPage(pPage, pPageName, bDefaultUI, pbOK, bIncludeUser))
	{
		return pPage;
	}
	else
	{
		delete pPage;
		return NULL;
	}
}
*/


bool CXMLBuilder::InitPage(CWholePage* pPage, const TDVCHAR *pPageName, bool bDefaultUI, bool bIncludeUser)
{
	bool bSuccess = pPage->Initialise();
	CUser*	pViewer = m_InputContext.GetCurrentUser(); // the viewing user xml object
	if (bIncludeUser && bSuccess && pViewer != NULL)
	{
		bSuccess = bSuccess && pPage->AddInside("VIEWING-USER", pViewer);
	}

	// Get the site config from the sitesdata cache or from the preview table depending on the preview mode
	CTDVString sSiteConfig, sEditKey;
	if (m_InputContext.GetIsInPreviewMode())
	{
		// Get the siteconfig from the preview data
		CSiteConfigPreview SiteConfig(m_InputContext);
		bSuccess = bSuccess && SiteConfig.GetPreviewSiteConfig(sSiteConfig,m_InputContext.GetSiteID(),&sEditKey);
	}
	else
	{
		m_InputContext.GetSiteConfig(sSiteConfig);
	}

	if (sSiteConfig.GetLength() > 0) 
	{
		bSuccess = bSuccess && pPage->AddInside("H2G2",sSiteConfig);
	}

	if (sEditKey.GetLength() > 0)
	{
		bSuccess = bSuccess && pPage->AddInside("H2G2","<SITECONFIG-EDITKEY>" + sEditKey + "</SITECONFIG-EDITKEY>");
	}

	//Add Topics xml to page.
	bSuccess = bSuccess && AddTopicsToPage(pPage,m_InputContext.GetIsInPreviewMode());

	if (bDefaultUI && bSuccess)
	{
		CPageUI UI(m_InputContext);
		bSuccess = bSuccess && UI.Initialise(pViewer);
		bSuccess = bSuccess && pPage->AddInside("H2G2", &UI);
	}

	bSuccess = bSuccess && pPage->SetPageType(pPageName);
	return bSuccess;

//	if (bSuccess)
//	{
//		return pPage;
//	}
//	else
//	{
//		delete pPage;
//		pPage = NULL;
//		return NULL;
//	}
}

/*********************************************************************************
	Name:		AddTopicsToPage
	Author:		Martin Robb
	Created:	01/11/2002
	Inputs:		- CWholePage*
	Outputs:	- NA
	Returns:	true unless error
	Purpose:	Overridable method which adds topic xml to page
				If Preview mode is specified will request the preview topic for the current site
				otherwies adds cached live topics to page.
*********************************************************************************/
bool CXMLBuilder::AddTopicsToPage(CWholePage* pPage, bool bPreviewMode )
{
	bool bSuccess = true;
	if ( bPreviewMode )
	{
		//Include Preview Topics
		CTopic topics4site(m_InputContext);
		topics4site.GetTopicsForSiteID(m_InputContext.GetSiteID(),CTopic::TS_PREVIEW );
		bSuccess = pPage->AddInside("H2G2",&topics4site);
		
	}
	else
	{
		//Include Live Cached Topics.
		CTDVString sTopics;
		m_InputContext.GetTopics(sTopics);
		if ( sTopics.GetLength() > 0 )
		{
			bSuccess = pPage->AddInside("H2G2",sTopics);
		}
	}
	return bSuccess;
}

bool CXMLBuilder::AddSiteListToPage(CWholePage *pPage)
{
	return false;
}

/*********************************************************************************

	bool CXMLBuilder::IsUserAuthorised()

	Author:		Jim Lynn
	Created:	11/04/2002
	Inputs:		-
	Outputs:	-
	Returns:	true if current user is authorised, false otherwise
	Purpose:	Overridable function which checks so see if there are any
				constraints on who can view the current page.

				Possible constraints might be:
					Only editor/moderator
					Only editor
					Only tester (unlikely for a builder)
					
				These will all check *only* the HTTP authenticated user

*********************************************************************************/

bool CXMLBuilder::IsUserAuthorised()
{
	if ((m_AllowedUsers & USER_ANY) != 0)
	{
		return true;
	}
	// dont check editor credentials...
	return true;
/*
	CTDVString UserName;
	if (!m_InputContext.GetUserName(&UserName))
	{
		return false;
	}
	if ((m_AllowedUsers & USER_AUTHENTICATED) != 0)
	{
		return true;
	}
	else if ((m_AllowedUsers & USER_TESTER) != 0 && UserName.CompareText("tester"))
	{
		return true;
	}
	else if ((m_AllowedUsers & USER_MODERATOR) != 0 && UserName.CompareText("moderator"))
	{
		return true;
	}
	else if ((m_AllowedUsers & USER_EDITOR) != 0 && UserName.CompareText("editor"))
	{
		return true;
	}
	else if ((m_AllowedUsers & USER_ADMINISTRATOR) != 0 && UserName.CompareText("administrator"))
	{
		return true;
	}
	else
	{
		return false;
	}*/
}

/*********************************************************************************

	bool CXMLBuilder::ManageClippedLinks()

	Author:		Jim Lynn
	Created:	20/08/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Manages the requests for editing links, etc.

*********************************************************************************/

bool CXMLBuilder::ManageClippedLinks(CWholePage* pPage)
{
	CLink Link(m_InputContext);
	if (m_InputContext.ParamExists("movelinks")) 
	{
		//xxx // Make sure unauthorised people can't move links by fiddling the URL.
		// try deleting all the links
		int iCount = 0;
		while (m_InputContext.ParamExists("linkid", iCount)) 
		{
			if (iCount == 0)
			{
				Link.StartMoveLink();
			}
			int iLinkID = m_InputContext.GetParamInt("linkid", iCount);
			CTDVString sNewLocation;
			m_InputContext.GetParamString("newgroup", sNewLocation);
			if (sNewLocation.CompareText("default")) 
			{
				sNewLocation = "";
			}
			Link.MoveLink(iLinkID, sNewLocation);
			iCount++;
		}
		Link.EndMoveLinks();
		pPage->AddInside("H2G2", &Link);
	}
	if (m_InputContext.ParamExists("moveclublinks")) 
	{
		// try deleting all the links
		int iCount = 0;
		while (m_InputContext.ParamExists("linkid", iCount)) 
		{
			if (iCount == 0)
			{
				Link.StartMoveLink();
			}
			int iLinkID = m_InputContext.GetParamInt("linkid", iCount);
			CTDVString sNewLocation;
			m_InputContext.GetParamString("newgroup", sNewLocation);
			if (sNewLocation.CompareText("default")) 
			{
				sNewLocation = "";
			}
			Link.MoveLink(iLinkID, sNewLocation);
			iCount++;
		}
		Link.EndMoveLinks();
		pPage->AddInside("H2G2", &Link);
	}
	if (m_InputContext.ParamExists("changepublic")) 
	{
		bool bStarted = false;
		int iCount = 0;
		// fields:
		// hidden: privlinkid = 1234
		// hidden: curprivacy = 0/1
		// checkbox: newprivlinkid = 1234
		// or
		// radio: newprivlinkid = 0, radio: newprivlinkid = 1234
		// 
		// thus, the absence of newprivlinkid=1234 indicates hidden
		// So for each privlinkid, we get the current privacy setting,
		// look for newprivlinkid = privlinkid, and if we don't find it
		// the new privacy state is 0, otherwise it's 1

		while (m_InputContext.ParamExists("privlinkid", iCount)) 
		{
			if (!bStarted)
			{
				Link.StartChangeLinkPrivacy();
				bStarted = true;
			}
			int iLinkID = m_InputContext.GetParamInt("privlinkid", iCount);
			bool bCurrentPrivacy = true;
			if (m_InputContext.GetParamInt("curprivacy", iCount) == 0)
			{
				bCurrentPrivacy = false;
			}
			// Now look for newprivlinkid=iLinkID
			int iNewCount = 0;
			bool bFoundLinkID = false;
			while (!bFoundLinkID && m_InputContext.ParamExists("newprivlinkid", iNewCount)) 
			{
				if (m_InputContext.GetParamInt("newprivlinkid", iNewCount) == iLinkID)
				{
					// Found it, privacy must be on
					bFoundLinkID = true;
				}
				iNewCount++;
			}
			// bFoundLinkID now represents the privacy state
			if (bFoundLinkID != bCurrentPrivacy) 
			{
				Link.ChangeLinkPrivacy(iLinkID, bFoundLinkID);
			}
			iCount++;
		}
		Link.EndChangeLinkPrivacy();
		pPage->AddInside("H2G2", &Link);

	}
	if (m_InputContext.ParamExists("copytoclub")) 
	{
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		int iUserID = pViewingUser->GetUserID();
		int iClubID = m_InputContext.GetParamInt("clubid");
		CClub Club(m_InputContext);
		if (Club.CanUserEditClub(iUserID, iClubID)) 
		{
			CTDVString sLinkGroup;
			m_InputContext.GetParamString("linkgroup", sLinkGroup);
			Link.CopyLinksToClub(iUserID, iClubID, sLinkGroup);
			pPage->AddInside("H2G2", &Link);
		}
	}
	if (m_InputContext.ParamExists("copyselectedtoclub")) 
	{
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		int iUserID = pViewingUser->GetUserID();
		int iClubID = m_InputContext.GetParamInt("clubid");
		CClub Club(m_InputContext);
		if (Club.CanUserEditClub(iUserID, iClubID)) 
		{
			// try copying all the links
			int iCount = 0;
			while (m_InputContext.ParamExists("linkid", iCount)) 
			{
				if (iCount == 0)
				{
					Link.StartCopyLinkToClub();
				}
				int iLinkID = m_InputContext.GetParamInt("linkid", iCount);
				CTDVString sNewLocation;
				m_InputContext.GetParamString("clubgroup", sNewLocation);
				if (sNewLocation.CompareText("default")) 
				{
					sNewLocation = "";
				}
				Link.CopyLinkToClub(iLinkID, iClubID, sNewLocation);
				iCount++;
			}
			Link.EndCopyLinkToClub();
			pPage->AddInside("H2G2", &Link);
		}
	}
	if (m_InputContext.ParamExists("deletelinks"))
	{
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		int iUserID = pViewingUser->GetUserID();
		int iSiteID = m_InputContext.GetSiteID();

		// try deleting all the links
		int iCount = 0;
		while (m_InputContext.ParamExists("linkid", iCount)) 
		{
			if (iCount == 0)
			{
				Link.StartDeleteLink();
			}
			int iLinkID = m_InputContext.GetParamInt("linkid", iCount);
			Link.DeleteLink(iLinkID,iUserID,iSiteID);
			iCount++;
		}
		Link.EndDeleteLinks();
		pPage->AddInside("H2G2", &Link);
	}
	return true;
}

/*********************************************************************************

	bool CXMLBuilder::CheckAndUseRedirectIfGiven(CWholePage* pPage)

		Author:		Mark Howitt
        Created:	17/01/2005
        Inputs:		pPAge - The page that you to insert the redirect into.
        Outputs:	-
        Returns:	true if redirect was found and processed, false if not.
        Purpose:	Checks the URL For a key s_param called 's_returnto'. If
					found, it is inserted into the given page as a redirect.
					Mainly used in builders that can be entered from multiple entry points
					and need to return back to that one.

*********************************************************************************/
bool CXMLBuilder::CheckAndUseRedirectIfGiven(CWholePage* pPage)
{
	// Make sure we've been given a valid page object
	if (pPage == NULL)
	{
		// No Page!
		TDVASSERT(false,"CXMLBuilder::CheckAndUseRedirectIfGiven - Invalid Page Object Given!!!");
		return false;
	}

	// Check to see if we are being given a redirect.
	if (m_InputContext.ParamExists("s_returnto"))
	{
		CTDVString sRedirect;
		if (m_InputContext.GetParamString("s_returnto",sRedirect) && !sRedirect.IsEmpty())
		{
			// Do the redirect
			return pPage->Redirect(sRedirect);
		}
	}

	// If we're here, no redirect was given!
	return false;
}