using System;
using System.Collections.Generic;
using System.Text;
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

namespace Tests
{
	/// <summary>
	/// Tests for the Cookie decoder class
	/// </summary>
	[TestClass]
	public class RatingForumTests
	{
        private ISiteList _siteList;
        private ISite site = null;
        private Reviews _ratings = null;

        /// <summary>
        /// 
        /// </summary>
        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After RatingForumTests");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            Statistics.InitialiseIfEmpty();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public RatingForumTests()
        {
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                _siteList = SiteList.GetSiteList(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
                site = _siteList.GetSite("h2g2");

                _ratings = new Reviews(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                _ratings.siteList = _siteList;
            }
            
        }
		
		
        /// <summary>
		/// Tests of the read of comment forums by sitename
		/// </summary>
		[TestMethod]
        public void RatingForumReadByUID()
		{
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_readUID",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            //create the comment
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated comment." + Guid.NewGuid().ToString(),
                rating = 5
            };
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
            RatingInfo returnedRating = _ratings.RatingCreate(result, rating);
            Assert.IsTrue(returnedRating != null);
            Assert.IsTrue(returnedRating.ID > 0);
            Assert.IsTrue(returnedRating.text == rating.text);
            Assert.IsTrue(returnedRating.rating == rating.rating);

            //test good site
            result = _ratings.RatingForumReadByUID(ratingForum.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ratingsList != null);
            Assert.IsTrue(result.ratingsList.TotalCount != 0);
            Assert.IsTrue(result.ratingsSummary.Average == 5);
            //test paging
            _ratings.ItemsPerPage = 50;
            _ratings.StartIndex = 0;
            result = _ratings.RatingForumReadByUID(ratingForum.Id, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ratingsList != null);
            Assert.IsTrue(result.ratingsList.TotalCount != 0);
            Assert.IsTrue(result.ratingsList.ItemsPerPage == _ratings.ItemsPerPage);
            Assert.IsTrue(result.ratingsList.StartIndex == _ratings.StartIndex);

            //test bad site name
            result = _ratings.RatingForumReadByUID("this doesn't exist", site);
            Assert.IsTrue(result == null);

		}

        
        /// <summary>
        /// tests returning comments by site and forum id
        /// </summary>
        [TestMethod]
        public void RatingsReadByForumID()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_good" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            RatingForum resultCommentForum = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(resultCommentForum != null);
            Assert.IsTrue(resultCommentForum.Id == ratingForum.Id);
            Assert.IsTrue(resultCommentForum.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(resultCommentForum.Title == ratingForum.Title);
        }

        
        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_Good()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_good",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
         
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_WithTooManyUIDChars()
        {
            //create namespace and ID which equal 255
            RatingForum ratingForum = new RatingForum
            {
                Id = "".PadRight(256, 'I'),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            try
            {
                //should throw error stating uid length too long
                RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumUid);
            }

        }

        /// <summary>
        /// tests RatingForumCreate with missing UID
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_Duplicate()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_dupe",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);


            RatingForum dupResult = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(dupResult.Created.At == result.Created.At);
            
        }

        /// <summary>
        /// tests RatingForumCreate with missing UID
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_MissingUID()
        {
            RatingForum ratingForum = new RatingForum
            {
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            
            try
            {
                RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumUid);
            }
        }

