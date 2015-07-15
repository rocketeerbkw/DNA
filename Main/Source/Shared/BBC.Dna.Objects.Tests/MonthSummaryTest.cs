using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using System;
using System.Collections.Generic;
using System.Xml;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for MonthSummaryTest and is intended
    ///to contain all MonthSummaryTest Unit Tests
    ///</summary>
    [TestClass]
    public class MonthSummaryTest
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
        ///A test for MonthSummary Constructor
        ///</summary>
        [TestMethod]
        public void MonthSummaryXmlTest()
        {
            MonthSummary monthSummary = new MonthSummary();
            XmlDocument xml = Serializer.SerializeToXml(monthSummary);
            Assert.IsNotNull(xml.SelectSingleNode("MONTHSUMMARY"));
        }

        /// <summary>
        ///A test for MonthSummaryTest
        ///</summary>
        [TestMethod]
        public void CreateMonthSummaryTest()
        {
            int siteId = 1;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupMonthSummaryMocks(out mocks, out creator, out reader, 2);

            MonthSummary monthSummary;

            monthSummary = MonthSummary.CreateMonthSummaryFromDatabase(creator, siteId);
            Assert.AreNotEqual(null, monthSummary);

            XmlDocument xml = Serializer.SerializeToXml(monthSummary);

        }
        /// <summary>
        /// Tests if MonthSummary returns an empty list when there aren't any articles.
        /// </summary>
        [TestMethod()]
        public void GetMonthSummary_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupMonthSummaryMocks(out mocks, out creator, out reader, 0);

            MonthSummary monthSummary;

            try
            {
                // EXECUTE THE TEST
                monthSummary = MonthSummary.CreateMonthSummaryFromDatabase(creator, 1);
            }
            catch (Exception Ex)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(Ex.Message.Contains("Month summary not found"), true);
            }
        }

        /// <summary>
        /// Tests if CreateMonthSummary actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateMonthSummary_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupMonthSummaryMocks(out mocks, out creator, out reader, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            MonthSummary actual = MonthSummary.CreateMonthSummary(cache, creator, 1, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateMonthSummary bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod()]
        public void CreateMonthSummary_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupMonthSummaryMocks(out mocks, out creator, out reader, 2);

            //MonthSummary monthSummary = MonthSummary.CreateMonthSummaryFromDatabase(creator, 1);

            var monthSummary = mocks.DynamicMock<MonthSummary>();
            monthSummary.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(monthSummary);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            MonthSummary actual = MonthSummary.CreateMonthSummary(cache, creator, 1, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_MonthSummaryOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new MonthSummary()
            {
                GuideEntries = new List<ArticleSummary> { ArticleSummaryTest.CreateArticleSummaryTest() }
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
        /// Tests if CreateMonthSummary atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateMonthSummary_WithDoNotIgnoreCache_CacheIsNotIgnored()
        {

            string monthSummaryCacheKey = "BBC.Dna.Objects.MonthSummary, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|1|";
            DateTime lastUpdated = DateTime.Now;

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateMonthSummary_SetupDefaultMocks(out mocks, out cache, out readerCreator, out viewingUser, out site);

            MonthSummary cachedMonthSummary = CreateTestMonthSummary();
            cachedMonthSummary.LastUpdated = lastUpdated;

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            //cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // simulate the category being in cache
            cache.Stub(x => x.GetData(monthSummaryCacheKey)).Return(cachedMonthSummary);


            // simulate cachegettimeofmostrecentguideentry being called and returning an up to date value
            IDnaDataReader cacheGetMonthSummaryReader = mocks.DynamicMock<IDnaDataReader>();
            cacheGetMonthSummaryReader.Stub(x => x.HasRows).Return(true);
            cacheGetMonthSummaryReader.Stub(x => x.Read()).Return(true);
            cacheGetMonthSummaryReader.Stub(x => x.GetInt32NullAsZero("seconds")).Return(5000);

            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(cacheGetMonthSummaryReader).Constraints(Is.Anything());

            // EXECUTE THE TEST             
            mocks.ReplayAll();
            MonthSummary actual = MonthSummary.CreateMonthSummary(cache, readerCreator, 1);

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(monthSummaryCacheKey), options => options.Repeat.AtLeastOnce());
            Assert.AreSame(cachedMonthSummary, actual);
        }


        /// <summary>
        ///A test for Clone
        ///</summary>
        [TestMethod, Ignore]
        public void CloneTest()
        {
            var target = new MonthSummary
            {
                GuideEntries = new List<ArticleSummary>
                { 
                    ArticleSummaryTest.CreateArticleSummaryTest() 
                }
                ,
                LastUpdated = DateTime.Now
            };
            var actual = (MonthSummary)target.Clone();
            Assert.AreEqual(1, actual.GuideEntries.Count);
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var monthSummary = new MonthSummary();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(MonthSummary).AssemblyQualifiedName);
            string actual = monthSummary.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test MonthSummary
        /// </summary>
        /// <returns></returns>
        public static MonthSummary CreateTestMonthSummary()
        {
            var monthSummary = new MonthSummary()
            {
                GuideEntries = new List<ArticleSummary>
                { 
                    ArticleSummaryTest.CreateArticleSummaryTest() 
                }
            };
            return monthSummary;
        }

        #region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateMonthSummary call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateMonthSummary_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
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

        private void SetupMonthSummaryMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
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
            AddMonthSummaryTestDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("getmonthsummary")).Return(reader);

            mocks.ReplayAll();
        }

        private void AddMonthSummaryTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("type")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();
        }
        #endregion
    }
}
