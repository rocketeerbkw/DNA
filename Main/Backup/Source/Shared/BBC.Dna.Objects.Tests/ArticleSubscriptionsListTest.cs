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
    ///This is a test class for ArticleSubscriptionsListTest and is intended
    ///to contain all ArticleSubscriptionsListTest Unit Tests
    ///</summary>
    [TestClass]
    public class ArticleSubscriptionsListTest
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
        ///A test for ArticleSubscriptionsList Constructor
        ///</summary>
        [TestMethod]
        public void ArticleSubscriptionsListXmlTest()
        {
            ArticleSubscriptionsList articleSubscriptions = new ArticleSubscriptionsList();
            XmlDocument xml = Serializer.SerializeToXml(articleSubscriptions);

            Assert.IsNotNull(xml.SelectSingleNode("ARTICLESUBSCRIPTIONSLIST"));

        }

        /// <summary>
        ///A test for ArticleSubscriptionsListTest
        ///</summary>
        [TestMethod]
        public void CreateArticleSubscriptionsListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleSubscriptionsListMocks(out mocks, out creator, 2);

            ArticleSubscriptionsList articleSubscriptions;

            articleSubscriptions = ArticleSubscriptionsList.CreateArticleSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false);
            Assert.AreNotEqual(null, articleSubscriptions);

            XmlDocument xml = Serializer.SerializeToXml(articleSubscriptions);
        }

        /// <summary>
        /// Tests if ArticleSubscriptionsList returns an empty list when there aren't any articleSubscriptions.
        /// </summary>
        [TestMethod]
        public void GetArticleSubscriptionsList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleSubscriptionsListMocks(out mocks, out creator, 0);

            ArticleSubscriptionsList articleSubscriptions;

            // EXECUTE THE TEST
            articleSubscriptions = ArticleSubscriptionsList.CreateArticleSubscriptionsListFromDatabase(creator, identityusername, siteId, 0, 20, false);

            Assert.IsTrue(articleSubscriptions.Articles.Count == 0, "Articles found - should be empty");
        }

        /// <summary>
        /// Tests if CreateArticleSubscriptionsList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateArticleSubscriptionsList_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleSubscriptionsListMocks(out mocks, out creator, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleSubscriptionsList actual = ArticleSubscriptionsList.CreateArticleSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateArticleSubscriptionsList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateArticleSubscriptionsList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReaderCreator creator;

            SetupArticleSubscriptionsListMocks(out mocks, out creator, 2);

            var articleSubscriptions = mocks.DynamicMock<ArticleSubscriptionsList>();
            articleSubscriptions.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(articleSubscriptions);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            ArticleSubscriptionsList actual = ArticleSubscriptionsList.CreateArticleSubscriptionsList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_ArticleSubscriptionsListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new ArticleSubscriptionsList()
            {
                Articles = new List<Article> { ArticleTest.CreateArticle() }
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
            var articleSubscriptions = new ArticleSubscriptionsList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(ArticleSubscriptionsList).AssemblyQualifiedName);
            string actual = articleSubscriptions.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test ArticleSubscriptionsList
        /// </summary>
        /// <returns></returns>
        public static ArticleSubscriptionsList CreateTestArticleSubscriptionsList()
        {
            var articleSubscriptions = new ArticleSubscriptionsList()
            {
                Articles = new List<Article> { ArticleTest.CreateArticle() }
            };
            return articleSubscriptions;
        }

#region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateArticleSubscriptionsList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateArticleSubscriptionsList_SetupDefaultMocks(out MockRepository mocks, 
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

        private void SetupArticleSubscriptionsListMocks(out MockRepository mocks, out 
            IDnaDataReaderCreator readerCreator, int rowsToReturn)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReader reader3;

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();
            reader3 = mocks.DynamicMock<IDnaDataReader>();

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(false);
                reader2.Stub(x => x.Read()).Return(false);

                AddArticleSubscriptionsListUserDatabaseRows(reader, "");
            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true).Repeat.Times(rowsToReturn);

                AddArticleSubscriptionsListUserDatabaseRows(reader, "");
                AddArticleSubscriptionsListArticlesDatabaseRows(reader2);
                AddArticleSubscriptionsListArticlePageAuthorsDatabaseRows(reader3);

                readerCreator.Stub(x => x.CreateDnaDataReader("getarticlecomponents2")).Return(reader2);
                readerCreator.Stub(x => x.CreateDnaDataReader("getauthorsfromh2g2id")).Return(reader3);
                readerCreator.Stub(x => x.CreateDnaDataReader("getrelatedarticles")).Return(reader2);
                readerCreator.Stub(x => x.CreateDnaDataReader("getrelatedclubs")).Return(reader2);
                readerCreator.Stub(x => x.CreateDnaDataReader("getarticlecrumbtrail")).Return(reader2);
                readerCreator.Stub(x => x.CreateDnaDataReader("GetBookmarkCount")).Return(reader2);
                readerCreator.Stub(x => x.CreateDnaDataReader("getforumstyle")).Return(reader2);
            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getsubscribedarticles")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddArticleSubscriptionsListArticlePageAuthorsDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            //PageAuthor
            reader.Stub(x => x.Exists("UserID")).Return(true);
            reader.Stub(x => x.GetInt32("UserID")).Return(1090497224).Repeat.Once();
        }

        private void AddArticleSubscriptionsListArticlesDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.HasRows).Return(true);

            reader.Stub(x => x.NextResult()).Return(true);

            reader.Stub(x => x.Read()).Return(true).Repeat.Times(2);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            reader.Stub(x => x.GetInt32("EntryID")).Return(73322156);
            reader.Stub(x => x.GetTinyIntAsInt("style")).Return(1);
            reader.Stub(x => x.GetInt32("PreProcessed")).Return(10);
            reader.Stub(x => x.GetString("text")).Return("<GUIDE><BODY>this is an<BR /> article</BODY></GUIDE>");
        }

        private void AddArticleSubscriptionsListUserDatabaseRows(IDnaDataReader reader, string suffix)
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
