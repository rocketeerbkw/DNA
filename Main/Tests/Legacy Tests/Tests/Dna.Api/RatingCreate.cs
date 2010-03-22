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

namespace Tests
{
	/// <summary>
	/// Tests for the Cookie decoder class
	/// </summary>
	[TestClass]
	public class RatingCreateTests
	{
        /// <summary>
        /// Class setup force a proper restore
        /// </summary>
        /// <param name="a"></param>
        [ClassInitialize]      
        public static void ClassSetup(TestContext a)
        {
            Console.WriteLine("Class Setup");
            SnapshotInitialisation.ForceRestore();

        }        /// <summary>
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
            SnapshotInitialisation.RestoreFromSnapshot();
            Statistics.InitialiseIfEmpty();
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                ProfanityFilter.InitialiseProfanitiesIfEmpty(inputcontext.ReaderCreator, null);
                _siteList = SiteList.GetSiteList(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics);
                site = _siteList.GetSite("h2g2");
                site.IsEmergencyClosed = false;
                _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
        }

        private ISiteList _siteList;
        private ISite site = null;
        private Reviews _ratings = null;
        /// <summary>
        /// Constructor
        /// </summary>
        public RatingCreateTests()
        {
            
            
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
                    }
                    _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                    site = _siteList.GetSite("h2g2");
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
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
                        _siteList = new SiteList(DnaMockery.CreateDatabaseReaderCreator(), null);
                        _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
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
                ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
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

