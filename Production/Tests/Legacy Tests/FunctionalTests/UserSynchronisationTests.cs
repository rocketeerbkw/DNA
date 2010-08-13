using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Data;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;
using System.Text;





namespace FunctionalTests
{
    [TestClass]
    public class UserSynchronisationTests
    {
        private string _userName = "testers";
        private string _password = "123456789";
        private string _dob = "1989-12-31";
        private string _14YearsOld = string.Format("{0:yyyy-MM-dd}", DateTime.Now.AddYears(-14));
        private string _displayName = "Good old tester i-Ā-å-p";
        private string _cppDisplayName = "Good old tester i-A-�-p";
        //private string _displayName = "Good old tester!";
        private string _email = "a@b.com";
        private Cookie _cookie;
        private Cookie _secureCookie;

        private string _firstName = "Donald";
        private string _lastName = "Duck";
        private string _newEmail = "";

        [TestInitialize]
        public void Setup()
        {
            // Create a unique name and email for the test
            _userName = "testers" + DateTime.Now.Ticks.ToString();
            _email = _userName + "@bbc.co.uk";
            _newEmail = _userName + "new@bbc.co.uk";
        }

        [TestCleanup]
        public void TearDown()
        {
            SnapshotInitialisation.ForceRestore();
            if (_cookie != null)
            {
                Assert.IsTrue(TestUserCreator.DeleteIdentityUser(_cookie, _userName));
                _cookie = null;
            }
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaBBCDnaWithoutDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, "", _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaBBCDnaWithDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
        }
        
