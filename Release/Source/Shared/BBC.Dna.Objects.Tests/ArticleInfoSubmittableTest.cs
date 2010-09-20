using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ArticleInfoSubmittableTest and is intended
    ///to contain all ArticleInfoSubmittableTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ArticleInfoSubmittableTest
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
        ///A test for CreateSubmittable
        ///</summary>
        [TestMethod()]
        public void CreateSubmittable_DefaultSettings_ReturnsCorrectType()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            SubmittableTestSetup(out mocks, out reader, out creator);


            int h2g2Id = 0; 
            bool isSubmittable = false; 
            ArticleInfoSubmittable actual;
            actual = ArticleInfoSubmittable.CreateSubmittable(creator, h2g2Id, isSubmittable);
            Assert.AreEqual(actual.Type, "IN");
        }

        [TestMethod()]
        public void CreateSubmittable_NoResults_ReturnsCorrectType()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            SubmittableTestSetup(out mocks, out reader, out creator);
            int h2g2Id = 0;
            bool isSubmittable = false;
            ArticleInfoSubmittable actual;

            //test if no results
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchreviewforummemberdetails")).Return(reader);
            mocks.ReplayAll();

            isSubmittable = false;
            actual = ArticleInfoSubmittable.CreateSubmittable(creator, h2g2Id, isSubmittable);
            Assert.AreEqual(actual.Type, "NO");

        }

        [TestMethod()]
        public void CreateSubmittable_NoResultsIsSubmittable_ReturnsCorrectType()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            SubmittableTestSetup(out mocks, out reader, out creator);
            int h2g2Id = 0;
            bool isSubmittable = false;
            ArticleInfoSubmittable actual;

            //test if no results
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchreviewforummemberdetails")).Return(reader);
            mocks.ReplayAll();


            isSubmittable = true;
            actual = ArticleInfoSubmittable.CreateSubmittable(creator, h2g2Id, isSubmittable);
            Assert.AreEqual(actual.Type, "YES");

        }


        private static void SubmittableTestSetup(out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchreviewforummemberdetails")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("fetchreviewforumdetails")).Return(reader);

            mocks.ReplayAll();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        static public ArticleInfoSubmittable Create()
        {
            return new ArticleInfoSubmittable()
            {
                Type = "IN",
                Forum = new SubmittableForum(),
                Post = new SubmittablePost(),
                Thread = new SubmittableThread(),
                ReviewForum = ReviewForumTest.CreateReviewForum()
            };
        }
    }
}
