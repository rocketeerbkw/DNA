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

namespace SiteActivityProcessor.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class PostComplaintTests
    {
        public PostComplaintTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public MockRepository Mocks = new MockRepository();


        [TestMethod]
        public void PostComplaintTests_ComplaintPost_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.Now;
            var statusId = SiteActivityType.ComplaintPost;
            var authorUserId = 2;
            var authorUsername = "authorUsername";
            var subject = "subejct";
            var modReason = "Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var url = "";
            var type = "post";
            var data = string.Format(ComplaintPostEvent.DataFormat, authorUserId, authorUsername, type, forumid, postid, threadid, url
                    , subject, modReason);


            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Fail);
            dataReader.Stub(x => x.GetInt32NullAsZero("complaintantID_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainantUserName")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainttext")).Return(modReason);
            dataReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return(subject);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = ComplaintPostEvent.CreateComplaintPostEventActivity(dataReader, creator);

            Assert.AreEqual(siteId, result.SiteId);
            Assert.AreEqual(dateCreated, result.Date.DateTime);
            Assert.AreEqual(statusId, result.Type);
            Assert.AreEqual(data, result.ActivityData.InnerXml);


        }

        [TestMethod]
        public void PostComplaintTests_ComplaintComment_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.Now;
            var statusId = SiteActivityType.ComplaintPost;
            var authorUserId = 2;
            var authorUsername = "authorUsername";
            var subject = "subject";
            var modReason = "Unsuitable/Broken URL";
            var postid = 4;
            var threadid = 5;
            var forumid = 6;
            var url = "http://bbc.co.uk";
            var type = "comment";
            var data = string.Format(ComplaintPostEvent.DataFormat, authorUserId, authorUsername, type, forumid, postid, threadid, url
                    , subject, modReason);


            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return((int)ModerationDecisionStatus.Fail);
            dataReader.Stub(x => x.GetInt32NullAsZero("complaintantID_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            dataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumid);
            dataReader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainantUserName")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("complainttext")).Return(modReason);
            dataReader.Stub(x => x.GetStringNullAsEmpty("subject")).Return(subject);
            dataReader.Stub(x => x.GetStringNullAsEmpty("parenturl")).Return(url);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = ComplaintPostEvent.CreateComplaintPostEventActivity(dataReader, creator);

            Assert.AreEqual(siteId, result.SiteId);
            Assert.AreEqual(dateCreated, result.Date.DateTime);
            Assert.AreEqual(statusId, result.Type);
            Assert.AreEqual(data, result.ActivityData.InnerXml);


        }

        
       
    }
}
