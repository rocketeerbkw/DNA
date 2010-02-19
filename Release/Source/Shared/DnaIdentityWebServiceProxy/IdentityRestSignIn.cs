using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Diagnostics;
using System.Xml;
using System.Reflection;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// The new Identity Rest API signin
    /// </summary>
    public class IdentityRestSignIn : IDnaIdentityWebServiceProxy
    {
        public IdentityRestSignIn()
        {
        }

        /// <summary>
        /// Default constructor. This creates the web connection and sets the policy based on the sitename.
        /// </summary>
        /// <param name="connectionDetails">The url for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        public IdentityRestSignIn(string connectionDetails, string clientIPAddress)
        {
            // Set the connection string for the web service
            Initialise(connectionDetails, clientIPAddress);
        }
        
        /// <summary>
        /// This property tell the caller that it uses identity
        /// </summary>
        public SignInSystem SignInSystemType
        {
            get { return SignInSystem.Identity; }
        }

        private bool _initialised = false;
        private string _clientIPAddress = "";
        private string _proxy = "";
        private string _certificateName = "";
        string _identityBaseURL = "";
        CookieContainer _cookieContainer = new CookieContainer();

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
                _identityBaseURL = details[0];

                _identityBaseURL = _identityBaseURL.Substring(0,_identityBaseURL.LastIndexOf("/"));
                _identityBaseURL = _identityBaseURL.Substring(0, _identityBaseURL.LastIndexOf("/"));
                _identityBaseURL = _identityBaseURL.Substring(0, _identityBaseURL.LastIndexOf("/"));

                if (details.Length > 1)
                {
                    _certificateName = details[1];
                }
                if (details.Length > 2)
                {
                    _proxy = details[2];
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

                report.AppendLine("IdentityRestSignIn - Initialising...");
                report.AppendLine("Base URL         - " + _identityBaseURL);
                report.AppendLine("Certificate Name - " + _certificateName);
                report.AppendLine("Proxy server     - " + _proxy);
#if EVENTLOGGING
                report.AppendLine("Event Logging    - " + _eventLogging.ToString());
#endif
                report.AppendLine("");

                _clientIPAddress = clientIPAddress;

                if (!_initialised)
                {
                    ServicePointManager.ServerCertificateValidationCallback += DNAIWSAcceptCertificatePolicy;
                    _initialised = true;
                }
            }
            catch (Exception e)
            {
                report.AppendLine("ERROR!!! - " + e.Message);
            }

            report.AppendLine("");
            Trace.WriteLine(report);

            return _initialised;
        }

        /// <summary>
        /// Create a request object to call the identity rest interface
        /// </summary>
        /// <param name="identityRestCall">The Uri to request</param>
        /// <returns>The response from the request</returns>
        private HttpWebResponse CallRestAPI(string identityRestCall)
        {
            HttpWebResponse response = null;
            try
            {
                _lastTimingInfo += "(*) Calling Rest with : " + identityRestCall + ", cert=" + _certificateName + " (*) ";
                Uri URL = new Uri(identityRestCall);
                HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

                webRequest.Timeout = 30000;

                if (_proxy.Length > 0)
                {
                    webRequest.Proxy = new WebProxy(_proxy);
                }

                webRequest.CookieContainer = _cookieContainer;
                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                X509Certificate certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _certificateName, false)[0];
                webRequest.ClientCertificates.Add(certificate);
                response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }

                _lastTimingInfo += "<ERROR>" + error + "</ERROR>";
            }
            return response;
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

        private bool _userLoggedIn = false;

        /// <summary>
        /// Get property that states whether or not the user is logged in
        /// </summary>
        public bool IsUserLoggedIn
        {
            get { return _userLoggedIn; }
        }

        private bool _userSignedIn = false;

        /// <summary>
        /// Get property that states whether or not the user is signed in
        /// </summary>
        public bool IsUserSignedIn
        {
            get { return _userSignedIn; }
        }

        private int _legacySSOID = 0;
        private string _displayName = "";
        private string _emailAddress = "";
        private string _firstName = "";
        private string _lastName = "";
        private DateTime _lastUpdatedDate;

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
                return _loginName.Length > 0;
            }
            else if (attributeName == "displayname")
            {
                return _displayName.Length > 0;
            }
            else if (attributeName == "firstname")
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
            else if (attributeName == "lastupdatedcpp")
            {
                return true;
            }
            else if (attributeName == "lastupdated")
            {
                return true;
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
            if (attributeName == "email")
            {
                return _emailAddress;
            }
            else if (attributeName == "username")
            {
                return _loginName;
            }
            else if (attributeName == "displayname")
            {
                return _displayName;
            }
            else if (attributeName == "firstname")
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
            else if (attributeName == "lastupdatedcpp")
            {
                return string.Format("{0:yyyyMMddHHmmss}", _lastUpdatedDate);
            }
            else if (attributeName == "lastupdated")
            {
                return _lastUpdatedDate.ToString();
            }
            return "";
        }

        private string _PolicyUri = "";

        /// <summary>
        /// Sets the service you want to log into or get info about
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
            bool userSet = false;
            return userSet;
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="userName">The username you want to sign in with</param>
        /// <param name="password">The password for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaUserNamePassword(string userName, string password)
        {
            bool userSet = false;
            return userSet;
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            _userLoggedIn = false;
            try
            {
                // Make sure the cookie does not contain a ' ', so replace them with '+'
                cookie = cookie.Replace(' ', '+');

                // Check to see if the user is logged in
                _lastTimingInfo = "Calling athorization ";
                _cookieContainer.Add(new Cookie("IDENTITY", cookie, "/", ".bbc.co.uk"));
                HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/authorization?target_resource={1}", _identityBaseURL, _PolicyUri));
                if (response == null || response.StatusCode != HttpStatusCode.OK)
                {
                    if (response == null)
                    {
                        _lastTimingInfo += "Failed to authorize user because of no response.";
                    }
                    else
                    {
                        _lastTimingInfo += "Failed to authorize user because status code = " + response.StatusCode.ToString();
                    }
                    return false;
                }

                XmlDocument xDoc = new XmlDocument();
                xDoc.Load(response.GetResponseStream());
                response.Close();
                _userSignedIn = true;
                _cookieValue = cookie;

                // Check to make sure that we get a valid response and it's value is true
                if (xDoc.SelectSingleNode("//boolean") == null || xDoc.SelectSingleNode("//boolean").InnerText != "true")
                {
                    // Not valid or false
                    _lastTimingInfo += "authorize result false or null : " + response;
                    return false;
                }

                _lastTimingInfo += " - Getting cookies 1 (";
                // NOw add all the cookies from the last response to the nextr request
                foreach (Cookie c in response.Cookies)
                {
                    if (c.Name.Contains("X-Mapping"))
                    {
                        c.Domain = ".bbc.co.uk";
                    }
                    _cookieContainer.Add(c);
                    _lastTimingInfo += c.Name + ":" + c.Domain + ":" + c.Value + ",";
                }
                _lastTimingInfo += ")";

                string identityUserName = userName.Substring(0, userName.IndexOf("|"));

                _lastTimingInfo += " - Getting attributes (";
                response = CallRestAPI(string.Format("{0}/idservices/users/{1}/attributes", _identityBaseURL, identityUserName));
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    _lastTimingInfo += "Get attributes failed : " + response;
                    return false;
                }
                
                _lastTimingInfo += " - Getting cookies 2 (";
                // NOw add all the cookies from the last response to the nextr request
                foreach (Cookie c in response.Cookies)
                {
                    if (c.Name.Contains("X-Mapping"))
                    {
                        c.Domain = ".bbc.co.uk";
                    }
                    _lastTimingInfo += c.Name + ":" + c.Domain + ":" + c.Value + ",";
                }
                _lastTimingInfo += ")";

                xDoc.Load(response.GetResponseStream());
                response.Close();
                if (xDoc.HasChildNodes)
                {
                    _loginName = xDoc.SelectSingleNode("//attributes/username").InnerText;
                    _lastTimingInfo += _loginName + ",";
                    _emailAddress = xDoc.SelectSingleNode("//attributes/email").InnerText;
                    _lastTimingInfo += _emailAddress + ",";
                    if (xDoc.SelectSingleNode("//attributes/firstname") != null)
                    {
                        _firstName = xDoc.SelectSingleNode("//attributes/firstname").InnerText;
                    }
                    if (xDoc.SelectSingleNode("//attributes/lastname") != null)
                    {
                        _lastName = xDoc.SelectSingleNode("//attributes/lastname").InnerText;
                    }

                    _userID = Convert.ToInt32(xDoc.SelectSingleNode("//attributes/id").InnerText);

                    string legacyID = xDoc.SelectSingleNode("//attributes/legacy_user_id").InnerText;
                    if (legacyID.Length == 0)
                    {
                        legacyID = "0";
                    }
                    _legacySSOID = Convert.ToInt32(legacyID);
                    _lastTimingInfo += legacyID + ",";

                    _displayName = xDoc.SelectSingleNode("//attributes/displayname").InnerText;
                    _lastTimingInfo += _displayName + ",";

                    DateTime.TryParse(xDoc.SelectSingleNode("//attributes/update_date").InnerText, out _lastUpdatedDate);
                    _lastTimingInfo += _lastUpdatedDate.ToString() + ",";

                    // The user is now setup correctly
                    _userLoggedIn = _userID > 0;
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
                _lastTimingInfo += "Error!!! : " + error;
            }
            return _userLoggedIn;
        }

        /// <summary>
        /// Tries to log the user in with the details already set
        /// </summary>
        /// <returns>True if they were logged in, false if not</returns>
        public bool LoginUser()
        {
            bool userLoggedIn = false;
            return userLoggedIn;
        }

        private int _userID = 0;

        /// <summary>
        /// Get property for the current user id
        /// </summary>
        public int UserID
        {
            get { return _userID; }
        }

        private string _loginName = "";

        /// <summary>
        /// Get property for the current users login name
        /// </summary>
        public string LoginName
        {
            get { return _loginName; }
        }

        /// <summary>
        /// Get property for the current users display name
        /// </summary>
        public string DisplayName
        {
            get { return _displayName; }
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
                HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/policy", _identityBaseURL));
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    _lastTimingInfo = "Failed to get policies!";
                    return policies.ToArray();
                }

                XmlDocument xDoc = new XmlDocument();
                xDoc.Load(response.GetResponseStream());
                response.Close();

                // Check to make sure that we get a valid response and it's value is true
                if (xDoc.SelectSingleNode("//policies") == null)
                {
                    // Not valid or false
                    _lastTimingInfo = "No policies found";
                    return policies.ToArray();
                }

                // Get the DNA policies from the results
                foreach (XmlNode policy in xDoc.SelectNodes("//policies/policy/uri"))
                {
                    if (policy.InnerText.Contains("/dna/") && !policies.Contains(policy.InnerText))
                    {
                        policies.Add(policy.InnerText);
                    }
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
                _lastTimingInfo = "Error!!! : " + error;
            }

            //AddTimingInfo("Finished GetDnaPolicies", false);
            return policies.ToArray();
        }
        
        /// <summary>
        /// Gets the min max ages for a given service
        /// </summary>
        /// <param name="serviceName">The name of the service you want to check against</param>
        /// <param name="minAge">reference to an int that will take the min age</param>
        /// <param name="maxAge">reference to an int that will take the max age</param>
        public void GetServiceMinMaxAge(string serviceName, ref int minAge, ref int maxAge)
        {
        }

        /// <summary>
        /// Called to close any connections that might be open for the current object.
        /// </summary>
        public void CloseConnections()
        {
        }

        /// <summary>
        /// Called to dispose of any allocated resources if any
        /// </summary>
        public void Dispose()
        {
        }

        private string _cookieValue = "";

        /// <summary>
        /// Gets the current users Identity cookie value
        /// </summary>
        public string GetCookieValue
        {
            get { return _cookieValue; }
        }

#if DEBUG
        /// <summary>
        /// Debugging feature for logging out users
        /// </summary>
        public void LogoutUser()
        {
        }
#endif

        private string _lastError = "";

        /// <summary>
        /// Gets the last known error as a string
        /// </summary>
        /// <returns>The error message</returns>
        public string GetLastError()
        {
            return _lastError;
        }

        private string _lastTimingInfo = "IdentityRest";

        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        public string GetLastTimingInfo()
        {
            return _lastTimingInfo;
        }

        /// <summary>
        /// Gets the version number of the Interface
        /// </summary>
        /// <returns>The version number for this Interface</returns>
        public string GetVersion()
        {
            Version v = Assembly.GetExecutingAssembly().GetName().Version;
            return String.Format("{0} (RestAPI)",v.ToString());
        }
    }
}
