using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Groups
{
    public interface ICachedGroups
    {
        /// <summary>
        /// Gets the cached information for the given user on a given site
        /// </summary>
        /// <param name="userID">The users ID</param>
        /// <param name="siteID">The site ID</param>
        /// <returns>The cached list of groups</returns>
        List<string> GetGroupsForUserAndSite(int userID, int siteID);

        /// <summary>
        /// Puts a list of groups into the cache for a given user and site
        /// </summary>
        /// <param name="userID">The users ID</param>
        /// <param name="siteID">The site ID</param>
        /// <param name="groups">The group list you want to cache</param>
        void PutGroupsForUserAndSite(int userID, int siteID, List<string> groups);

        /// <summary>
        /// Gets the cached list of all known groups
        /// </summary>
        /// <returns>The cached list of groups</returns>
        List<string> GetAllGroupNames();

        /// <summary>
        /// Puts the list of all known groups into cache
        /// </summary>
        /// <param name="groups">The list of groups you want to cache</param>
        void PutAllGroupNames(List<string> groups);
    }
}
