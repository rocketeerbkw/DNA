// NoticeBoardListBuilder.cpp: implementation of the CNoticeBoardListBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "NoticeBoardListBuilder.h"
#include "NoticeBoardList.h"
#include "User.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNoticeBoardListBuilder::CNoticeBoardListBuilder(CInputContext& inputContext)
: CXMLBuilder(inputContext),m_pPage(NULL)
{
}

CNoticeBoardListBuilder::~CNoticeBoardListBuilder()
{
}

/*********************************************************************************

	CWholePage* CNoticeBoardListBuilder::Build()

	Author:		Mark Howitt
	Created:	04/12/2003
	Inputs:		-
	Outputs:	The NoticeBoard List page
	Returns:	A valid page if successful or NULL if not
	Purpose:	Creates a page a page which lists all the noticeboards for the current
				site in alphabetical order. There is also a skip show system which
				defaults to skip = 0 and show = 20. The name of the local authority and
				number of articles and clubs  whcih are attached to node are also
				given.

*********************************************************************************/

bool CNoticeBoardListBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	// Create the new page object
	if (!InitPage(m_pPage, "NOTICEBOARDLIST", true))
	{
		return false;
	}

	// Check to make sure the user is an editor or superuser
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser != NULL && (pViewingUser->GetIsSuperuser() || pViewingUser->GetIsEditor()) )
	{
		// Add the object type to the XML Page
		m_pPage->AddInside("H2G2","<NOTICEBOARDLIST>");

		// Get the skip and show values from the URL if they exist
		int iSkip = 0;
		int iShow = 20;
		if (m_InputContext.ParamExists("skip"))
		{
			iSkip = m_InputContext.GetParamInt("skip");
		}
		if (m_InputContext.ParamExists("show"))
		{
			iShow = m_InputContext.GetParamInt("show");

			// Limit the show number to a max of 400
			if (iShow > 400)
			{
				iShow = 400;
			}
		}

		// Setup the noticeboard list object to get all the relavent info
		CNoticeBoardList NoticeBoardList(m_InputContext);
		if (NoticeBoardList.GetAllNoticeBoards(m_pPage,m_InputContext.GetSiteID(),iSkip,iShow))
		{
			m_pPage->AddInside("H2G2",&NoticeBoardList);
		}
		else
		{
			// Get the last error message as XML from the noticeboardlist object
			CTDVString sErrorXML;
			NoticeBoardList.GetLastErrorAsXMLString(sErrorXML);
			m_pPage->AddInside("H2G2", sErrorXML);
		}
	}
	else
	{
		// Setup a suitable error report
		m_pPage->SetPageType("ERROR");
		m_pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot view Noticeboard list unless you are logged in as an Editor or SuperUser.</ERROR>");
	}

	// Return the page
	return true;
}
