using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Groups
{
    public class CachedGroups : ICachedGroups
    {
        // The list of all users groups for every site
        // Dictionary(userid, Dictionary(siteid, List(groupdetails)))
        private Dictionary<int, Dictionary<int, List<string>>> _allUsersGroupsAndSites = new Dictionary<int, Dictionary<int, List<string>>>();

        /// <summary>
        /// Gets the cached information for the given user on a given site
        /// </summary>
        /// <param name="userID">The users ID</param>
        /// <param name="siteID">The site ID</param>
        /// <returns>The cached list of groups</returns>
        public List<string> GetGroupsForUserAndSite(int userID, int siteID)
        {
            List<string> userGroups = null;

            // Check to see if we've got the user already in the list
            if (_allUsersGroupsAndSites.ContainsKey(userID))
            {
                // Now check to see if we've got the group data for the given site
                if (_allUsersGroupsAndSites[userID].ContainsKey(siteID))
                {
                    // Get the list
                    userGroups = _allUsersGroupsAndSites[userID][siteID];
                }
            }

            // Return the group data if any
            return userGroups;
        }

        /// <summary>
        /// Puts a list of groups into the cache for a given user and site
        /// </summary>
        /// <param name="userID">The users ID</param>
        /// <param name="siteID">The site ID</param>
        /// <param name="groups">The group list you want to cache</param>
        public void PutGroupsForUserAndSite(int userID, int siteID, List<string> groups)
        {
            // Check to make sure the group list is not null. We don't add nulls!
            if (groups == null)
            {
                return;
            }

            // Check to make sure we have a valid item to add to
            if (!_allUsersGroupsAndSites.ContainsKey(userID))
            {
                _allUsersGroupsAndSites.Add(userID, new Dictionary<int, List<string>>());
            }

            // Add the new list to the main list
            if (!_allUsersGroupsAndSites[userID].ContainsKey(siteID))
            {
                _allUsersGroupsAndSites[userID].Add(siteID, groups);
            }
            else
            {
                _allUsersGroupsAndSites[userID][siteID] = groups;
            }
        }

        private List<string> _groupList = null;

        /// <summary>
        /// Gets the cached list of all known groups
        /// </summary>
        /// <returns>The cached list of groups</returns>
        public List<string> GetAllGroupNames()
        {
            return _groupList;
        }

        /// <summary>
        /// Puts the list of all known groups into cache
        /// </summary>
        /// <param name="groups">The list of groups you want to cache</param>
        public void PutAllGroupNames(List<string> groups)
        {
            _groupList = groups;
        }
    }
}