        [TestMethod]
        public void SyncUserDetailsViaBBCDna()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("status-n?skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/FIRSTNAME"), "There shouldn't be a first name");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/LASTNAME"), "There shouldn't be a last name");
            Thread.Sleep(2000);

            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, _displayName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.FirstName, _firstName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.LastName, _lastName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.Email, _newEmail));
            
            request.RequestPage("status-n?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaBBCDnaWithoutDisplayNameAndThenUpdateDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, "", _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Thread.Sleep(2000);

            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, _displayName));
            
            request.RequestPage("status-n?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE LoginName = '" + _userName + "'";
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(_displayName, reader.GetString("username"));
            }
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaBBCDnaWithDisplayNameAndThenUpdatingDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Thread.Sleep(2000);

            string newName = _displayName + " Updated!";
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, newName));
            
            request.RequestPage("status-n?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(newName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE LoginName = '" + _userName + "'";
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(newName, reader.GetString("username"));
            }
        }

        [Ignore]
        public void CheckMigratedUserDetailsViaBBCDna()
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE UserID = " + TestUserAccounts.GetNormalUserAccount.UserID;
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(TestUserAccounts.GetNormalUserAccount.UserName, reader.GetString("username"));
            }

            string identityUserID;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _dob, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, TestUserAccounts.GetNormalUserAccount.UserID, out _cookie, out _secureCookie, out identityUserID), "Failed to create test identity user");
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAs(_userName, _password, TestUserAccounts.GetNormalUserAccount.UserID, _cookie.Value, true);
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE UserID = " + TestUserAccounts.GetNormalUserAccount.UserID;
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(_displayName, reader.GetString("username"));
                Assert.AreEqual(_userName, reader.GetString("loginname"));
            }
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaRipleyWithoutDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, "", _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            request.RequestPage("?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaRipleyWithDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            request.RequestPage("?skin=purexml");

            int i = request.CurrentUserID;

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaRipleyWithoutDisplayNameAndThenUpdateDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, "", _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Thread.Sleep(2000);

            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, _displayName));
            
            request.RequestPage("?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE LoginName = '" + _userName + "'";
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                string dbname = reader.GetString("username");
                Assert.AreEqual(_displayName, reader.GetString("username"));
            }
        }

        [TestMethod]
        public void CheckCorrectUserDetailsViaRipleyWithDisplayNameAndThenUpdatingDisplayName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Thread.Sleep(2000);

            string newName = _displayName + " Updated!";
            string newNameCPP = _cppDisplayName + " Updated!";
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, newName));
            request.RequestPage("?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(newNameCPP, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE LoginName = '" + _userName + "'";
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(newName, reader.GetString("username"));
            }
        }

        [Ignore]
        public void CheckMigratedUserDetailsViaRipley()
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE UserID = " + TestUserAccounts.GetNormalUserAccount.UserID;
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(TestUserAccounts.GetNormalUserAccount.UserName, reader.GetString("username"));
            }

            string identityUserID;
            Assert.IsTrue(TestUserCreator.CreateIdentityUser(_userName, _password, _dob, _email, _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, TestUserAccounts.GetNormalUserAccount.UserID, out _cookie, out _secureCookie, out identityUserID), "Failed to create test identity user");
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAs(_userName, _password, TestUserAccounts.GetNormalUserAccount.UserID, _cookie.Value, true);
            request.RequestPage("?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");

            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT * FROM Users WHERE UserID = " + TestUserAccounts.GetNormalUserAccount.UserID;
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(_displayName, reader.GetString("username"));
                Assert.AreEqual(_userName, reader.GetString("loginname"));
            }
        }

        [TestMethod]
        public void SyncUserDetailsViaRipley()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _dob, TestUserCreator.IdentityPolicies.Adult, "identity606", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("?skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/FIRSTNAME"), "There shouldn't be a first name");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/LASTNAME"), "There shouldn't be a last name");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS"), "incorrect email");
            Assert.AreEqual(_email, doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS").InnerText, "incorrect email");
            Thread.Sleep(2000);

            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.DisplayName, _displayName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.FirstName, _firstName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.LastName, _lastName));
            Assert.IsTrue(TestUserCreator.SetIdentityAttribute(_userName, cookie, TestUserCreator.AttributeNames.Email, _newEmail));
            
            request.RequestPage("?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS"), "incorrect email");
            Assert.AreEqual(_newEmail, doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS").InnerText, "incorrect email");
        }

        [TestMethod, Ignore]
        ///TODO CHECK WITH MARK H IF STILL NEEDED
        public void CheckCorrectUserDetailsViaBBCDnaWithNewSSOAccount()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserAs("ultimatetester", "123456789", 0, "34b89e32918c500eba6e575aa1cae216753ff7752853802bb1b76ebdd5e9e9ae00", false);
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.CURRENTSETTINGS);
            request.RequestPage("status-n?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual("ultimatetester", doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
        }

        [TestMethod, Ignore]
        ///TODO CHECK WITH MARK H IF STILL NEEDED
        public void CheckCorrectUserDetailsViaRipleyWithNewSSOAccount()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserAs("ultimatetester", "123456789", 0, "34b89e32918c500eba6e575aa1cae216753ff7752853802bb1b76ebdd5e9e9ae00", false);
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.CURRENTSETTINGS);
            request.RequestPage("?skin=purexml");

            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual("ultimatetester", doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
        }

        [TestMethod]
        public void CBBCUDNG_SyncAutoGenNameFromIdentityViaRipley_DNASiteSuffixMatchesIdentityValue()
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("exec setsiteoption 54,'User','UseSiteSuffix','1'");
                sql.AppendLine("exec setsiteoption 54,'SignIn','UseIdentitySignIn','1'");
                sql.AppendLine("exec setsiteoption 54,'User','AutoGeneratedNames','http://www.stage.bbc.co.uk/udng/'");
                sql.AppendLine("UPDATE Sites SET IdentityPolicy='http://identity/policies/dna/kids' WHERE SiteID=54");
                reader.ExecuteDEBUGONLY(sql.ToString());
            } 
            
            DnaTestURLRequest request = new DnaTestURLRequest("mbcbbc");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _14YearsOld, TestUserCreator.IdentityPolicies.Kids, "mbcbbc", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("signal?action=recache-site&siteid=54&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/FIRSTNAME"), "There shouldn't be a first name");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/LASTNAME"), "There shouldn't be a last name");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS"), "incorrect email");
            Assert.AreEqual(_email, doc.SelectSingleNode("//VIEWING-USER/USER/EMAIL-ADDRESS").InnerText, "incorrect email");
            Assert.IsNull(doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX"), "Site suffix should not exist!");

            Thread.Sleep(5000);
            TestUserCreator.SetAppNamedSpacedAttribute(_userName, cookie, "cbbc_displayname", "This Is My SiteSuffix", "cbbc");

            request.RequestPage("?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_cppDisplayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX"), "Site suffix is not correct");
            Assert.AreEqual("This Is My SiteSuffix", doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX").InnerText, "Site suffix is not correct");
        }

        [TestMethod]
        public void CBBCUDNG_SyncAutoGenNameFromIdentityViaBBCDNA_DNASiteSuffixMatchesIdentityValue()
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("exec setsiteoption 54,'User','UseSiteSuffix','1'");
                sql.AppendLine("exec setsiteoption 54,'SignIn','UseIdentitySignIn','1'");
                sql.AppendLine("exec setsiteoption 54,'User','AutoGeneratedNames','http://www.stage.bbc.co.uk/udng/'");
                sql.AppendLine("UPDATE Sites SET IdentityPolicy='http://identity/policies/dna/kids' WHERE SiteID=54");
                reader.ExecuteDEBUGONLY(sql.ToString());
            } 
            
            DnaTestURLRequest request = new DnaTestURLRequest("mbcbbc");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _14YearsOld, TestUserCreator.IdentityPolicies.Kids, "mbcbbc", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("dnasignal?action=recache-site&siteid=54&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX"), "Site suffix should not exist!");

            Thread.Sleep(5000);
            TestUserCreator.SetAppNamedSpacedAttribute(_userName, cookie, "cbbc_displayname", "This Is My SiteSuffix", "cbbc");

            request.RequestPage("status-n?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX"), "Site suffix is not correct");
            Assert.AreEqual("This Is My SiteSuffix", doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX").InnerText, "Site suffix is not correct");
        }

        [TestMethod]
        public void CBBCUDNG_CheckThatDisplayNameMatchesSiteSuffixCausesBlankSiteSuffixXml()
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("exec setsiteoption 54,'User','UseSiteSuffix','1'");
                sql.AppendLine("exec setsiteoption 54,'SignIn','UseIdentitySignIn','1'");
                sql.AppendLine("exec setsiteoption 54,'User','AutoGeneratedNames','http://www.stage.bbc.co.uk/udng/'");
                sql.AppendLine("UPDATE Sites SET IdentityPolicy='http://identity/policies/dna/kids' WHERE SiteID=54");
                reader.ExecuteDEBUGONLY(sql.ToString());
            }

            DnaTestURLRequest request = new DnaTestURLRequest("mbcbbc");
            request.SetCurrentUserAsNewIdentityUser(_userName, _password, _displayName, _email, _14YearsOld, TestUserCreator.IdentityPolicies.Kids, "mbcbbc", TestUserCreator.UserType.IdentityOnly);
            string cookie = request.CurrentCookie;
            request.RequestPage("dnasignal?action=recache-site&siteid=54&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();

            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX"), "Site suffix should not exist!");

            Thread.Sleep(5000);
            //Set sitesuffix to be same as the username
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("UPDATE Preferences SET SiteSuffix = '" + _userName + "' WHERE siteid = 54 AND userid = " + request.CurrentUserID.ToString());
                reader.ExecuteDEBUGONLY(sql.ToString());
            }

        
            //TestUserCreator.SetAppNamedSpacedAttribute(_userName, cookie, "cbbc_displayname", "This Is My SiteSuffix", "cbbc");

            request.RequestPage("status-n?skin=purexml");

            doc = request.GetLastResponseAsXML();
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME"), "User name is not correct");
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//VIEWING-USER/USER/USERNAME").InnerText, "User name is not correct");
            Assert.IsNotNull(doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME"), "login name is not correct");
            Assert.AreEqual(_userName, doc.SelectSingleNode("//VIEWING-USER/SIGNINNAME").InnerText, "login name is not correct");
            Assert.AreEqual("", doc.SelectSingleNode("//VIEWING-USER/USER/SITESUFFIX").InnerText, "Site suffix should be blank");
        }

 
        //[TestMethod]
        //public void BODGEIT()
        //{
        //    TestUserCreator.SetIdentityAttribute("mpg-h-s", "3253608|mpg-h-s||1259253027862|0|a1a494914cca94a8c1afd1d73aa8e25f442b9f675980:0", TestUserCreator.AttributeNames.FirstName, "I am");
        //    TestUserCreator.SetIdentityAttribute("mpg-h-s", "3253608|mpg-h-s||1259253027862|0|a1a494914cca94a8c1afd1d73aa8e25f442b9f675980:0", TestUserCreator.AttributeNames.LastName, "Tester");
        //}
    }
}
