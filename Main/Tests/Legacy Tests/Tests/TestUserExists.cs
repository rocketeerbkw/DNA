using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// The checks to make sure that all the test user accounts exists in the current database
    /// </summary>
    //[TestClass]
    public class aaTestUserExists
    {
        // the input context to use
        IInputContext _inputContext = null;
        string _siteName = "haveyoursay";
        SiteListTests _siteListTest = null;
        private const string _schemaUri = "H2G2CommentBoxFlat.xsd";

        /// <summary>
        /// The site name property for the tests. This can be used if the test class is used to test other sites
        /// </summary>
        public String SiteName
        {
            get { return _siteName; }
            set { _siteName = value; }
        }

        private int GetIDForSiteName()
        {
            if (_siteListTest == null)
            {
                _siteListTest = new SiteListTests();
            }
            return _siteListTest.GetIDForSiteName(_siteName);
        }

        /// <summary>
        /// Checks to see if the ProfileAPI test user exists
        /// </summary>
        [TestMethod]
        public void CheckProfileAPIUserExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckProfileAPIUserExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.PROFILETEST);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate(); 
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml,"ProfileAPITest");

            Console.WriteLine("After aaTestUserExists - CheckProfileAPIUserExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// Checks to see if the Normal test user exists
        /// </summary>
        [TestMethod]
        public void CheckNormalUserExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckNormalUserExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.NORMALUSER);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml,"DotNetNormalUser");
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerText != "1")
            {
                // Make the user a normal user by setting their status to 1
                SetUserStatus(request.CurrentUserID, 1);
                reRequest = true;
            }

            if (xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Remove the user from all groups for this site as they are not meant to be in any!
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.RemoveUserFromAllGroupsForSite(request.CurrentUserID, GetIDForSiteName());
                reRequest = true;
            }

            if (reRequest)
            {
                request.RequestPage("acs?skin=purexml");
            }

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") == null, "Normal user is in the editors group!");

            Console.WriteLine("After aaTestUserExists - CheckNormalUserExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// Checks to see if the Editor test user exists
        /// </summary>
        [TestMethod]
        public void CheckEditorUserExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckEditorUserExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.EDITOR);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml, "DotNetEditor");

            // Make sure that the editor is not a super user
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerText != "1")
            {
                // Make the user a normal user by setting their status to 1
                SetUserStatus(request.CurrentUserID, 1);
                reRequest = true;
            }

            // Make sure that the user is in the editor group
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") == null || xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Add the user to the editors group
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.AddUserToGroup(request.CurrentUserID, GetIDForSiteName(), "editor", true);
                reRequest = true;
            }

            if (reRequest)
            {
                // Re request the page as the information has changed
                request.RequestPage("acs?skin=purexml");
                xml = request.GetLastResponseAsXML();
            }

            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") != null);

            Console.WriteLine("After aaTestUserExists - CheckEditorUserExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// Checks to see if the SuperUser test user exists
        /// </summary>
        [TestMethod]
        public void CheckSuperUserExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckSuperUserExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.SUPERUSER);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml, "DotNetSuperUser");

            // Make sure the user is a super user
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != "2")
            {
                // Make the superusers status 2!
                SetUserStatus(request.CurrentUserID, 2);
                reRequest = true;
            }

            // Make sure the user is in the editors group
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") == null || xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Add the user to the editors group
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.AddUserToGroup(request.CurrentUserID, GetIDForSiteName(), "editor", true);
                reRequest = true;
            }

            // See if we need to re request the information due to database changes
            if (reRequest)
            {
                request.RequestPage("acs?skin=purexml");
                xml = request.GetLastResponseAsXML();
            }

            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "2");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR']") != null);

            Console.WriteLine("After aaTestUserExists - CheckSuperUserExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// This tests to make sure that the moderator user is in the database and has the correct settings
        /// </summary>
        [TestMethod]
        public void CheckModeratorExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckModeratorExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.MODERATOR);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml, "DotNetModerator");
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");

            // Make sure the user is a super user
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != "1")
            {
                // Make the user normal!
                SetUserStatus(request.CurrentUserID, 1);
                reRequest = true;
            }

            // Make sure the user is in the moderators group
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='MODERATOR']") == null || xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Add the user to the editors group
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.AddUserToGroup(request.CurrentUserID, GetIDForSiteName(), "moderator", true);
                reRequest = true;
            }

            // See if we need to re request the information due to database changes
            if (reRequest)
            {
                request.RequestPage("acs?skin=purexml");
                xml = request.GetLastResponseAsXML();
            }

            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='MODERATOR']") != null);

            Console.WriteLine("After aaTestUserExists - CheckModeratorExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// This tests to make sure that the PreMod user is in the database and has the correct settings
        /// </summary>
        [TestMethod]
        public void CheckPreModExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckPreModExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.PREMODUSER);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml, "DotNetPreModUser");
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");

            // Make sure the user is a super user
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != "1")
            {
                // Make the user normal!
                SetUserStatus(request.CurrentUserID, 1);
                reRequest = true;
            }

            // Make sure the user is in the premod user group
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='PREMODERATED']") == null || xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Add the user to the editors group
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.AddUserToGroup(request.CurrentUserID, GetIDForSiteName(), "premoderated", true);
                reRequest = true;
            }

            // See if we need to re request the information due to database changes
            if (reRequest)
            {
                request.RequestPage("acs?skin=purexml");
                xml = request.GetLastResponseAsXML();
            }

            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='PREMODERATED']") != null);

            Console.WriteLine("After aaTestUserExists - CheckPreModExistsAndHasTheCorrectSettings");
        }


        /// <summary>
        /// This tests to make sure that the Notable user is in the database and has the correct settings
        /// </summary>
        [TestMethod]
        public void CheckNotableExistsAndHasTheCorrectSettings()
        {
            Console.WriteLine("Before aaTestUserExists - CheckNotableExistsAndHasTheCorrectSettings");

            // Create a request object
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.NOTABLE);
            request.RequestPage("acs?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml != null);
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != null);
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerXml, "DotNetNotable");
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");

            // Make sure the user is a super user
            bool reRequest = false;
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml != "1")
            {
                // Make the user normal!
                SetUserStatus(request.CurrentUserID, 1);
                reRequest = true;
            }

            // Make sure the user is in the notable group
            if (xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='NOTABLES']") == null || xml.SelectNodes("/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME").Count > 1)
            {
                // Add the user to the editors group
                UserGroupsTests userGroups = new UserGroupsTests();
                userGroups.AddUserToGroup(request.CurrentUserID, GetIDForSiteName(), "notables", true);
                reRequest = true;
            }

            // See if we need to re request the information due to database changes
            if (reRequest)
            {
                request.RequestPage("acs?skin=purexml");
                xml = request.GetLastResponseAsXML();
            }

            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/STATUS").InnerXml, "1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='NOTABLES']") != null);

            Console.WriteLine("After aaTestUserExists - CheckNotableExistsAndHasTheCorrectSettings");
        }

        /// <summary>
        /// Helper function for setting a given users status ( normal = 1, super user = 2 )
        /// </summary>
        /// <param name="userID">The user you want to set the status for</param>
        /// <param name="status">The status you want to set user to</param>
        public void SetUserStatus(int userID, int status)
        {
            // Check to make sure that the status is a valid value
            if (status < 1 || status > 2)
            {
                return;
            }

            // Now set the value for the user
            // Make the superusers status 2!
            try
            {
                if (_inputContext == null)
                {
                    _inputContext = DnaMockery.CreateDatabaseInputContext();
                }
                using (IDnaDataReader dataReader = _inputContext.CreateDnaDataReader("updateuser"))
                {
                    dataReader.AddParameter("userid", userID);
                    dataReader.AddParameter("status", status);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
            }
        }
    }
}
