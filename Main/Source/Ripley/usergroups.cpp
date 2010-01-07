#include "stdafx.h"
#include "tdvstring.h"
#include "inputcontext.h"
#include "usergroups.h"
#include "StoredProcedure.h"
#include "tdvassert.h"

// STL
#include <map>
#include <string>
#include <vector>
#include <algorithm>

/*
 PLEASE NOTE: I have refactored this code. 
			  It is also no longer re-cached on demand because that leads to huge numbers of calls when the service is
			  busy. Instead, when the server is signalled that the cache needs refreshing, it immediately reads the 
			  new data, meaning it only happens once per recache per server.

			  Jim.
			  
*/

CUserGroups::CUserGroups() : m_pUsersData(NULL), m_pGroupNames(NULL), m_bCachePopulated(false)
{
//	OutputDebugString("CUserGroups::CUserGroups()\n");

	InitializeCriticalSection(&GroupsMapCS);
	InitializeCriticalSection(&RebuildCS);
//	InitializeCriticalSection(&CacheExpiredCountCS);
}

CUserGroups::~CUserGroups()
{
//	OutputDebugString("CUserGroups::~CUserGroups()\n");

	DeleteCriticalSection(&GroupsMapCS);
	DeleteCriticalSection(&RebuildCS);
	//DeleteCriticalSection(&CacheExpiredCountCS);
		GroupNames* pTempGroupNames = m_pGroupNames;
		UsersData* pTempUsersData = m_pUsersData;
		if (pTempGroupNames)
		{
			delete pTempGroupNames;
		}
		if (pTempUsersData)
		{
			for (UsersData::iterator udit = pTempUsersData->begin(); udit != pTempUsersData->end(); udit++)
			{
				delete (udit->second);
				udit->second = NULL;
			}
			
			delete pTempUsersData;
		}
}	


/*********************************************************************************

	bool CUserGroups::GetUserGroups(CTDVString &sXML, int nUserID, int nSiteID = 0)

		Author:		James Pullicino
        Created:	08/04/2005
        
		Inputs:		sXML	- EMPTY string
					nUserID	- ID of user for whom you want the groups
					nSiteID	- ID of site to get groups of. If set to 0
							  will get groups of current site.
					
					InputContext - Current input context

        Outputs:	sXML	- On success, contains <GROUPS> xml
        Returns:	true on success
        Purpose:	Creates <GROUPS> element with groups for user

*********************************************************************************/

bool CUserGroups::GetUserGroups(CTDVString &sXML, int nUserID, CInputContext & InputContext, int nSiteID)
{
	//InputContext.LogTimerEvent("UGCT:Entering GetUserGroups");
	// I like doing this
	if(!sXML.IsEmpty())
	{
		TDVASSERT(false, "CUserGroups::GetUserGroups() sXML parameter must be empty string");
		return false;
	}

	// We don't use the cache flag any more
	//// Check cache status and refresh if need be
	//if(IsCacheExpired())
	//{
	//	if(!RefreshCache(InputContext))	// Refresh cache
	//	{
	//		TDVASSERT(false, "CUserGroups::GetUserGroups() failed to refresh RefreshCache() failed");
	//		return false;
	//	}
	//}

	// Fix site id
	if(!nSiteID) 
		nSiteID = InputContext.GetSiteID();	// Current site id
	{
		//CAutoCS acs(&GroupsMapCS);
		if (m_bCachePopulated)
		{
			//InputContext.LogTimerEvent("UGCT:Calling ToString");
			ToString(sXML, nUserID, nSiteID);
			//InputContext.LogTimerEvent("UGCT:Called ToString");
			//InputContext.LogTimerEvent("UGCT:Leaving GetUserGroups");
			return true;
		}
		else
		{
			if(!RefreshCache(InputContext))	// Refresh cache
			{
				TDVASSERT(false, "CUserGroups::GetUserGroups() failed to refresh RefreshCache() failed");
				//InputContext.LogTimerEvent("UGCT:Leaving GetUserGroups");
				return false;
			}
			//InputContext.LogTimerEvent("UGCT:Calling ToString");
			ToString(sXML, nUserID, nSiteID);
			//InputContext.LogTimerEvent("UGCT:Called ToString");
			//InputContext.LogTimerEvent("UGCT:Leaving GetUserGroups");
			return true;
		}
	}
}
void CUserGroups::ToString(CTDVString& sXML, int nUserID, int nSiteID)
{
	//{
	//	CAutoCS	acs(&GroupsMapCS);	 // Manipulate map in a critical section

	//	// Get groups map of site
	//	SiteGroupsMap::iterator it = m_pGroups->find(nSiteID);
	//	if(it == m_pGroups->end())
	//	{
	//		// No data for this site. Not an error.
	//		sXML = "<GROUPS />";
	//		return;
	//	}

	//	// Find groups of this user
	//	GroupsMap & groups = it->second;
	//	GroupsMap::iterator itGroups = groups.begin();

	//	sXML = "<GROUPS>";	// Open groups tag

	//	while(itGroups != groups.end())
	//	{
	//		GroupEntry & groupEntry = itGroups->second;
	//		GroupMembers & groupMembers = groupEntry.second;

	//		// Find ID in vector
	//		if(std::find(groupMembers.begin(), groupMembers.end(), nUserID) != groupMembers.end())
	//		{
	//			// User found in this group. Add groupname to XML
	//			sXML << "<" << groupEntry.first.c_str() << "/>";
	//			//Add New Format
	//			CTDVString sGroupName = groupEntry.first.c_str();
	//			sGroupName.MakeUpper();

	//			sXML << "<GROUP><NAME>" << sGroupName << "</NAME></GROUP>";
	//		}

	//		++itGroups;
	//	}
	//}

	//sXML << "</GROUPS>";	// Close groups tag

	//return;

	{
		CAutoCS acs(&GroupsMapCS);
		if (m_pUsersData->find(nUserID) == m_pUsersData->end())
		{
			sXML = "<GROUPS />";
			return;
		}
		UserGroupData* pUserData = (*m_pUsersData)[nUserID];
		UserGroupData::iterator it = pUserData->find(nSiteID);
		if (it == pUserData->end())
		{
			sXML = "<GROUPS />";
			return;
		}

		sXML = "<GROUPS>";

		while (it != pUserData->end() && it->first == nSiteID)
		{
			CTDVString sGroupName = ((*m_pGroupNames)[it->second]).c_str();
			sGroupName.MakeUpper();
			sXML << "<" << sGroupName << "/>";
			sXML << "<GROUP><NAME>" << sGroupName << "</NAME></GROUP>";
			it++;
		}

	}
	sXML << "</GROUPS>";
	return;
}

