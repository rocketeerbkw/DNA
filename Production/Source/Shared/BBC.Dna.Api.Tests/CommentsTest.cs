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
            Statistics.InitialiseIfEmpty();
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

            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(siteName);

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
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(siteName);

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
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(siteName);

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
            reader.Stub(x => x.Execute()).Throw(new Exception("DB Error"));
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitename")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            try
            {
                comments.GetCommentForumListBySite(siteName);
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
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("sitename")).Return(siteName);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumsreadbysitenameprefix")).Return(reader);
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            var forums = comments.GetCommentForumListBySite(siteName, "prefix");

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
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
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

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            site.Stub(x => x.ModerationStatus).Return(ModerationStatus.SiteStatus.UnMod);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            readerComments.Stub(x => x.HasRows).Return(true);
            readerComments.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerComments.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitename")).Return(readerComments);
            
            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
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
        public void CommentsReadBySite_FromDbCorrectInputEditorsPicks_ReturnsValidList()
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
            readerCreator.Stub(x => x.CreateDnaDataReader("commentsreadbysitenameeditorpicksfilter")).Return(readerComments);

            siteList.Stub(x => x.GetSite(siteName)).Return(site);
            mocks.ReplayAll();

            var comments = new Comments(null, readerCreator, cacheManager, siteList);
            comments.FilterBy = FilterBy.EditorPicks;
            var commentList = comments.GetCommentsListBySite(site);

            Assert.IsNotNull(commentList);
            Assert.AreEqual(1, commentList.TotalCount);
            Assert.AreEqual(1, commentList.comments.Count);
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


            callingUser.Stub(x => x.UserID).Return(1);
            callingUser.Stub(x => x.IsUserA(UserTypes.SuperUser)).Return(false).Constraints(Is.Anything());

            cacheManager.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());

            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(1);

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
            var text = "profanity";
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
                Assert.AreEqual(ErrorType.ProfanityFoundInText, ex.type);

            }

            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentcreate"));
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

       
        

    }
}
