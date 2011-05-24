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
using BBC.Dna.Objects;
using System.Xml.Linq;

namespace SiteActivityProcessor.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class ArticleModerationDecisionTests
    {
        public ArticleModerationDecisionTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public MockRepository Mocks = new MockRepository();

        [TestMethod]
        public void SiteEventArticleModerationDecisionTests_FailedModPost_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModerateArticleFailed;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var h2g2Id = 4;
            var data = string.Format(ArticleModerationDecision.DataFormatFailed, h2g2Id, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("statusid")).Return((int)ModerationDecisionStatus.Fail);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(h2g2Id);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("ModReason")).Return(modReason);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = ArticleModerationDecision.CreateArticleModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result.SiteId);
            Assert.AreEqual(dateCreated, result.Date.DateTime);
            Assert.AreEqual(statusId, result.Type);
            Assert.AreEqual(data.ToString(), result.ActivityData.ToString());


        }

        [TestMethod]
        public void SiteEventArticleModerationDecisionTests_ReferredModPost_ReturnsCorrectObject()
        {
            var siteId = 1;
            var dateCreated = DateTime.UtcNow;
            var statusId = SiteActivityType.ModerateArticleReferred;
            var authorUserId = 2;
            var modUserId = 3;
            var authorUsername = "authorUsername";
            var modUsername = "modUsername";
            var modReason = "Unsuitable/Broken URL";
            var h2g2Id = 4;
            var data =string.Format(ArticleModerationDecision.DataFormatReferred, h2g2Id, authorUserId, authorUsername, modUserId, modUsername,
                modReason);

            var dataReader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            dataReader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            dataReader.Stub(x => x.GetDateTime("DateCreated")).Return(dateCreated);
            dataReader.Stub(x => x.GetInt32NullAsZero("statusid")).Return((int)ModerationDecisionStatus.Referred);
            dataReader.Stub(x => x.GetInt32NullAsZero("author_userid")).Return(authorUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("mod_userid")).Return(modUserId);
            dataReader.Stub(x => x.GetInt32NullAsZero("h2g2id")).Return(h2g2Id);
            dataReader.Stub(x => x.GetStringNullAsEmpty("author_username")).Return(authorUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("mod_username")).Return(modUsername);
            dataReader.Stub(x => x.GetStringNullAsEmpty("Notes")).Return(modReason);

            creator.Stub(x => x.CreateDnaDataReader("insertsiteactivityitem")).Return(dataReader);

            Mocks.ReplayAll();

            var result = ArticleModerationDecision.CreateArticleModerationDecisionActivity(dataReader, creator);

            Assert.AreEqual(siteId, result.SiteId);
            Assert.AreEqual(dateCreated, result.Date.DateTime);
            Assert.AreEqual(statusId, result.Type);
            Assert.AreEqual(data.ToString(), result.ActivityData.ToString());


        }
    }
}