/*********************************************************************************

	bool CUserGroups::IsCacheExpired()

		Author:		James Pullicino
        Created:	08/04/2005
        Returns:	Returns true if cache needs to be refreshed

*********************************************************************************/

//bool CUserGroups::IsCacheExpired()
//{
//	bool bExpired;
//	EnterCriticalSection(&CacheExpiredCountCS);
//	bExpired = (m_nCacheExpiredCount > 0);
//	LeaveCriticalSection(&CacheExpiredCountCS);
//	return bExpired;
//}

/*********************************************************************************

	void CUserGroups::SetCacheExpired()

		Author:		James Pullicino
        Created:	11/04/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Will cause cache to be refreshed next time its needed

*********************************************************************************/

void CUserGroups::SetCacheExpired(CInputContext& InputContext)
{
	//EnterCriticalSection(&CacheExpiredCountCS);
	//m_nCacheExpiredCount++;
	//LeaveCriticalSection(&CacheExpiredCountCS);
	RefreshCache(InputContext);
}

/*********************************************************************************

	bool CUserGroups::RefreshCache(CInputContext & InputContext)

		Author:		James Pullicino
        Created:	08/04/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Clears cache data and reloads it from database

*********************************************************************************/

bool CUserGroups::RefreshCache(CInputContext & InputContext)
{
	CAutoCS refresh(&RebuildCS);
	//InputContext.LogTimerEvent("UGCT:Entering UserGroups cache refresh");
	// Create a whole new map for the new data so we can swap out the old data quickly	
	//SiteGroupsMap* pGroups = new SiteGroupsMap();
	UsersData* pUsersData = new UsersData();
	GroupNames* pGroupNames = new GroupNames();

	// Run stored procedure
	CStoredProcedure SP;
	if(!InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CUserGroups::RefreshCache() m_InputContext.InitialiseStoredProcedureObject failed");
		//InputContext.LogTimerEvent("UGCT:Leaving UserGroups cache refresh");
		return false;
	}

	// Fetch data
//	Sleep(2000);
	if(!SP.FetchGroupsAndMembers())
	{
		TDVASSERT(false, "CUserGroups::RefreshCache() SP.FetchGroupsAndMembers failed");
		//InputContext.LogTimerEvent("UGCT:Leaving UserGroups cache refresh");
		return false;
	}
	else
	{	
		// Validate cache counter
		//EnterCriticalSection(&CacheExpiredCountCS);
		//m_nCacheExpiredCount = 0;
		//LeaveCriticalSection(&CacheExpiredCountCS);

		// Clear cache map
//		pGroups->clear();

		// Load data
		while(!SP.IsEOF())
		{
			int nSiteID		= SP.GetIntField("siteid");		// SiteID
			int nGroupID	= SP.GetIntField("groupid");	// GroupID
			int nUserID		= SP.GetIntField("userid");		// UserID
			
			// Groups.Name
			CTDVString sGroupName;
			if(!SP.GetField("name", sGroupName))
			{
				// Skip this record, continue with rest
				TDVASSERT(false, "CUserGroups::RefreshCache() SP.GetField failed");
			}
			else	// Add to map
			{
				//GroupEntry & groupEntry = (*pGroups)[nSiteID][nGroupID];
				//
				//// Only set name once
				//if(groupEntry.first.empty())
				//	groupEntry.first = sGroupName;
				//
				//// Add user id to vector of group entry
				//groupEntry.second.push_back(nUserID);

				// And the new data structures
				
				if (((*pGroupNames)[nGroupID]).empty())
				{
					(*pGroupNames)[nGroupID] = sGroupName;
				}
				if ((*pUsersData)[nUserID] == 0)
				{
					UserGroupData* pNewData = new UserGroupData();
					pNewData->insert(std::pair<int,int>(nSiteID,nGroupID));

					(*pUsersData)[nUserID] = pNewData;
				}
				else
				{
					((*pUsersData)[nUserID])->insert(std::pair<int,int>(nSiteID, nGroupID));
				}
			}

			SP.MoveNext();
		}
	}
//	Sleep(2000);
//	SiteGroupsMap* pTempMap = m_pGroups;
	if (true)
	{
		CAutoCS	acs(&GroupsMapCS);	 // Manipulate map in a critical section
		//InputContext.LogTimerEvent("UGCT:Entering UserGroups data swap code");
		//m_pGroups = pGroups;
		//if (pTempMap)
		//{
		//	delete pTempMap;
		//}
		GroupNames* pTempGroupNames = m_pGroupNames;
		UsersData* pTempUsersData = m_pUsersData;
		m_pGroupNames = pGroupNames;
		if (pTempGroupNames)
		{
			delete pTempGroupNames;
		}
		m_pUsersData = pUsersData;
		if (pTempUsersData)
		{
			for (UsersData::iterator udit = pTempUsersData->begin(); udit != pTempUsersData->end(); udit++)
			{
				delete (udit->second);
				udit->second = NULL;
			}
			
			delete pTempUsersData;
		}
		//InputContext.LogTimerEvent("UGCT:Leaving UserGroups data swap code");
	}
	m_bCachePopulated = true;
//	Sleep(2000);
	//InputContext.LogTimerEvent("UGCT:Leaving UserGroups cache refresh");
	return true;
}

