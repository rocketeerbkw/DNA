using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Net;
using System.Web;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Web.Services.Protocols;
#if EVENTLOGGING
using System.Diagnostics;
#endif

namespace DnaIdentityWebServiceProxy
{
    public class DnaIdentityWebServiceProxy : IDnaIdentityWebServiceProxy
    {
        private IdentityServicesImplService _webService = null;
        private X509Certificate _certificate = null;
        private string _PolicyUri = "";
        private token _appToken = null;
        private CookieContainer _cookieContainer = null;
        private string _clientIPAddress = "";

        private bool _userLoggedIn = false;
        private bool _userSignedIn = false;
        private int _userID = 0;
        private int _legacySSOID = 0;
        private string _displayName = "";
        private string _emailAddress = "";
        private string _firstName = "";
        private string _lastName = "";

        private token _currentUserToken = null;
        private bool _haveUserDetails = false;
        private bool _initialised = false;

        private string _errorMessage;

#if EVENTLOGGING
        private bool _eventLogging = false;
        private EventLog _eventLog = new EventLog();
#endif

        /// <summary>
        /// This property tell the caller that it uses identity
        /// </summary>
        public SignInSystem SignInSystemType
        {
            get { return SignInSystem.Identity; }
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        public DnaIdentityWebServiceProxy()
        {
        }

        /// <summary>
        /// Default constructor. This creates the web connection and sets the policy based on the sitename.
        /// </summary>
        /// <param name="connectionDetails">The url for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        public DnaIdentityWebServiceProxy(string connectionDetails, string clientIPAddress)
        {
            // Set the connection string for the web service
            Initialise(connectionDetails, clientIPAddress);
        }

        /// <summary>
        /// Initialises the connection details for the web service
        /// </summary>
        /// <param name="connectionDetails">The connection string for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        /// <returns>True if initialised, false if something went wrong</returns>
        public bool Initialise(string connectionDetails, string clientIPAddress)
        {
            // Set the connection string for the web service
            string[] details = connectionDetails.Split(';');
            StringBuilder report = new StringBuilder();
            try
            {
                string identityURL = details[0];
                string certificateName = "";
                string proxy = "";
                if (details.Length > 1)
                {
                    certificateName = details[1];
                }
                if (details.Length > 2)
                {
                    proxy = details[2];
                }
                if (details.Length > 3)
                {
#if EVENTLOGGING
                    _eventLogging = details[3].Length > 0;
                    if (!EventLog.SourceExists("DnaIdentityWebService"))
                    {
                        EventLog.CreateEventSource("DnaIdentityWebService", "DnaIdentityWebServiceLogging");
                        _eventLogging = false;
                    }
                    else
                    {
                        _eventLog.Source = "DnaIdentityWebService";
                    }
#endif
                }

                report.AppendLine("DnaIdentityWebProxy - Initialising...");
                report.AppendLine("URL              - " + identityURL);
                report.AppendLine("Certificate Name - " + certificateName);
                report.AppendLine("Proxy server     - " + proxy);
#if EVENTLOGGING
                report.AppendLine("Event Logging    - " + _eventLogging.ToString());
#endif
                report.AppendLine("");

                if (!_initialised)
                {
                    ServicePointManager.ServerCertificateValidationCallback += DNAIWSAcceptCertificatePolicy;
                    _webService = new IdentityServicesImplService(identityURL);
                    report.AppendLine("Webservice OK");
                    if (certificateName.Length > 0)
                    {
                        X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                        store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                        _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, certificateName, false)[0];
                        _webService.ClientCertificates.Add(_certificate);
                        report.AppendLine("Certificate OK");
                    }
                    if (proxy.Length > 0)
                    {
                        _webService.Proxy = new WebProxy(proxy);
                    }
                    _cookieContainer = new CookieContainer();
                    _webService.CookieContainer = _cookieContainer;
                    _clientIPAddress = clientIPAddress;
                    _initialised = true;
                }
            }
            catch (SoapException e)
            {
                report.AppendLine("ERROR!!! - " + e.Message);
                _errorMessage = report.ToString();
                TraceSoapException(e, "InitialiseError - ");
            }
            catch (Exception e)
            {
                report.AppendLine("ERROR!!! - " + e.Message);
                _errorMessage = report.ToString();
                TraceLine("InitialiseError - " + e.Message);
            }

            report.AppendLine("");
            TraceLine(report.ToString());
            return _initialised;
        }

