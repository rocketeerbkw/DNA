/******************************************************************************
class:	CProfanityGroup

This class manages the PROFANITYGROUP xml element. It will be able to generate: 
	- A list of all sites belonging to this group (BASICSITELIST)
	  See class CBasicSiteList

Example Usage:
	CProfanityGroup profanityGroup(inputContext);
	profanityGroup.SetId(5);
	profanityGroup.SetName("Kids");
	profanityGroup.GenerateList(5);
	AddInside("PROFANITYGROUPLIST", profanityGroup.GetAsXML());

Implementation Details:
	- Has a CBasicSiteList member variable which is used to list all the sites 
	  that belong in this group. Note that this is not necessarily included. 
	  If the calling object only wants to add a PROFANITYGROUP element for the 
	  ID and NAME values then doesn't call GenerateList() then this won't be 
	  included i.e. the tag won't exist. If the BASICSITELIST is in the XML but
	  contains no elements then it means GenerateList() was called but there 
	  were no sites. See m_bShowList for how this works.
******************************************************************************/

#ifndef _PROFANITYGROUP_H_INCLUDED_
#define _PROFANITYGROUP_H_INCLUDED_

#include <vector>
#include <map>
#include "TDVString.h"
#include "XMLError.h"
#include "BasicSiteList.h"

class CProfanityGroup : public CXMLError
{
public:
	CProfanityGroup(CInputContext& inputContext);
	~CProfanityGroup();
	CProfanityGroup& operator=(const CProfanityGroup& group);

	void Clear();

	// Accessor methods
	//
	void SetId(const int iId);
	void SetName(const CTDVString& sName);
	const TDVCHAR* GetName();

	void AddSite(const CSite& site);
	void AddSite(const int iSiteId, const CTDVString& sSiteName);

	bool Populate(const int iGroupId);
	bool PopulateList(const int iGroupId);
	CTDVString GetAsXML();

	void GetSiteListAsCsv(CTDVString& sGroupSites);
	void GetSiteListAsMap(std::map<int, bool>& sites);

private:
	CInputContext& m_InputContext;
	int m_iId;
	CTDVString m_sName;
	bool m_bShowList;
	CBasicSiteList m_cBasicSiteList;
};




/*********************************************************************************
inline void CProfanityGroup::SetId(const int iId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanityGroup::SetId(const int iId)
{
	m_iId = iId;
}

/*********************************************************************************
inline void CProfanityGroup::SetName(const CTDVString& sName)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CProfanityGroup::SetName(const CTDVString& sName)
{
	m_sName = sName;
}


/*********************************************************************************
inline const TDVCHAR* CProfanityGroup::GetName()
Author:		David van Zijl
Created:	20/08/2004
Purpose:	Returns internal value
*********************************************************************************/

inline const TDVCHAR* CProfanityGroup::GetName()
{
	return m_sName;
}

/*********************************************************************************
inline void CProfanityGroup::AddSite(const int iSiteId, const CTDVString& sSiteName)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		iSiteId - numeric ID of site to be added
			sSiteName - name of site to be added
Outputs:	-
Returns:	-
Purpose:	Adds a site to the internal site list
*********************************************************************************/

inline void CProfanityGroup::AddSite(const int iSiteId, const CTDVString& sSiteName)
{
	m_bShowList = true;
	m_cBasicSiteList.AddSite(iSiteId, sSiteName);
}


/*********************************************************************************
inline void CProfanityGroup::AddSite(const CSite& site)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		site - site you are adding
Outputs:	-
Returns:	-
Purpose:	Adds a site to the internal site list
*********************************************************************************/

inline void CProfanityGroup::AddSite(const CSite& site)
{
	m_bShowList = true;
	m_cBasicSiteList.AddSite(site);
}


/*********************************************************************************
inline void CProfanityGroup::GetSiteListAsCsv(CTDVString& sGroupSites)
Author:		David van Zijl
Created:	29/07/2004
Inputs:		-
Outputs:	sGroupSites - CSV string goes here
Returns:	-
Purpose:	Returns the sites that belong to this group in a CSV string e.g. "3,5"
*********************************************************************************/

inline void CProfanityGroup::GetSiteListAsCsv(CTDVString& sGroupSites)
{
	m_cBasicSiteList.GetAsCsv(sGroupSites);
}


/*********************************************************************************
inline void CProfanityGroup::GetSiteListAsMap(std::map<int, bool>& sites)
Author:		David van Zijl
Created:	02/09/2004
Inputs:		-
Outputs:	sites - STL map of site ids
Returns:	-
Purpose:	Returns the sites that belong to this group in a map (site id => true)
*********************************************************************************/

inline void CProfanityGroup::GetSiteListAsMap(std::map<int, bool>& sites)
{
	m_cBasicSiteList.GetAsMap(sites);
}

#endif
