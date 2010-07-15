using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    [Serializable]
    public class CachedGroups
    {
        // The list of all users groups for every site
        // Dictionary(userid, Dictionary(siteid, List(groupdetails)))
        public Dictionary<string, List<UserGroup>> AllUsersGroupsAndSites = new Dictionary<string, List<UserGroup>>();

        public List<UserGroup> GroupList = null;

        public CachedGroups()
        {
            GroupList = new List<UserGroup>();
            AllUsersGroupsAndSites = new Dictionary<string, List<UserGroup>>();
        }

    }
}
