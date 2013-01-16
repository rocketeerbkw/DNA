using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Configuration;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.SocialAPI;

namespace BBC.Dna.Users
{
    /// <summary>
    /// The different types of users we can have
    /// </summary>
    public enum UserTypes
    {
        /// <summary>
        /// Banned status
        /// </summary>
        BannedUser,
        /// <summary>
        /// Normal user status
        /// </summary>
        NormalUser,
        /// <summary>
        /// Editor rights
        /// </summary>
        Editor,
        /// <summary>
        /// Moderator rights
        /// </summary>
        Moderator,
        /// <summary>
        /// Superuser rights
        /// </summary>
        SuperUser,
        /// <summary>
        /// Notable user
        /// </summary>
        Notable,
        /// <summary>
        /// Guardian user
        /// </summary>
        Guardian,
        /// <summary>
        /// Scout user
        /// </summary>
        Scout,
        /// <summary>
        /// SubEditor user
        /// </summary>
        SubEditor
    }

    public enum UserStatus
    {
        /// <summary>
        /// Banned
        /// </summary>
        Banned = 0, 

        /// <summary>
        /// Normal
        /// </summary>
        Normal = 1, 

        /// <summary>
        /// Super
        /// </summary>
        Super = 2
    }

    /// <summary>
    /// Different types of external users
    /// </summary>
    public enum ExternalUserTypes
    {
        TwitterUser,
        FacebookUser
    }
    
