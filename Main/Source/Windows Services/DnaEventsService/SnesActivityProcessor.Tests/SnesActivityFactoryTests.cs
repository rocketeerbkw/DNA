using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ActivityProcessor.Activities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using DnaEventService.Common;

namespace SnesActivityProcessorTests
{
    /// <summary>
    /// Summary description for SnesActivityFactoryTests
    /// </summary>
    [TestClass]
    public class SnesActivityFactoryTests
    {
        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext { get; set; }

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

        [TestMethod]
        public void CreateSnesActivity_ActivityType19_ReturnsCommentActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(19);

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);

            Assert.IsTrue(activity is CommentActivityBase);
        }

        [TestMethod]
        public void CreateSnesActivity_ActivityType20_ReturnsRevokeCommentActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(20);
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);
            Assert.IsTrue(activity is RevokeCommentActivity);
        }

        [TestMethod]
        public void CreateSnesActivity_ActivityType100_ReturnsUnexpectedActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(100);
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);
            Assert.IsTrue(activity is UnexpectedActivity);
        }

        [TestMethod]
        public void CreateSnesActivity_ActivityType19BlogUrlPresent_ReturnsCommentForumActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            dataReader.Stub(x => x.GetString("BlogUrl")).Return("http://localhost");
            dataReader.Stub(x => x.IsDBNull("Rating")).Return(true);
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);
            Assert.IsTrue(activity is CommentForumActivity);
        }

        [TestMethod]
        public void CreateSnesActivity_ActivityType19BlogUrlIsDbNull_ReturnsMessageBoardPostActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            dataReader.Stub(x => x.IsDBNull("BlogUrl")).Return(true);
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);
            Assert.IsTrue(activity is MessageBoardPostActivity);
        }

        [TestMethod]
        public void CreateSnesActivity_ActivityType19RatingNotNull_ReturnsReviewActivity()
        {
            var dataReader = MockRepository.GenerateStub<IDnaDataReader>();
            dataReader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            dataReader.Stub(x => x.IsDBNull("BlogUrl")).Return(false);
            dataReader.Stub(x => x.GetString("BlogUrl")).Return("http://localhost");
            dataReader.Stub(x => x.IsDBNull("Rating")).Return(false);
            dataReader.Stub(x => x.GetTinyIntAsInt("Rating")).Return(1);
            var logger = MockRepository.GenerateStub<IDnaLogger>();

            var activity = SnesActivityFactory.CreateSnesActivity(logger, dataReader);
            Assert.IsTrue(activity is ReviewActivity);
        }
    }
}
