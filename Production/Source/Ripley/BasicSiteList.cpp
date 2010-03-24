#include "stdafx.h"
#include "tdvassert.h"
#include "ProfanityGroup.h"
#include "StoredProcedure.h"
#include "BasicSiteList.h"

/*********************************************************************************
CBasicSiteList::CBasicSiteList(CInputContext& inputContext, const TDVCHAR* pType)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CBasicSiteList::CBasicSiteList(CInputContext& inputContext, const TDVCHAR* pType) :
	CXMLError(),
	m_InputContext(inputContext)
{
	Clear();
	m_sType = pType;
}


/*********************************************************************************
CBasicSiteList::~CBasicSiteList()
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CBasicSiteList::~CBasicSiteList()
{
	m_vSites.clear();
}


/*********************************************************************************
void CBasicSiteList::Clear()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	-
Purpose:	Clears or zeros all internal variables
*********************************************************************************/

void CBasicSiteList::Clear()
{
	m_vSites.clear();
}


/*********************************************************************************
void CBasicSiteList::AddSite(const int iSiteId, const CTDVString& sSiteName)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iSiteId - numeric ID of site to be added
			sSiteName - name of site to be added
Outputs:	-
Returns:	-
Purpose:	Adds a CSite object to the list. This is used when the calling object
			has the site details from some SP. i.e. We are not using GenerateList()
*********************************************************************************/

void CBasicSiteList::AddSite(const int iSiteId, const CTDVString& sSiteName)
{
	if (iSiteId == 0)
	{
		TDVASSERT(false, "CBasicSiteList::AddSite called with zero id");
		return;
	}
	TDVASSERT(!sSiteName.IsEmpty(), "CBasicSiteList::AddSite called with empty site name");

	CSite newSite;
	newSite.SetId( iSiteId );
	newSite.SetName( sSiteName );

	AddSite( newSite );
}


/*********************************************************************************
bool CBasicSiteList::CutSite(const int iSiteId, CSite& site)
Author:		David van Zijl
Created:	31/08/2004
Inputs:		iSiteId - ID of site you want to remove
Outputs:	site - ref to a CSite object where the removed site will be placed
Returns:	true if site found, false otherwise
Purpose:	Finds a site that matches an id and removes it from the list.
*********************************************************************************/

bool CBasicSiteList::CutSite(const int iSiteId, CSite& site)
{
	bool bFoundSite = false;
	SITELIST::iterator i = m_vSites.begin();

	while (!bFoundSite && i != m_vSites.end())
	{
		if (i->GetId() == iSiteId)
		{
			// Found it! Remove it
			//
			site = *i;
			m_vSites.erase(i);
			bFoundSite = true;
		}
		else
		{
			i++;
		}
	}

	return bFoundSite;
}


/*********************************************************************************
bool CBasicSiteList::GenerateList()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	true on success
Purpose:	Fetches all sites from DB and stores them internally, optionally you 
			can specify a list of sites to exclude
*********************************************************************************/

bool CBasicSiteList::PopulateList()
{
	// Get site list and group info from DB
	//
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetSitesModerationDetails())
	{
		SetDNALastError("CBasicSiteList","DATABASE","An Error Occurred while accessing the database");
		return false;
	}

	// For each row, create a Profanity object and add it to the list
	//
	bool bIncludeThisSite = true;

	CTDVString sSiteName;
	CTDVString sDescription;
	CTDVString sUrlName;
	CSite newSite;

	while(!SP.IsEOF())
	{
		SP.GetField("ShortName", sSiteName);
		SP.GetField("Description", sDescription);
		SP.GetField("UrlName", sUrlName);

		newSite.Clear();
		newSite.SetId( SP.GetIntField("SiteID") );
		newSite.SetName( sSiteName );
		newSite.SetDescription(sDescription);
		newSite.SetModerationClass( SP.GetIntField("ModClassId"));
		newSite.SetUrlName(sUrlName);
		m_vSites.push_back( newSite );

		SP.MoveNext();
	}

	return true;
}


/*********************************************************************************
CTDVString CBasicSiteList::GetAsXML()
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Builds the entire XML structure for this object and returns it as a string.
			Provided for legacy support.
*********************************************************************************/

CTDVString CBasicSiteList::GetAsXML()
{
	CTDVString sXML;

	sXML << "<BASICSITELIST TYPE=\"" << m_sType << "\">";

	// Loop through sites and add each to the XML string in turn
	//
	for (SITELIST::iterator current = m_vSites.begin(); current != m_vSites.end(); current++)
	{
		sXML << current->GetAsXML();
	}

	sXML << "</BASICSITELIST>";

	return sXML;
}

/*********************************************************************************
CTDVString CBasicSiteList::GetAsXML2()
Author:		Martin Robb
Created:	29/07/2004
Inputs:		-
Outputs:	-
Returns:	XML string of entire object
Purpose:	Creates a SITE-LIST XML block.
*********************************************************************************/
CTDVString CBasicSiteList::GetAsXML2()
{
	CTDVString sXML;
	sXML << "<SITE-LIST TYPE='" << m_sType << "'>";

	// Loop through sites and add each to the XML string in turn
	for (SITELIST::iterator current = m_vSites.begin(); current != m_vSites.end(); current++)
	{
		sXML << current->GetAsXML();
	}

	sXML << "</SITE-LIST>";

	return sXML;
}


/*********************************************************************************
void CBasicSiteList::GetAsCsv(CTDVString& sGroupSites)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	sGroupSites - CSV string goes here
Returns:	-
Purpose:	Returns the sites that belong to this group in a CSV string e.g. "3,5"
*********************************************************************************/

void CBasicSiteList::GetAsCsv(CTDVString& sGroupSites)
{
	sGroupSites.Empty();
	if (m_vSites.size() > 0)
	{
		for (SITELIST::iterator current = m_vSites.begin(); current != m_vSites.end(); current++)
		{
			// We may need to add a comma if this is not the first element
			//
			if (current != m_vSites.begin())
			{
				sGroupSites += ",";
			}
			CTDVString sNumToString = current->GetId();
			sGroupSites += sNumToString;
		}
	}
}


/*********************************************************************************
void CBasicSiteList::GetAsMap(std::map<int, bool>& sites)
Author:		David van Zijl
Created:	02/09/2004
Inputs:		-
Outputs:	sites - STL map of site ids
Returns:	-
Purpose:	Returns the sites that belong to this group in a map (site id => true)
*********************************************************************************/

void CBasicSiteList::GetAsMap(std::map<int, bool>& sites)
{
	sites.clear();

	if (m_vSites.size() > 0)
	{
		for (SITELIST::iterator current = m_vSites.begin(); current != m_vSites.end(); current++)
		{
			sites[current->GetId()] = true;
		}
	}
}

/*********************************************************************************
void CBasicSiteList::GetSite(int id)
Author:		Martin Robb
Created:	10/02/2006
Inputs:		-
Outputs:	sites - STL map of site ids
Returns:	-
Purpose:	Access to site given ID
*********************************************************************************/
CSite*  CBasicSiteList::GetSite( int siteId )
{
	for (SITELIST::iterator current = m_vSites.begin(); current != m_vSites.end(); current++)
	{
		if ( current->GetId() == siteId )
			return &(*current);
	}
	return NULL;
}

CBasicSiteList& CBasicSiteList::operator=(const CBasicSiteList& list)
{
	m_sType = list.m_sType;
	m_vSites = list.m_vSites;
	return *this;
}
