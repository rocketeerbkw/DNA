using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Api.Contracts;

namespace BBC.Dna.Api.Tests
{
    /// <summary>
    /// Summary description for CommentForumActivity
    /// </summary>
    [TestClass]
    public class CommentForumRatingActivityTests
    {
        public CommentForumRatingActivityTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;
        public MockRepository mocks = new MockRepository();

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

        [TestMethod]
        public void DefaultURLParams_ReturnsActivityForOneMinute()
        {
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();

            DateTime startSampleTime = DateTime.Now.AddMinutes(-1); // URL Default is 1 minute
            int minutes = 1; // URL Default

            int totalActiveForums = 1;
            DateTime closeDate = DateTime.Now.AddDays(1.0);
            int count = 5;
            DateTime lastRatedDate = DateTime.Now.AddMinutes(-0.5);
            int siteId = 1;
            string urlName = "h2g2";
            string title = "Test Title";
            int totalPosts = 20;
            string url = "https://local.bbc.co.uk/dna/h2g2/comments";
            int upRatings = 20;
            int downRatings = 10;

            StubDatabaseCall(readerCreator, reader, totalActiveForums, closeDate, count, lastRatedDate, siteId, urlName, title, totalPosts, url, upRatings, downRatings);

            mocks.ReplayAll();

            Comments comments = new Comments(null, readerCreator, cacheManager, null);
            CommentForumsRatingActivityList activity = comments.GetCommentForumsRatingActivity(minutes, "");

            VerifyActivityList(totalActiveForums, minutes, closeDate, startSampleTime, count, lastRatedDate, siteId, urlName, title, totalPosts, url, upRatings, downRatings, activity);

            cacheManager.AssertWasCalled(x => x.GetData(Arg<string>.Is.Anything));
            cacheManager.AssertWasCalled(x => x.Add(Arg<string>.Is.Anything, Arg<object>.Is.Anything, Arg<CacheItemPriority>.Is.Anything, Arg<ICacheItemRefreshAction>.Is.Anything, Arg<ICacheItemExpiration>.Is.Anything));
        }

        [TestMethod]
        public void MinuteValueGreaterThan60_ReturnsActivityCappedAt60Minutes()
        {
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();

            int requestedMinutes = 70;
            int expectedMinutes = 60;
            DateTime expectedStartSampleTime = DateTime.Now.AddMinutes(-expectedMinutes);

            StubDatabaseCall(readerCreator, reader, 0, DateTime.Now, 0, DateTime.Now, 0, "", "", 0, "", 0, 0);

            mocks.ReplayAll();

            Comments comments = new Comments(null, readerCreator, cacheManager, null);
            CommentForumsRatingActivityList activity = comments.GetCommentForumsRatingActivity(requestedMinutes, "");

            VerifyActivityList(0, expectedMinutes, DateTime.Now, expectedStartSampleTime, 0, DateTime.Now, 0, "", "", 0, "", 0, 0, activity);

            cacheManager.AssertWasCalled(x => x.GetData(Arg<string>.Is.Anything));
            cacheManager.AssertWasCalled(x => x.Add(Arg<string>.Is.Anything, Arg<object>.Is.Anything, Arg<CacheItemPriority>.Is.Anything, Arg<ICacheItemRefreshAction>.Is.Anything, Arg<ICacheItemExpiration>.Is.Anything));
        }

        [TestMethod]
        public void StartDateValueGreaterThan60Minutes_ReturnsActivityCappedAt60Minutes()
        {
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();

            DateTime requestedStartSampleTime = DateTime.Now.AddMinutes(-70);
            DateTime expectedStartSampleTime = DateTime.Now.AddMinutes(-60);
            int expectedMinutes = 60;

            StubDatabaseCall(readerCreator, reader, 0, DateTime.Now, 0, DateTime.Now, 0, "", "", 0, "", 0, 0);

            mocks.ReplayAll();

            Comments comments = new Comments(null, readerCreator, cacheManager, null);
            CommentForumsRatingActivityList activity = comments.GetCommentForumsRatingActivity(1, requestedStartSampleTime.ToString());

            VerifyActivityList(0, expectedMinutes, DateTime.Now, expectedStartSampleTime, 0, DateTime.Now, 0, "", "", 0, "", 0, 0, activity);

            cacheManager.AssertWasCalled(x => x.GetData(Arg<string>.Is.Anything));
            cacheManager.AssertWasCalled(x => x.Add(Arg<string>.Is.Anything, Arg<object>.Is.Anything, Arg<CacheItemPriority>.Is.Anything, Arg<ICacheItemRefreshAction>.Is.Anything, Arg<ICacheItemExpiration>.Is.Anything));
        }

