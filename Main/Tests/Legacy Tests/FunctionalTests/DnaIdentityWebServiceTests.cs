using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml;
using BBC.Dna;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for testing DNAs integration with SSO
    /// </summary>
    [TestClass]
    public class DnaIdentityWebServiceTests
    {
        private IdentityServicesImplService _webService = null;
        private token _appToken = null;
        private token _userToken = null;
        private string _appName;
        private bool _userCreated = false;

        // Test variables
        private string _ValidIdentityCookie = "";
        private string _userName = "testers" + DateTime.Now.Ticks.ToString();
        private string _displayName = "Good old tester";
        private string _password = "123456789";
        private string _dob = "1989-12-31";
        private string _email;

        // Name of the required attributes for the test Policy. These are liable to change
        // so update them here instead of specifing them in the tests.
        // For the latest attribute names use.. http://fmtdev16.national.core.bbc.co.uk:10854/opensso/identity/getrequiredattributes
        private string _wsUserName = "username";
        private string _wsDisplayName = "displayname";
        private string _wsDateOfBirth = "date_of_birth";
        private string _wsPassword = "password";
        private string _wsAgreedTerms = "agreement_accepted_flag";
        private string _wsEmailAddress = "email";
        private string _wsUserID = "id";
        private string _wsHouseRules = "houserules.adults";
        private string _wsEmailValidation = "email_validation_flag";

        private string _uriPolicy = "http://identity:80/policies/dna/adult";

        private X509Certificate _certificate = null;
        private string _proxy = "http://10.152.4.180:80"; // "www-cache.reith.bbc.co.uk:80";
        //private string _proxy = ""; // "www-cache.reith.bbc.co.uk:80";
        private string _webIdentityConnectionDetails;

        private Cookie _IdentityServerIdCookie = null;
        private Cookie _identityUserCookie;


        //private static string _IdentityServerBaseUri = "https://api.int.bbc.co.uk";
        //private static string _webServiceCertificationName = "dna";

        private static string _IdentityServerBaseUri = "https://api.test.bbc.co.uk";
        private static string _webServiceCertificationName = @"dna";

        //private static string _IdentityServerBaseUri = "https://api.stage.bbc.co.uk"; 
        //private static string _webServiceCertificationName = @"dna live";

        //private static string _IdentityServerBaseUri = "https://api.live.bbc.co.uk";
        //private static string _webServiceCertificationName = @"dna live";

        //private string _webServiceURL = _IdentityServerBaseUri + "/idservices";
        private string _webServiceURL = _IdentityServerBaseUri + "/opensso/identityservices/IdentityServices";


        public static bool AcceptAllCertificatePolicy(object sender,
                                                X509Certificate certificate,
                                                X509Chain chain,
                                                SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        public DnaIdentityWebServiceTests()
        {
            ServicePointManager.ServerCertificateValidationCallback += AcceptAllCertificatePolicy;
            _webIdentityConnectionDetails = _webServiceURL + ";" + _webServiceCertificationName + ";" + _proxy + ";logging";
        }

        /// <summary>
        /// Create a new user in the identity database to test against
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            if (!_userCreated)
            {
                _webService = new IdentityServicesImplService(_webServiceURL);
                if (_webServiceCertificationName.Length > 0)
                {
                    X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                    store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                    _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0];
                    _webService.ClientCertificates.Add(_certificate);
                }

                if (_proxy.Length > 0)
                {
                    _webService.Proxy = new WebProxy(_proxy);
                }

                CookieContainer container = new CookieContainer();
                _webService.CookieContainer = container;

                List<attribute> attributes;
                List<personalAttribute> personalAttributes;

                bool setUserAgreedToTermsAndConditions = true;

                if (setUserAgreedToTermsAndConditions)
                {
                    AddUserAttributes(out attributes, out personalAttributes, true);
                    RegisterUser(attributes, personalAttributes, _uriPolicy);
                }
                else
                {
                    AddUserAttributes(out attributes, out personalAttributes, false);
                    RegisterUser(attributes, personalAttributes, null);
                }

                _userCreated = true;

                Console.WriteLine("\n\n*** New Identity User ***");
                Console.WriteLine("User name - " + _userName);
                Console.WriteLine("Password - " + _password);
                Console.WriteLine("Cookie - " + _ValidIdentityCookie);
                if (_IdentityServerIdCookie != null)
                {
                    Console.WriteLine("X-Cookie - " + _IdentityServerIdCookie.Value);
                }
                Console.WriteLine("*** New Identity User ***\n\n");

                string ecookie = HttpUtility.UrlEncode(_ValidIdentityCookie);
                _identityUserCookie = new Cookie("IDENTITY", ecookie, "/", ".bbc.co.uk");
            }
        }

        private void RegisterUser(List<attribute> attributes, List<personalAttribute> personalAttributes, string policy)
        {
            try
            {
                _userToken = _webService.register(_appToken, attributes.ToArray(), personalAttributes.ToArray(), policy);
                //_IdentityServerIdCookie = _webService.CookieContainer.GetCookies(new Uri(_IdentityServerBaseUri))["X-Mapping-lbgdeohg"];
                _ValidIdentityCookie = _webService.getCookieValue(_appToken, _userToken, "", null);
                Console.WriteLine("");
            }
            catch (SoapException ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
                throw ex;
            }
        }

        private void AddUserAttributes(out List<attribute> attributes, out List<personalAttribute> personalAttributes, bool agreedTermsAndConditions)
        {
            attributes = new List<attribute>();

            // THe app name is constructed using the base web address and then the sso service name
            _appName = "www.bbc.co.uk/dna/";
            _appName += "blogs";
            _email = "a" + DateTime.Now.Ticks.ToString() + "@b.c";

            /*
             * Identity have not got this in place yet, but should do shortly
             * _appToken = _webService.GetAppToken(_appUri);
             * It should look like a unique string, hence I've used a guid for now
            */
            _appToken = null;

            attribute emailAttrib = new attribute();
            emailAttrib.name = _wsEmailAddress;
            emailAttrib.values = new string[] { _email };
            attributes.Add(emailAttrib);

            attribute agreementAttrib = new attribute();
            agreementAttrib.name = _wsAgreedTerms;
            agreementAttrib.values = new string[] { "1" };
            attributes.Add(agreementAttrib);

            attribute dobAttrib = new attribute();
            dobAttrib.name = _wsDateOfBirth;
            dobAttrib.values = new string[] { _dob };
            attributes.Add(dobAttrib);

            attribute usernameAttrib = new attribute();
            usernameAttrib.name = _wsUserName;
            usernameAttrib.values = new string[] { _userName };
            attributes.Add(usernameAttrib);

            attribute passwordAttrib = new attribute();
            passwordAttrib.name = _wsPassword;
            passwordAttrib.values = new string[] { _password };
            attributes.Add(passwordAttrib);

            attribute emailValidationAttrib = new attribute();
            emailValidationAttrib.name = _wsEmailValidation;
            emailValidationAttrib.values = new string[] { "1" };
            attributes.Add(emailValidationAttrib);

            attribute displayNameAttrib = new attribute();
            displayNameAttrib.name = _wsDisplayName;
            displayNameAttrib.values = new string[] { _displayName };
            attributes.Add(displayNameAttrib);

            personalAttributes = new List<personalAttribute>();
            if (agreedTermsAndConditions)
            {
                personalAttribute houseRulesAttrib = new personalAttribute();
                houseRulesAttrib.name = _wsHouseRules;
                houseRulesAttrib.values = new string[] { "0" };
                houseRulesAttrib.application = "dna";
                personalAttributes.Add(houseRulesAttrib);
            }
        }

        /// <summary>
        /// Tests to make sure that the identity rest interface works for sigining in users
        /// </summary>
        [TestMethod]
        public void TestIdentityRestInterfaceForSigningInUserAndGetAttributes()
        {
            // Create the URL and the Request object
            string identityRestCall = string.Format("{0}/idservices/authorization?target_resource={1}", _IdentityServerBaseUri, _uriPolicy);

            List<Cookie> cookies = new List<Cookie>();
            //cookies.Add(_IdentityServerIdCookie);
            Cookie identityName = new Cookie("IDENTITY-USERNAME", _userName + "|123|93837365afe", "/", ".bbc.co.uk");
            cookies.Add(identityName);
            
            HttpWebResponse response = CallRestAPI(identityRestCall, cookies);
            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode, "The response did not come back with 200 OK");

            string returnValue = GetLastResponseAsString(response);
            Assert.AreEqual("<boolean>true</boolean>", returnValue, "The response did not come back with true");

            cookies = new List<Cookie>();
            foreach(Cookie c in response.Cookies)
            {
                cookies.Add(c);
            }

            // Get the user details
            identityRestCall = string.Format("{0}/idservices/users/{1}/attributes", _IdentityServerBaseUri, _userName);
            response = CallRestAPI(identityRestCall,cookies);

            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode, "The response did not come back with 200 OK");

            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(GetLastResponseAsString(response));

            Assert.IsNotNull(xDoc.SelectSingleNode("//"+_wsUserName), "Failed to get the users name");
            Assert.IsNotNull(xDoc.SelectSingleNode("//"+_wsUserID), "Failed to get the users id");
            Assert.IsNotNull(xDoc.SelectSingleNode("//"+_wsEmailAddress), "Failed to get the users email address");
            Assert.IsNotNull(xDoc.SelectSingleNode("//"+_wsDisplayName), "Failed to get the users display name");

            Assert.IsTrue(xDoc.SelectSingleNode("//" + _wsUserName).InnerText == _userName, "Failed to get the users name");
            Assert.IsTrue(xDoc.SelectSingleNode("//" + _wsEmailAddress).InnerText == _email, "Failed to get the users email address");
            Assert.IsTrue(xDoc.SelectSingleNode("//" + _wsDisplayName).InnerText == _displayName, "Failed to get the users display name");

            Assert.IsTrue(true);
        }

        /// <summary>
        /// Create a request object to call the identity rest interface
        /// </summary>
        /// <param name="identityRestCall">The Uri to request</param>
        /// <param name="cookies">The cookies to be set for the request</param>
        /// <returns>The response from the request</returns>
        private HttpWebResponse CallRestAPI(string identityRestCall, List<Cookie> cookies)
        {
            Uri URL = new Uri(identityRestCall);

            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            webRequest.Timeout = 1000 * 30;

            webRequest.Proxy = new WebProxy(_proxy);

            webRequest.CookieContainer = new CookieContainer();
            webRequest.CookieContainer.Add(_identityUserCookie);

            if (cookies != null)
            {
                foreach (Cookie c in cookies)
                {
                    webRequest.CookieContainer.Add(c);
                }
            }

            X509Store store = new X509Store("My", StoreLocation.LocalMachine);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
            X509Certificate _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0];
            webRequest.ClientCertificates.Add(_certificate);

            webRequest.Method = "GET";

            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
                Assert.Fail(error);
            }
            return response;
        }

        /// <summary>
        /// Gets the last response as a string
        /// </summary>
        /// <returns>The response as a string.</returns>
        public string GetLastResponseAsString(HttpWebResponse response)
        {
            // Create a reader from the response stream and return the content
            string responseAsString = "";
            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                responseAsString = reader.ReadToEnd();
            }
            response.Close();
            return responseAsString;
        }

        /// <summary>
        /// Tests the identity authentication code
        /// </summary>
        [TestMethod]
        public void TestAuthenticateWithValidUserNameAndValidPassword()
        {
            token authenticationToken = _webService.authenticate(_appToken, _userName, _password, _uriPolicy);
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");
        }

        /// <summary>
        /// Tests the identity authentication code
        /// </summary>
        [TestMethod]
        public void TestAuthenticateWithInvalidUserNameAndvalidPassword()
        {
            token authenticationToken = null;
            bool invalid = false;
            try
            {
                authenticationToken = _webService.authenticate(_appToken, "RandomUser", _password, _uriPolicy);
            }
            catch (SoapException ex)
            {
                Console.WriteLine("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
                invalid = true;
            }
            Assert.IsTrue(invalid);
            Assert.IsNull(authenticationToken, "Authentication token should be null!");
        }

        /// <summary>
        /// Tests the identity authentication code
        /// </summary>
        [TestMethod]
        public void TestAuthenticateWithValidUserNameAndInvalidPassword()
        {
            bool invalid = false;
            token authenticationToken = null;
            try
            {
                authenticationToken = _webService.authenticate(_appToken, _userName, "invalidpassword", _uriPolicy);
            }
            catch (SoapException ex)
            {
                Console.WriteLine("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
                invalid = true;
            }
            Assert.IsTrue(invalid);
            Assert.IsNull(authenticationToken, "Authentication token should be null!");
        }

        /// <summary>
        /// Tests the identity authentication code
        /// </summary>
        [TestMethod]
        public void TestAuthenticateWithInvalidCookie()
        {
            bool invalid = false;
            token authenticationToken = null;
            try
            {
                authenticationToken = _webService.authenticateCookieValue(_appToken, "INVALIDCOOKIE!!!");
            }
            catch (SoapException ex)
            {
                Console.WriteLine("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
                invalid = true;
            }
            Assert.IsTrue(invalid);
            Assert.IsNull(authenticationToken, "Authentication token should be null!");
        }

        /// <summary>
        /// Tests the identity authentication code
        /// </summary>
        [TestMethod]
        public void TestAuthenticateWithValidCookie()
        {
            token authenticationToken = null;
            try
            {
                authenticationToken = _webService.authenticateCookieValue(_appToken, _ValidIdentityCookie);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");
        }

        /// <summary>
        /// Tests the identity authorization code
        /// </summary>
        [TestMethod]
        public void TestAuthorizeWithValidCookieAndPolicy()
        {
            token authenticationToken = null;
            CookieCollection cookies = null;
            Uri testUri = new Uri(_webServiceURL);
            try
            {
                cookies = _webService.CookieContainer.GetCookies(testUri);
                //Console.WriteLine("before authenticate - " + cookies["X-Mapping-lbgdeohg"].Value);
                authenticationToken = _webService.authenticateCookieValue(_appToken, _ValidIdentityCookie);
                cookies = _webService.CookieContainer.GetCookies(testUri);
                //Console.WriteLine("After authenticate - " + cookies["X-Mapping-lbgdeohg"].Value);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");

            bool authorized = false;
            try
            {
                authorized = _webService.authorize(_appToken, _uriPolicy, "GET", authenticationToken);
                cookies = _webService.CookieContainer.GetCookies(testUri);
                //Console.WriteLine("After authorize - " + cookies["X-Mapping-lbgdeohg"].Value);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authorize - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsTrue(authorized, "Failed to authorize valid user");
        }

        /// <summary>
        /// Time to see what the avg response time is for 500 call to authenticate and authorize
        /// </summary>
        [Ignore]
        public void TimeAuthorizeWithCookie()
        {
            long start = DateTime.Now.Ticks;

            //bool authorized = false;
            //token authenticationToken = null;
            int iterations = 500;
            string[] attributesToFetch = { "username", "email", "firstnames", "lastname", "id", "legacy_user_id" };
            
            Console.WriteLine("Starting " + iterations.ToString() + " requests...");

            IdentityRestSignIn testRequest = new IdentityRestSignIn(_webIdentityConnectionDetails, "");
            for (int i = 0; i < iterations; i++)
            {
                try
                {
                    //_webService.listPolicyNames(_appToken, null);
                    /*
                    token authenticationToken = _webService.authenticateCookieValue(_appToken, _ValidIdentityCookie);
                    bool authorized = _webService.authorize(_appToken, _uriPolicy, "GET", authenticationToken);
                    _webService.getAttributes(_appToken, attributesToFetch, authenticationToken);
                    */
                    if (!testRequest.TrySetUserViaCookieAndUserName(_identityUserCookie.Value, _userName + "|123|93837365afe"))
                    {
                        Console.Write("!");
                    }
                }
                catch (SoapException ex)
                {
                    Assert.Fail("(" + i + ") Failed to Authorize - " + ex.Message);
                    Console.WriteLine("(" + i + ")" + ex.Detail.InnerXml);
                }
                catch (HttpException e)
                {
                    Assert.Fail("(" + i + ") Failed to Authorize - " + e.Message);
                    Console.WriteLine("(" + i + ")" + e.Message);
                }

                if (i % 10 == 0)
                {
                    Console.Write(i.ToString() + ".");
                    if (i % 100 == 0)
                    {
                        Console.WriteLine("");
                    }
                }
            }

            long end = DateTime.Now.Ticks;
            TimeSpan total = new TimeSpan(end - start);
            Console.WriteLine("");
            Console.WriteLine("Totals : Tick count = {0}, Seconds = {1}, milliseconds = {2}", end - start, total.TotalSeconds, total.TotalMilliseconds);
            Console.WriteLine("Avg time for {0} calls to authenticate and authorize = {1} milliseconds.", iterations, (1.0 * total.TotalMilliseconds) / iterations);
        }


        /// <summary>
        /// Tests the identity authorization code
        /// </summary>
        [Ignore] // This test is now being ignored as invalid policies are meant to pass ok according to Identity!!!! I don't agree!
        public void TestAuthorizeWithValidCookieAndInvalidPolicy()
        {
            token authenticationToken = null;
            try
            {
                authenticationToken = _webService.authenticateCookieValue(_appToken, _ValidIdentityCookie);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");

            bool authorized = false;
            try
            {
                authorized = _webService.authorize(_appToken, "/dodgy/policy.com", "POST", authenticationToken);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authorize - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsFalse(authorized, "We should of failed the authorization to the dodgy policy");
        }

        /// <summary>
        /// Tests getting the user attributes
        /// </summary>
        [TestMethod]
        public void TestGetUserAttributes()
        {
            token authenticationToken = _webService.authenticate(_appToken, _userName, _password, _uriPolicy);
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");

            userDetails userAttributes = null;
            try
            {
                userAttributes = _webService.getAttributes(_appToken, null, authenticationToken);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Get User Attributes - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }

            Assert.IsNotNull(userAttributes, "No attributes found for the user");
            Assert.AreNotEqual(0, userAttributes.attributes.Length);

            foreach (attribute attrib in userAttributes.attributes)
            {
                if (attrib.name == _wsDateOfBirth)
                {
                    Assert.AreEqual(_dob, attrib.values[0]);
                }
                else if (attrib.name == _wsUserID)
                {
                    Assert.IsTrue(Convert.ToInt32(attrib.values[0]) > 0);
                }
                else if (attrib.name == _wsUserName)
                {
                    Assert.AreEqual(_userName, attrib.values[0]);
                }
                else if (attrib.name == _wsEmailAddress)
                {
                    Assert.AreEqual(_email, attrib.values[0]);
                }
            }
        }

        /// <summary>
        /// Tests the dna wrapper for the identity webservice
        /// </summary>
        [TestMethod]
        public void TestDnaIdentityWrapperClass()
        {
            DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy testProxy = new DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy(_webIdentityConnectionDetails, "Me Testing");
            testProxy.SetIdentityServerCookie(new Cookie("X-Forwarded-For-Identity","hohoho","",""));
            testProxy.SetService(_uriPolicy);
            Assert.IsTrue(testProxy.TrySetUserViaUserNamePassword(_userName, _password), "Failed to set user via username and password");
            Assert.IsTrue(testProxy.IsUserLoggedIn, "User is not logged in");
            Assert.IsTrue(testProxy.UserID > 0, "User has no user id");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("h2g2", "email"), "User has no email address");
            Assert.IsTrue(testProxy.GetUserAttribute("email") == _email, "User has no email address");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("h2g2", "username"), "User has no name");
            Assert.IsTrue(testProxy.GetUserAttribute("username") == _userName, "User has no name");

            string cookie = testProxy.GetCookieValue;
            Assert.IsTrue(cookie.Length > 0, "User has no cookie");
            Console.WriteLine("Cookie value = " + cookie);

            Assert.IsTrue(testProxy.TrySetUserViaCookie(cookie), "Failed to set user via cookie");
            Assert.IsTrue(testProxy.IsUserLoggedIn, "User is not logged in");
            Assert.IsTrue(testProxy.UserID > 0, "User has no user id");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("h2g2", "email"), "User has no email address");
            Assert.IsTrue(testProxy.GetUserAttribute("email") == _email, "User has no email address");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("h2g2", "username"), "User has no name");
            Assert.IsTrue(testProxy.GetUserAttribute("username") == _userName, "User has no name");

            cookie = testProxy.GetCookieValue;
            Assert.IsTrue(cookie.Length > 0, "User has no cookie");
            Console.WriteLine("Cookie value = " + cookie);
        }

        /// <summary>
        /// Tests the dna wrapper for the identity webservice
        /// </summary>
        [TestMethod]
        public void TestDnaIdentityRestWrapperClassSignInUser()
        {
            IdentityRestSignIn testRequest = new IdentityRestSignIn(_webIdentityConnectionDetails, "127.0.0.1");
            testRequest.SetService(_uriPolicy);
            Assert.IsTrue(testRequest.TrySetUserViaCookieAndUserName(_identityUserCookie.Value, _userName + "|123|93837365afe"), "Failed to signin user via username and cookie");
            Assert.IsTrue(testRequest.LoginName == _displayName, "Failed to get the users loginname");
            Assert.IsTrue(testRequest.GetUserAttribute("email") == _email, "Failed to get the users email");
        }

        /// <summary>
        /// Tests the dna wrapper for the identity webservice
        /// </summary>
        [TestMethod]
        public void TestDnaIdentityRestWrapperClassGetPolicies()
        {
            IdentityRestSignIn testRequest = new IdentityRestSignIn(_webIdentityConnectionDetails, "127.0.0.1");
            Assert.IsTrue(testRequest.GetDnaPolicies() != null, "Failed to get the policies!");
            Assert.IsTrue(testRequest.GetDnaPolicies().Length > 0, "No policies found!");
        }
        
        /// <summary>
        /// Check to make sure that we get the correct XML back when we get a dna page using identity login
        /// for a dot net page
        /// </summary>
        [TestMethod]
        public void RequestDNAPageUsingIdentityLoginForDotNetPage()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.UseIdentitySignIn = true;
            request.CurrentSSO2Cookie = _ValidIdentityCookie;
            //request.AddCookie(_IdentityServerIdCookie);

            Cookie identityName = new Cookie("IDENTITY-USERNAME", _userName + "|123|93837365afe");
            request.AddCookie(identityName);

            request.RequestPage("hierarchy?skin=purexml");

            XmlDocument xDoc = request.GetLastResponseAsXML();
            
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER"), "No viewing user");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY"), "No Identity tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE"), "No Cookie tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"], "No plain version of the cookie present");
            Console.WriteLine("Plain cookie value - " + xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"].Value);
        }

        /// <summary>
        /// Check to make sure that we get the correct XML back when we get a dna page using identity login
        /// for a ripley page
        /// </summary>
        [TestMethod]
        public void RequestDNAPageUsingIdentityLoginForRipleyPage()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.UseIdentitySignIn = true;
            request.CurrentSSO2Cookie = _ValidIdentityCookie;
            //request.AddCookie(_IdentityServerIdCookie);

            Cookie identityName = new Cookie("IDENTITY-USERNAME", _userName + "|123|93837365afe");
            request.AddCookie(identityName);

            request.RequestPage("?skin=purexml&__ip__=TestingFromCPP&logsignin=1");

            XmlDocument xDoc = request.GetLastResponseAsXML();

            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER"), "No viewing user");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY"), "No Identity tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE"), "No Cookie tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"], "No plain version of the cookie present");
            Console.WriteLine("Plain cookie value - " + xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"].Value);
        }

        /// <summary>
        /// Check to make sure that we can log a user in via direct call to IdentityProxy, Dna wrapper and URL Request
        /// </summary>
        [TestMethod]
        public void SignInUserUsingAtAllLevels()
        {
            // Call the Identity Proxy directly
            token authenticationToken = null;
            try
            {
                authenticationToken = _webService.authenticateCookieValue(_appToken, _ValidIdentityCookie);
                Console.WriteLine("User Token = " + authenticationToken.id);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authenticate - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsNotNull(authenticationToken, "Authentication token should not be null!");
            Assert.AreNotEqual(String.Empty,authenticationToken.ToString(), "Authentication token was empty!");

            bool authorized = false;
            try
            {
                authorized = _webService.authorize(_appToken, _uriPolicy, "GET", authenticationToken);
            }
            catch (SoapException ex)
            {
                Assert.Fail("Failed to Authorize - " + ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
            }
            Assert.IsTrue(authorized, "Failed to authorize valid user");

            // Call the DNA Warpper object
            DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy testProxy = new DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy(_webIdentityConnectionDetails, "Test ip address");
            //testProxy.SetIdentityServerCookie(_IdentityServerIdCookie);
            testProxy.SetService(_uriPolicy);
            Assert.IsTrue(testProxy.TrySetUserViaCookie(_ValidIdentityCookie), "Failed to set user via cookie");
            Assert.IsTrue(testProxy.IsUserLoggedIn, "User is not logged in");
            Assert.IsTrue(testProxy.UserID > 0, "User has no user id");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("identity606", "email"), "User has no email address");
            Assert.IsTrue(testProxy.GetUserAttribute("email") == _email, "User has no email address");
            Assert.IsTrue(testProxy.DoesAttributeExistForService("identity606", "username"), "User has no name");
            Assert.IsTrue(testProxy.GetUserAttribute("username") == _userName, "User has no name");

            // Now do a Request to the .Net
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.CurrentSSO2Cookie = _ValidIdentityCookie;
            request.UseIdentitySignIn = true;
            //request.AddCookie(_IdentityServerIdCookie);

            Cookie identityName = new Cookie("IDENTITY-USERNAME", _userName + "|123|93837365afe");
            request.AddCookie(identityName);

            request.RequestPage("hierarchy?skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();

            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER"), "No viewing user");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY"), "No Identity tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE"), "No Cookie tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"], "No plain version of the cookie present");
            Console.WriteLine("Plain cookie value - " + xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"].Value);
        }

        /// <summary>
        /// Sets the given personal attribute for a given identity user account
        /// </summary>
        [Ignore]
        public void SetUserPersonalAttribute()
        {
            token userToken = _webService.authenticate(_appToken, "iamtester", "123456789", _uriPolicy);
            if (userToken != null)
            {
                List<personalAttribute> personalAttributes = new List<personalAttribute>();
                personalAttribute houseRulesAttrib = new personalAttribute();
                houseRulesAttrib.name = _wsHouseRules;
                houseRulesAttrib.values = new string[] { "1" };
                houseRulesAttrib.application = "dna";
                personalAttributes.Add(houseRulesAttrib);

                try
                {
                    personalDetails details = _webService.getPersonalAttributes(_appToken, null, null, userToken);
                    details = _webService.setPersonalAttributes(_appToken, null, personalAttributes.ToArray(), _uriPolicy, userToken);
                    Console.WriteLine(details.token.id);
                }
                catch (SoapException ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
        }

        /// <summary>
        /// Tests to make sure that we get the dna policies from Identity
        /// </summary>
        [TestMethod]
        public void TestGetDnaPolicies()
        {
            DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy testProxy = new DnaIdentityWebServiceProxy.DnaIdentityWebServiceProxy(_webIdentityConnectionDetails, "");
            string[] policies = testProxy.GetDnaPolicies();
            Assert.IsNotNull(policies, "Failed to get the dna policies");
            foreach (string s in policies)
            {
                Console.WriteLine(s);
            }
        }
    }
}
