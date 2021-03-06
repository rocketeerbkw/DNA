using System;
using System.Collections.Generic;
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
using BBC.Dna.Common;


namespace BBC.Dna.Api.Tests
{
    /// <summary>
    ///This is a test class for CommentInfoTest and is intended
    ///to contain all CommentInfoTest Unit Tests
    ///</summary>
    [TestClass]
    public class CommentsTest
    {
        public CommentsTest()
        {
            Statistics.InitialiseIfEmpty(null,false);
            ProfanityFilterTests.InitialiseProfanities();
        }

        public MockRepository mocks = new MockRepository();
      
        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumsRead_CorrectInput_ReturnsValidList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var siteId = 1;

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.SiteName).Return(siteName);
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(site);

            Assert.AreEqual(1, forums.CommentForums.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumsRead_NoRows_ReturnsEmptyList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(false);
            site.Stub(x => x.SiteName).Return(siteName);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(site);

            Assert.AreEqual(0, forums.CommentForums.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumsRead_ReadFalse_ReturnsEmptyList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.SiteName).Return(siteName);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(site);

            Assert.AreEqual(0, forums.CommentForums.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumsRead_DBError_ThrowsExpection()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.SiteName).Return(siteName);
            reader.Stub(x => x.Execute()).Throw(new Exception("DB Error"));
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            try
            {
                comments.GetCommentForumListBySite(site);
                throw new Exception("No expection thrown)");
            }
            catch (ApiException ex)
            {

                Assert.AreEqual(ErrorType.Unknown,ex.type);
                
            }
            
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumsReadWithPrefix_CorrectInput_ReturnsValidList()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.SiteName).Return(siteName);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitenameprefix")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(site, "prefix");

