using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Groups;

namespace BBC.Dna
{
    //define some aliases
	//using GroupMembers = ArrayList;
	//using GroupEntry = KeyValuePair<string, ArrayList>;
	//using GroupMap = Dictionary<int, KeyValuePair<string, ArrayList>>;
	//using SiteGroupMap = Dictionary<int, Dictionary<int, KeyValuePair<string, ArrayList>>>;

	// New storage mechanism
	// UsersData[userid][siteid][0-n]
	// Dictionary<int, Dictionary<int, List<int>>>
	//            userid          siteid    groupid
	// The list is a list of group IDs
	// We also have a Dictionary<int,string> to mape GroupID to groupname

	using UsersData = Dictionary<int, Dictionary<int, List<int>>>;
	using SiteGroupMembership = Dictionary<int, List<int>>;
    using BBC.Dna.Sites;
	

    /// <summary>
    /// UserGroups class
    /// </summary>
    public class UserGroups
    {
		//private static SiteGroupMap _siteGroupMap = new SiteGroupMap();
		//private static SiteGroupMap _userGroupsLoader;

		private static UsersData _usersData = new UsersData();
		private static Dictionary<int, string> _groupNames = new Dictionary<int, string>();
        private static UsersData _usersDataLoader = new Dictionary<int, Dictionary<int, List<int>>>();
        private static Dictionary<int, string> _groupNamesLoader = new Dictionary<int, string>();
        private static Dictionary<string, int> _groupIdNames = new Dictionary<string, int>();
		private static Dictionary<string, int> _groupIdNamesLoader = new Dictionary<string, int>();

        private static object _lock = new object();

        //Start the count of at 1 so the first time it's used we get the cache
        private static long _cacheExpiredCount = 1;

        /// <summary>
        /// Get the xml representation of the groups a user is in for a specific site.
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns></returns>
        public static string GetUserGroupsAsXml(int userID, int siteID, IInputContext context)
        {
            string result = String.Empty;

            if (IsCacheExpired())
            {
                RefreshCache(context);
            }

			if (_usersData.ContainsKey(userID) && _usersData[userID].ContainsKey(siteID))
			{
				result = "<GROUPS>";
				foreach (int groupID in _usersData[userID][siteID])
				{
					result += "<GROUP><NAME>";
					result += _groupNames[groupID].ToUpper();
					result += "</NAME></GROUP>";
				}
				result += "</GROUPS>";
			}
			else
			{
				result = "<GROUPS/>";
			}

            return result;
        }

        /// <summary>
        /// Get the xml element of the groups a user is in for a specific site.
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns></returns>
        public static XmlElement GetUserGroupsElement(int userID, int siteID, IInputContext context)
        {
            string result = String.Empty;

            if (IsCacheExpired())
            {
                RefreshCache(context);
            }

			XmlDocument groupsdoc = new XmlDocument();
			XmlElement groups = groupsdoc.CreateElement("GROUPS");

			if (_usersData.ContainsKey(userID) && _usersData[userID].ContainsKey(siteID))
			{
				foreach (int groupID in _usersData[userID][siteID])
				{
					XmlElement group = groupsdoc.CreateElement("GROUP");
					XmlElement name = groupsdoc.CreateElement("NAME");
					name.AppendChild(groupsdoc.CreateTextNode(_groupNames[groupID].ToUpper()));
					group.AppendChild(name);
					groups.AppendChild(group);
				}
			}

			return groups;
        }

        /// <summary>
        /// Retuns all groups for the given site.
        /// </summary>
        /// <param name="siteID"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static XmlElement GetSiteGroupsElement(int siteID, IInputContext context )
        {
            string result = String.Empty;
            if (IsCacheExpired())
            {
                RefreshCache(context);
            }

            XmlDocument groupsdoc = new XmlDocument();
            XmlElement groups = groupsdoc.CreateElement("GROUPS");
            
			foreach (string groupname in _groupNames.Values)
			{
				XmlElement group = groupsdoc.CreateElement("GROUP");
				XmlElement name = groupsdoc.CreateElement("NAME");
				name.AppendChild(groupsdoc.CreateTextNode(groupname.ToUpper()));
				group.AppendChild(name);
				groups.AppendChild(group);

			}
			return groups;

        }

        /// <summary>
        /// Expire the UserGroups cache
        /// </summary>
        public static void SetCacheExpired()
        {
            Interlocked.Increment(ref _cacheExpiredCount);
        }

