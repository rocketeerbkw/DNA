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
    
    /// <summary>
    /// The dna user class
    /// </summary>
    public class User : IUser
    {
        private Groups.UserGroups _userGroups;
        private List<string> _usersGroupsForSite;
        protected string _databaseConnectionDetails = "";
        private int _userID = 0;
        private int _ssoSignInUserID = 0;
        private int _IdentitySignInUserID = 0;
        private string _userName = "";
        private string _email = "";
        private string _firstNames = "";
        private string _lastName = "";
        private string _siteSuffix = "";
        private int _status = -1;
        private int _siteID = 0;
        private DateTime _lastSynchronisedDate;
        protected ICacheManager _cachingObject = null;
        protected IDnaDataReaderCreator _dnaDataReaderCreator = null;
        protected IDnaDiagnostics _dnaDiagnostics = null;

        /// <summary>
        /// Get property for the dna users id
        /// </summary>
        public virtual int UserID
        {
            get { return _userID; }
        }

        /// <summary>
        /// The get property for the users SSO user id
        /// </summary>
        public virtual int SSOUserID
        {
            get { return _ssoSignInUserID; }
        }

        /// <summary>
        /// The get property for the users identity user id
        /// </summary>
        public virtual int IdentityUserID
        {
            get { return _IdentitySignInUserID; }
        }

        /// <summary>
        /// The get property for the users name
        /// </summary>
        public virtual string UserName
        {
            get { return _userName; }
        }

        /// <summary>
        /// The get property for the users email
        /// </summary>
        public string Email
        {
            get { return _email; }
        }

        /// <summary>
        /// The get property for the user first names
        /// </summary>
        public string FirstNames
        {
            get { return _firstNames; }
        }

        /// <summary>
        /// The get property for the users last name
        /// </summary>
        public string LastName
        {
            get { return _lastName; }
        }

        /// <summary>
        /// The get property for the users status
        /// </summary>
        public int Status
        {
            get { return _status; }
        }

        /// <summary>
        /// The get property for the siteid the user was created for
        /// </summary>
        public int SiteID
        {
            get { return _siteID; }
        }

        /// <summary>
        /// The get property for the users
        /// </summary>
        public DateTime LastSynchronisedDate
        {
            get { return _lastSynchronisedDate; }
        }

        /// <summary>
        /// Get property for the users SiteSuffix
        /// </summary>
        public string SiteSuffix
        {
            get { return _siteSuffix; }
        }

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
            _userGroups = new Groups.UserGroups(_dnaDataReaderCreator, _dnaDiagnostics, null);
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
        public bool CreateUserFromSignInUserID(int userSignInID, int legacyUserID, SignInSystem signInType, int siteID, string loginName, string email, string displayName)
        {
            bool userCreated = false;
            _siteID = siteID;
            if (signInType == SignInSystem.Identity)
            {
                _IdentitySignInUserID = userSignInID;
                Trace.WriteLine("CreateUserFromSignInUserID() - Using Identity");
                userCreated = CreateNewUserFromId(_siteID, _IdentitySignInUserID, legacyUserID, loginName, email, displayName);
            }
            else
            {
                _ssoSignInUserID = userSignInID;
                userCreated = CreateNewUserFromId(_siteID, 0, _ssoSignInUserID, loginName, email, displayName);
                Trace.WriteLine("CreateUserFromSignInUserID() - Using SSO");
            }

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
            string procedureName = "GetDnaUserIDFromSSOUserID";
            string signInIDName = "SSOUserID";
            if (signInType == SignInSystem.Identity)
            {
                procedureName = "GetDnaUserIDFromIdentityUserID";
                signInIDName = "IdentityUserID";
            }

            using (IDnaDataReader reader = CreateStoreProcedureReader(procedureName))
            {
                reader.AddParameter(signInIDName, signInUserID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    _userID = reader.GetInt32("DnaUserID");
                }
            }

            return _userID;
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
        private bool CreateNewUserFromId(int siteID, int identityUserID, int ssoUserID, string signInLoginName, string signInEmail, string displayName)
        {
            if (siteID != 0)
            {
                return CreateUserFromSignInUserID(siteID, identityUserID, ssoUserID, signInLoginName, signInEmail, displayName, identityUserID != 0);
            }
            return false;
        }

        /// <summary>
        /// Helper method for creating and getting users via signin userids
        /// </summary>
        /// <param name="siteID">The id of the site the user is being created on</param>
        /// <param name="identityUserID">The users IDentity UserID</param>
        /// <param name="ssoUserID">The users SSO UserID or Legacy SSO UserID</param>
        /// <param name="loginName">The users Login Name</param>
        /// <param name="email">The users Email</param>
        /// <param name="displayName">The users displayname</param>
        /// <param name="identitySignIn">A flag to state that we're on an Identity signin site or SSO site</param>
        /// <returns>True if the user is created, false if not</returns>
        private bool CreateUserFromSignInUserID(int siteID, int identityUserID, int ssoUserID, string loginName, string email, string displayName, bool identitySignIn)
        {
            string procedureName = "createnewuserfromidentityid";
            if (!identitySignIn)
            {
                procedureName = "createnewuserfromssoid";
            }

            using (IDnaDataReader reader = CreateStoreProcedureReader(procedureName))
            {
                if (identitySignIn)
                {
                    reader.AddParameter("identityuserid", identityUserID);
                    if (ssoUserID > 0)
                    {
                        reader.AddParameter("legacyssoid", ssoUserID);
                    }
                }
                else
                {
                    reader.AddParameter("ssouserid", ssoUserID);
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
                    _siteID = siteID;
                    ReadUserDetails(reader);
                    return _userID > 0;
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
                        _siteID = siteID;
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
            _userID = reader.GetInt32("userid");
            _userName = reader.GetString("username");
            _status = reader.GetInt32("status");
            _email = reader.GetString("email");
            _siteSuffix = reader.GetStringNullAsEmpty("SiteSuffix");
            _lastSynchronisedDate = reader.GetDateTime("LastUpdatedDate");
        }

        /// <summary>
        /// Gets the given users groups they belong to for a given site
        /// </summary>
        /// <returns>The list of groups they belong to. This will be empty if they donot belong to any groups</returns>
        public List<string> GetUsersGroupsForSite()
        {
            // Call the groups service
            _usersGroupsForSite = _userGroups.GetUsersGroupsForSite(_userID, _siteID);
            return _usersGroupsForSite;
        }

        /// <summary>
        /// Adds the current user to the given group
        /// </summary>
        /// <param name="groupName">The name of the group you want to add the user to</param>
        /// <returns>True if they were added, false if something went wrong</returns>
        public bool AddUserToGroup(string groupName)
        {
            // Call the groups service
            if (_userGroups.PutUserIntoGroup(UserID, groupName, SiteID))
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
            if (_userGroups.PutUserIntoGroup(userID, groupName, siteID))
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
            _userGroups.DeleteUserFromGroup(UserID, groupName, SiteID);
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
            _userGroups.DeleteUserFromGroup(userID, groupName, siteID);
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
                        return _status == 0 || _usersGroupsForSite.Contains("banned");
                    }
                case UserTypes.Editor:
                    {
                        return _status == 2 || _usersGroupsForSite.Contains("editor");
                    }
                case UserTypes.SuperUser:
                    {
                        return _status == 2;
                    }
                case UserTypes.Moderator:
                    {
                        return _usersGroupsForSite.Contains("moderator");
                    }
                case UserTypes.NormalUser:
                    {
                        return _status == 1;
                    }
                case UserTypes.Notable:
                    {
                        return _usersGroupsForSite.Contains("notables");
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
            if (_userName != signInUserName || _email != signInEmail)
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("synchroniseuserwithprofile"))
                {
                    reader.AddParameter("userid", _userID);
                    reader.AddParameter("displayname", signInUserName);
                    reader.AddParameter("loginname", signInLoginName);
                    reader.AddParameter("email", signInEmail);
                    reader.AddParameter("siteid", _siteID);
                    reader.AddParameter("identitysite", _IdentitySignInUserID > 0 ? 1 : 0);
                    reader.Execute();
                    if (reader.Read())
                    {
                        _email = signInEmail;
                        if (signInUserName.Length > 0)
                        {
                            _userName = signInUserName;
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
            if (_siteSuffix != siteSuffix)
            {
                using (IDnaDataReader dataReader = CreateStoreProcedureReader("updateuser2"))
                {
                    dataReader.AddParameter("UserID", _userID);
                    dataReader.AddParameter("SiteID", _siteID);
                    dataReader.AddParameter("SiteSuffix", siteSuffix);
                    dataReader.Execute();
                }

                _siteSuffix = siteSuffix;
            }
        }
    }
}
