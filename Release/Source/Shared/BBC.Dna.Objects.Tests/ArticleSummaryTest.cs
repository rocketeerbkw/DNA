using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for ArticleSummaryTest
    /// </summary>
    [TestClass]
    public class ArticleSummaryTest
    {
        private readonly int _test_nodeid = 55;
        private readonly int _test_siteid = 100;
        private readonly string _test_unstrippedname = "the stripped name";
        private readonly string _test_strippedname = "stripped name";

        public ArticleSummaryTest()
        {
            //
            // TODO: Add constructor logic here
            //
        }

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
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        public void GetChildArticles_SetupDefaultMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
        }

        public static ArticleSummary CreateArticleSummaryTest()
        {
            var summary = new ArticleSummary
            {

                DateCreated = new DateElement(DateTime.Now),
                Editor = new UserElement()
                {
                    user = UserTest.CreateTestUser()
                },                
                H2G2ID = 1,
                LastUpdated = new DateElement(DateTime.Now),
                Name = "Test",
                SortOrder = 1,
                Status = new ArticleStatus()
                {
                    Type = 1,
                    Value = "1"
                },
                StrippedName = "StrippedName"
            };
            return summary;
        }

        /// <summary>
        /// Tests if GetChildArticles correctly populates all immediate child properties of the first returned instance in the list
        /// </summary>
        [TestMethod()]
        public void GetChildArticles_WithOneChild_ReturnsValidFirstChild()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildArticles_SetupDefaultMocks(out mocks, out readerCreator);
            DateTime testDate = DateTime.Parse("29/05/2010 12:09:04");
            DateTime utcVersionOfTestDate = DateTime.Parse("29/05/2010 11:09:04");

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getarticlesinhierarchynodeReader = mocks.DynamicMock<IDnaDataReader>();
            getarticlesinhierarchynodeReader.Stub(x => x.HasRows).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("h2g2id")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(123);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("subject")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return(_test_unstrippedname);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("type")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("type")).Return(1);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editor")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editor")).Return(99);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorName")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorName")).Return("name");
            //getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorFirstNames")).Return(true);
            //getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorFirstNames")).Return("First Names");
            //getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorLastName")).Return(true);
            //getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorLastName")).Return("Last Name");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorArea")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorArea")).Return("Editor Area");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorStatus")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorStatus")).Return(2);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorTaxonomyNode")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorTaxonomyNode")).Return(3);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorJournal")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorJournal")).Return(4);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorActive")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetBoolean("editorActive")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorSiteSuffix")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorSiteSuffix")).Return("suffix");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorTitle")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorTitle")).Return("title");            
            getarticlesinhierarchynodeReader.Stub(x => x.GetDateTime("datecreated")).Return(testDate);
            getarticlesinhierarchynodeReader.Stub(x => x.GetDateTime("lastupdated")).Return(testDate);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1);            
            readerCreator.Stub(x => x.CreateDnaDataReader("getarticlesinhierarchynode")).Return(getarticlesinhierarchynodeReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<ArticleSummary> actual = ArticleSummary.GetChildArticles(readerCreator, _test_nodeid, _test_siteid);

            // VERIFY THE RESULTS
            Assert.IsNotNull(actual.First());
            Assert.AreEqual(123, actual.First().H2G2ID);
            Assert.AreEqual(_test_unstrippedname, actual.First().Name);
            Assert.AreEqual(_test_strippedname, actual.First().StrippedName);
            Assert.AreEqual(Article.ArticleType.Article, actual.First().Type);
            Assert.IsNotNull(actual.First().Editor);
            //Assert.AreEqual("First Names", actual.First().Editor.user.FirstNames);
            //Assert.AreEqual("Last Name", actual.First().Editor.user.LastName);
            Assert.AreEqual("Editor Area", actual.First().Editor.user.Area);
            Assert.AreEqual(2, actual.First().Editor.user.Status);
            Assert.AreEqual(3, actual.First().Editor.user.TaxonomyNode);
            Assert.AreEqual(4, actual.First().Editor.user.Journal);
            Assert.AreEqual(true, actual.First().Editor.user.Active);
            Assert.AreEqual("suffix", actual.First().Editor.user.SiteSuffix);
            Assert.AreEqual("title", actual.First().Editor.user.Title);
            Assert.AreEqual(utcVersionOfTestDate.ToString(), actual.First().DateCreated.Date.DateTime.ToString());
            Assert.AreEqual(utcVersionOfTestDate.ToString(), actual.First().LastUpdated.Date.DateTime.ToString());
        }

        /// <summary>
        /// Tests if GetChildArticles returns an empty list when there aren't any articles.
        /// </summary>
        [TestMethod()]
        public void GetChildArticles_WithoutChildren_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildArticles_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getarticlesinhierarchynodeReader = mocks.DynamicMock<IDnaDataReader>();
            getarticlesinhierarchynodeReader.Stub(x => x.HasRows).Return(false);
            getarticlesinhierarchynodeReader.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("getarticlesinhierarchynode")).Return(getarticlesinhierarchynodeReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<ArticleSummary> actual = ArticleSummary.GetChildArticles(readerCreator, _test_nodeid, _test_siteid);

            // VERIFY THE RESULTS
            Assert.AreEqual(actual.Count, 0);
        }

        /// <summary>
        /// Tests if GetChildArticles returns multiple results when it has multiple ancestors
        /// </summary>
        [TestMethod()]
        public void GetChildArticles_WithMultipleAncestors_ReturnsMultipleObjects()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildArticles_SetupDefaultMocks(out mocks, out readerCreator);
            DateTime testDate = DateTime.Parse("29/05/2010 12:09:04");
            DateTime utcVersionOfTestDate = DateTime.Parse("29/05/2010 11:09:04");

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getarticlesinhierarchynodeReader = mocks.DynamicMock<IDnaDataReader>();
            getarticlesinhierarchynodeReader.Stub(x => x.HasRows).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.Read()).Return(true).Repeat.Times(10);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("h2g2id")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(123);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("subject")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return("test subject");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("DisplayName")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return(_test_unstrippedname);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("type")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("type")).Return(1);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editor")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editor")).Return(99);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorName")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorName")).Return("name");
            //getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorFirstNames")).Return(true);
            //getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorFirstNames")).Return("First Names");
            //getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorLastName")).Return(true);
            //getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorLastName")).Return("Last Name");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorArea")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorArea")).Return("Editor Area");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorStatus")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorStatus")).Return(2);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorTaxonomyNode")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorTaxonomyNode")).Return(3);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorJournal")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("editorJournal")).Return(4);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorActive")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetBoolean("editorActive")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorSiteSuffix")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorSiteSuffix")).Return("suffix");
            getarticlesinhierarchynodeReader.Stub(x => x.Exists("editorTitle")).Return(true);
            getarticlesinhierarchynodeReader.Stub(x => x.GetStringNullAsEmpty("editorTitle")).Return("title");
            getarticlesinhierarchynodeReader.Stub(x => x.GetDateTime("datecreated")).Return(testDate);
            getarticlesinhierarchynodeReader.Stub(x => x.GetDateTime("lastupdated")).Return(testDate);
            getarticlesinhierarchynodeReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("getarticlesinhierarchynode")).Return(getarticlesinhierarchynodeReader);


            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<ArticleSummary> actual = ArticleSummary.GetChildArticles(readerCreator, _test_nodeid, _test_siteid);

            // VERIFY THE RESULTS
            Assert.AreEqual(actual.Count, 10);
        }   
        
    }
}




