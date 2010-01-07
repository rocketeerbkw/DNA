// TeamListPageBuilder.cpp: implementation of the CTeamListPageBuilder class.
//

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
	not not warrant that the code is error-free or bug-free.
	  
	All information, data etc relating to the code is confidential 
	information to the BBC and as such must not be disclosed to 
	any other party whatsoever.
		
		  						  
*/

#include "stdafx.h"
#include "TeamListPageBuilder.h"
#include "Club.h"
#include "Team.h"
//#include "GuideEntry.h"
//#include "Forum.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTeamListPageBuilder::CTeamListPageBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext),
m_pPage(NULL)
{
	
}

CTeamListPageBuilder::~CTeamListPageBuilder()
{
	
}

/*********************************************************************************

  CWholePage* CTeamListPageBuilder::Build()
  
	Author:		Nick Stevenson
	Created:	6/23/2003
	Inputs:		- NA
	Outputs:	- m_pPage object pointer
	Returns:	- m_pPage
	Purpose:	- calls function to do the work if input values are correct
	
*********************************************************************************/

bool CTeamListPageBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "TEAMLIST", true)) // creates <H2G2 Type="TEAMLIST">
	{
		return false;
	}


	int iTeamID = m_InputContext.GetParamInt("id");

	//CUser* pViewingUser = m_pInputContext->GetCurrentUser();
	DisplayTeamList(iTeamID);				

	
	return true;
	
}

/*********************************************************************************

  CWholePage* CTeamListPageBuilder::DisplayTeamList(int iTeamID)
  
	Author:		Nick Stevenson
	Created:	6/23/2003
	Inputs:		- iTeamID: id of team to display
	Outputs:	- m_pPage -updated with teamlist XML data
	Returns:	- m_pPage
	Purpose:	- Calls appropriate objects to generate teamlist XML
	
*********************************************************************************/

bool CTeamListPageBuilder::DisplayTeamList(int iTeamID)
{
		
	if(iTeamID <= 0)
	{
		return ErrorMessage("DisplayTeamList","Team id has useless value of zero");		
	}

	// a CTeam object
	CTDVString sTeamType;
	CTeam Team(m_InputContext);

	// show - default number of first team member in list
	int show	= 0;
	// skip	- default max number of team members to show at one time
	int skip	= 0;
	show	= m_InputContext.GetParamInt("show");
	skip	= m_InputContext.GetParamInt("skip");

	// create a CClub object and get its data
	int iClubID = 0;
	CClub Club(m_InputContext);
				
	// get the club id from team id			
 	bool bSuccess = Team.GetClubIDAndClubTeamsForTeamID(iTeamID, sTeamType, iClubID);
	if(!bSuccess)
	{
		return ErrorMessage("DisplayTeamList","Failed to establish club id from team id");		
	}

	// iClubID now has a value so get the club details
	if (!Club.InitialiseViaClubID(iClubID))
	{
		return ErrorMessage("ClubInit", "Failed to initialise Club");
	}
	

	// get the team list
	Team.SetType(sTeamType);
	
	// just get all if show and skip values don't exist
	if(skip > 0  || show > 0)	
	{
		// get subset of members for the team
		if ( !Team.GetTeamMembersSubSet(iTeamID, show, skip) )
		{
			return ErrorMessage("DisplayTeamList","Unable to get a subset of specified team");
		}
	}
	else
	{
		if (!Team.GetAllTeamMembers(iTeamID))
		{

			return ErrorMessage("DisplayTeamList","Unable to get list of members for specified team");
		}
	}

	// create the page
	bSuccess =	m_pPage->AddInside("H2G2","<TEAMLIST></TEAMLIST>") &&
				m_pPage->AddInside("TEAMLIST",&Team) &&
				m_pPage->AddInside("TEAMLIST",&Club);

	if (!bSuccess)
	{
		return ErrorMessage("XML","Failed to build the XML for team list");
	}

	return true; 
}



/*********************************************************************************

	CWholePage* CTeamListPageBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Nick Stevenson
	Created:	26/06/2003
	Inputs:		sType - type of error
				sMsg - Defualt message
	Outputs:	-
	Returns:	whole xml page with error
	Purpose:	default error message

*********************************************************************************/

bool CTeamListPageBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	InitPage(m_pPage, "CLUB", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}