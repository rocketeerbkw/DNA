﻿using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Web;
using System.Xml;
using Tests;
using TestUtils;

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

        [ClassInitialize]
        static public void ThisFirst(TestContext context)
        {
            SnapshotInitialisation.ForceRestore(true);
        }

        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        [TestCleanup]
        public void TearDown()
        {//reset the test harness to unmod
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            //var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;
            UnSetSiteOptions();
            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_Unmoderated_CorrectPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);
        }

        [TestMethod]
        public void PostToForum_TrustedUser_CorrectPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Trusted;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_NotLoggedIn_CorrectError()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request = PostToForumWithException(request, " POST WITHout credentials ", DnaTestURLRequest.usertype.NOTLOGGEDIN);

            CheckForError(request.GetLastResponseAsXML(), "NotLoggedIn");
        }

        [TestMethod]
        public void PostToForum_SiteIsPostModerated_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PostMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
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
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, " posting ok", DnaTestURLRequest.usertype.SUPERUSER);

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
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my with refferred item post", DnaTestURLRequest.usertype.SUPERUSER);

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
            var userStatus = ModerationStatus.UserStatus.Premoderated;
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
            var userStatus = ModerationStatus.UserStatus.Standard;
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
            var userStatus = ModerationStatus.UserStatus.Standard;
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
            var userStatus = ModerationStatus.UserStatus.Standard;
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
            var userStatus = ModerationStatus.UserStatus.Standard;
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
            var userStatus = ModerationStatus.UserStatus.Postmoderated;
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
            var userStatus = ModerationStatus.UserStatus.Premoderated;
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
            var userStatus = ModerationStatus.UserStatus.Postmoderated;
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
            var userStatus = ModerationStatus.UserStatus.Standard;


            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, " POST WITH profanity fuck ", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();
            Assert.AreEqual("1", xml.SelectSingleNode("H2G2/POSTTHREADFORM/@PROFANITYTRIGGERED").InnerText);

        }


        [TestMethod]
        public void PostToForum_WithMaxCharLimitExceeded_CorrectError()
        {
            SetSiteOptions(0, 5, false, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, " POST WITH that is longer than 5 chars", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "ExceededTextLimit");
        }

        [TestMethod]
        public void PostToForum_WithMinCharLimitExceeded_CorrectError()
        {
            SetSiteOptions(50, 0, false, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "MinCharLimitNotReached");
        }

        [TestMethod]
        public void PostToForum_WithSiteClosed_CorrectError()
        {
            SetSiteOptions(0, 0, true, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "SiteIsClosed");
        }

        [TestMethod]
        public void PostToForum_WithSiteScheduledClosed_CorrectError()
        {
            SetSiteOptions(0, 0, false, true, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckForError(xml, "SiteIsClosed");
        }

        [TestMethod]
        public void PostToForum_WithSiteClosedAsSuperUser_CorrectPost()
        {
            SetSiteOptions(0, 0, true, false, 0);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.SUPERUSER);

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
            //request.SetCurrentUserEditor();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.EDITOR);

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
            var userStatus = ModerationStatus.UserStatus.Premoderated;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserSuperUser();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.SUPERUSER);

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
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            new TermsFilterImportPageTests().TermsFilterImportPage_AddSingleReferTermToAll_PassesValidation();
            SendTermsSignal();

            request = PostToForumWithException(request, "my with refferred item potato post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }


        [TestMethod]
        public void PostToForum_ReferredTermsInPost_CorrectModeratedPost()
        {
            var threadModId = 0;
            var termStr = "potato";
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            //Add the terms to the terms update history

            new TermsFilterImportPageTests().TermsFilterImportPage_AddSingleReferTermToAll_PassesValidation();
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item potato post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

            var termId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select * from threadmod where modid = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual("Filtered terms: potato", dataReader.GetStringNullAsEmpty("notes"));

                dataReader.ExecuteDEBUGONLY("select ID from TermsLookUp where term='" + termStr + "'");
                Assert.IsTrue(dataReader.Read());
                termId = dataReader.GetInt32("ID");

                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where threadmodid = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(termId, dataReader.GetInt32("TermID"));
                threadModId = dataReader.GetInt32("ThreadModID");
            }

            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termsList = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, threadModId, true);
            Assert.AreEqual("potato", termsList.Terms[0].Value);
        }


        [TestMethod]
        public void PostToForum_ReferredTermsInPost_CorrectModeratedPostWithProcessPreMod()
        {
            var threadModId = 0;
            var termStr = "potato";
            var processPreMod = true;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.PreMod;
            var threadStatus = ModerationStatus.ForumStatus.PreMod;
            var userStatus = ModerationStatus.UserStatus.Premoderated;
            var expectedPostStatus = ModerationStatus.ForumStatus.PreMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            //Add the terms to the terms update history

            new TermsFilterImportPageTests().TermsFilterImportPage_AddSingleReferTermToAll_PassesValidation();
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item post potato", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);

            var termId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select * from threadmod where modid = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual("Filtered terms: potato", dataReader.GetStringNullAsEmpty("notes"));

                dataReader.ExecuteDEBUGONLY("select ID from TermsLookUp where term='" + termStr + "'");
                Assert.IsTrue(dataReader.Read());
                termId = dataReader.GetInt32("ID");

                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where threadmodid = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(termId, dataReader.GetInt32("TermID"));
                threadModId = dataReader.GetInt32("ThreadModID");
            }

            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termsList = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, threadModId, true);
            Assert.AreEqual("potato", termsList.Terms[0].Value);
        }

        [TestMethod]
        public void PostToForum_ReferredForumTermsInPost_CorrectModeratedPost()
        {
            var forumTerm = "humbug123";
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            //Add the terms to the terms update history

            ICacheManager _cache = CacheFactory.GetCacheManager();
            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termsLists = new TermsLists();

            var termList = new TermsList(_forumId, false, true);
            termList.Terms.Add(new TermDetails { Value = forumTerm, Action = TermAction.Refer });

            termsLists.Termslist.Add(termList);

            Error error = termsLists.UpdateTermsInDatabase(creator, _cache, "Testing humbug123", 6, false);
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item " + forumTerm + " post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

            CheckModerationTerms(forumTerm, creator);

        }

        [TestMethod]
        public void PostToForum_ReferredForumBlockedModClassTermsInPost_CorrectModeratedPost()
        {
            var forumTerm = "hum123";
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            new TermsFilterImportPageTests().TermsFilterImportPage_AddSingleTermToAll_PassesValidation();
            SendTermsSignal();
            //Add the terms to the terms update history

            ICacheManager _cache = CacheFactory.GetCacheManager();
            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termList = new TermsList(_forumId, false, true);
            termList.Terms.Add(new TermDetails { Value = forumTerm, Action = TermAction.Refer });
            Error error = termList.UpdateTermsInDatabase(creator, _cache, "Testing hum123", 6, false);
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item " + forumTerm + " post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

            var termId = 0;
            var threadModId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select ID from TermsLookUp where term = '" + forumTerm + "'");
                Assert.IsTrue(dataReader.Read());
                termId = dataReader.GetInt32("ID");

                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where ThreadModID = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(termId, dataReader.GetInt32("TermID"));
                threadModId = dataReader.GetInt32("ThreadModID");
            }

            var terms = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, threadModId, true);
            Assert.AreEqual(forumTerm, terms.Terms[0].Value);
        }

        [TestMethod]
        public void PostToForum_ReferredForumReferredModClassTermsInPost_CorrectModeratedPost()
        {
            var forumTerm = "potato";
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            new TermsFilterImportPageTests().TermsFilterImportPage_AddSingleReferTermToAll_PassesValidation();
            SendTermsSignal();
            //Add the terms to the terms update history

            ICacheManager _cache = CacheFactory.GetCacheManager();
            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termsLists = new TermsLists();

            var termList = new TermsList(_forumId, false, true);
            termList.Terms.Add(new TermDetails { Value = forumTerm, Action = TermAction.Refer });

            termsLists.Termslist.Add(termList);

            Error error = termsLists.UpdateTermsInDatabase(creator, _cache, "Testing potato", 6, false);
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item " + forumTerm + " post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

            var termId = 0;
            var threadModId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select ID from TermsLookUp where term = '" + forumTerm + "'");
                Assert.IsTrue(dataReader.Read());
                termId = dataReader.GetInt32("ID");

                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where ThreadModID = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(termId, dataReader.GetInt32("TermID"));
                threadModId = dataReader.GetInt32("ThreadModID");
            }

            var terms = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, threadModId, true);
            Assert.AreEqual(forumTerm, terms.Terms[0].Value);
            Assert.AreEqual("this has a reason", terms.Terms[0].Reason);
        }

        [TestMethod]
        public void PostToForum_BlockedForumTermsInPost_CorrectModeratedPost()
        {
            var forumTerm = "bum1234";
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.UserStatus.Standard;
            //var expectedPostStatus = ModerationStatus.ForumStatus.PostMod;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();

            //Add the terms to the terms update history

            ICacheManager _cache = CacheFactory.GetCacheManager();
            IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();

            var termsLists = new TermsLists();

            var termList = new TermsList(_forumId, false, true);
            termList.Terms.Add(new TermDetails { Value = forumTerm, Action = TermAction.ReEdit });

            termsLists.Termslist.Add(termList);

            Error error = termsLists.UpdateTermsInDatabase(creator, _cache, "Testing bum1234", 6, false);
            SendTermsSignal();

            request = PostToForumWithException(request, "Testing terms with refferred item " + forumTerm + " post", DnaTestURLRequest.usertype.NORMALUSER);

            var xml = request.GetLastResponseAsXML();

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where ThreadModID = (select max(modid) from threadmod where notes like '%" + forumTerm + "%')");
                Assert.IsFalse(dataReader.Read());
            }
        }

        private static void CheckModerationTerms(string forumTerm, IDnaDataReaderCreator creator)
        {
            var threadModId = 0;
            var termId = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(""))
            {
                dataReader.ExecuteDEBUGONLY("select * from threadmod where modid = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual("Filtered terms: " + forumTerm, dataReader.GetStringNullAsEmpty("notes"));

                dataReader.ExecuteDEBUGONLY("select ID from TermsLookUp where term = '" + forumTerm + "'");
                Assert.IsTrue(dataReader.Read());
                termId = dataReader.GetInt32("ID");

                dataReader.ExecuteDEBUGONLY("select * from ForumModTermMapping where ThreadModID = (select max(modid) from threadmod)");
                Assert.IsTrue(dataReader.Read());
                Assert.AreEqual(termId, dataReader.GetInt32("TermID"));
                threadModId = dataReader.GetInt32("ThreadModID");
            }

            var termsList = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, threadModId, true);
            Assert.AreEqual(forumTerm, termsList.Terms[0].Value);

        }

        public void SendTermsSignal()
        {
            var url = String.Format("{0}dna/h2g2/dnaSignal?action=recache-terms", DnaTestURLRequest.CurrentServer.AbsoluteUri);
            var request = new DnaTestURLRequest(_siteName);
            request.RequestPageWithFullURL(url, null, "text/xml");
        }


        [TestMethod]
        public void PostToForum_WithinPostFrequency_CorrectError()
        {
            SetSiteOptions(0, 0, false, false, 1000);

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            //request.SetCurrentUserNormal();
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.NORMALUSER);
            request = PostToForumWithException(request, "my post2", DnaTestURLRequest.usertype.NORMALUSER);
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
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.EDITOR);
            request = PostToForumWithException(request, "my post2", DnaTestURLRequest.usertype.EDITOR);
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
            request = PostToForumWithException(request, "my post", DnaTestURLRequest.usertype.NOTABLE);
            request = PostToForumWithException(request, "my post2", DnaTestURLRequest.usertype.NOTABLE);
            var xml = request.GetLastResponseAsXML();


            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        [TestMethod]
        public void PostToForum_PostWithGreaterThanLessThanSymbols_CorrectPost()
        {

            var processPreMod = false;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request = PostToForumWithException(request, "1 > 2 and 3<4", DnaTestURLRequest.usertype.NORMALUSER);
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
            var userStatus = ModerationStatus.UserStatus.Standard;


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
            ModerationStatus.ForumStatus threadStatus, ModerationStatus.UserStatus userStatus, bool processPreMod)
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
                if (userStatus != ModerationStatus.UserStatus.Standard)
                {
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into Preferences (userid, siteid, AutoSinBin, prefstatus, AgreedTerms, DateJoined,PrefStatusDuration, PrefStatusChangedDate) values ({0},{1},{2},{3},1,'2010/1/1',{4},'2020/1/1')",
                        _userId, _siteId, (userStatus == ModerationStatus.UserStatus.Premoderated) ? 1 : 0, (int)userStatus, 1000));
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
            var url = String.Format("{0}dna/h2g2/dnaSignal?action=recache-site", DnaTestURLRequest.CurrentServer.AbsoluteUri);
            var request = new DnaTestURLRequest(_siteName);
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

        private DnaTestURLRequest PostToForumWithException(DnaTestURLRequest request, string post, DnaTestURLRequest.usertype user)
        {
            var url = String.Format("PostToForum?skin=purexml&forumid=" + _forumId.ToString());

            if (user == DnaTestURLRequest.usertype.EDITOR)
            {
                request.SetCurrentUserEditor();
            }
            else if (user == DnaTestURLRequest.usertype.SUPERUSER)
            {
                request.SetCurrentUserSuperUser();
            }
            else if (user == DnaTestURLRequest.usertype.NOTABLE)
            {
                request.SetCurrentUserNotableUser();
            }
            else if (user == DnaTestURLRequest.usertype.NORMALUSER)
            {
                request.SetCurrentUserNormal();
            }

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
                switch (quote)
                {
                    case BBC.Dna.Objects.QuoteEnum.QuoteId:
                        url += "&AddQuoteID=1"; break;
                    case BBC.Dna.Objects.QuoteEnum.QuoteUser:
                        url += "&AddQuoteUser=1"; break;

                }
                url += "&d_identityuserid=dotnetnormaluser";

                var request = new DnaTestURLRequest(_siteName);
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