        /// <summary>
        /// tests RatingForumCreate with missing ParentUri
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_MissingUri()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_MissingParentUri",
                Title = "testCommentForum_MissingParentUri"
            };

            try
            {
                RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumParentUri);
            }
            //check that parentUri is from bbc.co.uk
            ratingForum = new RatingForum
            {
                Id = "testCommentForum_MissingParentUri",
                Title = "testCommentForum_MissingParentUri",
                ParentUri = "http://www.google.com"
            };

            try
            {
                RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumParentUri);
            }
        }

        /// <summary>
        /// tests RatingForumCreate with missing Title
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_MissingTitle()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_MissingTitle",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            try
            {
                RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.InvalidForumTitle);
            }
        }

        /// <summary>
        /// tests RatingForumCreate with missing sitename
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_MissingSiteName()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_missingSitename",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };

            try
            {
                RatingForum result = _ratings.RatingForumCreate(ratingForum, null);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.UnknownSite);
            }
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_InPostmod()
        {
            RatingForum ratingForum = new RatingForum
            {
                
                Id = "CommentForumCreate_InPostmod",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.PostMod);

        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_InPremod()
        {
            RatingForum ratingForum = new RatingForum
            {
                
                Id = "CommentForumCreate_InPremod",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod
            };
            
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod);

        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_InReactive()
        {
            RatingForum ratingForum = new RatingForum
            {
                
                Id = "CommentForumCreate_InReactive",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive
            };
            

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            
            Assert.IsTrue(result.ModerationServiceGroup == ModerationStatus.ForumStatus.Reactive);

        }
        
        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_WithFixedClosedDate()
        {
            RatingForum ratingForum = new RatingForum
            {
                
                Id = "CommentForumCreate_InReactive" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                CloseDate = DateTime.Now.AddDays(2)
            };
            

            DateTime expectedCloseDate = ratingForum.CloseDate.AddDays(1);//add a day
            expectedCloseDate = new DateTime(expectedCloseDate.Year, expectedCloseDate.Month, expectedCloseDate.Day);//force to midnight

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            
            Assert.IsTrue(result.CloseDate == expectedCloseDate);
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_WithAverage()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                SiteName = site.SiteName
            };

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);

            //create first rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            byte[] ratings = { 1, 2, 5 };
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = ratings[0]
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post
            RatingInfo ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //create second rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetEditorUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetEditorUserAccount.IdentityUserName);
            rating.rating = ratings[1];
            ratingReturned = _ratings.RatingCreate(ratingForum, rating);


            //create third rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNotableUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNotableUserAccount.IdentityUserName);
            rating.rating = ratings[2];
            ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //get rating forum back and check post count and average
            result = _ratings.RatingForumReadByUID(ratingForum.Id, site);
            Assert.IsTrue(result.ratingsSummary.Total == 3);
            Assert.IsTrue(result.ratingsSummary.Average == (ratings[0] + ratings[1] + ratings[2]) / 3);
                


        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        [TestMethod]
        public void RatingForumCreate_UserRating()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                SiteName = site.SiteName
            };

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);

            //create first rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            byte[] ratings = { 1, 2, 1 };
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = ratings[0]
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post
            //create third rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNotableUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNotableUserAccount.IdentityUserName);
            rating.rating = ratings[2];
            RatingInfo ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //get rating for a specific user
            ratingReturned = _ratings.RatingsReadByDNAUserID(ratingForum.Id, site, TestUserAccounts.GetNotableUserAccount.UserID);
            Assert.IsTrue(ratingReturned != null);
            Assert.IsTrue(ratingReturned.User != null);
            Assert.IsTrue(ratingReturned.User.UserId == TestUserAccounts.GetNotableUserAccount.UserID);

            //get rating for a specific user who hasn't rated = should be null
            ratingReturned = _ratings.RatingsReadByDNAUserID(ratingForum.Id, site, TestUserAccounts.GetSuperUserAccount.UserID);
            Assert.IsTrue(ratingReturned == null);


        }


        /// <summary>
        /// tests returning a list of reviews for a given userlist ** THIS IS NOW A LIST OF IDENTITY IDS ** 
        /// </summary>
        [Ignore]
        public void RatingForum_ByUserList()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum",
                SiteName = site.SiteName
            };

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);

            //create first rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            byte[] ratings = { 1, 2, 1 };
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = ratings[0]
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post
            RatingInfo ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //create second rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNotableUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNotableUserAccount.IdentityUserName);
            rating.rating = ratings[1];
            ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //create third rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetSuperUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNotableUserAccount.IdentityUserName);
            rating.rating = ratings[2];
            ratingReturned = _ratings.RatingCreate(ratingForum, rating);

            //get rating forum for user list who have create reviews
            int[] userList = new int[]{ TestUserAccounts.GetNormalUserAccount.UserID, TestUserAccounts.GetNotableUserAccount.UserID, TestUserAccounts.GetModeratorAccount.UserID };
            RatingForum ratingForumReturned = _ratings.RatingForumReadByUIDAndUserList(ratingForum.Id, site, userList);
            Assert.IsTrue(ratingForumReturned != null);
            Assert.IsTrue(ratingForumReturned.ratingsSummary.Total == 2);
            Assert.IsTrue(ratingForumReturned.ratingsSummary.Average == (ratings[0] + ratings[1])/2);

            //get rating forum for list of users who haven't reviewed.
            userList = new int[] { TestUserAccounts.GetEditorUserAccount.UserID};
            ratingForumReturned = _ratings.RatingForumReadByUIDAndUserList(ratingForum.Id, site, userList);
            Assert.IsTrue(ratingForumReturned != null);
            Assert.IsTrue(ratingForumReturned.ratingsSummary.Total == 0);
        }


        /// <summary>
        /// Tests the read of a review/rating by its PostID
        /// </summary>
        [TestMethod]
        public void RatingReadByPostID()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testRatingForum_RatingReadByPostID",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testRatingForum"
            };


            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            //create the rating

            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated review.",
                rating = 4
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
            RatingInfo ratingInfo = _ratings.RatingCreate(result, rating);
            Assert.IsTrue(ratingInfo != null);
            Assert.IsTrue(ratingInfo.ID > 0);
            Assert.IsTrue(ratingInfo.text == rating.text);
            Assert.IsTrue(ratingInfo.rating == rating.rating);

            RatingInfo returnedRatingInfo = _ratings.RatingReadByPostID(ratingInfo.ID.ToString(), site);
            Assert.IsTrue(ratingInfo.text == returnedRatingInfo.text);
            Assert.IsTrue(ratingInfo.rating == returnedRatingInfo.rating);

        }

        /*
        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentListReadBySiteName()
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_CommentListReadBySiteName",
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
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
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _ratings.CommentCreate(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }

           
            //test good site
            CommentsList resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            //test paging
            _ratings.ItemsPerPage = 3;
            _ratings.StartIndex = 5;
            resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            Assert.IsTrue(resultList.ItemsPerPage == _ratings.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _ratings.StartIndex);

           

        }

        /// <summary>
        /// Tests of the read of comment forums by sitename
        /// </summary>
        [TestMethod]
        public void CommentListReadBySiteNameAndPrefix()
        {
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            RatingForum ratingForum = new RatingForum
            {
                Id = prefix + "_" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };
            

            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
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
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _ratings.CommentCreate(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            CommentsList resultList = _ratings.CommentsReadBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount == 10);
            //test paging
            _ratings.ItemsPerPage = 3;
            _ratings.StartIndex = 5;
            resultList = _ratings.CommentsReadBySite(site, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount == 10);
            Assert.IsTrue(resultList.ItemsPerPage == _ratings.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _ratings.StartIndex);



        }

        /// <summary>
        /// Tests of the read of comment forums by sitename and prefix with sorting
        /// </summary>
        [TestMethod]
        public void RatingForumsReadAll_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixTest";
            RatingForum ratingForum = new RatingForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            RatingForum result = null;
            for (int i = 0; i < 3; i++)
            {
                ratingForum.Title = this.ToString();
                ratingForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _ratings.RatingForumCreate(ratingForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == ratingForum.Id);
                Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
                Assert.IsTrue(result.Title == ratingForum.Title);
            }

            //get comment list with ascending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Ascending;
            RatingForumList resultList = _ratings.CommentForumsRead(null);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for(int i=0;i<resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Descending;
            resultList = _ratings.CommentForumsRead(null);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

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
        public void RatingForumsReadBySite_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            RatingForum ratingForum = new RatingForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            RatingForum result = null;
            for (int i = 0; i < 3; i++)
            {
                ratingForum.Title = this.ToString();
                ratingForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _ratings.RatingForumCreate(ratingForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == ratingForum.Id);
                Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
                Assert.IsTrue(result.Title == ratingForum.Title);
            }

            //get comment list with ascending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Ascending;
            RatingForumList resultList = _ratings.CommentForumsRead(site.SiteName);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Descending;
            resultList = _ratings.CommentForumsRead(site.SiteName);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

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
        public void RatingForumsReadBySitePrefix_SortBy_Created()
        {

            //create 3 with the same prefix
            string prefix = "prefixtestsbycomments" + Guid.NewGuid().ToString();
            RatingForum ratingForum = new RatingForum
            {
                Id = prefix,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/"
            };

            RatingForum result = null;
            for (int i = 0; i < 3; i++)
            {
                ratingForum.Title = this.ToString();
                ratingForum.Id = String.Format("{0}-{1}", prefix, Guid.NewGuid().ToString());
                result = _ratings.RatingForumCreate(ratingForum, site);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.Id == ratingForum.Id);
                Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
                Assert.IsTrue(result.Title == ratingForum.Title);
            }

            //get comment list with ascending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Ascending;
            RatingForumList resultList = _ratings.CommentForumsRead(site.SiteName, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.CommentForums.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.CommentForums[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Descending;
            resultList = _ratings.CommentForumsRead(site.SiteName, prefix);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

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
            RatingForum ratingForum = new RatingForum
            {
                Id = "testCommentForum_CommentListReadBySiteName" + Guid.NewGuid().ToString(),
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };


            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
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
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _ratings.CommentCreate(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            CommentsList resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.comments.Count != 0);
            //test paging
            _ratings.ItemsPerPage = 3;
            _ratings.StartIndex = 5;
            resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.TotalCount != 0);
            Assert.IsTrue(resultList.ItemsPerPage == _ratings.ItemsPerPage);
            Assert.IsTrue(resultList.StartIndex == _ratings.StartIndex);

            //get comment list with ascending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Ascending;
            resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Descending;
            resultList = _ratings.CommentsReadBySite(site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.SortDirection == _ratings.SortDirection);

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
            RatingForum ratingForum = new RatingForum
            {
                Id = uid,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testCommentForum"
            };


            //create the forum
            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
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
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.CreateUserFromDnaUserID(TestUtils.TestUserAccounts.GetNormalUserAccount.UserID, site.SiteID);
                CommentInfo commentInfo = _ratings.CommentCreate(result, comment);
                Assert.IsTrue(commentInfo != null);
                Assert.IsTrue(commentInfo.ID > 0);
                Assert.IsTrue(commentInfo.text == comment.text);
            }


            //test good site
            RatingForum resultList = _ratings.CommentForumReadByUID(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.TotalCount != 0);
            //test paging
            _ratings.ItemsPerPage = 3;
            _ratings.StartIndex = 5;
            resultList = _ratings.CommentForumReadByUID(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.TotalCount != 0);
            Assert.IsTrue(resultList.commentList.ItemsPerPage == _ratings.ItemsPerPage);
            Assert.IsTrue(resultList.commentList.StartIndex == _ratings.StartIndex);

            //get comment list with ascending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Ascending;
            resultList = _ratings.CommentForumReadByUID(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.commentList.SortDirection == _ratings.SortDirection);

            DateTime prevCreate = DateTime.MinValue;
            DateTime currentDate = DateTime.MinValue;
            for (int i = 0; i < resultList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate >= prevCreate);
                prevCreate = currentDate;
            }

            //get comment list with descending sort
            _ratings.SortBy = SortBy.Created;
            _ratings.SortDirection = SortDirection.Descending;
            resultList = _ratings.CommentForumReadByUID(uid, site);
            Assert.IsTrue(resultList != null);
            Assert.IsTrue(resultList.commentList.SortBy == _ratings.SortBy);
            Assert.IsTrue(resultList.commentList.SortDirection == _ratings.SortDirection);

            prevCreate = DateTime.MaxValue;
            for (int i = 0; i < resultList.commentList.comments.Count; i++)
            {
                currentDate = DateTime.Parse(resultList.commentList.comments[i].Created.At);
                Assert.IsTrue(currentDate <= prevCreate);
                prevCreate = currentDate;
            }





        }

         */
    }
}
