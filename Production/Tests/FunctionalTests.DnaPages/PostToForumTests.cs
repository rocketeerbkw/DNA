using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Moderation.Utils;
using TestUtils;
using System.Web;


namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class PostToForumTests
    {
        private int _threadId = 34;
        private int _forumId = 7325075;
        private int _inReplyTo = 61;
        private int _siteId = 70;//mbiplayer
        private string _siteName = "mbiplayer";
        private int _userId = TestUserAccounts.GetNormalUserAccount.UserID;

        [TestInitialize]
        public void Setup()
        {
            try
            {
                SnapshotInitialisation.RestoreFromSnapshot();
            }
            catch { }
        }

        [TestCleanup]
        public void TearDown()
        {//reset the test harness to unmod
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            //var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;
            UnSetSiteOptions();
            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_Unmoderated_CorrectPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus =ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus,threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_SiteIsPostModerated_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PostMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_SiteIsPreModerated_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, " posting ok");

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_SiteIsPreModeratedSuperUser_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my with refferred item arse post");

            var xml = request.GetLastResponseAsXML();


            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_SiteIsPreModeratedWithProcessPreMod_CorrectModeratedPost()
        {
            var processPreMod = true;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.ForumStatus.PreMod;
            var expectedPostStatus = ModerationStatus.ForumStatus.PreMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            Assert.AreEqual(_threadId.ToString(), xml.SelectSingleNode("H2G2/POSTPREMODERATED/@THREAD").InnerText);
            
            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_ForumIsPostModerated_CorrectUnmoderatedPost()
        {
            //thread status takes precedence over forum status
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.PostMod;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_ForumIsPreModerated_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_ThreadIsPostMod_CorrectPostModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.PostMod;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_ThreadIsPreMod_CorrectPreModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.PreMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_UserIsPostMod_CorrectPostModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.PostMod;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_UserIsPreMod_CorrectPreModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.PreMod;
            var expectedPostStatus = ModerationStatus.ForumStatus.PreMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_UserIsBanned_CorrectError()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserBanned();
            var url = String.Format("PostToForum?skin=purexml&forumid=150");


            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("threadid", "33"));
            postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", "60"));
            postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("forum", "150"));
            postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
            postParams.Enqueue(new KeyValuePair<string, string>("body", "Post message"));
            postParams.Enqueue(new KeyValuePair<string, string>("post", "Post message"));

            try
            {
                request.RequestPage(url, postParams);
            }
            catch { }
            
            var xml = request.GetLastResponseAsXML();

            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/POSTTHREADUNREG"));
            Assert.AreEqual("1", xml.SelectSingleNode("//H2G2/POSTTHREADUNREG").Attributes["RESTRICTED"].Value);
        }

        [TestMethod]
        public void PostToForum_AllPreModUserIsPostMod_CorrectPreModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.ForumStatus.PostMod;
            var expectedPostStatus = ModerationStatus.ForumStatus.PreMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_PreviewPost_CorrectPreviewReturned()
        {
            string post = "my post";
            string expected = "my post";
            
            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithQuoteParam_CorrectPreviewReturned()
        {
            string post = "my post";
            string expected = "<QUOTE POSTID=\"61\">more test data....</QUOTE>my post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.QuoteId);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithQuoteParamAndExistingQuote_CorrectPreviewReturned()
        {
            string post = "<quote postid='61'>more test data....</quote><BR />my post";
            string expected = "<QUOTE POSTID=\"61\">more test data....</QUOTE>my post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.QuoteId);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithQuoteUserParam_CorrectPreviewReturned()
        {
            string post = "my post";
            string expected = "<QUOTE POSTID=\"61\" USER=\"DotNetNormalUser\" USERID=\"1090501859\">more test data....</QUOTE>my post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.QuoteUser);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithLink_CorrectPreviewReturned()
        {
            string post = "my post http://bbc.co.uk";
            string expected = "my post <LINK HREF=\"http://bbc.co.uk\">http://bbc.co.uk</LINK>";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithSmiley_CorrectPreviewReturned()
        {
            string post = "my post <ale>";
            string expected = "my post <SMILEY TYPE=\"ale\" H2G2=\"Smiley#ale\" />";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithScriptTag_CorrectPreviewReturned()
        {
            string post = "<script>my post</script>";
            string expected = "my post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithNewlines_CorrectPreviewReturned()
        {
            string post = "my\r\npost";
            string expected = "my<BR />post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_PreviewPostWithInvalidHTML_CorrectPreviewReturned()
        {
            string post = "my <quote>post";
            string expected = "my &lt;quote&gt;post";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);
        }

        [TestMethod]
        public void PostToForum_WithProfanity_CorrectError()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;


            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, " POST WITH profanity fuck ");

            var xml = request.GetLastResponseAsXML();
            Assert.AreEqual("1", xml.SelectSingleNode("H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED").InnerText);

        }

        [TestMethod]
        public void PostToForum_WithMaxCharLimitExceeded_CorrectError()
        {
            SetSiteOptions(0, 5, false,false,0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, " POST WITH that is longer than 5 chars");

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "ExceededTextLimit");
        }

        [TestMethod]
        public void PostToForum_WithMinCharLimitExceeded_CorrectError()
        {
            SetSiteOptions(50, 0, false, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "MinCharLimitNotReached");
        }

        [TestMethod]
        public void PostToForum_WithSiteClosed_CorrectError()
        {
            SetSiteOptions(0, 0, true, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "SiteIsClosed");
        }

        [TestMethod]
        public void PostToForum_WithSiteScheduledClosed_CorrectError()
        {
            SetSiteOptions(0, 0, false, true, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "SiteIsClosed");
        }

        [TestMethod]
        public void PostToForum_WithSiteClosedAsSuperUser_CorrectPost()
        {
            SetSiteOptions(0, 0, true, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;
            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);
        }

        [TestMethod]
        public void PostToForum_WithSiteClosedAsEditorUser_CorrectPost()
        {
            SetSiteOptions(0, 0, true, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;
            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);
        }

        [TestMethod]
        public void PostToForum_SiteIsPreModeratedAsSuperUser_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.ForumStatus.PreMod;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my post");

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_ReferredTermInPost_CorrectModeratedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my with refferred item arse post");

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_WithinPostFrequency_CorrectError()
        {
            SetSiteOptions(0, 0, false, false, 1000);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post");
            request = PostToForumWithException(request, "my post2");
            var xml = request.GetLastResponseAsXML();

            Assert.AreEqual("1", xml.SelectSingleNode("H2G2/POSTTHREADFORM/@POSTEDBEFOREREPOSTTIMEELAPSED").InnerText);
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST"));

        }

        [TestMethod]
        public void PostToForum_WithinPostFrequencyAsEditorUser_CorrectUnmoderatedPost()
        {
            SetSiteOptions(0, 0, false, false, 300);

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request = PostToForumWithException(request, "my post");
            request = PostToForumWithException(request, "my post2");
            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_WithinPostFrequencyAsNotableUser_CorrectUnmoderatedPost()
        {
            SetSiteOptions(0, 0, false, false, 300);

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNotableUser();
            request = PostToForumWithException(request, "my post");
            request = PostToForumWithException(request, "my post2");
            var xml = request.GetLastResponseAsXML();

            
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_PostWithGreaterThanLessThanSymbols_CorrectPost()
        {

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "1 > 2 and 3<4");
            var xml = request.GetLastResponseAsXML();


            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_PreviewWithGreaterThanLessThanSymbols_CorrectPost()
        {

            string post = "1 < 2 > 0";
            string expected = "1 &lt; 2 &gt; 0";

            PreviewPost(post, expected, BBC.Dna.Objects.QuoteEnum.None);

        }

        private void SetSiteOptions(int minChars, int maxChars, bool closeSite, bool scheduleCloseSite, int postFreq)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='MaxCommentCharacterLength'", _siteId));
                if (maxChars > 0)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (section, siteid, name, value, type,description) values ('CommentForum',{0},'MaxCommentCharacterLength', {1}, 0, 'test')", _siteId, maxChars));
                }

                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='MinCommentCharacterLength'", _siteId));
                if (minChars > 0)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (section, siteid, name, value, type,description) values ('CommentForum',{0},'MinCommentCharacterLength', {1}, 0, 'test')", _siteId, minChars));
                }

                dataReader.ExecuteDEBUGONLY(string.Format("update sites set SiteEmergencyClosed=0 where siteid={0}", _siteId));
                if (closeSite)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("update sites set SiteEmergencyClosed=1 where siteid={0}", _siteId));
                }
                dataReader.ExecuteDEBUGONLY(string.Format("delete from SiteTopicsOpenCloseTimes where siteid={0}", _siteId));
                if (scheduleCloseSite)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into SiteTopicsOpenCloseTimes (siteid, dayweek, hour, minute,closed) values ({0},{1}, 0, 0, 0)", _siteId, (int)DateTime.Now.DayOfWeek));
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into SiteTopicsOpenCloseTimes (siteid, dayweek, hour, minute,closed) values ({0},{1}, 0, 0, 1)", _siteId, (int)DateTime.Now.DayOfWeek));
                }
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='PostFreq'", _siteId));
                if (postFreq > 0)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (section, siteid, name, value, type,description) values ('Forum',{0},'PostFreq', {1}, 0, 'test')", _siteId, postFreq));
                }


            }


            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;


            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);
        }

        private void UnSetSiteOptions()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='MaxCommentCharacterLength'", _siteId));
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='MinCommentCharacterLength'", _siteId));
                dataReader.ExecuteDEBUGONLY(string.Format("update sites set SiteEmergencyClosed=0 where siteid={0}", _siteId));
                dataReader.ExecuteDEBUGONLY(string.Format("delete from SiteTopicsOpenCloseTimes where siteid={0}", _siteId));
                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='PostFreq'", _siteId));
            }
        }

        private void CheckPostInModQueue(XmlDocument xml, ModerationStatus.ForumStatus modStatus, bool processPreMod)
        {
            if (processPreMod)
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("select * from premodpostings"));
                    Assert.IsTrue(dataReader.HasRows);
                }
            }
            else
            {
                var postId = GetPostIdFromResponse(xml, modStatus == ModerationStatus.ForumStatus.PreMod);

                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("select * from threadmod where postid={0}", postId));
                    if (modStatus == ModerationStatus.ForumStatus.Reactive)
                    {//not in queue
                        Assert.IsFalse(dataReader.HasRows);
                    }
                    else
                    {//in queue
                        Assert.IsTrue(dataReader.HasRows);
                    }
                }

            }
        }

        private void CheckPostInThread(XmlDocument xml, ModerationStatus.ForumStatus modStatus, bool processPreMod)
        {
             //get forum page
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.RequestPage(string.Format("NF{0}?thread={1}&skin=purexml", _forumId, _threadId));
            var xmlDoc = request.GetLastResponseAsXML();
            

            if (processPreMod)
            {
                var nodes = xmlDoc.SelectNodes(string.Format("//H2G2/FORUMTHREADPOSTS/POST"));
                Assert.AreEqual(1, nodes.Count);
            }
            else
            {
                var postId = GetPostIdFromResponse(xml, modStatus == ModerationStatus.ForumStatus.PreMod);

                var node = xmlDoc.SelectSingleNode(string.Format("//H2G2/FORUMTHREADPOSTS/POST[@POSTID = {0}]", postId));
                Assert.IsNotNull(node);
                if (modStatus == ModerationStatus.ForumStatus.PreMod)
                {//only hidden if premod
                    Assert.AreEqual("3", node.Attributes["HIDDEN"].Value);
                }
                else
                {
                    Assert.AreEqual("0", node.Attributes["HIDDEN"].Value);
                }
            }
        }

        private void SetPermissions(ModerationStatus.SiteStatus siteStatus, ModerationStatus.ForumStatus forumStatus, 
            ModerationStatus.ForumStatus threadStatus, ModerationStatus.ForumStatus userStatus, bool processPreMod)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                switch (siteStatus)
                {
                    case ModerationStatus.SiteStatus.PreMod:
                        dataReader.ExecuteDEBUGONLY("update sites set premoderation=1, unmoderated=0 where siteid=" + _siteId);
                        break;

                    case ModerationStatus.SiteStatus.PostMod:
                        dataReader.ExecuteDEBUGONLY("update sites set premoderation=0, unmoderated=0 where siteid=" + _siteId);
                        break;

                    case ModerationStatus.SiteStatus.UnMod:
                        dataReader.ExecuteDEBUGONLY("update sites set premoderation=0, unmoderated=1 where siteid=" + _siteId);
                        break;
                }

                dataReader.ExecuteDEBUGONLY(string.Format("update forums set moderationstatus={0} where forumid={1}", (int)forumStatus, _forumId));
                dataReader.ExecuteDEBUGONLY(string.Format("update threads set moderationstatus={0} where threadid={1}", (int)threadStatus, _threadId));


                dataReader.ExecuteDEBUGONLY(string.Format("delete from Preferences where userid={0} and siteid={1}", _userId, _siteId));
                if (userStatus != ModerationStatus.ForumStatus.Reactive)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into Preferences (userid, siteid, AutoSinBin, prefstatus, AgreedTerms, DateJoined,PrefStatusDuration, PrefStatusChangedDate) values ({0},{1},{2},{3},1,'2010/1/1',{4},'2020/1/1')", 
                        _userId, _siteId,(userStatus == ModerationStatus.ForumStatus.PreMod) ? 1 : 0, (int)userStatus, 1000));
                }
                else
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into Preferences (userid, siteid, AutoSinBin, prefstatus, AgreedTerms, DateJoined) values ({0},{1},{2},{3},1,'2010/1/1')", _userId, _siteId, 0, 0));
                }

                dataReader.ExecuteDEBUGONLY(string.Format("delete from siteoptions where siteid={0} and name='ProcessPreMod'", _siteId));
                if (processPreMod)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into siteoptions (section, siteid, name, value, type,description) values ('Moderation',{0},'ProcessPreMod', 1, 1, 'test')", _siteId));

                }
            }

            SendSignal();

        }

        private void SendSignal()
        {
            var url = String.Format("http://{0}/dna/h2g2/dnaSignal?action=recache-site", DnaTestURLRequest.CurrentServer);
            var request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");


        }

        private XmlDocument PostToForum()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            return PostToForum(request);
        }

        private XmlDocument PostToForum(DnaTestURLRequest request)
        {
            var url = String.Format("PostToForum?skin=purexml");
            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("threadid", _threadId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", _inReplyTo.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("forum", _forumId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
            postParams.Enqueue(new KeyValuePair<string, string>("body", Guid.NewGuid().ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("post", "Post message"));
            request.RequestPage(url, postParams);
            return request.GetLastResponseAsXML();
        }

        private DnaTestURLRequest PostToForumWithException(DnaTestURLRequest request, string post)
        {
            var url = String.Format("PostToForum?skin=purexml&forumid=" + _forumId.ToString());


            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("threadid", _threadId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", _inReplyTo.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("forum", _forumId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
            postParams.Enqueue(new KeyValuePair<string, string>("body", post));
            postParams.Enqueue(new KeyValuePair<string, string>("post", "Post message"));

            try
            {
                request.RequestPage(url, postParams);
            }
            catch { }
            return request;
        }

        private void PreviewPost(string previewText, string expectedText, BBC.Dna.Objects.QuoteEnum quote)
        {
            try
            {
                var url = String.Format("PostToForum?skin=purexml&forumid=" + _forumId.ToString());
                switch(quote)
                {
                    case BBC.Dna.Objects.QuoteEnum.QuoteId:
                        url += "&AddQuoteID=1"; break;
                    case BBC.Dna.Objects.QuoteEnum.QuoteUser:
                        url += "&AddQuoteUser=1"; break;

                }
                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserNormal();
                var postParams = new Queue<KeyValuePair<string, string>>();
                postParams = new Queue<KeyValuePair<string, string>>();
                postParams.Enqueue(new KeyValuePair<string, string>("threadid", _threadId.ToString()));
                postParams.Enqueue(new KeyValuePair<string, string>("inreplyto", _inReplyTo.ToString()));
                postParams.Enqueue(new KeyValuePair<string, string>("dnapoststyle", "1"));
                postParams.Enqueue(new KeyValuePair<string, string>("forum", _forumId.ToString()));
                postParams.Enqueue(new KeyValuePair<string, string>("subject", "test post"));
                postParams.Enqueue(new KeyValuePair<string, string>("body", previewText));
                postParams.Enqueue(new KeyValuePair<string, string>("preview", "preview message"));
                request.RequestPage(url, postParams);

                var xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.SelectSingleNode("/H2G2/POSTTHREADFORM").OuterXml, "PostThreadForm.xsd");
                validator.Validate();

                var returnedPreview = xml.SelectSingleNode("/H2G2/POSTTHREADFORM/PREVIEWBODY").InnerXml;
                Assert.AreEqual(expectedText, returnedPreview);
            }
            finally
            {
            }
        }

        private int GetPostIdFromResponse(XmlDocument xml, bool processPreMod)
        {
            var postId = 0;
            if (processPreMod)
            {
                //<POSTPREMODERATED FORUM="7325075" THREAD="34" POST="65" />
                var node = xml.SelectSingleNode("//H2G2/POSTPREMODERATED");
                postId = Int32.Parse(node.Attributes["POST"].Value);

            }
            else
            {
                var redirectUrl = HttpUtility.UrlDecode(xml.SelectSingleNode("//html/body/h2/a/@href").InnerText);
                var postPos = redirectUrl.LastIndexOf("#p") + 2;
                postId = Int32.Parse(redirectUrl.Substring(postPos, redirectUrl.Length - postPos));
            }

            return postId;
        }

        private void CheckForError(XmlDocument xml, string errorType)
        {
            var errorXml = xml.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(errorXml);
            Assert.AreEqual(errorType, errorXml.Attributes["TYPE"].Value);
        }


    }
}