            Assert.AreEqual(1, forums.CommentForums.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumsreadbysitenameprefix"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumReadByUid_FromDbCorrectInput_ReturnsValidList()
        {
            
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>(); 
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "";
            var postId = 1;

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
            readerComments.Stub(x => x.GetInt32NullAsZero("id")).Return(postId);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            site.Stub(x => x.SiteName).Return(siteName);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("[sitename]-[postid]");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.GetCommentForumByUid(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.commentList.TotalCount);
            Assert.AreEqual(1, forum.commentList.comments.Count);
            Assert.AreEqual( siteName + "-" + postId.ToString(), forum.commentList.comments[0].ComplaintUri);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumReadByUid_FromDbNotSignedIn_ReturnsValidList()
        {

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "";
            var userId = 1;

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("NotSignedInUserId")).Return(userId);
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.GetCommentForumByUid(uid, site);

            Assert.IsNotNull(forum);
            Assert.IsTrue(forum.allowNotSignedInCommenting);
            Assert.AreEqual(userId, forum.NotSignedInUserId);
            Assert.AreEqual(1, forum.commentList.TotalCount);
            Assert.AreEqual(1, forum.commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumReadByUid_CacheOutOfDate_ReturnsValidList()
        {
            var comments = new Comments(null, null, null, null);
            
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "";
            string cacheKey = comments.CommentForumCacheKey("", 0);

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


            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.GetCommentForumByUid(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.commentList.TotalCount);
            Assert.AreEqual(1, forum.commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumReadByUid_CacheInDateMissingActualObject_ReturnsValidList()
        {
            var lastUpdate = DateTime.Now.AddDays(1);
            var comments = new Comments(null, null, null, null);
            
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "";
            string cacheKey = comments.CommentForumCacheKey("", 0);

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


            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.GetCommentForumByUid(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.commentList.TotalCount);
            Assert.AreEqual(1, forum.commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbyforumid"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentForumReadByUid_CacheValid_ReturnsValidList()
        {
            var lastUpdate = DateTime.Now.AddDays(1);
            var uid = "testUid";
            var validForum = new CommentForum { Id = uid };
            var comments = new Comments(null, null, null, null);
            
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            string cacheKey = comments.CommentForumCacheKey(uid, 0);

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


            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("CommentforumGetLastUpdate")).Return(readerLastUpdate);


            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.GetCommentForumByUid(uid, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(uid, forum.Id);
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentsreadbyforumid"));
        }


         /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_FromDbCorrectInput_ReturnsValidList()
        {
            
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var siteId = 1;
            var userName = "myudng";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerComments.Stub(x => x.DoesFieldExist("SiteSpecificDisplayName")).Return(true);
            readerComments.Stub(x => x.GetStringNullAsEmpty("SiteSpecificDisplayName")).Return(userName);
            readerComments.Stub(x => x.DoesFieldExist("tweetid")).Return(true);
            readerComments.Stub(x => x.GetLongNullAsZero("tweetid")).Return(1);
            readerComments.Stub(x => x.DoesFieldExist("nerovalue")).Return(true);
            readerComments.Stub(x => x.GetInt32NullAsZero("nerovalue")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "User", "UseSiteSuffix")).Return(false);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
            Assert.AreEqual(string.Empty, commentList.comments[0].User.SiteSpecificDisplayName);//even though site suffix set, option not supported
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitename"));
        }

        [TestMethod]
        public void CommentsReadBySite_NotSignedInUser_ReturnsValidList()
        {

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var siteId = 1;
            var userName = "myudng";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerComments.Stub(x => x.GetStringNullAsEmpty("AnonymousUserName")).Return(userName);
            readerComments.Stub(x => x.DoesFieldExist("AnonymousUserName")).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "User", "UseSiteSuffix")).Return(false);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
            Assert.AreEqual(userName, commentList.comments[0].User.DisplayName);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_FromDbCorrectInputEditorsPicks_ReturnsValidList()
        {

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var siteId = 1;
            var userName = "myudng";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.SiteID).Return(siteId);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.DoesFieldExist("SiteSpecificDisplayName")).Return(true);
            readerComments.Stub(x => x.GetStringNullAsEmpty("SiteSpecificDisplayName")).Return(userName);
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitenameeditorpicksfilter")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "User", "UseSiteSuffix")).Return(true);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.FilterBy = FilterBy.EditorPicks;
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
            Assert.AreEqual(userName, commentList.comments[0].User.SiteSpecificDisplayName);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitenameeditorpicksfilter"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_WithPrefixFromDbCorrectInput_ReturnsValidList()
        {

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitenameprefix")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var commentList = comments.GetCommentsListBySite(site, "prefix");

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitenameprefix"));
        }

         /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_CacheOutOfDate_ReturnsValidList()
         {
             var comments = new Comments(null, null, null, null);

             var siteList = mocks.DynamicMock<ISiteList>();
             var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
             var site = mocks.DynamicMock<ISite>();
             var readerComments = mocks.DynamicMock<IDnaDataReader>();
             var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

             var cacheManager = mocks.DynamicMock<ICacheManager>();
             var siteName = "h2g2";
             string cacheKey = comments.CommentListCacheKey(0, "");

             cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(DateTime.Now.AddDays(1));
             site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
             site.Stub(x => x.IsEmergencyClosed).Return(false);
             site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

             readerComments.Stub(x => x.HasRows).Return(true);
             readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
             readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
             readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);
             readerCreator.Stub(x => x.CreateDnaDataReader("commentsgetlastupdatebysite")).Return(readerLastUpdate);

             readerLastUpdate.Stub(x => x.HasRows).Return(true);
             readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
             readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(DateTime.Now.AddDays(-1));

             site.Stub(x => x.SiteID).Return(1);
             siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
             siteList.Stub(x => x.GetSite(siteName)).Return(site);
             mocks.ReplayAll();

             comments = new Comments(null, readerCreator, cacheManager, siteList);
             var commentList = comments.GetCommentsListBySite(site);

             Assert.IsNotNull(commentList);
             Assert.AreEqual(1, commentList.TotalCount);
             Assert.AreEqual(1, commentList.comments.Count);
             readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitename"));
         }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_CacheInDateMissingActualObject_ReturnsValidList()
        {
            var lastUpdate = DateTime.Now.AddDays(1);
            var comments = new Comments(null, null, null, null);

            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            string cacheKey = comments.CommentListCacheKey(0, "");

            cacheManager.Stub(x => x.GetData(cacheKey)).Return(null);
            cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(lastUpdate);
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsgetlastupdatebysite")).Return(readerLastUpdate);

            readerLastUpdate.Stub(x => x.HasRows).Return(true);
            readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(lastUpdate);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            comments = new Comments(null, readerCreator, cacheManager, siteList);
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentsreadbysitename"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentsReadBySite_ValidCache_ReturnsValidList()
        {
            var lastUpdate = DateTime.Now.AddDays(1);
            var comments = new Comments(null, null, null, null);
            var validCommentsList = new CommentsList {comments = new List<CommentInfo>()};
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerLastUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            string cacheKey = comments.CommentListCacheKey(0, "");

            cacheManager.Stub(x => x.GetData(cacheKey)).Return(validCommentsList);
            cacheManager.Stub(x => x.GetData(cacheKey + "|LASTUPDATED")).Return(lastUpdate);
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsgetlastupdatebysite")).Return(readerLastUpdate);

            readerLastUpdate.Stub(x => x.HasRows).Return(true);
            readerLastUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerLastUpdate.Stub(x => x.GetDateTime("lastupdated")).Return(lastUpdate);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            comments = new Comments(null, readerCreator, cacheManager, siteList);
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentsreadbysitename"));
        }


        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_ValidInput_ReturnCorrectObject()
        {
            

            var siteName = "h2g2";
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            var comment = comments.CreateComment(commentForum, commentInfo);

            Assert.IsNotNull(comment);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NotSignedInUserWithDisplayName_ReturnCorrectObject()
        {
            var siteName = "h2g2";
            var uid = "uid";
            var text = "test comment";
            var displayName = "notsignedin";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName, allowNotSignedInCommenting=true, NotSignedInUserId=1 };
            var commentInfo = new CommentInfo { text = text };
            commentInfo.User = new User { DisplayName = displayName };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            var comment = comments.CreateComment(commentForum, commentInfo);

            Assert.IsNotNull(comment);
            Assert.AreEqual(displayName, comment.User.DisplayName);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
            reader.AssertWasCalled(x => x.AddParameter("nickname", displayName));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_AsPreMod_ReturnCorrectError()
        {            
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test text";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName, ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            var comment = comments.CreateComment(commentForum, commentInfo);

            Assert.IsNotNull(comment);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NoUser_ReturnCorrectError()
        {           
            var siteName = "h2g2";
            var uid = "uid";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = "test" };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(0);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserCredentials, ex.type);
                
            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_BannedUser_ReturnCorrectError()
        {
            var siteName = "h2g2";
            var uid = "uid";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = "test" };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.BannedUser)).Return(true);

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.UserIsBanned, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NoText_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var uid = "uid";
            var text = "";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.EmptyText, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NotSecureWithSiteOption_ReturnCorrectError()
        {
            var siteName = "h2g2";
            var uid = "uid";
            var text = "Here is my text that is not posted securely";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueInt(0, "CommentForum","EnforceSecurePosting")).Return(1);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.NotSecure, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NotSecureWithoutSiteOption_ReturnCorrectComment()
        {
            var siteName = "h2g2";
            var uid = "uid";
            var text = "Here is my text that is not posted securely";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            siteList.Stub(x => x.GetSiteOptionValueInt(0, "CommentForum", "EnforceSecurePosting")).Return(0);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            comments.CreateComment(commentForum, commentInfo);
            
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_SiteClosed_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(true);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.SiteIsClosed, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }


        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_SiteScheduledClosed_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(true).Constraints(Is.Anything());

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.SiteIsClosed, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_TextBeyondMaxCharLimit_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);



            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MaxCommentCharacterLength")).Return(4);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ExceededTextLimit, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_TextLessThanMinCharLimit_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);



            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MinCommentCharacterLength")).Return(100);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MinCharLimitNotReached, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_InvalidHtml_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "<b>test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.XmlFailedParse, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_WithProfanity_ReturnCorrectError()
        {
            

            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = " (ock ";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.ModClassID).Return(3);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ProfanityFoundInText, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_WithWhiteListTerm_AddsCorrectNotes()
        {
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = " Bomb ";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            site.Stub(x => x.ModClassID).Return(3);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            comments.CreateComment(commentForum, commentInfo);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
            reader.AssertWasCalled(x => x.AddParameter("modnotes", "Filtered terms: bomb"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_NoForum_ReturnCorrectError()
        {
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

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
            reader.Stub(x => x.TryGetIntReturnValue(out returnValue)).OutRef(1).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
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
        public void CommentCreate_ForumClosed_ReturnCorrectError()
        {
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

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
            reader.Stub(x => x.TryGetIntReturnValue(out returnValue)).OutRef(2).Return(true);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
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
        public void CommentCreate_ForumClosed_NotableUser_ReturnResults()
        {
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

            callingUser.Stub(x => x.IsSecureRequest).Return(true);

            callingUser.Stub(x => x.UserID).Return(1);

            callingUser.Stub(x => x.IsUserA(UserTypes.Notable)).Return(true);

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
           
            var retVal = comments.CreateComment(commentForum, commentInfo);
            Assert.AreEqual(text, retVal.text);
            reader.AssertWasCalled(x => x.Execute());
           
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentCreate_ForumReadOnly_ReturnCorrectError()
        {
            var siteName = "h2g2";
            var siteId = 1;
            var uid = "uid";
            var text = "test comment";
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var callingUser = mocks.DynamicMock<ICallingUser>();
            var commentForum = new CommentForum { Id = uid, SiteName = siteName };
            var commentInfo = new CommentInfo { text = text };

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

            readerCreator.Stub(x => x.CreateDnaDataReader("commentcreate")).Return(reader);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.CallingUser = callingUser;
            try
            {
                comments.CreateComment(commentForum, commentInfo);
                throw new Exception("No exception thrown");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.ForumReadOnly, ex.type);

            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentcreate"));
        }


        [TestMethod]
        public void GetStartIndexForPostId_ValidResult_ReturnCorrectIndex()
        {
            var itemsPerPage = 10;
            var postIndex = 25;
            var expectedStartIndex = 20;
            var postId = 5;
            var sortDirection = SortDirection.Ascending;
            var sortBy = SortBy.Created;

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("startIndex")).Return(postIndex);
            readerCreator.Stub(x => x.CreateDnaDataReader("getindexofcomment")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                ItemsPerPage= itemsPerPage,
                SortDirection =sortDirection,
                SortBy = sortBy
            };

            Assert.AreEqual(expectedStartIndex, comments.GetStartIndexForPostId(postId));
            reader.AssertWasCalled((x => x.AddParameter("postid", postId)));
            reader.AssertWasCalled((x => x.AddParameter("sortby", sortBy.ToString())));
            reader.AssertWasCalled((x => x.AddParameter("sortdirection", sortDirection.ToString())));

        }

        [TestMethod]
        public void GetStartIndexForPostId_NoResult_ReturnCorrectException()
        {
            var itemsPerPage = 10;
            var postIndex = 25;
            var postId = 5;
            var sortDirection = SortDirection.Ascending;
            var sortBy = SortBy.Created;

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("startIndex")).Return(postIndex);
            readerCreator.Stub(x => x.CreateDnaDataReader("getindexofcomment")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                ItemsPerPage = itemsPerPage,
                SortDirection = sortDirection,
                SortBy = sortBy
            };

            try
            {
                comments.GetStartIndexForPostId(postId);
                throw new Exception("Should have thrown expection");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.CommentNotFound, ex.type);
            }

            reader.AssertWasCalled((x => x.AddParameter("postid", postId)));
            reader.AssertWasCalled((x => x.AddParameter("sortby", sortBy.ToString())));
            reader.AssertWasCalled((x => x.AddParameter("sortdirection", sortDirection.ToString())));

        }

        [TestMethod]
        public void GetStartIndexForPostId_NoRead_ReturnCorrectException()
        {
            var itemsPerPage = 10;
            var postIndex = 25;
            var postId = 5;
            var sortDirection = SortDirection.Ascending;
            var sortBy = SortBy.Created;

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("startIndex")).Return(postIndex);
            readerCreator.Stub(x => x.CreateDnaDataReader("getindexofcomment")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                ItemsPerPage = itemsPerPage,
                SortDirection = sortDirection,
                SortBy = sortBy
            };

            try
            {
                comments.GetStartIndexForPostId(postId);
                throw new Exception("Should have thrown expection");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.CommentNotFound, ex.type);
            }

            reader.AssertWasCalled((x => x.AddParameter("postid", postId)));
            reader.AssertWasCalled((x => x.AddParameter("sortby", sortBy.ToString())));
            reader.AssertWasCalled((x => x.AddParameter("sortdirection", sortDirection.ToString())));

        }

        [TestMethod]
        public void GetStartIndexForPostId_DbException_ReturnCorrectException()
        {
            var itemsPerPage = 10;
            var postId = 5;
            var sortDirection = SortDirection.Ascending;
            var sortBy = SortBy.Created;
            var expectedException = "dbexception thrown";

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Execute()).Throw(new Exception(expectedException)); ;
            readerCreator.Stub(x => x.CreateDnaDataReader("getindexofcomment")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                ItemsPerPage = itemsPerPage,
                SortDirection = sortDirection,
                SortBy = sortBy
            };

            try
            {
                comments.GetStartIndexForPostId(postId);
                throw new Exception("Should have thrown expection");
            }
            catch (Exception ex)
            {
                Assert.AreEqual(expectedException, ex.Message);
            }

            reader.AssertWasCalled((x => x.AddParameter("postid", postId)));
            reader.AssertWasCalled((x => x.AddParameter("sortby", sortBy.ToString())));
            reader.AssertWasCalled((x => x.AddParameter("sortdirection", sortDirection.ToString())));

        }

        [TestMethod]
        public void CreateCommentRating_AsAnonymousWithoutDetails_ThrowsError()
        {
            var value = 1;
            var postId = 1;
            var userid = 0;
            var commentForum = new CommentForum() { ForumID=1 };
            ISite site = null;
            

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("value")).Return(value);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
            };

            try
            {
                comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserAttributes, ex.type);
            }

