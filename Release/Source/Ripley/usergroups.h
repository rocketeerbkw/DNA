// header file for CUserGroups class
// created: 08/04/05
// author: james pullicino

#pragma once

#include <map>
#include <string>
#include <vector>

// == Purpose ==
//
// Generates <GROUPS> element for <USER> element
// Has in-memory cache of groups and members to
// minimize database hits. Only one instance of
// this class should be created, or else cache is
// ineffective.
//

// == Lifetime ==
//
// This class is behaves like a singleton. It is
// created once in CGI class. The instance from
// CGI class must be used or else cache will have
// to be reloaded.
//

// === Cache Size ==
//
// Cache is designed to take as little memory as possible. Due to the nature
// of the data, it is currently more memory efficient to store 'Users in Groups'
// than 'Groups of User'.
//
// If average groups for user ever exceeds average users in groups, the way the 
// cache stored could be changed to take up less memory.
//
// Approx size of cache with current data (12/04/05)
// is 5451 bytes calculated as follows:
//
// struct group
// {
//  int groupid;			// 4 bytes
//  int userids[1];			// 4 bytes
//  char groupname[15];		// 15 bytes
// };
//
// group groups[237];		// (4+4+15)*237 = 5451 bytes
//
// Current group count is 237 (select count(*) from groups)
//
// Average users in each group is 1 and is calculated as follows:
//
// -- avg users in each group
// select 'avg' = avg(dd.groupcount), 'sum' = sum(dd.groupcount), 'count' = count(dd.groupcount) from
// (
// select UserID, count(gm.GroupID) as groupcount from GroupMembers gm
// inner join groups g on g.GroupID = gm.GroupID and userinfo=1
// group by UserID
// ) as dd
//
// Average groups for each user is 13 and is calculated as follows:
//
// -- avg groups for each user
// select 'avg' = avg(ss.members), 'sum' = sum(ss.members), 'count' = count(ss.members) from
// (
// select g.GroupID, g.name, count(gm.userid) as Members from groups g 
// inner join groupmembers gm on gm.groupid = g.groupid
// group by g.groupid, g.name
// ) as ss
//

//
// === Invalidating the Cache ===
//
// When cache is invalidated or expired it will be refreshed
// next time its needed.
//
// Cache is invalidated in these ways:
//
// 1) When new groups are created (InspectUser)
// 2) When groups members are added (InspectUser)
// 3) When the Signal "recache-groups" is received (SignalBuilder)
// 4) When the _gc=1 parameter is passed on URL
// 5) By calling CUserGroups::SetCacheExpired() function
//

class CUserGroups
{
private:
	// [siteid][groupid][groupname, userids]
	//typedef std::vector<int> GroupMembers;
	//typedef std::pair<std::string,  GroupMembers> GroupEntry;
	//typedef std::map<int, GroupEntry> GroupsMap;
	//typedef std::map<int, GroupsMap > SiteGroupsMap;

	typedef std::multimap<int,int> UserGroupData;
	typedef std::map<int, UserGroupData*> UsersData;
	typedef std::map<int, std::string> GroupNames;

	
	// All data is stored here. Clients will be accessing m_Groups
	// in a multithreaded manner.
	//SiteGroupsMap* m_pGroups;
	UsersData* m_pUsersData;
	GroupNames* m_pGroupNames;

	// The string representation of the groups data
	//CTDVString m_GroupsString;

	// To protect access to m_Groups
	CRITICAL_SECTION GroupsMapCS;
	CRITICAL_SECTION RebuildCS;

	// No more cache flag or count
	//// To protect cache update index
	//CRITICAL_SECTION CacheExpiredCountCS;

	// Where cache is loaded from
	bool RefreshCache(CInputContext & InputContext);

	// Checks if cache is expired
//	bool IsCacheExpired();

	// Stores the number of times that cache has expired
	// without being refreshed.
//	int m_nCacheExpiredCount;
	bool m_bCachePopulated;

	void ToString(CTDVString& sXML, int nUserID, int nSiteID);

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

public:
	CUserGroups();
	~CUserGroups();

	// Create <GROUPS> xml for nUserID 
	bool GetUserGroups(CTDVString &sXML, int nUserID,  CInputContext & InputContext, int nSiteID = 0);

	// Expire cache
	void SetCacheExpired(CInputContext& InputContext);
	bool RefreshUserGroups(CInputContext& InputContext, int iUserID);
};
