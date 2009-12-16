using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Tests;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ArticleInfoTest and is intended
    ///to contain all ArticleInfoTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ArticleInfoTest
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
        ///A test for ArticleInfo Constructor
        ///</summary>
        [TestMethod()]
        public void ArticleInfoXmlTest()
        {
            ArticleInfo target = CreateArticleInfo();

            XmlDocument xml = Serializer.SerializeToXml(target);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "articleinfo.xsd");
            validator.Validate();

            //string json = Serializer.SerializeToJson(target);


            
        }

        public static ArticleInfo CreateArticleInfo()
        {
            ArticleInfo target = new ArticleInfo()
            {
                H2g2Id = 1,
                DateCreated = new DateElement(DateTime.Now),
                LastUpdated = new DateElement(DateTime.Now),
                ForumId = 2,
                ModerationStatus = new ModerationStatus() { Id = 1, Value = "2" },
                PageAuthor = ArticleInfoPageAuthorTest.CreatePageAuthor(),
                PreProcessed = 1,
                Site = new ArticleInfoSite() { Id = 1 },
                SiteId = 1,
                Status = new ArticleStatus() { Type = 1, Value = "ok" },
                RelatedMembers = new ArticleInfoRelatedMembers()
                {
                    RelatedArticles = RelatedArticleTest.CreateRelatedArticles(),
                    RelatedClubs = RelatedClubsTest.CreateRelatedClubs()
                },
                CrumbTrails = CrumbTrailsTest.CreateCrumbTrails()
            };
            return target;
        }

        /// <summary>
        ///A test for GetEntryFromDataBase
        ///</summary>
        [TestMethod()]
        public void GetEntryFromDataBaseTest_ValidDataSet_ReturnsValidObject()
        {
            int entryId = 0;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetEntryFromDatabaseTestSetup(out mocks, out reader, out creator);
            ArticleInfo actual;

            actual = ArticleInfo.GetEntryFromDataBase(entryId, reader, creator);
            Assert.AreNotEqual(actual, null);


        }

        /// <summary>
        ///A test for GetEntryFromDataBase
        ///</summary>
        [TestMethod()]
        public void GetEntryFromDataBaseTest_EmptyDataSet_ReturnsValidObject()
        {
            int entryId = 0;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetEntryFromDatabaseTestSetup(out mocks, out reader, out creator);
            ArticleInfo actual;

            //empty recordset
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false).Repeat.Times(1);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            actual = ArticleInfo.GetEntryFromDataBase(entryId, reader, creator);
            Assert.AreEqual(actual, null);


        }

        /// <summary>
        ///A test for GetEntryFromDataBase
        ///</summary>
        [TestMethod()]
        public void GetEntryFromDataBaseTest_NotMainArticle_ReturnsValidObject()
        {
            int entryId = 0;
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetEntryFromDatabaseTestSetup(out mocks, out reader, out creator);
            ArticleInfo actual;

            //not main article
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false).Repeat.Times(1);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(0);
            actual = ArticleInfo.GetEntryFromDataBase(entryId, reader, creator);
            Assert.AreEqual(actual, null);

        }

        private static void GetEntryFromDatabaseTestSetup(out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(6);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getauthorsfromh2g2id")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getrelatedarticles")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getrelatedclubs")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getarticlecrumbtrail")).Return(reader);
            mocks.ReplayAll();
        }
    }
}

