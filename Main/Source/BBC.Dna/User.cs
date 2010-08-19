using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna.Component;
using DnaIdentityWebServiceProxy;
using BBC.Dna.Data;
using System.Threading;
using BBC.Dna.Utils;
using BBC.Dna.Objects;

namespace BBC.Dna
{

    /// <summary>
    /// The Dna User component
    /// </summary>
    public class User : DnaInputComponent, IUser
    {
		enum UserStatus
		{
			Inactive,
			Active,
			SuperUser
		}

		private UserStatus _status = UserStatus.Inactive;
		private string _userName = String.Empty;
        private string _preferredSkin = String.Empty;

        //Copy of SSO Maintained Data.
        private string _loginName = String.Empty;
        private int     _userID = 0;
        private bool    _userLoggedIn = false;
        private string  _userEmail = String.Empty;
		private string  _firstNames = String.Empty;
		private string  _lastName = String.Empty;
		private string  _password = String.Empty;
		private string  _title = String.Empty;
		private string  _siteSuffix = String.Empty;
        private int     _journalID = 0;
        private int     _teamID = 0;
        private string  _bbcuid = String.Empty;
        private bool    _acceptSubscriptions = false;
        private DateTime _lastUpdated;

        private bool _gotUserData = false;
        private bool _gotUserGroupsData = false;
        private bool _showFullUserDetails = false;
        private int _prefStatus = 0;

        private Dictionary<string, object> _userData = new Dictionary<string, object>();
        private List<string> _userGroupsData = new List<string>();

        private XmlNode _userElementNode;
        private XmlNode _userGroupsElementNode;

		private int _masthead;

        private string _identityUserId = String.Empty;

        private static object _lock = new object();

        /// <summary>
        /// Default constructor
        /// </summary>
        public User(IInputContext context)
            : base(context)
        {
            _userData.Clear();
            _userGroupsData.Clear();

            //_viewingUserElementNode = CreateElementNode("VIEWING-USER");
            //RootElement.AppendChild(_viewingUserElementNode);
        }

        /// <summary>
        /// Journal forum ID
        /// </summary>
        public int Journal
        {
            get
            {
                return _journalID;
            }
        }

        /// <summary>
        /// Team ID
        /// </summary>
        public int TeamID
        {
            get
            {
                return _teamID;
            }
        }

        /// <summary>
        /// This is the DNA Username, not to be confused with the ProfileAPI login name
        /// (which is called username in the profile API database).
        /// </summary>
        public string UserName
        {
            get { return _userName; }
        }

        /// <summary>
        /// Returns the users status
        /// </summary>
        public int Status
        {
            get { return (int)_status; }
        }


