// Team.cpp: implementation of the CTeam class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Team.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTeam::CTeam(CInputContext& inputContext)
:
CXMLObject(inputContext)
{

}

CTeam::~CTeam()
{

}


/*********************************************************************************

	bool CTeam::GetTeamMembers(int iTeamID)

	Author:		Dharmesh Raithatha
	Created:	5/12/2003
	Inputs:		iTeamID - Id of the team to initialise
	Outputs:	bEmpty - if 
	Returns:	true if there was a team to interrogate
	Purpose:	Gets the Teammembers for a given team and creates the xmltree for
				its representation

*********************************************************************************/

bool CTeam::GetAllTeamMembers(int iTeamID)
{
	CStoredProcedure SP;

	m_InputContext.InitialiseStoredProcedureObject(&SP);

	bool bNoMembers = false;

	if (!SP.GetAllTeamMembers(iTeamID,m_InputContext.GetSiteID(),bNoMembers))
	{
		SetDNALastError("Team","Database","An Error Occurred while accessing the database");
		return false;
	}

	//even if there are no members, we will just return the empty team as it may be empty
	CTDVString sXML;

	sXML << "<TEAM ID='" << iTeamID;
	
	//Add the type if it has been set
	if (!m_sType.IsEmpty())
	{
		sXML << "' TYPE='" << m_sType; 
	}
	
	sXML << "'>";

	bool bOk = true;

	// Setup the XML for the current member
	InitialiseXMLBuilder(&sXML, &SP);
	while (!SP.IsEOF())
	{
		bOk = bOk && OpenXMLTag("MEMBER");
		bOk = bOk && AddDBXMLTag("Role",NULL,false);
		
		int iThisUserID = 0;

		bOk = bOk && OpenXMLTag("USER");
			bOk = bOk && AddDBXMLIntTag("User","USERID", true, &iThisUserID);
			bOk = bOk && AddDBXMLTag("UserName");
			bOk = bOk && AddDBXMLTag("FirstNames",NULL,false);
			bOk = bOk && AddDBXMLTag("LastName",NULL,false);			
			bOk = bOk && AddDBXMLTag("Area",NULL,false);
			bOk = bOk && AddDBXMLIntTag("Status", NULL, false);
			bOk = bOk && AddDBXMLIntTag("TaxonomyNode", NULL, false);
			bOk = bOk && AddDBXMLIntTag("Journal", NULL, false);
			bOk = bOk && AddDBXMLIntTag("Active");	
			bOk = bOk && AddDBXMLTag("Title",NULL,false);
			bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);			
			//get the groups to which this user belongs to 		
			CTDVString sGroupXML;		
			bOk = bOk && m_InputContext.GetUserGroups(sGroupXML, iThisUserID);
			sXML = sXML + sGroupXML;
		bOk = bOk && CloseXMLTag("USER");

		bOk = bOk && AddDBXMLDateTag("DateJoined");
		bOk = bOk && CloseXMLTag("MEMBER");
		TDVASSERT(bOk,"CTeam::GetTeamMembersSubSet - Problems getting member details from database");
		SP.MoveNext();
	}

	sXML << "</TEAM>";
	
	m_pTree = CXMLTree::Parse(sXML);

	if (m_pTree == NULL)
	{
		SetDNALastError("Team","XML","Failed to generate XML");	
		return false;
	}

	return true;
}

/*********************************************************************************

	void CTeam::GetTeamMembersSubSet(int iTeamID, int& show, int& numSkip)

	Author:		Nick Stevenson
	Created:	25/06/2003
	Inputs:		iTeamID: the type of the team,  numShow: number of items to display, 
				numSkip: element to start at
	Outputs:	- sTeamType <describe>, show, skip
	Returns:	- bool, true if <describe>
	Purpose:	Generates an XML formatted list of team members according to the 
				values of numSkip and numShow and up

*********************************************************************************/

