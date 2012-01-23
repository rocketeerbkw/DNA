using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestUtils;
using Tests;
using BBC.Dna.Sites;
using BBC.Dna.Moderation.Utils;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Net;

namespace FunctionalTests.Services.Comments
{
    /// <summary>
    /// Summary description for Twitter
    /// </summary>
    [TestClass]
    public class TwitterTests
    {
        private ISiteList _siteList;
        private string _sitename = "h2g2";
        private int _siteid = 1;
        private readonly string _server = DnaTestURLRequest.CurrentServer;
        private FullInputContext _context;
        private CommentForum _commentForumReactive;
        private string _tweetPostUrlReactive;

        private CommentForum _commentForumPremod;
        private string _tweetPostUrlPremod;

        public TwitterTests()
        {
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            _context = new FullInputContext("");

            _siteList = _context.SiteList;

            // Create a comment forums to post tweets to, and the corresponding URLs
            CommentsTests_V1 ct = new CommentsTests_V1();
            _commentForumReactive = ct.CommentForumCreate("Tests Reactive", Guid.NewGuid().ToString(),ModerationStatus.ForumStatus.Reactive);
            _tweetPostUrlReactive= String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/{0}/commentsforums/{1}/",_sitename, _commentForumReactive.Id);

            _commentForumPremod = ct.CommentForumCreate("Tests Premod", Guid.NewGuid().ToString(),ModerationStatus.ForumStatus.PreMod);
            _tweetPostUrlPremod = String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/{0}/commentsforums/{1}/", _sitename, _commentForumPremod.Id);
        }

