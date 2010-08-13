using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;

using TestUtils;


namespace FunctionalTests.Services.Comments
{
	/// <summary>
	/// Tests for the Cookie decoder class
	/// </summary>
	[TestClass]
	public class CommentForumCachingAndStats_v1
	{
        //private ISiteList _siteList;
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _secureserver = DnaTestURLRequest.SecureServerAddress;
        private string _sitename = "h2g2";

        /// <summary>
        /// 
        /// </summary>
        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After CommentForumTests");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            ResetCounters();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public CommentForumCachingAndStats_v1()
        {
           
        }
		
		/// <summary>
		/// Tests of the read of comment forums by sitename
		/// </summary>
		[TestMethod]
        public void CommentForum_BasicAddCommentWithStatsCheck()
		{
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 1);

            XmlDocument xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 3);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 0);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 1);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 1);
            xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 4);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 1);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 1);

		}

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentsBySite_BasicAddCommentWithStatsCheck()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //get total for this site
            CommentsList list = ReadCommentsReadBySite("");
            Assert.IsTrue(list.TotalCount != 0);

            CommentsList listPrefix = ReadCommentsReadBySite(commentForum.Id.Substring(0, 4));
            Assert.IsTrue(listPrefix.TotalCount == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            CreateComment(comment, result);

            //get total for this site
            CommentsList listAfter = ReadCommentsReadBySite("");
            Assert.IsTrue(listAfter.TotalCount == list.TotalCount+1);

            XmlDocument xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 5);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 0);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 3);

            CommentsList listPrefixAfter = ReadCommentsReadBySite(commentForum.Id.Substring(0, 4));
            Assert.IsTrue(listPrefixAfter.TotalCount == 1);
            xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 6);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 0);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 4);

            //reget totals
            listAfter = ReadCommentsReadBySite("");
            Assert.IsTrue(listAfter.TotalCount == list.TotalCount + 1);
            xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 7);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 1);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 4);

            listPrefixAfter = ReadCommentsReadBySite(commentForum.Id.Substring(0, 4));
            Assert.IsTrue(listPrefixAfter.TotalCount == 1);
            xStats = GetAllStatCounter();
            Assert.IsTrue(GetStatCounter(xStats, "RAWREQUESTS") == 8);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEHITS") == 2);
            Assert.IsTrue(GetStatCounter(xStats, "HTMLCACHEMISSES") == 4);

        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_ChangeCloseDate()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 1);

            // Now ste the closing date of the forum to something in the past.
            using (FullInputContext _context = new FullInputContext(""))
            {
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
                {
                    dataReader.AddParameter("uid", result.Id);
                    dataReader.AddParameter("forumclosedate", DateTime.Today.AddDays(-20));
                    dataReader.Execute();
                }
            }
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.isClosed);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_ChangeCanWriteFlag()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };



            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 1);
            Assert.IsFalse(result.isClosed);

            // Now ste the closing date of the forum to something in the past.
            using (FullInputContext _context = new FullInputContext(""))
            {
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
                {
                    dataReader.AddParameter("uid", result.Id);
                    dataReader.AddParameter("canwrite", 0);
                    dataReader.Execute();
                }
            }
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.isClosed);

            //try and read it again as json - to check the isclosed forum flag is honoured.
            result = ReadForumJson(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.isClosed);
            


        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_ComplaintHideComment()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 1);

            // Now ste the closing date of the forum to something in the past.
            using (FullInputContext _context = new FullInputContext(""))
            {

                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("hidepost"))
                {
                    dataReader.AddParameter("postid", result.commentList.comments[0].ID);
                    dataReader.AddParameter("hiddenid", 6);
                    dataReader.Execute();
                }
          
            }
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == "This post has been removed.", "Comment not hidden!");
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Removed_EditorComplaintTakedown);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_PreMod_Pass()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == "This post is awaiting moderation.", "Comment not hidden!");
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsTrue(result.commentSummary.Total == 1);

            // Now ste the closing date of the forum to something in the past.
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, BBC.Dna.Component.ModeratePosts.Status.Passed,"");
            
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == comment.text);
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.NotHidden);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_PreMod_Fail()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == "This post is awaiting moderation.", "Comment not hidden!");
            Assert.IsTrue(result.commentSummary.Total == 1);
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            // Now ste the closing date of the forum to something in the past.
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, BBC.Dna.Component.ModeratePosts.Status.Failed,"");

            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == "This post has been removed.", "Comment not hidden!");
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Removed_FailedModeration);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_PreMod_PassWithEdit()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };

            CommentForum result = CreateForum(commentForum);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };

            

            CreateComment(comment, result);

            //get forum again
            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsTrue(result.commentList.comments[0].text == "This post is awaiting moderation.", "Comment not hidden!");
            Assert.IsTrue(result.commentSummary.Total == 1);


            string newText = " this is editted text";
            // Now ste the closing date of the forum to something in the past.
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, BBC.Dna.Component.ModeratePosts.Status.PassedWithEdit, newText);

            result = ReadForum(result.Id);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].text == newText);
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="postid"></param>
        /// <param name="forumid"></param>
        /// <param name="status"></param>
        /// <param name="edittedText"></param>
        private void ModerateComment(int postid, int forumid, BBC.Dna.Component.ModeratePosts.Status status, string edittedText)
        {
            using (FullInputContext _context = new FullInputContext(""))
            {
                int threadId = 0, modId = 0, threadModStatus = 0;

                using (IDnaDataReader dataReader = _context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY("select modid, threadid, forumid, status from threadmod where postid=" + postid.ToString());
                    if (dataReader.Read())
                    {
                        threadId = dataReader.GetInt32NullAsZero("threadid");
                        modId = dataReader.GetInt32NullAsZero("modid");
                        threadModStatus = dataReader.GetInt32NullAsZero("status");
                        forumid = dataReader.GetInt32NullAsZero("forumid");
                    }
                }
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("moderatepost"))
                {
                    dataReader.AddParameter("forumid", forumid);
                    dataReader.AddParameter("threadid", threadId);
                    dataReader.AddParameter("postid", postid);
                    dataReader.AddParameter("modid", modId);
                    dataReader.AddParameter("status", (int)status);
                    dataReader.AddParameter("notes", "");
                    dataReader.AddParameter("referto", 0);
                    dataReader.AddParameter("referredby", 0);
                    dataReader.AddParameter("moderationstatus", threadModStatus);
                    dataReader.Execute();
                }

                if(status == BBC.Dna.Component.ModeratePosts.Status.PassedWithEdit)
                {
                    using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatepostdetails"))
                    {
                        dataReader.AddParameter("userid", TestUserAccounts.GetNormalUserAccount.UserID);
                        dataReader.AddParameter("postid", postid);
                        dataReader.AddParameter("subject", "");
                        dataReader.AddParameter("text", edittedText);
                        dataReader.AddParameter("setlastupdated", true);
                        dataReader.AddParameter("forcemoderateandhide", 0);
                        dataReader.AddParameter("ignoremoderation", 1);

                        dataReader.Execute();
                    }
                }

            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="counter"></param>
        /// <returns></returns>
        private XmlDocument GetAllStatCounter()
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/status.aspx?skin=purexml&interval=" + (24 * 60).ToString();

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");

            //load stats
            return request.GetLastResponseAsXML();

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="counter"></param>
        /// <returns></returns>
        private int GetStatCounter(XmlDocument xStat, string counter)
        {
            return Int32.Parse(xStat.SelectSingleNode("/H2G2/STATUS-REPORT/STATISTICS/STATISTICSDATA/" + counter.ToUpper()).InnerText);

        }

        private void ResetCounters()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + "/dna/api/comments/status.aspx?reset=1";

            // now get the response
            request.RequestPageWithFullURL(url, "", "text/xml");
        }

        private CommentForum CreateForum(CommentForum forum)
        {
            string commentForumXml = String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</commentForum>", forum.Id, forum.Title, forum.ParentUri, forum.ModerationServiceGroup);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == forum.Id);
            return returnedForum;
        }

        private CommentInfo CreateComment(CommentInfo info, CommentForum forum)
        {
            string commentForumXml = String.Format("<comment xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text>" +
                "</comment>", info.text);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            // Setup the request url
            string url = String.Format("https://" + _secureserver + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, forum.Id);
            // now get the response
            request.RequestPageWithFullURL(url, commentForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            CommentInfo returnedComment = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.IsNotNull(returnedComment.User);
            Assert.IsTrue(returnedComment.User.UserId == request.CurrentUserID);

            return returnedComment;
        }

        private CommentForum ReadForum(string uid)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == uid);
            return returnedForum;
        }

        private CommentForum ReadForumJson(string uid)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, uid);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/javascript");
            // Check to make sure that the page returned with the correct information
            CommentForum returnedForum = (BBC.Dna.Api.CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForum));
            Assert.IsTrue(returnedForum.Id == uid);
            return returnedForum;
        }

        private CommentsList ReadCommentsReadBySite(string prefix)
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/{0}/comments/?prefix={1}", _sitename, prefix);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            return (BBC.Dna.Api.CommentsList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentsList));
        }

        /*
        /// <summary>
        /// Helper method that signals for a site to be closed/open and then waits for that site to recieve and process the signal
        /// </summary>
        /// <param name="siteClosed">The state that you want tohe site to be in. 1 = closed, 0 = open</param>
        /// <returns>True if the site was updated, false if not</returns>
        private static bool SignalAndWaitforSiteToOpenOrClose(int siteClosed)
        {
            // Make sure the site is open
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            if (siteClosed > 0)
            {
                request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
            }
            else
            {
                request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
            }

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[SITE-CLOSED='" + siteClosed.ToString() + "']") != null, "The haveyoursay site was not updated correctly! Please check your database!");

            // Now wait untill the .net has been signaled by ripley that we need to recache site data. Emergency closed is in the data!!!
            // Make sure we've got a drop clause after 15 seconds!!!
            int tries = 0;
            bool updated = false;
            Console.Write("Waiting for open/close signal to be processed ");
            while (tries++ <= 20 && !updated)
            {
                //request.RequestPage("acswithoutapi?skin=purexml");
                if (siteClosed > 0)
                {
                    request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
                }
                else
                {
                    request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
                } 
                
                if (request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED") != null)
                {
                    updated = request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED").InnerXml.CompareTo(siteClosed.ToString()) == 0;

                    if (!updated)
                    {
                        // Goto sleep for 5 secs
                        System.Threading.Thread.Sleep(5000);
                        Console.Write(".");
                    }
                }
            }
            tries *= 5;
            Console.WriteLine(" waited " + tries.ToString() + " seconds.");
            return updated;
        }
         * */
        private bool SetSiteEmergencyClosed(bool setClosed)
        {
            // Set the value in the database
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("updatesitetopicsclosed"))
                {
                    dataReader.AddParameter("siteid", 1);
                    dataReader.AddParameter("siteemergencyclosed", setClosed ? 1 : 0);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }

            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");
            }

            return true;
        }

    }
}
