using System;
using System.Collections.Generic;
using System.Text;
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
	public class CommentForumTests
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
            SnapshotInitialisation.ForceRestore();
            Statistics.InitialiseIfEmpty();

            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                _siteList = SiteList.GetSiteList();
                site = _siteList.GetSite("h2g2");

                _comments = new Comments(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                
                ICacheManager groupsCache = new StaticCacheManager();
                var g = new UserGroups(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
                var p = new ProfanityFilter(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
                var b = new BannedEmails(DnaMockery.CreateDatabaseReaderCreator(), null, groupsCache, null, null);
            }
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public CommentForumTests()
        {
           
            
        }
		
		/// <summary>
		/// Tests of the read of comment forums by sitename
		/// </summary>
		[TestMethod]
        public void CommentForumsReadBySiteName()
		{
           
            SetupACommentForum();

            //test good site
            CommentForumList result = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.TotalCount > 0);
            //test paging
            _comments.ItemsPerPage = 50;
            _comments.StartIndex = 0;
            result = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.TotalCount > 0);
            Assert.IsTrue(result.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(result.StartIndex == _comments.StartIndex);

		}

        private void SetupACommentForum()
        {
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            CommentForum result = null;

            commentForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
            result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
        }

        /// <summary>
        /// Tests of the read of comment forums by sitename and prefix
        /// </summary>
        [TestMethod]
        public void CommentForumsReadBySiteNameAndPrefix()
        {    
            //create 3 with the same prefix
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            CommentForum result = null;
            for (int i = 0; i < 3; i++)
            {
                commentForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _comments.CreateCommentForum(commentForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
            }
            //create one which doesn't have the prefix
            commentForum.Id = String.Format("{0}", Guid.NewGuid().ToString());
            result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);

            //get comment list with prefix
            CommentForumList resultList = _comments.GetCommentForumListBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount == 3);

        }

        /// <summary>
		/// Tests of the read of comment forums by sitename
		/// </summary>
		[TestMethod]
        public void CommentForumReadByUID()
		{
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_readUID",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            //create the comment
            //set up test data
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
            CommentInfo commentInfo = _comments.CreateComment(result, comment);
            Assert.IsTrue(commentInfo != null);
            Assert.IsTrue(commentInfo.ID > 0);
            Assert.IsTrue(commentInfo.text == comment.text);

            string badUid = "not a UID";
            //test good site
            result = _comments.GetCommentForumByUid(commentForum.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.commentList != null);
            Assert.IsTrue(result.commentList.TotalCount != 0);
            //test paging
            _comments.ItemsPerPage = 50;
            _comments.StartIndex = 0;
            result = _comments.GetCommentForumByUid(commentForum.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.commentList != null);
            Assert.IsTrue(result.commentList.TotalCount != 0);
            Assert.IsTrue(result.commentList.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(result.commentList.StartIndex == _comments.StartIndex);

            //test bad site name
            result = _comments.GetCommentForumByUid(badUid, site);
            Assert.IsTrue(result == null);

		}

        /// <summary>
        /// tests returning comments by site and forum id
        /// </summary>
        [TestMethod]
        public void CommentsReadByForumID()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_good" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            CommentForum resultCommentForum = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(resultCommentForum != null);
            Assert.IsTrue(resultCommentForum.Id == commentForum.Id);
            Assert.IsTrue(resultCommentForum.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(resultCommentForum.Title == commentForum.Title);
        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_Good()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_good",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
         
        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_WithTooManyUIDChars()
        {
            //create namespace and ID which equal 255
            CommentForum commentForum = new CommentForum
            {
                Id = "".PadRight(256, 'I'),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            try
            {
                //should throw error stating uid length too long
                CommentForum result = _comments.CreateCommentForum(commentForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumUid);
            }

        }

        /// <summary>
        /// tests CommentForumCreate with missing UID
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_Duplicate()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_dupe",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);

            //should return the same forum
            result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);

        }

        /// <summary>
        /// tests CommentForumCreate with missing UID
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_MissingUID()
        {
            CommentForum commentForum = new CommentForum
            {
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            try
            {
                CommentForum result = _comments.CreateCommentForum(commentForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumUid);
            }
        }

        /// <summary>
        /// tests CommentForumCreate with missing ParentUri
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_MissingUri()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_MissingParentUri",
                Title = "testCommentForum_MissingParentUri"
            };

            try
            {
                CommentForum result = _comments.CreateCommentForum(commentForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumParentUri);
            }

            //check with an invalid url
            commentForum = new CommentForum
            {
                Id = "testCommentForum_MissingParentUri",
                Title = "testCommentForum_MissingParentUri",
                ParentUri ="http://www.google.com"
            };

            try
            {
                CommentForum result = _comments.CreateCommentForum(commentForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumParentUri);
            }
        }

        /// <summary>
        /// tests CommentForumCreate with missing Title
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_MissingTitle()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_MissingTitle",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };
            try
            {
                CommentForum result = _comments.CreateCommentForum(commentForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumTitle);
            }
        }

        /// <summary>
        /// tests CommentForumCreate with missing sitename
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_MissingSiteName()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_missingSitename",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            try
            {
                CommentForum result = _comments.CreateCommentForum(commentForum, null);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.UnknownSite);
            }
        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_InPostmod()
        {
            CommentForum commentForum = new CommentForum
            {
                
                Id = "CommentForumCreate_InPostmod",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.PostMod);

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_InPremod()
        {
            CommentForum commentForum = new CommentForum
            {
                
                Id = "CommentForumCreate_InPremod",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };
            
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod);

        }

        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_InReactive()
        {
            CommentForum commentForum = new CommentForum
            {
                
                Id = "CommentForumCreate_InReactive",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive
            };
            

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.Reactive);

        }

        /*
        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_WithInvalidModeration()
        {
            CommentForum commentForum = new CommentForum
            {
                
                Id = "CommentForumCreate_InReactive",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = "invalid status"
            };
            

            Comments comments = null;
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                comments = new Comments(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);

            }
            bool exceptionThrown = false;
            try
            {
                CommentForum result = _comments.CommentForumCreate(commentForum, siteName);
            }
            catch
            {
                exceptionThrown = true;
            }
            Assert.IsTrue(exceptionThrown, "Exception missed for missing title");

        }*/


        /// <summary>
        /// tests successful CommentForumCreate 
        /// </summary>
        [TestMethod]
        public void CommentForumCreate_WithFixedClosedDate()
        {
            CommentForum commentForum = new CommentForum
            {
                
                Id = "CommentForumCreate_InReactive" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                CloseDate = DateTime.Now.AddDays(2)
            };
            

            DateTime expectedCloseDate = commentForum.CloseDate.AddDays(1);//add a day
            expectedCloseDate = new DateTime(expectedCloseDate.Year, expectedCloseDate.Month, expectedCloseDate.Day);//force to midnight

            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            
            Assert.IsTrue(result.CloseDate == expectedCloseDate);
        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentListReadBySiteName()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_CommentListReadBySiteName",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            //create the comment
            //set up test data
            for (int i = 0; i < 10; i++)
            {
                CommentInfo comment = new CommentInfo
                {
                    text = "this is a nunit generated comment."
                };
                comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _comments.CreateComment(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }

           
            //test good site
            CommentsList resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            //test paging
            _comments.ItemsPerPage = 3;
            _comments.StartIndex = 5;
            resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            Assert.IsTrue(resultList.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _comments.StartIndex);
        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentListReadBySiteNameAndPrefix()
        {
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = prefix + "_" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            //create the comment
            //set up test data
            for (int i = 0; i < 10; i++)
            {
                CommentInfo comment = new CommentInfo
                {
                    text = "this is a nunit generated comment."
                };
                comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _comments.CreateComment(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            CommentsList resultList = _comments.GetCommentsListBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount == 10);
            //test paging
            _comments.ItemsPerPage = 3;
            _comments.StartIndex = 5;
            resultList = _comments.GetCommentsListBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount == 10);
            Assert.IsTrue(resultList.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _comments.StartIndex);

        }

        /// <summary>
        /// Tests of the read of comment forums by sitename and prefix with sorting
        /// </summary>
        [TestMethod]
        public void CommentForumsReadAll_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixTest";
            CommentForum commentForum = new CommentForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            CommentForum result = null;
            for (int i = 0; i < 3; i++)
            {
                commentForum.Title = this.ToString();
                commentForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _comments.CreateCommentForum(commentForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
            }

            //get comment list with ascending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Ascending;
            CommentForumList resultList = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for(int i=0;i<resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Descending;
            resultList = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Tests of the read of comment forums by sitename and prefix with sorting
        /// </summary>
        [TestMethod]
        public void CommentForumsReadBySite_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            CommentForum result = null;
            for (int i = 0; i < 3; i++)
            {
                commentForum.Title = this.ToString();
                commentForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _comments.CreateCommentForum(commentForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
            }

            //get comment list with ascending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Ascending;
            CommentForumList resultList = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Descending;
            resultList = _comments.GetCommentForumListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Tests of the read of comment forums by sitename and prefix with sorting
        /// </summary>
        [TestMethod]
        public void CommentForumsReadBySitePrefix_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            CommentForum result = null;
            for (int i = 0; i < 3; i++)
            {
                commentForum.Title = this.ToString();
                commentForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _comments.CreateCommentForum(commentForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == commentForum.Id);
                Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
                Assert.IsTrue(result.Title == commentForum.Title);
            }

            //get comment list with ascending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Ascending;
            CommentForumList resultList = _comments.GetCommentForumListBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Descending;
            resultList = _comments.GetCommentForumListBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void CommentListReadBySiteName_SortBy_Created()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_CommentListReadBySiteName" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };


            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            //create the comment
            //set up test data
            for (int i = 0; i < 10; i++)
            {
                CommentInfo comment = new CommentInfo
                {
                    text = "this is a nunit generated comment."
                };
                comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _comments.CreateComment(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            CommentsList resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.comments.Count != 0);
            //test paging
            _comments.ItemsPerPage = 3;
            _comments.StartIndex = 5;
            resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            Assert.IsTrue(resultList.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _comments.StartIndex);

            //get comment list with ascending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Ascending;
            resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Descending;
            resultList = _comments.GetCommentsListBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.SortDirection == _comments.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// </summary>
        [TestMethod]
        public void CommentListReadByUID_SortBy_Created()
        {
            string uid = "testCommentForum_CommentListReadBySiteName" + Guid.NewGuid().ToString();
            CommentForum commentForum = new CommentForum
            {
                Id = uid,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };


            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);
            //create the comment
            //set up test data
            for (int i = 0; i < 10; i++)
            {
                CommentInfo comment = new CommentInfo
                {
                    text = "this is a nunit generated comment."
                };
                comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                //normal user
                _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
                _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _comments.CreateComment(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            CommentForum resultList = _comments.GetCommentForumByUid(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.TotalCount != 0);
            //test paging
            _comments.ItemsPerPage = 3;
            _comments.StartIndex = 5;
            resultList = _comments.GetCommentForumByUid(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.TotalCount != 0);
            Assert.IsTrue(resultList.commentList.ItemsPerPage == _comments.ItemsPerPage);
            Assert.IsTrue(resultList.commentList.StartIndex == _comments.StartIndex);

            //get comment list with ascending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Ascending;
            resultList = _comments.GetCommentForumByUid(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.commentList.SortDirection == _comments.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _comments.SortBy = SortBy.Created;
            _comments.SortDirection = SortDirection.Descending;
            resultList = _comments.GetCommentForumByUid(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.SortBy == _comments.SortBy);
            Assert.IsTrue(resultList.commentList.SortDirection == _comments.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }
        }

        /// <summary>
        /// Tests the read of a comment by its PostID
        /// </summary>
        [TestMethod]
        public void CommentReadByPostID()
        {
            CommentForum commentForum = new CommentForum
            {
                Id = "testCommentForum_CommentReadByPostIDTest",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            CommentForum result = _comments.CreateCommentForum(commentForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == commentForum.Id);
            Assert.IsTrue(result.ParentUri == commentForum.ParentUri);
            Assert.IsTrue(result.Title == commentForum.Title);

            CommentInfo comment1 = SetupComment();
            CommentInfo createdComment1 = _comments.CreateComment(result, comment1);

            Assert.IsTrue(createdComment1 != null);
            Assert.IsTrue(createdComment1.ID > 0);
            Assert.IsTrue(createdComment1.text == comment1.text);

            CommentInfo comment2 = SetupComment();
            CommentInfo createdComment2 = _comments.CreateComment(result, comment2);

            Assert.IsTrue(createdComment2 != null);
            Assert.IsTrue(createdComment2.ID > 0);
            Assert.IsTrue(createdComment2.text == comment2.text);

            CommentInfo comment3 = SetupComment();
            CommentInfo createdComment3 = _comments.CreateComment(result, comment3);

            Assert.IsTrue(createdComment3 != null);
            Assert.IsTrue(createdComment3.ID > 0);
            Assert.IsTrue(createdComment3.text == comment3.text);


            CommentInfo returnedCommentInfo = _comments.CommentReadByPostId(createdComment1.ID.ToString(), site);
            Assert.IsTrue(createdComment1.text == returnedCommentInfo.text);

            returnedCommentInfo = _comments.CommentReadByPostId(createdComment3.ID.ToString(), site);
            Assert.IsTrue(createdComment3.text == returnedCommentInfo.text);

            returnedCommentInfo = _comments.CommentReadByPostId(createdComment2.ID.ToString(), site);
            Assert.IsTrue(createdComment2.text == returnedCommentInfo.text);

            returnedCommentInfo = null;
            try
            {
                returnedCommentInfo = _comments.CommentReadByPostId("0", site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.CommentNotFound);
            }
            Assert.IsTrue(returnedCommentInfo == null);
        }

        private CommentInfo SetupComment()
        {
            //create the comment
            CommentInfo comment = new CommentInfo
            {
                text = "this is a nunit generated comment."
            };
            comment.text += Guid.NewGuid().ToString();//have to randomize the string to post
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            //normal user
            _comments.CallingUser = new CallingUser(SignInSystem.Identity, null, null, null, _siteList);
            _comments.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
            return comment;
        }
    }
}
