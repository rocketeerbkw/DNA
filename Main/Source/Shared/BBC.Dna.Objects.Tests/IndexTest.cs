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
    ///This is a test class for IndexTest and is intended
    ///to contain all IndexTest Unit Tests
    ///</summary>
    [TestClass]
    public class IndexTest
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
        ///A test for Index Constructor
        ///</summary>
        [TestMethod]
        public void IndexXmlTest()
        {
            Index index = new Index();
            XmlDocument xml = Serializer.SerializeToXml(index);

            Assert.IsNotNull(xml.SelectSingleNode("INDEX"));

        }

        /// <summary>
        ///A test for IndexTest
        ///</summary>
        [TestMethod]
        public void CreateIndexTest()
        {
            int siteId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupIndexMocks(out mocks, out creator, out reader, 2);

            Index index;

            index = Index.CreateIndexFromDatabase(creator, siteId, "A", true, false, false, "", 0);
            Assert.AreNotEqual(null, index);

            XmlDocument xml = Serializer.SerializeToXml(index);

        }

        /// <summary>
        ///A test for . IndexTest
        ///</summary>
        [TestMethod]
        public void CreateDotIndexTest()
        {
            int siteId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupIndexMocks(out mocks, out creator, out reader, 2);

            Index index;

            index = Index.CreateIndexFromDatabase(creator, siteId, ".", true, false, false, "", 0);
            Assert.AreNotEqual(null, index);

            XmlDocument xml = Serializer.SerializeToXml(index);

        }


        /// <summary>
        /// Tests if Index returns an empty list when there aren't any articles.
        /// </summary>
        [TestMethod()]
        public void GetIndex_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupIndexMocks(out mocks, out creator, out reader, 0);

            Index index;

            try
            {
                // EXECUTE THE TEST
                index = Index.CreateIndexFromDatabase(creator, 1, "A", true, false, false, "", 0);
            }
            catch (Exception Ex)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(Ex.Message.Contains("Index not found"), true);
            }
        }

        /// <summary>
        /// Tests if CreateIndex actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateIndex_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupIndexMocks(out mocks, out creator, out reader, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            Index actual = Index.CreateIndex(cache, creator, 1, "A", true, false, false, "", 0, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateIndex bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod()]
        public void CreateIndex_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupIndexMocks(out mocks, out creator, out reader, 2);

            var index = mocks.DynamicMock<Index>();
            index.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(index);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            Index actual = Index.CreateIndex(cache, creator, 1, "A", true, false, false, "", 0, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_IndexOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new Index()
            {
                 IndexEntries = new List<ArticleSummary> { ArticleSummaryTest.CreateArticleSummaryTest() } 
            };

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("cachegettimeofmostrecentguideentry")).Return(reader);
            mocks.ReplayAll();

            Assert.AreEqual(false, target.IsUpToDate(creator));
        }

        /// <summary>
        /// Tests if CreateIndex atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateIndex_WithDoNotIgnoreCache_CacheIsNotIgnored()
        {
            string indexCacheKey = "BBC.Dna.Objects.Index, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|1||True|False|False||0|";
            DateTime lastUpdated = DateTime.Now;
          
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateIndex_SetupDefaultMocks(out mocks, out cache, out readerCreator, out viewingUser, out site);
            
            Index cachedIndex = CreateTestIndex();
            cachedIndex.LastUpdated = lastUpdated;

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            //cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // simulate the category being in cache
            cache.Stub(x => x.GetData(indexCacheKey)).Return(cachedIndex);


            // simulate cachegettimeofmostrecentguideentry being called and returning an up to date value
            IDnaDataReader cacheGetIndexReader = mocks.DynamicMock<IDnaDataReader>();
            cacheGetIndexReader.Stub(x => x.HasRows).Return(true);
            cacheGetIndexReader.Stub(x => x.Read()).Return(true);
            cacheGetIndexReader.Stub(x => x.GetInt32NullAsZero("seconds")).Return(5000);

            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(cacheGetIndexReader).Constraints(Is.Anything());

            // EXECUTE THE TEST             
            mocks.ReplayAll();
            Index actual = Index.CreateIndex(cache, readerCreator, 1);

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(indexCacheKey), options => options.Repeat.AtLeastOnce());
            Assert.AreSame(cachedIndex, actual);
        }

        /// <summary>
        ///A test for Clone
        ///</summary>
        [TestMethod, Ignore]
        public void CloneTest()
        {
            var target = new Index
            {
                IndexEntries = new List<ArticleSummary>
                { 
                    ArticleSummaryTest.CreateArticleSummaryTest() 
                }
                , LastUpdated = DateTime.Now
            };
            var actual = (Index)target.Clone();
            Assert.AreEqual(1, actual.IndexEntries.Count);
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var index = new Index();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(Index).AssemblyQualifiedName);
            string actual = index.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test Index
        /// </summary>
        /// <returns></returns>
        public static Index CreateTestIndex()
        {
            var index = new Index()
            {
                IndexEntries = new List<ArticleSummary>
                { 
                    ArticleSummaryTest.CreateArticleSummaryTest() 
                }
            };
            return index;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateIndex call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateIndex_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
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

        private void SetupIndexMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);

            if (rowsToReturn > 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true).Repeat.Times(rowsToReturn);
            }
            else
            {
                reader.Stub(x => x.HasRows).Return(false);
                reader.Stub(x => x.Read()).Return(false);
            }
            AddIndexTestDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("articlesinindex")).Return(reader);

            mocks.ReplayAll();
        }

        private void AddIndexTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("status")).Return(1).Repeat.Twice();

            reader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();
        }
#endregion
    }
}