        [TestMethod]
        public void CreateTweet_WithXmlData()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "Here's Johnny";
            var twitterUserId = "24870588";
            var screenName = "ccharlesworth";
            var tweetData = CreatTweetXmlData(text, twitterUserId, screenName);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "text/xml");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, text, twitterUserId, screenName);
        }



        [TestMethod]
        public void CreateTweet_WithJsonData()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "Go ahead punk";
            var twitterUserId = "1234567";
            var screenName = "furrygeezer";
            var tweetData = CreatTweetJsonData(text, twitterUserId, screenName);

            var dt = DateTime.Parse("1995-02-05 00:00");


            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "application/json");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, text, twitterUserId, screenName);
        }

        [TestMethod]
        public void CreateTweet_WithJsonData_BadSiteURL()
        {
            string badTweetPostUrl = String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/0/commentsforums/{0}/", _commentForumReactive.Id);
            var tweetData = CreatTweetJsonData("text", "1234", "Flea");

            var request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            try
            {
                request.RequestPageWithFullURL(badTweetPostUrl, tweetData, "application/json");
            }
            catch (WebException)
            {
                return;
            }
            Assert.Fail("Expecting a WebException to go off.  Shouldn't get this far");
        }

        [TestMethod]
        public void CreateTweet_TestApplyExpiryTime_ProcessPremodOff()
        {
            CreateTweet_TestApplyExpiryTime("This one goes to 11", "Off");
        }

        [TestMethod]
        public void CreateTweet_TestApplyExpiryTime_ProcessPremodOn()
        {
            CreateTweet_TestApplyExpiryTime("Whammy Kiss", "On");
        }

        [TestMethod]
        public void TwitterQueue_TestExipryCall_WithExpiredTweets()
        {
            ClearModerationQueues();

            CreateCommentsWithAlternateApplyExpiryTimes(20, 0);

            int i = 0;
            using (var reader = _context.CreateDnaDataReader(""))
            {
                // Process the expired posts
                reader.ExecuteDEBUGONLY("exec processexpiredpremodpostings");

                // Only 10 rows should have expired, and the ModIds should match between 
                // tables ThreadModExpired and PremodPostingsExpired
                reader.ExecuteDEBUGONLY(@"select * from ThreadModExpired tme
                                            join PremodPostingsExpired ppe on ppe.modid=tme.modid");
                for (i = 0; reader.Read(); i++)
                {
                    // Extract the number from the Body text, and check that it's even.
                    // Only evenly numbered posts should have expired
                    var postNum = int.Parse(reader.GetString("Body"));
                    Assert.IsTrue((postNum % 2) == 0);
                    Assert.IsTrue(reader.GetBoolean("ApplyExpiryTime"));
                }
                Assert.AreEqual(10, i);

                // There should be no rows that exist in ThreadModExpired AND ThreadMod
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModExpired tme
                                            join ThreadMod tm on tm.modid=tme.modid");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(0, reader.GetInt32("c"));

                // There should only be 10 rows left in the PremodPostings table
                reader.ExecuteDEBUGONLY(@"select count(*) c from PremodPostings where ApplyExpiryTime=0");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(10, reader.GetInt32("c"));
            }
        }

        [TestMethod]
        public void TwitterQueue_TestExipryCall_WithNoExpiredComments()
        {
            ClearModerationQueues();

            // Set the expiry time to 10 minutes.  This will mean that no posts will expire
            // at the time processexpiredpremodpostings is called
            CreateCommentsWithAlternateApplyExpiryTimes(20, 10);

            int i = 0;
            using (var reader = _context.CreateDnaDataReader(""))
            {
                // Process the expired posts
                reader.ExecuteDEBUGONLY("exec processexpiredpremodpostings");

                // We're expecting that no items have expired, so sanity check the tables...

                // Get the last 20 threadmod entries.  They should match up with 20 PremodPosting entries
                reader.ExecuteDEBUGONLY(@"select top 20 * from ThreadMod tm 
                                            join PremodPostings pp on pp.modid=tm.modid
                                            order by pp.modid desc");
                for (i = 19; reader.Read(); i--)
                {
                    // Extract the number from the end of the Body text, and check that it's even.
                    // Only evenly numbered posts should have expired
                    var postNum = int.Parse(reader.GetString("Body"));
                    Assert.AreEqual(i, postNum);
                    Assert.IsTrue(reader.GetBoolean("ApplyExpiryTime") == ((postNum % 2) == 0));
                }
                Assert.AreEqual(-1, i);

                // There should be no rows in ThreadModExpired
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModExpired");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(0, reader.GetInt32("c"));

                // There should be no rows in PremodPostingsExpired
                reader.ExecuteDEBUGONLY(@"select count(*) c from PremodPostingsExpired");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(0, reader.GetInt32("c"));
            }
        }

        [TestMethod]
        public void TwitterQueue_TestExipryCall_ExpireOnlyNewUnlockedPosts()
        {
            ClearModerationQueues();

            CreateCommentsWithAlternateApplyExpiryTimes(20, 0);

            int i = 0;
            using (var reader = _context.CreateDnaDataReader(""))
            {
                // Lock the first 5 rows to a moderator
                reader.ExecuteDEBUGONLY("exec getmoderationposts @userid =6, @issuperuser = 1, @show = 5");

                // Process the expired posts
                reader.ExecuteDEBUGONLY("exec processexpiredpremodpostings");

                // Get the last 20 threadmod entries.  They should match up with the PremodPosting entries
                reader.ExecuteDEBUGONLY(@"select top 20 * from ThreadMod tm 
                                            join PremodPostings pp on pp.modid=tm.modid
                                            order by pp.modid desc");

                // Only expecting 13, because 7 should have expired out of the remaining 15 unlocked rows
                for (i = 13; reader.Read(); i--)
                {
                    var applyExpiryTime = reader.GetBoolean("ApplyExpiryTime");
                    int? lockedBy = reader.GetNullableInt32("LockedBy");
                    var status = reader.GetNullableInt32("Status");

                    // Rows that have the ApplyExpiryTime set should have a value for LockedBy 
                    // and the status=0.  I.e. these rows did not get expired because they've been locked by 
                    // a moderator
                    if (applyExpiryTime)
                    {
                        Assert.IsTrue(lockedBy.HasValue);
                        Assert.AreEqual(0, status);
                    }
                }
                Assert.AreEqual(0, i);

                // There should be 7 rows in ThreadModExpired and PremodPostingsExpired
                // And they should have matching mod IDs
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModExpired tme
                                            join PremodPostingsExpired ppe on ppe.modid=tme.modid");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(7, reader.GetInt32("c"));
            }
        }

        [TestMethod]
        public void CreateTweet_WithXmlData_TestTwitterTranslation()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "This is a test post from @furrygeezer and @#srihari03 to search for #FactsWithoutWikipedia and ##WithoutWiki";
            var expectedText = "This is a test post from <a href=\"http://twitter.com/furrygeezer\" target=\"_blank\">@furrygeezer</a> and @<a href=\"http://search.twitter.com/search?q=%23srihari03\" target=\"_blank\">#srihari03</a> to search for " +
                                "<a href=\"http://search.twitter.com/search?q=%23FactsWithoutWikipedia\" target=\"_blank\">#FactsWithoutWikipedia</a> and #" +
                                "<a href=\"http://search.twitter.com/search?q=%23WithoutWiki\" target=\"_blank\">#WithoutWiki</a>";
            var twitterUserId = "24870599";
            var screenName = "ccharlesworth";
            var tweetData = CreatTweetXmlData(text, twitterUserId, screenName);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "text/xml");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            Assert.AreEqual(PostStyle.Style.tweet, returnedCommentInfo.PostStyle);
            Assert.AreEqual(expectedText, returnedCommentInfo.text);
        }

        private void ClearModerationQueues()
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("delete ThreadMod");
                reader.ExecuteDEBUGONLY("delete ThreadModExpired");
                reader.ExecuteDEBUGONLY("delete PremodPostings");
                reader.ExecuteDEBUGONLY("delete PremodPostingsExpired");
            }
        }

        private int CreateTwitterUser(string twitterUserId, string userName, int siteId, string displayName)
        {
            var sqlFormat = "exec createnewuserfromtwitteruserid @twitteruserid=N'{0}',@username=N'{1}',@siteid={2},@displayname=N'{3}'";
            var sql = string.Format(sqlFormat, twitterUserId, userName, siteId, displayName);
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(sql);
                Assert.IsTrue(reader.Read());
                return reader.GetInt32("UserId");
            }
        }
        
        private void CreateTweet_TestApplyExpiryTime(string text, string processPremodSetting)
        {
            // Set ProcessPreMod site option
            switch (processPremodSetting)
            {
                case "On": TestSite.SetSiteOption(_server, _sitename, "Moderation", "ProcessPreMod", 1, "1"); break;
                case "Off": TestSite.SetSiteOption(_server, _sitename, "Moderation", "ProcessPreMod", 1, "0"); break;
                default: Assert.Fail("Unknown processPremodSetting setting"); break;
            }

            PostTweet(text, "4864748", "meanmachine", ModerationStatus.ForumStatus.PreMod);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"
                        select top 1 pmp.ApplyExpiryTime,pmp.Body,pmp.userid,smt.TwitterUserId
                        from threadmod tm
                        join premodpostings pmp on pmp.modid=tm.modid
                        join dbo.SignInUserIDMapping smt on smt.dnauserid=pmp.userid
                        order by tm.modid desc");
                Assert.IsTrue(reader.Read());
                var applyExpiryTime = reader.GetBoolean("ApplyExpiryTime");
                var body = reader.GetString("Body");
                var twitterUserId2 = reader.GetString("TwitterUserId");

                // Test that applyExpiryTime flag is set and do a few other sanity checks
                Assert.IsTrue(applyExpiryTime);
                Assert.AreEqual(text, body);
                Assert.AreEqual("4864748", twitterUserId2);
            }
        }

        private void PostTweet(string text, string twitterUserId, string screenName, ModerationStatus.ForumStatus modStatus)
        {
            var request = new DnaTestURLRequest(_sitename);
            var tweetData = CreatTweetJsonData(text, twitterUserId, screenName);

            switch (modStatus)
            {
                case ModerationStatus.ForumStatus.PreMod: request.RequestPageWithFullURL(_tweetPostUrlPremod, tweetData, "application/json"); break;
                case ModerationStatus.ForumStatus.Reactive: request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "application/json"); break;
                default: Assert.Fail("Unknown modStatus setting"); break;
            }
        }

        private void CreateCommentsWithAlternateApplyExpiryTimes(int numComments, int expiryTime)
        {
            // Set up the site options
            TestSite.SetSiteOption(_server, _sitename, "Moderation", "ProcessPreMod", 1, "1");
            TestSite.SetSiteOption(_server, _sitename, "Moderation", "ExternalCommentQueuedExpiryTime", 0, expiryTime.ToString());

            using (var reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("truncate table PremodPostings");
                reader.ExecuteDEBUGONLY("truncate table ThreadModExpired");
                reader.ExecuteDEBUGONLY("truncate table PremodPostings");
            }

            var userId = CreateTwitterUser("9900001", "Da Geeza", _siteid, "furry");

            int i = 0;

            for (i = 0; i < numComments; i++)
            {
                CreateCommentInDb(_commentForumPremod.Id, userId, i.ToString(), (i % 2) == 0);
            }

            using (var reader = _context.CreateDnaDataReader(""))
            {
                // "numComments" rows must now be in the premodpostings table
                reader.ExecuteDEBUGONLY("select top 20 * from premodpostings order by modid desc");
                for (i = 0; reader.Read(); i++)
                {
                    Assert.AreEqual((i % 2) == 1, reader.GetBoolean("ApplyExpiryTime"));
                }
                Assert.AreEqual(numComments, i);
            }
        }

        private void CreateCommentInDb(string commentForumId, int userId, string text, bool expiry)
        {
            var sqlFormat = @"
                declare @hash uniqueidentifier
                set @hash = newid()

                exec commentcreate @commentforumid=N'{0}',
                    @userid={1},
                    @content=N'{2}',
                    @hash=@hash,
                    @forcemoderation=0,
                    @ignoremoderation=0,
                    @isnotable=0,
                    @applyprocesspremodexpirytime={3},
                    @ipaddress=NULL,
                    @bbcuid='00000000-0000-0000-0000-000000000000',
                    @poststyle=4";

            var sql = string.Format(sqlFormat, commentForumId, userId, text, expiry ? "1" : "0");
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(sql);
            }
        }

        private void TestCommentInfo(CommentInfo commentInfo, string text, string twitterUserId, string displayName)
        {
            Assert.AreEqual(text, commentInfo.text);
            Assert.AreEqual(PostStyle.Style.tweet, commentInfo.PostStyle);
            Assert.AreEqual(displayName, commentInfo.User.DisplayName);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from signinuseridmapping where TwitterUserID=" + twitterUserId);
                Assert.IsTrue(reader.HasRows);
                reader.Read();
                var dnaUserId = reader.GetInt32("DnaUserId");
                Assert.AreEqual(commentInfo.User.UserId, dnaUserId);
                Assert.IsFalse(reader.Read()); // Check we only got one row back
            }
        }

        private string CreatTweetXmlData(string text, string twitterUserId, string screenName)
        {
            // Use a Tweet object to generate the XML
            Tweet tweet = new Tweet()
            {
                id = 131341566890618880,
                createdStr = "Tue Nov 01 12:07:24 +0000 2011",
                Text = text,
                user = new TweetUser()
                {
                    Name = "Chico Charlesworth",
                    ScreenName = screenName,
                    ProfileImageUrl = @"http://a1.twimg.com/profile_images/99627155/me_normal.jpg",
                    id = twitterUserId
                }
            };

            var tweetXml = new XmlDocument();
            tweetXml.Load(StringUtils.SerializeToXml(tweet));
            var tweetData = tweetXml.DocumentElement.OuterXml;
            return tweetData;
        }

        private string CreatTweetJsonData(string text, string twitterUserId, string screenName)
        {
            // Use an actual tweet from Twitter as the source data
            string s = @"{""id_str"":""131341566890618880"",
                ""place"":null,
                ""geo"":{""coordinates"":[28.736,-25.7373],""type"":""Point""},
                ""in_reply_to_user_id_str"":null,
                ""coordinates"":null,
                ""contributors"":null,
                ""possibly_sensitive"":false,
                ""created_at"":""Tue Nov 01 12:07:24 +0000 2011"",
                ""user"":{""id_str"":""" + twitterUserId+@""",
                    ""profile_text_color"":""333333"",
                    ""protected"":false,
                    ""profile_image_url_https"":""https:\/\/si0.twimg.com\/profile_images\/99627155\/me_normal.jpg"",
                    ""profile_background_image_url"":""http:\/\/a0.twimg.com\/images\/themes\/theme1\/bg.png"",
                    ""followers_count"":250,
                    ""profile_image_url"":""http:\/\/a1.twimg.com\/profile_images\/99627155\/me_normal.jpg"",
                    ""name"":""Chico Charlesworth"",
                    ""listed_count"":11,
                    ""contributors_enabled"":false,
                    ""profile_link_color"":""0084B4"",
                    ""show_all_inline_media"":true,
                    ""utc_offset"":0,
                    ""created_at"":""Tue Mar 17 11:52:29 +0000 2009"",
                    ""description"":""Techie\/Startupreneur"",
                    ""default_profile"":true,
                    ""following"":true,
                    ""profile_background_color"":""C0DEED"",
                    ""verified"":false,
                    ""notifications"":false,
                    ""profile_background_tile"":false,
                    ""default_profile_image"":false,
                    ""profile_sidebar_fill_color"":""DDEEF6"",
                    ""time_zone"":""London"",
                    ""profile_background_image_url_https"":""https:\/\/si0.twimg.com\/images\/themes\/theme1\/bg.png"",
                    ""favourites_count"":8,
                    ""profile_sidebar_border_color"":""C0DEED"",
                    ""location"":""London"",
                    ""screen_name"":"""+screenName+@""",
                    ""follow_request_sent"":false,
                    ""statuses_count"":586,
                    ""geo_enabled"":true,
                    ""friends_count"":480,
                    ""id"":"+twitterUserId+@",
                    ""is_translator"":false,
                    ""lang"":""en"",
                    ""profile_use_background_image"":true,
                    ""url"":""http:\/\/99layers.com\/chico""},
                ""retweet_count"":0,
                ""in_reply_to_status_id"":null,
                ""favorited"":false,
                ""in_reply_to_screen_name"":null,
                ""truncated"":false,
                ""source"":""\u003Ca href=\""http:\/\/www.tweetdeck.com\"" rel=\""nofollow\""\u003ETweetDeck\u003C\/a\u003E"",
                ""retweeted"":false,
                ""id"":131341566890618880,
                ""in_reply_to_status_id_str"":null,
                ""in_reply_to_user_id"":null,
                ""text"":""" +text+@"""}";

            return s;
        }

        void SetSiteModStatus(string siteUrl, string modStatus)
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                int premoderation = 0, unmoderated = 0;
                switch (modStatus.ToLower())
                {
                    case "unmoderated": premoderation = 0; unmoderated = 1; break;
                    case "postmoderated": premoderation = 0; unmoderated = 0; break;
                    case "premoderated": premoderation = 1; unmoderated = 0; break;
                    default: Assert.Fail("Unknown moderation status"); break;
                }

                string sql = string.Format(
                    @"UPDATE Sites SET premoderation={1}, unmoderated={2} 
                        WHERE siteid=(SELECT SiteId FROM Sites WHERE urlname='{0}')"
                    , siteUrl, premoderation, unmoderated);
                reader.ExecuteDEBUGONLY(sql);
            }
        }
    }
}