bool CTeam::GetTeamMembersSubSet(int iTeamID, int& numShow, int& numSkip )
{

	// set the max number of members we can show on a page
	// 200 is the standard here
	int max_to_show = 200;
	if (numShow == 0 || numShow > max_to_show) 
	{
		numShow = max_to_show;
	}
	if(numSkip < 0 )
	{	
		numSkip = 0;
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CTeam::GetTeamMembersSubSet");
		return false;
	}

	if (!SP.GetNumberOfTeamMembers(iTeamID))
	{
		SetDNALastError("Team","Database","An Error Occurred while accessing the database");
		return false;
	}

	int iTotalMembers = SP.GetIntField("TotalMembers");

	CTDVString sXML = "<TEAM ID='";
	sXML << iTeamID << "'"; 
	if (!m_sType.IsEmpty())
	{
		sXML << " TYPE='" << m_sType << "'"; 
	}
	sXML << " TOTALMEMBERS='" << iTotalMembers << "' SKIPTO='" << numSkip << "' COUNT='" << numShow << "'>";
	
	if(iTotalMembers > 0){
		bool bNoMembers = true;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "Failed to create SP in CForum::GetThreadList");
			return false;
		}
		if (!SP.GetAllTeamMembers(iTeamID, m_InputContext.GetSiteID(),bNoMembers))
		{
			SetDNALastError("Team","Database","An Error Occurred while accessing the database");
			return false;
		}

		// cursor at first element so only 'move next' if we need to
		if (numSkip > 0)
		{
			SP.MoveNext(numSkip);
		}

		// Setup the XML for the current member
		bool bOk = true;
		InitialiseXMLBuilder(&sXML, &SP);
		int	index = numShow;
		while (bOk && !SP.IsEOF() && index > 0)
		{
			bOk = bOk && OpenXMLTag("MEMBER");
			bOk = bOk && AddDBXMLTag("Role",NULL,false);

			int iThisUserID = 0;

			bOk = bOk && OpenXMLTag("USER");
				bOk = bOk && AddDBXMLIntTag("User","USERID", true, &iThisUserID);
				bOk = bOk && AddDBXMLTag("UserName");
				bOk = bOk && AddDBXMLTag("FirstNames",NULL,false);
				bOk = bOk && AddDBXMLTag("LastName",NULL,false);			
				bOk = bOk && AddDBXMLTag("Area",NULL,false);
				bOk = bOk && AddDBXMLIntTag("Status", NULL, false);
				bOk = bOk && AddDBXMLIntTag("TaxonomyNode", NULL, false);
				bOk = bOk && AddDBXMLIntTag("Journal", NULL, false);
				bOk = bOk && AddDBXMLIntTag("Active");	
				bOk = bOk && AddDBXMLTag("Title",NULL,false);
				bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);			
				//get the groups to which this user belongs to 		
				CTDVString sGroupXML;		
				bOk = bOk && m_InputContext.GetUserGroups(sGroupXML, iThisUserID);
				sXML = sXML + sGroupXML;
			bOk = bOk && CloseXMLTag("USER");

			bOk = bOk && AddDBXMLDateTag("DateJoined");
			bOk = bOk && CloseXMLTag("MEMBER");
			TDVASSERT(bOk,"CTeam::GetTeamMembersSubSet - Problems getting member details from database");
			SP.MoveNext();
			index--;
		}
	}
 	sXML << "</TEAM>";

	m_pTree = CXMLTree::Parse(sXML);

	if (m_pTree == NULL)
	{
		SetDNALastError("Team","XML","Failed to generate XML");	
		return false;
	}

	return true;
}


/*********************************************************************************

	void CTeam::SetType(const TDVCHAR* sType)

	Author:		Dharmesh Raithatha
	Created:	5/16/2003
	Inputs:		the type of the team 
	Outputs:	-
	Returns:	-
	Purpose:	Sets the Type of the Team

*********************************************************************************/

void CTeam::SetType(const TDVCHAR* sType)
{
	m_sType = sType;
}

/*********************************************************************************

	void CTeam::GetClubIDAndClubTeamsForTeamID(int iTeamID, int& iClubID)

	Author:		Nick Stevenson
	Created:	25/06/2003
	Inputs:		the type of the team 
	Outputs:	- sTeamType <describe>, iClubID <describe>
	Returns:	- bool, true if <describe>
	Purpose:	Establishes club_id for the team id

*********************************************************************************/

bool CTeam::GetClubIDAndClubTeamsForTeamID(int iTeamID, CTDVString& sTeamType, int& iClubID)
{
	CStoredProcedure SP;

	// set up stored procedure
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	//bool bNoMembers = false;

	// write this stored proceedure
	bool bSuccess;
	int iMember = 0;
	int iOwner	= 0;
	int iClub	= 0;

	
	if (!SP.GetClubIDAndClubTeamsForTeamID(iTeamID, iClub, iMember, iOwner, bSuccess))
	{
		SetDNALastError("Team","Database","An Error Occurred while accessing the database");
		return false;
	}

		iClubID = iClub;	
		if(iOwner == iTeamID)
		{
			sTeamType = "OWNER";
		}
		else if(iMember == iTeamID)
		{
			sTeamType = "MEMBER";
		}
		else 
		{
			SetDNALastError("Team","Database","Team type could not be determined");
			return false;
		}


	if(iClubID <= 0 || !sTeamType.IsEmpty())
	{	
		bSuccess = false;
	}

	return true;
}

/*********************************************************************************

	bool CTeam::IsUserAMemberOfThisTeam(int iTeamID, int iUserID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iTeamID - The id of the Team
						iUserID - The id of the User
        Outputs:	bIsMember
        Returns:	true if ok, false if not
        Purpose:	returns true if a user is a member of a team false otherwise

*********************************************************************************/
bool CTeam::IsUserAMemberOfThisTeam(int iTeamID, int iUserID, bool& bIsMember)
{
	CStoredProcedure SP;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTeam::IsUserAMemberOfThisTeam","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure	
	if (!SP.IsUserAMemberOfThisTeam(iTeamID, iUserID, bIsMember))
	{
		return SetDNALastError("CTeam::IsUserAMemberOfThisTeam","FailedToExecuteIsUserAMemberOfThisTeam","Failed To Execute IsUserAMemberOfThisTeam");
	}

	return true;
}

/*********************************************************************************

	bool CTeam::GetForumIDForTeamID(int iTeamID, int iForumID)

		Author:		DE
        Created:	11/08/2005
        Inputs:		iTeamID - The id of the Team
						iForumID - The id of the Forum
        Outputs:	iForumID of this team
        Returns:	true if ok, false if not
        Purpose:	returns the id of the forum for this team

*********************************************************************************/
bool CTeam::GetForumIDForTeamID(int iTeamID, int& iForumID)
{
	CStoredProcedure SP;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTeam::GetForumIDForTeamID","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure	
	if (!SP.GetForumIDForTeamID(iTeamID, iForumID))
	{
		return SetDNALastError("CTeam::GetForumIDForTeamID","FailedToExecuteGetForumIDForTeamID","Failed To Execute GetForumIDForTeamID");
	}

	return true;
}
