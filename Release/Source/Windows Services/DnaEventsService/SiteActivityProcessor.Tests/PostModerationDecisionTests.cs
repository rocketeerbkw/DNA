using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Rhino.Mocks;
using BBC.DNA.Moderation.Utils;
using Dna.SiteEventProcessor;
using BBC.Dna.Moderation;
using System.Xml.Linq;

namespace SiteActivityProcessor.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class PostModerationDecisionTests
    {
        public PostModerationDecisionTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public MockRepository Mocks = new MockRepository();


        [TestMethod]
        public void PostModerationDecisionTests_FailedModPost_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModeratePostFailed;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var url = "";
            var type = "post";
            var data = string.Format(PostModerationDecision.DataFormatFailed, forumid, postid, threadid, url, type, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Fail);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("ModReason")).Return(modReason);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = PostModerationDecision.CreatePostModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result[0].SiteId);
            Assert.AreEqual(dateCreated, result[0].Date.DateTime);
            Assert.AreEqual(statusId, result[0].Type);
            Assert.AreEqual(data.ToString(), result[0].ActivityData.ToString());


        }

        [TestMethod]
        public void PostModerationDecisionTests_ReferredModPost_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModeratePostReferred;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var url = "";
            var type = "post";
            var data = string.Format(PostModerationDecision.DataFormatReferred, forumid, postid, threadid, url, type, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Referred);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("Notes")).Return(modReason);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = PostModerationDecision.CreatePostModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result[0].SiteId);
            Assert.AreEqual(dateCreated, result[0].Date.DateTime);
            Assert.AreEqual(statusId, result[0].Type);
            Assert.AreEqual(data.ToString(), result[0].ActivityData.ToString());


        }

        [TestMethod]
        public void PostModerationDecisionTests_ReferredModComment_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModeratePostReferred;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var url = "http://bbc.co.uk";
            var type = "comment";
            var data = string.Format(PostModerationDecision.DataFormatReferred, forumid, postid, threadid, url, type, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Referred);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("Notes")).Return(modReason);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("parenturl")).Return(url);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = PostModerationDecision.CreatePostModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result[0].SiteId);
            Assert.AreEqual(dateCreated, result[0].Date.DateTime);
            Assert.AreEqual(statusId, result[0].Type);
            Assert.AreEqual(data.ToString(), result[0].ActivityData.ToString());


        }

        [TestMethod]
        public void PostModerationDecisionTests_Passed_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ComplaintPostRejected;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var complaintText = "my complaint";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var complainantid = 1;
            var url = "";
            var type = "post";
            var data = string.Format(PostModerationDecision.DataFormatReject, forumid, postid, threadid, url, type, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Passed);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("Notes")).Return(modReason);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainttext")).Return(complaintText);
            dataReader.Stub(x => x.GetInt32NullAsZero("complainantid")).Return(complainantid);
            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = PostModerationDecision.CreatePostModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result[0].SiteId);
            Assert.AreEqual(dateCreated, result[0].Date.DateTime);
            Assert.AreEqual(statusId, result[0].Type);
            Assert.AreEqual(data.ToString(), result[0].ActivityData.ToString());


        }

        [TestMethod]
        public void PostModerationDecisionTests_Reinstated_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModeratePostFailedReversal;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var complaintText = "From EditPost: Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var complainantid = 1;
            var url = "";
            var type = "post";
            var data = string.Format(PostModerationDecision.DataFormatReversed, forumid, postid, threadid, url, type, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Passed);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("Notes")).Return(modReason);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainttext")).Return(complaintText);
            dataReader.Stub(x => x.GetInt32NullAsZero("complainantid")).Return(complainantid);
            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = PostModerationDecision.CreatePostModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result[0].SiteId);
            Assert.AreEqual(dateCreated, result[0].Date.DateTime);
            Assert.AreEqual(statusId, result[0].Type);
            Assert.AreEqual(data.ToString(), result[0].ActivityData.ToString());


        }
    }
}
