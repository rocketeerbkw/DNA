// NoticeBoardList.cpp: implementation of the CNoticeBoardList class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "NoticeBoardList.h"
#include "Notice.h"
#include "tdvassert.h"
#include "WholePage.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNoticeBoardList::CNoticeBoardList(CInputContext& inputContext) :
CXMLObject(inputContext)
{
}

CNoticeBoardList::~CNoticeBoardList()
{
}

/*********************************************************************************

	bool CNoticeBoardList::GetAllNoticeBoards(CWholePage* pPage, const int iSiteID, int iSkip, int iShow)

	Author:		Mark Howitt
	Created:	03/12/2003
	Inputs:		pPage - The page in which the List is going to be displayed
				iSiteID - The current site you want to get the notices for
				iSkip - THe number of results to skip
				iShow - The number of results to show
	Outputs:	-
	Returns:	True if everything went ok
	Purpose:	Inserts all the noticeboards for a given site id. You can also specify
				the number of results to skip and show.
				The number of article and club members are also given for each noticeboard

*********************************************************************************/

bool CNoticeBoardList::GetAllNoticeBoards(CWholePage* pPage, const int iSiteID, int iSkip, int iShow)
{
	// Check to make sure we've been given a valid page to play with
	if (pPage == NULL)
	{
		return SetDNALastError("CNoticeBoardList","NULLPageObjectGiven","No page given to fill in!!!");
	}

	// Now get the all the noticeboards from the taxonomy
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetAllLocalAuthorityNodes(iSiteID,0,5))
	{
		return SetDNALastError("CNoticeBoardList","FailedToGetNodes","Failed to find the local authority nodes!");
	}

	// Now go through all the nodes getting the localnoticeboard info
	// Setup some local variables
	CTDVString sXML;
	bool bOk = true;
	CNotice Notice(m_InputContext);
	CTDVString sClubInfo;
	CTDVString sArticleInfo;
	CTDVString sDisplayName;
	int iNodeID = 0;

	// Check to see if we've been asked to skip
	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}

	// Put the skip, show and total count into the page
	CTDVString sSkip = iSkip;
	CTDVString sShow = iShow;
	CTDVString sCount = SP.GetIntField("Count");
	pPage->SetAttribute("NOTICEBOARDLIST","SKIP",sSkip);
	pPage->SetAttribute("NOTICEBOARDLIST","SHOW",sShow);
	pPage->SetAttribute("NOTICEBOARDLIST","TOTAL",sCount);

	// Setup a counter to count down the number of results to show
	int iCount = iShow;
	while (!SP.IsEOF() && iCount > 0 && bOk)
	{
		// Get the current nodeid, ArticleMembers, ClubMembers and DisplayName
		iNodeID = SP.GetIntField("NodeID");
		SP.GetField("ArticleMembers",sArticleInfo);
		SP.GetField("ClubMembers",sClubInfo);
		SP.GetField("DisplayName",sDisplayName);

		// Get the noticeboard for the location
		if (Notice.GetNoticeBoardForNode(iNodeID,iSiteID))
		{
			// Add the club and article info
			Notice.SetAttribute("NOTICEBOARD","LOCALAUTHORITY",sDisplayName);
			Notice.SetAttribute("NOTICEBOARD","ARTICLEMEMBERS",sArticleInfo);
			Notice.SetAttribute("NOTICEBOARD","CLUBMEMBERS",sClubInfo);

			bOk = pPage->AddInside("NOTICEBOARDLIST",&Notice);
			if (!bOk)
			{
				SetDNALastError("CNoticeBoardList","FailedInsertingNoticeINtoPage","Failed to insert noticeboard into XML Page!");
			}
		}

		// Get the next result
		SP.MoveNext();
		iCount--;
	}

	// Return the verdict
	return bOk;
}

