/******************************************************************************
class:	CBasicSiteList

This class manages the BASICSITELIST xml element. It will be able to generate: 
	- A list of all sites, or all sites explicitely passed in (SITE)
	  See class CSite

Example Usage:
	CBasicSiteList basicSiteList(inputContext, "ALLSITES");
	// Then either pass each one in
		basicSiteList.AddSite(1, "H2G2");
		basicSiteList.AddSite(5, "iCan");
	// OR generate a list of all sites
		basicSiteList.GenerateList();
	CTDVString sXML;
	basicSiteList.GetAsXML(sXML);

Implementation details:
	- Contains a vector of CSite objects which are created when the 
	  GenerateList() method is called. When GetAsXML is called then GetAsXML 
	  is called on each of these and added to the result string.
******************************************************************************/

#ifndef _BASICSITELIST_H_INCLUDED_
#define _BASICSITELIST_H_INCLUDED_

#include <vector>
#include <map>
#include "TDVString.h"
#include "XMLError.h"
#include "InputContext.h"
#include "Site.h"

class CBasicSiteList : public CXMLError
{
public:
	CBasicSiteList(CInputContext& inputContext, const TDVCHAR* pType = "ALLSITES");
	~CBasicSiteList();

	CBasicSiteList& operator=(const CBasicSiteList& list);

	void Clear();

	// Accessor methods
	//
	void AddSite(const int iSiteId, const CTDVString& sSiteName);
	void AddSite(const CSite& site);

	CSite* GetSite( int SiteId );

	bool CutSite(const int iSiteId, CSite& site);
	bool PopulateList();
	CTDVString GetAsXML();
	CTDVString GetAsXML2();

	void GetAsCsv(CTDVString& sGroupSites);
	void GetAsMap(std::map<int, bool>& sites);

private:
	typedef std::vector<CSite> SITELIST;

	CInputContext m_InputContext;
	CTDVString m_sType;
	SITELIST m_vSites;
};



/*********************************************************************************
inline void CBasicSiteList::AddSite(const CSite& site)
Author:		David van Zijl
Created:	31/08/2004
Inputs:		site - site to be added to list
Outputs:	-
Returns:	-
Purpose:	Adds a CSite object to the list.
*********************************************************************************/

inline void CBasicSiteList::AddSite(const CSite& site)
{
	m_vSites.push_back( site );
}

#endif
