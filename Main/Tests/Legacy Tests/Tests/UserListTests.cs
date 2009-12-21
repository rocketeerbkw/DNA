using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using TestUtils;

namespace Tests
{
    /// <summary>
    /// Tests for the UserList class
    /// </summary>
    [TestClass]
    public class UserListTests
    {
        /// <summary>
        /// User
        /// </summary>
        public IInputContext _InputContext;

        /// <summary>
        /// schema
        /// </summary>
        public string _schemaUri = "Users-List.xsd";

        /// <summary>
        /// Constructor for the User Tests to set up the context for the tests
        /// </summary>
        public UserListTests()
        {
            string rootPath = TestConfig.GetConfig().GetRipleyServerPath();
            BBC.Dna.AppContext.OnDnaStartup(rootPath);

            ProfanityFilter.ClearTestData();

            Console.WriteLine("Before RecentSearch - AddRecentSearchTests");

            //Create the mocked _InputContext
            Mockery mock = new Mockery();
            _InputContext = DnaMockery.CreateDatabaseInputContext();

            // Create a mocked site for the context
            ISite mockedSite = DnaMockery.CreateMockedSite(_InputContext, 1, "h2g2", "h2g2", false);
            Stub.On(_InputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.DnaConfig.ConnectionString, null);

            BBC.Dna.User user = new BBC.Dna.User(_InputContext);
            Stub.On(_InputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(_InputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            //Create sub editor group and users
            //create test sub editors
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            TestDataCreator testData = new TestDataCreator(_InputContext);
            int[] userIDs = new int[10];
            Assert.IsTrue(testData.CreateNewUsers(mockedSite.SiteID, ref userIDs), "Test users not created");
            Assert.IsTrue(testData.CreateNewUserGroup(dnaRequest.CurrentUserID, "subs"), "CreateNewUserGroup not created");
            Assert.IsTrue(testData.AddUsersToGroup(userIDs, mockedSite.SiteID, "subs"), "Unable to add users to group not created");


        }

        /// <summary>
        /// Tests CreateNewUsersList
        /// </summary>
        [TestMethod]
        public void Test1UserListClassTest_CreateNewUsersList()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateNewUsersList(10, "YEAR", 10, 0, false, "", _InputContext.CurrentSite.SiteID, 0), "Failed creation of list");

            XmlElement xml = userList.RootElement;
            
            Assert.IsTrue(xml.SelectSingleNode("USER-LIST") != null, "The xml is not generated correctly!!!");
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Tests CreateSubEditorsList
        /// </summary>
        [TestMethod]
        public void Test2UserListClassTest_CreateSubEditorsList()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateSubEditorsList(10, 0), "CreateSubEditorsList failed and returned false");

            Assert.IsTrue(userList.RootElement.SelectSingleNode("USER-LIST") != null, "The xml is not generated correctly!!!");
            DnaXmlValidator validator = new DnaXmlValidator(userList.RootElement.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Tests CreateGroupMembershipList
        /// </summary>
        [TestMethod]
        public void Test3UserListClassTest_CreateGroupMembershipList()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateGroupMembershipList("Subs", 10, 0), "CreateGroupMembershipList failed and returned false");

            XmlElement xml = userList.RootElement;
            Assert.IsTrue(xml.SelectSingleNode("USER-LIST") != null, "The xml is not generated correctly!!!");
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Tests CreateGroupMembershipList
        /// </summary>
        [TestMethod]
        public void Test4UserListClassTest_CreateGroupMembershipList()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateGroupMembershipList("Subs"), "CreateGroupMembershipList(subs) failed and returned false");

            XmlElement xml = userList.RootElement;
            Assert.IsTrue(xml.SelectSingleNode("USER-LIST") != null, "The xml is not generated correctly!!!");
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Tests GetUserIDs
        /// </summary>
        [TestMethod]
        public void Test5UserListClassTest_GetUserIDs()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateNewUsersList(10, "YEAR", 10, 0, false, "", _InputContext.CurrentSite.SiteID, 0), "Failed creation of list");

            int[] userIds = null;
            Assert.IsTrue(userList.GetUserIDs(ref userIds), "GetUserIDs failed to return");
            Assert.IsFalse(userIds == null || userIds.Length == 0, "Incorrect number of users returned");
        }

        /// <summary>
        /// Tests FindUserInList
        /// </summary>
        [TestMethod]
        public void Test6UserListClassTest_FindUserInList()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateNewUsersList(10, "YEAR", 10, 0, false, "", _InputContext.CurrentSite.SiteID, 0), "Failed creation of list");

            int[] userIds = null;
            Assert.IsTrue(userList.GetUserIDs(ref userIds), "GetUserIDs failed to return");
            Assert.IsFalse(userIds == null || userIds.Length == 0, "Incorrect number of users returned");

            Assert.IsTrue(userList.FindUserInList(userIds[0]), "Failed to find user in list");
        }

        /// <summary>
        /// Tests RemoveUser
        /// </summary>
        [TestMethod]
        public void Test7UserListClassTest_RemoveUser()
        {
            UserList userList = new UserList(_InputContext);
            Assert.IsTrue(userList.CreateNewUsersList(10, "YEAR", 10, 0, false, "", _InputContext.CurrentSite.SiteID, 0), "Failed creation of list");

            int[] userIds = null;
            Assert.IsTrue(userList.GetUserIDs(ref userIds), "GetUserIDs failed to return");
            Assert.IsFalse(userIds == null || userIds.Length == 0, "Incorrect number of users returned");
            Assert.IsTrue(userList.RemoveUser(userIds[0]), "RemoveUser failed to return");
            Assert.IsFalse(userList.FindUserInList(userIds[0]), "Found removed user in list");
        }

        /// <summary>
        /// Tests AddCurrentUserToList
        /// </summary>
        [TestMethod]
        public void Test8UserListClassTest_AddCurrentUserToList()
        {
            using (FullInputContext fullinputcontext = new FullInputContext(false))
            {
                fullinputcontext.SetCurrentSite("h2g2");
                fullinputcontext.InitUserFromCookie("44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00");

                UserList userList = new UserList(fullinputcontext);
                Assert.IsTrue(userList.CreateNewUsersList(10, "YEAR", 10, 0, false, "", _InputContext.CurrentSite.SiteID, 0), "Failed creation of list");

                Assert.IsTrue(userList.AddCurrentUserToList(), "RemoveUser failed to return");
                Assert.IsTrue(userList.FindUserInList(fullinputcontext.ViewingUser.UserID), "Failed to find added user in list");
            }
        }
        
    }
}
