using System;
using System.Collections.Generic;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;



namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for RelatedArticleTest and is intended
    ///to contain all RelatedArticleTest Unit Tests
    ///</summary>
    [TestClass()]
    public class RelatedArticleTest
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


        

        public static List<RelatedArticle> CreateRelatedArticles()
        {
            List<RelatedArticle> articles = new List<RelatedArticle>();
            articles.Add(new RelatedArticle()
            {
                H2g2Id = 1,
                Name = "test article",
                StrippedName = "test article",
                Editor = new UserElement() { user = UserTest.CreateTestUser() },
                DateCreated = new DateElement(DateTime.Now),
                LastUpdated = new DateElement(DateTime.Now),
                Status = new ArticleStatus() { Type = 1, Value = "test" },
                ExtraInfo = "<EXTRAINFO><TEST>test</TEST></EXTRAINFO>"
            });

            return articles;
        }

        /// <summary>
        ///A test for GetDescriptionForStatusValue
        ///</summary>
        [TestMethod()]
        public void GetDescriptionForStatusValue_InvalidStatus_ReturnsUnknown()
        {
            int status = 50; 
            string expected = "Unknown";
            string actual;
            actual = RelatedArticle.GetDescriptionForStatusValue(status);
            Assert.AreEqual(expected, actual);
           
        }

        /// <summary>
        ///A test for GetRelatedArticles
        ///</summary>
        [TestMethod()]
        public void GetRelatedArticles_ValidDataSet_ReturnsValidObject()
        {
            int h2g2ID = 0;
            string testSubject = "this is a test subject";
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            reader.Stub(x => x.GetString("Subject")).Return(testSubject);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getrelatedarticles")).Return(reader);
            mocks.ReplayAll();

            List<RelatedArticle> actual;
            actual = RelatedArticle.GetRelatedArticles(h2g2ID, creator);
            Assert.AreEqual(actual.Count, 1);
            Assert.AreEqual(actual[0].Name, testSubject);

        }
    }
}
