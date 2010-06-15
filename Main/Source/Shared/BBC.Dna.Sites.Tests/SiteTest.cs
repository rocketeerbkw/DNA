using BBC.Dna.Moderation.Utils;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using System;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for SiteTest and is intended
    ///to contain all SiteTest Unit Tests
    ///</summary>
    [TestClass]
    public class SiteTest
    {
        private readonly MockRepository _mocks = new MockRepository();

        /// <summary>
        ///A test for Site Constructor
        ///</summary>
        [TestMethod]
        public void SiteConstructorTest()
        {
            CreateDefaultSiteObject();
        }


        [TestMethod]
        public void AddReviewForum_ValidInput_ReturnsNothing()
        {
            Site site = CreateDefaultSiteObject();
            site.AddReviewForum("test", 1);
            // you can add but never retrieve?
        }

        [TestMethod]
        public void AddOpenCloseTime_ValidInput_ReturnsItemInList()
        {
            Site site = CreateDefaultSiteObject();
            site.AddOpenCloseTime(0, 0, 0, 0);
            Assert.AreEqual(1, site.OpenCloseTimes.Count);
        }

        [TestMethod]
        public void AddSkin_ValidInput_ReturnsItemInList()
        {
            Site site = CreateDefaultSiteObject();
            site.AddSkin("test", "test", false);
            Assert.IsTrue(site.DoesSkinExist("test"));
        }

        [TestMethod]
        public void GetEmail_AsEditor_ReturnsEditorsEmail()
        {
            Site site = CreateDefaultSiteObject();
            Assert.AreEqual("editorsEmail", site.GetEmail(Site.EmailType.Editors));
        }

        [TestMethod]
        public void GetEmail_AsModerators_ReturnsModeratorsEmail()
        {
            Site site = CreateDefaultSiteObject();
            Assert.AreEqual("moderatorsEmail", site.GetEmail(Site.EmailType.Moderators));
        }

        [TestMethod]
        public void GetEmail_AsFeedback_ReturnsFeedbackEmail()
        {
            Site site = CreateDefaultSiteObject();
            Assert.AreEqual("feedbackEmail", site.GetEmail(Site.EmailType.Feedback));
        }

        [TestMethod]
        public void ModerationStatus_AsPreMod_ReturnsCorrectEnum()
        {
            int id = 5;
            string name = string.Empty;
            int threadOrder = 0;
            bool preModeration = true;
            string defaultSkin = string.Empty;
            bool noAutoSwitch = false;
            string description = string.Empty;
            string shortName = string.Empty;
            string moderatorsEmail = "moderatorsEmail";
            string editorsEmail = "editorsEmail";
            string feedbackEmail = "feedbackEmail";
            int autoMessageUserID = 0;
            bool passworded = false;
            bool unmoderated = false;
            bool articleGuestBookForums = false;
            string config = string.Empty;
            string emailAlertSubject = string.Empty;
            int threadEditTimeLimit = 0;
            int eventAlertMessageUserID = 0;
            int allowRemoveVote = 0;
            int includeCrumbtrail = 0;
            int allowPostCodesInSearch = 0;
            bool queuePostings = false;
            bool emergencyClosed = false;
            int minAge = 0;
            int maxAge = 0;
            int modClassID = 0;
            string ssoService = string.Empty;
            bool useIdentitySignInSystem = false;
            string skinSet = string.Empty;
            string IdentityPolicy = string.Empty;
            
            string connection = string.Empty;
            var target = new Site(id, name, threadOrder, preModeration, defaultSkin, noAutoSwitch, description,
                                  shortName, moderatorsEmail, editorsEmail, feedbackEmail, autoMessageUserID, passworded,
                                  unmoderated, articleGuestBookForums, config, emailAlertSubject, threadEditTimeLimit,
                                  eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail, allowPostCodesInSearch,
                                  queuePostings, emergencyClosed, minAge, maxAge, modClassID, ssoService,
                                  useIdentitySignInSystem, skinSet, IdentityPolicy);
            Assert.AreEqual(id, target.SiteID);


            Assert.AreEqual(ModerationStatus.SiteStatus.PreMod, target.ModerationStatus);
        }

        [TestMethod]
        public void ModerationStatus_AsUnMod_ReturnsCorrectEnum()
        {
            int id = 5;
            string name = string.Empty;
            int threadOrder = 0;
            bool preModeration = false;
            string defaultSkin = string.Empty;
            bool noAutoSwitch = false;
            string description = string.Empty;
            string shortName = string.Empty;
            string moderatorsEmail = "moderatorsEmail";
            string editorsEmail = "editorsEmail";
            string feedbackEmail = "feedbackEmail";
            int autoMessageUserID = 0;
            bool passworded = false;
            bool unmoderated = true;
            bool articleGuestBookForums = false;
            string config = string.Empty;
            string emailAlertSubject = string.Empty;
            int threadEditTimeLimit = 0;
            int eventAlertMessageUserID = 0;
            int allowRemoveVote = 0;
            int includeCrumbtrail = 0;
            int allowPostCodesInSearch = 0;
            bool queuePostings = false;
            bool emergencyClosed = false;
            int minAge = 0;
            int maxAge = 0;
            int modClassID = 0;
            string ssoService = string.Empty;
            bool useIdentitySignInSystem = false;
            string skinSet = string.Empty;
            string IdentityPolicy = string.Empty;
            
            string connection = string.Empty;
            var target = new Site(id, name, threadOrder, preModeration, defaultSkin, noAutoSwitch, description,
                                  shortName, moderatorsEmail, editorsEmail, feedbackEmail, autoMessageUserID, passworded,
                                  unmoderated, articleGuestBookForums, config, emailAlertSubject, threadEditTimeLimit,
                                  eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail, allowPostCodesInSearch,
                                  queuePostings, emergencyClosed, minAge, maxAge, modClassID, ssoService,
                                  useIdentitySignInSystem, skinSet, IdentityPolicy);
            Assert.AreEqual(id, target.SiteID);


            Assert.AreEqual(ModerationStatus.SiteStatus.UnMod, target.ModerationStatus);
        }

        [TestMethod]
        public void ModerationStatus_AsPostMod_ReturnsCorrectEnum()
        {
            Site site = CreateDefaultSiteObject();
            Assert.AreEqual(ModerationStatus.SiteStatus.PostMod, site.ModerationStatus);
        }

        [TestMethod]
        public void AddTopic_ValidLiveTopic_ReturnsCorrectListCount()
        {
            Site site = CreateDefaultSiteObject();
            site.AddTopic(0,"",0,0,0);
            Assert.AreEqual(1, site.GetLiveTopics().Count);
        }

        [TestMethod]
        public void AddTopic_ValidDeletedTopic_ReturnsCorrectListCount()
        {
            Site site = CreateDefaultSiteObject();
            site.AddTopic(0, "", 0, 0, 2);
            Assert.AreEqual(1, site.GetLiveTopics().Count);
            //note it was returned as a live topic...
        }

        [TestMethod]
        public void GetTopicListXml_ValidLiveTopic_ReturnsXML()
        {
            string expectedXml = "<TOPICLIST><TOPIC><TOPICID>0</TOPICID><H2G2ID>0</H2G2ID><SITEID>0</SITEID><TOPICSTATUS>0</TOPICSTATUS><TOPICLINKID>0</TOPICLINKID><TITLE /><FORUMID>0</FORUMID><FORUMPOSTCOUNT>0</FORUMPOSTCOUNT></TOPIC></TOPICLIST>";
            Site site = CreateDefaultSiteObject();
            site.AddTopic(0, "", 0, 0, 0);
            Assert.AreEqual(expectedXml, site.GetTopicListXml().OuterXml);
        }

        [TestMethod]
        public void IsSiteScheduledClosed_NoTimes_ReturnsFalse()
        {
            var site = CreateDefaultSiteObject();
            Assert.IsFalse(site.IsSiteClosed());
        }

        [TestMethod]
        public void IsSiteScheduledClosed_AlreadyHappenedClosed_ReturnsTrue()
        {
            var site = CreateDefaultSiteObject();
            DateTime now = DateTime.Now.AddMinutes(-30);
            site.AddOpenCloseTime(((int)now.DayOfWeek)+1, now.Hour, now.Minute, 1);
            Assert.IsTrue(site.IsSiteScheduledClosed(DateTime.Now));
        }

        [TestMethod]
        public void IsSiteScheduledClosed_AlreadyHappenedClosed_ReturnsFalse()
        {
            var site = CreateDefaultSiteObject();
            DateTime now = DateTime.Now.AddMinutes(-30);
            site.AddOpenCloseTime(((int)now.DayOfWeek) + 1, now.Hour, now.Minute, 0);
            Assert.IsFalse(site.IsSiteScheduledClosed(DateTime.Now));
        }

        [TestMethod]
        public void IsSiteScheduledClosed_NotHappenedClosed_ReturnsTrue()
        {
            var site = CreateDefaultSiteObject();
            DateTime now = DateTime.Now.AddMinutes(30);
            site.AddOpenCloseTime(((int)now.DayOfWeek) + 1, now.Hour, now.Minute, 1);
            Assert.IsTrue(site.IsSiteScheduledClosed(DateTime.Now));
        }

        [TestMethod]
        public void IsSiteScheduledClosed_NotHappenedNotClosed_ReturnsFalse()
        {
            var site = CreateDefaultSiteObject();
            DateTime now = DateTime.Now.AddMinutes(30);
            site.AddOpenCloseTime(((int)now.DayOfWeek) + 1, now.Hour, now.Minute, 0);
            Assert.IsFalse(site.IsSiteScheduledClosed(DateTime.Now));
        }

        [TestMethod]
        public void IsSiteClosed_EmergencyClosed_ReturnsTrue()
        {
            int id = 5;
            string name = string.Empty;
            int threadOrder = 0;
            bool preModeration = true;
            string defaultSkin = string.Empty;
            bool noAutoSwitch = false;
            string description = string.Empty;
            string shortName = string.Empty;
            string moderatorsEmail = "moderatorsEmail";
            string editorsEmail = "editorsEmail";
            string feedbackEmail = "feedbackEmail";
            int autoMessageUserID = 0;
            bool passworded = false;
            bool unmoderated = false;
            bool articleGuestBookForums = false;
            string config = string.Empty;
            string emailAlertSubject = string.Empty;
            int threadEditTimeLimit = 0;
            int eventAlertMessageUserID = 0;
            int allowRemoveVote = 0;
            int includeCrumbtrail = 0;
            int allowPostCodesInSearch = 0;
            bool queuePostings = false;
            bool emergencyClosed = true;
            int minAge = 0;
            int maxAge = 0;
            int modClassID = 0;
            string ssoService = string.Empty;
            bool useIdentitySignInSystem = false;
            string skinSet = string.Empty;
            string IdentityPolicy = string.Empty;
            
            string connection = string.Empty;
            var target = new Site(id, name, threadOrder, preModeration, defaultSkin, noAutoSwitch, description,
                                  shortName, moderatorsEmail, editorsEmail, feedbackEmail, autoMessageUserID, passworded,
                                  unmoderated, articleGuestBookForums, config, emailAlertSubject, threadEditTimeLimit,
                                  eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail, allowPostCodesInSearch,
                                  queuePostings, emergencyClosed, minAge, maxAge, modClassID, ssoService,
                                  useIdentitySignInSystem, skinSet, IdentityPolicy);
            Assert.AreEqual(id, target.SiteID);

            Assert.AreEqual(emergencyClosed, target.IsSiteClosed());
        }


        [TestMethod]
        public void IsSiteClosed_HasHappenedIsClosed_ReturnsTrue()
        {
            var site = CreateDefaultSiteObject();
            DateTime now = DateTime.Now.AddMinutes(-30);
            site.AddOpenCloseTime(((int)now.DayOfWeek) + 1, now.Hour, now.Minute, 1);
            Assert.IsTrue(site.IsSiteClosed());
        }

        [TestMethod]
        public  void AddArticle_ValidArticle_ReturnsNothing()
        {
            var site = CreateDefaultSiteObject();
            site.AddArticle("");
        }

        [TestMethod]
        public void UpdateEveryMessageBoardAdminStatusForSite_ValidResponse_CorrectResult()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(true);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateEveryMessageBoardAdminStatusForSite")).Return(reader);


            _mocks.ReplayAll();

            var actual = CreateDefaultSiteObject();
            var result = actual.UpdateEveryMessageBoardAdminStatusForSite(creator, MessageBoardAdminStatus.Unread);
            Assert.AreEqual("Result", result.GetType().Name);
            Assert.AreEqual("UpdateEveryMessageBoardAdminStatusForSite", result.Type);
        }

        [TestMethod]
        public void UpdateEveryMessageBoardAdminStatusForSite_NoResponse_CorrectError()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(false);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateEveryMessageBoardAdminStatusForSite")).Return(reader);


            _mocks.ReplayAll();

            var actual = CreateDefaultSiteObject();
            var result = actual.UpdateEveryMessageBoardAdminStatusForSite(creator, MessageBoardAdminStatus.Unread);
            Assert.AreEqual("Error", result.GetType().Name);
            Assert.AreEqual("UpdateEveryMessageBoardAdminStatusForSite", result.Type);
        }

        [TestMethod]
        public void UpdateEveryMessageBoardAdminStatusForSite_InvalidResponse_CorrectError()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(3).Return(true);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateEveryMessageBoardAdminStatusForSite")).Return(reader);


            _mocks.ReplayAll();

            var actual = CreateDefaultSiteObject();
            var result = actual.UpdateEveryMessageBoardAdminStatusForSite(creator, MessageBoardAdminStatus.Unread);
            Assert.AreEqual("Error", result.GetType().Name);
            Assert.AreEqual("UpdateEveryMessageBoardAdminStatusForSite", result.Type);
        }

        [TestMethod]
        public void GetPreviewTopicsXml_ValidRecordSet_ReturnsCorrectXml()
        {
            IDnaDataReaderCreator creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            _mocks.ReplayAll();

            var site = CreateDefaultSiteObject();
            var node = site.GetPreviewTopicsXml(creator);
            Assert.IsNotNull(node.SelectSingleNode("TOPIC"));
        }

        [TestMethod]
        public void GetPreviewTopicsXml_NoRows_ReturnsCorrectXml()
        {
            IDnaDataReaderCreator creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            IDnaDataReader reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(reader);

            _mocks.ReplayAll();

            var site = CreateDefaultSiteObject();
            var node = site.GetPreviewTopicsXml(creator);
            Assert.IsNull(node.SelectSingleNode("TOPIC"));
        
        }

        [TestMethod]
        public void GetPreviewTopicsXml_NoRead_ReturnsCorrectXml()
        {
            IDnaDataReaderCreator creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            IDnaDataReader reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(reader);

            _mocks.ReplayAll();

            var site = CreateDefaultSiteObject();
            var node = site.GetPreviewTopicsXml(creator);
            Assert.IsNull(node.SelectSingleNode("TOPIC"));
        }

        private static Site CreateDefaultSiteObject()
        {
            int id = 5;
            string name = string.Empty;
            int threadOrder = 0;
            bool preModeration = false;
            string defaultSkin = string.Empty;
            bool noAutoSwitch = false;
            string description = string.Empty;
            string shortName = string.Empty;
            string moderatorsEmail = "moderatorsEmail";
            string editorsEmail = "editorsEmail";
            string feedbackEmail = "feedbackEmail";
            int autoMessageUserID = 0;
            bool passworded = false;
            bool unmoderated = false;
            bool articleGuestBookForums = false;
            string config = string.Empty;
            string emailAlertSubject = string.Empty;
            int threadEditTimeLimit = 0;
            int eventAlertMessageUserID = 0;
            int allowRemoveVote = 0;
            int includeCrumbtrail = 0;
            int allowPostCodesInSearch = 0;
            bool queuePostings = false;
            bool emergencyClosed = false;
            int minAge = 0;
            int maxAge = 0;
            int modClassID = 0;
            string ssoService = string.Empty;
            bool useIdentitySignInSystem = false;
            string skinSet = string.Empty;
            string IdentityPolicy = string.Empty;
            
            string connection = string.Empty;
            var target = new Site(id, name, threadOrder, preModeration, defaultSkin, noAutoSwitch, description,
                                  shortName, moderatorsEmail, editorsEmail, feedbackEmail, autoMessageUserID, passworded,
                                  unmoderated, articleGuestBookForums, config, emailAlertSubject, threadEditTimeLimit,
                                  eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail, allowPostCodesInSearch,
                                  queuePostings, emergencyClosed, minAge, maxAge, modClassID, ssoService,
                                  useIdentitySignInSystem, skinSet, IdentityPolicy);
            Assert.AreEqual(id, target.SiteID);

            return target;
        }

        private IDnaDataReader GetSiteTopicsMockReader()
        {
            IDnaDataReader reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            reader.Stub(x => x.GetByte("")).Constraints(Is.Anything()).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(1);

            return reader;
        }
    }
}