        /// <summary>
        /// Refresh the cached user groups
        /// </summary>
        /// <param name="context">input context</param>
        public static bool RefreshCache(IInputContext context)
        {
            if (Monitor.TryEnter(_lock))
            {
                try
                {
                    using (IDnaDataReader dataReader = context.CreateDnaDataReader("fetchgroupsandmembers"))
                    {
                        dataReader.Execute();
                        if (dataReader.HasRows)
                        {
                            InitialiseSiteGroupMap();
                            Interlocked.Exchange(ref _cacheExpiredCount, 0);
                            while (dataReader.Read())
                            {
                                AddUserToUserGroups(dataReader);   
                            }
                            TransferSiteGroupMap();
                        }
                    }
                    //update new groups object
                    var groups = new Groups.UserGroups(AppContext.ReaderCreator, context.Diagnostics, AppContext.DnaCacheManager);
                    groups.InitialiseAllUsersAndGroups();
                }
                finally
                {
                    Monitor.Exit(_lock);
                }
            }
            else
            {
                // Failed to get a lock, so something else is initialising
                // If we already have a set of profanities, return them
                // Even if it will be released, it'll always be safe to use
                if (_usersData != null)
                {
                    return true;
                }
                else
                {
                    // We'll have to wait until the lock is released
                    Monitor.Enter(_lock);
                    Monitor.Exit(_lock);
                    // If _profanityClasses is still null, then something serious has gone wrong
                    // So throw an exception
                    if (_usersData == null)
                    {
                        throw new Exception("RefreshCache was unable to create a UserGroups list");
                    }
                    else
                    {
                        return true;
                    }
                }
            }
            return true;
        }

		/// <summary>
		/// This will update the cache information for a particular user
		/// </summary>
		/// <param name="userID">User whose group data needs to be updated</param>
		/// <param name="context">context for this request</param>
		public static void RefreshCacheForUser(int userID, IInputContext context)
		{
			SiteGroupMembership groupmembers = new SiteGroupMembership();
			using (IDnaDataReader reader = context.CreateDnaDataReader("fetchgroupsforuser"))
			{
				reader.AddParameter("@userid", userID);
				reader.Execute();
				while (reader.Read())
				{
					int siteID = reader.GetInt32("siteid");
					int groupID = reader.GetInt32("groupid");
					string groupName = reader.GetString("name");
					AddGroupName(groupName, groupID);
					if (!groupmembers.ContainsKey(siteID))
					{
						groupmembers.Add(siteID, new List<int>());
					}
					groupmembers[siteID].Add(groupID);
				}
			}

			lock (_lock)
			{
				if (_usersData.ContainsKey(userID))
				{
					_usersData.Remove(userID);
				}
				_usersData.Add(userID, groupmembers);
			}
		}

		private static void AddGroupName(string groupName, int groupID)
		{
			groupName = groupName.ToUpper();
			lock (_lock)
			{
				if (!_groupNames.ContainsKey(groupID))
				{
					_groupNames.Add(groupID, groupName);
					_groupIdNames.Add(groupName, groupID);
				}
			}
		}

        /// <summary>
        /// Add each user returned in the result set to the internal cache.
        /// </summary>
        /// <param name="dataReader">IDnaDataReader representing the result set.</param>
        private static void AddUserToUserGroups(IDnaDataReader dataReader)
        {
            int siteID = dataReader.GetInt32NullAsZero("siteid");
            int userID = dataReader.GetInt32NullAsZero("userid");
            int groupID = dataReader.GetInt32NullAsZero("groupid");

            if (groupID != 0 && userID != 0 && siteID != 0)
            {

                string groupName = dataReader.GetString("name");

                // Now initialise the new structures
                // First add the group name if it doesn't already exist in the groupname dictionary
                groupName = groupName.ToUpper();
                if (!_groupNamesLoader.ContainsKey(groupID))
                {
                    _groupNamesLoader.Add(groupID, groupName);
                    _groupIdNamesLoader.Add(groupName, groupID);
                }

                // Now create the user record if necessary
                if (!_usersDataLoader.ContainsKey(userID))
                {
                    _usersDataLoader.Add(userID, new SiteGroupMembership());
                }

                SiteGroupMembership thisUsersMembership = _usersDataLoader[userID];

                // Create the site record if necessary
                if (!thisUsersMembership.ContainsKey(siteID))
                {
                    thisUsersMembership.Add(siteID, new List<int>());
                }

                thisUsersMembership[siteID].Add(groupID);
            }
        }

        /// <summary>
        /// Initialise the internal storage
        /// </summary>
        private static void InitialiseSiteGroupMap()
        {
			_usersDataLoader = new Dictionary<int, Dictionary<int, List<int>>>();
			_groupNamesLoader = new Dictionary<int, string>();
			_groupIdNamesLoader = new Dictionary<string, int>();
        }

