using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using NUnit.Extensions.Asp;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestUtils;

namespace Tests
{
    /// <summary>
    /// Helper class for requesting URLs
    /// </summary>
    public class DnaTestURLRequest : IDisposable
    {
        // Reference IIsInitialise to ensure test web site is created.
        private static IIsInitialise _iisInitialse = IIsInitialise.GetIIsInitialise();
        
        /// <summary>
        /// Constructor. Takes the name of the service that you are wanting to use.
        /// When this object is created, the default user is set to "ProfileAPITest" along with the correct password and cookie info.
        /// The default server will be your machine OR on ops-dna1 it will be dnadev.
        /// Proxy is defaulted to off, as is the editor authentication.
        /// There are some preset user profiles you can use, OR you can specifically set the username, password and cookie yourself.
        /// </summary>
        /// <param name="serviceName">The name of the service you want to use</param>
        public DnaTestURLRequest(string serviceName)
        {
            // Set the service
            _serviceName = serviceName.ToLower();
            
            _server = CurrentServer;
            
            _secureServer = SecureServerAddress;

            //SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Enum of the different types of users you can use to log into sso with
        /// </summary>
        public enum usertype
        {
            /// <summary>
            /// The normal user
            /// </summary>
            NORMALUSER,
            /// <summary>
            /// The Editor
            /// </summary>
            EDITOR,
            /// <summary>
            /// The superuser
            /// </summary>
            SUPERUSER,
            /// <summary>
            /// The profile api test user
            /// </summary>
            PROFILETEST,
            /// <summary>
            /// The moderator test user
            /// </summary>
            MODERATOR,
            /// <summary>
            /// The Premod test user
            /// </summary>
            PREMODUSER,
            /// <summary>
            /// The Notable test user
            /// </summary>
            NOTABLE,
            /// <summary>
            /// The test user for identity login
            /// </summary>
            IDENTITYTEST,
            /// <summary>
            /// Use the current values in the fields. Use this if you manually want to set
            /// username, password and cookie
            /// </summary>
            CURRENTSETTINGS
        }

        /// <summary>
        /// class fields
        /// </summary>
        private string _serviceName = "";
        private WebProxy _proxy = new WebProxy("http://www-cache.reith.bbc.co.uk:80");
        private bool _useProxyPassing = false;
        private bool _useEditorAuthentication = false;
        private string _userName = "ProfileAPITest";
        private string _password = "APITest";
        private string _cookie = "44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00";
        private int _userid = 1090498911;
        private int _identityuserid = 0;
        private string _server = "";
        private string _secureServer = "";
        private HttpWebResponse _response = null;
        private string _responseAsString = null;
        private XmlDocument _responseAsXML = null;

        private bool _assertWebFailure = true;
        private bool _lastRequestWasASPX = false;

        private static Host _hostRequest;

        private bool _useIdentity = false;

        List<Cookie> _cookieList = new List<Cookie>();

        private string _secureCookie = "44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00";

        /// <summary>
        /// The dispose method for cleaning up after ourselves
        /// </summary>
        public void Dispose()
        {
            _response.Close();
        }

        /// <summary>
        /// Helper function that sets the current user to be profile api test user
        /// </summary>
        public void SetCurrentUserProfileTest()
        {
            UserAccount user = TestUserAccounts.GetProfileAPITestUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a normal user
        /// </summary>
        public void SetCurrentUserNormal()
        {
            UserAccount user = TestUserAccounts.GetNormalUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a Editor
        /// </summary>
        public void SetCurrentUserEditor()
        {
            UserAccount user = TestUserAccounts.GetEditorUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a Superuser
        /// </summary>
        public void SetCurrentUserSuperUser()
        {
            UserAccount user = TestUserAccounts.GetSuperUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a Moderator
        /// </summary>
        public void SetCurrentUserModerator()
        {
            UserAccount user = TestUserAccounts.GetModeratorAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a premod user
        /// </summary>
        public void SetCurrentUserPreModUser()
        {
            UserAccount user = TestUserAccounts.GetPreModeratedUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that sets the current user to be a Notable user
        /// </summary>
        public void SetCurrentUserNotableUser()
        {
            UserAccount user = TestUserAccounts.GetNotableUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that reset the current user to be a not logged in user
        /// </summary>
        public void SetCurrentUserNotLoggedInUser()
        {
            UserAccount user = TestUserAccounts.GetNonLoggedInUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Helper function that reset the current user to be an identity user
        /// </summary>
        public void SetCurrentUserAsIdentityTestUser()
        {
            UserAccount user = TestUserAccounts.GetNormalIdentityUserAccount;
            _userName = user.UserName;
            _password = user.Password;
            _cookie = user.Cookie;
            _secureCookie = user.SecureCookie;
            _userid = user.UserID;
            _useIdentity = user.UsesIdentity;
        }

        /// <summary>
        /// Sets the current user with the given details
        /// </summary>
        /// <param name="userName">The username for the user</param>
        /// <param name="password">The users password</param>
        /// <param name="dnaUserID">The users DNAUserID</param>
        /// <param name="cookie">The users SSO or Identity cookie</param>
        /// <param name="useIdentity">A flag to state whether or not to use the identity sign in system. Make sure the cookie value is correct for this flag!</param>
        public void SetCurrentUserAs(string userName, string password, int dnaUserID, string cookie, bool useIdentity)
        {
            _userName = userName;
            _password = password;
            _cookie = cookie;
            _userid = dnaUserID;
            _useIdentity = useIdentity;
        }

        /// <summary>
        /// Creates and then sets the current user to a new identity user account.
        /// </summary>
        /// <param name="userName">The username for the new account</param>
        /// <param name="password">The password for the new account</param>
        /// <param name="displayname">The display name for the new account</param>
        /// <param name="email">The email address for the account</param>
        /// <param name="dateOfBirth">The date of birth for the user. Format "1989-12-31"</param>
        /// <param name="policy">The policy you want to create the account under</param>
        /// <param name="sitename">The site that you want to create them in</param>
        /// <param name="userType">The type of user you want to create</param>
        /// <returns>True if the user was created correctly, false if not</returns>
        public bool SetCurrentUserAsNewIdentityUser(string userName, string password, string displayname,
                                                    string email, string dateOfBirth,
                                                    TestUserCreator.IdentityPolicies policy,
                                                    string sitename, TestUserCreator.UserType userType)
        {
            int siteid = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID FROM dbo.Sites WHERE UrlName='" + sitename + "'");
                if (!reader.HasRows || !reader.Read())
                {
                    return false;
                }
                siteid = reader.GetInt32NullAsZero("siteid");
            }

            return siteid > 0 && SetCurrentUserAsNewIdentityUser(userName, password, displayname, email, dateOfBirth, policy, siteid, userType);
        }

        /// <summary>
        /// Creates and then sets the current user to a new identity user account.
        /// </summary>
        /// <param name="userName">The username for the new account</param>
        /// <param name="password">The password for the new account</param>
        /// <param name="displayname">The display name for the new account</param>
        /// <param name="email">The email address for the account</param>
        /// <param name="dateOfBirth">The date of birth for the user. Format "1989-12-31"</param>
        /// <param name="policy">The policy you want to create the account under</param>
        /// <param name="siteid">The site that you want to create them in</param>
        /// <param name="userType">The type of user you want to create</param>
        /// <returns>True if the user was created correctly, false if not</returns>
        public bool SetCurrentUserAsNewIdentityUser(string userName, string password, string displayname,
                                                    string email, string dateOfBirth,
                                                    TestUserCreator.IdentityPolicies policy,
                                                    int siteid, TestUserCreator.UserType userType)
        {
            // Set the identity glag to true. Obvious if we're wanting to create identity users
            _useIdentity = true;

            Cookie cookie;
            Cookie secureCookie;
            if (userType == TestUserCreator.UserType.Normal)
            {
                if (!TestUserCreator.CreateNewIdentityNormalUser(userName, password, dateOfBirth, email, displayname, true, policy, true, out cookie, out secureCookie, out _identityuserid, out _userid))
                {
                    return false;
                }
            }
            else if (userType == TestUserCreator.UserType.Editor)
            {
                if (!TestUserCreator.CreateNewIdentityEditorUser(userName, password, dateOfBirth, email, displayname, siteid, policy, out cookie, out secureCookie, out _identityuserid, out _userid))
                {
                    return false;
                }
            }
            else if (userType == TestUserCreator.UserType.SuperUser)
            {
                if (!TestUserCreator.CreateNewIdentitySuperUser(userName, password, dateOfBirth, email, displayname, policy, out cookie, out secureCookie, out _identityuserid, out _userid))
                {
                    return false;
                }
            }
            else if (userType == TestUserCreator.UserType.Moderator)
            {
                if (!TestUserCreator.CreateNewIdentityModeratorUser(userName, password, dateOfBirth, email, displayname, siteid, policy, out cookie, out secureCookie, out _identityuserid, out _userid))
                {
                    return false;
                }
            }
            else if (userType == TestUserCreator.UserType.Notable)
            {
                if (!TestUserCreator.CreateNewIdentityNotableUser(userName, password, dateOfBirth, email, displayname, siteid, policy, out cookie, out secureCookie, out _identityuserid, out _userid))
                {
                    return false;
                }
            }
            else if (userType == TestUserCreator.UserType.IdentityOnly)
            {
                if (!TestUserCreator.CreateIdentityUser(userName, password, dateOfBirth, email, displayname, true, policy, true, 0, out cookie, out secureCookie, out _identityuserid))
                {
                    return false;
                }
            }
            else
            {
                return false;
            }

            _cookie = cookie.Value;
            _secureCookie = secureCookie.Value;
            _userName = userName;
            _password = password;
            _useIdentity = true;

            return true;
        }

        /// <summary>
        /// Helper function that sets the current user to be a banned user
        /// </summary>
        public void SetCurrentUserBanned()
        {
            _userName = "DotNetUserBanned";
            _password = "asdfasdf";
            _cookie = HttpUtility.UrlEncode("542926f3b88d86c2b085062a01251fbbcfe1206a58b330fba197aeed9672415b00");
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getdnauseridfromssouserid"))
            {
                reader.AddParameter("@ssouserid", 1166868343);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    _userid = (int)reader["DNAUserID"];
                }
            }
        }

        /// <summary>
        /// Current service name property
        /// </summary>
        public string Currentservice
        {
            get { return _serviceName; }
            set { _serviceName = value.ToLower(); }
        }

        /// <summary>
        /// Current web proxy property
        /// </summary>
        public WebProxy CurrentWebProxy
        {
            get { return _proxy; }
            set { _proxy = value; }
        }

        /// <summary>
        /// Property for turning on or off proxy passing
        /// </summary>
        public bool UseProxyPassing
        {
            get { return _useProxyPassing; }
            set { _useProxyPassing = value; }
        }

        /// <summary>
        /// Property for checking and setting if we want to authenticate the request as an editor
        /// </summary>
        public bool UseEditorAuthentication
        {
            get { return _useEditorAuthentication; }
            set { _useEditorAuthentication = value; }
        }

        /// <summary>
        /// Current user property
        /// </summary>
        public string CurrentUserName
        {
            get { return _userName; }
            set { _userName = value; }
        }

        /// <summary>
        /// Current password property
        /// </summary>
        public string CurrentPassword
        {
            get { return _password; }
            set { _password = value; }
        }

        /// <summary>
        /// Current cookie property
        /// </summary>
        public string CurrentCookie
        {
            get { return _cookie; }
            set { _cookie = HttpUtility.UrlEncode(value); }
        }

        /// <summary>
        /// Current secure cookie property
        /// </summary>
        public string CurrentSecureCookie
        {
            get { return _secureCookie; }
            set { _secureCookie = HttpUtility.UrlEncode(value); }
        }

        /// <summary>
        /// Current User ID property
        /// </summary>
        public int CurrentUserID
        {
            get { return _userid; }
        }

        /// <summary>
        /// Current Identity User ID property
        /// </summary>
        public int CurrentIdentityUserID
        {
            get { return _identityuserid; }
        }

        /// <summary>
        /// Set which signin system to use. True uses identity, false uses profileAPI
        /// </summary>
        public bool UseIdentitySignIn
        {
            get { return _useIdentity; }
            set { _useIdentity = value; }
        }

        /// <summary>
        /// Current Web Responce property
        /// </summary>
        public HttpWebResponse CurrentWebResponse
        {
            get { return _response; }
        }

        /// <summary>
        /// Propert on whether to automaticall asset web failure
        /// </summary>
        public bool AssertWebRequestFailure
        {
            get 
            { 
                return _assertWebFailure; 
            }
            set 
            {
                _assertWebFailure = value; 
            }
        }

        /// <summary>
        /// Adds the given cookie to the request
        /// </summary>
        /// <param name="cookie">The cookie you want to add</param>
        public void AddCookie(Cookie cookie)
        {
            _cookieList.Add(cookie);
        }

        /// <summary>
        /// Current server property
        /// </summary>
        public static string CurrentServer
        {
            get
            {
                if(!string.IsNullOrEmpty(ConfigurationManager.AppSettings["testServer"]))
                {//overridden in app.config
                    return ConfigurationManager.AppSettings["testServer"];
                }
                if (Environment.MachineName.ToLower() == "ops-dna1")
                {
                    // We've on ops-dev1! make the server name dnadev!
                    return "dnadev.national.core.bbc.co.uk:8081";
                }
                else
                {
                    // Just make the server the machine name plus the rest
                    return "local.bbc.co.uk:8081";
                }
            }
        }
        /// <summary>
        /// Current SecureServerAddress
        /// </summary>
        public static string SecureServerAddress
        {
            get
            {
                if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["testServer"]))
                {//overridden in app.config
                    return ConfigurationManager.AppSettings["testServer"];
                }
                if (Environment.MachineName.ToLower() == "ops-dna1")
                {
                    // We've on ops-dev1! make the server name dnadev!
                    return "dnadev.national.core.bbc.co.uk";
                }
                else
                {
                    // Just make the server the machine name plus the rest
                    return "local.bbc.co.uk:443";
                }
            }
        }

        /// <summary>
        /// The method can be used for NUnitAsp testing of WebForms.
        /// It uses the NUnitASP browser to request pages.
        /// </summary>
        /// <param name="relativePath">Allow the relative path to be specified.</param>
        /// <param name="Browser">NUnitASP Browser object</param>
        public void RequestNUnitASPPage(string relativePath, HttpClient Browser )
        {
            string server;

            //local.bbc.co.uk could not be resolved by Browser.GetPage() - not sure why.
            server = _server;
            server = server.Replace("local.bbc.co.uk", "localhost");

            //Specifying the actual aspx page can be important so that NUNitASP click events are processed correctly.
            Uri URL = new Uri("http://" + server + relativePath );

            //Set editor credentials
            if (_useEditorAuthentication)
            {
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);

                Browser.Credentials = MyCrendentialCache;
            }

            if (_cookie.Length >= 66)
            {
                Console.WriteLine("Adding cookie: " + _cookie);

                // Create and add the cookie to the request
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", server);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", server);
                }
                
                Browser.Cookies.Add(cookie);
            }

            foreach (Cookie cookie in _cookieList)
            {
                Browser.Cookies.Add(cookie);
            }

            // Check to see if we require a proxy for the request
			if (_useProxyPassing)
			{
                Console.WriteLine("Using proxy");
                // Set the proxy
				Browser.Proxy = _proxy;
			}
			else
			{
				Browser.Proxy = null;
			}

            Console.WriteLine("NunitASP Browser getting page :" + URL.AbsoluteUri);
            Browser.GetPage(URL.AbsoluteUri);

        }

        /// <summary>
        /// Used to request aspx pages
        /// </summary>
        /// <param name="page">The aspx page you want to request</param>
        /// <param name="pageParams">The params the page is to take</param>
        public void RequestAspxPage(string page, string pageParams)
        {
            // Make sure that we clear the last response objects
            _responseAsString = null;
            _responseAsXML = null;

            //Require a copy of RipleyServer config as we are going to host ASP.NET in dnapages dir.
            //Will only be copied on first call.
            TestConfig.GetConfig().CopyRipleyServerConfig();

            // Check to see if we've got a host already setup
            //if (_hostRequest == null)
            //{
                // Use dnapages directory as physical dir.
                //string dnapagesdir = System.Environment.GetEnvironmentVariable("dnapages");
                _hostRequest = Host.Create(TestConfig.GetConfig().GetDnaPagesDir());
            //}

            // Check to see if the query contains the site
            if (!pageParams.Contains("_si="))
            {
                // Add the site name to the query
                pageParams += "&_si=" + _serviceName;
            }

            // See if we need to put the path to the skins in
            if (!pageParams.Contains("d_skinfile="))
            {
                string skinPath = System.Environment.GetEnvironmentVariable("RipleyServerPath");
                skinPath += @"\skins\" + _serviceName + @"\HTMLOutput.xsl";
                pageParams += "&d_skinfile=" + skinPath;
            }

            // Now call the request
            _hostRequest.ProcessRequest(page, pageParams, "SSO2-UID=" + _cookie);

            // State that the last request was for an aspx page
            _lastRequestWasASPX = true;
        }

       /// <summary>
        /// This function is used to send the request
        /// </summary>
        /// <param name="pageAndParams">The dna page that you want to call and the associated params</param>
        /// <returns>The HTTP response object to the request</returns>
        public void RequestPage(string pageAndParams)
        {
            RequestSecurePage(pageAndParams, false);
        }

        /// <summary>
        /// This function is used to send the request
        /// </summary>
        /// <param name="pageAndParams">The dna page that you want to call and the associated params</param>
        /// <returns>The HTTP response object to the request</returns>
        public void RequestSecurePage(string pageAndParams, bool secure)
        {
            // Make sure that we clear the last response objects
            _responseAsString = null;
            _responseAsXML = null;

            // Create the URL and the Request object
            Uri URL;
            if (secure)
            {
                URL = new Uri("https://" + _secureServer + "/dna/" + _serviceName + "/" + pageAndParams);
                //URL = new Uri("http://" + _server + "/dna/" + _serviceName + "/" + pageAndParams);
            }
            else
            {
                URL = new Uri("http://" + _server + "/dna/" + _serviceName + "/" + pageAndParams);
            }
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Timeout = 400000;

            Console.WriteLine("Requesting "+URL.ToString());

            // Check to see if we require a proxy for the request
			if (_useProxyPassing)
			{
                Console.WriteLine("Using proxy");
                // Set the proxy
				webRequest.Proxy = _proxy;
			}
			else
			{
				webRequest.Proxy = null;
			}

            // Check to see if we need to authenticate the request as an editor
            if (_useEditorAuthentication)
            {
                Console.WriteLine("_useEditorAuthentication = true");
                webRequest.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                webRequest.Credentials = MyCrendentialCache;
            }

            // Check to see if we need to add a cookie
            webRequest.CookieContainer = new CookieContainer();
            if (_cookie.Length >= 66)
            {
                // Create and add the cookie to the request
                webRequest.CookieContainer = new CookieContainer();
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", _server);
                    webRequest.CookieContainer.Add(cookie);
                    if (secure)
                    {
                        cookie = new Cookie("IDENTITY-HTTPS", _secureCookie, "/", _server);
                        webRequest.CookieContainer.Add(cookie);
                    }
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", _server);
                    webRequest.CookieContainer.Add(cookie);
                }
            }

            foreach (Cookie cookie in _cookieList)
            {
                if (cookie != null)
                {
                    Console.WriteLine("Adding cookie - " + cookie.Name + " : " + cookie.Value);
                    webRequest.CookieContainer.Add(new Uri("http://" + _server + "/"), cookie);
                }
            }

            try
            {
                // Try to send the request and get the response
                Console.Write("Requesting page ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (Exception ex)
            {
                if (_assertWebFailure)
                {
                    // Problems!
                    Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
					_response = null;
					return; // null;
                }
                else
                {
                    throw new Exception("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message, ex);
                }
            }

			// Capture the string response always

            // State that the last request was not for an aspx page
            _lastRequestWasASPX = false;

			GetLastResponseAsString();
            // Return the response object
			return; // _response;
        }

        /// <summary>
        /// This function is used to send the request
        /// </summary>
        /// <param name="pageAndParams">The dna page that you want to call and the associated params</param>
        /// <returns>The HTTP response object to the request</returns>
        public void RequestPageWithFullURL(string fullUrl)
        {
            RequestPageWithFullURL(fullUrl, string.Empty, string.Empty, String.Empty);
        }

        public void RequestPageWithFullURL(string fullUrl, string postData, string postDataType)
        {
            RequestPageWithFullURL(fullUrl, postData, postDataType, String.Empty);
        }

        public void RequestPageWithFullURL(string fullUrl, string postData, string postDataType, string method)
        {
            RequestPageWithFullURL(fullUrl, postData, postDataType, method, null);
            
        }

        /// <summary>
        /// This function is used to send the request
        /// </summary>
        /// <param name="fullUrl">The full url to call</param>
        /// <param name="postData">The data to post</param>
        /// <returns>The HTTP response object to the request</returns>
        public void RequestPageWithFullURL(string fullUrl, string postData, string postDataType, string method, NameValueCollection headers)
        {
            // Make sure that we clear the last response objects
            _responseAsString = null;
            _responseAsXML = null;

            // Create the URL and the Request object
            Uri URL = new Uri(fullUrl);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Timeout = 400000;
            webRequest.AllowAutoRedirect = false;
            if (!String.IsNullOrEmpty(postDataType))
            {
                webRequest.ContentType = postDataType;
            }

            Console.WriteLine("Requesting " + URL.ToString());

            // Check to see if we require a proxy for the request
            if (_useProxyPassing)
            {
                Console.WriteLine("Using proxy");
                // Set the proxy
                webRequest.Proxy = _proxy;
            }
            else
            {
                webRequest.Proxy = null;
            }

            // Check to see if we need to authenticate the request as an editor
            if (_useEditorAuthentication)
            {
                Console.WriteLine("_useEditorAuthentication = true");
                webRequest.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                webRequest.Credentials = MyCrendentialCache;
            }

            // Check to see if we need to add a cookie
            if (_cookie.Length >= 66)
            {
                Console.WriteLine("Adding cookie: " + _cookie);

                // Create and add the cookie to the request
                webRequest.CookieContainer = new CookieContainer();
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", _server);
                    webRequest.CookieContainer.Add(cookie);
                    cookie = new Cookie("IDENTITY-HTTPS", _secureCookie, "/", _server);
                    webRequest.CookieContainer.Add(cookie);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", _server);
                    webRequest.CookieContainer.Add(cookie);
                }
            }

            foreach (Cookie cookie in _cookieList)
            {
                if (cookie != null)
                {
                    webRequest.CookieContainer.Add(new Uri("http://" + _server + "/"), cookie);
                }
            }

            //add custom headers
            if (headers != null && headers.Count > 0)
            {
                foreach (string key in headers.AllKeys)
                {
                    switch (key.ToUpper())
                    {
                        case "REFERER": webRequest.Referer = headers[key]; break;
                    }
                }

            }

            // Set Method if speciified eg PUT / POST / DELETE
            if (!String.IsNullOrEmpty(method))
            {
                webRequest.Method = method;
            }

            //add post data
            if (!String.IsNullOrEmpty(postData))
            {
                var encoding = new UTF8Encoding();
                byte[] data = encoding.GetBytes(postData);
                if (webRequest.Method == "GET")
                {
                webRequest.Method = "POST";
                }
                
                webRequest.ContentLength = data.Length;
	            Stream newStream=webRequest.GetRequestStream();
	            // Send the data.
                newStream.Write(data, 0, data.Length);
	            newStream.Close();
            }
            else
            {
                webRequest.ContentLength = 0;
            }

            try
            {
                // Try to send the request and get the response
                Console.Write("Requesting page ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (WebException ex)
            {
                // Problems!
                _response = (HttpWebResponse)ex.Response;
                Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
                
            }
            
            GetLastResponseAsString();

            // Return the response object
            return; // _response;
        }

        /// <summary>
        /// This function is used to send the request
        /// </summary>
        /// <param name="page">The dna page that you want to call and the associated params</param>
        /// <param name="postparams">Collection of params for a post request.</param>
        /// <returns>The HTTP response object to the request</returns>
        public void RequestPage(string page, Queue<KeyValuePair<string,string> > postparams )
        {
            // Make sure that we clear the last response objects
            _responseAsString = null;
            _responseAsXML = null;

            // Create the URL and the Request object
            Uri URL = new Uri("http://" + _server + "/dna/" + _serviceName + "/" + page);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Method = "POST";
            webRequest.ContentType = "application/x-www-form-urlencoded";
            webRequest.Timeout = 400000;

            // Check to see if we require a proxy for the request
            if (_useProxyPassing)
            {
                // Set the proxy
                webRequest.Proxy = _proxy;
            }
            else
            {
                webRequest.Proxy = null;
            }

            // Check to see if we need to authenticate the request as an editor
            if (_useEditorAuthentication)
            {
                webRequest.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                webRequest.Credentials = MyCrendentialCache;
            }

            // Check to see if we need to add a cookie
            if (_cookie.Length >= 66)
            {
                // Create and add the cookie to the request
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", _server);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", _server);
                }
                webRequest.CookieContainer = new CookieContainer();
                webRequest.CookieContainer.Add(cookie);
            }

            foreach (Cookie cookie in _cookieList)
            {
                webRequest.CookieContainer.Add(cookie);
            }

            // Create test data
            StringBuilder data = new StringBuilder();
            foreach( KeyValuePair<string, string> kvp in postparams )
            {
                data.Append("&" + kvp.Key  + "=" + kvp.Value );
            }

            // Create a byte array of the data we want to send   
            byte[] byteData = UTF8Encoding.UTF8.GetBytes(data.ToString());

            // Set the content length in the request headers   
            webRequest.ContentLength = byteData.Length;

            // Write data   
            using (Stream postStream = webRequest.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }   

            try
            {
                // Try to send the request and get the response
                Console.Write("Requesting page ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (Exception ex)
            {
                // Problems!
                Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
				_response = null;
                return;
            }

            // State that the last request was not for an aspx page
            _lastRequestWasASPX = false;

			GetLastResponseAsString();
            // Return the response object
            return;
        }

        /// <summary>
        /// Uploads a file simulating a multipart/form-data encoded request.
        /// Based on http://www.codeproject.com/csharp/uploadfileex.asp
        /// </summary>
        public HttpWebResponse UploadFileEx(string uploadfile, string page, string contenttype, Queue< KeyValuePair<string,string> > queryparams, CookieContainer cookies)
        {
            // Make sure that we clear the last response objects
            _responseAsString = null;
            _responseAsXML = null;

            string postdata = "?";
            if (queryparams != null)
            {
                foreach (KeyValuePair<string, string> kvp in queryparams)
                {
                    postdata += kvp.Key + "=" + kvp.Value + "&";
                }
            }

            // Create the URL and the Request object
            Uri URL = new Uri("http://" + _server + "/dna/" + _serviceName + "/" + page);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL+postdata);

            // Check to see if we require a proxy for the request
            if (_useProxyPassing)
            {
                // Set the proxy
                webRequest.Proxy = _proxy;
            }
            else
            {
                webRequest.Proxy = null;
            }

            // Check to see if we need to authenticate the request as an editor
            if (_useEditorAuthentication)
            {
                webRequest.PreAuthenticate = true;
                NetworkCredential myCred = new NetworkCredential("editor", "editor");
                CredentialCache MyCrendentialCache = new CredentialCache();
                MyCrendentialCache.Add(URL, "Basic", myCred);
                webRequest.Credentials = MyCrendentialCache;
            }

            // Check to see if we need to add a cookie
            if (_cookie.Length >= 66)
            {
                // Create and add the cookie to the request
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", _server);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", _server);
                }
                webRequest.CookieContainer = new CookieContainer();
                webRequest.CookieContainer.Add(cookie);
            }

            foreach (Cookie cookie in _cookieList)
            {
                webRequest.CookieContainer.Add(cookie);
            }

            string boundary = "----------" + DateTime.Now.Ticks.ToString("x");
            webRequest.ContentType = "multipart/form-data; boundary=" + boundary;
            webRequest.Method = "POST";

            // Build up the post message header
            StringBuilder sb = new StringBuilder();
            sb.Append("--");
            sb.Append(boundary);
            sb.Append("\r\n");
            sb.Append("Content-Disposition: form-data; name=\"");
            sb.Append("fileupload");
            sb.Append("\"; filename=\"");
            sb.Append(Path.GetFileName(uploadfile));
            sb.Append("\"");
            sb.Append("\r\n");
            sb.Append("Content-Type: ");
            sb.Append(contenttype);
            sb.Append("\r\n");
            sb.Append("\r\n");

            string postHeader = sb.ToString();
            byte[] postHeaderBytes = Encoding.UTF8.GetBytes(postHeader);

            // Build the trailing boundary string as a byte array
            // ensuring the boundary appears on a line by itself
            byte[] boundaryBytes =
                   Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

            using (FileStream fileStream = new FileStream(uploadfile, FileMode.Open, FileAccess.Read))
            {
                long length = postHeaderBytes.Length + fileStream.Length +
                                                       boundaryBytes.Length;
                webRequest.ContentLength = length;

                Stream requestStream = webRequest.GetRequestStream();

                // Write out our post header
                requestStream.Write(postHeaderBytes, 0, postHeaderBytes.Length);

                // Write out the file contents
                byte[] buffer = new Byte[1024];
                int bytesRead = 0;
                while ((bytesRead = fileStream.Read(buffer, 0, buffer.Length)) > 0 && bytesRead > 0)
                {
                    requestStream.Write(buffer, 0, bytesRead);
                }

                // Write out the trailing boundary
                requestStream.Write(boundaryBytes, 0, boundaryBytes.Length);
            }           

            try
            {
                // Try to send the request and get the response
                Console.Write("Uploading file ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (Exception ex)
            {
                if (_assertWebFailure)
                {
                    // Problems!
                    Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
                    return null;
                }
                else
                {
                    throw new Exception("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message, ex);
                }
            }

            // State that the last request was not for an aspx page
            _lastRequestWasASPX = false;

            GetLastResponseAsString();

            // Return the response object
            return _response;
        }

        /// <summary>
        /// Logs the current user in SSO via the profile api
        /// </summary>
        /// <param name="userType">The type of user you want to log in as.</param>
        public void SignUserIntoSSOViaProfileAPI(usertype userType)
        {
            // Check to see what type of user we are wanting to sign in as
            Console.WriteLine("SignUserIntoSSOViaProfileAPI");
            if (userType == usertype.NORMALUSER)
            {
                // Set the user to be the normal user
                SetCurrentUserNormal();
            }
            else if (userType == usertype.EDITOR)
            {
                // Set the user to be the editor
                SetCurrentUserEditor();
            }
            else if (userType == usertype.SUPERUSER)
            {
                // Set the user to be the super user
                SetCurrentUserSuperUser();
            }
            else if (userType == usertype.PROFILETEST)
            {
                // Set the user to be the profile test user
                SetCurrentUserProfileTest();
            }
            else if (userType == usertype.MODERATOR)
            {
                // Set the user to be the moderator test user
                SetCurrentUserModerator();
            }
            else if (userType == usertype.PREMODUSER)
            {
                // Set the user to be the premod test user
                SetCurrentUserPreModUser();
            }
            else if (userType == usertype.NOTABLE)
            {
                // Set the user to be the notable test user
                SetCurrentUserNotableUser();
            }
            else if (userType == usertype.IDENTITYTEST)
            {
                // Set the user to be the notable test user
                SetCurrentUserAsIdentityTestUser();
            }

            // Create the profile api obejct
            using (FullInputContext inputContext = new FullInputContext(_useIdentity))
            {
                inputContext.GetCurrentSignInObject.SetService(_serviceName);
                inputContext.GetCurrentSignInObject.TrySetUserViaCookie(_cookie);
            }
        }

        /// <summary>
        /// Logs the current user in via the SSO web service
        /// </summary>
        /// <returns></returns>
        public HttpWebResponse SignUserIntoSSOViaWebRequest(usertype userType)
        {
            // Check to see what type of user we are wanting to sign in as
            Console.WriteLine("SignUserIntoSSOViaWebRequest");
            if (userType == usertype.NORMALUSER)
            {
                // Set the user to be the normal user
                SetCurrentUserNormal();
            }
            else if (userType == usertype.EDITOR)
            {
                // Set the user to be the editor
                SetCurrentUserEditor();
            }
            else if (userType == usertype.SUPERUSER)
            {
                // Set the user to be the super user
                SetCurrentUserSuperUser();
            }
            else if (userType == usertype.PROFILETEST)
            {
                // Set the user to be the profile test user
                SetCurrentUserProfileTest();
            }
            else if (userType == usertype.MODERATOR)
            {
                // Set the user to be the moderator test user
                SetCurrentUserModerator();
            }
            else if (userType == usertype.PREMODUSER)
            {
                // Set the user to be the premod test user
                SetCurrentUserPreModUser();
            }
            else if (userType == usertype.NOTABLE)
            {
                // Set the user to be the notable test user
                SetCurrentUserNotableUser();
            }
            else if (userType == usertype.IDENTITYTEST)
            {
                // Set the user to be the notable test user
                SetCurrentUserAsIdentityTestUser();
            }

            // Set the url with the requested service anme and user details
            Uri URL = new Uri("http://ops-dev14.national.core.bbc.co.uk/cgi-perl/signon/mainscript.pl?service=" + _serviceName + "&c_login=login&username=" + _userName + "&password=" + _password);
            WebRequest webRequest = HttpWebRequest.Create(URL);
            webRequest.Proxy = _proxy;
            webRequest.Timeout = 400000;
            try
            {
                // Try to send the request and get the response
                Console.Write("Signing in user ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (Exception ex)
            {
                // Problems!
                Console.WriteLine(" failed!");
                Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
                _response = null;
            }

            GetLastResponseAsString();

            return _response;
        }
        
        /// <summary>
        /// This function is used to sign out a given user.
        /// You need to set the current user and password before calling this function. The default is to use the profile api test user
        /// </summary>
        /// <returns>The HTTP response to the request</returns>
        public HttpWebResponse SignOutUserFromSSO()
        {
            // Set the url with the requested service anme and user details
            Uri URL = new Uri("http://ops-dev14.national.core.bbc.co.uk/cgi-perl/signon/mainscript.pl?service=" + _serviceName + "&c=signout");
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            webRequest.Proxy = _proxy;
            webRequest.Timeout = 400000;
            if (_cookie.Length >= 66)
            {
                // Create and add the cookie to the request
                Cookie cookie;
                if (_useIdentity)
                {
                    cookie = new Cookie("IDENTITY", _cookie, "/", _server);
                }
                else
                {
                    cookie = new Cookie("SSO2-UID", _cookie, "/", _server);
                }
                webRequest.CookieContainer = new CookieContainer();
                webRequest.CookieContainer.Add(cookie);

                foreach (Cookie cookies in _cookieList)
                {
                    webRequest.CookieContainer.Add(cookies);
                }
            }
            try
            {
                // Try to send the request and get the response
                Console.Write("Signing out user ->");
                _response = (HttpWebResponse)webRequest.GetResponse();
                Console.WriteLine(" done");
            }
            catch (Exception ex)
            {
                // Problems!
                Console.WriteLine(" failed!");
                Assert.Fail("Web request ( " + webRequest.RequestUri + " ) failed with error : " + ex.Message);
                _response = null;
            }

            GetLastResponseAsString();

            return _response;
        }

        /// <summary>
        /// Gets the last response as xml.
        /// </summary>
        /// <returns>The XML document created from the response</returns>
        /// <remarks>This function will throw an exception if the response is not able to be converted to XML</remarks>
        public XmlDocument GetLastResponseAsXML()
        {
            // Check to see if we've already got it
			if (_responseAsXML == null)
			{
				string thisResponse = GetLastResponseAsString();
				// Create the new response
				_responseAsXML = new XmlDocument();

				// Check to see if we requested an aspx or normal page
				try
				{
					_responseAsXML.LoadXml(thisResponse);
				}
				catch (Exception e)
				{
					throw new Exception("Response wasn't valid xml. Response: \n" + thisResponse, e);
				}
			}

            // return the new document
            return _responseAsXML;
        }

        /// <summary>
        /// Gets the last response as a string
        /// </summary>
        /// <returns>The response as a string.</returns>
        public string GetLastResponseAsString()
        {
            // Check to see if we've already got it
            if (_responseAsString == null)
            {
                // Check to see if we requested an aspx or normal page
                if (_lastRequestWasASPX)
                {
                    // load the string from the host resquest
                    _responseAsString = _hostRequest.ResponseString;
                }
                else
                {
                    // Create a reader from the response stream and return the content
                    using (StreamReader reader = new StreamReader(_response.GetResponseStream()))
                    {
                        _responseAsString = reader.ReadToEnd();
                    }
					_response.Close();
					//_response = null;
					return _responseAsString;
                }
            }

            // return the response
            return _responseAsString;
        }
    }
}
