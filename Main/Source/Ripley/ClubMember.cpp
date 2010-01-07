// ClubMember.cpp: implementation of the CClubMember class.
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
#include "ClubMember.h"
#include "XMLStringUtils.h"
#include "Team.h"

/*********************************************************************************
	CClubMember::CClubMember()

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		-
	Purpose:	Constructor
*********************************************************************************/

CClubMember::CClubMember(CInputContext& inputContext)
:
CXMLObject(inputContext)
{
	Clear();
}


/*********************************************************************************
	CClubMember::~CClubMember()

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		-
	Purpose:	Destructor
*********************************************************************************/

CClubMember::~CClubMember()
{
}


/*********************************************************************************
	void CClubMember::Clear()

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Clears all internal variables
*********************************************************************************/

void CClubMember::Clear()
{
	m_iClubId = 0;	
	m_sName.Empty();
	m_bIncludeStrippedName = false;
	m_sExtraInfo.Empty();
	m_dateCreated.SetStatus( COleDateTime::null );
	m_lastUpdated.SetStatus( COleDateTime::null );
	m_bClubIsLocal = false;
}

/*********************************************************************************
	bool CClubMember::GetAsXML(CTDVString& sXML)

	Author:		David van Zijl
	Created:	20/07/2004
	Inputs:		sXML - destination for generated XML					
					CStoredProcedure& SP -  
	Outputs:	-
	Returns:	true on success
	Purpose:	Builds ARTICLEMEMBER xml based on current internal values
					NOTE: If m_iOwnerTeamID is not 0, a db call will be made to obtain the club owners
*********************************************************************************/

bool CClubMember::GetAsXML(CStoredProcedure& SP, CTDVString& sXML, bool& bMovedToNextRec )
{
	//extra check, set to true if MoveNext has moved cursor to the next row
	bMovedToNextRec = false;

	// Require a ClubId as a minimum
	if (m_iClubId == 0)
	{
		return false;
	}

	sXML << "<CLUBMEMBER>";
	sXML << "<CLUBID>" << m_iClubId << "</CLUBID>";

	if (!m_sName.IsEmpty())
	{
		sXML << "<NAME>" << m_sName << "</NAME>";
		if (m_bIncludeStrippedName)
		{
			CXMLStringUtils::AddStrippedNameXML(m_sName, sXML);
		}
	}
	if (!m_sExtraInfo.IsEmpty())
	{
		sXML << m_sExtraInfo;
	}
	if (m_dateCreated.GetStatus())
	{
		CTDVString sDateCreatedXML;
		m_dateCreated.GetAsXML(sDateCreatedXML);

		sXML << "<DATECREATED>" << sDateCreatedXML << "</DATECREATED>";
	}
	if (m_lastUpdated.GetStatus())
	{
		CTDVString sLastUpdatedXML;
		m_lastUpdated.GetAsXML(sLastUpdatedXML);

		sXML << "<LASTUPDATED>" << sLastUpdatedXML << "</LASTUPDATED>";
	}

	if (m_bClubIsLocal)
	{
		sXML << "<LOCAL>1</LOCAL>";
	}
	
	

	
	//////////////Comments////////////////////////////
	
	//////////////Comments////////////////////////////
	if (SP.FieldExists("ClubOwnerUserID") )
	{	
		CTDVString sClubMembers = "<CLUBOWNERS>";
		CTDVString sSubNodes;
		int iLastClubID = 0;
		while (!SP.IsEOF())
		{
			int iCurClubID = SP.GetIntField("ClubID");
			if (iCurClubID != iLastClubID && iLastClubID > 0 )
			{			
				break;
			}
			
			//same club but different club owner 
			CTDVString sUserName;
			CTDVString sFirstNames;
			CTDVString sLastName;
			CTDVString sArea;		
			CTDVString sSiteSuffix;
			CTDVString sTitle;
			int iUserID=0;
			int iStatus=0;
			int iTaxonomyNode=0;
			int iJournal = 0;
			int iActive = 0;
			
			SP.GetField("ClubOwnerUserName", sUserName);
			SP.GetField("ClubOwnerFirstNames", sFirstNames);
			SP.GetField("ClubOwnerLastName", sLastName);
			SP.GetField("ClubOwnerArea", sArea);
			SP.GetField("ClubOwnerSiteSuffix", sSiteSuffix);
			SP.GetField("ClubOwnerTitle", sTitle);
			iUserID = SP.GetIntField("ClubOwnerUserID");
			iStatus = SP.GetIntField("ClubOwnerStatus");
			iTaxonomyNode = SP.GetIntField("ClubOwnerTaxonomyNode");
			iJournal = SP.GetIntField("ClubOwnerJournal");
			iActive = SP.GetIntField("ClubOwnerActive");

			EscapeAllXML(&sUserName);
			EscapeAllXML(&sFirstNames);
			EscapeAllXML(&sLastName);
			EscapeAllXML(&sArea);
			EscapeAllXML(&sSiteSuffix);
			EscapeAllXML(&sTitle);

			//get the groups to which this user belongs to 		
			CTDVString sGroupXML;		
			m_InputContext.GetUserGroups(sGroupXML, iUserID);		

			sSubNodes << "<USER>";
				sSubNodes << "<USERID>" << iUserID << "</USERID>";
				sSubNodes << "<USERNAME>" << sUserName << "</USERNAME>";
				sSubNodes << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
				sSubNodes << "<LASTNAME>" << sLastName << "</LASTNAME>";
				sSubNodes << "<AREA>" << sArea << "</AREA>";
				sSubNodes << "<STATUS>" << iStatus << "</STATUS>";
				sSubNodes << "<TAXONOMYNODE>" << iTaxonomyNode << "</TAXONOMYNODE>";
				sSubNodes << "<ACTIVE>" << iActive << "</ACTIVE>";
				sSubNodes << "<JOURNAL>" << iJournal << "</JOURNAL>";
				sSubNodes << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
				sSubNodes << "<TITLE>" << sTitle << "</TITLE>";
				sSubNodes << sGroupXML;
			sSubNodes << "</USER>";


			iLastClubID = iCurClubID;

			SP.MoveNext();
			bMovedToNextRec = true;
		}
		sXML << sClubMembers << sSubNodes << "</CLUBOWNERS>";
	}

	sXML << "</CLUBMEMBER>";

	return true;
}

bool CClubMember::SetCrumbTrail()
{
	CCategory Cat(m_InputContext);
	Cat.GetClubCrumbTrail(m_iClubId);
	return Cat.GetAsString(m_sCrumbTrail);
}

void CClubMember::SetLocal()
{
	m_bClubIsLocal = true;
}