            var callingUser = _ratings.CallingUser;
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
                using (FullInputContext inputcontext = new FullInputContext(false))
                {
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                    _ratings.CallingUser = callingUser;
                }
                RatingInfo result = _ratings.RatingCreate(ratingForum, rating);
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
            Assert.IsTrue(result.FormatttedText.IndexOf(illegalTags) < 0);//illegal char stripped
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
            Assert.AreEqual(expectedOutput, result.FormatttedText);//illegal char stripped
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
            Assert.AreEqual(expectedOutput, result.FormatttedText);//illegal char stripped
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
            Assert.AreEqual(expectedOutput, result.FormatttedText);//illegal char stripped
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
            Assert.AreEqual("This post is awaiting moderation.", result.FormatttedText);

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
                _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                site = _siteList.GetSite("h2g2");
                _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), inputcontext.SiteList);
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
                    _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                    site = _siteList.GetSite("h2g2");
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), inputcontext.SiteList);
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


        /************************************************************************************************/
        /* Char limit tests
         * ***********************************************/
        /// <summary>
        /// tests ratingCreate function to create rating with a character limit
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithCharLimit()
        {
            try
            {
                Random random = new Random(DateTime.Now.Millisecond);
                int maxCharLength = random.Next(1, 4000);

                //set max char option
                SetMaxCharLimit(maxCharLength);

                GoodMaxPostCheck(maxCharLength);

                BadMaxPostCheck(maxCharLength);
            }
            finally 
            {
                DeleteMinMaxLimitSiteOptions();
            }
        }
        /// <summary>
        /// tests ratingCreate function to create rating with a minimum character limit
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithMinCharLimit()
        {
            try
            {
                Random random = new Random(DateTime.Now.Millisecond);
                int minCharLength = random.Next(1, 4000);
                //set min char option
                SetMinCharLimit(minCharLength);

                GoodMinPostCheck(minCharLength);

                BadMinPostCheck(minCharLength);
            }
            finally
            {
                DeleteMinMaxLimitSiteOptions();
            }
        }

        private void BadMaxPostCheck(int maxCharLength)
        {
            string ratingForumID = "good" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //string too large with html
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            //set up test data
            RatingInfo rating = new RatingInfo { text = String.Format("<div><b><i><u>{0}</u></i></b></div>", "a".PadRight(maxCharLength + 1)) };
            RatingInfo result;
            bool exceptionFlagged = false;
            try
            {
                result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                exceptionFlagged = true;
            }
            //check an exception was raised
            Assert.IsTrue(exceptionFlagged);
            //reset flag to say it has raised an exception
            exceptionFlagged = false;

            //string too large without html
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("{0}", "a".PadRight(maxCharLength + 1));
            try
            {
                result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.ExceededTextLimit);
                exceptionFlagged = true;
            }
        }

        private void BadMinPostCheck(int minCharLength)
        {
            string ratingForumID = "good" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //string too small with html
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            //set up test data
            RatingInfo rating = new RatingInfo { text = String.Format("<div><b><i><u>{0}</u></i></b></div>", "".PadRight(minCharLength-1)) };
            RatingInfo result;
            bool exceptionFlagged = false;
            try
            {
                result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.MinCharLimitNotReached);
                exceptionFlagged = true;
            }
            //check an exception was raised
            Assert.IsTrue(exceptionFlagged);

            //reset flag to say it has raised an exception
            exceptionFlagged = false;

            //string too small without html
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("{0}", "".PadRight(minCharLength-1));
            try
            {
                result = _ratings.RatingCreate(ratingForum, rating);
            }
            catch (ApiException ex)
            {
                Assert.IsTrue(ex.type == ErrorType.MinCharLimitNotReached);
                exceptionFlagged = true;
            }
            Assert.IsTrue(exceptionFlagged);
        }

        private void GoodMaxPostCheck(int maxCharLength)
        {
            string ratingForumID = "good" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            //set up test data
            string randomString = String.Empty;
            //Getting a ok length of random characters for the test
            for (int i=0;i<10;i++)
            {
                randomString = EncodedRandomString();
                if (randomString.Length >  maxCharLength)
                {
                    break;
                }
            }

            string maxText = randomString.Substring(0, maxCharLength);
            Console.WriteLine("maxText Length :" + maxText.Length.ToString());

            RatingInfo rating = new RatingInfo { text = maxText };
            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //with some markup
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", maxText);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);
        }

        private void GoodMinPostCheck(int minCharLength)
        {
            string ratingForumID = "good" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);
            string randomString = EncodedRandomString();

            string minText = randomString.Substring(0, minCharLength);

            //set up test data
            RatingInfo rating = new RatingInfo { text = minText };

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //with some markup
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", minText);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);
        }

        private void GoodMinMaxPostCheck(int minCharLength, int maxCharLength)
        {
            string ratingForumID = "good" + Guid.NewGuid().ToString();
            RatingForum ratingForum = RatingForumCreate(ratingForumID);

            string randomString = EncodedRandomString();

            string goodText = randomString.Substring(0, maxCharLength);

            //Test max boundary
            RatingInfo rating = new RatingInfo();
            rating.text = goodText;

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            RatingInfo result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //with some markup
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", goodText);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            ratingForumID = "good" + Guid.NewGuid().ToString();
            ratingForum = RatingForumCreate(ratingForumID);

            goodText = randomString.Substring(0, minCharLength);

            //Test max boundary
            rating = new RatingInfo();
            rating.text = goodText;

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //with some markup
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", goodText);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            ratingForumID = "good" + Guid.NewGuid().ToString();
            ratingForum = RatingForumCreate(ratingForumID);

            goodText = randomString.Substring(0, (minCharLength + ((maxCharLength - minCharLength)/2)));

            //Test max boundary
            rating = new RatingInfo();
            rating.text = goodText;

            //normal user
            _ratings.CallingUser = new CallingUser(SignInSystem.SSO, DnaMockery.DnaConfig.ConnectionString, null);
            _ratings.CallingUser.IsUserSignedIn(TestUtils.TestUserAccounts.GetNormalUserAccount.Cookie, site.SSOService, site.SiteID, TestUserAccounts.GetNormalUserAccount.IdentityUserName);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

            //with some markup
            ratingForum = RatingForumCreate(Guid.NewGuid().ToString());
            rating.text = String.Format("<div><b><i><u>{0}</u></i></b></div>", goodText);
            result = _ratings.RatingCreate(ratingForum, rating);//should pass successfully
            Assert.IsTrue(result != null);
            Assert.IsTrue(result.ID > 0);
            Assert.IsTrue(result.text == rating.text);

        }

        /// <summary>
        /// tests ratingCreate function to create rating with character limits
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithEqualMinAndMaxCharLimits()
        {
            try
            {
                Random random = new Random(DateTime.Now.Millisecond);
                int minmaxCharLength = random.Next(1, 4000);

                SetMinCharLimit(minmaxCharLength);
                SetMaxCharLimit(minmaxCharLength);

                GoodMaxPostCheck(minmaxCharLength);

                BadMaxPostCheck(minmaxCharLength);

                GoodMinPostCheck(minmaxCharLength);

                BadMinPostCheck(minmaxCharLength);

            }
            finally
            {
                DeleteMinMaxLimitSiteOptions();
            }
        }

        /// <summary>
        /// tests ratingCreate function to create rating with character limits
        /// </summary>
        [TestMethod]
        public void RatingCreate_WithNormalMinAndMaxCharLimits()
        {
            try
            {
                Random random = new Random(DateTime.Now.Millisecond);
                int minCharLength = random.Next(1, 2000);
                int maxCharLength = minCharLength + random.Next(1, 2000);

                SetMinCharLimit(minCharLength);
                SetMaxCharLimit(maxCharLength);

                GoodMinMaxPostCheck(minCharLength, maxCharLength);

                BadMaxPostCheck(maxCharLength);
                BadMinPostCheck(minCharLength);

            }
            finally
            {
                DeleteMinMaxLimitSiteOptions();
            }
        }

        private void DeleteMinMaxLimitSiteOptions()
        {
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    try
                    {
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='MaxCommentCharacterLength'");
                    }
                    catch 
                    { 
                    }
                    try
                    {
                        reader.ExecuteDEBUGONLY("delete from siteoptions where SiteID=" + site.SiteID.ToString() + " and Name='MinCommentCharacterLength'");
                    }
                    catch
                    {
                    }
                }
                _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
            }
        }

        private void SetMaxCharLimit(int maxLimit)
        {
            //set min and max char option
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() + ",'CommentForum', 'MaxCommentCharacterLength','" + maxLimit.ToString() + "',0,'test MaxCommentCharacterLength value')");
                    _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
                }
            }
        }
        private void SetMinCharLimit(int minLimit)
        {
            //set min and max char option
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(" + site.SiteID.ToString() + ",'CommentForum', 'MinCommentCharacterLength','" + minLimit.ToString() + "',0,'test MinCommentCharacterLength value')");
                    _siteList = SiteList.GetSiteList(DnaMockery.CreateDatabaseReaderCreator(), null, true);
                    _ratings = new Reviews(inputcontext.dnaDiagnostics, inputcontext.ReaderCreator, CacheFactory.GetCacheManager(), _siteList);
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

        /// <summary>
        /// Gets a list of the printable ascii codes.
        /// </summary>
        /// <returns></returns>
        private string GetASCIIcodes()
        {
            string asciiCodes = String.Empty;
            for (int i = 32; i < 127; i++)
            {
                asciiCodes += (char)i;
            }
            return asciiCodes;
        }
        /// <summary>
        /// Gets a string contain a number of the printable ascii codes.
        /// </summary>
        /// <returns></returns>
        private string RandomString()
        {
            int length = 4000;
            string randomString = String.Empty;
            string asciiCodes = GetASCIIcodes();
            Random random = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < length; i++)
            {
                randomString += asciiCodes[random.Next(asciiCodes.Length)];
            }
            return randomString;
        }
        /// <summary>
        /// Gets an encoded string contain a number of the printable ascii codes.
        /// </summary>
        /// <returns></returns>
        private string EncodedRandomString()
        {
            int length = 8000;
            string randomString = String.Empty;
            string asciiCodes = GetASCIIcodes();
            Random random = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < length; i++)
            {
                randomString += asciiCodes[random.Next(asciiCodes.Length)];
            }
            string strippedText = StringUtils.StripFormattingFromText(randomString);

            return StringUtils.EscapeAllXml(strippedText);
        }
    }
}