/*********************************************************************************

	bool CNoticeBoardList::GetNoticeBoardsForNodeID(const int iNodeID, const int iSiteID, int iSkip, int iShow)

	Author:		Mark Howitt
	Created:	08/12/2003
	Inputs:		iNodeID - the node you want to get the noticeboards for.
				iSiteID - the site to look in.
				iSkip - the the number of results to skip
				iShow - The number of results to show.
	Outputs:	-
	Returns:	True if ok, False if not
	Purpose:	Gets all the noticeboards for a given node.
				If the node is above the authority level, then it returns all
				the noticeboards from each authority. If the node is an authority node,
				then it returns all the noticeboarda in the same area. If the node is below
				the authority level, then it returns the noticeboard for just
				that node.

*********************************************************************************/

bool CNoticeBoardList::GetNoticeBoardsForNodeID(const int iNodeID, const int iSiteID, int iSkip, int iShow)
{
	// First check to make sure we've been given correct params
	if (iNodeID <= 0 || iSiteID <= 0)
	{
		return SetDNALastError("CNoticeBoardList","InvalidCallParams","Invalid node or site id given!");
	}

	// Now try to create the object so we can add the noticeboard to it
	if (!CreateFromCacheText("<NOTICEBOARDLIST></NOTICEBOARDLIST>"))
	{
		return SetDNALastError("CNoticeBoardList","FailedToCreateTree","Failed to create the tree object");
	}

	// Now get the tree level for the given node
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetTreeLevelForNodeID(iNodeID,iSiteID))
	{
		return SetDNALastError("CNoticeBoardList","FailedToGetTreeLevel","Failed to get the tree level for the given node! Invalid nodeid?");
	}
	
	// Now get the value and move the results position
	int iTreeLevel = SP.GetIntField("TreeLevel");
	if (iTreeLevel < 3)
	{
		// We don't want to show noticeboard lists for anything above level 4!
		return true;
	}

	// We're higher, so get all the noticeboards from the child areas
	// Get all the local authority nodes under this node!
	if (!SP.GetAllLocalAuthorityNodes(iSiteID,iNodeID,5))
	{
		return SetDNALastError("CNoticeBoardList","FailedToGetNodes","Failed to find the local authority nodes!");
	}

	// Set the total value from the results
	CTDVString sCount = SP.GetIntField("Count");
	SetAttribute("NOTICEBOARDLIST","TOTAL",sCount);

	// Setup some local variables
	CTDVString sClubInfo;
	CTDVString sArticleInfo;
	CTDVString sDisplayName;
	CTDVString sSkip = iSkip;
	CTDVString sShow = iShow;
	SetAttribute("NOTICEBOARDLIST","SKIP",sSkip);
	SetAttribute("NOTICEBOARDLIST","SHOW",sShow);

	// Check to see if we're in a local authority area or higher?
	// Are we inside?
	CNotice Notice(m_InputContext);
	bool bOk = true;

	// Setup a counter to count down the number of results to show
	int iCount = iShow;
	int iAreaNode = 0;
	while (!SP.IsEOF() && iCount > 0 && bOk)
	{
		// Get the current nodeid, ArticleMembers, ClubMembers and DisplayName
		iAreaNode = SP.GetIntField("NodeID");
		SP.GetField("ArticleMembers",sArticleInfo);
		SP.GetField("ClubMembers",sClubInfo);
		SP.GetField("DisplayName",sDisplayName);

		// Get the noticeboard for the location
		if (Notice.GetNoticeBoardForNode(iAreaNode,iSiteID,false))
		{
			// Add the club and article info
			Notice.SetAttribute("NOTICEBOARD","LOCALAUTHORITY",sDisplayName);
			Notice.SetAttribute("NOTICEBOARD","ARTICLEMEMBERS",sArticleInfo);
			Notice.SetAttribute("NOTICEBOARD","CLUBMEMBERS",sClubInfo);

			bOk = AddInside("NOTICEBOARDLIST",&Notice);
			if (!bOk)
			{
				SetDNALastError("CNoticeBoardList","FailedInsertingNoticeINtoPage","Failed to insert noticeboard into XML Page!");
			}
		}

		// Get the next result
		SP.MoveNext();
		iCount--;
	}

	return bOk;
}