        /// <summary>
        /// Login Name property
        /// </summary>
        public string LoginName
        {
            get
            {
                return _loginName;
            }
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public string FirstNames
		{
			get
			{
				return _firstNames;
			}
		}

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public string LastName
		{
			get
			{
				return _lastName;
			}
		}

        /// <summary>
        /// UserID Property
        /// </summary>
        public int UserID
        {
            get
            {
                return _userID;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public string IdentityUserId
        {
            get
            {
                return _identityUserId;
            }
        }

        /// <summary>
        /// UserLoggedIn Property
        /// </summary>
        public bool UserLoggedIn
        {
            get
            {
                return _userLoggedIn;
            }
        }

        /// <summary>
        /// Users EMail Property
        /// </summary>
        public string Email
        {
            get
            {
                return _userEmail;
            }
        }

        /// <summary>
        /// Accept Subscriptions Property - Idicates whether user allows subscriptions to their content.
        /// </summary>
        public bool AcceptSubscriptions
        {
            get
            {
                return _acceptSubscriptions;
            }
        }

        /// <summary>
        /// Gets the users BBCUID value
        /// </summary>
        public string BbcUid
        {
            get { return _bbcuid; }
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public bool IsSuperUser
		{
			// TODO: Check the groups as well
			get
			{
                if (UserLoggedIn && _status == UserStatus.SuperUser)
				{
					return true;
				}
                return false;
			}
		}

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsEditor
        {
            get
            {
                if (UserLoggedIn)
                {
                    return (IsSuperUser || _userGroupsData.Contains("editor"));
                }
                return false;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsNotable
        {
            // TODO: Check the groups as well
            get
            {
                return _userGroupsData.Contains("notables");
            }
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public bool IsScout
		{
			get
			{
				return _userGroupsData.Contains("scouts");
			}
		}

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsModerator
        {
            // TODO: Check the groups as well
            get
            {
                return _userGroupsData.Contains("moderator");
            }
        }
		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public bool IsSubEditor
		{
			// TODO: Check the groups as well
			get
			{
				return _userGroupsData.Contains("subs");
			}
		}

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsReferee
        {
            get
            {
                return _userGroupsData.Contains("referee");
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsPreModerated 
        {
            get
            {
                return _prefStatus == (int)ModerationUserStatuses.Status.Premoderated;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsPostModerated
        {
            get
            {
                return _prefStatus == (int) ModerationUserStatuses.Status.Postmoderated;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsBanned
        {
            get
            {
                return _prefStatus == (int)ModerationUserStatuses.Status.Restricted;
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsTester
        {
            get
            {
                return _userGroupsData.Contains("tester");
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsHost
        {
            get
            {
                return _userGroupsData.Contains("host");
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsAutoSinBin
        {
            get
            {
                //TODO Rewrite - Not very nice.
               object AutoSinBin;
               _userData.TryGetValue("SinBin", out AutoSinBin);
               return Convert.ToBoolean(AutoSinBin);
            }
        }

        /// <summary>
        /// ShowFullDetails Property
        /// </summary>
        public bool ShowFullDetails
        {
            get
            {
                return _showFullUserDetails;
            }
            set
            {
                _showFullUserDetails = value;
            }
        }

        /// <summary>
        /// A users preferred skin
        /// </summary>
        public string PreferredSkin
        {
            get 
            { 
                return _preferredSkin; 
            }
            set { _preferredSkin = value; }
            
        }

        /// <summary>
        /// Public access to the user data dictionary object
        /// </summary>
        public Dictionary<string, object> UserData
        {
            get { return _userData; }
        }

        /// <summary>
        /// Gets the user details for the given user ID in the current site
        /// </summary>
        /// <param name="userID">ID of the user we want to get</param>
        public void CreateUser(int userID)
        {
            _userID = userID;
            GetUserDetails();

            // Now generate the XML for the user
            GenerateUserXml();
        }

        /// <summary>
        /// This is the function that creates the viewing user. It checks to ssee if the user is currently logged in
        /// and retrieves their details from SSO
        /// </summary>
		public void CreateUser()
		{
            IDnaIdentityWebServiceProxy signInComponent = InputContext.GetCurrentSignInObject;
            string signInMethod = "SSO-Signin";
            if (signInComponent.SignInSystemType == SignInSystem.Identity)
            {
                signInMethod = "IDENTITY-Signin";
            }
            InputContext.Diagnostics.WriteTimedSignInEventToLog("User","Creating User");

			bool autoLogIn = false;
            bool migrated = false;

		    DnaCookie cookie;
            if (signInComponent.SignInSystemType == SignInSystem.Identity)
            {
                cookie = InputContext.GetCookie("IDENTITY");
            }
            else
            {
                cookie = InputContext.GetCookie("SSO2-UID");
            }

		    if (cookie == null)
		    {
                InputContext.Diagnostics.WriteTimedSignInEventToLog(signInMethod, "No cookie");
                Statistics.AddLoggedOutRequest();
                return;
		    }

		    if (!InitialiseProfileAPI(cookie, ref signInComponent))
		    {
			    InputContext.Diagnostics.WriteWarningToLog("ProfileAPI", "Unable to initialise user");
			    signInComponent.CloseConnections();
                InputContext.Diagnostics.WriteTimedSignInEventToLog(signInMethod, "SignIn System Failed");
                return;
		    }

		    TryLoginUser(ref signInComponent, ref autoLogIn, ref migrated);

		    // Get the users BBCUID
            if (InputContext.GetCookie("BBC-UID") != null)
            {
                _bbcuid = InputContext.GetCookie("BBC-UID").Value;
            }

			// If we're logged in, then get the details for the current user
            if (_userLoggedIn)
            {
                InputContext.Diagnostics.WriteToLog("User", "User logged in");

                bool newUser = false;
                string ssoLoginName;
                string ssoDisplayName;
                string ssoEmail;
                string ssoFirstNames;
                string ssoLastName;
                int ssoUserID;
                string identityUserID;

                // Check to make sure that we've got the users details
                if (!GetUserDetails())
                {
                    // New User has registered - add them to DB.
                    newUser = true;

                    // Check to see if the users email is in the banned list
                    if (!IsEmailInBannedList(signInComponent))
                    {
                        // Get the users details from SSO
                        ReadUserSSODetails(signInComponent, out ssoLoginName, out ssoEmail, out ssoFirstNames, out ssoLastName, out identityUserID, out ssoUserID, out ssoDisplayName);

                        // Create the new user in the database with the given information
                        if (CreateNewUserFromId(identityUserID, ssoUserID, ssoLoginName, ssoEmail, ssoFirstNames, ssoLastName, InputContext.CurrentSite.SiteID, ssoDisplayName))
                        {
                            // Get the extra details from our dtabase
                            GetUserDetails();
                        }
                    }
                }

                //Existing users may need to be synchronised.
                bool autoLogInOrSync = (autoLogIn || InputContext.GetParamIntOrZero("s_sync", "User's details must be synchronised with the data in SSO.") == 1);
                InputContext.Diagnostics.WriteToLog("User", "Auto login Synch check" + autoLogInOrSync.ToString());

                // If the site is using identity, then we need to check the users last updated date
                DateTime lastUpdatedDateFromSignInSystem = DateTime.Now;
                if (signInComponent.SignInSystemType == SignInSystem.Identity)
                {
                    if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "lastupdated"))
                    {
                        lastUpdatedDateFromSignInSystem = Convert.ToDateTime(signInComponent.GetUserAttribute("lastupdated"));
                        InputContext.Diagnostics.WriteToLog("User", "Signin - lastUpdatedDate - " + lastUpdatedDateFromSignInSystem.ToString());
                        InputContext.Diagnostics.WriteToLog("User", "DNA - lastUpdatedDate - " + _lastUpdated.ToString());

                        autoLogInOrSync |= _lastUpdated < lastUpdatedDateFromSignInSystem;
                    }
                }
                InputContext.Diagnostics.WriteToLog("User", "Synch check - " + autoLogInOrSync.ToString());
                InputContext.Diagnostics.WriteToLog("User", "New user - " + newUser.ToString());
                InputContext.Diagnostics.WriteToLog("User", "Synch check - " + migrated.ToString());

                if ((!newUser || migrated) && autoLogInOrSync)
                {
                    ReadUserSSODetails(signInComponent, out ssoLoginName, out ssoEmail, out ssoFirstNames, out ssoLastName, out identityUserID, out ssoUserID, out ssoDisplayName);
                    _lastUpdated = lastUpdatedDateFromSignInSystem;
                    SynchroniseWithProfile(ssoLoginName, ssoEmail, ssoFirstNames, ssoLastName, ssoDisplayName);
                }
                else
                {
                    CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName();
                }
            }
            else
            {
                Statistics.AddLoggedOutRequest();
            }

			signInComponent.CloseConnections();
            
            // Now generate the XML for the user
            GenerateUserXml();

            InputContext.Diagnostics.WriteTimedSignInEventToLog(signInMethod, "Created User" + _userID.ToString());
        }

        /// <summary>
        /// Checks to see if the current users email is in the banned email list
        /// </summary>
        /// <param name="signInComponent">The Signin component for this request</param>
        /// <returns>True if they are, false if not</returns>
        /// <remarks>If there are any problems encounted within the method, then it defaults by returning true for safety reasons.</remarks>
        private bool IsEmailInBannedList(IDnaIdentityWebServiceProxy signInComponent)
        {
            // User should be logged in before calling this method
            if (!signInComponent.IsUserLoggedIn)
            {
                return true;
            }

            // Get the current users cookie
            DnaCookie cookie;
            if (signInComponent.SignInSystemType == SignInSystem.Identity)
            {
                cookie = InputContext.GetCookie("IDENTITY");
            }
            else
            {
                cookie = InputContext.GetCookie("SSO2-UID");
            } 
            
            bool validCookie = (cookie != null && cookie.Value != null && cookie.Value.Length >= 64);

            // Check to see if the users cookie is in the banned cookie list
            if (validCookie)
            {
                // Lock the banned list while we check
                Monitor.Enter(_lock);
                try
                {
                    foreach (string bannedCookie in AppContext.BannedCookies)
                    {
                        // If we find a match, then return true as they are banned
                        if (cookie.Value.CompareTo(bannedCookie) == 0)
                        {
                            return true;
                        }
                    }
                }
                finally
                {
                    Monitor.Exit(_lock);
                }
            }

            // Now check to see if their email is in the banned list in the database
            string ssoEmail = string.Empty;
            if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "email"))
            {
                // Get the email for this current user
                ssoEmail = signInComponent.GetUserAttribute("email");
            }
            else
            {
                // The service does not support emails, nothing to check. Return not banned
                return false;
            }

            // Make sure we have an email from SSO
            if (ssoEmail.Length == 0)
            {
                return true;
            }

            // Check it against the database
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("IsEmailInBannedList"))
            {
                // Add the email param, execute and then check the return value
                reader.AddParameter("Email", ssoEmail);
                reader.Execute();

                // Check to make sure we got something back!
                if (!reader.HasRows || !reader.Read())
                {
                    return true;
                }

                // If they are banned and they have a valid cookie, add them to the banned list and return true
                if (reader.GetInt32("IsBanned") > 0)
                {
                    // Add the users cookie to the banned cookie list, and then return
                    if (validCookie)
                    {
                        // Lock the banned list while we add the cookie
                        Monitor.Enter(_lock);
                        try
                        {
                            AppContext.BannedCookies.Add(cookie.Value);
                        }
                        finally
                        {
                            Monitor.Exit(_lock);
                        }
                    }
                    return true;
                }
            }

            // If we get here, then we're not banned
            return false;
        }

        /// <summary>
        /// Initialises profile connection.
        /// </summary>
        /// <param name="cookie">Dna Cookie to login with</param>
        /// <param name="signInComponent">Initialised ProfileAPI</param>
        private bool InitialiseProfileAPI(DnaCookie cookie, ref IDnaIdentityWebServiceProxy signInComponent)
        {
            InputContext.Diagnostics.WriteTimedEventToLog("SSO", "Start");
            DateTime timer = DateTime.Now; 

            // Set the current user. If this returns false, it means the user was not signed in correctly
            string decodedCookie = cookie.Value;

            // Get a profile connection
            if (signInComponent.SignInSystemType == SignInSystem.Identity)
            {
                signInComponent.SetService(InputContext.CurrentSite.IdentityPolicy);
            }
            else
            {
                signInComponent.SetService(InputContext.CurrentSite.SSOService);
            }

            InputContext.Diagnostics.WriteTimedEventToLog("SSO","End");

            // Check to see if the service was set ok before calling any user functions
            if (!signInComponent.IsServiceSet)
            {
                InputContext.Diagnostics.WriteToLog("---** SignIn **---", "Service not set!!!");
                return false;
            }

            string secureCookie = "";
            if (InputContext.GetCookie("IDENTITY-HTTPS") != null)
            {
                secureCookie = InputContext.GetCookie("IDENTITY-HTTPS").Value;
            }

            bool userSet = signInComponent.TrySecureSetUserViaCookies(decodedCookie, secureCookie) || signInComponent.IsUserSignedIn;

            InputContext.IsSecureRequest = signInComponent.IsSecureRequest;
            InputContext.Diagnostics.WriteToLog("---** InputContext.IsSecureRequest **---", InputContext.IsSecureRequest.ToString());
            if (!userSet)
            {
                InputContext.Diagnostics.WriteToLog("---** SignIn **---", "Set user with cookie failed!!! - " + decodedCookie);
                if (secureCookie.Length > 0)
                {
                    InputContext.Diagnostics.WriteToLog("---** SignIn **---", "Set user with secure cookie failed!!! - " + secureCookie);
                }
                return false;
            }

            Statistics.AddIdentityCallDuration(TimeSpan.FromTicks(DateTime.Now.Ticks - timer.Ticks).Milliseconds);

            return true;
        }


        /// <summary>
        /// Method that tries to login in the user with a cookie.
        /// Requires Profile API to be initialised.
        /// </summary>
        /// <param name="signInComponent">Initialised SignIn Component</param>
        /// <param name="autoLogIn">Indicates whether user login was performed.</param>
        /// <param name="migrated">Indicate whether the user is migrating. This happens when we can't find the identity userid, but we can the legacy sso id</param>
        private void TryLoginUser(ref IDnaIdentityWebServiceProxy signInComponent, ref bool autoLogIn, ref bool migrated)
        {
            autoLogIn = false;
            _userID = 0;
                
            // Check to see if they are logged in
            _userLoggedIn = signInComponent.IsUserLoggedIn;
            if (!_userLoggedIn)
            {
                try
                {
                    // Try to log them into the service
                    _userLoggedIn = signInComponent.LoginUser();
                    autoLogIn = _userLoggedIn;
                }
                catch (ProfileAPIException ex)
                {
                    // Catch any Profile Exceptions, but don't throw as we can carry on without the user being logged in
                    InputContext.Diagnostics.WriteWarningToLog("User", "Failed to log in user");
                    InputContext.Diagnostics.WriteExceptionToLog(ex);
                    _userLoggedIn = false;
                }
                catch (MySql.Data.MySqlClient.MySqlException ex)
                {
                    InputContext.Diagnostics.WriteWarningToLog("User", "Failed to log in user");
                    InputContext.Diagnostics.WriteExceptionToLog(ex);
                    _userLoggedIn = false;
                }
            }

            _loginName = signInComponent.LoginName;

            // Now get the userid if we logged them in ok
            if (_userLoggedIn)
            {
                GetDnaUserIDFromSignInID(signInComponent, "");
                if (_userID == 0 && signInComponent.SignInSystemType == SignInSystem.Identity)
                {
                    if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "legacy_user_id"))
                    {
                        int legacyID = 0;
                        if (int.TryParse(signInComponent.GetUserAttribute("legacy_user_id"), out legacyID))
                        {
                            GetDnaUserIDFromSignInID(signInComponent, legacyID.ToString());
                            migrated = true;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Tries to find the userid dna id from their sign id
        /// </summary>
        /// <param name="signInComponent">The current signin component</param>
        /// <param name="overideSignInUserID">If this is greater than 0, then it is used instead of the signin objects userid</param>
        private void GetDnaUserIDFromSignInID(IDnaIdentityWebServiceProxy signInComponent, string overideSignInUserID)
        {
            // Get the DnaUserID associated with the SignInUserID
            string identityUserID = signInComponent.UserID;
            if (overideSignInUserID.Length > 0)
            {
                identityUserID = overideSignInUserID;
            }

            string databaseProc = "GetDnaUserIDFromIdentityUserID";
            string signInIDName = "IdentityUserID";

            // Now get the user id
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader(databaseProc))
            {
                reader.AddParameter(signInIDName, identityUserID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    _userID = reader.GetInt32("DnaUserID");
                }
            }
        }

        /// <summary>
        /// <param name="signInComponent"></param>
        /// <param name="ssoLoginName"></param>
        /// <param name="ssoEmail"></param>
        /// <param name="ssoFirstNames"></param>
        /// <param name="ssoLastName"></param>
        /// <param name="identityUserID"></param>
        /// <param name="ssoUserID"></param>
        /// <param name="ssoDisplayName"></param>
        /// </summary>
        private bool ReadUserSSODetails(IDnaIdentityWebServiceProxy signInComponent, out string ssoLoginName, out string ssoEmail, out string ssoFirstNames, out string ssoLastName, out string identityUserID, out int ssoUserID, out string ssoDisplayName)
        {
            ssoLoginName = signInComponent.LoginName;

            ssoDisplayName = string.Empty;
            if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "displayname"))
            {
                ssoDisplayName = signInComponent.GetUserAttribute("displayname");
            }

            ssoEmail = string.Empty;
            if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "email"))
            {
                ssoEmail = signInComponent.GetUserAttribute("email");
            }

            ssoFirstNames = string.Empty;
            if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "firstname"))
            {
                ssoFirstNames = signInComponent.GetUserAttribute("firstname");
            }

            ssoLastName = string.Empty;
            if (signInComponent.DoesAttributeExistForService(InputContext.CurrentSite.SSOService, "lastname"))
            {
                ssoLastName = signInComponent.GetUserAttribute("lastname");
            }

            ssoUserID = 0;
            identityUserID = signInComponent.UserID;

            if (signInComponent.GetUserAttribute("legacy_user_id").Length > 0)
            {
                ssoUserID = Convert.ToInt32(signInComponent.GetUserAttribute("legacy_user_id"));
            }

            return true;
        }

        /// <summary>
        /// <param name="ssoLoginName"></param>
        /// <param name="ssoEmail"></param>
        /// <param name="ssoFirstNames"></param>
        /// <param name="ssoLastName"></param>
        /// <param name="ssoDisplayName"></param>
        /// Synchronises DNA User Details with SSO Details.
        /// </summary>
        private bool SynchroniseWithProfile( string ssoLoginName, string ssoEmail, string ssoFirstNames, string ssoLastName, string ssoDisplayName )
        {
            CheckAutoGeneratedName();

            if (ssoLoginName != _loginName || ssoEmail != _userEmail || ssoFirstNames != _firstNames || ssoLastName != _lastName || (ssoDisplayName.Length > 0 && ssoDisplayName != _userName))
            {
                //Need to update DNA copy of SSO data.
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("synchroniseuserwithprofile"))
                {
                    dataReader.AddParameter("@userid", _userID );
                    dataReader.AddParameter("@email", ssoEmail);
                    dataReader.AddParameter("@loginName", ssoLoginName);
                    dataReader.AddParameter("@siteID", InputContext.CurrentSite.SiteID);
                    dataReader.AddParameter("@lastname", ssoLastName);
                    dataReader.AddParameter("@firstnames", ssoFirstNames);
                    if (ssoDisplayName.Length > 0)
                    {
                        dataReader.AddParameter("@displayname", ssoDisplayName);
                    }
                    dataReader.AddParameter("@identitysite", InputContext.CurrentSite.UseIdentitySignInSystem ? 1 : 0);
                    dataReader.Execute();

                    if (dataReader.Read() )
                    {
                        _loginName = ssoLoginName;
                        _firstNames = ssoFirstNames;
                        _lastName = ssoLastName;
                        _userEmail = ssoEmail;
                        if (ssoDisplayName.Length > 0)
                        {
                            _userName = ssoDisplayName;
                        }
                        return true;
                    }
                }
            }
            return false;
        }
        /// <summary>
        /// Checks if the site suffix is null or the same as their username and if we're on a site that uses AutoGen names	
		///		Checks if one exists and goes and gets the users autogen nickname from the signin system
        /// </summary>
        private void CheckForExistingUDNGifSiteSuffixIsNullOrDisplayName()
        {
            if (InputContext.GetSiteOptionValueBool("User", "UseSiteSuffix") && InputContext.GetSiteOptionValueString("User", "AutoGeneratedNames").Length > 0)
	        {
		        if (InputContext.GetSiteOptionValueBool("General","IsKidsSite"))
		        {
                    if (_siteSuffix.Length == 0 || _siteSuffix == _userName)
			        {
                        CheckAutoGeneratedName();
			        }
		        }
	        }
        }
        /// <summary>
        /// Checks to see if the site currently uses auto gen names, and if so, syncs with identity
        /// </summary>
        private void CheckAutoGeneratedName()
        {
            // Check to see if we've got a site that needs autogenerated nicknames
            string autoGenURL = InputContext.GetSiteOptionValueString("User", "AutoGeneratedNames");
            if (autoGenURL.Length > 0)
            {
                string siteSuffix = "";
                string attribNameSpace = "";
                string attribName = "";

                if (InputContext.GetSiteOptionValueBool("General", "IsKidsSite"))
                {
                    attribNameSpace = "cbbc";
                    attribName = "cbbc_displayname";
                }

                // Get the generated name from Identity
                if (InputContext.GetCurrentSignInObject.DoesAppNameSpacedAttributeExist(InputContext.GetCookie("IDENTITY").Value, attribNameSpace, attribName))
                {
                    // Set the users site suffix for this site with the one in Identity
                    siteSuffix = InputContext.GetCurrentSignInObject.GetAppNameSpacedAttribute(InputContext.GetCookie("IDENTITY").Value, attribNameSpace, attribName);

                    // Only update if it's different to the one we already have
                    if (_siteSuffix != siteSuffix)
                    {
                        using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updateuser2"))
                        {
                            dataReader.AddParameter("UserID", _userID);
                            dataReader.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                            dataReader.AddParameter("SiteSuffix", siteSuffix);
                            dataReader.Execute();
                        }

                        _siteSuffix = siteSuffix;
                        _userData["SiteSuffix"] = siteSuffix;
                    }
                }
                else
                {
                    _siteSuffix = String.Empty;
                    _userData["SiteSuffix"] = String.Empty;
                }

            }
        }

        /// <summary>
        /// Gets the user data details and fills in the XML block
        /// </summary>
        private bool GetUserDetails()
        {
            if (GetUserData())
            {
                GetUserGroupsData();
                return true;
            }
            return false;
        }

        /// <summary>
        /// Gets the user data details and fills in the XML block
        /// </summary>
        private bool CreateNewUserFromId(string identityUserID, int ssoUserID, string ssoLoginName, string ssoEmail, string ssoFirstNames, string ssoLastName, int siteId, string ssoDisplayName )
        {
            if (InputContext.CurrentSite.SiteID != 0)
            {
                if (InputContext.CurrentSite.UseIdentitySignInSystem)
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("createnewuserfromidentityid"))
                    {
                        dataReader.AddParameter("identityuserid", identityUserID);
                        if (ssoUserID > 0)
                        {
                            dataReader.AddParameter("legacyssoid", ssoUserID);
                        }

                        dataReader.AddParameter("username", ssoLoginName);
						dataReader.AddParameter("email",ssoEmail);
						dataReader.AddParameter("siteid",siteId);
                        if (ssoFirstNames.Length > 0)
                        {
                            dataReader.AddParameter("firstnames", ssoFirstNames);
                        }

                        if (ssoLastName.Length > 0)
                        {
                            dataReader.AddParameter("lastname", ssoLastName);
                        }

                        if (ssoDisplayName.Length > 0)
                        {
                            dataReader.AddParameter("displayname", ssoDisplayName);
                        }

                        dataReader.Execute();
                        if (dataReader.Read() && dataReader.HasRows)
                        {
                            // Get the id for the user.
                            _userID = dataReader.GetInt32("userid");
                            return _userID > 0;
                        }
                    }
                }
                else
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("createnewuserfromssoid"))
                    {
                        dataReader.AddParameter("ssouserid", ssoUserID);
                        dataReader.AddParameter("username", ssoLoginName);
                        dataReader.AddParameter("email", ssoEmail);
                        dataReader.AddParameter("siteid", siteId);
                        if (ssoFirstNames.Length > 0)
                        {
                            dataReader.AddParameter("firstnames", ssoFirstNames);
                        }

                        if (ssoLastName.Length > 0)
                        {
                            dataReader.AddParameter("lastname", ssoLastName);
                        }

                        dataReader.Execute();
                        if (dataReader.Read() && dataReader.HasRows)
                        {
                            // Get the id for the user.
                            _userID = dataReader.GetInt32("userid");
                            return _userID > 0;
                        }
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Assist in the creation of standardised User XML.
        /// Pass in the data to be represented in a standard way.
        /// </summary>
        /// <param name="userId">The user id to put in the XML</param>
        /// <param name="userName">The user Name</param>
        /// <param name="emailAddress">The user Email Address</param>
        /// <param name="firstNames">First Names</param>
        /// <param name="lastName">Last Name</param>
        /// <param name="status">Status of the User. -1 if they do not have a status</param>
        /// <param name="taxonomyNode">Their taxonomyNode</param>
        /// <param name="active">Whether they are active</param>
        /// <param name="zeitgeistScore">Their zeitgeist score if they have one</param>
        /// <param name="siteSuffix">The users site suffix</param>
        /// <param name="area">The users area</param>
        /// <param name="title">The users title for the site</param>
        /// <param name="journal">The id of the users journal</param>
        /// <param name="dateLastNotified">The date of the last notified</param>
        /// <param name="subQuota">The sub-editors allocation quota</param>
        /// <param name="allocations">The number of allocated articles</param>
        /// <param name="dateJoined">The date the user joined</param>
        /// <param name="forumID">Users forum ID</param>
        /// <param name="forumPostedTo">if the Users forum has been posted to</param>
        /// <param name="masthead">Users masthead</param>
        /// <param name="sinbin">if the user is sinbinned</param>
        /// <param name="identityUserId">Identity User ID to put in the XML</param>
        /// <returns>Xml Node set up with a uniform representation of User XML.</returns>
        
        public XmlNode GenerateUserXml(int userId, string userName, string emailAddress, string firstNames, string lastName, 
                                        int status, int taxonomyNode, bool active, double zeitgeistScore,
                                        string siteSuffix, string area, string title, int journal,
                                        DateTime dateLastNotified, int subQuota, int allocations, DateTime dateJoined,
                                        int forumID, int forumPostedTo, int masthead, int sinbin, string identityUserId)
        {

            Dictionary<string, object> userData = new Dictionary<string, object>();
            userData.Add("UserID", userId);
            userData.Add("IdentityUserId", identityUserId);
            userData.Add("UserName", userName);
            userData.Add("EMAIL-ADDRESS", emailAddress);
            userData.Add("Status", status);
            userData.Add("FirstNames", firstNames);
            userData.Add("LastName", lastName);

            // Rest go in the dictionary
            userData.Add("SiteSuffix", siteSuffix);
            //userData.Add("Area", area);
            //userData.Add("Title", title);
            userData.Add("TaxonomyNode", taxonomyNode);
            userData.Add("Journal", journal);
            userData.Add("Active", Convert.ToInt32(active));
            userData.Add("Score", zeitgeistScore);
            userData.Add("SUB-QUOTA", subQuota);
            userData.Add("ALLOCATIONS", allocations);

            //New items missing from user list port
            if (forumID != -1)
            {
                userData.Add("FORUMID", forumID);
            }
            if (forumPostedTo != -1)
            {
                userData.Add("FORUM-POSTED-TO", forumPostedTo);
            }
            if (masthead != -1)
            {
                userData.Add("MASTHEAD", masthead);
            }
            if (sinbin != -1)
            {
                userData.Add("SINBIN", sinbin);
            }

			// TODO: Need to escape strings, probably
            XmlNode userNode = CreateElementNode("USER");
            foreach (KeyValuePair<string, object> entry in userData)
            {
                /*if (entry.Key == "UserName")
                {
                    InputContext.Diagnostics.WriteToLog("User", "UserName - " + entry.Value.ToString());
                    AddElement(userNode, entry.Key.ToString(), entry.Value.ToString());
                }
                else
                {*/
                    AddTextTag(userNode, entry.Key.ToString(), entry.Value.ToString());
                //}
            }

            if (dateLastNotified != DateTime.MinValue)
            {
                XmlNode dateCreatedNode = AddElementTag(userNode, "DATE-LAST-NOTIFIED");
                dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateLastNotified, true));
                
            }

            if (dateJoined != DateTime.MinValue)
            {
                XmlNode dateCreatedNode = AddElementTag(userNode, "DATE-JOINED");
                dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateJoined, true));
                
            }
            
            string groupsXml = UserGroupsHelper.GetUserGroupsAsXml(userId, InputContext.CurrentSite.SiteID, InputContext);

            XmlDocument groups = new XmlDocument();
            groups.LoadXml(groupsXml);
            if (groups.HasChildNodes)
            {
                XmlNode importNode = ImportNode(groups.FirstChild);
                userNode.AppendChild(importNode);
            }

            return userNode;
        }

        /// <summary>
        /// Fills the User component with the User XML block from the internal Data
        /// </summary>
        /// <returns>True if sucessful or false</returns>
        private bool GenerateUserXml()
        {
            bool success = false;
            if (_gotUserData)
            {
                _userElementNode = CreateElementNode("USER");

                AddTextTag(_userElementNode,"USERID",_userID);
                //AddElement(_userElementNode, "USERNAME", _userName);
                AddTextTag(_userElementNode, "USERNAME", _userName);
                AddTextTag(_userElementNode, "FIRST-NAMES", _firstNames);
                AddTextTag(_userElementNode, "FIRSTNAMES", _firstNames);
                AddTextTag(_userElementNode, "LAST-NAME", _lastName);
                AddTextTag(_userElementNode, "LASTNAME", _lastName);
                AddTextTag(_userElementNode, "STATUS", Convert.ToInt32(_status));

                if (ShowFullDetails)
                {
                    AddTextTag(_userElementNode, "EMAIL-ADDRESS", _userEmail);
                    AddTextTag(_userElementNode, "LOGIN-NAME", _loginName);
                    AddTextTag(_userElementNode, "PASSWORD", _password);
                }

                foreach (KeyValuePair<string, object> entry in _userData)
                {
					string thisKey = entry.Key.ToLower();
                    AddTextTag(_userElementNode, entry.Key.ToString(), entry.Value.ToString());
                }

                XmlNode modStatus = AddElementTag(_userElementNode, "MODERATIONSTATUS");
                AddAttribute(modStatus, "ID", _prefStatus);
                AddAttribute(modStatus, "NAME", ModerationUserStatuses.GetDescription(_prefStatus));
                
                if (_gotUserGroupsData )
                {
                    _userGroupsElementNode = CreateElementNode("GROUPS");
                    foreach (string groupsEntry in _userGroupsData)
                    {
                        XmlNode userGroupElementNode;
                        userGroupElementNode = CreateElementNode("GROUP");
                        AddTextTag(userGroupElementNode, "NAME", groupsEntry.ToUpper());
                        _userGroupsElementNode.AppendChild(userGroupElementNode);
                    }
                    _userElementNode.AppendChild(_userGroupsElementNode);
                }

                // Check to see if we're want to see if they user needs to set their username. This is only done for
                // the viewing user hense the _userLoggedIn check.
                bool checkName = InputContext.GetSiteOptionValueBool("General", "CheckUserNameSet");
                if (_userLoggedIn && checkName)
                {
                    // Quickly check to see if the users nickname is set
                    if (!HasUserSetUserName())
                    {
                        // Add the prompt flag into the list of items to be put in the XML
                        AddIntElement(_userElementNode, "PROMPTSETUSERNAME", 1);
                    }
                }

                RootElement.AppendChild(_userElementNode);
                success = true;
            }

            if (InputContext.GetCurrentSignInObject.GetCookieValue.Length > 0 || LoginName.Length > 0)
            {
                if (InputContext.CurrentSite.UseIdentitySignInSystem)
                {
                    XmlNode identityXML = AddElementTag(RootElement, "IDENTITY");
                    XmlNode cookieNode = AddTextTag(identityXML, "COOKIE", "");
                    string cookie = InputContext.GetCurrentSignInObject.GetCookieValue;
                    AddAttribute(cookieNode, "PLAIN", cookie);
                    AddAttribute(cookieNode, "URLENCODED", InputContext.UrlEscape(cookie));
                }
                else
                {
                    XmlNode sso = AddElementTag(RootElement, "SSO");
                    AddTextTag(sso, "SSOLOGINNAME", LoginName);
                }

                AddTextTag(RootElement, "SIGNINNAME", LoginName);
            }

            return success;
        }

        /// <summary>
        /// Checks to see if the user has set their username. It also takes into account of the nickname moderation queue
        /// </summary>
        /// <returns>True if the username has been set or is in the moderation queue, fasle if not or failed moderation</returns>
        private bool HasUserSetUserName()
        {
            bool isSet = true;

            // First check their username for U#########
            string check = "U" + _userID.ToString();
            if (check.CompareTo(_userName) == 0)
            {
                // Ok, check to see if they are queued in the moderation system
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("isnicknameinmoderationqueue"))
                {
                    reader.AddParameter("UserID", _userID);
                    reader.Execute();

                    isSet = false;
                    if (reader.HasRows && reader.Read())
                    {
                        int status = reader.GetInt32("Status");
                        isSet = (status != 4);
                    }
                }
            }

            return isSet;
        }

        /// <summary>
        /// Method to get the User Data from the DB
        /// </summary>
        private bool GetUserData()
        {
            if (_userID != 0 && InputContext.CurrentSite.SiteID != 0)
            {
                string findUserFromID = "finduserfromid";
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(findUserFromID))
                {
                    dataReader.AddParameter("@userid", _userID)
                    .AddParameter("@h2g2id", DBNull.Value)
                    .AddParameter("@siteid", InputContext.CurrentSite.SiteID)
                    .Execute();
                    if (dataReader.HasRows)
                    {
                        _gotUserData = true;
                        if (dataReader.Read())
                        {
                            FillUserDataDictionary(dataReader);
                        }
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Method to get the Users Groups from the DB
        /// </summary>
        private void GetUserGroupsData()
        {
            if (_userID != 0 && InputContext.CurrentSite.SiteID != 0)
            {
                string findUsersGroups = "fetchusersgroups";
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(findUsersGroups))
                {
                    dataReader.AddParameter("@userid", UserID)
                    .AddParameter("@siteID", InputContext.CurrentSite.SiteID)
                    .Execute();
                    if (dataReader.HasRows)
                    {
                        _gotUserGroupsData = true;
                        FillUserGroupsDataDictionary(dataReader);
                    }
                }
            }
        }

        /// <summary>
        /// Fills the userData Dictionary with User DB data
        /// </summary>
        /// <param name="sp">Stored Procedure Data Reader object</param>
        /// <returns>True if sucessful or false</returns>
        private bool FillUserDataDictionary(IDnaDataReader sp)
        {
			// Set member variables that are useful as values
            _userID = sp.GetInt32NullAsZero("userid");
            _identityUserId = sp.GetStringNullAsEmpty("identityuserid");
            _status = (UserStatus)sp.GetInt32NullAsZero("Status");
			_userName = sp.GetStringNullAsEmpty("UserName");
			_firstNames = sp.GetStringNullAsEmpty("FirstNames");
            _lastName = sp.GetStringNullAsEmpty("LastName");
            _userEmail = sp.GetStringNullAsEmpty("Email");
			_password = sp.GetStringNullAsEmpty("Password");
         
			if (_loginName.Length == 0)
			{
				_loginName = sp.GetStringNullAsEmpty("LoginName");
			}
            _preferredSkin = sp.GetStringNullAsEmpty("PrefSkin");
			_masthead = sp.GetInt32NullAsZero("Masthead");
			_journalID = sp.GetInt32NullAsZero("Journal");
			_title = sp.GetStringNullAsEmpty("Title");
			_siteSuffix = sp.GetStringNullAsEmpty("SiteSuffix");
            _acceptSubscriptions = sp.GetBoolean("AcceptSubscriptions");
            _prefStatus = sp.GetInt32NullAsZero("PrefStatus");
            _teamID = sp.GetInt32NullAsZero("TeamID");
            _lastUpdated = DateTime.Now;
            _lastUpdated = sp.GetDateTime("LastUpdatedDate");

            bool success = false;
            if (_gotUserData)
            {
                //AddUserDataObject("UserID", sp);
                //AddUserDataObject("UserName", sp);
                AddUserDataObject("Postcode", sp);
                AddUserDataObject("Region", sp);
                AddUserDataObject("PrefUserMode", sp);
                //AddUserDataObject("Status", sp);
                AddUserDataObject("Area", sp);
                AddUserDataObject("Title", sp);
                //AddUserDataObject("FirstNames", sp);
                //AddUserDataObject("LastName", sp);
                AddUserDataObject("SiteSuffix", sp);
                AddUserDataObject("TeamID", sp);
                AddUserDataObject("UnreadPublicMessageCount", sp);
                AddUserDataObject("UnreadPrivateMessageCount", sp);
                AddUserDataObject("TaxonomyNode", sp);
                AddUserDataObject("HideLocation", sp);
                AddUserDataObject("HideUserName", sp);
                //AddUserDataObject("AcceptSubscriptions", sp);

                if (ShowFullDetails)
                {
                    AddUserDataObject("PrefXML", sp);
                    //AddUserDataObject("Email", sp);

                    //AddUserDataObject("LoginName", sp);
                    AddUserDataObject("BBCUID", sp);
                    AddUserDataObject("Cookie", sp);
                    //AddUserDataObject("Password", sp);
                    AddUserDataObject("Masthead", sp);
                    AddUserDataObject("Journal", sp);
                    AddUserDataObject("PrivateForum", sp);
                    AddUserDataObject("DateJoined", sp);
                    AddUserDataObject("DateReleased", sp);
                    AddUserDataObject("Active", sp);
                    AddUserDataObject("Anonymous", sp);

                    AddUserDataObject("SinBin", sp);
                    AddUserDataObject("Latitude", sp);
                    AddUserDataObject("Longitude", sp);
                    AddUserDataObject("PrefSkin", sp);

                    AddUserDataObject("IsModClassMember", sp);
                    AddUserDataObject("PrefForumStyle", sp);
                    AddUserDataObject("AgreedTerms", sp);
                    AddUserDataObject("PrefStatus", sp); 
                    AddUserDataObject("AutoSinBin", sp);
                }

                success = true;
            }
            return success;
        }

        /// <summary>
        /// Fills the userData Dictionary with Groups DB data
        /// </summary>
        /// <param name="sp">Stored Procedure Data Reader object</param>
        /// <returns></returns>
        private bool FillUserGroupsDataDictionary(IDnaDataReader sp)
        {
            bool success = false;
            if (_gotUserGroupsData)
            {
                while (sp.Read())
                {
                    _userGroupsData.Add(sp["Name"].ToString().ToLower());
                }
                success = true;
            }
            return success;
        }

        /// <summary>
        /// Helper function to fill the data dictionary with the data from the DB
        /// </summary>
        /// <param name="columnName">Name of the column to add</param>
        /// <param name="sp">Stored Procedure Data Reader object</param>
        private void AddUserDataObject(string columnName, IDnaDataReader sp)
        {
            if (sp[columnName] != null)
            {
                _userData.Add(columnName, sp[columnName]);
            }
            else
            {
                _userData.Add(columnName, "");
            }
        }

		/// <summary>
		/// Used when updating a user's record. Can only be called after calling BeginUpdateDetails
		/// </summary>
		/// <param name="userName"></param>
		public void SetUsername(string userName)
		{
			_userName = userName;
			UpdateField(userName, "@username", "USERNAME");
		}

        /// <summary>
        /// Updates a value within the user data dictionary
        /// </summary>
        /// <param name="name">name of variable</param>
        /// <param name="value">object value</param>
        /// <returns>True if add to update reader</returns>
        public bool SetUserData(string name, object value)
        {
            if (_userData.ContainsKey(name.ToUpper()))
                _userData[name.ToUpper()] = value;

            _updateReader.AddParameter("@" + name.ToLower(), value);
            return true;
        }

		private void UpdateField(string value, string pname, string xpath)
		{
			_updateReader.AddParameter(pname, value);
			XmlNodeList nodelist = _userElementNode.SelectNodes(xpath);
			foreach (XmlNode node in nodelist)
			{
                node.InnerText = StringUtils.EscapeAllXml(value);
			}
		}

		private void UpdateField(int value, string pname, string xpath)
		{
			_updateReader.AddParameter(pname, value);
			XmlNodeList nodelist = _userElementNode.SelectNodes(xpath);
			foreach (XmlNode node in nodelist)
			{
				node.InnerText = value.ToString();
			}
		}

		/// <summary>
		/// Set a new email address. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="email">New email address</param>
		public void SetEmail(string email)
		{
			_userEmail = email;
			UpdateField(email, "@email", "EMAIL-ADDRESS");
		}

        /// <summary>
        /// Sets the preferred skin value
        /// </summary>
        /// <param name="skin">Skin to set</param>
        public void SetPreferredSkinInDB(string skin)
        {
            _preferredSkin = skin;
            UpdateField(_preferredSkin, "@prefskin", "REFERENCES/SKIN");
        }

		
        /// <summary>
		/// Set a new FIRST NAMES field. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="firstNames">new first names</param>
		public void SetFirstNames(string firstNames)
		{
			_firstNames = firstNames;
			UpdateField(firstNames, "@firstnames", "FIRST-NAMES|FIRSTNAMES");
		}

		/// <summary>
		/// Set a new last name. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="lastName">new value of last name field</param>
		public void SetLastName(string lastName)
		{
			_lastName = lastName;
			UpdateField(lastName, "@lastname", "LAST-NAME|LASTNAME");
		}

		/// <summary>
		/// Set a new password field. Can be called only after BeginUpdateDetails. 
		/// Note that this password field is now redundant and does not reflect the SSO password.
		/// </summary>
		/// <param name="password">New password</param>
		public void SetPassword(string password)
		{
			_password = password;
			UpdateField(password, "@password", "PASSWORD");
		}

		/// <summary>
		/// Set a new user status. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="status">New status. 1 = ordinary user, 2 = superuser</param>
		public void SetStatus(int status)
		{
			_status = (UserStatus)status;
			UpdateField(status, "@status", "STATUS");
		}

		/// <summary>
		/// Set a new value for the Title field. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="title">New title</param>
		public void SetTitle(string title)
		{
			_title = title;
			UpdateField(title, "@title", "TITLE");
		}

        /// <summary>
        /// Gets the users title
        /// </summary>
        public string Title
        {
            get { return _title; }
        }

		/// <summary>
		/// Set a new SiteSuffix field. Can be called only after BeginUpdateDetails
		/// </summary>
		/// <param name="siteSuffix">New SiteSuffix</param>
		public void SetSiteSuffix(string siteSuffix)
		{
			_siteSuffix = siteSuffix;
			UpdateField(siteSuffix, "@sitesuffix", "SITESUFFIX");
		}

        /// <summary>
        /// Sets whether a user accepts subscriptions to their content
        /// </summary>
        /// <param name="acceptSubscriptions">New SiteSuffix</param>
        public void SetAcceptSubscriptions( bool acceptSubscriptions )
        {
            _acceptSubscriptions = acceptSubscriptions;
            UpdateField(Convert.ToInt32(acceptSubscriptions), "@acceptsubscriptions", "ACCEPTSUBSCRIPTIONS");
        }

		/// <summary>
		/// Call this method after calling BeginUpdateDetails and any of the Set methods.
		/// Will fail if you haven't called BeginUpdateDetails
		/// </summary>
		public bool UpdateDetails()
		{
			_updateReader.Execute();
			_updateReader.Close();
            _updateReader.Dispose();
			_updateReader = null;
			return true;
		}

		private IDnaDataReader _updateReader;

		/// <summary>
		/// Call this method before calling any of the Set methods in order to update fields for this user
		/// Once all necessary Set methods have been called, call UpdateDetails to execute the update
		/// </summary>
		public void BeginUpdateDetails()
		{
			_updateReader = InputContext.CreateDnaDataReader("updateuser2");
			_updateReader.AddParameter("@userid", _userID);
			_updateReader.AddParameter("@siteid", InputContext.CurrentSite.SiteID);
		}

		/// <summary>
		/// Clear the group membership details for this user
		/// </summary>
		public void ClearGroupMembership()
		{
			_userGroupsData.Clear();
			_userGroupsElementNode.RemoveAll();
		}

		/// <summary>
		/// Set this user to be a member of the specified group.
		/// Note that this does not update the database. Call UpdateUsersGroupMembership to update the
		/// data in the database.
		/// </summary>
		/// <param name="groupName">Name of group to which to add user</param>
		public void SetIsGroupMember(string groupName)
		{
			_userGroupsData.Add(groupName.ToLower());
			XmlNode newGroup = AddElementTag(_userGroupsElementNode, "GROUP");
			AddTextTag(newGroup, "NAME", groupName.ToUpper());
		}

		/// <summary>
		/// 
		/// </summary>
		public int Masthead
		{
			get
			{
				return _masthead;
			}
		}

		/// <summary>
		/// Update the groups of which this user is a member.
		/// </summary>
        /// <param name="userID">The id of the user you want to update</param>
        /// <param name="siteID">The id of the site you want to update the groups for</param>
        /// <param name="groups">The list of groups you want to add the user to</param>
		public void UpdateUsersGroupMembership(int userID, int siteID, List<string> groups)
		{
            // Make sure we're got a valid user
            if (userID > 0)
            {
                // first remove all the users current groups, then add all the one we wish them
                // to be members of
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("clearusersgroupmembership"))
                {
                    reader.AddParameter("@userid", userID);
                    reader.AddParameter("@siteid", siteID);
                    reader.Execute();
                }

                // check for errors
                // if all okay and list isn't empty then proceed
                if (_userGroupsData.Count > 0)
                {
                    // Add the user to the groups
                    AddUserToGroups(userID, siteID, new List<string>(groups));

                    // Sync the preferences for the user
                    using (IDnaDataReader reader = InputContext.CreateDnaDataReader("syncusergroupstopreferences"))
                    {
                        reader.AddParameter("@userid", userID);
                        reader.AddParameter("@siteid", siteID);
                        reader.Execute();
                    }
                }
            }
		}

        /// <summary>
        /// Adds the user to a list of groups for a specific site
        /// </summary>
        /// <param name="userID">The id of the user you want to update</param>
        /// <param name="siteID">The id of the site the groups belong to</param>
        /// <param name="groups">The list of groups you want to add the user to.</param>
        /// <remarks>Make sure you pass in a copy of the groups list, as this method will remove
        /// items from the list as it adds them to the database.</remarks>
        private void AddUserToGroups(int userID, int siteID, List<string> groups)
        {
            // now go through our list of groups, adding them in batches of ten
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addusertogroups"))
            {
                reader.AddParameter("@userid", userID);
                reader.AddParameter("@siteid", siteID);
                for (int i = 0; i < 10 && i < groups.Count; i++)
                {
                    // make sure group name is in upper case for XML output
                    reader.AddParameter("@groupname" + i, groups[0]);
                    groups.RemoveAt(0);
                }
                reader.Execute();
            }

            // Check to see if we've got any more to do
            if (groups.Count > 0)
            {
                // Call this function again
                AddUserToGroups(userID, siteID, groups);
            }
        }

		/// <summary>
		/// Get the sites of which this user is a editor or all if superuser.
		/// </summary>
        public XmlElement GetSitesThisUserIsEditorOfXML()
        {
            return UserGroupsHelper.GetSitesUserIsEditorOfXML(_userID, IsSuperUser, InputContext);
        }

        /// <summary>
        /// Creates and adds the returned User Xml block to a given parent post node from the passed user parameters
        /// </summary>
        /// <param name="dataReader">Data reader object</param>
        /// <param name="userID">The users id</param>
        /// <param name="parent">The parent Node to add the user xml to</param>
        /// <returns>XmlNode Containing user XML from the stored procedure</returns>
        public void AddUserXMLBlock(IDnaDataReader dataReader, int userID, XmlNode parent)
        {
            AddPrefixedUserXMLBlock(dataReader, userID, "", parent);
        }

        /// <summary>
        /// Is the user a member of the guardian group
        /// </summary>
        public bool IsGuardian
        {
            get { return _userGroupsData.Contains("tester"); }
        }

        /// <summary>
        /// Creates and adds the returned User Xml block to a given parent post node from the passed user parameters with a prefix
        /// ie the field name of OwnerUserName, OwnerFirstNames
        /// </summary>
        /// <param name="dataReader">Data reader object</param>
        /// <param name="userID">The users id</param>
        /// <param name="prefix">The prefix of the field names for a different user in the same result set</param>
        /// <param name="parent">The parent Node to add the user xml to</param>
        /// <returns>XmlNode Containing user XML from the stored procedure</returns>
        public void AddPrefixedUserXMLBlock(IDnaDataReader dataReader, int userID, string prefix, XmlNode parent)
        {
            string userName = "";
            if (dataReader.Exists(prefix + "UserName"))
            {
                userName = dataReader.GetStringNullAsEmpty(prefix + "UserName");
            }
            else if (dataReader.Exists(prefix + "Name"))
            {
                userName = dataReader.GetStringNullAsEmpty(prefix + "Name");
            }

            if (userName == String.Empty)
            {
                userName = "Member " + userID.ToString();
            }

            string identityUserId = "";
            if (dataReader.Exists(prefix + "identityUserId"))
            {
                identityUserId = dataReader.GetStringNullAsEmpty(prefix + "identityUserId");
            }

            string emailAddress = "";
            if (dataReader.Exists(prefix + "Email"))
            {
                emailAddress = dataReader.GetStringNullAsEmpty(prefix + "Email");
            }

            double zeigeistScore = 0.0;
            if (dataReader.DoesFieldExist(prefix + "ZeitgeistScore"))
            {
                zeigeistScore = dataReader.GetDoubleNullAsZero(prefix + "ZeitgeistScore");
            }

            string siteSuffix = "";
            if (dataReader.Exists(prefix + "SiteSuffix"))
            {
                siteSuffix = dataReader.GetStringNullAsEmpty(prefix + "SiteSuffix");
            }

            string area = "";
            if (dataReader.Exists(prefix + "Area"))
            {
                area = dataReader.GetStringNullAsEmpty(prefix + "Area");
            }

            string title = "";
            if (dataReader.Exists(prefix + "Title"))
            {
                title = dataReader.GetStringNullAsEmpty(prefix + "Title");
            }

            int subQuota = 0;
            if (dataReader.Exists(prefix + "SubQuota"))
            {
                subQuota = dataReader.GetInt32NullAsZero(prefix + "SubQuota");
            }

            int allocations = 0;
            if (dataReader.Exists(prefix + "Allocations"))
            {
                allocations = dataReader.GetInt32NullAsZero(prefix + "Allocations");
            }
            

            int journal = 0;
            if (dataReader.Exists(prefix + "Journal"))
            {
                journal = dataReader.GetInt32NullAsZero(prefix + "Journal");
            }

            bool isActive = false;
            if (dataReader.Exists(prefix + "Active") && !dataReader.IsDBNull(prefix + "Active"))
            {
                isActive = dataReader.GetBoolean(prefix + "Active");
            }

            DateTime dateLastNotified = DateTime.MinValue;
            if (dataReader.Exists(prefix + "DateLastNotified") && dataReader.GetValue(prefix + "DateLastNotified") != DBNull.Value)
            {
                dateLastNotified = dataReader.GetDateTime(prefix + "DateLastNotified");
            }

            DateTime dateJoined = DateTime.MinValue;
            if (dataReader.Exists(prefix + "DateJoined") && dataReader.GetValue(prefix + "DateJoined") != DBNull.Value)
            {
                dateJoined = dataReader.GetDateTime(prefix + "DateJoined");
            }
            int forumPostedTo = -1;
            if (dataReader.Exists(prefix + "ForumPostedTo"))
            {
                forumPostedTo = dataReader.GetInt32NullAsZero(prefix + "ForumPostedTo");
            }
            int masthead = -1;
            if (dataReader.Exists(prefix + "Masthead"))
            {
                masthead = dataReader.GetInt32NullAsZero(prefix + "Masthead");
            }
            int sinbin = -1;
            if (dataReader.Exists(prefix + "SinBin"))
            {
                sinbin = dataReader.GetInt32NullAsZero(prefix + "SinBin");
            }
            int forumID = -1;
            if (dataReader.Exists(prefix + "ForumID"))
            {
                forumID = dataReader.GetInt32NullAsZero(prefix + "ForumID");
            }

            XmlNode userXML = GenerateUserXml(userID,
                                                userName,
                                                emailAddress,
                                                dataReader.GetStringNullAsEmpty(prefix + "FirstNames"),
                                                dataReader.GetStringNullAsEmpty(prefix + "LastName"),
                                                dataReader.GetInt32NullAsZero(prefix + "Status"),
                                                dataReader.GetInt32NullAsZero(prefix + "TaxonomyNode"),
                                                isActive,
                                                zeigeistScore,
                                                siteSuffix,
                                                area,
                                                title,
                                                journal,
                                                dateLastNotified,
                                                subQuota, 
                                                allocations,
                                                dateJoined,
                                                forumID,
                                                forumPostedTo,
                                                masthead,
                                                sinbin,
                                                identityUserId);


            if (userXML != null)
            {
                XmlNode importxml = parent.OwnerDocument.ImportNode(userXML, true);
                parent.AppendChild(importxml);
            }
        }

        /// <summary>
        /// Checks to see if the current user has special edit permissions for the given article
        /// </summary>
        /// <param name="h2g2ID">Id of the article you what to check for</param>
        /// <returns>True if they have, false if not</returns>
        public bool HasSpecialEditPermissions(int h2g2ID)
        {
            if (IsEditor)
            {
                return true;
            }
            if (IsModerator && HasEntryLockedForModeration(h2g2ID))
            {
                return true;
            }
            return false;
        }

        private bool HasEntryLockedForModeration(int h2g2ID)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("checkuserhasentrylockedformoderation"))
            {
                reader.AddParameter("UserID", _userID);
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.Execute();

                bool hasEntryLocked = false;
                if (reader.Read())
                {
                    hasEntryLocked = reader.GetBoolean("IsLocked");
                }

                return hasEntryLocked;
            }
        }

		#region IUser Members

		/// <summary>
		/// True if the user is a member of one of the volunteer groups
		/// </summary>
		public bool IsVolunteer
		{
			get 
			{
				if (IsScout ||
					IsSubEditor ||
					_userGroupsData.Contains("aces") ||
					_userGroupsData.Contains("gurus") ||
					_userGroupsData.Contains("sectionheads") ||
					_userGroupsData.Contains("communityartists") ||
					_userGroupsData.Contains("guardian") ||
					_userGroupsData.Contains("bbctester")
					)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		#endregion

        /// <summary>
        /// Converts BBC.Dna.User to BBC.Dna.Objects.User
        /// A hack until user objects are unified.
        /// </summary>
        /// <returns></returns>
        public BBC.Dna.Objects.User ConvertUser()
        {
            BBC.Dna.Objects.User userObj = new BBC.Dna.Objects.User(AppContext.ReaderCreator, AppContext.TheAppContext.Diagnostics, AppContext.DnaCacheManager)
            {
                UserId = UserID,
                UserLoggedIn = UserLoggedIn,
                Status = IsSuperUser ? 2 : 0
            };

            userObj.Groups = new List<Group>();
            foreach (string group in _userGroupsData)
            {
                userObj.Groups.Add(new Group() { Name = group.ToUpper() });
            }
            return userObj;
        }
    }
}
