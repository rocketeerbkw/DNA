using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Data;
using Rhino.Mocks.Constraints;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for SiteStatisticsTest
    /// </summary>
    [TestClass]
    public class SiteStatisticsTest
    {
        public SiteStatisticsTest()
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

        [TestMethod()]
        public void CreateSiteStatistics_ReturnsValidObject()
        {
            // 1) Prepare
            MockRepository mocks = new MockRepository();

            IDnaDataReader getUneditedArticleCountReader = mocks.DynamicMock<IDnaDataReader>();
            getUneditedArticleCountReader.Stub(x => x.HasRows).Return(true);
            getUneditedArticleCountReader.Stub(x => x.Read()).Return(true);
            getUneditedArticleCountReader.Stub(x => x.GetInt32NullAsZero("cnt")).Return(5);

            IDnaDataReader getTotalEditedEntriesReader = mocks.DynamicMock<IDnaDataReader>();
            getTotalEditedEntriesReader.Stub(x => x.HasRows).Return(true);
            getTotalEditedEntriesReader.Stub(x => x.Read()).Return(true);
            getTotalEditedEntriesReader.Stub(x => x.GetInt32NullAsZero("cnt")).Return(10);

            IDnaDataReader createRecentArticlesReader = mocks.DynamicMock<IDnaDataReader>();
            createRecentArticlesReader.Stub(x => x.HasRows).Return(true); ;
            createRecentArticlesReader.Stub(x => x.Read()).Return(true).Repeat.Once();
            createRecentArticlesReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(123).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetInt32NullAsZero("status")).Return(3).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return("test subject 1").Repeat.Once();
            createRecentArticlesReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return("test subject 1").Repeat.Once();
            createRecentArticlesReader.Stub(x => x.Read()).Return(true).Repeat.Once();
            createRecentArticlesReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(456).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetInt32NullAsZero("status")).Return(3).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetDateTime("datecreated")).Return(DateTime.Now).Repeat.Once(); ;
            createRecentArticlesReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return("test subject 2").Repeat.Once();
            createRecentArticlesReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return("test subject 1").Repeat.Once();

            IDnaDataReader createRecentConversations = mocks.DynamicMock<IDnaDataReader>();
            createRecentConversations.Stub(x => x.HasRows).Return(true); ;
            createRecentConversations.Stub(x => x.Read()).Return(true).Repeat.Once();
            createRecentConversations.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(123).Repeat.Once(); ;
            createRecentConversations.Stub(x => x.GetInt32NullAsZero("Forumid")).Return(456).Repeat.Once(); ;
            createRecentConversations.Stub(x => x.GetString("FirstSubject")).Return("first subject").Repeat.Once(); ;            
            createRecentConversations.Stub(x => x.GetDateTime("LastPosted")).Return(DateTime.Now).Repeat.Once(); ;
            createRecentConversations.Stub(x => x.Read()).Return(true).Repeat.Once();
            createRecentConversations.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(789).Repeat.Once(); ;
            createRecentConversations.Stub(x => x.GetInt32NullAsZero("Forumid")).Return(444).Repeat.Once(); ;
            createRecentConversations.Stub(x => x.GetString("FirstSubject")).Return("second subject").Repeat.Once(); ;            
            createRecentConversations.Stub(x => x.GetDateTime("LastPosted")).Return(DateTime.Now).Repeat.Once(); ;


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("totalunapprovedentries")).Return(getUneditedArticleCountReader);
            creator.Stub(x => x.CreateDnaDataReader("totalapprovedentries")).Return(getTotalEditedEntriesReader);
            creator.Stub(x => x.CreateDnaDataReader("freshestarticles")).Return(createRecentArticlesReader);
            creator.Stub(x => x.CreateDnaDataReader("freshestconversations")).Return(createRecentConversations);
            
            mocks.ReplayAll();

            // 2) Execute            
            SiteStatistics actual = SiteStatistics.CreateSiteStatistics(creator, 1);

            // 3) Verify            
            Assert.AreEqual(5, actual.TotalUneditedEntries);
            Assert.AreEqual(10, actual.TotalEditedEntries);
            Assert.AreEqual(2, actual.MostRecentConversations.Count);
            Assert.AreEqual(2, actual.MostRecentGuideEntries.Count);

        }


    }
}
