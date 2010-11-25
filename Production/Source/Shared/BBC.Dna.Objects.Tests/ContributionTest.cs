using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for ContributionTest
    /// </summary>
    [TestClass]
    public class ContributionTest
    {
        private readonly string _test_sitename = "h2g2";
        private readonly DateTime _test_timestamp = DateTime.Now.AddDays(-20);
        private readonly DateTime _test_instance_created_datetime = DateTime.Now;

        
        private readonly string _test_guideentry_subject = "test guide entry subject";
        private readonly int _test_totalpostsonforum = 20;
        private readonly int _test_author_user_id = 99;
        private readonly string _test_author_username = "poster";
        private readonly string _test_author_identityusername = "poster";


        public ContributionTest()
        {
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

         public void CreateContribution_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
        }

         /// <summary>
         /// Tests that calling GetContribution_Valid works ok
         /// </summary>
         [TestMethod]
         public void GetContribution_Valid()
         {
             // PREPARE THE TEST
             // setup the default mocks
             MockRepository mocks;
             ICacheManager cache;
             IDnaDataReaderCreator readerCreator;
             int threadentryid = 60;

             CreateContribution_SetupDefaultMocks(out mocks, out cache, out readerCreator);

             IDnaDataReader getContributionReader = mocks.DynamicMock<IDnaDataReader>();
             getContributionReader.Stub(x => x.HasRows).Return(true);
             getContributionReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);

             // second row is a community
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return("Community Body").Repeat.Once();
             getContributionReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp).Repeat.Once();
             getContributionReader.Stub(x => x.GetLongNullAsZero("PostIndex")).Return(1).Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename).Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return(((int)SiteType.Community).ToString()).Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return("Community Description").Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return("Community Url").Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return("Community Title").Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Community Subject").Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return("Community First Subject").Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(String.Empty).Repeat.Once(); ;
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(_test_guideentry_subject).Repeat.Once(); ;
             getContributionReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum).Repeat.Once();
             getContributionReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id).Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username).Repeat.Once();
             getContributionReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername).Repeat.Once();

             readerCreator.Stub(x => x.CreateDnaDataReader("getcontribution")).Return(getContributionReader).Constraints(Is.Anything());

             // EXECUTE THE TEST            
             mocks.ReplayAll();
             try
             {
                 Contribution actual = Contribution.CreateContribution(readerCreator, threadentryid);
             }
             catch (ApiException e)
             {
                 // VERIFY THE RESULTS
                 Assert.AreEqual(e.type, ErrorType.ThreadPostNotFound);
             }

         }

                 
        /// <summary>
        /// Tests that calling GetContribution when there are no contribution throws exception
        /// </summary>
        [TestMethod]
        public void GetContribution_NoResults_throwsException()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            int threadentryid = 60;

            CreateContribution_SetupDefaultMocks(out mocks, out cache, out readerCreator);

            IDnaDataReader getContributionReader = mocks.DynamicMock<IDnaDataReader>();
            getContributionReader.Stub(x => x.HasRows).Return(false);
            getContributionReader.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("getcontribution")).Return(getContributionReader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            try
            {
                Contribution actual = Contribution.CreateContribution(readerCreator, threadentryid);
            }
            catch (ApiException e)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(e.type, ErrorType.ThreadPostNotFound);
            }     
        }

        public static Contribution CreateTestContribution()
        {
            Contribution contribution = new Contribution()
            {
                 Body = "First Item Body",                         
                 ModerationStatus = CommentStatus.Hidden.NotHidden,
                 PostIndex = 0,
                 SiteName = "h2g2",
                 SiteType = BBC.Dna.Sites.SiteType.Blog,
                 FirstSubject = "Test Instance Source Title",
                 Subject = "Test Instance Sub Title",
                 Timestamp = new DateTimeHelper(DateTime.Now),
                 Title = "Test Instance Title"
            };
            return contribution;
        }
    }
}
