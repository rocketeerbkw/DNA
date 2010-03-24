// MorePostsBuilder.cpp: implementation of the CMorePostsBuilder class.
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
#include "PostList.h"
#include "PageUI.h"
#include "tdvassert.h"
#include "MorePostsBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMorePostsBuilder::CMorePostsBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CMorePostsBuilder::~CMorePostsBuilder()
{

}

bool CMorePostsBuilder::Build(CWholePage* pPage)
{
	int iUserID = m_InputContext.GetParamInt("userid");
	int iNumShow = m_InputContext.GetParamInt("show");
	if (iNumShow == 0)
	{
		iNumShow = 25;
	}
	int iNumSkipped = m_InputContext.GetParamInt("skip");
	if (iNumSkipped <0)
	{
		iNumSkipped = 0;
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	
	// all the XML objects we need to build the page
	CPostList PostList(m_InputContext);

	// Now initialise those objects that need it.
	bool bPageSuccess = true;
	bPageSuccess = InitPage(pPage, "MOREPOSTS",true);
	TDVASSERT(bPageSuccess, "Failed to initialise WholePage in MorePostsBuilder");
	bool bSuccess = bPageSuccess;
		
	if (m_InputContext.ParamExists("allread") && pViewingUser != NULL) 
	{
		PostList.MarkAllRead(pViewingUser->GetUserID());
	}

	// See if we've been given a specific type of post to look for
	int iPostType = 0;
	if (m_InputContext.ParamExists("posttype"))
	{
		CTDVString sPostType;
		m_InputContext.GetParamString("posttype",sPostType);
		if (sPostType.CompareText("notice"))
		{
			iPostType = 1;
		}
		else if (sPostType.CompareText("event"))
		{
			iPostType = 2;
		}
	}

	// get the journal posts we want from the forum
	bool bGotPosts = bSuccess && PostList.CreateRecentPostsList(pViewingUser, iUserID, iNumShow, iNumSkipped, iPostType);

	// Put in the wrapping <POSTS> tag which has the user ID in it
	CTDVString sXML = "<POSTS USERID='";
	sXML << iUserID << "'/>";
	bSuccess = bSuccess && pPage->AddInside("H2G2", sXML);
	// Insert the forum into the page
	if (bGotPosts)
	{
		bSuccess = bSuccess && pPage->AddInside("POSTS",&PostList);
	}

	// Return SiteOption SystemMessageOn if set. 
	if (bSuccess && m_InputContext.IsSystemMessagesOn(m_InputContext.GetSiteID()))
	{
		CTDVString sSiteOptionSystemMessageXML = "<SITEOPTION><NAME>UseSystemMessages</NAME><VALUE>1</VALUE></SITEOPTION>"; 

		bSuccess = bSuccess && pPage->AddInside("H2G2",sSiteOptionSystemMessageXML);
	}

	CTDVString sSiteXML;
	bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML);
	bSuccess = bSuccess && pPage->AddInside("H2G2", sSiteXML);
	
	// OK, I think that's us done.
	return bPageSuccess;
}
