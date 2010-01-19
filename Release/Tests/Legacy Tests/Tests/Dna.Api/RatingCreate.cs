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
	public class RatingCreateTests
	{
        /// <summary>
        /// 
        /// </summary>
        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After ratingForumTests");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Statistics.InitialiseIfEmpty();
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        private ISiteList _siteList;
        private ISite site = null;
        private Reviews _ratings = null;
        /// <summary>
        /// Constructor
        /// </summary>
        public RatingCreateTests()
        {
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                site = _siteList.GetSite("h2g2");
                _ratings = new Reviews(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                _ratings.siteList = _siteList;
            }
            
        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        public RatingForum RatingForumCreate(string id)
        {
            return RatingForumCreate(id, ModerationStatus.ForumStatus.Reactive, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        public RatingForum RatingForumCreate(string id, ModerationStatus.ForumStatus moderationStatus)
        {
            return RatingForumCreate(id, moderationStatus, DateTime.MinValue);

        }

        /// <summary>
        /// tests successful RatingForumCreate 
        /// </summary>
        public RatingForum RatingForumCreate(string id, ModerationStatus.ForumStatus moderationStatus, DateTime closingDate)
        {
            RatingForum ratingForum = new RatingForum
            {
                Id = id,
                ParentUri = "http://www.bbc.co.uk/dna/h2g2/",
                Title = "testratingForum",
                ModerationServiceGroup = moderationStatus,
                CloseDate = closingDate
            };

            RatingForum result = _ratings.RatingForumCreate(ratingForum, site);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.Id == ratingForum.Id);
            Assert.IsTrue(result.ParentUri == ratingForum.ParentUri);
            Assert.IsTrue(result.Title == ratingForum.Title);
            return result;
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_Good()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithoutRating()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating."
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            //repeat post
            RatingInfo returnRating = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(returnRating.rating == 0);

        }

        /// <summary>
        /// tests RatingForumCreate with repeat posts
        /// </summary>
        [TestMethod]
        public void RatingCreate_RepeatRating()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);



            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            RatingForum ratingForumData = _ratings.RatingForumReadByUID(ratingForumID,site);
            int total = ratingForumData.ratingsList.TotalCount;

            //repeat post
            try
            {
                result = _ratings.RatingCreate(ratingForumData, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.MultipleRatingByUser);
            }
        }

        /// <summary>
        /// tests RatingForumCreate with repeat posts
        /// </summary>
        [TestMethod]
        public void RatingCreate_RatingLargerThanSiteOption()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = 6//site option = 5
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            //repeat post
            try
            {
                _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.RatingExceedsMaximumAllowed);
            }
        }

        /// <summary>
        /// tests RatingForumCreate with repeat posts
        /// </summary>
        [TestMethod]
        public void RatingCreate_RatingWithBiggerSiteOption()
        {
            try
            {
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() + ",'CommentForum', 'MaxForumRatingScore','15',0,'test MaxForumRatingScore value')");
                        _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                        _ratings.siteList = _siteList;
                    }
                }

                //set up test data
                RatingInfo rating = new RatingInfo
                {
                    text = "this is a nunit generated rating.",
                    rating = 14//standard site option = 5
                };
                rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();

                RatingForum ratingForum = RatingForumCreate(ratingForumID);
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

                //getr the forum and check value
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID > 0);
                Assert.IsTrue(result.text == rating.text);
                Assert.IsTrue(result.rating == rating.rating);
            }
            finally
            {
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='MaxForumRatingScore'");
                        _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                        _ratings.siteList = _siteList;
                    }
                }
            }
        }

        /// <summary>
        /// tests RatingForumCreate with repeat posts
        /// </summary>
        [TestMethod]
        public void RatingCreate_RepeatDifferentRatingText()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = 3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            


            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            RatingForum ratingForumData = _ratings.RatingForumReadByUID(ratingForumID, site);
            int total = ratingForumData.ratingsList.TotalCount;

            rating = new RatingInfo
            {
                text = "this is a nunit generated rating.",
                rating = 3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            //post new rating from same user
            try
            {
                result = _ratings.RatingCreate(ratingForumData, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.MultipleRatingByUser);
            }
        }

        /// <summary>
        /// Tests trying to post as a banned user
        /// </summary>
        [Ignore]
        public void RatingCreate_BannedUser()
        {
            Reviews ratings = null;
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                ratings = new Reviews(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
            }
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetBannedUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetBannedUserAccount.IdentityUserName);

            try
            {
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.UserIsBanned);
            }
        }

        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated emergency closed site
        /// </summary>
        [TestMethod]
        public void RatingCreate_RatingOnEmergencyClosedSite()
        {
            //create ratings objects

            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            try
            {//turn the site into emergency closed mode
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = true;
                _ratings.siteList = _siteList;
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.SiteIsClosed);
            }
            finally
            {//reset the site into emergency closed mode
                _siteList.GetSite(site.ShortName).IsEmergencyClosed = false;
            }
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithIllegalXmlChars()
        {
            //set up test data
            string illegalChar = "&#20;";
            RatingInfo rating = new RatingInfo
            {
                text = String.Format("this is a nunit {0}generated rating.", illegalChar)
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);


            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text.IndexOf(illegalChar) < 0);//illegal char stripped
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithIllegalTags()
        {
            //set up test data
            string illegalTags = "<script/><object/><embed/>";
            RatingInfo rating = new RatingInfo
            {
                text = String.Format("this is a nunit {0}generated rating.", illegalTags)
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);


            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text.IndexOf(illegalTags) < 0);//illegal char stripped
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_TestRatingWithALinkWithCRLFInIt()
        {
            //set up test data
            string input = @"blahblahblah<a href=""http:" + "\r\n" + @""">Test Link</a>";
            string expectedOutput = "blahblahblah<a href=\"http: \">Test Link</a>";

            RatingInfo rating = new RatingInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == expectedOutput);//illegal char stripped
        }

        /// <summary>
        /// tests ratingCreate functionality
        /// </summary>
        [TestMethod]
        public void RatingCreate_TestRichTextPosts()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b>
with a carrage return.";
            string expectedOutput = "blahblahblah2<b>NormalUser</b><BR />with a carrage return.";

            RatingInfo rating = new RatingInfo
            {
                text = input
            };
            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == expectedOutput);//illegal char stripped
        }

        /// <summary>
        /// tests ratingCreate functionality
        /// </summary>
        [TestMethod]
        public void RatingCreate_TestRichTextPostWithDodgyTagsReportsCorrectErrors()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">>fail you <bugger</a>with a carrage
return.";

            RatingInfo rating = new RatingInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            bool exceptionThrown = false;
            try
            {
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch { exceptionThrown = true; }
            Assert.IsTrue(exceptionThrown);

            rating.text = @"blahblahblah2<b>NormalUser</b><a href=""www.bbc.co.uk/dna/h2g2"" test='blah''>>fail you bugger</a>with an error message!!!.";
            exceptionThrown = false;
            try
            {
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch { exceptionThrown = true; }
            Assert.IsTrue(exceptionThrown);

        }

        /// <summary>
        /// tests ratingCreate functionality
        /// </summary>
        [TestMethod]
        public void RatingCreate_TestRichTextPostsCRLFInLink()
        {
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string input = @"blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage
return.";
            string expectedOutput = @"blahblahblah2<b>NormalUser</b><a href="" www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage<BR />return.";

            RatingInfo rating = new RatingInfo
            {
                text = input
            };

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == expectedOutput);//illegal char stripped
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_PreModForum()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID, ModerationStatus.ForumStatus.PreMod);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);


            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);//should be valid post ID 
            Assert.IsTrue(result.text == "This post is awaiting moderation.");

            //check if post in mod queue table
            using (FullInputContext inputcontext = new FullInputContext(false))
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
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_PreModSiteWithProcessPreMod()
        {

            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("update sites set premoderation=1 where siteid=" + site.SiteID.ToString());//set premod
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() +",'Moderation', 'ProcessPreMod','1',1,'test premod value')");

                    
                }
                _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                site = _siteList.GetSite("h2g2");
                _ratings = new Reviews(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                _ratings.siteList = _siteList;
            }

            try
            {

                //set up test data
                RatingInfo rating = new RatingInfo
                {
                    text = "this is a nunit generated rating.", rating=3
                };
                rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

                string IPAddress = String.Empty;
                Guid BBCUid = Guid.NewGuid();
                string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();

                RatingForum ratingForum = RatingForumCreate(ratingForumID, ModerationStatus.ForumStatus.Unknown);//should override this with the site value
                //normal user
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

                try
                {
                    _ratings.RatingCreate(ratingForum, rating);
                }
                catch (ApiException ex)
                {
                    Assert.IsTrue(ex.type == ErrorType.InvalidProcessPreModState);
                }
            }
            finally 
            { //reset h2g2 site
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("update sites set premoderation=0 where siteid=" + site.SiteID.ToString());//set premod
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='ProcessPreMod'");
                    }
                    _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                    site = _siteList.GetSite("h2g2");
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                    _ratings.siteList = _siteList;
                }
            }
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_PreModForumEditorEntry()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID, ModerationStatus.ForumStatus.PreMod);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetEditorUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetEditorUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);//moderation should be ignored for editors
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_PostModForum()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID, ModerationStatus.ForumStatus.PostMod);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //check if post in mod queue table
            using (FullInputContext inputcontext = new FullInputContext(false))
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
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_ReactiveModForum()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID, ModerationStatus.ForumStatus.PostMod);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_PostPastClosingDate()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit generated rating.", rating=3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum_good" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);


            //change the closing date for this forum
            using (FullInputContext _context = new FullInputContext(false))
            {
                using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
                {
                    dataReader.AddParameter("uid", ratingForumID);
                    dataReader.AddParameter("forumclosedate", DateTime.Today.AddDays(-20));
                    dataReader.Execute();
                }
            }
            ratingForum = _ratings.RatingForumReadByUID(ratingForumID, site);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            try
            {
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.ForumClosed);
            }
        }

        /// <summary>
        /// tests ratingCreate function to create rating
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithProfanities()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a nunit fuck generated rating."
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testratingForum_good" + Guid.NewGuid().ToString();
            
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            try
            {
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.ProfanityFoundInText);
            }
        }

        /// <summary>
        /// tests ratingCreate function to create rating with a character limit
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithCharLimit()
        {
            try
            {
                //set max char option
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() + ",'CommentForum', 'MaxCommentCharacterLength','15',0,'test MaxCommentCharacterLength value')");
                        _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                        _ratings.siteList = _siteList;
                    }
                }
                string ratingForumID = "good" + Guid.NewGuid().ToString();
                RatingForum ratingForum = RatingForumCreate(ratingForumID);
                //set up test data
                RatingInfo rating = new RatingInfo{text = Guid.NewGuid().ToString().Substring(0,10)};
                //normal user
                _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
                _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID > 0);
                Assert.IsTrue(result.text == rating.text);

                //with some markup
                ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
                rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", Guid.NewGuid().ToString().Substring(0, 10));
                result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
                Assert.IsTrue(result != null);
                Assert.IsTrue(result.ID > 0);
                Assert.IsTrue(result.text == rating.text);

                //string too large with html
                ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
                rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", "stringtopad".PadRight(20));
                try
                {
                    result = _ratings.RatingCreate(ratingForum, rating);
                }
                catch (ApiException ex)
                {
                    Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                }

                //string too large without html
                ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
                rating.text = String.Format("{0}", "stringtopad".PadRight(20));
                try
                {
                    result = _ratings.RatingCreate(ratingForum, rating);
                }
                catch (ApiException ex)
                {
                    Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                }
            }
            finally 
            {
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                    {
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='MaxCommentCharacterLength'");
                        _siteList = SiteList.GetSiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString, true);
                        _ratings.siteList = _siteList;
                    }
                }

            }
        }
        /**************************************************************************************
         * Threaded Rating Tests
         * ************************************************************************************/


        /// <summary>
        /// Tests ratingThreadCreate function to create rating thread
        /// </summary>
        [TestMethod]
        public void RatingCreateThread_Good()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a test generated rating.",
                rating = 3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testthreadedratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            ThreadInfo result = _ratings.RatingThreadCreate(ratingForum, rating);
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.rating.ID > 0);
            Assert.IsTrue(result.rating.text == rating.text);
        }

        /// <summary>
        /// Tests ratingThreadCreate function to create rating thread
        /// </summary>
        [TestMethod]
        public void RatingCreateTwoThreads_Good()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a test generated rating.",
                rating = 3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testthreadedratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //1st normal users rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            ThreadInfo result = _ratings.RatingThreadCreate(ratingForum, rating);
            int threadID1 = result.id;
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.rating.ID > 0);
            Assert.IsTrue(result.rating.text == rating.text);

            //create second editors rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetEditorUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetEditorUserAccount.IdentityUserName);

            rating.text += "SecondOne";

            result = _ratings.RatingThreadCreate(ratingForum, rating);
            int threadID2 = result.id;
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.rating.ID > 0);
            Assert.IsTrue(result.rating.text == rating.text);

            Assert.IsTrue(threadID1 != threadID2, "Thread ids are the same, they need to be in different threads");
        }

        /// <summary>
        /// Tests ratingThreadCreate function to create rating thread
        /// </summary>
        [TestMethod]
        public void RatingCreateTwoThreadsAndCommentsOnEach_Good()
        {
            //set up test data
            RatingInfo rating = new RatingInfo
            {
                text = "this is a test generated rating.",
                rating = 3
            };
            rating.text += Guid.NewGuid().ToString();//have to randomize the string to post

            string IPAddress = String.Empty;
            Guid BBCUid = Guid.NewGuid();
            string ratingForumID = "testthreadedratingForum" + Guid.NewGuid().ToString();

            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //1st normal users rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            ThreadInfo result = _ratings.RatingThreadCreate(ratingForum, rating);
            int threadID1 = result.id;
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.rating.ID > 0);
            Assert.IsTrue(result.rating.text == rating.text);

            //create second editors rating
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetEditorUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetEditorUserAccount.IdentityUserName);

            rating.text += "SecondOne";

            result = _ratings.RatingThreadCreate(ratingForum, rating);
            int threadID2 = result.id;

            Assert.IsTrue(result != null);
            Assert.IsTrue(result.rating.ID > 0);
            Assert.IsTrue(result.rating.text == rating.text);

            Assert.IsTrue(threadID1 != threadID2);

            //1st normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);

            //Now the comments
            //set up test data
            string baseText = "This is a generated test comment on a rating." + Guid.NewGuid().ToString();
            CommentInfo comment = new CommentInfo
            {
                text = baseText,
            };

            comment.text += "FirstCommentOnFirstRating";
            CommentInfo commentResult = _ratings.RatingCommentCreate(ratingForum, threadID1, comment);
            Assert.IsTrue(commentResult != null);
            Assert.IsTrue(commentResult.text == comment.text);

            comment.text = baseText + "FirstCommentOnSecondRating";
            commentResult = _ratings.RatingCommentCreate(ratingForum, threadID2, comment);
            Assert.IsTrue(commentResult != null);
            Assert.IsTrue(commentResult.text == comment.text);

            //1st comment by the editor account
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUserAccounts.GetEditorUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetEditorUserAccount.IdentityUserName);

            comment.text = baseText + "SecondCommentOnFirstRating";
            commentResult = _ratings.RatingCommentCreate(ratingForum, threadID1, comment);
            Assert.IsTrue(commentResult != null);
            Assert.IsTrue(commentResult.text == comment.text);
        }

	}
}
