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
    ///This is a test class for ArticleListTest and is intended
    ///to contain all ArticleListTest Unit Tests
    ///</summary>
    [TestClass]
    public class ArticleListTest
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
        ///A test for ArticleListTest Constructor
        ///</summary>
        [TestMethod]
        public void ArticleListTestXmlTest()
        {
            ArticleList articlelist = new ArticleList();
            articlelist.Type = ArticleList.ArticleListType.NormalAndApproved;
            XmlDocument xml = Serializer.SerializeToXml(articlelist);

            Assert.IsNotNull(xml.SelectSingleNode("ARTICLELIST"));

        }

        /// <summary>
        ///A test for ArticleListTestTest
        ///</summary>
        [TestMethod]
        public void CreateArticleListTestTest()
        {
            int siteId = 1;
            int dnaUserId = 1090501859;
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleListTestMocks(out mocks, out creator, 2);

            ArticleList articleList;

            articleList = ArticleList.CreateUsersArticleListFromDatabase(creator, dnaUserId, siteId, 0, 20, ArticleList.ArticleListType.NormalAndApproved);
            Assert.AreNotEqual(null, articleList);

            XmlDocument xml = Serializer.SerializeToXml(articleList);
        }

        /// <summary>
        /// Tests if ArticleListTest returns an empty list when there aren't any articleList.
        /// </summary>
        [TestMethod]
        public void GetArticleListTest_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            int dnaUserId = 1090501859;

            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleListTestMocks(out mocks, out creator, 0);

            ArticleList articleList;

            // EXECUTE THE TEST
            articleList = ArticleList.CreateUsersArticleListFromDatabase(creator, dnaUserId, siteId, 0, 20, ArticleList.ArticleListType.NormalAndApproved);

            Assert.IsTrue(articleList.Articles.Count == 0, "Articles found - should be empty");
        }

        /// <summary>
        /// Tests if CreateArticleListTest actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateArticleListTest_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleListTestMocks(out mocks, out creator, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleList actual = ArticleList.CreateUsersArticleList(cache, creator, null, identityusername, siteId, 0, 20, ArticleList.ArticleListType.NormalAndApproved, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateArticleListTest bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateArticleListTest_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleListTestMocks(out mocks, out creator, 2);

            // simulate cachegetarticlelistdate being called and returning an up to date value
            IDnaDataReader cacheArticleListReader = mocks.DynamicMock<IDnaDataReader>();
            cacheArticleListReader.Stub(x => x.HasRows).Return(true);
            cacheArticleListReader.Stub(x => x.Read()).Return(true);
            cacheArticleListReader.Stub(x => x.GetInt32NullAsZero("seconds")).Return(5000);

            creator.Stub(x => x.CreateDnaDataReader("cachegetarticlelistdate")).Return(cacheArticleListReader).Constraints(Is.Anything());
            

            var articleList = mocks.DynamicMock<ArticleList>();
            articleList.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(articleList);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleList actual = ArticleList.CreateUsersArticleList(cache, creator, null, identityusername, siteId, 0, 20, ArticleList.ArticleListType.NormalAndApproved, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_ArticleListTestOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new ArticleList()
            {
                Articles = new List<ArticleSummary> { ArticleSummaryTest.CreateArticleSummaryTest() }
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
            var articleList = new ArticleList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(ArticleList).AssemblyQualifiedName);
            string actual = articleList.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test ArticleListTest
        /// </summary>
        /// <returns></returns>
        public static ArticleList CreateTestArticleListTest()
        {
            var articleList = new ArticleList()
            {
                Articles = new List<ArticleSummary> { ArticleSummaryTest.CreateArticleSummaryTest() }
            };
            return articleList;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateArticleListTest call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateArticleListTest_SetupDefaultMocks(out MockRepository mocks, 
            out ICacheManager cache, 
            out IDnaDataReaderCreator readerCreator, 
            out User viewingUser, 
            out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        private void SetupArticleListTestMocks(out MockRepository mocks, out 
            IDnaDataReaderCreator readerCreator, int rowsToReturn)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            IDnaDataReader reader;
            IDnaDataReader reader2;

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(false);
                reader2.Stub(x => x.Read()).Return(false);

                AddArticleListUserDatabaseRows(reader, "");
            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true).Repeat.Times(rowsToReturn);

                AddArticleListUserDatabaseRows(reader, "");
                AddArticleListTestArticlesDatabaseRows(reader2);

            }
            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("getuserrecententrieswithguidetype")).Return(reader2);
            readerCreator.Stub(x => x.CreateDnaDataReader("getuserrecentapprovedentrieswithguidetype")).Return(reader2);
            readerCreator.Stub(x => x.CreateDnaDataReader("getuserrecentandapprovedentrieswithguidetype")).Return(reader2);                 

            mocks.ReplayAll();
        }

        private void AddArticleListTestArticlesDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(2);

            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("status")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("Count")).Return(83).Repeat.Twice();
            reader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();
            reader.Stub(x => x.GetDateTime("lastupdated")).Return(DateTime.Now).Repeat.Twice();
        }

        private void AddArticleListUserDatabaseRows(IDnaDataReader reader, string suffix)
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
