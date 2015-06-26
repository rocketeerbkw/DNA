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
    ///This is a test class for LinkSubscriptionsListTest and is intended
    ///to contain all LinkSubscriptionsListTest Unit Tests
    ///</summary>
    [TestClass]
    public class LinkSubscriptionsListTest
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
        ///A test for LinkSubscriptionsList Constructor
        ///</summary>
        [TestMethod]
        public void LinkSubscriptionsListXmlTest()
        {
            LinkSubscriptionsList linkSubscriptions = new LinkSubscriptionsList();
            XmlDocument xml = Serializer.SerializeToXml(linkSubscriptions);

            Assert.IsNotNull(xml.SelectSingleNode("LINKSUBSCRIPTIONSLIST"));

        }

        /// <summary>
        ///A test for LinkSubscriptionsListTest
        ///</summary>
        [TestMethod]
        public void CreateLinkSubscriptionsListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupLinkSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            LinkSubscriptionsList linkSubscriptions;

            linkSubscriptions = LinkSubscriptionsList.CreateLinkSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false, false);
            Assert.AreNotEqual(null, linkSubscriptions);

            XmlDocument xml = Serializer.SerializeToXml(linkSubscriptions);
        }

        /// <summary>
        /// Tests if LinkSubscriptionsList returns an empty list when there aren't any linkSubscriptions.
        /// </summary>
        [TestMethod]
        public void GetLinkSubscriptionsList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupLinkSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 0);

            LinkSubscriptionsList linkSubscriptions;

            // EXECUTE THE TEST
            linkSubscriptions = LinkSubscriptionsList.CreateLinkSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false, false);

            Assert.IsTrue(linkSubscriptions.Links.Count == 0, "Links found - should be empty");
        }

        /// <summary>
        /// Tests if CreateLinkSubscriptionsList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateLinkSubscriptionsList_IgnoreCache_CacheIsIgnored()
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

            SetupLinkSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            LinkSubscriptionsList actual = LinkSubscriptionsList.CreateLinkSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateLinkSubscriptionsList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateLinkSubscriptionsList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
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

            SetupLinkSubscriptionsListMocks(out mocks, out creator, out reader, out reader2, 2);

            var linkSubscriptions = mocks.DynamicMock<LinkSubscriptionsList>();
            linkSubscriptions.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(linkSubscriptions);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            LinkSubscriptionsList actual = LinkSubscriptionsList.CreateLinkSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_LinkSubscriptionsListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new LinkSubscriptionsList()
            {
                Links = new List<Link> { LinkTest.CreateLink() } 
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
            var linkSubscriptions = new LinkSubscriptionsList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(LinkSubscriptionsList).AssemblyQualifiedName);
            string actual = linkSubscriptions.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test LinkSubscriptionsList
        /// </summary>
        /// <returns></returns>
        public static LinkSubscriptionsList CreateTestLinkSubscriptionsList()
        {
            var linkSubscriptions = new LinkSubscriptionsList()
            {
                Links = new List<Link> { LinkTest.CreateLink() }
            };
            return linkSubscriptions;
        }

        #region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateLinkSubscriptionsList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateLinkSubscriptionsList_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
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

        private void SetupLinkSubscriptionsListMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2, int rowsToReturn)
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

                AddLinkSubscriptionsListUserDatabaseRows(reader, "");
                AddLinkSubscriptionsListUserDatabaseRows(reader2, "Subscriber");

            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.NextResult()).Return(true);

                AddLinkSubscriptionsListUserDatabaseRows(reader, "");

                AddLinkSubscriptionsListUserDatabaseRows(reader2, "Subscriber");

                AddLinksListTestDatabaseRows(reader2);
                AddLinksListTestDatabaseRows(reader2);
            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getlinksubscriptionlist")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddLinkSubscriptionsListUserDatabaseRows(IDnaDataReader reader, string suffix)
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

        private void AddLinksListTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("destinationtype")).Return("article");
            reader.Stub(x => x.GetStringNullAsEmpty("relationship")).Return("Bookmark");
            reader.Stub(x => x.GetInt32NullAsZero("linkid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("teamid")).Return(12345);
            reader.Stub(x => x.GetInt32NullAsZero("DestinationID")).Return(24088151);
            reader.Stub(x => x.GetTinyIntAsInt("private")).Return(0);

        }

        #endregion
    }
}
