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
    ///This is a test class for ArticleLocationTest and is intended
    ///to contain all ArticleLocationTest Unit Tests
    ///</summary>
    [TestClass]
    public class ArticleLocationTest
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
        ///A test for ArticleLocation Constructor
        ///</summary>
        [TestMethod]
        public void ArticleLocationXmlTest()
        {
            ArticleLocation locations = new ArticleLocation();
            XmlDocument xml = Serializer.SerializeToXml(locations);

            Assert.IsNotNull(xml.SelectSingleNode("ARTICLELOCATION"));

        }

        /// <summary>
        ///A test for ArticleLocationTest
        ///</summary>
        [TestMethod]
        public void CreateArticleLocationTest()
        {
            int siteId = 1;
            int articleId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupArticleLocationMocks(out mocks, out creator, out reader, 2);

            ArticleLocation locations;

            locations = ArticleLocation.CreateArticleLocationsFromDatabase(creator, articleId, siteId, 0, 20);
            Assert.AreNotEqual(null, locations);

            XmlDocument xml = Serializer.SerializeToXml(locations);
        }

        /// <summary>
        /// Tests if ArticleLocation returns an empty list when there aren't any locations.
        /// </summary>
        [TestMethod]
        public void GetArticleLocation_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            int articleId = 1;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupArticleLocationMocks(out mocks, out creator, out reader, 0);

            ArticleLocation locations;

            // EXECUTE THE TEST
            locations = ArticleLocation.CreateArticleLocationsFromDatabase(creator, articleId, siteId, 0, 20);

            Assert.IsTrue(locations.Locations.Count == 0, "Locations found - should be empty");
        }

        /// <summary>
        /// Tests if CreateArticleLocation actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateArticleLocation_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            int articleId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupArticleLocationMocks(out mocks, out creator, out reader, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleLocation actual = ArticleLocation.CreateArticleLocations(cache, creator, null, articleId, siteId, 0, 20, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateArticleLocation bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateArticleLocation_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            int articleId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupArticleLocationMocks(out mocks, out creator, out reader, 2);

            var locations = mocks.DynamicMock<ArticleLocation>();
            locations.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(locations);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleLocation actual = ArticleLocation.CreateArticleLocations(cache, creator, null, articleId, siteId, 0, 20, ignoreCache);
            Assert.IsNotNull(actual);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_ArticleLocationOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new ArticleLocation()
            {                
                Locations = new List<Location> { LocationTest.CreateLocation()}
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
            var locations = new ArticleLocation();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(ArticleLocation).AssemblyQualifiedName);
            string actual = locations.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test ArticleLocation
        /// </summary>
        /// <returns></returns>
        public static ArticleLocation CreateTestArticleLocation()
        {
            var locations = new ArticleLocation()
            {
                Locations = new List<Location>
                {                   
                    LocationTest.CreateLocation()
                }
            };
            return locations;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateArticleLocation call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateArticleLocation_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupArticleLocationMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(false);
                reader.Stub(x => x.Read()).Return(false);

            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                AddArticleLocationTestDatabaseRows(reader);
            }

            readerCreator.Stub(x => x.CreateDnaDataReader("GetGuideEntryLocation")).Return(reader);

            mocks.ReplayAll();
        }
            
        private void AddArticleLocationTestDatabaseRows(IDnaDataReader reader)
        {
            //Add in locations
            reader.Stub(x => x.GetStringNullAsEmpty("description")).Return("Test Location 1").Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("title")).Return("Test Location 1").Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("locationid")).Return(1).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("ownerid")).Return(1090497224).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(1).Repeat.Once();
            reader.Stub(x => x.GetDateTime("CreatedDate")).Return(DateTime.Now).Repeat.Once();
        }

#endregion
    }
}
