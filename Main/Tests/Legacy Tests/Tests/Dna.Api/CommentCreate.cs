using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
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
	public class CommentCreateTests
	{
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
            Statistics.InitialiseIfEmpty();
            SnapshotInitialisation.RestoreFromSnapshot();


            ICacheManager groupsCache = new StaticCacheManager();
            var g = new UserGroups(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
            var p = new ProfanityFilter(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
            var b = new BannedEmails(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
        }

        private ISiteList _siteList;
        private ISite site = null;
        private Comments _comments = null;
        /// <summary>
        /// Constructor
        /// </summary>
        public CommentCreateTests()
        {
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                _siteList = SiteList.GetSiteList();
                site = _siteList.GetSite("h2g2");
                _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
            
        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string id)
        {
            return CommentForumCreate(id, ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string id, ModerationStatus.ForumStatus moderationStatus)
        {
            return CommentForumCreate(id, moderationStatus, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        public CommentForum CommentForumCreate(string id, ModerationStatus.ForumStatus moderationStatus, DateTime closingDate)
        {
            CommentForum commentForum = new CommentForum
            {
                Id = id,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = moderationStatus,
                CloseDate = closingDate
            };
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            return result;
        }

        /// <summary>
        /// Tests CommentCreate function to create comment insecurely
        /// </summary>
        [TestMethod]
        public void CommentCreate_TryCreateNonSecureComment()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);

            Comments comments = null;
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.IdentityPolicy, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.NotSecure);
            }
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_Good()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();

            CommentForum commentForum = CommentForumCreate(commentForumID);

            Comments comments = null;
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUserAccounts.GetNormalUserAccount.Cookie, TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);
        }

        /// <summary>
        /// tests CommentForumCreate with repeat posts
        /// </summary>
        [TestMethod]
        public void CommentCreate_RepeatComment()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);



            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);

            CommentForum commentForumData = _comments.GetCommentForumByUid(commentForumID,site);
            int total = commentForumData.commentList.TotalCount;

            //repeat post
            result = _comments.CreateComment(commentForumData, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);
            commentForumData = _comments.GetCommentForumByUid(commentForumID, site);
            //should not increment
            Assert.IsTrue(total == commentForumData.commentList.TotalCount);



        }

        /// <summary>
        /// Tests trying to post as a banned user
        /// </summary>
        [Ignore]
        public void CommentCreate_BannedUser()
        {
            Comments comments = null;
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetBannedUserAccount.Cookie, TestUtils.TestUserAccounts.GetBannedUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);


            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch(ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.UserIsBanned);
            }
        }

        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated emergency closed site
        /// </summary>
        [TestMethod]
        public void CommentCreate_CommentOnEmergencyClosedSite()
        {
            //create comments objects

            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);
            var callingUser = _comments.CallingUser;
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);

            try
            {//turn the site into emergency closed mode
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = true;
                using (var inputcontext = new FullInputContext(true))
                {
                    _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator,
                                             CacheFactory.GetCacheManager(), _siteList);
                    _comments.CallingUser = callingUser;
                }
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.SiteIsClosed, ex.type);
            }
            finally
            {//reset the site into emergency closed mode
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = false;
            }
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_WithIllegalXmlChars()
        {
            //set up test data
            string illegalChar = "&#20;";
            CommentInfo comment = new CommentInfo
            {
                text = String.Format("this is a nunit {0}generated comment.", illegalChar)
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);


            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text.IndexOf(illegalChar) < 0);//illegal char stripped
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_WithIllegalTags()
        {
            //set up test data
            string illegalTags = "<script/><object/><embed/>";
            CommentInfo comment = new CommentInfo
            {
                text = String.Format("this is a nunit {0}generated comment.", illegalTags)
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);


            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.FormatttedText.IndexOf(illegalTags) < 0);//illegal char stripped
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_TestCommentWithALinkWithCRLFInIt()
        {
            //set up test data
            string input = @"blahblahblah<a href=""http:" + "\r\n" + @""">Test Link</a>";
            string expectedOutput = "blahblahblah<a href=\"http: \">Test Link</a>";

            CommentInfo comment = new CommentInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie,site.IdentityPolicy, site.SiteID);
            

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.AreEqual(expectedOutput, result.FormatttedText);//illegal char stripped
        }

        /// <summary>
        /// tests CommentCreate functionality
        /// </summary>
        [TestMethod]
        public void CommentCreate_TestRichTextPosts()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b>
with a carrage return.";
            string expectedOutput = "blahblahblah2<b>NormalUser</b><BR />with a carrage return.";

            CommentInfo comment = new CommentInfo
            {
                text = input
            };
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.AreEqual(expectedOutput, result.FormatttedText); //illegal char stripped
        }

        /// <summary>
        /// tests CommentCreate functionality
        /// </summary>
        [TestMethod]
        public void CommentCreate_TestRichTextPostWithDodgyTagsReportsCorrectErrors()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">>fail you <bugger</a>with a carrage
return.";

            CommentInfo comment = new CommentInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            bool exceptionThrown = false;
            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch { exceptionThrown = true; }
            Assert.IsTrue(exceptionThrown);

            comment.text = @"blahblahblah2<b>NormalUser</b><a href=""www.bbc.co.uk/dna/h2g2"" test='blah''>>fail you bugger</a>with an error message!!!.";
            exceptionThrown = false;
            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch { exceptionThrown = true; }
            Assert.IsTrue(exceptionThrown);

        }

        /// <summary>
        /// tests CommentCreate functionality
        /// </summary>
        [TestMethod]
        public void CommentCreate_TestRichTextPostsCRLFInLink()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage
return.";
            string expectedOutput = @"blahblahblah2<b>NormalUser</b><a href="" www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage<BR />return.";

            CommentInfo comment = new CommentInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            CommentForum commentForum = CommentForumCreate(commentForumID);

            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.AreEqual(expectedOutput, result.FormatttedText);//illegal char stripped
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_PreModForum()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID, ModerationStatus.ForumStatus.PreMod);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie,TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);


            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);//should be valid post ID 
            Assert.AreEqual("This post is awaiting moderation.", result.FormatttedText);

            //check if post in mod queue table
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("select * from ThreadMod where postid=" + result.ID.ToString());
                    if(!reader.Read() || !reader.HasRows)
                    {
                        Assert.Fail("Post not in ThreadMod table and moderation queue");
                    }
                
                }
            }
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_PreModSiteWithProcessPreMod()
        {

            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("update sites set premoderation=1 where siteid=" + site.SiteID.ToString());//set premod
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() +",'Moderation', 'ProcessPreMod','1',1,'test premod value')");

                    
                }
                _siteList = SiteList.GetSiteList();
                site = _siteList.GetSite("h2g2");
                _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), inputcontext.SiteList);
            }

            try
            {

                //set up test data
                CommentInfo comment = new CommentInfo
                {
                    text = "this is a nunit generated comment."
                };
                comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();

                CommentForum commentForum = CommentForumCreate(commentForumID, ModerationStatus.ForumStatus.Unknown);//should override this with the site value
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

                CommentInfo result = _comments.CreateComment(commentForum, comment);

                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID == 0);//should be have no post ID
                Assert.IsTrue(result.FormatttedText == "This post is awaiting moderation.");

                //check if post in PreModPostings queue table
                using (FullInputContext inputcontext = new FullInputContext(true))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("select top 1 * from PreModPostings where dateposted > DATEADD(mi, -1, getdate())");//must be within 2 mins of post date
                        if (!reader.Read() || !reader.HasRows)
                        {
                            Assert.Fail("Post not in ThreadMod PreModPostings and moderation queue");
                        }
                    }
                }
            }
            finally 
            { 
                //reset h2g2 site
                using (FullInputContext inputcontext = new FullInputContext(true))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("update sites set premoderation=0 where siteid=" + site.SiteID.ToString());//set premod
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='ProcessPreMod'");
                    }
                    _siteList = new SiteList(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, CacheFactory.GetCacheManager(), null, null);
                    site = _siteList.GetSite("h2g2");
                    _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                }
            }
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_PreModForumEditorEntry()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID, ModerationStatus.ForumStatus.PreMod);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetEditorUserAccount.Cookie, TestUtils.TestUserAccounts.GetEditorUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);//moderation should be ignored for editors
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_PostModForum()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID, ModerationStatus.ForumStatus.PostMod);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);

            //check if post in mod queue table
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("select * from ThreadMod where postid=" + result.ID.ToString());
                    if (!reader.Read() || !reader.HasRows)
                    {
                        Assert.Fail("Post not in ThreadMod table and moderation queue");
                    }

                }
            }
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_ReactiveModForum()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID, ModerationStatus.ForumStatus.PostMod);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            CommentInfo result = _comments.CreateComment(commentForum, comment);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == comment.text);
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_PostPastClosingDate()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum_good" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);


            //change the closing date for this forum
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("", DnaMockery.DnaConfig.ConnectionString, inputcontext.dnaDiagnostics))
                {
                    string sqlQuery = string.Format("update commentforums set forumclosedate = GetDate()-1 where UID = '{0}'", commentForumID);
                    reader.ExecuteDEBUGONLY(sqlQuery);
                }
            }
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            bool exceptionThrown = false;
            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch { exceptionThrown = true; }
            Assert.IsTrue(exceptionThrown);
        }

        /// <summary>
        /// tests CommentCreate function to create comment
        /// </summary>
        [TestMethod]
        public void CommentCreate_WithProfanities()
        {
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit fuck generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string commentForumID = "testCommentForum_good" + Guid.NewGuid().ToString();
            
            CommentForum commentForum = CommentForumCreate(commentForumID);
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);

            
            try
            {
                CommentInfo result = _comments.CreateComment(commentForum, comment);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.ProfanityFoundInText);
            }
            
        }

        /// <summary>
        /// tests CommentCreate function to create comment with a character limit
        /// </summary>
        [TestMethod]
        public void CommentCreate_WithCharLimit()
        {
            try
            {
                //set max char option
                using (FullInputContext inputcontext = new FullInputContext(true))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() + ",'CommentForum', 'MaxCommentCharacterLength','15',0,'test MaxCommentCharacterLength value')");
                        _siteList = SiteList.GetSiteList();
                        _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                    }
                }
                string commentForumID = "good" + Guid.NewGuid().ToString();
                CommentForum commentForum = CommentForumCreate(commentForumID);
                //set up test data
                CommentInfo comment = new CommentInfo{text = Guid.NewGuid().ToString().Substring(0,10)};
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.IsUserSignedInSecure(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, TestUtils.TestUserAccounts.GetNormalUserAccount.SecureCookie, site.IdentityPolicy, site.SiteID);
                CommentInfo result = _comments.CreateComment(commentForum, comment);//should pass successfully
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID > 0);
                Assert.IsTrue(result.text == comment.text);

                //with some markup
                comment.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", Guid.NewGuid().ToString().Substring(0, 10));
                result = _comments.CreateComment(commentForum, comment);//should pass successfully
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID > 0);
                Assert.IsTrue(result.text == comment.text);

                //string too large with html
                comment.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", "stringtopad".PadRight(20));
                try
                {
                    result = _comments.CreateComment(commentForum, comment);
                }
                catch (ApiException ex)
                {
                    Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                }

                //string too large without html
                comment.text = String.Format("{0}", "stringtopad".PadRight(20));
                try
                {
                    result = _comments.CreateComment(commentForum, comment);
                }
                catch (ApiException ex)
                {
                    Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                }
            }
            finally 
            {
                using (FullInputContext inputcontext = new FullInputContext(true))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='MaxCommentCharacterLength'");
                        _siteList = new SiteList(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, CacheFactory.GetCacheManager(), null, null);
                        _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                    }
                }
            }
        }



        private static void GetNewIdentityUser(out Cookie cookie, out Cookie secureCookie)
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            string userName = "dnatester";
            string password = "123456789";
            string dob = "1972-09-07";
            string email = "a@b.com";

            string testUserName = String.Empty;

            // Create a unique name and email for the test
            testUserName = userName + DateTime.Now.Ticks.ToString();
            email = testUserName + "@bbc.co.uk";

            request.SetCurrentUserAsNewIdentityUser(testUserName, password, "", email, dob, TestUserCreator.IdentityPolicies.Adult, "h2g2", TestUserCreator.UserType.IdentityOnly);
            string returnedCookie = request.CurrentCookie;
            string returnedSecureCookie = request.CurrentSecureCookie;
            cookie = new Cookie("IDENTITY", returnedCookie, "/", ".bbc.co.uk");
            secureCookie = new Cookie("IDENTITY-HTTPS", returnedSecureCookie, "/", ".bbc.co.uk");
        }

        private void SetupSiteForIdentityLogin()
        {
            /*using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                StringBuilder sql = new StringBuilder("exec setsiteoption 1,'SignIn','UseIdentitySignIn','1'");
                sql.AppendLine("UPDATE Sites SET IdentityPolicy='http://identity/policies/dna/adult' WHERE SiteID=1");
                reader.ExecuteDEBUGONLY(sql.ToString());
            }
            using (FullInputContext inputContext = new FullInputContext(true))
            {//send signal
                inputContext.SendSignal("action=recache-site");
                _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null);
            }*/

            ICacheManager groupsCache = new StaticCacheManager();
            var g = new UserGroups(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);

        }

	}
}
