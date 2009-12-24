using System;
using System.Collections.Generic;
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



namespace FunctionalTests
{
    [TestClass]
    public class UserMigrationTests
    {
        private string _wsLegacyUserID = "legacy_user_id";
        private int _legacySSOID = 0;

        private IdentityServicesImplService _webService = null;
        private token _appToken = null;
        private token _userToken = null;
        private string _appName;
        private bool _userCreated = false;

        // Test variables
        private string _ValidIdentityCookie = "";
        private string _userName = "SSOMigratedToIdentityUser";
        private string _password = "123456789";
        private string _dob = "1989-12-31";
        private string _email;

        // Name of the required attributes for the test Policy. These are liable to change
        // so update them here instead of specifing them in the tests.
        // For the latest attribute names use.. http://fmtdev16.national.core.bbc.co.uk:10854/opensso/identity/getrequiredattributes
        private string _wsUserName = "username";
        private string _wsDateOfBirth = "date_of_birth";
        private string _wsPassword = "password";
        private string _wsAgreedTerms = "agreement_accepted_flag";
        private string _wsEmailAddress = "email";
        private string _wsHouseRules = "houserules.adults";
        private string _wsEmailValidation = "email_validation_flag";

        //private string _uriPolicy = "http://identity:80/register";
        private string _uriPolicy = "http://identity:80/policies/dna/adult";

        private X509Certificate _certificate = null;
        private string _proxy = "http://10.152.4.15:80";
        private string _webIdentityConnectionDetails;

        //private string _webServiceCertificationName = "";
        //private string _webServiceURL = "http://fmtdev16.national.core.bbc.co.uk:10854/opensso/identityservices/IdentityServices";

        //private string _webServiceCertificationName = @"dnadevteam";
        //private string _webServiceURL = "https://api.test.bbc.co.uk/opensso/identityservices/IdentityServices";

        private string _webServiceCertificationName = @"dna live";
        private string _webServiceURL = "https://api.stage.bbc.co.uk/opensso/identityservices/IdentityServices";

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
        public UserMigrationTests()
        {
            ServicePointManager.ServerCertificateValidationCallback += AcceptAllCertificatePolicy;
            _webIdentityConnectionDetails = _webServiceURL + ";" + _webServiceCertificationName + ";" + _proxy;
        }

        /// <summary>
        /// Create a new user in the identity database to test against
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            TearDown();
            if (!_userCreated)
            {
                // Setup the unique test email for identity
                _email = "a" + DateTime.Now.Ticks.ToString() + "@b.c";

                // Get the normal SSO User and use the id for the legacy userid
                DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
                request.SetCurrentUserNormal();
                _legacySSOID = request.CurrentUserID;

                // Create the new identity user
                CreateNewIdentityAccountWithLegacySSOID(_legacySSOID);
            }
        }

        /// <summary>
        /// Create a new user in the identity database to test against
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            // Check to make sure that we have created the user first
            // Delete the user via the usertoken.
            IdentityServicesImplService webService = new IdentityServicesImplService(_webServiceURL);
            if (_webServiceCertificationName.Length > 0)
            {
                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                webService.ClientCertificates.Add(store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0]);
            }
            webService.Proxy = new WebProxy(_proxy);

            try
            {
                token authenticationToken = webService.authenticate(_appToken, _userName, _password, _uriPolicy);
                webService.deleteUser(_appToken, authenticationToken, "true");
                Console.WriteLine("Deleted user with token - " + authenticationToken.id);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to delete user - " + ex.Message);
            }
        }

        /// <summary>
        /// Create a new Identity account
        /// </summary>
        private void CreateNewIdentityAccountWithLegacySSOID(int legacyUserID)
        {
            _webService = new IdentityServicesImplService(_webServiceURL);
            if (_webServiceCertificationName.Length > 0)
            {
                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0];
                _webService.ClientCertificates.Add(_certificate);
            }
            _webService.Proxy = new WebProxy(_proxy);
            
            List<attribute> attributes = new List<attribute>();

            // The app name is constructed using the base web address and then the sso service name
            _appName = "www.bbc.co.uk/dna/";
            _appName += "blogs";

            /*
             * Identity have not got this in place yet, but should do shortly
             * _appToken = _webService.GetAppToken(_appUri);
             * It should look like a unique string, hence I've used a guid for now
            */
            _appToken = new token();
            _appToken.id = Guid.NewGuid().ToString();

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

            attribute legacyUserIDAttrib = new attribute();
            legacyUserIDAttrib.name = _wsLegacyUserID;
            legacyUserIDAttrib.values = new string[] { legacyUserID.ToString() };
            attributes.Add(legacyUserIDAttrib);

            attribute emailValidationAttrib = new attribute();
            emailValidationAttrib.name = _wsEmailValidation;
            emailValidationAttrib.values = new string[] { "1" };
            attributes.Add(emailValidationAttrib);

            List<personalAttribute> personalAttributes = new List<personalAttribute>();
            personalAttribute houseRulesAttrib = new personalAttribute();
            houseRulesAttrib.name = _wsHouseRules;
            houseRulesAttrib.values = new string[] { "1" };
            houseRulesAttrib.application = "dna";
            personalAttributes.Add(houseRulesAttrib);

            try
            {
                _userToken = _webService.register(_appToken, attributes.ToArray(), personalAttributes.ToArray(), _uriPolicy);
                _ValidIdentityCookie = _webService.getCookieValue(_appToken, _userToken, "", null);
            }
            catch (SoapException ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.Detail.InnerXml);
                throw ex;
            }
            _userCreated = true;

            Console.WriteLine("\n\n*** New Identity User ***");
            Console.WriteLine("User name - " + _userName);
            Console.WriteLine("Password - " + _password);
            Console.WriteLine("Cookie - " + _ValidIdentityCookie);
            Console.WriteLine("User with token - " + _userToken.id);
            Console.WriteLine("*** New Identity User ***\n\n");
        }

        /// <summary>
        /// Check to make sure that a user that has been migrated from sso to identity has
        /// the same dna userid when posting on sites using sso and identity.
        /// </summary>
        [TestMethod]
        public void TestUserWithMigratedSSOAccountHasSameDNAUserIDForBothIdentityAndSSO()
        {
            // Create a request to dna via the .net code
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.UseIdentitySignIn = true;
            request.CurrentSSO2Cookie = _ValidIdentityCookie;
            request.RequestPage("hierarchy?skin=purexml");

            XmlDocument xDoc = request.GetLastResponseAsXML();
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER"), "No viewing user");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/USER/USERID"), "Failed to find the users user id");
            Assert.AreEqual(_legacySSOID.ToString(), xDoc.SelectSingleNode("//VIEWING-USER/USER/USERID").InnerText, "The userid is not the same as the sso account");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY"), "No Identity tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE"), "No Cookie tags");
            Assert.IsNotNull(xDoc.SelectSingleNode("//VIEWING-USER/IDENTITY/COOKIE").Attributes["PLAIN"], "No plain version of the cookie present");
        }
    }
}
