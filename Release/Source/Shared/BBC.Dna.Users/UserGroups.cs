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
    public class UserGroups : SignalBase<UserGroups>
    {
        private const string _signalKey = "recache-groups";
        public static string ALLGROUPSKEY = "ALLGROUPS";

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionString">Connection details for accessing the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public UserGroups(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            InitialiseObject += new InitialiseObjectDelegate(InitialiseAllUsersAndGroups);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetUserGroupsStats);
            CheckVersionInCache(ALLGROUPSKEY);

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
        private void InitialiseAllUsersAndGroups(params object[] args)
        {

            if (args != null && args.Length == 2)
            {
                if (args[0].GetType() == typeof(Int32) && args[1].GetType() == typeof(Int32))
                {//arg[0]= userid arg[1]= siteid
                    int userId = (int)args[0];
                    int siteId = (int)args[1];
                    AddToInternalObjects(CreateCacheKey(userId, siteId), CreateCacheLastUpdateKey(userId, siteId), new List<UserGroup>());
                    return;
                }
            }

            try
            {
                DnaDiagnostics.Default.WriteTimedEventToLog("CACHING", "About to initialise all groups and users");
                // Get all the users and groups
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("fetchgroupsandmembers"))
                {
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
                                    AddToInternalObjects(CreateCacheKey(lastUserID, lastSiteID), GetCacheKeyLastUpdate(lastUserID, lastSiteID), groups);
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
                        groups.Add(new UserGroup() { Name = reader.GetString("name").ToUpper(), SiteId = lastSiteID });
                    }

                    // Put the last group info into the cache
                    if (groups != null)
                    {
                        try
                        {
                            AddToInternalObjects(CreateCacheKey(lastUserID, lastSiteID), GetCacheKeyLastUpdate(lastUserID, lastSiteID), groups);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
                throw ex;
            }

            InitialiseAllGroups();
            DnaDiagnostics.Default.WriteTimedEventToLog("CACHING", "All groups and users initialised");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        private void InitialiseGroupsForSingleUser(int userId)
        {
            
            try
            {
                // Get all the users and groups
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("fetchgroupsforuser"))
                {
                    reader.AddParameter("userid", userId);
                    reader.Execute();
                    // Go round all the results building the lists and caching them.
                    int lastUserID = 0;
                    int lastSiteID = 0;
                    int currentUserID = 0;
                    int currentSiteID = 0;
                    List<UserGroup> groups = null;
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
                                    AddToInternalObjects(CreateCacheKey(lastUserID, lastSiteID), GetCacheKeyLastUpdate(lastUserID, lastSiteID), groups);
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
                        groups.Add(new UserGroup() { Name = reader.GetString("name").ToUpper(), SiteId = lastSiteID });
                    }

                    // Put the last group info into the cache
                    if (groups != null)
                    {
                        try
                        {
                            AddToInternalObjects(CreateCacheKey(lastUserID, lastSiteID), GetCacheKeyLastUpdate(lastUserID, lastSiteID), groups);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
            }
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
                InitialiseAllUsersAndGroups(null);
            }
            else
            {
                InitialiseGroupsForSingleUser(userId);
            }
            

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
            if (!AddUserToInternalList(userID, groupName, siteID, ref userGroups))
            {//already in group
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
            AddToInternalObjects(CreateCacheKey(userID, siteID), GetCacheKeyLastUpdate(userID, siteID), userGroups);
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
            AddToInternalObjects(CreateCacheKey(userID, siteID), GetCacheKeyLastUpdate(userID, siteID), userGroups);
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
            InitialiseGroupsForSingleUser(userId);//ensure cache contains all user groups for user
            var siteIds = new List<int>();
            var lookupKey = CreateCacheKey(userId, 0);

            var keys = from n in InternalObjects.Keys
                       where n.IndexOf(lookupKey) == 0 && n.IndexOf(_lastUpdateCacheKey) < 0
                             select n;

            foreach (string key in keys)
            {
                var group = (List<UserGroup>)InternalObjects[key];
                if (group.Exists(x => x.Name.ToLower() == groupName.ToLower()))
                {
                    siteIds.Add(group[0].SiteId);
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
            var cachedGroups = (List<UserGroup>)GetCachedObject(ALLGROUPSKEY);
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


                AddToInternalObjects(GetCacheKey(ALLGROUPSKEY), GetCacheKeyLastUpdate(ALLGROUPSKEY), cachedGroups);


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
        /// Helper method that gets the users group list for a given site
        /// </summary>
        /// <param name="userID">The users id to look for</param>
        /// <param name="siteID">The site you want to check against</param>
        /// <returns>A list containing the groups the user belongs to, or null if we don't have that info yet</returns>
        /// <remarks>An empty list does not mean it hasn't been setup, the user does not belong to any groups</remarks>
        private List<UserGroup> GetUsersGroupListForSite(int userID, int siteID)
        {
            return (List<UserGroup>)GetCachedObject(userID, siteID);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="groupName"></param>
        /// <param name="userID"></param>
        /// <returns></returns>
        private bool AddGroupToInternalList(string groupName, int userID, ref List<UserGroup> cachedGroups)
        {
            // Check to see if we already have the group
            if (cachedGroups.Exists(x => x.Name.ToUpper() == groupName.ToUpper()))
            {
                // Already Exists!
                return false;
            }
            cachedGroups.Add(new UserGroup() { Name = groupName.ToLower() });
            return true;

        }

        /// <summary>
        /// Gets a list of all the current groups in the database
        /// </summary>
        /// <returns>The list of all group names</returns>
        private void InitialiseAllGroups()
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

            AddToInternalObjects(GetCacheKey(ALLGROUPSKEY), GetCacheKeyLastUpdate(ALLGROUPSKEY), _groupList);

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
                if (userGroups.Exists(x => x.Name == groupName.ToLower()))
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

            values.Add("NumberOfAllUsersGroupsAndSites", InternalObjects.Count.ToString());
            if(InternalObjects.ContainsKey(GetCacheKey(ALLGROUPSKEY)))
            {
                values.Add("NumberOfGroups", ((List<UserGroup>)InternalObjects[GetCacheKey(ALLGROUPSKEY)]).Count.ToString());
            }
            else
            {
                values.Add("NumberOfGroups", "0");
            }

            return values;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static string CreateCacheKey(int userId, int siteId)
        {
            if (siteId == 0)
            {
                return GetCacheKey(userId);
            }
            else
            {
                return GetCacheKey(userId, siteId);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static string CreateCacheLastUpdateKey(int userId, int siteId)
        {
            if (siteId == 0)
            {
                return GetCacheKeyLastUpdate(userId);
            }
            else
            {
                return GetCacheKeyLastUpdate(userId, siteId);
            }
        }

        /// <summary>
        /// Returns all groups in cache
        /// </summary>
        /// <returns></returns>
        public List<UserGroup> GetAllGroups()
        {
            if(InternalObjects.ContainsKey(GetCacheKey(ALLGROUPSKEY)))
            {
                return (List<UserGroup>)InternalObjects[GetCacheKey(ALLGROUPSKEY)];
            }
            return new List<UserGroup>();
        }

    }
}
