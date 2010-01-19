// MorePagesBuilder.cpp: implementation of the CMorePagesBuilder class.
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
#include "ArticleList.h"
#include "PageUI.h"
#include "MorePagesBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMorePagesBuilder::CMorePagesBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CMorePagesBuilder::~CMorePagesBuilder()
{

}

bool CMorePagesBuilder::Build(CWholePage* pPage)
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

	// type is either 1 (approved) 2 (normal) 3 (cancelled) or 4 (normal and approved)
	int iType = m_InputContext.GetParamInt("type");
	if (iType < CArticleList::ARTICLELISTTYPE_FIRST || iType > CArticleList::ARTICLELISTTYPE_LAST)
	{
		iType = CArticleList::ARTICLELISTTYPE_APPROVED;
	}

	// See if we've been given a specified type to search for
	int iGuideType = 0;
	if (m_InputContext.ParamExists("guidetype"))
	{
		iGuideType = m_InputContext.GetParamInt("guidetype");
	}

	CUser*			pViewingUser = m_InputContext.GetCurrentUser();
	
	// all the XML objects we need to build the page

	CUser PageOwner(m_InputContext);

	// Now initialise those objects that need it.
	bool bPageSuccess = false;
	bPageSuccess = InitPage(pPage, "MOREPAGES",true);
	TDVASSERT(bPageSuccess, "Failed to initialise WholePage in MorePagesBuilder");
	
	bool bSuccess = bPageSuccess;
	if ((iType == CArticleList::ARTICLELISTTYPE_CANCELLED) && ((pViewingUser == NULL) || (pViewingUser->GetUserID() != iUserID)))
	{
		bSuccess = false;
		pPage->SetError("You cannot view the cancelled entries of another user");
	}
	// now get the owner of the guide entries and put their xml in the page
	if (bSuccess)
	{
		bSuccess = PageOwner.CreateFromID(iUserID);
		bSuccess = bSuccess && pPage->AddInside("H2G2", "<PAGE-OWNER></PAGE-OWNER>");
		bSuccess = bSuccess && pPage->AddInside("PAGE-OWNER", &PageOwner);
	}

	CTDVString sXML = "<ARTICLES USERID='";
	sXML << iUserID << "' WHICHSET='" << iType << "'/>";
	bSuccess = bSuccess && pPage->AddInside("H2G2", sXML);
	bSuccess = bSuccess && AddArticlesToPage(iType,pPage,iUserID, iNumShow, iNumSkipped,iGuideType);

	// add the XML for the owner of the articles
	bSuccess = bSuccess && pPage->AddInside("ARTICLES", &PageOwner);

	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	bSuccess = bSuccess && pPage->AddInside("H2G2", sSiteXML);

	// OK, I think that's us done.
	return bPageSuccess;
}


bool CMorePagesBuilder::AddArticlesToPage(int iType,CWholePage* pPage,int iUserID, int iNumShow, int iNumSkipped, int iGuideType)
{
	bool bSuccess = false;

	if (pPage != NULL)
	{
		CArticleList ArticleList(m_InputContext);

		if (iType == CArticleList::ARTICLELISTTYPE_APPROVED)
		{
			bSuccess = ArticleList.CreateRecentApprovedArticlesList(iUserID, iNumShow, iNumSkipped, iGuideType);
		}
		else if (iType == CArticleList::ARTICLELISTTYPE_NORMAL)
		{
			bSuccess = ArticleList.CreateRecentArticlesList(iUserID, iNumShow, iNumSkipped, iGuideType);
		}
		else if (iType == CArticleList::ARTICLELISTTYPE_NORMALANDAPPROVED)
		{
			bSuccess = ArticleList.CreateRecentNormalAndApprovedArticlesList(iUserID, iNumShow, iNumSkipped, iGuideType);
		}
		else
		{
			bSuccess = ArticleList.CreateCancelledArticlesList(iUserID, iNumShow, iNumSkipped, iGuideType);
		}

		// Insert the forum into the page
		bSuccess = bSuccess && pPage->AddInside("ARTICLES", &ArticleList);
	}

	return bSuccess;
}
