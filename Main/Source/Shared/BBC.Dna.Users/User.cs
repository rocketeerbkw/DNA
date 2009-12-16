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
        private int _status = -1;
        private int _siteID = 0;
        protected ICacheManager _cachingObject = null;

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
        /// Default constructor
        /// </summary>
        /// <param name="databaseConnectionDetails">The connection details to connecting to the database.
        /// Leave this null if you want to use the default connection strings</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        //public User(string databaseConnectionDetails, IDnaCache caching)
        public User(string databaseConnectionDetails, ICacheManager caching)
        {
            _databaseConnectionDetails = databaseConnectionDetails;
            if (_databaseConnectionDetails == null || _databaseConnectionDetails == string.Empty)
            {
                _databaseConnectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
            }

            Trace.WriteLine("User() - connection details = " + _databaseConnectionDetails);
            _cachingObject = caching;
            _userGroups = new Groups.UserGroups(_databaseConnectionDetails, caching);
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
        /// <param name="firstName">The users first name if they have one</param>
        /// <param name="lastNames">The users last names if they have any</param>
        /// <param name="displayName">The users display name if gievn</param>
        /// <returns>True if they we're created ok, false if not</returns>
        public bool CreateUserFromSignInUserID(int userSignInID, int legacyUserID, SignInSystem signInType, int siteID, string loginName, string email, string firstName, string lastNames, string displayName)
        {
            bool userCreated = false;
            _siteID = siteID;
            if (signInType == SignInSystem.Identity)
            {
                _IdentitySignInUserID = userSignInID;
                Trace.WriteLine("CreateUserFromSignInUserID() - Using Identity");
                userCreated = CreateNewUserFromId(_siteID, _IdentitySignInUserID, legacyUserID, loginName, email, firstName, lastNames, displayName);
            }
            else
            {
                _ssoSignInUserID = userSignInID;
                userCreated = CreateNewUserFromId(_siteID, 0, _ssoSignInUserID, loginName, email, firstName, lastNames, displayName);
                Trace.WriteLine("CreateUserFromSignInUserID() - Using SSO");
            }
            
            return CreateUserFromDnaUserID(_userID, _siteID);
        }

        /// <summary>
        /// Creates a new stored procedure reader for the given procedure
        /// </summary>
        /// <param name="procedureName">The name of the procedure you want to call</param>
        /// <returns>A stored procedure reader ready to execute the given stored procedure</returns>
        private IDnaDataReader CreateStoreProcedureReader(string procedureName)
        {
            return new StoredProcedureReader(procedureName, _databaseConnectionDetails, null);
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
        private bool CreateNewUserFromId(int siteID, int identityUserID, int ssoUserID, string ssoLoginName, string ssoEmail, string ssoFirstNames, string ssoLastName, string displayName)
        {
            if (siteID != 0)
            {
                if (identityUserID != 0)
                {
                    using (IDnaDataReader reader = CreateStoreProcedureReader("createnewuserfromidentityid"))
                    {
                        reader.AddParameter("identityuserid", identityUserID);
                        if (ssoUserID > 0)
                        {
                            reader.AddParameter("legacyssoid", ssoUserID);
                        }

                        reader.AddParameter("username", ssoLoginName);
                        reader.AddParameter("email", ssoEmail);
                        reader.AddParameter("siteid", siteID);
                        if (ssoFirstNames.Length > 0)
                        {
                            reader.AddParameter("firstnames", ssoFirstNames);
                        }

                        if (ssoLastName.Length > 0)
                        {
                            reader.AddParameter("lastname", ssoLastName);
                        }

                        if (displayName.Length > 0)
                        {
                            reader.AddParameter("displayname", displayName);
                        }

                        reader.Execute();
                        if (reader.Read() && reader.HasRows)
                        {
                            // Get the id for the user.
                            _userID = reader.GetInt32("userid");
                            return _userID > 0;
                        }
                    }
                }
                else
                {
                    using (IDnaDataReader reader = CreateStoreProcedureReader("createnewuserfromssoid"))
                    {
                        reader.AddParameter("ssouserid", ssoUserID);
                        reader.AddParameter("username", ssoLoginName);
                        reader.AddParameter("email", ssoEmail);
                        reader.AddParameter("siteid", siteID);
                        if (ssoFirstNames.Length > 0)
                        {
                            reader.AddParameter("firstnames", ssoFirstNames);
                        }

                        if (ssoLastName.Length > 0)
                        {
                            reader.AddParameter("lastname", ssoLastName);
                        }

                        if (displayName.Length > 0)
                        {
                            reader.AddParameter("displayname", displayName);
                        }

                        reader.Execute();
                        if (reader.Read() && reader.HasRows)
                        {
                            // Get the id for the user.
                            _userID = reader.GetInt32("userid");
                            return _userID > 0;
                        }
                    }
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
                        _userID = reader.GetInt32("userid");
                        _userName = reader.GetString("username");
                        _status = reader.GetInt32("status");
                        _firstNames = reader.GetStringNullAsEmpty("firstnames");
                        _lastName = reader.GetStringNullAsEmpty("lastname");
                        _email = reader.GetString("email");
                        _siteID = siteID;
                        GetUsersGroupsForSite();
                        return true;
                    }
                }
            }
            return false;
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
    }
}