        /// <summary>
        /// Callback method for the certificate acception.
        /// </summary>
        /// <param name="sender">The httpWebRequest asking for accept certificates</param>
        /// <param name="certificate">The certificate that is being asked to be accepted</param>
        /// <param name="chain">The certificate chain</param>
        /// <param name="sslPolicyErrors">Any errors</param>
        /// <returns>True to accept certificates</returns>
        public static bool DNAIWSAcceptCertificatePolicy(object sender,
                                                X509Certificate certificate,
                                                X509Chain chain,
                                                SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }
        
        /// <summary>
        /// The BBC UID for the current viewing user
        /// </summary>
        public string BBCUID
        {
            get { return ""; }
        }

        /// <summary>
        /// Get property that states whether or not the user is logged in
        /// </summary>
        public bool IsUserLoggedIn
        {
            get { return _userLoggedIn; }
        }

        /// <summary>
        /// Get property that states whether or not the user is signed in
        /// </summary>
        public bool IsUserSignedIn
        {
            get { return _userSignedIn; }
        }

        /// <summary>
        /// Checks to see if a given attribute exists for the given service
        /// </summary>
        /// <param name="siteName">The name of the service you want to check against</param>
        /// <param name="attributeName">The name of the attribute you want to check for</param>
        /// <returns>True if it does, false if not</returns>
        public bool DoesAttributeExistForService(string siteName, string attributeName)
        {
            // Check to see if we've already got the site attributes
            if (attributeName == "email")
            {
                return _emailAddress.Length > 0;
            }
            else if (attributeName == "username")
            {
                return _displayName.Length > 0;
            }
            else if (attributeName == "firstnames")
            {
                return _firstName.Length > 0;
            }
            else if (attributeName == "lastname")
            {
                return _lastName.Length > 0;
            }
            else if (attributeName == "legacy_user_id")
            {
                return _legacySSOID > 0;
            }
            return false;
        }

        /// <summary>
        /// Gets the given attribute for the current user
        /// </summary>
        /// <param name="attributeName">The name of the attribute you want to get</param>
        /// <returns>The value if it exists, empty if it doesn't</returns>
        public string GetUserAttribute(string attributeName)
        {
            // If we don't have the users attributes, get them now
            if (!_haveUserDetails)
            {
                GetAttributes();
            }

            if (attributeName == "email")
            {
                return _emailAddress;
            }
            else if (attributeName == "username")
            {
                return _displayName;
            }
            else if (attributeName == "firstnames")
            {
                return _firstName;
            }
            else if (attributeName == "lastname")
            {
                return _lastName;
            }
            else if (attributeName == "legacy_user_id")
            {
                return _legacySSOID.ToString();
            }
            return "";
        }

        /// <summary>
        /// Gets all the attributes for the current user
        /// </summary>
        private bool GetAttributes()
        {
            // Reset the details flag
            _haveUserDetails = false;
            _userID = 0;
            _displayName = "";
            _firstName = "";
            _lastName = "";
            _emailAddress = "";

            // Have we got a logged in user?
            if (_userSignedIn)
            {
                // State which attributes we want to get
                string[] attributesToFetch = { "username", "email", "firstnames", "lastname", "id", "legacy_user_id" };
                userDetails details = null;
                try
                {
                    // Get the details for the user
                    _webService.InitialiseRequest(_clientIPAddress);
                    details = _webService.getAttributes(_appToken, attributesToFetch, _currentUserToken);

                    // Go through the user details filling in the ones we need.
                    foreach (attribute attr in details.attributes)
                    {
                        if (attr.name == "id" && attr.values != null)
                        {
                            _userID = Convert.ToInt32(attr.values[0]);
                        }
                        else if (attr.name == "email" && attr.values != null)
                        {
                            _emailAddress = attr.values[0];
                        }
                        else if (attr.name == "username" && attr.values != null)
                        {
                            _displayName = attr.values[0];
                        }
                        else if (attr.name == "firstnames" && attr.values != null)
                        {
                            _firstName = attr.values[0];
                        }
                        else if (attr.name == "lastname" && attr.values != null)
                        {
                            _lastName = attr.values[0];
                        }
                        else if (attr.name == "legacy_user_id" && attr.values != null)
                        {
                            if (attr.values[0].Length > 0)
                            {
                                _legacySSOID = Convert.ToInt32(attr.values[0]);
                            }
                        }
                    }

                    // We now have the user details
                    _haveUserDetails = true;
                }
                catch (SoapException ex)
                {
                    // Something not right!
                    TraceSoapException(ex, "GetAttributesError - ");
                }
                catch (Exception e)
                {
                    TraceLine("GetAttributesError - " + e.Message);
                }
            }

            // Return the verdict
            return _haveUserDetails;
        }

