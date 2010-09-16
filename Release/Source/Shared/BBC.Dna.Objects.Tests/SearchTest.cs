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

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for SearchTest and is intended
    ///to contain all SearchTest Unit Tests
    ///</summary>
    [TestClass]
    public class SearchTest
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
        ///A test for SearchTest Constructor
        ///</summary>
        [TestMethod]
        public void SearchTestXmlTest()
        {
            Search search = new Search();
            XmlDocument xml = Serializer.SerializeToXml(search);

            Assert.IsNotNull(xml.SelectSingleNode("SEARCH"));

        }

        /// <summary>
        ///A test for GetSearch API call
        ///</summary>
        [TestMethod]
        public void CreateSearchTest()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupSearchMocks(out mocks, out creator, out reader);

            Search search;

            search = Search.CreateSearchFromDatabase(creator, 1, "Dinosaur", "ARTICLE", true, false, false);
            Assert.AreNotEqual(null, search);

            XmlDocument xml = Serializer.SerializeToXml(search);
        }

        /// <summary>
        /// Tests if Search returns an empty list when there aren't any articles.
        /// </summary>
        [TestMethod()]
        public void GetSearch_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupEmptySearchMocks(out mocks, out creator, out reader);

            Search search;

            try
            {
                // EXECUTE THE TEST
                search = Search.CreateSearchFromDatabase(creator, 1, "Dinosaur", "ARTICLE", true, false, false);
            }
            catch(Exception Ex)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(Ex.Message.Contains("No Search Results found"), true);
            }
        }

        public static Search CreateSearch()
        {
            Search target = new Search()
            {
                RecentSearches = CreateRecentSearches(),
                SearchResults = new SearchResults()
                {
                    SearchTerm = "dinosaur",
                    SafeSearchTerm = "dinosaur",
                    Type = "ARTICLE",
                    Count = 1,
                    More = 1,
                    Skip = 0,
                    ArticleResults = CreateArticleResults()
                },
                Functionality = new Functionality()
                {
                    SearchArticles = new SearchArticles()
                    {
                        Selected = 1,
                        ShowApproved = 1,
                        ShowNormal = 0,
                        ShowSubmitted = 0
                    }, 
                    SearchForums = "",
                    SearchUsers = "" 
                }
            };
            return target;
        }

        public static List<ArticleResult> CreateArticleResults()
        {
            List<ArticleResult> articleResults = new List<ArticleResult>();
            articleResults.Add(new ArticleResult()
            {
                Status = 3,
                Type = 1,
                EntryId = 64992,
                Subject = "Dinosaurs Of The Isle Of Wight: Live From Dinosaur Island",
                H2G2Id = 649929,
                DateCreated = new DateElement(DateTime.Now),
                LastUpdated = new DateElement(DateTime.Now),
                Score = 69,
                SiteId = 1,
                PrimarySite = 1
            });

            return articleResults;
        }

        public static List<SearchTerm> CreateRecentSearches()
        {
            List<SearchTerm> searchTerms = new List<SearchTerm>();
            searchTerms.Add(new SearchTerm()
            { 
                Timestamp = "2001010101T120000",
                Count = 1,
                Name = "Test search",
                Type = "ARTICLE"                 
            });

            return searchTerms;
        }


        private void SetupSearchMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(2);

            AddSearchTestDatabaseRow(reader, 66466, 664661, "Dinosaurs of The Isle of Wight - Live From Dinosaur Island", 1);
            AddSearchTestDatabaseRow(reader, 296918, 2969184, "Dinosaurs of The Isle of Wight", 1);

            readerCreator.Stub(x => x.CreateDnaDataReader("searcharticlesadvanced")).Return(reader);

            mocks.ReplayAll();

        }

        private void SetupEmptySearchMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false) ;

            readerCreator.Stub(x => x.CreateDnaDataReader("searcharticlesadvanced")).Return(reader);

            mocks.ReplayAll();

        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();

        }

        private void AddSearchTestDatabaseRow(IDnaDataReader searchReader, 
                                                int entryId, 
                                                int h2g2Id, 
                                                string subject, 
                                                int siteId)
        {
            searchReader.Stub(x => x.GetInt32NullAsZero("entryid")).Return(entryId).Repeat.Twice();
            searchReader.Stub(x => x.GetInt32NullAsZero("h2g2Id")).Return(h2g2Id).Repeat.Twice();
            searchReader.Stub(x => x.GetInt32NullAsZero("status")).Return(4).Repeat.Twice();
            searchReader.Stub(x => x.GetInt32NullAsZero("type")).Return(1).Repeat.Twice();
            searchReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return(subject).Repeat.Twice();
            searchReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(8).Repeat.Twice();
            searchReader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();
            searchReader.Stub(x => x.GetDateTime("lastupdated")).Return(DateTime.Now).Repeat.Twice();
            searchReader.Stub(x => x.GetOrdinal("score")).Return(66).Repeat.Twice();
            searchReader.Stub(x => x.GetDouble(66)).Return(0.18).Repeat.Twice();
            searchReader.Stub(x => x.DoesFieldExist("siteid")).Return(true).Repeat.Twice();
            searchReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(1).Repeat.Once();            
        }
    }
}