bool CUserGroups::RefreshUserGroups(CInputContext &InputContext, int iUserID)
{
	CAutoCS refresh(&RebuildCS);
	if (!m_bCachePopulated)
	{
		return RefreshCache(InputContext);
	}
	//InputContext.LogTimerEvent("UGCT:Entering UserGroups userid cache refresh");
	CStoredProcedure SP;
	if (!InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to initialise SP when fetching a user's groups for the cache");
		//InputContext.LogTimerEvent("UGCT:Leaving UserGroups userid cache refresh");
		return false;
	}
//	Sleep(2000);
	if (!SP.FetchGroupsForUser(iUserID))
	{
		TDVASSERT(false, "Failed to call FetchGroupsForUser when fetching a user's groups for the cache");
		//InputContext.LogTimerEvent("UGCT:Leaving UserGroups userid cache refresh");
		return false;
	}
	UserGroupData* pNewData = new UserGroupData();
	while (!SP.IsEOF())
	{
		int iGroupID = SP.GetIntField("GroupID");
		int iSiteID = SP.GetIntField("SiteID");
		pNewData->insert(std::pair<int,int>(iSiteID, iGroupID));
		SP.MoveNext();
	}
//	Sleep(2000);
	// Now replace the existing user data in the user list with this new data
	if (true)
	{
		CAutoCS acs(&GroupsMapCS);
		//InputContext.LogTimerEvent("UGCT:Entering swap code for user group data");
		UserGroupData* pOldUserData = (*m_pUsersData)[iUserID];
		(*m_pUsersData)[iUserID] = pNewData;
		if (pOldUserData != NULL)
		{
			delete pOldUserData;
		}
		//InputContext.LogTimerEvent("UGCT:Leaving swap code for user group data");
	}
	//InputContext.LogTimerEvent("UGCT:Leaving UserGroups userid cache refresh");
	return true;
}