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
    ///This is a test class for LinksListTest and is intended
    ///to contain all LinksListTest Unit Tests
    ///</summary>
    [TestClass]
    public class LinksListTest
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
        ///A test for LinksList Constructor
        ///</summary>
        [TestMethod]
        public void LinksListXmlTest()
        {
            LinksList links = new LinksList();
            XmlDocument xml = Serializer.SerializeToXml(links);

            Assert.IsNotNull(xml.SelectSingleNode("LINKSLIST"));

        }

        /// <summary>
        ///A test for LinksListTest
        ///</summary>
        [TestMethod]
        public void CreateLinksListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupLinksListMocks(out mocks, out creator, out reader, out reader2, 2);

            LinksList links;

            links = LinksList.CreateLinksListFromDatabase(creator, identityusername, siteId, 0, 20, false, false);
            Assert.AreNotEqual(null, links);

            XmlDocument xml = Serializer.SerializeToXml(links);
        }

        /// <summary>
        /// Tests if LinksList returns an empty list when there aren't any links.
        /// </summary>
        [TestMethod]
        public void GetLinksList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupLinksListMocks(out mocks, out creator, out reader, out reader2, 0);

            LinksList links;

            // EXECUTE THE TEST
            links = LinksList.CreateLinksListFromDatabase(creator, identityusername, siteId, 0, 20, false, false);

            Assert.IsTrue(links.Links.Count == 0, "Links found - should be empty");
        }

        /// <summary>
        /// Tests if CreateLinksList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateLinksList_IgnoreCache_CacheIsIgnored()
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

            SetupLinksListMocks(out mocks, out creator, out reader, out reader2, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            LinksList actual = LinksList.CreateLinksList(cache, creator, null, identityusername, siteId, 0, 20, false, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateLinksList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateLinksList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
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

            SetupLinksListMocks(out mocks, out creator, out reader, out reader2, 2);

            var links = mocks.DynamicMock<LinksList>();
            links.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(links);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            LinksList actual = LinksList.CreateLinksList(cache, creator, null, identityusername, siteId, 0, 20, false, false, ignoreCache);
            Assert.IsNotNull(actual);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_LinksListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new LinksList()
            {                
                Links = new List<Link> { LinkTest.CreateLink()}
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
            var links = new LinksList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(LinksList).AssemblyQualifiedName);
            string actual = links.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test LinksList
        /// </summary>
        /// <returns></returns>
        public static LinksList CreateTestLinksList()
        {
            var links = new LinksList()
            {
                Links = new List<Link>
                {                   
                    LinkTest.CreateLink()
                }
            };
            return links;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateLinksList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateLinksList_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
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

        private void SetupLinksListMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2, int rowsToReturn)
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

                AddLinksListUserDatabaseRows(reader);
                AddLinksListUserDatabaseRows(reader2);

            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.NextResult()).Return(true);

                AddLinksListUserDatabaseRows(reader);
                AddLinksListTestDatabaseRows(reader2);

            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getmorelinks")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddLinksListUserDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.Exists("userID")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("userID")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists("userid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("userid")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists("IdentityUserID")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("IdentityUserID")).Return("608234").Repeat.Once();
            reader.Stub(x => x.Exists("LoginName")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("LoginName")).Return("Damnyoureyes").Repeat.Once();

            reader.Stub(x => x.Exists("Name")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("Name")).Return("name").Repeat.Once();
            reader.Stub(x => x.Exists("Area")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("Area")).Return("Editor Area").Repeat.Once();
            reader.Stub(x => x.Exists("Status")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Status")).Return(2).Repeat.Once();
            reader.Stub(x => x.Exists("TaxonomyNode")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("TaxonomyNode")).Return(3).Repeat.Once();
            reader.Stub(x => x.Exists("Journal")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Journal")).Return(4).Repeat.Once();
            reader.Stub(x => x.Exists("Active")).Return(true);
            reader.Stub(x => x.GetBoolean("Active")).Return(true).Repeat.Once();
            reader.Stub(x => x.Exists("SiteSuffix")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("SiteSuffix")).Return("suffix").Repeat.Once();
            reader.Stub(x => x.Exists("Title")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("Title")).Return("title").Repeat.Once();
        }
            
        private void AddLinksListTestDatabaseRows(IDnaDataReader reader)
        {
            //Add in links
            reader.Stub(x => x.GetStringNullAsEmpty("destinationtype")).Return("article").Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("relationship")).Return("Bookmark").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("linkid")).Return(1).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("teamid")).Return(12345).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("DestinationID")).Return(24088151).Repeat.Once();
            reader.Stub(x => x.GetTinyIntAsInt("private")).Return(0).Repeat.Once();
        }

#endregion
    }
}
