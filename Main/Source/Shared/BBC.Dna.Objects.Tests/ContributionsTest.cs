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
    /// Summary description for ContributionsTest
    /// </summary>
    [TestClass]
    public class ContributionsTest
    {
        private readonly string _test_sitename = "h2g2";
        private readonly string _test_identityuserid = "99";
        private readonly int _test_itemsPerPage = 10;
        private readonly int _test_postIndex = 0;
        private readonly string _test_sitedescription = null;
        private readonly DateTime _test_timestamp = DateTime.Now.AddDays(-20);
        private readonly DateTime _test_instance_created_datetime = DateTime.Now;

        
        private readonly SortDirection _test_sortDirection;
        private readonly SiteType _test_siteType = SiteType.Blog;
        private readonly string _test_body = "Body Text";
        private readonly string _test_title = "Title Text";
        private readonly string _test_subject = "Subject";
        private readonly string _test_firstsubject = "First Subject";
        private readonly string _test_siteurl = "test url";
        private readonly string _test_commentforumurl = "test comment forum url";
        private readonly string _test_guideentry_subject = "test guide entry subject";

        private readonly int _test_totalpostsonforum = 20;
        private readonly int _test_author_user_id = 99;
        private readonly string _test_author_username = "poster";
        private readonly string _test_author_identityusername = "poster";


        private readonly string _test_cache_key = "BBC.Dna.Objects.Contribution, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|99|Blog|h2g2|Ascending|10|0|identityuserid|";
        
        public ContributionsTest()
        {
            _test_sortDirection = SortDirection.Ascending;
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

         public void CreateContributions_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
        }

        /// <summary>
        /// Tests if GetUserContributions bypasses the cache when DoNotIgnoreCache = false
        /// </summary>
        [TestMethod]
        public void GetUserContributions_WithIgnoreCache_CacheIsIgnored()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);
            
            IDnaDataReader getuserReader = mocks.DynamicMock<IDnaDataReader>();
            getuserReader.Stub(x => x.HasRows).Return(true);
            getuserReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);

            // mock getusercontributions returned data
            IDnaDataReader getusercontributionsReader = mocks.DynamicMock<IDnaDataReader>();
            getusercontributionsReader.Stub(x => x.HasRows).Return(true);
            getusercontributionsReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return(_test_body);
            getusercontributionsReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp);
            getusercontributionsReader.Stub(x => x.GetInt32("PostIndex")).Return(_test_postIndex);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return("1");
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return(_test_sitedescription);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return(_test_siteurl);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return(_test_title);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return(_test_subject);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return(_test_firstsubject);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(_test_commentforumurl);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(_test_guideentry_subject);

            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum);
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username);
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername);


            

            readerCreator.Stub(x => x.CreateDnaDataReader("getusercontributions")).Return(getusercontributionsReader);

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Contributions actual = Contributions.GetUserContributions(cache,
                readerCreator,
                _test_sitename,
                _test_identityuserid,
                _test_itemsPerPage,
                _test_postIndex,
                _test_sortDirection,
                _test_siteType,
                "identityuserid",
                true);

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was NEVER accessed, that a datareader call was made and that item was added to cache
            cache.AssertWasNotCalled(c => c.GetData(_test_cache_key));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("getusercontributions"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("cachegetlastpostdate"));    
            cache.AssertWasCalled(c => c.Add(_test_cache_key, actual));
        }

        /// <summary>
        /// Tests if GetUserContributions atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod]
        public void GetUserContributions_WithDoNotIgnoreCache_CacheIsNotIgnored()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);

            Contributions cachedContributions = CreateTestContributions();
            cachedContributions.InstanceCreatedDateTime = _test_instance_created_datetime;

            // need a valid user
            IDnaDataReader getuserReader = mocks.DynamicMock<IDnaDataReader>();

            // simulate the contributions being in cache
            cache.Stub(x => x.GetData(_test_cache_key)).Return(cachedContributions);

            // simulate contributions being called and returning an up to date value
            IDnaDataReader cachegetcontributioninfoReader = mocks.DynamicMock<IDnaDataReader>();
            cachegetcontributioninfoReader.Stub(x => x.HasRows).Return(true);
            cachegetcontributioninfoReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            cachegetcontributioninfoReader.Stub(x => x.GetDateTime("LastPosted")).Return(_test_instance_created_datetime).Repeat.Times(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("cachegetlastpostdate")).Return(cachegetcontributioninfoReader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Contributions actual = Contributions.GetUserContributions(cache,
                readerCreator,
                _test_sitename,
                _test_identityuserid,
                _test_itemsPerPage,
                _test_postIndex,
                _test_sortDirection,
                _test_siteType,
                "identityuserid",
                false);

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(_test_cache_key), options => options.Repeat.AtLeastOnce());
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("cachegetlastpostdate"));    
            Assert.AreSame(cachedContributions, actual);                
        }

        /// <summary>
        /// Tests if the cache refreshes itself when the data changes
        /// </summary>
        [TestMethod]
        public void GetUserContributions_WithDoNotIgnoreCache_CacheIsUpdated()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);

            Contributions cachedContributions = CreateTestContributions();

            // simulate the data being retrieved 30 minutes ago
            cachedContributions.InstanceCreatedDateTime = _test_instance_created_datetime.AddMinutes(-30);

            // need a valid user
            IDnaDataReader getuserReader = mocks.DynamicMock<IDnaDataReader>();

            // simulate the contributions being in cache
            cache.Stub(x => x.GetData(_test_cache_key)).Return(cachedContributions);

            // simulate contributions being called and returning an up to date value
            IDnaDataReader cachegetcontributioninfoReader = mocks.DynamicMock<IDnaDataReader>();
            cachegetcontributioninfoReader.Stub(x => x.HasRows).Return(true);
            cachegetcontributioninfoReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);

            // similate the DB returning an update that's 30 minues after the cachedContributions
            cachegetcontributioninfoReader.Stub(x => x.GetDateTime("LastPosted")).Return(_test_instance_created_datetime).Repeat.Times(1);
            
            readerCreator.Stub(x => x.CreateDnaDataReader("cachegetlastpostdate")).Return(cachegetcontributioninfoReader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Contributions actual = Contributions.GetUserContributions(cache,
                readerCreator,
                _test_sitename,
                _test_identityuserid,
                _test_itemsPerPage,
                _test_postIndex,
                _test_sortDirection,
                _test_siteType,
                "identityuserid",
                false);

            // VERIFY THE RESULTS            
            // check that the cache was accessed, that lastpostdate was called and the cache instace refreshed
            cache.AssertWasCalled(c => c.GetData(_test_cache_key), options => options.Repeat.AtLeastOnce());
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("getusercontributions"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("cachegetlastpostdate"));            
            Assert.AreNotSame(cachedContributions, actual);
        }
                 
        /// <summary>
        /// Tests that a call to GetUserContributions returns a valid MessageBoard, Article and Blog.
        /// </summary>
        [TestMethod]
        public void GetUserContributions_WithNoFilter_Returns3ValidMixedItems()
        {

            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);

            // mock the getusercontributionsReader response            
            IDnaDataReader getuserReader = mocks.DynamicMock<IDnaDataReader>();
            getuserReader.Stub(x => x.HasRows).Return(true);
            getuserReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
                        
            IDnaDataReader getusercontributionsReader = mocks.DynamicMock<IDnaDataReader>();
            getusercontributionsReader.Stub(x => x.HasRows).Return(true);
            getusercontributionsReader.Stub(x => x.Read()).Return(true).Repeat.Times(4);

            // first row is a blog
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return("Blog Body").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetLongNullAsZero("PostIndex")).Return(0).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return(((int)SiteType.Blog).ToString()).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return("Blog Description").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return("Blog Url").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return("Blog Title").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Blog Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return("Blog First Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(_test_commentforumurl).Repeat.Once(); ;
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(String.Empty).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername).Repeat.Once();


            // second row is a community
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return("Community Body").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetLongNullAsZero("PostIndex")).Return(1).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return(((int)SiteType.Community).ToString()).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return("Community Description").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return("Community Url").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return("Community Title").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Community Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return("Community First Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(String.Empty).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(_test_guideentry_subject).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername).Repeat.Once();


            // third row is a messageboard
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return("Messageboard Body").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetLongNullAsZero("PostIndex")).Return(2).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return(((int)SiteType.Messageboard).ToString()).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return("Messageboard Description").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return("Messageboard Url").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return("Messageboard Title").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Messageboard Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return("Messageboard First Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(String.Empty).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(String.Empty).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername).Repeat.Once();


            // fourth row is a embedded comments
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Body")).Return("Comments Body").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetDateTime("TimeStamp")).Return(_test_timestamp).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetLongNullAsZero("PostIndex")).Return(3).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteName")).Return(_test_sitename).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteType")).Return(((int)SiteType.EmbeddedComments).ToString()).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("SiteDescription")).Return("Comments Description").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("UrlName")).Return("Comments Url").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("ForumTitle")).Return("Comments Title").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("Subject")).Return("Comments Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("FirstSubject")).Return("Comments First Subject").Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("CommentForumUrl")).Return(String.Empty).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("GuideEntrySubject")).Return(String.Empty).Repeat.Once();;
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("TotalPostsOnForum")).Return(_test_totalpostsonforum).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetInt32NullAsZero("AuthorUserId")).Return(_test_author_user_id).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorUsername")).Return(_test_author_username).Repeat.Once();
            getusercontributionsReader.Stub(x => x.GetStringNullAsEmpty("AuthorIdentityUsername")).Return(_test_author_identityusername).Repeat.Once();


            readerCreator.Stub(x => x.CreateDnaDataReader("getusercontributions")).Return(getusercontributionsReader);

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Contributions actual = Contributions.GetUserContributions(cache,
                readerCreator,
                _test_sitename,
                _test_identityuserid,
                _test_itemsPerPage,
                _test_postIndex,
                _test_sortDirection,
                _test_siteType,
                "identityuserid",
                false);

            // VERIFY THE RESULTS
            // check the Contributions instance has all the original data
            Assert.AreEqual(_test_siteType, actual.SiteType);
            Assert.AreEqual(_test_itemsPerPage, actual.ItemsPerPage);
            Assert.AreEqual(_test_sortDirection, actual.SortDirection);
            Assert.AreEqual(_test_postIndex, actual.StartIndex);
            Assert.AreEqual(_test_identityuserid, actual.IdentityUserID);

            // check the first ContributionItems member (Blog)
            Assert.AreEqual("Blog Body", actual.ContributionItems[0].Body);
            Assert.AreEqual(new DateTimeHelper(_test_timestamp).At, actual.ContributionItems[0].Timestamp.At);
            Assert.AreEqual(0, actual.ContributionItems[0].PostIndex);
            Assert.AreEqual("h2g2", actual.ContributionItems[0].SiteName);
            Assert.AreEqual(SiteType.Blog, actual.ContributionItems[0].SiteType);
            Assert.AreEqual("Blog Title", actual.ContributionItems[0].Title);
            Assert.AreEqual("Blog Subject", actual.ContributionItems[0].Subject);
            Assert.AreEqual("Blog First Subject", actual.ContributionItems[0].FirstSubject);
            Assert.AreEqual("Blog Url", actual.ContributionItems[0].SiteUrl);
            Assert.AreEqual(_test_sitename, actual.ContributionItems[0].SiteName);
            Assert.AreEqual(_test_commentforumurl, actual.ContributionItems[0].CommentForumUrl);
            Assert.AreEqual(String.Empty, actual.ContributionItems[0].GuideEntrySubject);

            // check the second ContributionItems member (Community)
            Assert.AreEqual("Community Body", actual.ContributionItems[1].Body);
            Assert.AreEqual(new DateTimeHelper(_test_timestamp).At, actual.ContributionItems[1].Timestamp.At);
            Assert.AreEqual(1, actual.ContributionItems[1].PostIndex);
            Assert.AreEqual("h2g2", actual.ContributionItems[1].SiteName);
            Assert.AreEqual(SiteType.Community, actual.ContributionItems[1].SiteType);
            Assert.AreEqual("Community Title", actual.ContributionItems[1].Title);
            Assert.AreEqual("Community Subject", actual.ContributionItems[1].Subject);
            Assert.AreEqual("Community First Subject", actual.ContributionItems[1].FirstSubject);
            Assert.AreEqual("Community Url", actual.ContributionItems[1].SiteUrl);
            Assert.AreEqual(_test_sitename, actual.ContributionItems[1].SiteName);
            Assert.AreEqual(String.Empty, actual.ContributionItems[1].CommentForumUrl);
            Assert.AreEqual(_test_guideentry_subject, actual.ContributionItems[1].GuideEntrySubject);

            // check the third MessageBoard member (Forum)
            Assert.AreEqual("Messageboard Body", actual.ContributionItems[2].Body);
            Assert.AreEqual(new DateTimeHelper(_test_timestamp).At, actual.ContributionItems[2].Timestamp.At);
            Assert.AreEqual(2, actual.ContributionItems[2].PostIndex);
            Assert.AreEqual("h2g2", actual.ContributionItems[2].SiteName);
            Assert.AreEqual(SiteType.Messageboard, actual.ContributionItems[2].SiteType);
            Assert.AreEqual("Messageboard Title", actual.ContributionItems[2].Title);
            Assert.AreEqual("Messageboard Subject", actual.ContributionItems[2].Subject);
            Assert.AreEqual("Messageboard First Subject", actual.ContributionItems[2].FirstSubject);
            Assert.AreEqual("Messageboard Url", actual.ContributionItems[2].SiteUrl);
            Assert.AreEqual(_test_sitename, actual.ContributionItems[2].SiteName);
            Assert.AreEqual(String.Empty, actual.ContributionItems[2].CommentForumUrl);
            Assert.AreEqual(String.Empty, actual.ContributionItems[2].GuideEntrySubject);

            // check the fourth ContributionItems member (embedded comments)
            Assert.AreEqual("Comments Body", actual.ContributionItems[3].Body);
            Assert.AreEqual(new DateTimeHelper(_test_timestamp).At, actual.ContributionItems[3].Timestamp.At);
            Assert.AreEqual(3, actual.ContributionItems[3].PostIndex);
            Assert.AreEqual("h2g2", actual.ContributionItems[3].SiteName);
            Assert.AreEqual(SiteType.EmbeddedComments, actual.ContributionItems[3].SiteType);
            Assert.AreEqual("Comments Title", actual.ContributionItems[3].Title);
            Assert.AreEqual("Comments Subject", actual.ContributionItems[3].Subject);
            Assert.AreEqual("Comments First Subject", actual.ContributionItems[3].FirstSubject);
            Assert.AreEqual("Comments Url", actual.ContributionItems[3].SiteUrl);
            Assert.AreEqual(_test_sitename, actual.ContributionItems[3].SiteName);
            Assert.AreEqual(String.Empty, actual.ContributionItems[3].CommentForumUrl);
            Assert.AreEqual(String.Empty, actual.ContributionItems[3].GuideEntrySubject);

        }


        /// <summary>
        /// Tests that calling GetUserContributions when there are no contributions returns an empty list
        /// </summary>
        [TestMethod]
        public void GetUserContributions_NoResults_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);

            // mock the getusercontributionsReader response            
            IDnaDataReader getuserReader = mocks.DynamicMock<IDnaDataReader>();
            getuserReader.Stub(x => x.HasRows).Return(true);
            getuserReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);

            IDnaDataReader getusercontributionsReader = mocks.DynamicMock<IDnaDataReader>();
            readerCreator.Stub(x => x.CreateDnaDataReader("getusercontributions")).Return(getusercontributionsReader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Contributions actual = Contributions.GetUserContributions(cache,
                readerCreator,
                _test_sitename,
                _test_identityuserid,
                _test_itemsPerPage,
                _test_postIndex,
                _test_sortDirection,
                SiteType.Undefined,
                "identityuserid",
                false);

            // VERIFY THE RESULTS            
            Assert.AreEqual(0, actual.ContributionItems.Count);
        }

        /// <summary>
        /// Tests that calling GetUserContributions with a non existing user throws an exception
        /// </summary>
        [TestMethod]
        public void GetUserContributions_NonExistingUser_ThrowException()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            IDnaDataReaderCreator readerCreator;
            CreateContributions_SetupDefaultMocks(out mocks, out cache, out readerCreator);
            int value = 1;

            // mock the getusercontributionsReader response
            IDnaDataReader getusercontributionsReader = mocks.DynamicMock<IDnaDataReader>();
            getusercontributionsReader.Stub(x => x.HasRows).Return(false);
            getusercontributionsReader.Stub(x => x.Read()).Return(false);
            getusercontributionsReader.Stub(x => x.TryGetIntReturnValue(out value)).Return(true).OutRef(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("getusercontributions")).Return(getusercontributionsReader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            try
            {
                Contributions actual = Contributions.GetUserContributions(cache,
                    readerCreator,
                    _test_sitename,
                    _test_identityuserid,
                    _test_itemsPerPage,
                    _test_postIndex,
                    _test_sortDirection,
                    SiteType.Undefined,
                    "identityuserid",
                    false);
            }
            catch (ApiException e)
            {
                // VERIFY THE RESULTS
                Assert.AreEqual(e.type, ErrorType.InvalidUserId);
            }     
        }

        public static Contributions CreateTestContributions()
        {
            Contributions contributions = new Contributions()
            {
                SiteType = SiteType.Undefined,
                InstanceCreatedDateTime = DateTime.Now,
                ItemsPerPage = 20,
                SortDirection = SortDirection.Ascending,
                StartIndex = 0,
                IdentityUserID = "77",
                ContributionItems = new List<Contribution>() 
                { 
                    new Contribution()
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
                    },
                    new Contribution()
                    {
                         Body = "Second Item Body",                         
                         ModerationStatus = CommentStatus.Hidden.NotHidden,
                         PostIndex = 1,
                         SiteName = "h2g2",
                         SiteType = BBC.Dna.Sites.SiteType.Messageboard,
                         FirstSubject = "Test Instance Source Title 2",
                         Subject = "Test Instance Sub Title 2",
                         Timestamp = new DateTimeHelper(DateTime.Now),
                         Title = "Test Instance Title 2"
                    }
                }
            };
            return contributions;
        }
    }
}
