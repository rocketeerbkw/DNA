using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Groups;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Configuration;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Runtime.Serialization;

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
        Notable
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
    /// The dna user class
    /// </summary>
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "")]
    [DataContract(Name = "user")]    
    public class User : IUser
    {
        
        protected string _databaseConnectionDetails = "";
        private int _status = -1;
        private DateTime _lastSynchronisedDate;
        protected ICacheManager _cachingObject = null;
        protected IDnaDataReaderCreator _dnaDataReaderCreator = null;
        protected IDnaDiagnostics _dnaDiagnostics = null;
        private Groups.UserGroups _userGroupsManager;

        [DataMember(Name = "groups")]
        public List<UserGroup> UserGroups { get; set; }

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
        /// The get property for the users name
        /// </summary>
        [DataMember(Name = "userName")]
        public virtual string UserName  {get; set;}

        /// <summary>
        /// The get property for the users email
        /// </summary>
        [DataMember(Name = "email")]
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
            _userGroupsManager = new Groups.UserGroups(_dnaDataReaderCreator, _dnaDiagnostics, null);
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
        public bool CreateUserFromSignInUserID(string userSignInID, int legacyUserID, SignInSystem signInType, int siteID, string loginName, string email, string displayName)
        {
            bool userCreated = false;
            
            IdentityUserID = userSignInID;
            Trace.WriteLine("CreateUserFromSignInUserID() - Using Identity");
            userCreated = CreateNewUserFromId(siteID, IdentityUserID, legacyUserID, loginName, email, displayName);

            if (userCreated)
            {
                GetUsersGroupsForSite();
            }

            return userCreated;
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
        /// <param name="ssoUserID">The users SSO UserID if given</pparam>
        /// <param name="signInLoginName">The users signin system login name</param>
        /// <param name="signInEmail">The users signin system email address</param>
        /// <param name="displayName">The users signin system display name</param>
        private bool CreateNewUserFromId(int siteID, string identityUserID, int ssoUserID, string signInLoginName, string signInEmail, string displayName)
        {
            if (siteID != 0)
            {
                return CreateUserFromSignInUserID(siteID, identityUserID, ssoUserID, signInLoginName, signInEmail, displayName);
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
        private bool CreateUserFromSignInUserID(int siteID, string identityUserID, int ssoUserID, string loginName, string email, string displayName)
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
        /// Creates a user using their DNA User ID
        /// </summary>
        /// <param name="userID">The users DNA ID</param>
        /// <param name="siteID">The site that you want to create the user in</param>
        /// <returns>True if they we're created ok, false if not</returns>
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
        /// Method for reading user data from user procedure calls
        /// </summary>
        /// <param name="reader">The StoredProcedure reader that contains the data</param>
        private void ReadUserDetails(IDnaDataReader reader)
        {
            UserID = reader.GetInt32("userid");
            UserName = reader.GetString("username");
            _status = reader.GetInt32("status");
            if (_status == 1)//normal global status
            {

                if (reader.GetInt32("PrefStatus") == 4)//banned
                {
                    _status = 0;
                }
            }
            Email = reader.GetString("email");
            SiteSuffix = reader.GetStringNullAsEmpty("SiteSuffix");
            LastSynchronisedDate = reader.GetDateTime("LastUpdatedDate");
        }

        /// <summary>
        /// Gets the given users groups they belong to for a given site
        /// </summary>
        /// <returns>The list of groups they belong to. This will be empty if they donot belong to any groups</returns>
        public List<UserGroup> GetUsersGroupsForSite()
        {
            // Call the groups service
            UserGroups = _userGroupsManager.GetUsersGroupsForSite(UserID, SiteID);
            return UserGroups;
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
                        
                        return _status == 0 || _userGroupsManager.IsItemInList(UserGroups, "banned");
                    }
                case UserTypes.Editor:
                    {
                        return _status == 2 || _userGroupsManager.IsItemInList(UserGroups, "editor");
                    }
                case UserTypes.SuperUser:
                    {
                        return _status == 2;
                    }
                case UserTypes.Moderator:
                    {
                        return _userGroupsManager.IsItemInList(UserGroups, "moderator");
                    }
                case UserTypes.NormalUser:
                    {
                        return _status == 1;
                    }
                case UserTypes.Notable:
                    {
                        return _userGroupsManager.IsItemInList(UserGroups, "notables");
                    }
            }

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
    }
}
