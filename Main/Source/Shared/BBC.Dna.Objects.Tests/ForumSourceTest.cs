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
    ///This is a test class for ForumSourceTest and is intended
    ///to contain all ForumSourceTest Unit Tests
    ///</summary>
    [TestClass]
    public class ForumSourceTest
    {
        private TestContext testContextInstance;
        string _forumSourceCacheKey = "BBC.Dna.Objects.ForumSource, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|1|1|1|";

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
        ///A test for ForumSource Constructor
        ///</summary>
        [TestMethod]
        public void ForumSourceXmlTest()
        {
            ForumSource forumSource = new ForumSource();
            XmlDocument xml = Serializer.SerializeToXml(forumSource);

            Assert.IsNotNull(xml.SelectSingleNode("FORUMSOURCE"));

        }

        /// <summary>
        ///A test for ForumSourceTest
        ///</summary>
        [TestMethod]
        public void CreateForumSourceTest()
        {
            int siteId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache;

            SetupForumSourceMocks(out mocks, out cache, out creator, out reader, 2);

            ForumSource forumSource;

            forumSource = ForumSource.CreateForumSourceFromDatabase(cache, creator, null, 1, 1, siteId, true, false);
            Assert.AreNotEqual(null, forumSource);

            XmlDocument xml = Serializer.SerializeToXml(forumSource);

        }
        /// <summary>
        /// Tests if ForumSource returns an empty list when there aren't any articles.
        /// </summary>
        [TestMethod()]
        public void GetForumSource_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache;

            SetupForumSourceMocks(out mocks, out cache, out creator, out reader, 0);

            ForumSource forumSource;

            try
            {
                // EXECUTE THE TEST
                forumSource = ForumSource.CreateForumSourceFromDatabase(cache, creator, null, 1, 1, 1, true, false);
            }
            catch (Exception Ex)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(Ex.Message.Contains("Month summary not found"), true);
            }
        }

        /// <summary>
        /// Tests if CreateForumSource actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateForumSource_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache;

            SetupForumSourceMocks(out mocks, out cache, out creator, out reader, 2);
            //TODO Should not call the ForumSourceGetData article
            //whether this should force the underlying article to not use the cache??
            cache.Stub(x => x.GetData(_forumSourceCacheKey)).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ForumSource actual = ForumSource.CreateForumSource(cache, creator, null, 1, 1, 1, true, ignoreCache, false);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateForumSource bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod()]
        public void CreateForumSource_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ICacheManager cache;

            SetupForumSourceMocks(out mocks, out cache, out creator, out reader, 2);

            //ForumSource forumSource = ForumSource.CreateForumSourceFromDatabase(creator, 1);
            Article article = ArticleTest.CreateArticle();

            var forumSource = mocks.DynamicMock<ForumSource>();
            forumSource.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);

            cache.Stub(x => x.GetData(_forumSourceCacheKey)).Return(forumSource);


            cache.Stub(x => x.GetData(article.GetCacheKey(0, false))).Return(null);


            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ForumSource actual = ForumSource.CreateForumSource(cache, creator, null, 1, 1, 1, true, ignoreCache, false);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateForumSource atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateForumSource_WithDoNotIgnoreCache_CacheIsNotIgnored()
        {
            DateTime lastUpdated = DateTime.Now;
          
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateForumSource_SetupDefaultMocks(out mocks, out cache, out readerCreator, out viewingUser, out site);
            
            ForumSource cachedForumSource = CreateTestForumSource();
            cachedForumSource.ArticleH2G2Id = 1;

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(cachedForumSource.Article.GetCacheKey(cachedForumSource.Article.EntryId, false))).Return(cachedForumSource.Article);

            // simulate the category being in cache
            cache.Stub(x => x.GetData(_forumSourceCacheKey)).Return(cachedForumSource);


            // simulate cachegettimeofmostrecentguideentry being called and returning an up to date value
            IDnaDataReader cacheGetForumSourceReader = mocks.DynamicMock<IDnaDataReader>();
            cacheGetForumSourceReader.Stub(x => x.HasRows).Return(true);
            cacheGetForumSourceReader.Stub(x => x.Read()).Return(true);
            cacheGetForumSourceReader.Stub(x => x.GetInt32NullAsZero("seconds")).Return(5000);

            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(cacheGetForumSourceReader).Constraints(Is.Anything());

            // EXECUTE THE TEST             
            mocks.ReplayAll();
            ForumSource actual = ForumSource.CreateForumSource(cache, readerCreator, null, 1, 1, 1, true, false, false);

            // VERIFY THE RESULTS
            // we were testing the 'ignoreCache' parameter from the Forum and the Article was NOT ignored
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(_forumSourceCacheKey), options => options.Repeat.AtLeastOnce());
            cache.AssertWasCalled(c => c.GetData(cachedForumSource.Article.GetCacheKey(cachedForumSource.Article.EntryId, false)), options => options.Repeat.AtLeastOnce());
            Assert.AreSame(cachedForumSource, actual);
        }

        /// <summary>
        /// Tests if CreateForumSource atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateForumSourceWithArticle_WithDoNotIgnoreCache_CacheIsNotIgnoredAndArticleNotChecked()
        {
            DateTime lastUpdated = DateTime.Now;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateForumSource_SetupDefaultMocks(out mocks, out cache, out readerCreator, out viewingUser, out site);

            ForumSource cachedForumSource = CreateTestForumSource();
            cachedForumSource.ArticleH2G2Id = 0;

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(cachedForumSource.Article.GetCacheKey(cachedForumSource.Article.EntryId, false))).Return(cachedForumSource.Article);

            // simulate the category being in cache
            cache.Stub(x => x.GetData(_forumSourceCacheKey)).Return(cachedForumSource);


            // simulate cachegettimeofmostrecentguideentry being called and returning an up to date value
            IDnaDataReader cacheGetForumSourceReader = mocks.DynamicMock<IDnaDataReader>();
            cacheGetForumSourceReader.Stub(x => x.HasRows).Return(true);
            cacheGetForumSourceReader.Stub(x => x.Read()).Return(true);
            cacheGetForumSourceReader.Stub(x => x.GetInt32NullAsZero("seconds")).Return(5000);

            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(cacheGetForumSourceReader).Constraints(Is.Anything());

            // EXECUTE THE TEST             
            mocks.ReplayAll();
            ForumSource actual = ForumSource.CreateForumSource(cache, readerCreator, null, 1, 1, 1, true, false, false);

            // VERIFY THE RESULTS
            // we were testing the 'ignoreCache' parameter from the Forum and the Article was NOT ignored
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(_forumSourceCacheKey), options => options.Repeat.AtLeastOnce());
            cache.AssertWasNotCalled(c => c.GetData(cachedForumSource.Article.GetCacheKey(cachedForumSource.Article.EntryId, false)), options => options.Repeat.AtLeastOnce());
            Assert.AreSame(cachedForumSource, actual);
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var forumSource = new ForumSource();
            string expected = string.Format("{0}|0|0|0|", typeof(ForumSource).AssemblyQualifiedName);
            string actual = forumSource.GetCacheKey(0, 0, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test ForumSource
        /// </summary>
        /// <returns></returns>
        public static ForumSource CreateTestForumSource()
        {
            var forumSource = new ForumSource()
            {
                Article = ArticleTest.CreateArticle(),
                AlertInstantly = 0,
            };
            return forumSource;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateForumSource call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateForumSource_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        private static void InitialiseMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupForumSourceMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out cache, out readerCreator, out reader);

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
            AddForumSourceTestDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("getforumsource")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getarticlecomponents2")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getauthorsfromh2g2id")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getrelatedarticles")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getrelatedclubs")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getarticlecrumbtrail")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("GetBookmarkCount")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getforumstyle")).Return(reader);           

            mocks.ReplayAll();
        }

        private void AddForumSourceTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("AlertInstantly")).Return(0).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32("ForumID")).Return(1).Repeat.Twice();

            reader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();

            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            reader.Stub(x => x.GetInt32("Status")).Return(1);
            reader.Stub(x => x.GetTinyIntAsInt("style")).Return(1);
            reader.Stub(x => x.GetString("text")).Return("<GUIDE><BODY>this is an article</BODY></GUIDE>");

            reader.Stub(x => x.GetByteNullAsZero("ModerationStatus")).Return(3);
            reader.Stub(x => x.GetDateTime("DateCreated")).Return(DateTime.Now);
            reader.Stub(x => x.GetDateTime("LastUpdated")).Return(DateTime.Now);
            reader.Stub(x => x.GetInt32("PreProcessed")).Return(0);
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetTinyIntAsInt("Submittable")).Return(1);

            reader.Stub(x => x.GetByteNullAsZero("ModerationStatus")).Return(3);

        }
#endregion
    }
}
