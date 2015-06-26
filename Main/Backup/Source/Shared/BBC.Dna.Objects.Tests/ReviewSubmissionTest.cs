using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;
using BBC.Dna.Moderation.Utils.Tests;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for ReviewSubmissionTest and is intended
    ///to contain all ReviewSubmissionTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ReviewSubmissionTest
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
        ///A test for SubmitReview
        ///</summary>
        [TestMethod]
        public void SubmitReviewTest()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ISite site; 
            SetupReviewSubmissionMocks(out mocks, out creator, out reader, out site, 1 );

            ReviewSubmission reviewSubmission;

            reviewSubmission = ReviewSubmission.SubmitArticle(creator, 
                                                                6, 
                                                                "JimLynn", 
                                                                site, 
                                                                1, 
                                                                "TestSubject", 
                                                                1090497224, 
                                                                "Damnyoureyes", 
                                                                1, 
                                                                "This is the article submitted for review.");
            Assert.AreNotEqual(null, reviewSubmission);

            XmlDocument xml = Serializer.SerializeToXml(reviewSubmission);
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }
        private void SetupReviewSubmissionMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out ISite site, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);
            
            site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(1);
            site.Stub(x => x.ModClassID).Return(1);

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
            AddReviewSubmissionsListTestDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("addarticletoreviewforummembers")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ForceUpdateEntry")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpersonalspaceforum")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchreviewforumdetails")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("posttoforum")).Return(reader);

            ProfanityFilterTests.InitialiseProfanities();

            mocks.ReplayAll();
        }

        private void AddReviewSubmissionsListTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(12345);
            reader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(24088151);
        }
    }
}