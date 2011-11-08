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
        private readonly string _server = DnaTestURLRequest.CurrentServer;
        private FullInputContext _context;
        private CommentForum _commentForum;
        private string _tweetPostUrl;

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

            // Create a comment forum to post tweets to
            CommentsTests_V1 ct = new CommentsTests_V1();
            _commentForum = ct.CommentForumCreate("Tests", Guid.NewGuid().ToString());

            // Create the URL to post to that forum
            _tweetPostUrl= String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/{0}/commentsforums/{1}/",_sitename, _commentForum.Id);
        }

        [TestMethod]
        public void CreateTweet_WithXmlData()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "Here's Johnny";
            var twitterUserId = 24870588;
            var screenName = "ccharlesworth";
            var tweetData = CreatTweetXmlData(text, twitterUserId, screenName);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrl, tweetData, "text/xml");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, text, twitterUserId, screenName);
        }

        [TestMethod]
        public void CreateTweet_WithJsonData()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "Go ahead punk";
            var twitterUserId = 1234567;
            var screenName = "furrygeezer";
            var tweetData = CreatTweetJsonData(text, twitterUserId, screenName);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrl, tweetData, "application/json");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, text, twitterUserId, screenName);
        }

        [TestMethod]
        public void CreateTweet_WithJsonData_BadSiteURL()
        {
            string badTweetPostUrl = String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/0/commentsforums/{0}/", _commentForum.Id);
            var tweetData = CreatTweetJsonData("text", 1234, "Flea");

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
            Assert.Fail("Expecting a WebException to go off.  Shouldn't have got this far");
        }

        private void TestCommentInfo(CommentInfo commentInfo, string text, int twitterUserId, string displayName)
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

        private string CreatTweetXmlData(string text, int twitterUserId, string screenName)
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

        private string CreatTweetJsonData(string text, int twitterUserId, string screenName)
        {
            // Use an actual tweet from Twitter as the source data
            string s = @"{""id_str"":""131341566890618880"",
                ""place"":null,
                ""geo"":null,
                ""in_reply_to_user_id_str"":null,
                ""coordinates"":null,
                ""contributors"":null,
                ""possibly_sensitive"":false,
                ""created_at"":""Tue Nov 01 12:07:24 +0000 2011"",
                ""user"":{""id_str"":"""+twitterUserId+@""",
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
    }
}
