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

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for BlockedUserSubscriptionsListTest and is intended
    ///to contain all BlockedUserSubscriptionsList Unit Tests
    ///</summary>
    [TestClass]
    public class BlockedUserSubscriptionsListTest
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
        ///A test for BlockedUserSubscriptionsList Constructor
        ///</summary>
        [TestMethod]
        public void BlockedUserSubscriptionsListXmlTest()
        {
            BlockedUserSubscriptionsList blockedUserSubscriptions = new BlockedUserSubscriptionsList();
            XmlDocument xml = Serializer.SerializeToXml(blockedUserSubscriptions);

            Assert.IsNotNull(xml.SelectSingleNode("BLOCKEDUSERSUBSCRIPTIONSLIST"));

        }

        /// <summary>
        ///A test for BlockedUserSubscriptionsListTest
        ///</summary>
        [TestMethod]
        public void CreateBlockedUserSubscriptionsListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupBlockedUserSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            BlockedUserSubscriptionsList blockedUserSubscriptions;

            blockedUserSubscriptions = BlockedUserSubscriptionsList.CreateBlockedUserSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false);
            Assert.AreNotEqual(null, blockedUserSubscriptions);

            XmlDocument xml = Serializer.SerializeToXml(blockedUserSubscriptions);
        }

        /// <summary>
        /// Tests if BlockedUserSubscriptionsList returns an empty list when there aren't any blockedUserSubscriptions.
        /// </summary>
        [TestMethod]
        public void GetBlockedUserSubscriptionsList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupBlockedUserSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 0);

            BlockedUserSubscriptionsList blockedUserSubscriptions;

            // EXECUTE THE TEST
            blockedUserSubscriptions = BlockedUserSubscriptionsList.CreateBlockedUserSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false);

            Assert.IsTrue(blockedUserSubscriptions.Users.Count == 0, "Users found - should be empty");
        }

        /// <summary>
        /// Tests if CreateBlockedUserSubscriptionsList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateBlockedUserSubscriptionsList_IgnoreCache_CacheIsIgnored()
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

            SetupBlockedUserSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            BlockedUserSubscriptionsList actual = BlockedUserSubscriptionsList.CreateBlockedUserSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateBlockedUserSubscriptionsList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateBlockedUserSubscriptionsList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
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

            SetupBlockedUserSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            var blockedUserSubscriptions = mocks.DynamicMock<BlockedUserSubscriptionsList>();
            blockedUserSubscriptions.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(blockedUserSubscriptions);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            BlockedUserSubscriptionsList actual = BlockedUserSubscriptionsList.CreateBlockedUserSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_BlockedUserSubscriptionsListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new BlockedUserSubscriptionsList()
            {
                Users = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
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
            var blockedUserSubscriptions = new BlockedUserSubscriptionsList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(BlockedUserSubscriptionsList).AssemblyQualifiedName);
            string actual = blockedUserSubscriptions.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test BlockedUserSubscriptionsList
        /// </summary>
        /// <returns></returns>
        public static BlockedUserSubscriptionsList CreateTestBlockedUserSubscriptionsList()
        {
            var blockedUserSubscriptions = new BlockedUserSubscriptionsList()
            {
                Users = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
            };
            return blockedUserSubscriptions;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateBlockedUserSubscriptionsList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateBlockedUserSubscriptionsList_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
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

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupBlockedUserSubscriptionsListMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader, out reader2);

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                //Return the user but no rows
                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true).Repeat.Once();
                reader2.Stub(x => x.Read()).Return(false).Repeat.Once();

                reader2.Stub(x => x.NextResult()).Return(false);

                AddBlockedUserSubscriptionsListUserDatabaseRows(reader, "");
                AddBlockedUserSubscriptionsListUserDatabaseRows(reader2, "Blocker");
                reader.Stub(x => x.GetBoolean("BlockerAcceptSubscriptions")).Return(true).Repeat.Once();

            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.NextResult()).Return(true);

                AddBlockedUserSubscriptionsListUserDatabaseRows(reader, "");

                AddBlockedUserSubscriptionsListUserDatabaseRows(reader2, "Blocker");
                AddBlockedUserSubscriptionsListUserDatabaseRows(reader2, "");
                AddBlockedUserSubscriptionsListUserDatabaseRows(reader2, "");

            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getblockedusersubscriptions")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddBlockedUserSubscriptionsListUserDatabaseRows(IDnaDataReader reader, string suffix)
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
