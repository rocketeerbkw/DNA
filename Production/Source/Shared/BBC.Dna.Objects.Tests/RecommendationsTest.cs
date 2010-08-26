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
    ///This is a test class for RecommendationsTest and is intended
    ///to contain all RecommendationsTest Unit Tests
    ///</summary>
    [TestClass]
    public class RecommendationsTest
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
        ///A test for Recommendations Constructor
        ///</summary>
        [TestMethod]
        public void RecommendationsXmlTest()
        {
            Recommendations recommendations = new Recommendations();
            XmlDocument xml = Serializer.SerializeToXml(recommendations);

            Assert.IsNotNull(xml.SelectSingleNode("RECOMMENDATIONS"));

        }

        /// <summary>
        ///A test for RecommendationsTest
        ///</summary>
        [TestMethod]
        public void CreateRecommendationsTest()
        {

            MockRepository mocks = new MockRepository();
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupRecommendationsMocks(out mocks, out creator, out reader);

            Recommendations recommendations;
            //actual = Recommendations.CreateRecommendations(null, creator, null, true);
            recommendations = Recommendations.CreateRecommendationsFromDatabase(creator);
            Assert.AreNotEqual(null, recommendations);

            XmlDocument xml = Serializer.SerializeToXml(recommendations);

        }

        private void SetupRecommendationsMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(2);

            AddRecommendationTestDatabaseRows(reader);

            readerCreator.Stub(x => x.CreateDnaDataReader("getacceptedentries")).Return(reader);

            mocks.ReplayAll();

        }

        private void AddRecommendationTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Test Subject").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("OriginalEntryID")).Return(2408805).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("Originalh2g2ID")).Return(24088052).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(2408815).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(24088151).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("GuideStatus")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("AcceptedStatus")).Return(1).Repeat.Twice();

            reader.Stub(x => x.GetDateTime("DateAllocated")).Return(DateTime.Now).Repeat.Twice();
            reader.Stub(x => x.GetDateTime("DateReturned")).Return(DateTime.Now).Repeat.Twice();

            reader.Stub(x => x.Exists("SubEditorID")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorName")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorFirstNames")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorLastName")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorArea")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorStatus")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorTaxomyNode")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorJournal")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorActive")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorSiteSuffix")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("SubEditorTitle")).Return(true).Repeat.Twice();

            reader.Stub(x => x.Exists("ScoutID")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutName")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutFirstNames")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutLastName")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutArea")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutStatus")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutTaxomyNode")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutJournal")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutActive")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutSiteSuffix")).Return(true).Repeat.Twice();
            reader.Stub(x => x.Exists("ScoutTitle")).Return(true).Repeat.Twice();


            reader.Stub(x => x.GetInt32NullAsZero("SubEditorID")).Return(2408805).Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("SubEditorName")).Return("FredSmith").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("SubEditorFirstNames")).Return("Fred").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("SubEditorLastName")).Return("Smith").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("SubEditorArea")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("SubEditorStatus")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("SubEditorTaxomyNode")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("SubEditorJournal")).Return(123456).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("SubEditorActive")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("SubEditorSiteSuffix")).Return("SiteSuffix").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("SubEditorTitle")).Return("Title").Repeat.Twice();

            reader.Stub(x => x.GetInt32NullAsZero("ScoutID")).Return(1090558353).Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("ScoutName")).Return("Scout").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("ScoutFirstNames")).Return("FirstScout").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("ScoutLastName")).Return("LastScout").Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("ScoutArea")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("ScoutStatus")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("ScoutTaxomyNode")).Return(4).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("ScoutJournal")).Return(123456).Repeat.Twice();
            reader.Stub(x => x.GetInt32NullAsZero("ScoutActive")).Return(1).Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("ScoutSiteSuffix")).Return("SiteSuffix").Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("ScoutTitle")).Return("Title").Repeat.Twice();

        }
    }
}
