// ReviewForumBuilder.cpp: implementation of the CReviewForumBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ReviewForumBuilder.h"
#include "Wholepage.h"
#include "Forum.h"
#include "ReviewForum.h"
#include "GuideEntry.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CReviewForumBuilder::CReviewForumBuilder(CInputContext& inputContext)
:CXMLBuilder(inputContext)
{

}

CReviewForumBuilder::~CReviewForumBuilder()
{

}

bool CReviewForumBuilder::Build(CWholePage* pPage)
{
	CReviewForum mReviewForum(m_InputContext);
	CGuideEntry mGuideEntry(m_InputContext);

	if (!InitPage(pPage, "REVIEWFORUM", true))
	{
		return false;
	}

	int iReviewForumID = 0;

	if (m_InputContext.ParamExists("ID"))
	{
		iReviewForumID = m_InputContext.GetParamInt("ID");
	}
	else
	{	
		return false;
	}

	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
	{
		pPage->AddInside("H2G2",&mReviewForum);
		return true;
	}

	//redirect if its the wrong site
	if (SwitchSites(pPage,mReviewForum))
	{
		return true;
	}

	int iSkip = 0;
	int iShow = 20;
	
	CReviewForum::OrderBy eOrder = CReviewForum::LASTPOSTED;
	bool bDirection = false;

	// get the skip and show parameters if any
	if (m_InputContext.ParamExists("Skip"))
	{
		iSkip = m_InputContext.GetParamInt("Skip");
		if (iSkip < 0)
		{
			iSkip = 0;
		}
	}
	if (m_InputContext.ParamExists("Show"))
	{
		iShow = m_InputContext.GetParamInt("Show");
		if (iShow <= 0)
		{
			iShow = 20;
		}
	}
	
	if (m_InputContext.ParamExists("Order"))
	{
		CTDVString sOrderBy;
		m_InputContext.GetParamString("Order",sOrderBy);

		if (sOrderBy.CompareText("dateentered"))
		{
			eOrder = CReviewForum::DATEENTERED;
		}
		else if(sOrderBy.CompareText("lastposted"))
		{
			eOrder = CReviewForum::LASTPOSTED;
		}
		else if(sOrderBy.CompareText("authorid"))
		{
			eOrder = CReviewForum::AUTHORID;
		}
		else if(sOrderBy.CompareText("authorname"))
		{
			eOrder = CReviewForum::AUTHORNAME;
		}
		else if (sOrderBy.CompareText("entry"))
		{
			eOrder = CReviewForum::H2G2ID;
		}
		else if (sOrderBy.CompareText("subject"))
		{
			eOrder = CReviewForum::SUBJECT;
		}
		else
		{
			eOrder = CReviewForum::LASTPOSTED;
		}
	}

	if (m_InputContext.ParamExists("Dir"))
	{
		int iDirection = m_InputContext.GetParamInt("Dir");
		if (iDirection == 1)
		{
			bDirection = true;
		}
		else
		{
			bDirection = false;
		}
	}

	if (mReviewForum.GetReviewForumThreadList(iShow,iSkip,eOrder,bDirection))
	{
		pPage->AddInside("H2G2",&mReviewForum);

		int bShowEntryBody = true;

		//check whether we need to add a guideentry description at the top
		if (m_InputContext.ParamExists("Entry"))
		{
			int iShowEntryBody = m_InputContext.GetParamInt("Entry");
			if (iShowEntryBody == 1)
			{
				bShowEntryBody = true;
			}
			else
			{
				bShowEntryBody = false;
			}
		}

		//add the entry 
		if (bShowEntryBody)
		{
			int iH2G2ID = mReviewForum.GetH2G2ID();

			if (mGuideEntry.Initialise(iH2G2ID,m_InputContext.GetSiteID(), false,false,false,true,true))
			{
				pPage->AddInside("H2G2",&mGuideEntry);
			}
			/*else
			{
				bShowEntryBody = false;
			}*/
		}
		
		//add the fact that we don't want/have an entry
		if (!bShowEntryBody)
		{
			pPage->AddInside("H2G2","<NOGUIDE/>");
		}
	}

	return true;
}

/*********************************************************************************

	bool CReviewForumBuilder::SwitchSites(CWholePage* pPage,CReviewForum& mReviewForum)

	Author:		Dharmesh Raithatha
	Created:	10/26/01
	Inputs:		pPage - page that gets filled in if site is switched
				mReviewForum - current initialised reviewforum
	Outputs:	-
	Returns:	true if the sites have been switched, false otherwise
	Purpose:	Checks if the reviewforums is accessed from the wrong site and prompts 
				the user to switch sites.
*********************************************************************************/

bool CReviewForumBuilder::SwitchSites(CWholePage* pPage,CReviewForum& mReviewForum)
{
	TDVASSERT(mReviewForum.IsInitialised(),"Uninitialised reviewforum in CReviewForumBuilder::SwitchSites");

	if (mReviewForum.GetSiteID() != m_InputContext.GetSiteID())
	{
		CTDVString sURL;
		sURL << "RF" << mReviewForum.GetReviewForumID();
		if (m_InputContext.ParamExists("Skip"))
		{
			sURL << "&Skip=" << m_InputContext.GetParamInt("Skip");
		}
		if (m_InputContext.ParamExists("Show"))
		{
			sURL << "&Show=" << m_InputContext.GetParamInt("Show");
		}
		if (m_InputContext.ParamExists("Order"))
		{
			CTDVString sOrderBy;
			m_InputContext.GetParamString("Order",sOrderBy);
			sURL << "&Order=" << sOrderBy;
		}
		if (m_InputContext.ParamExists("Dir"))
		{
			sURL << "&Dir=" << m_InputContext.GetParamInt("Dir");
		}
		if (m_InputContext.ParamExists("Entry"))
		{
			sURL << "&Entry=" << m_InputContext.GetParamInt("Entry");
		}

		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if (DoSwitchSites(pPage,sURL,m_InputContext.GetSiteID(),mReviewForum.GetSiteID(),&pViewingUser))
		{
			return true;
		}
	}

	return false;
}
