// CurrentClubsBuilder.cpp: implementation of the CCurrentClubsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "CurrentClubsBuilder.h"
#include "CurrentClubs.h"
#include "Vote.h"
#include "tdvassert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CCurrentClubsBuilder::CCurrentClubsBuilder(CInputContext& inputContext):
					  CClubPageBuilder(inputContext)
{
}

CCurrentClubsBuilder::~CCurrentClubsBuilder()
{
}

/*********************************************************************************

	CWholePage* CCurrentClubsBuilder::Build()

	Author:		Mark Howitt
	Created:	26/08/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Creates the Users Current Clubs page

*********************************************************************************/

bool CCurrentClubsBuilder::Build(CWholePage* pPage)
{
	// Create and initialize the page
	m_pPage = pPage;
	if (!InitPage(m_pPage, "USERMYCLUBS", true))
	{
		TDVASSERT(false, "Could not create current clubs page");
		return false;;
	}

	ProcessParams();

	if (!HasErrorBeenReported())
	{
		// Insert the SitesList
		CTDVString sSiteXML;
		m_InputContext.GetSiteListAsXML(&sSiteXML);
		m_pPage->AddInside("H2G2", sSiteXML);

		// Get the current user
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		CCurrentClubs CurrentClubs(m_InputContext);
		if (CurrentClubs.CreateList(pViewingUser))
		{
			m_pPage->AddInside("H2G2",&CurrentClubs);
		}
		else
		{
			m_pPage->AddInside("H2G2",CurrentClubs.GetLastErrorAsXMLString());
		}

		//include vote items
		if ( pViewingUser && pViewingUser->IsUserLoggedIn( ))
		{
			CVote oVoteItems(m_InputContext);		
			if ( oVoteItems.GetVotesCastByUser(pViewingUser->GetUserID( ), m_InputContext.GetSiteID( )))
			{
				m_pPage->AddInside("H2G2",&oVoteItems);
			}
			else
			{
				m_pPage->AddInside("H2G2",oVoteItems.GetLastErrorAsXMLString());
			}
		}
	}

	// Return the page
	return true;
}
