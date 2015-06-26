using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using BBC.Dna.Utils;

namespace Tests
{
    /// <summary>
    /// Suite of tests for testing the CheckUserNameSet site option.
    /// </summary>
    [TestClass]
    public class CheckUserNameSetSiteOptionTests
    {
        private int _userid = int.MaxValue - 1000;
        private int GetNextUserID
        {
            get { return _userid--; }
        }

        /// <summary>
        /// Make sure the database is in a good state
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            // Force a restore of the database
            SnapshotInitialisation.ForceRestore();
            Statistics.InitialiseIfEmpty(null,false);
        }

        /// <summary>
        /// Check to make sure that the prompt set user name tag in the viewing user block is not visible for a site
        /// that hasn't set the siteoption
        /// </summary>
        [TestMethod]
        public void Test1_CheckPromptSetUserNameNotVisibleOnSiteWithSiteOptionNotSet()
        {
            // Create a mocked input context for the test
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create a profileAPI for the test
            int userID = GetNextUserID;
            IDnaIdentityWebServiceProxy mockedProfileAPI = DnaMockery.CreateMockedProfileConnection(context, userID, "testUser", "BBCUID-Testing", "a@b.c", userID.ToString() + "123456789012345678901234567890abcdefghijklmnopqrstuvwxyz", true);

            // Create a mocked site
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true, "comment");

            // Create the site options for the new mocked site
            SiteOptionList siteOptionList = new SiteOptionList();
            siteOptionList.CreateFromDatabase(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default);
            siteOptionList.SetValueBool(1, "Moderation", "SetNewUsersNickNames", false, DnaMockery.CreateDatabaseReaderCreator(),null);
            siteOptionList.SetValueBool(1, "General", "CheckUserNameSet", false, DnaMockery.CreateDatabaseReaderCreator(), null);

            // Stub the call to the siteoption
            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Create the user
            User testUser = new User(context);
            testUser.CreateUser();

            // Check the XML
            XmlNode userXml = testUser.RootElement.SelectSingleNode("//USER");
            Assert.AreEqual(null, userXml.SelectSingleNode("PROMPTSETUSERNAME"), "The prompt set username should not be pressent in the user xml");
            Assert.AreEqual("U" + testUser.UserID.ToString(), userXml.SelectSingleNode("USERNAME").InnerText, "The username should be set to U" + userID.ToString() + " in the user xml");
        }

        /// <summary>
        /// Check to make sure the prompt set username tag is not pressent in the viewing user block for a
        /// site with the optionset and a user with a valid username
        /// </summary>
        [TestMethod]
        public void Test2_CheckPromptSetUserNameNotVisibleForUserWithValidUserNameWithSiteOptionSet()
        {
            // Create a mocked input context for the test
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create a profileAPI for the test
            int userID = GetNextUserID;
            IDnaIdentityWebServiceProxy mockedProfileAPI = DnaMockery.CreateMockedProfileConnection(context, userID, "testUser", "BBCUID-Testing", "a@b.c", userID.ToString() + "123456789012345678901234567890abcdefghijklmnopqrstuvwxyz", true);

            // Create a mocked site
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true, "comment");

            SiteOptionList siteOptionList = new SiteOptionList();
            siteOptionList.CreateFromDatabase(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default);
            siteOptionList.SetValueBool(1, "Moderation", "SetNewUsersNickNames", true, DnaMockery.CreateDatabaseReaderCreator(), null);
            siteOptionList.SetValueBool(1, "General", "CheckUserNameSet", false, DnaMockery.CreateDatabaseReaderCreator(),null);

            // Stub the call to the siteoption
            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(false));

            // Create the user
            User testUser = new User(context);
            testUser.CreateUser();

            // Check the XML
            XmlNode userXml = testUser.RootElement.SelectSingleNode("//USER");
            Assert.AreEqual(null, userXml.SelectSingleNode("PROMPTSETUSERNAME"), "The prompt set username should not be pressent in the user xml");
            Assert.AreEqual("testUser", userXml.SelectSingleNode("USERNAME").InnerText, "The username should be set to testUser in the user xml");
        }

        /// <summary>
        /// Check to make sure that the prompt set username is pressent in the viewing user block for site
        /// with the siteoption set and a user with a non valid username
        /// </summary>
        [TestMethod]
        public void Test3_CheckPromptSetUserNameVisibleForUserWithNonValidUserNameAndSiteOptionSet()
        {
            // Create a mocked input context for the test
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create a profileAPI for the test
            int userID = GetNextUserID;
            IDnaIdentityWebServiceProxy mockedProfileAPI = DnaMockery.CreateMockedProfileConnection(context, userID, "testUser", "BBCUID-Testing", "a@b.c", userID.ToString() + "123456789012345678901234567890abcdefghijklmnopqrstuvwxyz", true);

            // Create a mocked site
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true, "comment");

            SiteOptionList siteOptionList = new SiteOptionList();
            siteOptionList.CreateFromDatabase(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default);
            siteOptionList.SetValueBool(1, "Moderation", "SetNewUsersNickNames", false, DnaMockery.CreateDatabaseReaderCreator(), null);
            siteOptionList.SetValueBool(1, "General", "CheckUserNameSet", true, DnaMockery.CreateDatabaseReaderCreator(), null);

            IDnaDataReader reader = context.CreateDnaDataReader("getallsiteoptions");
            Stub.On(context).Method("CreateDnaDataReader").With("getallsiteoptions").Will(Return.Value(reader));
            
            // Stub the call to the siteoption
            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "CheckUserNameSet").Will(Return.Value(true));

            // Create the user
            User testUser = new User(context);
            testUser.CreateUser();

            // Check the XML
            XmlNode userXml = testUser.RootElement.SelectSingleNode("//USER");
            Assert.AreEqual("1", userXml.SelectSingleNode("PROMPTSETUSERNAME").InnerText, "The prompt set username should be set to 1 in the user xml");
            Assert.AreEqual("U" + testUser.UserID.ToString(), userXml.SelectSingleNode("USERNAME").InnerText, "The username should be set to U" + userID.ToString() + " in the user xml");
        }
    }
}
