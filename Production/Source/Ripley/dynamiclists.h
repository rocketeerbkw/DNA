#pragma once

#include <map>
#include <vector>
#include <string>

//
// Loads and caches dynamic lists for a site
// Uses CDynamicList to create <dynamic-lists xml block
// Must be used as a singleton, or else cache of lists for
// a site will be ineffecitve.
//
// Jamesp (19 jul 2005)
//

class CDynamicLists
{
private:
	
	// Instance of dlist record. This goes into a std::vector
	struct dlistrecord
	{
		dlistrecord(int nID, const char * szName, const char * szType)
		{
			// Blank strings are OK, but NULLs are not
			TDVASSERT(szName, "dlistrecord::dlistrecord() Expected a name");
			TDVASSERT(szType, "dlistrecord::dlistrecord() Expected a type");

			id = nID;
			if(szName) name = szName;
			if(szType) type = szType;
		}

		int id;				// ListID
		std::string name;	// ListName
		std::string type;	// ListType
	};

	// Key is siteid
	typedef std::vector<dlistrecord> dlistvec;
	typedef std::map<int,  dlistvec> dlistsmap;

	// Cache of lists
	dlistsmap	m_lists;
	
	// To protect cache update index
	CRITICAL_SECTION ForceRefreshCS;

	// To protect access to m_lists
	CRITICAL_SECTION listsCS;

	// When not zero, list needs to be reloaded
	bool m_bForceRefresh;

	// Clears cache and Loads lists from database
	bool LoadLists(CInputContext & InputContext);

	// Returns true when lists needs to be reloaded
	bool ShouldRefresh();

public:
	CDynamicLists();
	~CDynamicLists();

	// Gets dynamic lists xml for a site
	bool GetDynamicListsXml(CTDVString &sXML, CInputContext & InputContext, int nSiteID);
    
	// Expires cache so that its refershed. Here we refer
	// to cahe of dynamic lists for a site rather than the
	// dynamic list xml itself
	void ForceRefresh();

private:

	//
	// Class that automatically enters a critical section
	// in constructor and leaves it in destructor
	//

	class CAutoCS
	{
	private:
		CRITICAL_SECTION * m_pcs;
	public:
		CAutoCS(CRITICAL_SECTION * pcs) : m_pcs(pcs)
		{
			EnterCriticalSection(m_pcs);
		}

		~CAutoCS()
		{
			LeaveCriticalSection(m_pcs);
		}
	};
};
