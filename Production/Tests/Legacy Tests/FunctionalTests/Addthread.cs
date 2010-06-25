using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Groups;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Moderation.Utils;
using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    //[TestClass]
    public class AddThreadTests
    {
        private int _threadId = 34;
        private int _forumId = 7325075;
        private int _inReplyTo = 61;
        private int _siteId = 70;//mbiplayer
        private string _siteName = "mbiplayer";
        private int _userId = TestUserAccounts.GetNormalUserAccount.UserID;


        /// <summary>
        /// Setup fixtures
        /// </summary>
        //[TestInitialize]
        public void Setup()
        {
            try
            {
                SnapshotInitialisation.ForceRestore();
            }
            catch { }
        }

        //[TestCleanup]
        public void TearDown()
        {//reset the test harness to unmod
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.UnMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            //var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            SendSignal();
        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_Unmoderated_CorrectPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_SiteIsPostModerated_CorrectUnmoderatedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_SiteIsPreModerated_CorrectUnmoderatedPost()
        {
            var processPreMod = false;
            var siteStatus = ModerationStatus.SiteStatus.PreMod;
            var forumStatus = ModerationStatus.ForumStatus.Reactive;
            var threadStatus = ModerationStatus.ForumStatus.Reactive;
            var userStatus = ModerationStatus.ForumStatus.Reactive;
            var expectedPostStatus = ModerationStatus.ForumStatus.Reactive;

            SetPermissions(siteStatus, forumStatus, threadStatus, userStatus, processPreMod);

            var xml = PostToForum();

            CheckPostInModQueue(xml, expectedPostStatus, processPreMod);
            CheckPostInThread(xml, expectedPostStatus, processPreMod);

        }

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_ForumIsPostModerated_CorrectUnmoderatedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_ForumIsPreModerated_CorrectUnmoderatedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_ThreadIsPostMode_CorrectPostModeratedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_ThreadIsPreMode_CorrectPreModeratedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_UserIsPostMode_CorrectPostModeratedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_UserIsPreMod_CorrectPreModeratedPost()
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

        /// <summary>
        /// Test existing c++ code base
        /// </summary>
        //[TestMethod]
        public void AddThread_AllPreModUserIsPostMod_CorrectPreModeratedPost()
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
                var postId = GetPostIdFromResponse(xml, modStatus);

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
            request.RequestPage(string.Format("F{0}?thread={1}&skin=purexml", _forumId, _threadId));
            var xmlDoc = request.GetLastResponseAsXML();
            

            if (processPreMod)
            {
                var nodes = xmlDoc.SelectNodes(string.Format("//H2G2/FORUMTHREADPOSTS/POST"));
                Assert.AreEqual(1, nodes.Count);
            }
            else
            {
                var postId = GetPostIdFromResponse(xml, modStatus);

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
                    dataReader.ExecuteDEBUGONLY(string.Format("insert into Preferences (userid, siteid, AutoSinBin, prefstatus, AgreedTerms) values ({0},{1},{2},{3},1)", _userId, _siteId, 
                        (userStatus == ModerationStatus.ForumStatus.PreMod)?1:0, (int)userStatus));
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
            var url = String.Format("http://{0}/dna/h2g2/Signal?action=recache-site", DnaTestURLRequest.CurrentServer);
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");


        }

        private XmlDocument PostToForum()
        {
            var url = String.Format("AddThread?skin=purexml");
            
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
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

        private int GetPostIdFromResponse(XmlDocument xml, ModerationStatus.ForumStatus modStatus)
        {
            var postId = 0;
            if (modStatus == ModerationStatus.ForumStatus.PreMod)
            {
                //<POSTPREMODERATED FORUM="7325075" THREAD="34" POST="65" />
                var node = xml.SelectSingleNode("//H2G2/POSTPREMODERATED");
                postId = Int32.Parse(node.Attributes["POST"].Value);

            }
            else
            {
                var redirectUrl = HtmlUtils.HtmlDecode(xml.SelectSingleNode("//H2G2/REDIRECT-TO").InnerText);
                var postPos = redirectUrl.LastIndexOf("#p") + 2;
                postId = Int32.Parse(redirectUrl.Substring(postPos, redirectUrl.Length - postPos));
            }

            return postId;
        }

        
    }
}
