using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
using System;
using System.Collections.Generic;
using Rhino.Mocks;
using TestUtils.Mocks.Extentions;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using TestUtils;
using BBC.Dna.Sites;
using BBC.Dna.Common;
using BBC.Dna.Users;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for FollowersListTest and is intended
    ///to contain all FollowersListTest Unit Tests
    ///</summary>
    [TestClass]
    public class FollowersListTest
    {
        private TestContext testContextInstance;

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
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for FollowersList Constructor
        ///</summary>
        [TestMethod]
        public void FollowersListXmlTest()
        {
            FollowersList followers = new FollowersList();
            XmlDocument xml = Serializer.SerializeToXml(followers);

            Assert.IsNotNull(xml.SelectSingleNode("FOLLOWERSLIST"));

        }

        /// <summary>
        ///A test for FollowersListTest
        ///</summary>
        [TestMethod]
        public void CreateFollowersListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupFollowersListMocks(out mocks, out creator, out reader, out reader2, 2);

            FollowersList followers;

            followers = FollowersList.CreateFollowersListFromDatabase(creator, identityusername, siteId, 0, 20, false);
            Assert.AreNotEqual(null, followers);

            XmlDocument xml = Serializer.SerializeToXml(followers);
        }

        /// <summary>
        /// Tests if FollowersList returns an empty list when there aren't any followers.
        /// </summary>
        [TestMethod]
        public void GetFollowersList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupFollowersListMocks(out mocks, out creator, out reader, out reader2, 0);

            FollowersList followers;

            // EXECUTE THE TEST
            followers = FollowersList.CreateFollowersListFromDatabase(creator, identityusername, siteId, 0, 20, false);

            Assert.IsTrue(followers.Followers.Count == 0, "Followers found - should be empty");
        }

        /// <summary>
        /// Tests if CreateFollowersList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateFollowersList_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupFollowersListMocks(out mocks, out creator, out reader, out reader2, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            FollowersList actual = FollowersList.CreateFollowersList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateFollowersList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateFollowersList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupFollowersListMocks(out mocks, out creator, out reader, out reader2, 2);

            var followers = mocks.DynamicMock<FollowersList>();
            followers.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(followers);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            FollowersList actual = FollowersList.CreateFollowersList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_FollowersListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new FollowersList()
            {
                Followers = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
            };

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            mocks.ReplayAll();

            Assert.AreEqual(false, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var followers = new FollowersList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(FollowersList).AssemblyQualifiedName);
            string actual = followers.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test FollowersList
        /// </summary>
        /// <returns></returns>
        public static FollowersList CreateTestFollowersList()
        {
            var followers = new FollowersList()
            {
                Followers = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
            };
            return followers;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateFollowersList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateFollowersList_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the response
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupAddFriendMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out ICallingUser viewingUser, out ISite site, out IDnaDataReader reader, out IDnaDataReader reader2)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            site = mocks.DynamicMock<ISite>();
            viewingUser = mocks.DynamicMock<ICallingUser>();
            
            // mock the response
            viewingUser.Stub(x => x.UserID).Return(1090497224);
            viewingUser.Stub(x => x.IsUserA(BBC.Dna.Users.UserTypes.Editor)).Return(false);
            viewingUser.Stub(x => x.IsUserA(BBC.Dna.Users.UserTypes.SuperUser)).Return(false);

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();

            AddFollowersListUserDatabaseRows(reader, "");

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            reader2.Stub(x => x.HasRows).Return(true);
            reader2.Stub(x => x.Read()).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("watchuserjournal")).Return(reader2);
            readerCreator.Stub(x => x.CreateDnaDataReader("deletewatchedusers")).Return(reader2);

            mocks.ReplayAll();
        }

        private void SetupFollowersListMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader, out reader2);

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);
                AddFollowersListUserDatabaseRows(reader, "");

                reader2.Stub(x => x.HasRows).Return(false);
                reader2.Stub(x => x.Read()).Return(false);
            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true);

                AddFollowersListUserDatabaseRows(reader, "");

                AddFollowersListUserDatabaseRows(reader2, "");
                AddFollowersListUserDatabaseRows(reader2, "");

            }
            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("watchingusers")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddFollowersListUserDatabaseRows(IDnaDataReader reader, string suffix)
        {
            reader.Stub(x => x.Exists(suffix + "userID")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "userID")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "userid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "userid")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "IdentityUserID")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "IdentityUserID")).Return("608234").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "LoginName")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "LoginName")).Return("Damnyoureyes").Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "Name")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Name")).Return("name").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Area")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Area")).Return("Editor Area").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Status")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "Status")).Return(2).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "TaxonomyNode")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "TaxonomyNode")).Return(3).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Journal")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "Journal")).Return(4).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Active")).Return(true);
            reader.Stub(x => x.GetBoolean(suffix + "Active")).Return(true).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "SiteSuffix")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "SiteSuffix")).Return("suffix").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Title")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Title")).Return("title").Repeat.Once();
            
        }
#endregion
    }
}
