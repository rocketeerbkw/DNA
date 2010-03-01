using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestUtils;
using System.Net;
using System.Threading;
using System.Diagnostics;

namespace DnaIdentityWebServiceProxy.IntegrationTests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class DnaIdentityWebServiceProxyTests
    {
        public DnaIdentityWebServiceProxyTests()
        {
        }

        private TestContext testContextInstance;

        private string _userName = "testers";
        private string _password = "123456789";
        private string _displayName = "Good old tester";
        private string _email = "a@b.com";
        private Cookie _cookie;
        private string _14YearsOld = string.Format("{0:yyyy-MM-dd}", DateTime.Now.AddYears(-14));
        private string _21YearsOld = string.Format("{0:yyyy-MM-dd}", DateTime.Now.AddYears(-21));
        private string _9YearsOld = string.Format("{0:yyyy-MM-dd}", DateTime.Now.AddYears(-9));
        private int _legacySSOUserID = new Random(Convert.ToInt32(string.Format("{0:MMddhhmmss}",DateTime.Now))).Next();

        private string _connectionDetails = "";
        private string _connectionDetailsIDStage = "https://api.stage.bbc.co.uk/opensso/identityservices/IdentityServices;dna live;http://www-cache.reith.bbc.co.uk:80;logging";
        private string _connectionDetailsIDTest = "https://api.test.bbc.co.uk/opensso/identityservices/IdentityServices;dna;http://www-cache.reith.bbc.co.uk:80;logging";
        private bool _useIDStage = true;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestInitialize()]
        public void MyTestInitialize()
        {
            // Create a unique name and email for the test
            _userName = "testers" + DateTime.Now.Ticks.ToString();
            _email = _userName + "@bbc.co.uk";

            if (_useIDStage)
            {
                _connectionDetails = _connectionDetailsIDStage;
            }
            else
            {
                _connectionDetails = _connectionDetailsIDTest;
                TestUserCreator.SetBaseIdentityURL = "https://api.test.bbc.co.uk/idservices";
            }
        }

        [TestCleanup()]
        public void MyTestCleanup()
        {
            if (_cookie != null)
            {
                Assert.IsTrue(TestUserCreator.DeleteIdentityUser(_cookie, _userName));
                _cookie = null;
            }
        }

        /// <summary>
        /// Test the change that means the user name is extracted from the IDENTITY cookie
        /// instead of being passed into the TrySetUserViaCookieAndUserName(...) Method
        /// </summary>
        [TestMethod]
        public void TrySetUserViaCookieAndUserName_CallTrySetUserWithoutUserNameParam_ExpectAuthorized()
        {
            string blankUserName = "";
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Adult));

            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, blankUserName), "The Adult user should be authorized!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInChildWithAdultPolicy_ExpectNotAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _14YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Kids, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Adult));
            Assert.IsFalse(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The kid user should not be authorized for adult policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInAdultWithKidsPolicy_ExpectNotAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Kids));
            Assert.IsFalse(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The adult user should not be authorized for kids policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInAdultWithSchoolsPolicy_ExpectNotAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Schools));
            Assert.IsFalse(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The adult user should not be authorized for Schools policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInAdultWithOver13Policy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            Assert.IsTrue(TestUserCreator.SetDnaAttribute(_userName, _cookie.Value, TestUserCreator.DnaAttributeNames.AgreedTermsAndConditionsOver13, "1"));
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Over13));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The adult user should be authorized for Over13 policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInChildWithKidsPolicy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _14YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Kids, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Kids));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The kid user should be authorized for kids policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInAdultWithAdultPolicy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _14YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Kids, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Kids));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The kid user should be authorized for kids policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignIn14YearOldWith13OverPolicy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _14YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Over13, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Over13));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The Child user should be authorized for Over13 policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignIn14YearOldWithSchoolsPolicy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _14YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Schools, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Schools));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The Child user should be authorized for Schools policies!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignInAdultWithAgeRangeFlagsetInToKidsPolicy_ExpectAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            Assert.IsTrue(TestUserCreator.SetDnaAttribute(_userName, _cookie.Value, TestUserCreator.DnaAttributeNames.UnderAgeRangeCheck, "1"), "Failed to set the under age range flag");
            Assert.IsTrue(TestUserCreator.SetDnaAttribute(_userName, _cookie.Value, TestUserCreator.DnaAttributeNames.AgreedTermsAndConditionsKids, "1"), "Failed to set the T&Cs for kids policy");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Kids));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The Adult user should be authorized for kids policies when age range check flag is set!");
        }

        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignIn9YearOldWithSchoolsPolicy_ExpectNotAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _9YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Schools, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Schools));
            Assert.IsFalse(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The 9 year old user should not be authorized for Schools policies!");
        }
     
        [TestMethod]
        public void TrySetUserViaCookieAndUserName_SignIn9YearOldWithOver13Policy_ExpectNotAuthorized()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _9YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Kids, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Over13));
            Assert.IsFalse(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The 9 year old user should not be authorized for Over13 policies!");
        }

        [TestMethod]
        public void GetUserAttribute_GetEmail_ExpectedEmail()
        {
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            Assert.AreEqual(_email, signIn.GetUserAttribute("email"), "Email is not the correct");
        }

        [TestMethod]
        public void GetUserAttribute_GetUserName_ExpectedUserName()
        {
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            Assert.AreEqual(_userName, signIn.GetUserAttribute("username"), "UserName is not the correct");
        }

        [TestMethod]
        public void GetUserAttribute_GetDisplayName_ExpectedDisplayName()
        {
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            Assert.AreEqual(_displayName, signIn.GetUserAttribute("displayname"), "Displayname is not the correct");
        }

        [TestMethod]
        public void GetUserAttribute_GetLegacyUserID_ExpectedLegacyUserID()
        {
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            Assert.AreEqual(_legacySSOUserID, Convert.ToInt32(signIn.GetUserAttribute("legacy_user_id")), "Legacy SSO UserID is not the correct");
        }

        [TestMethod]
        public void GetUserAttribute_GetLastUpdatedDateDotNetFormat_ExpectedLastUpdatedDateDotNetFormat()
        {
            DateTime beforeCreation = DateTime.Now.AddSeconds(-10); // Due to the differences in machine clocks, we need to pretend that we've 
                                                                    // waited a few seconds before creating the user. take 10 seconds off the current time.
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            DateTime identityDate;
            DateTime.TryParse( signIn.GetUserAttribute("lastupdated"), out identityDate);
            Assert.IsTrue(identityDate >= beforeCreation, "Last updated date is not the correct");
        }

        [TestMethod]
        public void GetUserAttribute_GetLastUpdatedDateCPPFormat_ExpectedLastUpdatedDateCPPFormat()
        {
            string beforeCreation = string.Format("{0:yyyyMMddHHmmss}", DateTime.Now.AddSeconds(-10));  // Due to the differences in machine clocks, we need to pretend that we've 
                                                                                                        // waited a few seconds before creating the user. take 10 seconds off the current time.
            IDnaIdentityWebServiceProxy signIn = CreateIdentityUserAndAuthorize();
            string identityDate = signIn.GetUserAttribute("lastupdatedcpp"); // 20100204130916
            Assert.IsTrue(Convert.ToInt64(identityDate) > Convert.ToInt64(beforeCreation), "Last updated date is not the correct");
        }

        private IDnaIdentityWebServiceProxy CreateIdentityUserAndAuthorize()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _21YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, _legacySSOUserID, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Adult));
            Assert.IsTrue(signIn.TrySetUserViaCookieAndUserName(_cookie.Value, ""), "The Adult user should be authorized!");
            return signIn;
        }

        [TestMethod]
        public void GetUserAttribute_GetCBBCNameSpacedAutoGenNameAttribute_ExpectedAutoGenNameAttribute()
        {
            int identityUserId = 0;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _9YearsOld, _email, _displayName, true, TestUserCreator.IdentityPolicies.Kids, true, 0, out _cookie, out identityUserId), "Failed to create test identity user");
            IDnaIdentityWebServiceProxy signIn = new IdentityRestSignIn(_connectionDetails, "127.0.0.1");
            signIn.SetService(TestUserCreator.GetPolicyAsString(TestUserCreator.IdentityPolicies.Kids));

            string cbbcNickName = "MickyMouse";

            TestUserCreator.SetAppNamedSpacedAttribute(_userName, _cookie.Value, "cbbc_displayname", cbbcNickName, "cbbc");

            Assert.IsTrue(signIn.DoesAppNameSpacedAttributeExist(_cookie.Value, "cbbc", "cbbc_displayname"), "App namedspaced attribute does not exist or access denied!");
            Trace.WriteLine(signIn.GetLastTimingInfo());
            Assert.AreEqual(cbbcNickName, signIn.GetAppNameSpacedAttribute(_cookie.Value, "cbbc", "cbbc_displayname"), "The requested app named spaced attribute is not the one expected!");
            Trace.WriteLine(signIn.GetLastTimingInfo());
        }
    }
}
