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
    ///This is a test class for ScoutRecommendationsTest and is intended
    ///to contain all ScoutRecommendationsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ScoutRecommendationsTest
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
        public void ScoutRecommendsTest()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            ISite site;
            SetupScoutRecommendationsMocks(out mocks, out creator, out reader, out site, 1);

            ScoutRecommendations scoutRecommends;

            scoutRecommends = ScoutRecommendations.CreateScoutRecommendationsFromDatabase(creator,
                                                                1, 
                                                                0,
                                                                20);
            Assert.AreNotEqual(null, scoutRecommends);

            XmlDocument xml = Serializer.SerializeToXml(scoutRecommends);
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }
        private void SetupScoutRecommendationsMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out ISite site, int rowsToReturn)
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
            AddSetupScoutRecommendsResponseDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("FetchUndecidedRecommendations")).Return(reader);

            ProfanityFilterTests.InitialiseProfanities();

            mocks.ReplayAll();
        }

        private void AddSetupScoutRecommendsResponseDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("type")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Twice();
        }
    }
}