        [TestMethod]
        public void ValidParamsCalledTwiceWithin1Minute_UsesCachedVersionOnSecondCall()
        {
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();

            DateTime startSampleTime = DateTime.Now.AddMinutes(-1);
            int minutes = 1; // URL Default

            int totalActiveForums = 1;
            DateTime closeDate = DateTime.Now.AddDays(1.0);
            int count = 5;
            DateTime lastRatedDate = DateTime.Now.AddMinutes(-0.5);
            int siteId = 1;
            string urlName = "h2g2";
            string title = "Test Title";
            int totalPosts = 20;
            string url = "https://local.bbc.co.uk/dna/h2g2/comments";
            int upRatings = 20;
            int downRatings = 10;

            StubDatabaseCall(readerCreator, reader, totalActiveForums, closeDate, count, lastRatedDate, siteId, urlName, title, totalPosts, url, upRatings, downRatings);

            CommentForumRatingActivity cachedRatingActivity = new CommentForumRatingActivity();
            cachedRatingActivity.ClosingDate = new DateTimeHelper(closeDate);
            cachedRatingActivity.Count = count;
            cachedRatingActivity.LastRatedDate = new DateTimeHelper(lastRatedDate);
            cachedRatingActivity.SiteId = siteId;
            cachedRatingActivity.SiteName = urlName;
            cachedRatingActivity.Title = title;
            cachedRatingActivity.TotalPosts = totalPosts;
            cachedRatingActivity.URL = url;
            cachedRatingActivity.Up = upRatings;
            cachedRatingActivity.Down = downRatings;
            CommentForumsRatingActivityList cachedActivityRatingList = new CommentForumsRatingActivityList();
            cachedActivityRatingList.CommentForumsRatingActivity = new List<CommentForumRatingActivity>();
            cachedActivityRatingList.CommentForumsRatingActivity.Add(cachedRatingActivity);
            cachedActivityRatingList.DateChecked = new DateTimeHelper(DateTime.Now);
            cachedActivityRatingList.Minutes = minutes;
            cachedActivityRatingList.StartDate = new DateTimeHelper(startSampleTime);

            cacheManager.Stub(x => x.GetData(Arg<string>.Is.Anything)).Return(null).Repeat.Once(); // Not cached first time
            cacheManager.Stub(x => x.GetData(Arg<string>.Is.Anything)).Return(cachedActivityRatingList).Repeat.Once(); // Cached second time

            mocks.ReplayAll();

            Comments comments = new Comments(null, readerCreator, cacheManager, null);
            CommentForumsRatingActivityList activity = comments.GetCommentForumsRatingActivity(minutes, startSampleTime.ToString());

            VerifyActivityList(totalActiveForums, minutes, closeDate, startSampleTime, count, lastRatedDate, siteId, urlName, title, totalPosts, url, upRatings, downRatings, activity);

            activity = comments.GetCommentForumsRatingActivity(minutes, startSampleTime.ToString());

            VerifyActivityList(totalActiveForums, minutes, closeDate, startSampleTime, count, lastRatedDate, siteId, urlName, title, totalPosts, url, upRatings, downRatings, activity);

            cacheManager.AssertWasCalled(x => x.GetData(Arg<string>.Is.Anything), options => options.Repeat.Times(2));
            cacheManager.AssertWasCalled(x => x.Add(Arg<string>.Is.Anything, Arg<object>.Is.Anything, Arg<CacheItemPriority>.Is.Anything, Arg<ICacheItemRefreshAction>.Is.Anything, Arg<ICacheItemExpiration>.Is.Anything), options => options.Repeat.Once());
        }

        private static void StubDatabaseCall(IDnaDataReaderCreator readerCreator, IDnaDataReader reader, int totalActiveForums, DateTime closeDate, int count, DateTime lastRatedDate, int siteId, string urlName, string title, int totalPosts, string url, int upRatings, int downRatings)
        {
            reader.Stub(x => x.HasRows).Return(totalActiveForums > 0);

            if (totalActiveForums > 0)
            {
                reader.Stub(x => x.Read()).Return(true).Repeat.Once();
                reader.Stub(x => x.GetDateTime("ForumCloseDate")).Return(closeDate);
                reader.Stub(x => x.GetInt32("count")).Return(count);
                reader.Stub(x => x.GetDateTime("LastRatedDate")).Return(lastRatedDate);
                reader.Stub(x => x.GetInt32("siteid")).Return(siteId);
                reader.Stub(x => x.GetString("urlname")).Return(urlName);
                reader.Stub(x => x.GetString("title")).Return(title);
                reader.Stub(x => x.GetInt32("totalPosts")).Return(totalPosts);
                reader.Stub(x => x.GetString("url")).Return(url);
                reader.Stub(x => x.GetInt32("up")).Return(upRatings);
                reader.Stub(x => x.GetInt32("down")).Return(downRatings);
            }
            else
            {
                reader.Stub(x => x.Read()).Return(false);
            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getcommentforumsactivity_ratings")).Return(reader);
        }

        private static void VerifyActivityList(int totalActiveForums, int minutes, DateTime closeDate, DateTime startSampleTime, int count, DateTime lastRatedDate, int siteId, string urlName, string title, int totalPosts, string url, int upRatings, int downRatings, CommentForumsRatingActivityList activity)
        {
            Assert.IsTrue(activity.Minutes == minutes);
            Assert.IsTrue(Math.Abs((activity.StartDate.DateTime - startSampleTime).Seconds) < 5);
            Assert.IsTrue(activity.CommentForumsRatingActivity.Count == totalActiveForums);
            if (totalActiveForums > 0)
            {
                CommentForumRatingActivity forum = activity.CommentForumsRatingActivity[0];
                Assert.IsTrue(forum.ClosingDate.DateTime == closeDate);
                Assert.IsTrue(forum.Count == count);
                Assert.IsTrue(forum.LastRatedDate.DateTime == lastRatedDate);
                Assert.IsTrue(forum.SiteId == siteId);
                Assert.IsTrue(forum.SiteName == urlName);
                Assert.IsTrue(forum.Title == title);
                Assert.IsTrue(forum.TotalPosts == totalPosts);
                Assert.IsTrue(forum.URL == url);
                Assert.IsTrue(forum.Up == upRatings);
                Assert.IsTrue(forum.Down == downRatings);
            }
        }
    }
}
