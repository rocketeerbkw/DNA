using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Configuration;
using BBC.Dna.Common;
using System.Collections.Specialized;
using System.Collections;

namespace BBC.Dna.Users
{
    public class UserGroups : SignalBase<CachedGroups>
    {
        private const string _signalKey = "recache-groups";

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionString">Connection details for accessing the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public UserGroups(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            InitialiseObject = new InitialiseObjectDelegate(InitialiseAllUsersAndGroups);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetUserGroupsStats);
            CheckVersionInCache();

            SignalHelper.AddObject(typeof(UserGroups), this);
        }

        /// <summary>
        /// Returns the single static version
        /// </summary>
        /// <returns></returns>
        static public UserGroups GetObject()
        {
            var obj = SignalHelper.GetObject(typeof(UserGroups));
            if (obj != null)
            {
                return (UserGroups)obj;
            }
            return null;
        }

        /// <summary>
        /// Gets all the groups for all the users and sets up the cached information
        /// </summary>
        /// <returns>True if we initialised correctly</returns>
        private CachedGroups InitialiseAllUsersAndGroups()
        {
            var cachedGroups = new CachedGroups();
            cachedGroups.GroupList = InitialiseAllGroups();
            return cachedGroups;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        private CachedGroups InitialiseGroupsForSingleUser(int userId)
        {
            var cachedGroups = GetCachedObject();

            try
            {
                //remove all groups for this user
                cachedGroups.AllUsersGroupsAndSites.Where(x => x.Key.IndexOf(userId.ToString() + "-") >= 0).ToList().ForEach(pair => cachedGroups.AllUsersGroupsAndSites.Remove(pair.Key));

                // Get all the users and groups
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("fetchgroupsforuser"))
                {
                    reader.AddParameter("userid", userId);
                    reader.Execute();
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
                                try
                                {
                                    cachedGroups.AllUsersGroupsAndSites.Add(GetListKey(lastUserID, lastSiteID), groups);
                                }
                                catch (Exception e)
                                {
                                    _dnaDiagnostics.WriteExceptionToLog(e);
                                }
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
                        try
                        {
                            cachedGroups.AllUsersGroupsAndSites.Add(lastUserID.ToString() + "-" + lastSiteID.ToString(), groups);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                    cachedGroups.CachedUsers.Add(userId); 
                    UpdateCache();
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
                throw ex;
            }

            return cachedGroups;
        }

        private CachedGroups GetCachedGroups(int userId)
        {
            var cachedGroups = GetCachedObject();
            if (!cachedGroups.CachedUsers.Contains(userId))
            {
                cachedGroups = InitialiseGroupsForSingleUser(userId);
            }
            return cachedGroups;
        }

        /// <summary>
        /// Delegate for handling a signal
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        private bool HandleSignal(NameValueCollection args)
        {
            var userId=0;
            if (args != null)
            {
                if (!String.IsNullOrEmpty(args["userid"]))
                {
                    Int32.TryParse(args["userid"], out userId);
                }
            }

            if (userId == 0)
            {
                _object = InitialiseAllUsersAndGroups();
            }
            else
            {
                _object = InitialiseGroupsForSingleUser(userId);
            }
               
            UpdateCache();

            return true;
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
            if (!AddUserToInternalList(userID, groupName.ToLower(), siteID, ref userGroups))
            {
                return true;
            }

            // Add the user to the group in the database
            using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("AddUserToGroup"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("groupname", groupName.ToLower());
                reader.Execute();
            }

            

            // Add the updated group list to the main cache list
            AddUserGroupListToMainList(userID, siteID, userGroups);

            //update cache
            UpdateCache();

            return true;
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
            if (!RemoveUserFromInternalList(userID, groupName, siteID, ref userGroups))
            {
                return;
            }

            // Remove the user from the group in the database
            using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("RemoveUserFromGroup"))
            {
                reader.AddParameter("userid", userID);
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("groupname", groupName.ToLower());
                reader.Execute();
            }

            // Add the updated group list to the main cache list
            AddUserGroupListToMainList(userID, siteID, userGroups);

            //update cache
            UpdateCache();
        }
        
        /// <summary>
        /// Gets all the groups that a user belongs to on a given site
        /// </summary>
        /// <param name="userID">The users id you want to get the groups for</param>
        /// <param name="siteID">The sites id you want to get the group info from</param>
        /// <returns>a list of the groups the user belongs to for a given site</returns>
        public List<UserGroup> GetUsersGroupsForSite(int userID, int siteID)
        {
            // Check to see if we've got a list for this user already
            var list = GetUsersGroupListForSite(userID, siteID);
            if(list == null)
            {
                list = new List<UserGroup>();
            }
            return list;
        }

        /// <summary>
        /// Returns the siteIds that the user is a member of the given groupName
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupName"></param>
        /// <returns></returns>
        public List<int> GetSitesUserIsMemberOf(int userId, string groupName)
        {
            var siteIds = new List<int>();
            var lookupKey = string.Format("{0}-", userId);

            var allUserGroups = UserGroups.GetObject().GetCachedObject();
            var userGroups = from n in allUserGroups.AllUsersGroupsAndSites
                             where n.Key.IndexOf(lookupKey) == 0
                             select n;

            foreach (KeyValuePair<string,List<UserGroup>> group in userGroups)
            {
                if (group.Value.Exists(x => x.Name.ToLower() == groupName.ToLower()))
                {
                    var siteId=0;
                    if(Int32.TryParse(group.Key.Substring(group.Key.LastIndexOf("-") + 1, group.Key.Length - group.Key.LastIndexOf("-")-1), out siteId))
                    {
                        siteIds.Add(siteId);
                    }
                }
            }

            return siteIds;
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
            var cachedGroups = GetCachedGroups(userID);
            try
            {
                if (!AddGroupToInternalList(groupName, userID, ref cachedGroups))
                {
                    return true;
                }

                // Now create the new group in the database and add it to the list
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("createnewusergroup"))
                {
                    reader.AddParameter("userid", userID);
                    reader.AddParameter("groupname", groupName);
                    reader.Execute();
                }


                //update cache
                UpdateCache();

            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
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

        /// <summary>
        /// Returns the key used for the cached dictionary
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        static public string GetListKey(int userId, int siteId)
        {
            return userId.ToString() + "-" + siteId.ToString();
        }

        /// <summary>
        /// Sends the signal
        /// 
        /// </summary>
        public void SendSignal()
        {
            SendSignal(0);
        }

        /// <summary>
        /// Send signal with userid
        /// </summary>
        /// <param name="userId"></param>
        public void SendSignal(int userId)
        {
            NameValueCollection args = new NameValueCollection();
            if (userId != 0)
            {
                args.Add("userid", userId.ToString());
            }
            SendSignals(args);
        }


        /// <summary>
        /// Helper method for add user group list infomation to the main list
        /// </summary>
        /// <param name="userID">The id of the user</param>
        /// <param name="siteID">The id of the site</param>
        /// <param name="userGroups">The group list information you want to add</param>
        private void AddUserGroupListToMainList(int userID, int siteID, List<UserGroup> userGroups)
        {
            var cachedGroups = GetCachedObject();
            if (userGroups.Count > 0)
            {
                cachedGroups.AllUsersGroupsAndSites[GetListKey(userID, siteID)] = userGroups;

            }
            else
            {
                cachedGroups.AllUsersGroupsAndSites.Remove(GetListKey(userID, siteID));
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
            var cachedGroups = GetCachedGroups(userID);

            if (cachedGroups.AllUsersGroupsAndSites.ContainsKey(GetListKey(userID, siteID)))
            {
                return (List<UserGroup>)cachedGroups.AllUsersGroupsAndSites[GetListKey(userID, siteID)];
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="userID"></param>
        /// <returns></returns>
        private bool AddGroupToInternalList(string groupName, int userID, ref CachedGroups cachedGroups)
        {
            // Check to see if we already have the group
            if (cachedGroups.GroupList.Exists(x => x.Name.ToLower() == groupName.ToLower()))
            {
                // Already Exists!
                return false;
            }
            cachedGroups.GroupList.Add(new UserGroup() { Name = groupName.ToLower() });
            return true;

        }

        /// <summary>
        /// Gets a list of all the current groups in the database
        /// </summary>
        /// <returns>The list of all group names</returns>
        private List<UserGroup> InitialiseAllGroups()
        {
            var _groupList = new List<UserGroup>();
            try
            {
                // Get the list from the database
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("GetAllGroups"))
                {
                    reader.Execute();
                    while (reader.Read())
                    {
                        _groupList.Add(new UserGroup() { Name = reader.GetString("groupname") });
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
                throw ex;
            }

            // Return the list
            return _groupList;
        }

        /// <summary>
        /// Removes the user from the internal object
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="groupName"></param>
        /// <param name="siteID"></param>
        /// <returns>True if removed otherwise false if not in group already</returns>
        private bool RemoveUserFromInternalList(int userID, string groupName, int siteID, ref List<UserGroup> userGroups)
        {


            // Ok, got a list. Check to make sure they don't already belong to the group
            if (userGroups != null)
            {
                if (!userGroups.Exists(x => x.Name == groupName.ToLower()))
                {
                    // Not in this group, nothing to remove
                    return false;
                }

                // Remove the group to their current list
                userGroups.Remove(userGroups.First(x => x.Name == groupName.ToLower()));
                return true;
            }
            return false;
        }

        /// <summary>
        /// Adds user to internal groups list
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="groupName"></param>
        /// <param name="siteID"></param>
        /// <returns>True if added otherwise false if already in group</returns>
        private bool AddUserToInternalList(int userID, string groupName, int siteID, ref List<UserGroup> userGroups)
        {


            // Ok, got a list. Check to make sure they don't already belong to the group
            if (userGroups != null)
            {
                if (userGroups.Exists(x => x.Name.ToLower() == groupName.ToLower()))
                {
                    // Already a member of this group. Nothing to do
                    return false;
                }
            }
            else
            {
                // Ok, no group list for this user on this site
                userGroups = new List<UserGroup>();
            }

            // Add the new group to their current list
            userGroups.Add(new UserGroup() { Name = groupName.ToLower() });
            return true;
        }

        /// <summary>
        /// Returns list statistics
        /// </summary>
        /// <returns></returns>
        private NameValueCollection GetUserGroupsStats()
        {
            var values = new NameValueCollection();

            GetCachedObject();
            values.Add("NumberOfAllUsersGroupsAndSites", _object.AllUsersGroupsAndSites.Count.ToString());
            values.Add("NumberOfGroups", _object.GroupList.Count.ToString());
            values.Add("CachedObjectSize", _object.CachedObjectSize.ToString());
            return values;
        }
    }
}
