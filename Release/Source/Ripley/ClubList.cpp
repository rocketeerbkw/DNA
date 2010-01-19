// ClubList.cpp: implementation of the CClubList class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ClubList.h"
#include "ExtraInfo.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CClubList::CClubList(CInputContext& inputContext)
:
CXMLObject(inputContext)
{

}

CClubList::~CClubList()
{

}

/*********************************************************************************

	bool CClubList::ListClubs(int SiteID, bool bOrderByLastUpdated, int iSkip, int iShow)

	Author:		Nick Stevenson
	Created:	11/09/2003
	Inputs:		iSiteID = the site ID
				bOrderByLastUpdated = true  if you want list ordered by LastUpdated
									= false if you want list ordered by DateCreated
				iSkip = number of clubs to skip at the head of the list
				iShow = number of clubs to actually show in the list
	Outputs:	-
	Returns:	boolean success flag
	Purpose:	This displays all the clubs	

*********************************************************************************/

bool CClubList::ListClubs(int iSiteID, bool bOrderByLastUpdated, int iSkip, int iShow)
{
	if (iShow > 200)
	{
		iShow = 200;
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		//TDVASSERT(false, "Failed to create SP in CClubList::ListNewClubsInLastMonth()");
		return false;
	}

	CTDVString sClubListXML	= "";
	CTDVString sClubsXML	= "";
	int iShowCount			= 0;

	if (!SP.GetClubList(iSiteID, bOrderByLastUpdated))
	{
		SetDNALastError("ClubList","Database","An Error Occurred while accessing the database");
		return false;
	}

	SP.MoveNext(iSkip);

	//loop through the results and build the XML for the list
	while (iShow > 0 && !SP.IsEOF())
	{
		CTDVString sClubXML;

		int iClubID					= SP.GetIntField("ClubID"); 
		CTDVDateTime dtDateCreated	= SP.GetDateField("DateCreated");
		CTDVDateTime dtLastUpdated  = SP.GetDateField("LastUpdated");
		
		CTDVString sClubName;
		SP.GetField("Name", sClubName);

		CTDVString sExtraInfo;
		SP.GetField("ExtraInfo", sExtraInfo);
		
		if(sExtraInfo.IsEmpty()){
			SetDNALastError("ClubList","ExtraInfo","ExtraInfo string does not exist in DB for club id " + iClubID );	
			return false;
		}
	
		// build the individual club XML
		sClubXML << "<CLUB";
		sClubXML << " ID='" << iClubID << "'";
		sClubXML << " DateCreated='" << (LPCTSTR)dtDateCreated.Format( /*VAR_DATEVALUEONLY*/ ) << "'";
		sClubXML << " LastUpdated='" << (LPCTSTR)dtLastUpdated.Format( /*VAR_DATEVALUEONLY*/ ) << "'";
		sClubXML << ">";
		sClubXML << "<NAME>" << sClubName << "</NAME>";
		sClubXML << sExtraInfo;
		sClubXML << "</CLUB>";

		//add it to the club list
		sClubsXML << sClubXML;

		iShowCount++;
	
		iShow--;
		SP.MoveNext();
	}
	
	//wrap the clublist xml in the clublist tag
	sClubListXML << "<CLUBLIST SKIPTO='" << iSkip <<"' COUNT='" << iShowCount << "' ORDER='" << bOrderByLastUpdated << "'>";
	sClubListXML << sClubsXML;
	sClubListXML << "</CLUBLIST>";

	if (!CreateFromXMLText(sClubListXML))
	{
		SetDNALastError("Team","XML","Failed to generate XML");	
		return false;
	}

	return true;
}