        /// <summary>
        /// Sets the site you want to log into or get info about
        /// </summary>
        /// <param name="serviceName">The name of the service you want to use</param>
        public void SetService(string serviceName)
        {
            _PolicyUri = serviceName.ToLower();
        }

        /// <summary>
        /// Get property that states whether or not the service has been set
        /// </summary>
        public bool IsServiceSet
        {
            get { return _PolicyUri.Length > 0; }
        }

        /// <summary>
        /// Tries to log a user in via their cookie
        /// </summary>
        /// <param name="cookieValue">The users cookie</param>
        /// <returns>True if they were logged in, false if not</returns>
        public bool TrySetUserViaCookie(string cookieValue)
        {
            try
            {
                AddTimingInfo("TrySetUserViaCookie", true);
                _webService.InitialiseRequest(_clientIPAddress);
                AddTimingInfo("Initialised Rerquest", false);
                _currentUserToken = _webService.authenticateCookieValue(_appToken, cookieValue);
                AddTimingInfo("Authenticated cookie value", false);
                _userLoggedIn = _webService.authorize(_appToken, _PolicyUri, "GET", _currentUserToken);
                AddTimingInfo("Authorized User", false);
                _userSignedIn = true;
                GetAttributes();
                AddTimingInfo("Got attributes", false);
            }
            catch (SoapException ex)
            {
                // Something not right!
                AddTimingInfo("SoapEception - " + ex.Detail, false);
                TraceSoapException(ex, "TrySetUserViaCookieError - ");
                _userSignedIn = false;
            }
            catch (Exception e)
            {
                TraceLine("TrySetUserViaCookieError - " + e.Message);
                _userSignedIn = false;
            }

            TraceLine("Policy - " + _PolicyUri + "\n\ruserToken - " + _currentUserToken + "\n\rSigned in - " + _userSignedIn.ToString() + "\n\rLogged in - " + _userLoggedIn.ToString());
            AddTimingInfo("Finished TrySetUserViaCookie", false); 
            return _userLoggedIn;
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="userName">The username you want to sign in with</param>
        /// <param name="password">The password for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaUserNamePassword(string userName, string password)
        {
            try
            {
                _webService.InitialiseRequest(_clientIPAddress);
                _currentUserToken = _webService.authenticate(_appToken, userName, password, _PolicyUri);
                _userLoggedIn = _webService.authorize(_appToken, _PolicyUri, "GET", _currentUserToken);
                _userSignedIn = true;
                GetAttributes();
            }
            catch (SoapException ex)
            {
                // Something not right!
                TraceSoapException(ex, "TrySetUserViaUserNamePasswordError - ");
                _userSignedIn = false;
            }
            catch (Exception e)
            {
                TraceLine("TrySetUserViaUserNamePasswordError - " + e.Message);
                _userLoggedIn = false;
            }

            return _userLoggedIn;
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            bool userSet = false;
            return userSet;
        }

        /// <summary>
        /// Tries to log the user in with the details already set
        /// </summary>
        /// <returns>True if they were logged in, false if not</returns>
        public bool LoginUser()
        {
            return true;
        }

        /// <summary>
        /// Get property for the current user id
        /// </summary>
        public int UserID
        {
            get
            {
                if (!_haveUserDetails)
                {
                    GetAttributes();
                }
                return _userID;
            }
        }

        /// <summary>
        /// Get property for the current users login name
        /// </summary>
        public string LoginName
        {
            get
            {
                if (!_haveUserDetails)
                {
                    GetAttributes();
                } 
                return _displayName;
            }
        }

        /// <summary>
        /// Gets the min max ages for a given site
        /// </summary>
        /// <param name="siteName">The name of the site you want to check against</param>
        /// <param name="minAge">reference to an int that will take the min age</param>
        /// <param name="maxAge">reference to an int that will take the max age</param>
        public void GetServiceMinMaxAge(string siteName, ref int minAge, ref int maxAge)
        {
            // Currently this is not implimented in the Identity service so return defaults
            minAge = -1;
            maxAge = -1;
        }

        /// <summary>
        /// Called to close any connections that might be open for the current object.
        /// </summary>
        public void CloseConnections()
        {
            // Don't need to close connections
        }

        /// <summary>
        /// Called to dispose of any allocated resources if any
        /// </summary>
        public void Dispose()
        {
            // Nothing to dispose of here
        }

        /// <summary>
        /// Get the users cookie value
        /// </summary>
        public string GetCookieValue
        {
            get
            {
                string cookieValue = "";
                try
                {
                    _webService.InitialiseRequest(_clientIPAddress);
                    cookieValue = _webService.getCookieValue(_appToken, _currentUserToken, "", "");
                }
                catch (SoapException ex)
                {
                    // Something not right!
                    TraceSoapException(ex, "GetCookieError - ");
                }
                catch (Exception e)
                {
                    TraceLine("GetCookieError - " + e.Message);
                }

                return cookieValue;
            }
        }

#if DEBUG
        /// <summary>
        /// Debug only call to log the user out
        /// </summary>
        public void LogoutUser()
        {
            // The identity web service does not support this feature. Do nothing
            _webService.InitialiseRequest(_clientIPAddress);
            _webService.logout(_appToken, _currentUserToken);
        }

        /// <summary>
        /// Sets the server cookie for testing
        /// </summary>
        /// <param name="cookie">The cookie for the identity server</param>
        public void SetIdentityServerCookie(Cookie cookie)
        {
            try
            {
                _cookieContainer.Add(new Cookie(cookie.Name, cookie.Value, cookie.Path, cookie.Domain));
            }
            catch (Exception e)
            {
                TraceLine(e.Message);
            }
        }
#endif

        /// <summary>
        /// Helper method for tracing to file
        /// </summary>
        /// <param name="msg">The message you want to trace out</param>
        private void TraceLine(string msg)
        {
#if EVENTLOGGING
            if (_eventLogging)
            {
                _eventLog.WriteEntry(msg);
            }
#endif
        }

        /// <summary>
        /// Helper method for tracing soap exceptions to file
        /// </summary>
        /// <param name="ex">The exception you want to trace out</param>
        /// <param name="info">Any extra info for the exception</param>
        private void TraceSoapException(SoapException ex, string info)
        {
            StringBuilder s = new StringBuilder(info + ex.Message);
            if (ex.Detail != null)
            {
                s.AppendLine(ex.Detail.OuterXml.ToString());
            }
            AddTimingInfo(s.ToString(), false);
#if EVENTLOGGING
            if (_eventLogging)
            {
                _eventLog.WriteEntry(s.ToString());
            }
#endif
        }

        /// <summary>
        /// Gets the last known error
        /// </summary>
        /// <returns>The error message</returns>
        public string GetLastError()
        {
            return _errorMessage;
        }
    
        /// <summary>
        /// Gets the current list of all dna policies
        /// </summary>
        /// <returns>The list of dna policies, or null if non found</returns>
        public string[] GetDnaPolicies()
        {
            List<string> policies = new List<string>();
            try
            {
                AddTimingInfo("GetDnaPolicies", true);
                _webService.InitialiseRequest(_clientIPAddress);
                AddTimingInfo("Initialised request", false);
                string[] policyNames = _webService.listPolicyNames(_appToken, null);
                AddTimingInfo("Got policies", false);
                if (policyNames != null)
                {
                    foreach (string policy in policyNames)
                    {
                        if (policy.Contains("dna-"))
                        {
                            policies.Add("http://identity:80/policies/dna/" + policy.Substring(4));
                        }
                    }
                }
            }
            catch (SoapException ex)
            {
                // Something not right!
                TraceSoapException(ex, "GetDnaPoliciesError - ");
            }
            catch (Exception e)
            {
                AddTimingInfo("Exception thrown - " + e.Message, false);
                TraceLine("GetDnaPoliciesError - " + e.Message);
            }

            AddTimingInfo("Finished GetDnaPolicies", false);
            return policies.ToArray();
        }

        private string _timingInfo = "";
        private long _timingStart = 0;
        private long _timingSplitTime = 0;

        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        public string GetLastTimingInfo()
        {
            return _timingInfo;
        }

        /// <summary>
        /// Adds timing info to the _timingInfo field.
        /// </summary>
        /// <param name="info">The info you want to add</param>
        /// <param name="newInfo">A flag to state that you want to start new timing informtion</param>
        private void AddTimingInfo(string info, bool newInfo)
        {
            long currentTime = DateTime.Now.Ticks / 10000;
            if (newInfo)
            {
                _timingInfo = "";
                _timingStart = currentTime;
                _timingSplitTime = currentTime;
            }
            else
            {
                _timingInfo += " : ";
            }

            _timingInfo += info + " " + (currentTime - _timingStart).ToString() + " (" + (currentTime - _timingSplitTime).ToString() + ")";
            _timingSplitTime = currentTime;
        }


        /// <summary>
        /// Gets the version number of the Interface
        /// </summary>
        /// <returns>The version number for this Interface</returns>
        public string GetVersion()
        {
            return "1.0.1.6 (SOAP)";
        }
    }
}
