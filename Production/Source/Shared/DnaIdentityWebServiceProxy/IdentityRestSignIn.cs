using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Diagnostics;
using System.Xml;
using System.Reflection;
using System.IO;

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
        private bool _traceOutput = false;
        private string _identityBaseURL = "";
        private CookieContainer _cookieContainer = new CookieContainer();
        private StringBuilder _callInfo = new StringBuilder();
        private bool _secureCookieCall = false;

        private void AddTimingInfoLine(string info)
        {
            if (_traceOutput)
            {
                _callInfo.AppendLine(info);
            }
            Trace.WriteLineIf(_traceOutput,info);
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
                    _traceOutput = true;
                }

                AddTimingInfoLine( "<* IDENTITY START *>");
                AddTimingInfoLine( "IdentityRestSignIn - Initialising...");
                AddTimingInfoLine( "Base URL           - " + _identityBaseURL);
                AddTimingInfoLine( "Certificate Name   - " + _certificateName);
                AddTimingInfoLine( "Proxy server       - " + _proxy);

                _clientIPAddress = clientIPAddress;

                if (!_initialised)
                {
                    ServicePointManager.ServerCertificateValidationCallback += DNAIWSAcceptCertificatePolicy;
                    _initialised = true;
                }
            }
            catch (Exception e)
            {
                AddTimingInfoLine( "ERROR!!! - " + e.Message);
            }

            AddTimingInfoLine( "<* IDENTITY END *>");
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
                AddTimingInfoLine("(*) Calling Rest with : " + identityRestCall + ", cert=" + _certificateName + " (*) ");
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
            catch (WebException ex)
            {
                string error = ex.Message;

                if (ex.Response != null)
                {
                    StreamReader reader = new StreamReader(ex.Response.GetResponseStream(), Encoding.UTF8);
                    error += reader.ReadToEnd();
                }

                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }

                AddTimingInfoLine("<ERROR>" + error + "</ERROR>");
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
        /// Tries to set the user using their username and cookie
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            return TrySecureSetUserViaCookies(cookie, "");
        }

        /// <summary>
        /// Tries to set the user using their username, normal cookie and secure cookie
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="secureCookie">The secure cookie value for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySecureSetUserViaCookies(string cookie, string secureCookie)
        {
            _userLoggedIn = false;
            _secureCookieCall = false;
            AddTimingInfoLine("<* IDENTITY START *>");
            try
            {
                // Make sure the cookie does not contain a ' ', so replace them with '+'
                cookie = cookie.Replace(' ', '+');

                // Strip the :0 or encoded %3A0 from the end of the secure cookie as it won't validate with it added.
                secureCookie = secureCookie.Replace(":0", "").Replace("%3A0", "");

                // Check to see if the user is logged in
                AddTimingInfoLine("Calling authorization ");

                _cookieContainer.Add(new Cookie("IDENTITY", cookie, "/", ".bbc.co.uk"));
                if (secureCookie.Length > 0)
                {
                    _cookieContainer.Add(new Cookie("IDENTITY-HTTPS", secureCookie, "/", ".bbc.co.uk"));
                    _secureCookieCall = true;
                }
                HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/authorization?target_resource={1}", _identityBaseURL, _PolicyUri));
                if (response == null || response.StatusCode != HttpStatusCode.OK)
                {
                    if (response == null)
                    {
                        AddTimingInfoLine("Failed to authorize user because of no response.");
                    }
                    else
                    {
                        AddTimingInfoLine("Failed to authorize user because status code = " + response.StatusCode.ToString());
                    }
                    AddTimingInfoLine( "<* IDENTITY END *>");
                    return false;
                }

                XmlDocument xDoc = new XmlDocument();
                xDoc.Load(response.GetResponseStream());
                response.Close();
                _userSignedIn = true;
                _cookieValue = cookie;
                if (secureCookie.Length > 0)
                {
                    _secureCookieValue = secureCookie;
                }

                // Check to make sure that we get a valid response and it's value is true
                if (xDoc.SelectSingleNode("//boolean") == null || xDoc.SelectSingleNode("//boolean").InnerText != "true")
                {
                    // Not valid or false
                    AddTimingInfoLine("authorize result false or null : " + response);
                    AddTimingInfoLine( "<* IDENTITY END *>");
                    return false;
                }
                string identityUserName = cookie.Split('|').GetValue(1).ToString();

                AddTimingInfoLine("Calling Get Attributes...");
                response = CallRestAPI(string.Format("{0}/idservices/users/{1}/attributes", _identityBaseURL, identityUserName));
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    AddTimingInfoLine("Get attributes failed : " + response);
                    AddTimingInfoLine( "<* IDENTITY END *>");
                    return false;
                }

                xDoc.Load(response.GetResponseStream());
                response.Close();
                if (xDoc.HasChildNodes)
                {
                    _loginName = xDoc.SelectSingleNode("//attributes/username").InnerText;
                    AddTimingInfoLine("Login Name      : " + _loginName);
                    _emailAddress = xDoc.SelectSingleNode("//attributes/email").InnerText;
                    AddTimingInfoLine("Email           : " + _emailAddress);
                    if (xDoc.SelectSingleNode("//attributes/firstname") != null)
                    {
                        _firstName = xDoc.SelectSingleNode("//attributes/firstname").InnerText;
                    }
                    if (xDoc.SelectSingleNode("//attributes/lastname") != null)
                    {
                        _lastName = xDoc.SelectSingleNode("//attributes/lastname").InnerText;
                    }

                    _userID = xDoc.SelectSingleNode("//attributes/id").InnerText;

                    string legacyID = xDoc.SelectSingleNode("//attributes/legacy_user_id").InnerText;
                    if (legacyID.Length == 0)
                    {
                        legacyID = "0";
                    }
                    _legacySSOID = Convert.ToInt32(legacyID);
                    AddTimingInfoLine("Legacy SSO ID   : " + legacyID);

                    _displayName = xDoc.SelectSingleNode("//attributes/displayname").InnerText;
                    AddTimingInfoLine("Display Name    : " + _displayName);

                    DateTime.TryParse(xDoc.SelectSingleNode("//attributes/update_date").InnerText, out _lastUpdatedDate);
                    AddTimingInfoLine("Last Updated    : " + _lastUpdatedDate.ToString());

                    // The user is now setup correctly
                    _userLoggedIn = _userID.Length > 0;
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
                AddTimingInfoLine("Error!!! : " + error);
            }
            AddTimingInfoLine( "<* IDENTITY END *>");
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

        private string _userID = "";

        /// <summary>
        /// Get property for the current user id
        /// </summary>
        public string UserID
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
            AddTimingInfoLine( "<* IDENTITY START *>");

            try
            {
                HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/policy", _identityBaseURL));
                if (response.StatusCode != HttpStatusCode.OK)
                {
                    AddTimingInfoLine("Failed to get policies!");
                    AddTimingInfoLine( "<* IDENTITY END *>");
                    return policies.ToArray();
                }

                XmlDocument xDoc = new XmlDocument();
                xDoc.Load(response.GetResponseStream());
                response.Close();

                // Check to make sure that we get a valid response and it's value is true
                if (xDoc.SelectSingleNode("//policies") == null)
                {
                    // Not valid or false
                    AddTimingInfoLine("No policies found");
                    AddTimingInfoLine( "<* IDENTITY END *>");
                    return policies.ToArray();
                }

                // Get the DNA policies from the results
                foreach (XmlNode policy in xDoc.SelectNodes("//policies/policy/uri"))
                {
                    if (policy.InnerText.Contains("/identity/policies/dna/") && !policies.Contains(policy.InnerText))
                    {
                        policies.Add(policy.InnerText);
                        AddTimingInfoLine( "policy.InnerText");
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
                AddTimingInfoLine("Error!!! : " + error);
            }

            AddTimingInfoLine( "<* IDENTITY END *>");
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

        private string _secureCookieValue = "";

        /// <summary>
        /// Gets the current users Identity secure cookie value
        /// </summary>
        public string GetSecureCookieValue
        {
            get { return _secureCookieValue; }
        }

        /// <summary>
        /// Debugging feature for logging out users
        /// </summary>
        public void LogoutUser()
        {
        }

        private string _lastError = "";

        /// <summary>
        /// Gets the last known error as a string
        /// </summary>
        /// <returns>The error message</returns>
        public string GetLastError()
        {
            return _lastError;
        }

        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        public string GetLastTimingInfo()
        {
            return _callInfo.ToString();
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

        /// <summary>
        /// This method is used to check if the current call was made securely, called with the IDENTITY-HTTPS cookie.
        /// </summary>
        /// <returns>True if it is, false if not</returns>
        public bool IsSecureRequest
        {
            get { return _secureCookieCall; }
        }

        Dictionary<string, string> _nameSpacedAttributes = null;

        /// <summary>
        /// Gets the value of the given attribute from the given app name space in identity
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name Space the attribute lives in</param>
        /// <param name="attributeName">The attribute you want to get the value of</param>
        /// <returns>The value of the attribute. This will be empty if the attrbute does not exist</returns>
        public string GetAppNameSpacedAttribute(string cookie, string appNameSpace, string attributeName)
        {
            AddTimingInfoLine("Calling Get App Spacename Attrbute " + attributeName + " for namespace " + appNameSpace);

            // Check to see if we've cached the attrbute
            string key = cookie.Replace(' ', '+') + appNameSpace + attributeName;
            if (_nameSpacedAttributes != null && _nameSpacedAttributes.ContainsKey(key))
            {
                return _nameSpacedAttributes[key];
            }

            // Check to see if it exists
            if (DoesAppNameSpacedAttributeExist(cookie, appNameSpace, attributeName))
            {
                // Check to see if we've cached the attrbute
                if (_nameSpacedAttributes.ContainsKey(key))
                {
                    return _nameSpacedAttributes[key];
                }
            }

            // Didn't find the attribute value
            return "";
        }

        /// <summary>
        /// Checks to see if the requested attribute exists
        /// </summary>
        /// <param name="cookie">The users IDENTITY cookie</param>
        /// <param name="appNameSpace">The App Name space in which to check for the attribute</param>
        /// <param name="attributeName">The name of the attribute you want to check for</param>
        /// <returns>True if it exists, false if not</returns>
        public bool DoesAppNameSpacedAttributeExist(string cookie, string appNameSpace, string attributeName)
        {
            string identityUserName = cookie.Split('|').GetValue(1).ToString();
            AddTimingInfoLine("<* IDENTITY START *>");

            AddTimingInfoLine("Calling Does App Spacename Attrbute Exist " + attributeName + " for namespace " + appNameSpace);
            _cookieContainer.Add(new Cookie("IDENTITY", cookie.Replace(' ','+'), "/", ".bbc.co.uk")); 
            HttpWebResponse response = CallRestAPI(string.Format("{0}/idservices/users/{1}/applications/{2}/attributes", _identityBaseURL, identityUserName, appNameSpace));
            if (response == null || response.StatusCode != HttpStatusCode.OK)
            {
                AddTimingInfoLine("Get named spaced attribute failed!");
                AddTimingInfoLine("<* IDENTITY END *>");
                return false;
            }

            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(response.GetResponseStream());
            response.Close();

            bool exists = xDoc.SelectSingleNode("//" + appNameSpace + "/" + attributeName) != null;
            if (!exists)
            {
                AddTimingInfoLine(string.Format("Failed to find {0} int the {1} namespace", attributeName, appNameSpace));
                AddTimingInfoLine("<* IDENTITY END *>");
                return false;
            }

            string attributeValue = xDoc.SelectSingleNode("//" + appNameSpace + "/" + attributeName).InnerText;

            // Add the attribute value to the cache so we don't do extra calls
            if (_nameSpacedAttributes == null)
            {
                _nameSpacedAttributes = new Dictionary<string, string>();
            }

            // Check to see if we need to add it, or update the current one
            string key = cookie.Replace(' ', '+') + appNameSpace + attributeName;
            if (_nameSpacedAttributes.ContainsKey(key))
            {
                _nameSpacedAttributes[key] = attributeValue;
            }
            else
            {
                _nameSpacedAttributes.Add(key, attributeValue);
            }

            AddTimingInfoLine("<* IDENTITY END *>");
            return true;
        }
    }
}
