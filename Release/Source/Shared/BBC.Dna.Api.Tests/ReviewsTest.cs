using System;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Moderation.Utils.Tests;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;

namespace BBC.Dna.Api.Tests
{
    /// <summary>
    ///This is a test class for CommentInfoTest and is intended
    ///to contain all CommentInfoTest Unit Tests
    ///</summary>
    [TestClass]
    public class ReviewsTest
    {
        public MockRepository mocks = new MockRepository();

        public ReviewsTest()
        {
            Statistics.InitialiseIfEmpty();
            ProfanityFilterTests.InitialiseProfanities();
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingsForumReadByUid_FromDbCorrectInput_ReturnsValidList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumid")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUID(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.ratingsList.TotalCount);
            Assert.AreEqual(1, forum.ratingsList.ratings.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingsForumReadByUid_FromDbNotSignedIn_ReturnsValidList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";
            var userId = 1;

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            reader.Stub(x => x.GetInt32NullAsZero("NotSignedInUserId")).Return(userId);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumid")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUID(uid, site);

            Assert.IsNotNull(forum);
            Assert.IsTrue(forum.allowNotSignedInCommenting);
            Assert.AreEqual(userId, forum.NotSignedInUserId);
            Assert.AreEqual(1, forum.ratingsList.TotalCount);
            Assert.AreEqual(1, forum.ratingsList.ratings.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingsForumReadByUid_CacheOutOfDate_ReturnsValidList()
        {
            var reviews = new Reviews(null, null, null, null);

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";
            string cacheKey = reviews.RatingForumCacheKey("", 0);

            cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(DateTime.Now.AddDays(1));
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerLastUpdate.Stub(x => x.HasRows).Return(true);
            readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(DateTime.Now.AddDays(-1));


            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUID(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.ratingsList.TotalCount);
            Assert.AreEqual(1, forum.ratingsList.ratings.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingsForumReadByUid_CacheInDateMissingActualObject_ReturnsValidList()
        {
            DateTime lastUpdate = DateTime.Now.AddDays(1);
            var reviews = new Reviews(null, null, null, null);

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";
            string cacheKey = reviews.RatingForumCacheKey("", 0);

            cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(lastUpdate);
            cacheManager.Stub(x => x.GetData(cacheKey)).Return(null);
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerLastUpdate.Stub(x => x.HasRows).Return(true);
            readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(lastUpdate);


            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUID(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.ratingsList.TotalCount);
            Assert.AreEqual(1, forum.ratingsList.ratings.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("ratingsreadbyforumid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingsForumReadByUid_CacheValid_ReturnsValidList()
        {
            DateTime lastUpdate = DateTime.Now.AddDays(1);
            string uid = "testUid";
            var validForum = new RatingForum() {Id = uid};
            var reviews = new Reviews(null, null, null, null);

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";

            string cacheKey = reviews.RatingForumCacheKey(uid, 0);

            cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(lastUpdate);
            cacheManager.Stub(x => x.GetData(cacheKey)).Return(validForum);
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerLastUpdate.Stub(x => x.HasRows).Return(true);
            readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(lastUpdate);


            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);


            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUID(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(uid, forum.Id);
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingsreadbyforumid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingForumReadByUIDAndUserList_FromDbCorrectInput_ReturnsValidList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";
            var userList = new[]{1,2,3};

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("RatingsReadByForumandUsers")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            RatingForum forum = reviews.RatingForumReadByUIDAndUserList(uid, site, userList);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.ratingsList.TotalCount);
            Assert.AreEqual(1, forum.ratingsList.ratings.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingsReadByForumandUsers"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingForumReadByUIDAndUserList_WithUserList_ReturnsCorrectError()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            string siteName = "h2g2";
            string uid = "";
            var userList = new int[0];

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("RatingForumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("RatingsReadByForumandUsers")).Return(readerComments);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            try
            {
                reviews.RatingForumReadByUIDAndUserList(uid, site, userList);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserList, ex.type);
            }
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("RatingForumreadbyuid"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("RatingsReadByForumandUsers"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_ValidInput_ReturnCorrectObject()
        {
            string siteName = "h2g2";
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            RatingInfo comment = reviews.RatingCreate(ratingForum, ratingInfo);

            Assert.IsNotNull(comment);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_AsPreMod_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test text";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum
                                  {
                                      Id = uid,
                                      SiteName = siteName,
                                      ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
                                  };
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            RatingInfo comment = reviews.RatingCreate(ratingForum, ratingInfo);

            Assert.IsNotNull(comment);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_NoUser_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = "test", rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(0);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserCredentials, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_BannedUser_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = "test", rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.BannedUser)).Return(true);

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);

            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.UserIsBanned, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_NoText_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            string text = "";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.EmptyText, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_NotSecureWithOption_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            var text = "Here is my rating that is not posted securely";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum { Id = uid, SiteName = siteName };
            var ratingInfo = new RatingInfo { text = text, rating = 0 };

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueInt(0, "CommentForum", "EnforceSecurePosting")).Return(1);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.NotSecure, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_SiteClosed_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(true);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.SiteIsClosed, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }


        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_SiteScheduledClosed_ReturnCorrectError()
        {
            string siteName = "h2g2";
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(true).Constraints(Is.Anything());

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.SiteIsClosed, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_TextBeyondMaxCharLimit_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            

            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MaxCommentCharacterLength")).Return(4);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ExceededTextLimit, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_RatingTooLarge_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum { Id = uid, SiteName = siteName };
            var ratingInfo = new RatingInfo { text = text, rating = 100 };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);



            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MaxForumRatingScore")).Return(2);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.RatingExceedsMaximumAllowed, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_ProcessPreMod_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum { Id = uid, SiteName = siteName, ModerationServiceGroup= ModerationStatus.ForumStatus.PreMod };
            var ratingInfo = new RatingInfo { text = text, rating = 0 };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);



            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "Moderation", "ProcessPreMod")).Return(true);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidProcessPreModState, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_UserAlreadyRated_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum { Id = uid, SiteName = siteName };
            var ratingInfo = new RatingInfo { text = text, rating = 0 };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(true);
            readerUserRating.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MultipleRatingByUser, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_TextLessThanMinCharLimit_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            

            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MinCommentCharacterLength")).Return(100);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MinCharLimitNotReached, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_InvalidHtml_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "<b>test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.XmlFailedParse, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_WithProfanity_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = " (ock ";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.ModClassID).Return(3);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ProfanityFoundInText, ex.type);
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("ratingscreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_NoForum_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            int returnValue;
            reader.Stub(x => x.TryGetIntReturnValue(out returnValue)).OutRef(1).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ForumUnknown, ex.type);
            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_ForumClosed_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            int returnValue;
            reader.Stub(x => x.TryGetIntReturnValue(out returnValue)).OutRef(2).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);
            
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ForumClosed, ex.type);
            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }


        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void RatingCreate_ForumReadOnly_ReturnCorrectError()
        {
            string siteName = "h2g2";
            int siteId = 1;
            string uid = "uid";
            string text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var ratingForum = new RatingForum {Id = uid, SiteName = siteName};
            var ratingInfo = new RatingInfo {text = text, rating = 0};

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            int returnValue;
            reader.Stub(x => x.TryGetIntReturnValue(out returnValue)).OutRef(3).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("ratingscreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);
            var readerUserRating = mocks.DynamicMock<IDnaDataReader>();
            readerUserRating.Stub(x => x.HasRows).Return(false);
            readerUserRating.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("ratingsreadbyforumanduser")).Return(readerUserRating);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var reviews = new Reviews(null, readerCreator, cacheManager, siteList);
            reviews.CallingUser = callingUser;
            try
            {
                reviews.RatingCreate(ratingForum, ratingInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ForumReadOnly, ex.type);
            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }
    }
}