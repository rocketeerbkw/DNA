using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;
using TestUtils;
using BBC.Dna.Moderation;


namespace Tests
{
	/// <summary>
	/// Tests for the Cookie decoder class
	/// </summary>
	[TestClass]
	public class CommentForumCachingAndStats
	{
        private ISiteList _siteList;
        private ISite site = null;
        private Comments _comments = null;

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
            Statistics.InitialiseIfEmpty(null,false);
            Statistics.ResetCounters();

            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {//force processpremod out...
                    reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=1 and Name='ProcessPreMod'");
                }
                _siteList = SiteList.GetSiteList();
                site = _siteList.GetSite("h2g2");

                _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                var bannedEmails = new BannedEmails(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);//no sending signals from here
                var userGroups = new UserGroups(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);//no sending signals from here
                var profanityFilter = new ProfanityFilter(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);//no sending signals from here            
            }
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public CommentForumCachingAndStats()
        {
            
            
        }
		
		/// <summary>
		/// Tests of the read of comment forums by sitename
		/// </summary>
		[TestMethod]
        public void CommentForum_BasicAddCommentWithStatsCheck()
		{
            Statistics.ResetCounters();
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 1);

            Assert.IsTrue(GetStatCounter("CACHEMISSES") == 3);
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 0);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentSummary.Total == 1);
            Assert.IsTrue(GetStatCounter("CACHEMISSES") == 3);
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 1);

		}

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentsBySite_BasicAddCommentWithStatsCheck()
        {
            Statistics.ResetCounters();
            CommentForum commentForum = new CommentForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "CommentsBySite_BasicAddCommentWithStatsCheck"
            };

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //get total for this site
            CommentsList list = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(list.TotalCount != 0);

            CommentsList listPrefix = _comments.GetCommentsListBySite(site, commentForum.Id.Substring(0,4));
            Assert.IsTrue(listPrefix.TotalCount == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get total for this site
            CommentsList listAfter = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(listAfter.TotalCount == list.TotalCount+1);
            Assert.IsTrue(GetStatCounter("CACHEMISSES") == 5);
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 0);

            CommentsList listPrefixAfter = _comments.GetCommentsListBySite(site, commentForum.Id.Substring(0, 4));
            Assert.IsTrue(listPrefixAfter.TotalCount == 1);
            Assert.IsTrue(GetStatCounter("CACHEMISSES") == 6);
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 0);

            //reget totals
            listAfter = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(listAfter.TotalCount == list.TotalCount + 1);
            Assert.AreEqual(6, GetStatCounter("CACHEMISSES"));
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 1);

            listPrefixAfter = _comments.GetCommentsListBySite(site, commentForum.Id.Substring(0, 4));
            Assert.IsTrue(listPrefixAfter.TotalCount == 1);
            Assert.IsTrue(GetStatCounter("CACHEMISSES") == 6);
            Assert.IsTrue(GetStatCounter("CACHEHITS") == 2);

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

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
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
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.isClosed);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentForum_SiteEmergencyClose()
        {
            try
            {
                CommentForum commentForum = new CommentForum
                {
                    Id = Guid.NewGuid().ToString(),
                    ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                    Title = "testCommentForum"
                };

                CommentForum result = _comments.CreateCommentForum(commentForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
                Assert.IsTrue(result.commentSummary.Total == 0);

                //add a comment 
                CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
                _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
                _comments.CreateComment(result, comment);

                //get forum again
                result = _comments.GetCommentForumByUid(result.Id, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
                Assert.IsTrue(result.commentSummary.Total == 1);

                //close site
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = true;
                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                    
                }

                result = _comments.GetCommentForumByUid(result.Id, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.isClosed);

                //reopen site
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = false;
            }
            finally
            {
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = false;
                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    _siteList = SiteList.GetSiteList();
                    site = _siteList.GetSite("h2g2");
                    _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                }
            }
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

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
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
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
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
                Title = "CommentForum_PreMod_Pass",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            CommentInfo returnComment = _comments.CreateComment(result, comment);
            Assert.IsTrue(returnComment.ID != 0);//not processpremod'ed


            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments.Count != 0);
            Assert.IsTrue(result.commentList.comments[0].hidden ==  CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsTrue(result.commentSummary.Total == 1);

            // Pass the comment...
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, ModerationItemStatus.Passed,"");
            
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
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
                Title = "CommentForum_PreMod_Fail",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsTrue(result.commentSummary.Total == 1);

            // Now ste the closing date of the forum to something in the past.
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, ModerationItemStatus.Failed, "");

            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
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

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            Assert.IsTrue(result.commentSummary.Total == 0);

            //add a comment 
            CommentInfo comment = new CommentInfo { text = "this is a nunit generated comment." + Guid.NewGuid().ToString() };
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.DebugIdentity, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID, null, Guid.Empty);
            _comments.CreateComment(result, comment);

            //get forum again
            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration);
            Assert.IsTrue(result.commentSummary.Total == 1);


            string newText = " this is editted text";
            // Now ste the closing date of the forum to something in the past.
            ModerateComment(result.commentList.comments[0].ID, result.ForumID, ModerationItemStatus.PassedWithEdit, newText);

            result = _comments.GetCommentForumByUid(result.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.commentList.comments[0].hidden == 0);
            Assert.IsTrue(result.commentList.comments[0].text == newText);
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="postid"></param>
        /// <param name="forumid"></param>
        /// <param name="status"></param>
        /// <param name="edittedText"></param>
        private void ModerateComment(int postid, int forumid, ModerationItemStatus status, string edittedText)
        {
            using (FullInputContext _context = new FullInputContext(""))
            {
                int threadId = 0, modId = 0, threadModStatus = 0;

                using (IDnaDataReader dataReader = _context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY("select modid, threadid, status from threadmod where postid=" + postid.ToString());
                    if (dataReader.Read())
                    {
                        threadId = dataReader.GetInt32NullAsZero("threadid");
                        modId = dataReader.GetInt32NullAsZero("modid");
                        threadModStatus = dataReader.GetInt32NullAsZero("status");
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

                if (status == ModerationItemStatus.PassedWithEdit)
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
        private int GetStatCounter(string counter)
        {
            //load stats
            XmlDocument xStat = new XmlDocument();
            xStat.LoadXml(Statistics.GetStatisticsXML(60 * 24));
            return Int32.Parse(xStat.SelectSingleNode("/STATISTICS/STATISTICSDATA/" + counter.ToUpper()).InnerText);

        }
        

    }
}