            reader.AssertWasNotCalled(x => x.Execute());
        }

        [TestMethod]
        public void CreateCommentRating_AsAnonymous_ReturnsValue()
        {
            var value = 1;
            var posvalue = 20;
            var negvalue = -10;
            var postId = 1;
            var userid = 0;
            var commentForum = new CommentForum() { ForumID = 1 };
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(1);


            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("nerovalue")).Return(value);
            reader.Stub(x => x.GetInt32NullAsZero("neropositivevalue")).Return(posvalue);
            reader.Stub(x => x.GetInt32NullAsZero("neronegativevalue")).Return(negvalue);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                IpAddress = "1.1.1.1",
                BbcUid = Guid.NewGuid()
            };

            var retVal = comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            Assert.AreEqual(value, retVal.neroValue);
            Assert.AreEqual(posvalue, retVal.positiveNeroValue);
            Assert.AreEqual(negvalue, retVal.negativeNeroValue);
            reader.AssertWasCalled(x => x.Execute());
        }

        [TestMethod]
        public void CreateCommentRating_AsAnonymousWithoutIP_ThrowsError()
        {
            var value = 1;
            var postId = 1;
            var userid = 0;
            var commentForum = new CommentForum() { ForumID = 1 };
            ISite site = null;


            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("value")).Return(value);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                //IpAddress = "1.1.1.1",
                BbcUid = Guid.NewGuid()
            };

            try
            {
                comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserAttributes, ex.type);
            }

            reader.AssertWasNotCalled(x => x.Execute());
        }

        [TestMethod]
        public void CreateCommentRating_AsAnonymousWithoutUID_ThrowsError()
        {
            var value = 1;
            var postId = 1;
            var userid = 0;
            var commentForum = new CommentForum() { ForumID = 1 };
            ISite site = null;


            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("value")).Return(value);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                IpAddress = "1.1.1.1",
                //BbcUid = Guid.NewGuid()
            };

            try
            {
                comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.MissingUserAttributes, ex.type);
            }

            reader.AssertWasNotCalled(x => x.Execute());
        }


        [TestMethod]
        public void CreateCommentRating_AsUser_ReturnsValue()
        {
            var value = 1;
            var posvalue = 20;
            var negvalue = -10;
            var postId = 1;
            var userid = 1;
            var commentForum = new CommentForum() { ForumID = 1 };
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(1);


            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("nerovalue")).Return(value);
            reader.Stub(x => x.GetInt32NullAsZero("neropositivevalue")).Return(posvalue);
            reader.Stub(x => x.GetInt32NullAsZero("neronegativevalue")).Return(negvalue);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                IpAddress = "1.1.1.1",
                BbcUid = Guid.NewGuid()
            };

            var retVal = comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            Assert.AreEqual(value, retVal.neroValue);
            Assert.AreEqual(posvalue, retVal.positiveNeroValue);
            Assert.AreEqual(negvalue, retVal.negativeNeroValue);
            reader.AssertWasCalled(x => x.Execute());
        }

        [TestMethod]
        public void CreateCommentRating_DBThrowsException_ThrowsError()
        {
            var value = 1;
            var postId = 1;
            var userid = 0;
            var commentForum = new CommentForum() { ForumID = 1 };
            ISite site = null;


            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("value")).Return(value);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentratingcreate")).Return(reader);
            reader.Stub(x => x.Execute()).Throw(new Exception("test"));
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, null, null)
            {
                IpAddress = "1.1.1.1",
                BbcUid = Guid.NewGuid()
            };

            try
            {
                comments.CreateCommentRating(commentForum, site, postId, userid, (short)value);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.Unknown, ex.type);
            }

            //reader.AssertWasNotCalled(x => x.Execute());
        }

        [TestMethod]
        public void CreateCommentForum_AlreadyExists_DoesNotCreate()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "uid";
            var commentForum = new CommentForum
            {
                Id = uid,


            };

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

            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.CreateCommentForum(commentForum, site);

            Assert.IsNotNull(forum);
            Assert.AreEqual(1, forum.commentList.TotalCount);
            Assert.AreEqual(1, forum.commentList.comments.Count);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        [TestMethod]
        public void CreateCommentForum_NoExists_CreatesForum()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerCreate = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            readerComments.Stub(x => x.HasRows).Return(false);
            readerComments.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(readerCreate);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);

            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };


            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.CreateCommentForum(commentForum, site);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        [TestMethod]
        public void CreateAndUpdateCommentForum_AlreadyExists_ThenUpdate()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();
            var readerUpdate = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";
            var uid = "uid";
            var commentForum = new CommentForum
            {
                Id = uid,
                Title = "title",
                ParentUri = "https://www.bbc.co.uk"

            };

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            reader.Stub(x => x.GetStringNullAsEmpty("UID")).Return(uid);
            reader.Stub(x => x.GetStringNullAsEmpty("Title")).Return(uid);
            reader.Stub(x => x.GetStringNullAsEmpty("Url")).Return("https://www.bbc.co.uk");
            

            readerUpdate.Stub(x => x.HasRows).Return(true);
            readerUpdate.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerUpdate.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);


            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Twice();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);

            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumupdate")).Return(readerUpdate);
            

            site.Stub(x => x.SiteID).Return(1);
            siteList.Stub(x => x.GetSiteOptionValueString(1, "General", "ComplaintUrl")).Return("http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.CreateAndUpdateCommentForum(commentForum, site, null);

            Assert.IsNotNull(forum);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumupdate"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        [TestMethod]
        public void CreateAndUpdateCommentForum_NoExists_CreatesForum()
        {
            var siteList = mocks.DynamicMock<ISiteList>();
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var readerCreate = mocks.DynamicMock<IDnaDataReader>();
            var readerComments = mocks.DynamicMock<IDnaDataReader>();

            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteName = "h2g2";

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            readerComments.Stub(x => x.HasRows).Return(false);
            readerComments.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumreadbyuid")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbyforumid")).Return(readerComments);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(readerCreate);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);

            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };


            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forum = comments.CreateAndUpdateCommentForum(commentForum, site, null);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumreadbyuid"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

    }
}
