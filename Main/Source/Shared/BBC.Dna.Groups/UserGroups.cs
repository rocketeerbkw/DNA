using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Configuration;
using System.Runtime.Serialization;

namespace BBC.Dna.Groups
{
    [DataContract(Name = "userGroups")]
    public class UserGroups : IUserGroups
    {
        private ICacheManager _cachedGroups = null;
        private IDnaDataReaderCreator _dnaDataReaderCreator = null;
        private IDnaDiagnostics _dnaDiagnostics = null;
        private List<UserGroup> _allGroups = null;

#if DEBUG
        public static string _cacheName = "BBC.Dna.UserGroups-";
#else
        private static string _cacheName = "BBC.Dna.UserGroups-";
#endif
        private static bool IsInitialised = false;

        public List<UserGroup> AllGroups
        {
            get { return _allGroups; }
            set { _allGroups = value; }
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionString">Connection details for accessing the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public UserGroups(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching)
        {
            _dnaDataReaderCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;


            _cachedGroups = caching;
            if (_cachedGroups == null)
            {
                _cachedGroups = new StaticCacheManager();
            }
        }

        /// <summary>
        /// Creates a new stored procedure reader for the given procedure
        /// </summary>
        /// <param name="procedureName">The name of the procedure you want to call</param>
        /// <returns>A stored procedure reader ready to execute the given stored procedure</returns>
        private IDnaDataReader CreateStoreProcedureReader(string procedureName)
        {
            return _dnaDataReaderCreator.CreateDnaDataReader(procedureName);
        }

        /// <summary>
        /// Adds a given user to a given group for a site
        /// </summary>
        /// <param name="userID">The users id to add to the group</param>
        /// <param name="groupName">The group name to add the user to</param>
        /// <param name="siteID">The id of the site to add the user to</param>
        /// <returns>True if they were added correctly, false if not</returns>
        public bool PutUserIntoGroup(int userID, string groupName, int siteID)
        {
            // Check to see if we've got a list for this user already
            List<UserGroup> userGroups = GetUsersGroupListForSite(userID, siteID);

            // Ok, got a list. Check to make sure they don't already belong to the group
            if (userGroups != null)
            {
                if (IsItemInList(userGroups, groupName.ToLower()))
                {
                    // Already a member of this group. Nothing to do
                    return true;
                }
            }
            else
            {
                // Ok, no group list for this user on this site
                userGroups = new List<UserGroup>();
            }

            // Add the user to the group in the database
            using (IDnaDataReader reader = CreateStoreProcedureReader("AddUserToGroup"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("groupname", groupName);
                reader.Execute();
            }

            // Add the new group to their current list
            userGroups.Add(new UserGroup() { Name = groupName.ToLower()});

            // Add the updated group list to the main cache list
            AddUserGroupListToMainList(userID, siteID, userGroups);
            return true;
        }

        public bool IsItemInList(List<UserGroup> list, string name)
        {
            bool itemInList = ((from i in list where i.Name == name.ToLower()
                                select i).Count() > 0);
            return itemInList;
        }

        /// <summary>
        /// Removes a user from a given group on a site
        /// </summary>
        /// <param name="userID">The users id to remove</param>
        /// <param name="groupName">The group name to remove from</param>
        /// <param name="siteID">The id of the site to remove the user from the group</param>
        public void DeleteUserFromGroup(int userID, string groupName, int siteID)
        {
            // Check to see if we've got a list for this user already
            List<UserGroup> userGroups = GetUsersGroupListForSite(userID, siteID);

            // Ok, got a list. Check to make sure they don't already belong to the group
            if (userGroups != null)
            {
                if (!IsItemInList(userGroups, groupName.ToLower()))
                {
                    // Not in this group, nothing to remove
                    return;
                }

                // Remove the group to their current list
                UserGroup itemToRemove = (from u in userGroups
                                          where u.Name == groupName.ToLower()
                                          select u).FirstOrDefault();
                userGroups.Remove(itemToRemove);
            }
            else
            {
                // Ok, no group list currently for this user
                userGroups = new List<UserGroup>();
            }

            // Remove the user from the group in the database
            using (IDnaDataReader reader = CreateStoreProcedureReader("RemoveUserFromGroup"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("groupname", groupName);
                reader.Execute();
            }

            // Add the updated group list to the main cache list
            AddUserGroupListToMainList(userID, siteID, userGroups);
        }

        /// <summary>
        /// Gets all the groups that a user belongs to on a given site
        /// </summary>
        /// <param name="userID">The users id you want to get the groups for</param>
        /// <param name="siteID">The sites id you want to get the group info from</param>
        /// <returns>a list of the groups the user belongs to for a given site</returns>
        public List<UserGroup> GetUsersGroupsForSite(int userID, int siteID)
        {
            if(!IsInitialised)
            {
                throw new Exception("Users groups not initialised");
            }
            // Check to see if we've got a list for this user already
            var list = GetUsersGroupListForSite(userID, siteID);
            if(list == null)
            {
                list = new List<UserGroup>();
            }
            return list;

            // No list found, get the information from the database
            /*if (userGroups == null)
            {
                try
                {
                    userGroups = new List<string>();
                    using (IDnaDataReader reader = CreateStoreProcedureReader("GetGroupsFromUserAndSite"))
                    {
                        reader.AddParameter("userid", userID);
                        reader.AddParameter("siteid", siteID);
                        reader.Execute();

                        // Go through all the results adding the groups to the list
                        while (reader.Read())
                        {
                            if (!reader.IsDBNull("groupname"))
                            {
                                userGroups.Add(reader.GetString("groupname").ToLower());
                            }
                        }
                    }

                    // Add the new group list to the main cache list
                    AddUserGroupListToMainList(userID, siteID, userGroups);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    throw ex;
                }
            }*/

            //return userGroups;
        }

        /// <summary>
        /// Gets all the groups for all the users and sets up the cached information
        /// </summary>
        /// <returns>True if we initialised correctly</returns>
        public bool InitialiseAllUsersAndGroups()
        {
            try
            {
                // Get all the users and groups
                using (IDnaDataReader reader = CreateStoreProcedureReader("fetchgroupsandmembers"))
                {
                    reader.Execute();
                    if (!reader.HasRows)
                    {
                        return false;
                    }

                    // Go round all the results building the lists and caching them.
                    List<UserGroup> groups = null;
                    int lastUserID = 0;
                    int lastSiteID = 0;
                    int currentUserID = 0;
                    int currentSiteID = 0;
                    while (reader.Read())
                    {
                        currentSiteID = reader.GetInt32("siteid");
                        currentUserID = reader.GetInt32("userid");

                        // Check to see if we need to start a new list
                        if (currentUserID != lastUserID || currentSiteID != lastSiteID)
                        {
                            // Put the current groups list into the cache
                            if (groups != null)
                            {
                                _cachedGroups.Add(_cacheName + lastUserID.ToString() + "-" + lastSiteID.ToString(), groups);
                            }
                            groups = new List<UserGroup>();
                            lastUserID = currentUserID;
                            lastSiteID = currentSiteID;
                        }
                        // Add the group name to the list
                        groups.Add(new UserGroup() { Name = reader.GetString("name").ToLower() });
                    }

                    // Put the last group info into the cache
                    if (groups != null)
                    {
                        _cachedGroups.Add(_cacheName + lastUserID.ToString() + "-" + lastSiteID.ToString(), groups);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw ex;
            }
            IsInitialised = true;
            return IsInitialised;
        }

        /// <summary>
        /// Helper method for add user group list infomation to the main list
        /// </summary>
        /// <param name="userID">The id of the user</param>
        /// <param name="siteID">The id of the site</param>
        /// <param name="userGroups">The group list information you want to add</param>
        private void AddUserGroupListToMainList(int userID, int siteID, List<UserGroup> userGroups)
        {
            if (userGroups.Count > 0)
            {
                _cachedGroups.Add(_cacheName + userID.ToString() + "-" + siteID.ToString(), userGroups);
            }
        }

        /// <summary>
        /// Helper method that gets the users group list for a given site
        /// </summary>
        /// <param name="userID">The users id to look for</param>
        /// <param name="siteID">The site you want to check against</param>
        /// <returns>A list containing the groups the user belongs to, or null if we don't have that info yet</returns>
        /// <remarks>An empty list does not mean it hasn't been setup, the user does not belong to any groups</remarks>
        private List<UserGroup> GetUsersGroupListForSite(int userID, int siteID)
        {
            if (_cachedGroups.Contains(_cacheName + userID.ToString() + "-" + siteID.ToString()))
            {
                return (List<UserGroup>)_cachedGroups.GetData(_cacheName + userID.ToString() + "-" + siteID.ToString());
            }
            return null;
        }

        /// <summary>
        /// Drops all the groups for a given user for all sites. This is called when a users groups has been updated
        /// </summary>
        /// <remarks>This should not be called if the caching model uses the distributes memcache solution</remarks>
        /// <param name="cache">The cache manager object you want to drop the user group from</param>
        /// <param name="userID">The id of the user you want to drop the cache for</param>
        /// <param name="siteID">The id of the site you want to drop the group for</param>
        static public void DropCachedGroupsForUser(ICacheManager cache, int userID, int siteID)
        {
            cache.Remove(_cacheName + userID.ToString() + "-" + siteID.ToString());
        }

        /// <summary>
        /// Gets a list of all the current groups in the database
        /// </summary>
        /// <returns>The list of all group names</returns>
        public List<UserGroup> GetAllGroups()
        {
            // Check to see if we have the list yet
            if (_allGroups == null)
            {
                try
                {
                    // Get the list from the database
                    _allGroups = new List<UserGroup>();
                    using (IDnaDataReader reader = CreateStoreProcedureReader("GetAllGroups"))
                    {
                        reader.Execute();
                        if (!reader.HasRows)
                        {
                            return null;
                        }

                        while (reader.Read())
                        {
                            _allGroups.Add(new UserGroup() { Name = reader.GetString("groupname") });
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    _allGroups = null;
                    throw ex;
                }

                _cachedGroups.Add("grouplists",_allGroups);
            }

            // Return the list
            return _allGroups;
        }

        /// <summary>
        /// Creates a new group in the database
        /// </summary>
        /// <param name="groupName">The new group name you want to create</param>
        /// <param name="userID">The id of the user creating the group</param>
        /// <returns>True if it was created, false if something went wrong</returns>
        public bool CreateNewGroup(string groupName, int userID)
        {
            // Get all the groups first so we know we're in a stable state
            GetAllGroups();
            try
            {
                // Check to see if we already have the group
                if (IsItemInList(_allGroups, groupName.ToLower()))
                {
                    // Already Exists!
                    return true;
                }

                // Now create the new group in the database and add it to the list
                using (IDnaDataReader reader = CreateStoreProcedureReader("createnewusergroup"))
                {
                    reader.AddParameter("userid", userID);
                    reader.AddParameter("groupname", groupName);
                    reader.Execute();
                }
                _allGroups.Add(new UserGroup() { Name = groupName.ToLower() });
                _cachedGroups.Add("grouplists", _allGroups);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw ex;
            }

            return true;
        }

        /// <summary>
        /// Deletes the given group in the database
        /// </summary>
        /// <param name="groupName">The name of the group you want to delete</param>
        /// <returns>True if it was deleted, false if something went wrong</returns>
        public bool DeleteGroup(string groupName)
        {
            throw new NotSupportedException("We do not delete groups at this time!");
            /*
            // Get all the groups first so we know we're in a stable state
            GetAllGroups();
            try
            {
                // Check to see if group exists
                if (!_groupList.Contains(groupName.ToLower()))
                {
                    // Already gone!
                    return true;
                }

                // Now delete the group from the database and remove it from the list
                using (IDnaDataReader reader = CreateStoreProcedureReader("DeleteGroup"))
                {
                    reader.AddParameter("groupname", groupName);
                    reader.Execute();
                }
                _groupList.Remove(groupName.ToLower());
                _cachedGroups.Add("grouplists", _groupList);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }

            return true;*/
        }
    }
}
