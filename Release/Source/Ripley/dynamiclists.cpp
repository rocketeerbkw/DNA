#include "stdafx.h"
#include "tdvstring.h"
#include "inputcontext.h"
#include "StoredProcedure.h"
#include "tdvassert.h"
#include "dynamiclists.h"
#include "dynamiclist.h"

CDynamicLists::CDynamicLists() : m_bForceRefresh(true)
{
	InitializeCriticalSection(&ForceRefreshCS);
	InitializeCriticalSection(&listsCS);
}

CDynamicLists::~CDynamicLists()
{
	DeleteCriticalSection(&ForceRefreshCS);
	DeleteCriticalSection(&listsCS);
}


/*********************************************************************************

	CDynamicLists::ForceRefresh()

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Will cause cache to be refreshed next time its needed

*********************************************************************************/

void CDynamicLists::ForceRefresh()
{
	EnterCriticalSection(&ForceRefreshCS);
	m_bForceRefresh = true;
	LeaveCriticalSection(&ForceRefreshCS);
}


/*********************************************************************************

	bool CDynamicLists::ShouldRefresh()

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns true when lists needs to be reloaded

*********************************************************************************/

bool CDynamicLists::ShouldRefresh()
{
	EnterCriticalSection(&ForceRefreshCS);	
	bool bForce = m_bForceRefresh;
	LeaveCriticalSection(&ForceRefreshCS);

	return bForce;
}

/*********************************************************************************

	bool CDynamicLists::LoadLists(CInputContext & InputContext)

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Clears cache and loads lists from database

*********************************************************************************/

bool CDynamicLists::LoadLists(CInputContext & InputContext)
{
	// Run stored procedure
	CStoredProcedure SP;
	if(!InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CDynamicLists::LoadLists() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	// Get global lists
	if(!SP.DynamicListsGetGlobal())
	{
		TDVASSERT(false, "CDynamicLists::LoadLists() !SP.DynamicListsGetGlobal failed");
		return false;
	}
	else
	{
		CAutoCS cs(&listsCS);	// Critical section
	
		// Clear cache
		m_lists.clear();

		// Populate with new values	
		while(!SP.IsEOF())
		{
			// Siteid and ListID
			int iSiteID = SP.GetIntField("siteid");
			int iListID = SP.GetIntField("DynamicListID");
			
			// List Name and Type
			CTDVString name, type;
			if(!SP.GetField("name", name) 
				|| !SP.GetField("type", type))
			{
				TDVASSERT(false, "CDynamicLists::LoadLists() SP.GetField(name) failed");
			}
			else
			{
				m_lists[iSiteID].push_back(dlistrecord(iListID, (const char *)name, (const char *)type));
			}

			SP.MoveNext();
		}
	}

	return true;
}

/*********************************************************************************

	bool CDynamicLists::GetDynamicListsXml(int iSiteID)

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		nSiteID - ID of site for which to generate dlists
        Outputs:	sXML - XML block for <dynamic-lists>
        Returns:	-
        Purpose:	Returns <dynamic-lists> xml for site

*********************************************************************************/

bool CDynamicLists::GetDynamicListsXml(CTDVString &sXML, CInputContext & InputContext, int nSiteID)
{
	// Check if list is outdated
	if(ShouldRefresh())
	{
		if(!LoadLists(InputContext)) 
		{
			TDVASSERT(false, "CDynamicLists::GetDynamicListsXml() LoadLists Failed");
			return false;
		}
		else
		{
			// Cache is up to date
			EnterCriticalSection(&ForceRefreshCS);
			m_bForceRefresh = false;
			LeaveCriticalSection(&ForceRefreshCS);
		}
	}

	// Make copy of vector of lists. This allows us to release critical section quickly
	EnterCriticalSection(&listsCS);
	dlistvec vec = m_lists[nSiteID];
	LeaveCriticalSection(&listsCS);

	// Generate xml
	TDVASSERT(sXML.IsEmpty(), "CDynamicLists::GetDynamicListsXml() sXML param not empty. Contents will be cleared.");

	sXML = "<dynamic-lists>";
	
	// Make xml for each list
	dlistvec::iterator it = vec.begin();
	while(it != vec.end())
	{
		// Init with list name (still need to add id and type)
		CDynamicList dlist(InputContext, it->id, it->name.c_str(), it->type.c_str());
		
		// Create xml
		if(!dlist.MakeXML())
		{
			TDVASSERT(false, "CDynamicLists::GetDynamicListsXml() dlist.MakeXML failed");
		}
		else
		{
			// Add xml
			CTDVString dlistxml;
			if(!dlist.GetAsString(dlistxml))
			{
				TDVASSERT(false, "CDynamicLists::GetDynamicListsXml() dlist.GetAsString failed");
			}
			else
			{
				sXML += dlistxml;
			}
		}

		++it;
	}

	sXML += "</dynamic-lists>";

	return true;
}