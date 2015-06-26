using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;



namespace BBC.Dna.Objects.Tests
{       
    /// <summary>
    ///This is a test class for ArticleInfoPageAuthorTest and is intended
    ///to contain all ArticleInfoPageAuthorTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ArticleInfoPageAuthorTest
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


        

        public static ArticleInfoPageAuthor CreatePageAuthor()
        {
            ArticleInfoPageAuthor target = new ArticleInfoPageAuthor();
            target.Editor = new UserElement() { user = UserTest.CreateTestUser() };
            target.Researchers.Add(UserTest.CreateTestUser());
            target.Researchers.Add(UserTest.CreateTestUser());
            target.Researchers.Add(UserTest.CreateTestUser());
            return target;
        }

        /// <summary>
        ///A test for CreateListForArticle
        ///</summary>
        [TestMethod()]
        public void CreateListForArticle_ValidUserIds_ReturnsSingleResearcher()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(90);
            reader.Stub(x => x.GetInt32("UserID")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getauthorsfromh2g2id")).Return(reader);

            mocks.ReplayAll();

            int h2g2Id = 0; 
            int editorId = 0; 
            ArticleInfoPageAuthor actual;
            actual = ArticleInfoPageAuthor.CreateListForArticle(h2g2Id, editorId, creator);
            Assert.AreEqual(actual.Researchers.Count, 1);
        }
    }
}
