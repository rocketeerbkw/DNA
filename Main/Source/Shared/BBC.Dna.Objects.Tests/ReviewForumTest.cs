using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ReviewForumTest and is intended
    ///to contain all ReviewForumTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ReviewForumTest
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
        ///A test for CreateFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateFromDatabase_ValidDataSet_ReturnsValidObject()
        {
            bool isReviewForumID = true;
            int id = 1;

            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ReviewForumID")).Return(id);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchreviewforumdetails")).Return(reader);
            mocks.ReplayAll();
            
            ReviewForum actual;
            actual = ReviewForum.CreateFromDatabase(creator, id, isReviewForumID);
            Assert.AreEqual(actual.Id, id);

            isReviewForumID = false;
            actual = ReviewForum.CreateFromDatabase(creator, id, isReviewForumID);
            Assert.AreEqual(actual.Id, id);

        }

        static public ReviewForum CreateRevievForum()
        {
            return new ReviewForum()
            {
                ForumName = string.Empty,
                UrlFriendlyName = string.Empty,
            };
        }
    }
}