        /// <summary>
        /// Copy temporay object used during RefreshCache to the main object
        /// </summary>
        private static void TransferSiteGroupMap()
        {
			_usersData = _usersDataLoader;
			_groupNames = _groupNamesLoader;
			_groupIdNames = _groupIdNamesLoader;
        }

        /// <summary>
        /// Check if the UserGroups cache is expired
        /// </summary>
        /// <returns>true is expired, otherwise false</returns>
        private static bool IsCacheExpired()
        {
            return Interlocked.Read(ref _cacheExpiredCount) > 0;
        }

        /// <summary>
        /// Returns whether a given user is an editor for the given site
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns>whether a given user is an editor for the given site</returns>
        public static bool IsUserEditorForSite(int userID, int siteID, IInputContext context)
        {
            bool result = false;

            if (IsCacheExpired())
            {
                RefreshCache(context);
            }

			int editorGroup = _groupIdNames["EDITOR"];
			if (_usersData.ContainsKey(userID))
			{
				if (_usersData[userID].ContainsKey(siteID))
				{
					result = _usersData[userID][siteID].Contains(editorGroup);
				}
			}

            return result;                              
        }


        /// <summary>
        /// Create an Xml representation of the site list that the given user is an editor for
        /// </summary>
        /// <param name="userID">User to get groups for</param>
        /// <param name="isSuperUser">Whether the user is a superuser or not</param>
        /// <param name="context">The context it's called in</param>
        /// <returns>XmlElement pointing to the sites the user is editor of.</returns>
        public static XmlElement GetSitesUserIsEditorOfXML(int userID, bool isSuperUser, IInputContext context)
        {
            /*
             * <EDITOR-SITE-LIST>
             *  <SITE-LIST>
                    <SITE ID="17">
                        <NAME>1xtra</NAME>
                        <DESCRIPTION>1xtra messageboard</DESCRIPTION>
                        <SHORTNAME>1xtra</SHORTNAME>
                    </SITE>
                    <SITE ID="3">
                        <NAME>360</NAME>
                        <DESCRIPTION>360</DESCRIPTION>
                        <SHORTNAME>360</SHORTNAME>
                    </SITE>
             *  </SITE-LIST>
             * </EDITOR-SITE-LIST>
             */

            if (IsCacheExpired())
            {
                RefreshCache(context);
            }

            XmlDocument editorGroupsDoc = new XmlDocument();
            XmlElement root = editorGroupsDoc.CreateElement("EDITOR-SITE-LIST");

            if (isSuperUser)
            {
                SiteXmlBuilder siteXml = new SiteXmlBuilder(context);
                root.AppendChild(ImportNode(editorGroupsDoc, siteXml.GenerateAllSitesXml(context.TheSiteList).FirstChild));
            }
            else
            {
				XmlElement siteList = editorGroupsDoc.CreateElement("SITE-LIST");

				int editorGroup = _groupIdNames["EDITOR"];

				if (_usersData.ContainsKey(userID))
				{
					SiteGroupMembership userData = _usersData[userID];
					foreach (int siteID in userData.Keys)
					{
						if (userData[siteID].Contains(editorGroup))
						{
							XmlElement siteXml = editorGroupsDoc.CreateElement("SITE");

							ISite site = context.TheSiteList.GetSite(siteID);

							siteXml.SetAttribute("ID", siteID.ToString());

							AddTextElement(siteXml, "NAME", site.SiteName);
							AddTextElement(siteXml, "DESCRIPTION", site.Description);
							AddTextElement(siteXml, "SHORTNAME", site.ShortName);
							AddTextElement(siteXml, "SSOSERVICE", site.SSOService);

							siteList.AppendChild(siteXml);

						}
					}
				}
                root.AppendChild(siteList);
            }
            return root;
        }

        /// <summary>
        /// Static function to add a text element to a given parent element with the given name containing
        /// the given value
        /// </summary>
        /// <param name="parent">Parent node</param>
        /// <param name="name">Name of the element</param>
        /// <param name="value">Value of the text element</param>
        /// <returns>the new element</returns>
        private static XmlElement AddTextElement(XmlElement parent, string name, string value)
        {
            // Create the new element with the text
            XmlElement text = parent.OwnerDocument.CreateElement(name.ToUpper());
            text.AppendChild(parent.OwnerDocument.CreateTextNode(value));
            parent.AppendChild(text);

            // Return the new element
            return text;
        }

        /// <summary>
        /// Static Helper function to import a node from another document.
        /// </summary>
        /// <param name="newOwner">The new owner document to import into</param>
        /// <param name="source">The node you want to import</param>
        /// <returns>The new node or null if it failed</returns>
        public static XmlNode ImportNode(XmlDocument newOwner, XmlNode source)
        {
            return newOwner.ImportNode(source, true);
        }
    }
}