    /// <summary>
    /// The dna user class
    /// </summary>
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "")]
    [Serializable]
    [DataContract(Name = "user")]    
    public class User : IUser
    {
        
        protected string _databaseConnectionDetails = "";
        private int _status = -1;
        private int _prefStatus;
        protected ICacheManager _cachingObject = null;
        protected IDnaDataReaderCreator _dnaDataReaderCreator = null;
        protected IDnaDiagnostics _dnaDiagnostics = null;
        private UserGroups _userGroupsManager;
                

        [DataMember(Name = "groups")]
        public List<UserGroup> UsersListOfGroups { get; set; }

        /// <summary>
        /// Get property for the dna users id
        /// </summary>
        [DataMember(Name = "id")]
        public virtual int UserID { get; set;}

        /// <summary>
        /// The get property for the users SSO user id
        /// </summary>
        [DataMember(Name = "ssoUserID")]
        public virtual int SSOUserID {get; set;}

        /// <summary>
        /// The get property for the users identity user id
        /// </summary>
        [DataMember(Name = "identityUserID")]
        public virtual string IdentityUserID  {get; set;}

        /// <summary>
        /// The get property for the users twitter user id
        /// </summary>
        [DataMember(Name = "twitterUserID")]
        public virtual string TwitterUserID { get; set; }

        /// <summary>
        /// The get property for the users name
        /// </summary>
        [DataMember(Name = "userName")]
        public virtual string UserName  {get; set;}

        /// <summary>
        /// The get property for the users identity user name
        /// </summary>
        [DataMember(Name = "identityUserName")]
        public virtual string IdentityUserName { get; set; }

        /// <summary>
        /// The get property for the users email
        /// NO NO EMails
        /// </summary>
        //[DataMember(Name = "email")]
        public string Email  {get; set;}

        /// <summary>
        /// The get property for the user first names
        /// </summary>
        [DataMember(Name = "firstNames")]
        public string FirstNames { get; set;  }

        /// <summary>
        /// The get property for the users last name
        /// </summary>
        [DataMember(Name = "lastName")]
        public string LastName  { get; set;  }

        /// <summary>
        /// Accepts subscriptions?
        /// </summary>
        [DataMember(Name = "acceptSubscriptions")]
        public bool AcceptSubscriptions { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int IsAutoSinBin { get; set; }

        public int Status
        {
            get { return _status;}
            set { _status = value;}
        }

        /// <summary>
        /// The get property for the users status
        /// </summary>
        [DataMember(Name = "status")]
        public string StatusAsString
        {
            get 
            {
                return Enum.GetName(typeof(UserStatus), _status);
            }
            set 
            {
                UserStatus stringAsEnum = (UserStatus)Enum.Parse(typeof(UserStatus), value);
                _status = (int)stringAsEnum;
            }
        }

        public int PrefStatus
        {
            get { return _prefStatus;}
            set { _prefStatus = value;}
        }

        public string PrefStatusAsString
        {
            get
            {
                return Enum.GetName(typeof(ModerationStatus.UserStatus), _prefStatus);
            }
            set
            {
                ModerationStatus.UserStatus stringAsEnum = (ModerationStatus.UserStatus)Enum.Parse(typeof(ModerationStatus.UserStatus), value);
                _prefStatus = (int)stringAsEnum;
            }
        }


        /// <summary>
        /// The get property for the siteid the user was created for
        /// </summary>
        [DataMember(Name = "siteID")]
        public int SiteID { get; set; } 

        /// <summary>
        /// The get property for the users
        /// </summary>
        [DataMember(Name = "lastSynchronisedDate")]
        public DateTime LastSynchronisedDate { get; set; } 
 

        /// <summary>
        /// Get property for the users SiteSuffix
        /// </summary>
        [DataMember(Name = "siteSuffix")]
        public string SiteSuffix { get; set; }

        /// <summary>
        /// The get property for the teamid the user is assigned
        /// </summary>
        [DataMember(Name = "teamID")]
        public int TeamID { get; set; } 

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="dnaDataReaderCreator">A DnaDataReaderCreator object for creating the procedure this class needs.
        /// If NULL, it uses the connection stringsfrom the configuration manager</param>
        /// <param name="dnaDiagnostics">A DnaDiagnostics object for logging purposes</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        //public User(string databaseConnectionDetails, IDnaCache caching)
        public User(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching)
        {
            _dnaDataReaderCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;
            if (_dnaDataReaderCreator == null)
            {
                _databaseConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
            }

            Trace.WriteLine("User() - connection details = " + _databaseConnectionDetails);
            _cachingObject = caching;
            _userGroupsManager = UserGroups.GetObject();
        }

        public User(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, UserGroups userGroups)
        {
            _dnaDataReaderCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;
            if (_dnaDataReaderCreator == null)
            {
                _databaseConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
            }

            Trace.WriteLine("User() - connection details = " + _databaseConnectionDetails);
            _cachingObject = caching;
            _userGroupsManager = userGroups;
        }

        /// <summary>
        /// Creates a user using their DNA User ID
        /// </summary>
        /// <param name="userSignInID">The users SignIn ID</param>
        /// <param name="legacyUserID">The sso legacy userid if they have one</param>
        /// <param name="signInType">The type of the sign in ID. Identity or SSO</param>
        /// <param name="siteID">The site that you want to create the user in</param>
        /// <param name="loginName">The login name for the user</param>
        /// <param name="email">The users email</param>
        /// <param name="displayName">The users display name if gievn</param>
        /// <returns>True if they we're created ok, false if not</returns> 
        public bool CreateUserFromSignInUserID(string userSignInID, int legacyUserID, SignInSystem signInType, int siteID, string loginName, string email, string displayName,string ipAddress, Guid BBCUid )
        {
            bool userCreated = false;
            
            IdentityUserID = userSignInID;
            Trace.WriteLine("CreateUserFromSignInUserID() - Using Identity");
            userCreated = CreateNewUserFromId(siteID, IdentityUserID, legacyUserID, loginName, email, displayName,ipAddress, BBCUid );

            if (userCreated)
            {
                GetUsersGroupsForSite();
            }

            return userCreated;
        }

        public bool CreateUserFromTwitterUserID(int siteID, TweetUser tweetUser)
        {
            if (tweetUser.id == null || tweetUser.id.Length == 0)
                throw new ArgumentException("Invalid twitterUserId parameter");

            if (siteID == 0)
                throw new ArgumentException("Invalid siteID parameter");

            using (IDnaDataReader reader = CreateStoreProcedureReader("createnewuserfromtwitteruserid"))
            {
                reader.AddParameter("twitteruserid", tweetUser.id);
                reader.AddParameter("twitterscreenname", tweetUser.ScreenName);
                reader.AddParameter("twittername", tweetUser.Name);
                reader.AddParameter("siteid", siteID);
                reader.Execute();
                if (reader.Read() && reader.HasRows)
                {
                    // Get the id for the user.
                    SiteID = siteID;
                    ReadUserDetails(reader);
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Check to see if the tweet user is a trusted user
        /// </summary>
        /// <param name="siteID"></param>
        /// <param name="tweetUser"></param>
        /// <returns></returns>
        public bool IsTweetUserATrustedUser(int siteID, TweetUser tweetUser)
        {
            if (tweetUser.id == null || tweetUser.id.Length == 0)
                throw new ArgumentException("Invalid twitterUserId parameter");

            if (siteID == 0)
                throw new ArgumentException("Invalid siteID parameter");

            using (IDnaDataReader reader = CreateStoreProcedureReader("istweetuseratrusteduser"))
            {
                reader.AddParameter("twitteruserid", tweetUser.id);
                reader.AddParameter("siteid", siteID);
                reader.Execute();
                if (reader.Read() && reader.HasRows)
                {
                    // Get the id for the user.
                    SiteID = siteID;
                    ReadUserDetails(reader);
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Creates a new stored procedure reader for the given procedure
        /// </summary>
        /// <param name="procedureName">The name of the procedure you want to call</param>
        /// <returns>A stored procedure reader ready to execute the given stored procedure</returns>
        private IDnaDataReader CreateStoreProcedureReader(string procedureName)
        {
            if (_dnaDataReaderCreator == null)
            {
                return new StoredProcedureReader(procedureName, _databaseConnectionDetails, _dnaDiagnostics);
            }
            else
            {
                return _dnaDataReaderCreator.CreateDnaDataReader(procedureName);
            }
        }

        /// <summary>
        /// This method gets the users DNA UserID for the given SignIn UserID
        /// </summary>
        /// <param name="signInUserID">The users signin user id</param>
        /// <param name="signInType">The signin system the id belongs to</param>
        /// <returns>The DNA User ID</returns>
        private int GetDnaUserIDFromSignInID(int signInUserID, SignInSystem signInType)
        {
            string procedureName = "GetDnaUserIDFromIdentityUserID";
            string signInIDName = "IdentityUserID";

            using (IDnaDataReader reader = CreateStoreProcedureReader(procedureName))
            {
                reader.AddParameter(signInIDName, signInUserID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                     UserID = reader.GetInt32("DnaUserID");
                }
            }

            return  UserID;
        }

        /// <summary>
        /// Gets the user data details and fills in the XML block
        /// </summary>
        /// <param name="siteID">The Id of the site that you want to create the user on</param>
        /// <param name="identityUserID">The users Identity UserID if given</param>
        /// <param name="ssoUserID">The users SSO UserID if given</param>
        /// <param name="signInLoginName">The users signin system login name</param>
        /// <param name="signInEmail">The users signin system email address</param>
        /// <param name="displayName">The users signin system display name</param>
        private bool CreateNewUserFromId(int siteID, string identityUserID, int ssoUserID, string signInLoginName, string signInEmail, string displayName,string ipAddress, Guid BBCUid )
        {
            if (siteID != 0)
            {
                return CreateUserFromSignInUserID(siteID, identityUserID, ssoUserID, signInLoginName, signInEmail, displayName, ipAddress, BBCUid);
            }
            return false;
        }


        /// <summary>
        /// Helper method for creating and getting users via signin userids
        /// </summary>
        /// <param name="siteID">The id of the site the user is being created on</param>
        /// <param name="identityUserID">The users IDentity UserID</param>
        /// <param name="ssoUserID">The users Legacy SSO UserID</param>
        /// <param name="loginName">The users Login Name</param>
        /// <param name="email">The users Email</param>
        /// <param name="displayName">The users displayname</param>
        /// <returns>True if the user is created, false if not</returns>
        private bool CreateUserFromSignInUserID(int siteID, string identityUserID, int ssoUserID, string loginName,
            string email, string displayName, string ipAddress, Guid BBCUid)
        {
            string procedureName = "createnewuserfromidentityid";

            using (IDnaDataReader reader = CreateStoreProcedureReader(procedureName))
            {
                reader.AddParameter("identityuserid", identityUserID);
                if (ssoUserID > 0)
                {
                    reader.AddParameter("legacyssoid", ssoUserID);
                }

                reader.AddParameter("username", loginName);
                reader.AddParameter("email", email);
                reader.AddParameter("siteid", siteID);
                if (displayName.Length > 0)
                {
                    reader.AddParameter("displayname", displayName);
                }
                reader.AddParameter("ipaddress", ipAddress);
                reader.AddParameter("bbcuid", BBCUid);
                reader.Execute();
                if (reader.Read() && reader.HasRows)
                {
                    // Get the id for the user.
                    SiteID = siteID;
                    ReadUserDetails(reader);
                    return UserID > 0;
                }
            }
            return false;
        }

        /// <summary>
        /// Creates user per forum which allows for anonymous users
        /// </summary>
        /// <param name="siteID">The site</param>
        /// <param name="forumID">The forum id</param>
        /// <returns>true if created or false if missing parameters or blank params</returns>
        public bool CreateAnonymousUserForForum(int siteID, int forumID, string displayName)
        {
            if (forumID != 0 && siteID != 0)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("createnewuserforforum"))
                {
                    reader.AddParameter("@forumid", forumID);
                    reader.AddParameter("@siteid", siteID);
                    //not used
                    //if (!String.IsNullOrEmpty(displayName))
                    //{
                    //    reader.AddParameter("displayname", displayName);
                    //}
                    reader.Execute();
                    if (reader.Read())
                    {
                       return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Finds a user using their DNA User ID
        /// </summary>
        /// <param name="userID">The users DNA ID</param>
        /// <param name="siteID">The site that you want to create the user in</param>
        /// <returns>True if they we're retrieved ok, false if not</returns>
        public bool CreateUserFromDnaUserID(int userID, int siteID)
        {
            if (userID != 0 && siteID != 0)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("finduserfromid"))
                {
                    reader.AddParameter("@userid", userID);
                    reader.AddParameter("@h2g2id", DBNull.Value);
                    reader.AddParameter("@siteid", siteID);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        SiteID = siteID;
                        ReadUserDetails(reader);
                        GetUsersGroupsForSite();
                        return true;
                    }
                }
            }
            return false;
        }
        

        /// <summary>
        /// Finds a user using their Identity User ID
        /// </summary>
        /// <param name="identityUserID">The users Identity User ID</param>
        /// <param name="siteID">The site that you want to get the user for</param>
        /// <returns>True if they we're retrieved ok, false if not</returns>
        public bool CreateUserFromIdentityUserID(string identityUserID, int siteID)
        {
            if (identityUserID != String.Empty && siteID != 0)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("finduserfromidentityuserid"))
                {
                    reader.AddParameter("@identityuserid", identityUserID);
                    reader.AddParameter("@siteid", siteID);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        SiteID = siteID;
                        ReadUserDetails(reader);
                        GetUsersGroupsForSite();
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Finds a user using their Identity User Name
        /// </summary>
        /// <param name="identityUserName">The users Identity UserName</param>
        /// <param name="siteID">The site that you want to get the user for</param>
        /// <returns>True if they we're retrieved ok, false if not</returns>
        public bool CreateUserFromIdentityUserName(string identityUserName, int siteID)
        {
            if (identityUserName != String.Empty && siteID != 0)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("finduserfromidentityusername"))
                {
                    reader.AddParameter("@identityusername", identityUserName);
                    reader.AddParameter("@siteid", siteID);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        SiteID = siteID;
                        ReadUserDetails(reader);
                        GetUsersGroupsForSite();
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Method for reading user data from user procedure calls
        /// </summary>
        /// <param name="reader">The StoredProcedure reader that contains the data</param>
        private void ReadUserDetails(IDnaDataReader reader)
        {
            UserID = reader.GetInt32("userid");
            UserName = reader.GetString("username");

            IdentityUserID = reader.GetStringNullAsEmpty("IdentityUserID");
            IdentityUserName = reader.GetStringNullAsEmpty("IdentityUserName");

            _status = reader.GetInt32("status");
            _prefStatus = reader.GetInt32("PrefStatus");
            
            if (_status == 1)//normal global status
            {
                if (reader.GetInt32("PrefStatus") == 4)//banned
                {
                    _status = 0;
                }
            }
            //NO NO emails
            Email = reader.GetString("email");
            SiteSuffix = reader.GetStringNullAsEmpty("SiteSuffix");
            LastSynchronisedDate = reader.GetDateTime("LastUpdatedDate");
            if (reader.Exists("AcceptSubscriptions"))
            {
                AcceptSubscriptions = reader.GetBoolean("AcceptSubscriptions");
            }

            if (reader.Exists("SinBin"))
            {
                IsAutoSinBin = reader.GetInt32NullAsZero("SinBin");
            }

            //PrimarySiteId = reader.GetInt32NullAsZero("PrimarySiteId");
        }

        /// <summary>
        /// Gets the given users groups they belong to for a given site
        /// </summary>
        /// <returns>The list of groups they belong to. This will be empty if they donot belong to any groups</returns>
        public List<UserGroup> GetUsersGroupsForSite()
        {
            // Call the groups service
            if (_userGroupsManager != null)
            {
                UsersListOfGroups = _userGroupsManager.GetUsersGroupsForSite(UserID, SiteID);
                return UsersListOfGroups;
            }
            return new List<UserGroup>();
        }

        /// <summary>
        /// Adds the current user to the given group
        /// </summary>
        /// <param name="groupName">The name of the group you want to add the user to</param>
        /// <returns>True if they were added, false if something went wrong</returns>
        public bool AddUserToGroup(string groupName)
        {
            // Call the groups service
            if (_userGroupsManager.PutUserIntoGroup(UserID, groupName, SiteID))
            {
                GetUsersGroupsForSite();
                return true;
            }
            return false;
        }

        /// <summary>
        /// Adds the given user to the given group for a specified site
        /// </summary>
        /// <param name="userID">The user you want to add to the group</param>
        /// <param name="siteID">The site you want to add the user to</param>
        /// <param name="groupName">The name of the group you want to add the user to</param>
        /// <returns>True if they were added, false if something went wrong</returns>
        public bool AddUserToGroup(int userID, int siteID, string groupName)
        {
            // Call the groups service
            if (_userGroupsManager.PutUserIntoGroup(userID, groupName, siteID))
            {
                GetUsersGroupsForSite();
                return true;
            }
            return false;
        }

        /// <summary>
        /// Remomves the current user from the given group
        /// </summary>
        /// <param name="groupName">The name of the group you want to remove the user from</param>
        public void RemoveUserFromGroup(string groupName)
        {
            // Call the groups service
            _userGroupsManager.DeleteUserFromGroup(UserID, groupName, SiteID);
            GetUsersGroupsForSite();
        }

        /// <summary>
        /// Remomves the given user from the given group and site
        /// </summary>
        /// <param name="userID">The user you want to remove from the group</param>
        /// <param name="siteID">The site you want to remove the user from</param>
        /// <param name="groupName">The name of the group you want to remove the user from</param>
        public void RemoveUserFromGroup(int userID, int siteID, string groupName)
        {
            // Call the groups service
            _userGroupsManager.DeleteUserFromGroup(userID, groupName, siteID);
            GetUsersGroupsForSite();
        }



        /// <summary>
        /// This method checks to see if the current user is one of the known user types
        /// </summary>
        /// <param name="type">The type you want to check against</param>
        /// <returns>True if they are of the given type, false if not</returns>
        public bool IsUserA(UserTypes type)
        {
            switch (type)
            {
                case UserTypes.BannedUser:
                    {
                        return _status == 0 || UsersListOfGroups.Exists(x => x.Name.ToLower() == "banned");
                    }
                case UserTypes.Editor:
                    {
                        return _status == 2 || UsersListOfGroups.Exists(x => x.Name.ToLower() == "editor"); 
                    }
                case UserTypes.SuperUser:
                    {
                        return _status == 2;
                    }
                case UserTypes.Moderator:
                    {
                        return UsersListOfGroups.Exists(x => x.Name.ToLower() == "moderator"); 
                    }
                case UserTypes.NormalUser:
                    {
                        return _status == 1;
                    }
                case UserTypes.Notable:
                    {
                        return UsersListOfGroups.Exists(x => x.Name.ToLower() == "notables");
                    }
                case UserTypes.Guardian:
                    {
                        return UsersListOfGroups.Exists(x => x.Name.ToLower() == "guardian");
                    }
                case UserTypes.Scout:
                    {
                        return UsersListOfGroups.Exists(x => x.Name.ToLower() == "scouts");
                    }
                case UserTypes.SubEditor:
                    {
                        return UsersListOfGroups.Exists(x => x.Name.ToLower() == "subs");
                    }
            }

            return false;
        }

        public int PrimarySiteId { get; private set; }

        public bool IsTrustedUser()
        {
            if (IsUserA(UserTypes.Notable) || IsUserA(UserTypes.Editor))
                return true;
            else
                return false;
        }

        /// <summary>
        /// Synchronizes the users signin details with the database
        /// </summary>
        /// <param name="signInUserName">The users current username held in the signin system</param>
        /// <param name="signInEmail">The users current email address held in the signin system</param>
        /// <param name="signInLoginName">The users login name for the sign in system</param>
        /// <returns>True if it synch'd, false if not</returns>
        public void SynchronizeUserSigninDetails(string signInUserName, string signInEmail, string signInLoginName)
        {
            if (UserName != signInUserName || Email != signInEmail)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("synchroniseuserwithprofile"))
                {
                    reader.AddParameter("userid", UserID);
                    reader.AddParameter("displayname", signInUserName);
                    reader.AddParameter("loginname", signInLoginName);
                    reader.AddParameter("email", signInEmail);
                    reader.AddParameter("siteid", SiteID);
                    reader.AddParameter("identitysite",  1);
                    reader.AddParameter("LastUpdated", LastSynchronisedDate);
                    reader.Execute();
                    if (reader.Read())
                    {
                        Email = signInEmail;
                        if (signInUserName.Length > 0)
                        {
                            UserName = signInUserName;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Synchronises a users sitesuffix with the given one
        /// </summary>
        /// <param name="siteSuffix">The sitesuffix to sync against</param>
        public void SynchroniseSiteSuffix(string siteSuffix)
        {
            if (SiteSuffix != siteSuffix)
            {
                using (IDnaDataReader dataReader = CreateStoreProcedureReader("updateuser2"))
                {
                    dataReader.AddParameter("UserID", UserID);
                    dataReader.AddParameter("SiteID", SiteID);
                    dataReader.AddParameter("SiteSuffix", siteSuffix);
                    dataReader.Execute();
                }

                SiteSuffix = siteSuffix;
            }
        }

        /// <summary>
        /// Synchronises a users accept subscription with the given one
        /// </summary>
        /// <param name="acceptSubscriptions">Whetherto accept subscriptions or not to sync against</param>
        public void SynchroniseAcceptSubscriptions(bool acceptSubscriptions)
        {
            if (acceptSubscriptions != AcceptSubscriptions)
            {
                using (IDnaDataReader dataReader = CreateStoreProcedureReader("updateuser2"))
                {
                    dataReader.AddParameter("UserID", UserID);
                    dataReader.AddParameter("SiteID", SiteID);
                    dataReader.AddParameter("acceptsubscriptions", acceptSubscriptions);
                    dataReader.Execute();
                }

                AcceptSubscriptions = acceptSubscriptions;
            }
        }

        public bool HasSpecialEditPermissions(int h2g2id)
        {
            return (IsUserA(UserTypes.Editor) || (IsUserA(UserTypes.Moderator) && IsEntryLockedForModeration(h2g2id)));
        }

        bool IsEntryLockedForModeration(int ih2g2ID)
        {
            //StartStoredProcedure("checkuserhasentrylockedformoderation");
            //AddParam("userid", iUserID);
            //AddParam("h2g2id", ih2g2ID);
            //ExecuteStoredProcedure();
            //// check there is no error
            //CTDVString sTemp;
            //int iErrorCode;
            //if (!GetLastError(&sTemp, iErrorCode))
            //{
            //    bLocked = GetBoolField("IsLocked");
            //}
            //return bLocked;
            return false;
        }


        public void UpdateUserSubscriptions(IDnaDataReaderCreator dnaDataReaderCreator, int h2g2ID)
        {
            // Check to see if the current user accepts subscriptions
            if (AcceptSubscriptions)
            {
                // Update users subscriptions witht his new article
                using (IDnaDataReader reader = dnaDataReaderCreator.CreateDnaDataReader("addarticlesubscription"))
                {
                    reader.AddParameter("h2g2id", h2g2ID);
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsPreModerated
        {
            get
            {
                return _prefStatus == (int)ModerationStatus.UserStatus.Premoderated;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsPostModerated
        {
            get
            {
                return _prefStatus == (int)ModerationStatus.UserStatus.Postmoderated;
            }
        }

    }
}
