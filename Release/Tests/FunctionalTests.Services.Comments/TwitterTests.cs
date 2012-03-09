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
using BBC.Dna.SocialAPI;
using BBC.Dna.Moderation;

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

            var tweet = CreateTestTweet(1986455438846,"Here's Johnny","24870588","Chico Charlesworth", "ccharlesworth");
            var tweetData = CreatTweetXmlData(tweet);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "text/xml");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, tweet);
        }



        [TestMethod]
        public void CreateTweet_WithJsonData()
        {
            var request = new DnaTestURLRequest(_sitename);

            var tweet = CreateTestTweet(1099511627775,"Go ahead punk","1234567","Mr Furry Geezer", "furrygeezer");
            var tweetData = CreateTweetJsonData(tweet);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "application/json");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, tweet);
        }

        [TestMethod]
        public void CreateTweet_SameUserMultipleTweets()
        {
            var tweet = CreateTestTweet(1099511627775, "The Hell Of It All", "9876543", "Mr Furry Geezer", "furrygeezer");
            CreateTweet_SameUserMultipleTweets_Helper(tweet);

            tweet = CreateTestTweet(1099511627776, "Scar Tissue", "9876543", "Mr Furry Geezer", "furrygeezer");
            CreateTweet_SameUserMultipleTweets_Helper(tweet);
        }

        private void CreateTweet_SameUserMultipleTweets_Helper(Tweet tweet)
        {
            var request = new DnaTestURLRequest(_sitename);

            var tweetData = CreateTweetJsonData(tweet);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "application/json");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            TestCommentInfo(returnedCommentInfo, tweet);
        }

        [TestMethod]
        public void CreateTweet_WithJsonData_BadSiteURL()
        {
            string badTweetPostUrl = String.Format("http://" + _server + "/dna/api/comments/TwitterService.svc/V1/site/0/commentsforums/{0}/", _commentForumReactive.Id);
            var tweet = CreateTestTweet(9583548405684, "text", "1234", "Mr Flea - Bass maestro", "Flea");
            var tweetData = CreateTweetJsonData(tweet);

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
                // tables ThreadModDeleted and PremodPostingsDeleted
                // Also the reason code should be 'E' for 'Expired'
                reader.ExecuteDEBUGONLY(@"select * from ThreadModDeleted tmd
                                            join PremodPostingsDeleted ppd on ppd.modid=tmd.modid
                                            where ppd.Reason='E' and tmd.Reason='E'");
                for (i = 0; reader.Read(); i++)
                {
                    // Extract the number from the Body text, and check that it's even.
                    // Only evenly numbered posts should have expired
                    var postNum = int.Parse(reader.GetString("Body"));
                    Assert.IsTrue((postNum % 2) == 0);
                    Assert.IsTrue(reader.GetBoolean("ApplyExpiryTime"));
                }
                Assert.AreEqual(10, i);

                // There should be no rows that exist in ThreadModDeleted AND ThreadMod
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModDeleted tmd
                                            join ThreadMod tm on tm.modid=tmd.modid");
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

                // There should be no rows in ThreadModDeleted
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModDeleted");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(0, reader.GetInt32("c"));

                // There should be no rows in PremodPostingsDeleted
                reader.ExecuteDEBUGONLY(@"select count(*) c from PremodPostingsDeleted");
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

                // There should be 7 rows in ThreadModDeleted and PremodPostingsDeleted
                // And they should have matching mod IDs
                reader.ExecuteDEBUGONLY(@"select count(*) c from ThreadModDeleted tmd
                                            join PremodPostingsDeleted ppd on ppd.modid=tmd.modid");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(7, reader.GetInt32("c"));
            }
        }

        [TestMethod]
        public void CreateTweet_PreModPostingAndModerate()
        {
            TestSite.SetSiteOption(_server, _sitename, "Moderation", "ProcessPreMod", 1, "1");

            var text = "Notes from a big country";
            var tweetId = 64645735745376;
            var tweet = CreateTestTweet(tweetId, text, "76767676", "Bill Bryson", "Bryson");
            PostTweet(tweet, ModerationStatus.ForumStatus.PreMod);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"
                        select top 1 pmp.modid,
                                     pmp.forumid,
                                     pmp.threadid,
                                     pmpti.tweetid
                        from premodpostings pmp
                        join premodpostingstweetinfo pmpti on pmpti.modid=pmp.modid
                        order by pmp.modid desc");
                Assert.IsTrue(reader.Read());
                var modId = reader.GetInt32("modId");
                var forumId = reader.GetInt32("forumid");
                var threadId = reader.GetInt32NullAsZero("threadid");
                Assert.AreEqual(tweetId, reader.GetInt64("TweetId"));

                PassPreModPosting(modId, forumId, threadId);

                //var sql = string.Format("exec moderatepost @forumid={0},@threadid={1},@postid=0,@modid={2},@status=3,@notes=N' ',@referto=0,@referredby=6,@moderationstatus=0,@emailType=N'or Select failure reason'",
                       //forumId, threadId, modId);
                //reader.ExecuteDEBUGONLY(sql);

                reader.ExecuteDEBUGONLY("select * from premodpostingstweetinfo where modid=" + modId);
                Assert.IsFalse(reader.Read());

                reader.ExecuteDEBUGONLY(@"
                    select top 1 te.text,
                                 teti.tweetid
                    from threadentries te
                    join threadentriestweetinfo teti on teti.threadentryid = te.entryid
                    order by entryid desc");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(text, reader.GetString("text"));
                Assert.AreEqual(tweetId, reader.GetInt64("TweetId"));
            }
        }

        private void PassPreModPosting(int modId, int forumId, int? threadId)
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                var sql = string.Format("exec moderatepost @forumid={0},@threadid={1},@postid=0,@modid={2},@status=3,@notes=N' ',@referto=0,@referredby=6,@moderationstatus=0,@emailType=N'or Select failure reason'",
                    forumId, threadId.HasValue ? threadId.ToString() : "NULL" , modId);
                    reader.ExecuteDEBUGONLY(sql);
            }
        }


        [TestMethod]
        public void CreateTweet_Retweet_NoMatchingTweet()
        {
            var maxThreadEntryId = GetMaxThreadEntryId();

            var tweet = CreateTestTweet(9898534343444222, "Inspire", "3434343", "Creative Labs Inc", "crinc","4");
            tweet.RetweetedStatus = CreateTestTweet(74853549057838, "retweeted text", "909090909", "Big bird", "bigbird", "90");

            var response = PostTweet(tweet, ModerationStatus.ForumStatus.Reactive);
            Assert.AreEqual("\"Retweet ignored\"", response);

            // If the max thread entry id hasn't changed, this is proof that no posting happened
            Assert.AreEqual(maxThreadEntryId, GetMaxThreadEntryId());
        }

        [TestMethod]
        public void CreateTweet_Retweet_MatchingTweet()
        {
            // Post the original tweet
            long tweetId = 9898534343444222;
            var tweet = CreateTestTweet(tweetId, "SQLBits 2012 is a dreams", "3434343", "Itzik Ben Gan", "tsqlgod", "4");
            PostTweet(tweet, ModerationStatus.ForumStatus.Reactive);

            // Create a retweet of the original tweet and post it
            var retweet = CreateTestTweet(74853549057838, "RT @tsqlgod: SQLBits 2012 is a dreams", "909090909", "Danger Mouse", "dmouse", "4");
            retweet.RetweetedStatus = tweet;

            var maxThreadEntryId = GetMaxThreadEntryId();
            var response = PostTweet(retweet, ModerationStatus.ForumStatus.Reactive);
            Assert.AreEqual("\"Retweet handled\"", response);

            // If the max thread entry id hasn't changed, this is proof that no posting happened
            Assert.AreEqual(maxThreadEntryId, GetMaxThreadEntryId());

            // Check that the last post has a rating and that it's the correct value
            var rating = GetTweetRating(maxThreadEntryId);
            Assert.AreEqual(0, rating.userId);
            Assert.AreEqual(DnaHasher.GenerateHash(tweetId.ToString()), rating.userHash);
            Assert.AreEqual(4, rating.value);

            // Create another retweet with a different retweet count, and post it
            tweet.RetweetCountString = "56";
            retweet = CreateTestTweet(122435565688909, "RT @tsqlgod: SQLBits 2012 is a dreams", "2626262626", "Penfold", "pfold", "56");
            retweet.RetweetedStatus = tweet;

            response = PostTweet(retweet, ModerationStatus.ForumStatus.Reactive);
            Assert.AreEqual("\"Retweet handled\"", response);

            // Check that we still haven't created any more thread entries
            Assert.AreEqual(maxThreadEntryId, GetMaxThreadEntryId());

            // Check that the last post's rating contains the new retweet count
            rating = GetTweetRating(maxThreadEntryId);
            Assert.AreEqual(0, rating.userId);
            Assert.AreEqual(DnaHasher.GenerateHash(tweetId.ToString()), rating.userHash);
            Assert.AreEqual(56, rating.value);
        }

        [TestMethod]
        public void CreateTweet_Retweet_PreModTweetThenModerated()
        {
            // Post the original tweet, but make sure it's premoderated
            long tweetId = 56565656121212121;
            var tweet = CreateTestTweet(tweetId, "SQLBits 2012 is a dreams", "3434343", "Itzik Ben Gan", "tsqlgod", "4");
            PostTweet(tweet, ModerationStatus.ForumStatus.PreMod);

            // Create a retweet of the original tweet and post it
            var retweet = CreateTestTweet(74853549057838, "RT @tsqlgod: SQLBits 2012 is a dreams", "909090909", "Danger Mouse", "dmouse", "4");
            retweet.RetweetedStatus = tweet;

            var maxThreadEntryId = GetMaxThreadEntryId();
            var response = PostTweet(retweet, ModerationStatus.ForumStatus.PreMod);
            // This one will be ignored as the original tweet hasn't been moderated yet
            Assert.AreEqual("\"Retweet ignored\"", response);

            // Now pass moderation so that the tweet is created in the system
            var pmp = GetLatestPreModPosting();
            Assert.AreEqual(tweetId, GetPreModPostingsTweetId(pmp.modId));
            PassPreModPosting(pmp.modId, pmp.forumId, pmp.threadId);
            Assert.AreEqual(tweetId, GetThreadEntriesTweetId(GetMaxThreadEntryId()));

            // The act of passing moderation should have created a new thread entry
            maxThreadEntryId += 1;
            Assert.AreEqual(maxThreadEntryId, GetMaxThreadEntryId());

            // Create another retweet with a different retweet count, and post it
            tweet.RetweetCountString = "42";
            retweet = CreateTestTweet(122435565688909, "RT @tsqlgod: SQLBits 2012 is a dreams", "2626262626", "Penfold", "pfold", "42");
            retweet.RetweetedStatus = tweet;

            response = PostTweet(retweet, ModerationStatus.ForumStatus.PreMod);
            // This one is handled as the original tweet is now in the system
            Assert.AreEqual("\"Retweet handled\"", response);

            // Check that we haven't created any more thread entries
            Assert.AreEqual(maxThreadEntryId, GetMaxThreadEntryId());

            // Check that the last post's rating contains the new retweet count
            var rating = GetTweetRating(maxThreadEntryId);
            Assert.AreEqual(0, rating.userId);
            Assert.AreEqual(DnaHasher.GenerateHash(tweetId.ToString()), rating.userHash);
            Assert.AreEqual(42, rating.value);

        }

        private long GetPreModPostingsTweetId(int modId)
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"select * from PreModPostingsTweetInfo where modid=" + modId);
                reader.Read();
                return reader.GetInt64("TweetId");
            }
        }

        private long GetThreadEntriesTweetId(int entryId)
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"select * from ThreadEntriesTweetInfo where threadEntryId=" + entryId);
                reader.Read();
                return reader.GetInt64("TweetId");
            }
        }


        private int GetMaxThreadEntryId()
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"select top 1 EntryId from threadentries te order by te.entryid desc");
                reader.Read();
                return reader.GetInt32("EntryId");
            }
        }

        struct PreModPosting
        {
            public int modId;
            public int forumId;
            public int? threadId;
        }

        private PreModPosting GetLatestPreModPosting()
        {
            return GetPreModPosting(1);
        }


        private PreModPosting GetPreModPosting(int n)
        {
            var result = new PreModPosting();

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"
                    ;with numbered as 
                    (
                        select Top 100 *,ROW_NUMBER() OVER(ORDER BY ModID desc) n
                        from dbo.PreModPostings 
                        order by modid desc
	                )
	                select * from numbered
	                where n="+n);
                Assert.IsTrue(reader.Read());
                result.modId    = reader.GetInt32("modid");
                result.forumId  = reader.GetInt32("forumId");
                result.threadId = reader.GetNullableInt32("threadId");
            }

            return result;
        }


        struct ThreadEntryRating
        {
            public int entryId;
            public int userId;
            public Guid userHash;
            public short value;
            public int forumId;
            public int siteId;
        }
        
        private ThreadEntryRating GetTweetRating(int entryId)
        {
            var result = new ThreadEntryRating();

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from ThreadEntryRating where entryid=" + entryId);
                reader.Read();

                result.entryId = reader.GetInt32("entryId");
                result.userId = reader.GetInt32("userId");
                result.userHash = reader.GetGuid("userHash");
                result.value = reader.GetInt16("value");
                result.forumId = reader.GetInt32("forumId");
                result.siteId = reader.GetInt32("siteId");

                // Only expecting one row for this 
                Assert.IsFalse(reader.Read());
            }

            return result;
        }

        [TestMethod]
        public void CreateTweet_WithXmlData_TestTwitterTranslation()
        {
            var request = new DnaTestURLRequest(_sitename);

            var text = "This is a test post from @furrygeezer and @#srihari03 to search for #FactsWithoutWikipedia, ##WithoutWiki and for the link http://t.co/H3G9ZQGc and ftp://t.co/H3G9ZQGc";
            var expectedText = "This is a test post from <a href=\"http://twitter.com/furrygeezer\" target=\"_blank\">@furrygeezer</a> and @<a href=\"http://search.twitter.com/search?q=%23srihari03\" target=\"_blank\">#srihari03</a> to search for " +
                                "<a href=\"http://search.twitter.com/search?q=%23FactsWithoutWikipedia\" target=\"_blank\">#FactsWithoutWikipedia</a>, #" +
                                "<a href=\"http://search.twitter.com/search?q=%23WithoutWiki\" target=\"_blank\">#WithoutWiki</a> and for the link " +
                                "<a href=\"http://t.co/H3G9ZQGc\">http://t.co/H3G9ZQGc</a> and ftp://t.co/H3G9ZQGc";
            var twitterUserId = "24870599";
            var screenName = "ccharlesworth";
            var tweet = CreateTestTweet(876378637863786, text, twitterUserId, "Chico", screenName);
            var tweetData = CreatTweetXmlData(tweet);

            // now get the response
            request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "text/xml");

            // Check to make sure that the page returned with the correct information
            var returnedCommentInfo = (CommentInfo)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(CommentInfo));

            Assert.AreEqual(PostStyle.Style.tweet, returnedCommentInfo.PostStyle);
            Assert.AreEqual(expectedText, returnedCommentInfo.text);
        }

        [TestMethod]
        public void ArchiveFailedTweets_TweetArchived()
        {
            ClearModerationQueues();

            var paramList = new DnaTestURLRequest.ParamList();

            // Post three tweets, and collect the param list for the ModeratePost call later
            // It checked that only failed tweets get archived to the "Deleted" tables

            // This one will fail moderation
            PostTweet(CreateTestTweet(64645735745376, "I, Partridge", "76767676", "Alan Partridge", "Ahah!"), ModerationStatus.ForumStatus.PreMod);
            AddLatestPreModPostingToParamList(paramList, ModerationItemStatus.Failed, BBC.Dna.Api.PostStyle.Style.tweet);

            // This one will pass moderation
            PostTweet(CreateTestTweet(64645735745377, "chat suicide", "76767676", "Alan Partridge", "Ahah!"), ModerationStatus.ForumStatus.PreMod);
            AddLatestPreModPostingToParamList(paramList, ModerationItemStatus.Passed, BBC.Dna.Api.PostStyle.Style.tweet);

            // This one will fail moderation, but the post style is not a tweet
            PostTweet(CreateTestTweet(64645735745378, "dormant volcano", "76767676", "Alan Partridge", "Ahah!"), ModerationStatus.ForumStatus.PreMod);
            AddLatestPreModPostingToParamList(paramList, ModerationItemStatus.Failed, BBC.Dna.Api.PostStyle.Style.plaintext);
            
            // Moderate these posts
            var request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserEditor();
            request.RequestPageWithParamList("ModeratePosts", paramList);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {

                reader.ExecuteDEBUGONLY(@"
                    select * 
                        from PreModPostingsDeleted pmpd
                        join PreModPostingsTweetInfoDeleted pmptid on pmptid.modid=pmpd.modid
                        join ThreadModDeleted tmd on tmd.modid = pmptid.modid
                        where pmpd.reason='A' and pmptid.reason='A' and tmd.reason='A'");
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(64645735745376, reader.GetInt64("tweetid"));
                Assert.AreEqual("I, Partridge", reader.GetString("body"));
                Assert.IsFalse(reader.Read(),"Only expecting one row of archived deleted posts");

                // Check the last two posts are the other two moderated posts
                reader.ExecuteDEBUGONLY(@"
                    select top 2 * 
                        from ThreadEntries te
                        join ThreadEntriesTweetInfo teti on teti.ThreadEntryId=te.EntryId
                        order by te.entryid desc");

                Assert.IsTrue(reader.Read());
                Assert.AreEqual(64645735745378, reader.GetInt64("tweetid"));
                Assert.AreEqual("dormant volcano", reader.GetString("text"));
                Assert.AreEqual(1, reader.GetInt32("Hidden"),"This post failed moderation so should be hidden");

                Assert.IsTrue(reader.Read());
                Assert.AreEqual(64645735745377, reader.GetInt64("tweetid"));
                Assert.AreEqual("chat suicide", reader.GetString("text"));
                Assert.IsFalse(reader.GetNullableInt32("Hidden").HasValue, "The hidden flag should be NULL, i.e. not hidded");
            }
        }

        private void AddLatestPreModPostingToParamList(DnaTestURLRequest.ParamList paramList, ModerationItemStatus status, BBC.Dna.Api.PostStyle.Style postStyle)
        {
            paramList.Add("postid", 0);
            paramList.Add("alerts", 0);

            var pmp = GetLatestPreModPosting();
            paramList.Add("threadid", pmp.threadId.HasValue ? pmp.threadId.Value : 0);
            paramList.Add("modid", pmp.modId);
            paramList.Add("forumid", pmp.forumId);
            paramList.Add("siteid", _siteid);

            paramList.Add("decision", (int)status);
            paramList.Add("postStyle", (int)postStyle);
            paramList.Add("skin", "purexml");
        }

        private void ClearModerationQueues()
        {
            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("delete ThreadModHistory");

                reader.ExecuteDEBUGONLY("delete ThreadMod");
                reader.ExecuteDEBUGONLY("delete ThreadModDeleted");

                reader.ExecuteDEBUGONLY("delete PremodPostings");
                reader.ExecuteDEBUGONLY("delete PremodPostingsDeleted");

                reader.ExecuteDEBUGONLY("delete PremodPostingsTweetInfo");
                reader.ExecuteDEBUGONLY("delete PremodPostingsTweetInfoDeleted");
            }
        }

        private int CreateTwitterUser(string twitterUserId, string twitterScreenName, string twitterName, int siteId)
        {
            var sqlFormat = "exec createnewuserfromtwitteruserid @twitteruserid=N'{0}',@twitterscreenname=N'{1}',@twittername=N'{2}',@siteid={3}";
            var sql = string.Format(sqlFormat, twitterUserId, twitterScreenName, twitterName, siteId);
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

            var tweet = CreateTestTweet(84745253749329, text, "4864748", "Mean machine", "meanmachine");
            PostTweet(tweet, ModerationStatus.ForumStatus.PreMod);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(@"
                        select top 1 pmp.ApplyExpiryTime,
                                     pmp.Body,
                                     pmp.userid,
                                     smt.TwitterUserId,
                                     pmpti.tweetid
                        from threadmod tm
                        join premodpostings pmp on pmp.modid=tm.modid
                        join premodpostingstweetinfo pmpti on pmpti.modid=tm.modid
                        join dbo.SignInUserIDMapping smt on smt.dnauserid=pmp.userid
                        order by tm.modid desc");
                Assert.IsTrue(reader.Read());
                var applyExpiryTime = reader.GetBoolean("ApplyExpiryTime");
                var body = reader.GetString("Body");
                var twitterUserId2 = reader.GetString("TwitterUserId");
                var tweetId = reader.GetInt64("TweetId");

                // Test that applyExpiryTime flag is set and do a few other sanity checks
                Assert.IsTrue(applyExpiryTime);
                Assert.AreEqual(text, body);
                Assert.AreEqual("4864748", twitterUserId2);
                Assert.AreEqual(tweet.id, tweetId);
            }
        }

        private string PostTweet(Tweet tweet, ModerationStatus.ForumStatus modStatus)
        {
            var request = new DnaTestURLRequest(_sitename);
            var tweetData = CreateTweetJsonData(tweet);

            switch (modStatus)
            {
                case ModerationStatus.ForumStatus.PreMod: request.RequestPageWithFullURL(_tweetPostUrlPremod, tweetData, "application/json"); break;
                case ModerationStatus.ForumStatus.Reactive: request.RequestPageWithFullURL(_tweetPostUrlReactive, tweetData, "application/json"); break;
                default: Assert.Fail("Unknown modStatus setting"); break;
            }

            return request.GetLastResponseAsString();
        }

        private void CreateCommentsWithAlternateApplyExpiryTimes(int numComments, int expiryTime)
        {
            // Set up the site options
            TestSite.SetSiteOption(_server, _sitename, "Moderation", "ProcessPreMod", 1, "1");
            TestSite.SetSiteOption(_server, _sitename, "Moderation", "ExternalCommentQueuedExpiryTime", 0, expiryTime.ToString());

            using (var reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("truncate table PremodPostings");
                reader.ExecuteDEBUGONLY("truncate table ThreadModDeleted");
                reader.ExecuteDEBUGONLY("truncate table PremodPostings");
            }

            var userId = CreateTwitterUser("9900001", "furryfunster", "Mr Furry Funster",_siteid);

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

        private void TestCommentInfo(CommentInfo commentInfo, Tweet tweet)
        {
            Assert.AreEqual(tweet.Text, commentInfo.text);
            Assert.AreEqual(PostStyle.Style.tweet, commentInfo.PostStyle);
            Assert.AreEqual(tweet.user.Name, commentInfo.User.DisplayName);

            using (IDnaDataReader reader = _context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from signinuseridmapping where TwitterUserID=" + tweet.user.id);
                Assert.IsTrue(reader.HasRows);
                reader.Read();
                var dnaUserId = reader.GetInt32("DnaUserId");
                Assert.AreEqual(commentInfo.User.UserId, dnaUserId);
                Assert.IsFalse(reader.Read()); // Check we only got one row back

                reader.ExecuteDEBUGONLY("select * from ThreadEntriesTweetInfo where ThreadEntryId=" + commentInfo.ID);
                Assert.IsTrue(reader.HasRows);
                reader.Read();
                var tweetId = reader.GetInt64("TweetId");
                Assert.AreEqual(tweet.id, tweetId);
                Assert.IsFalse(reader.Read()); // Check we only got one row back
            }
        }

        private Tweet CreateTestTweet(long tweetId, string text, string twitterUserId, string name, string screenName)
        {
            return new Tweet()
            {
                id = tweetId,
                createdStr = "Tue Nov 01 12:07:24 +0000 2011",
                Text = text,
                user = new TweetUser()
                {
                    Name = name,
                    ScreenName = screenName,
                    ProfileImageUrl = @"http://a1.twimg.com/profile_images/99627155/me_normal.jpg",
                    id = twitterUserId
                }
            };
        }

        private Tweet CreateTestTweet(long tweetId, string text, string twitterUserId, string name, string screenName, string retweetCount)
        {
            var tweet = CreateTestTweet(tweetId, text, twitterUserId, name, screenName);
            tweet.RetweetCountString = retweetCount;
            return tweet;
        }


        private string CreatTweetXmlData(Tweet tweet)
        {
            var tweetXml = new XmlDocument();
            tweetXml.Load(StringUtils.SerializeToXml(tweet));
            var tweetData = tweetXml.DocumentElement.OuterXml;
            return tweetData;
        }

        private string CreateTweetJsonData(Tweet tweet)
        {
            if (tweet.RetweetedStatus != null)
                return CreateRetweetJsonData(tweet, tweet.RetweetedStatus);

            // Use an actual tweet from Twitter as the source data
            string s = @"{""id_str"":"""+tweet.id+@""",
                ""place"":null,
                ""geo"":{""coordinates"":[28.736,-25.7373],""type"":""Point""},
                ""in_reply_to_user_id_str"":null,
                ""coordinates"":null,
                ""contributors"":null,
                ""possibly_sensitive"":false,
                ""created_at"":""Tue Nov 01 12:07:24 +0000 2011"",
                ""user"":{""id_str"":""" + tweet.user.id+@""",
                    ""profile_text_color"":""333333"",
                    ""protected"":false,
                    ""profile_image_url_https"":""https:\/\/si0.twimg.com\/profile_images\/99627155\/me_normal.jpg"",
                    ""profile_background_image_url"":""http:\/\/a0.twimg.com\/images\/themes\/theme1\/bg.png"",
                    ""followers_count"":250,
                    ""profile_image_url"":""http:\/\/a1.twimg.com\/profile_images\/99627155\/me_normal.jpg"",
                    ""name"":"""+tweet.user.Name+@""",
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
                    ""screen_name"":"""+tweet.user.ScreenName+@""",
                    ""follow_request_sent"":false,
                    ""statuses_count"":586,
                    ""geo_enabled"":true,
                    ""friends_count"":480,
                    ""id"":"+tweet.user.id+@",
                    ""is_translator"":false,
                    ""lang"":""en"",
                    ""profile_use_background_image"":true,
                    ""url"":""http:\/\/99layers.com\/chico""},
                ""retweet_count"":"+tweet.RetweetCountString+@",
                ""in_reply_to_status_id"":null,
                ""favorited"":false,
                ""in_reply_to_screen_name"":null,
                ""truncated"":false,
                ""source"":""\u003Ca href=\""http:\/\/www.tweetdeck.com\"" rel=\""nofollow\""\u003ETweetDeck\u003C\/a\u003E"",
                ""retweeted"":false,
                ""id"":"+tweet.id+@",
                ""in_reply_to_status_id_str"":null,
                ""in_reply_to_user_id"":null,
                ""text"":""" +tweet.Text+@"""}";

            return s;
        }

        private string CreateRetweetJsonData(Tweet tweet, Tweet retweetedTweet)
        {
            string s = @"
            {
                ""retweeted_status"": {
                    ""text"": """+retweetedTweet.Text+@""",
                    ""retweeted"": false,
                    ""truncated"": false,
                    ""entities"": {
                        ""urls"": [],
                        ""hashtags"": [],
                        ""user_mentions"": []
                    },
                    ""id"": "+retweetedTweet.id+@",
                    ""source"": ""web"",
                    ""favorited"": false,
                    ""created_at"": ""Thu Jan 26 13:39:45 +0000 2012"",
                    ""retweet_count"": "+retweetedTweet.RetweetCountString+@",
                    ""id_str"": """+retweetedTweet.id+@""",
                    ""user"": {
                        ""location"": ""White House Press Room "",
                        ""default_profile"": false,
                        ""statuses_count"": 34054,
                        ""profile_background_tile"": false,
                        ""lang"": ""en"",
                        ""profile_link_color"": ""0084B4"",
                        ""id"": "+retweetedTweet.user.id+@",
                        ""favourites_count"": 1156,
                        ""protected"": false,
                        ""profile_text_color"": ""333333"",
                        ""description"": ""Independent White House journalist. Paul\u0027s bio: 5 yrs Moscow, 5 yrs network TV, 5 yrs Wall St.; foreign correspondent, private investor. 53 countries \u0026 counting"",
                        ""contributors_enabled"": false,
                        ""verified"": true,
                        ""name"": """+retweetedTweet.user.Name+@""",
                        ""profile_sidebar_border_color"": ""BDDCAD"",
                        ""profile_background_color"": ""9AE4E8"",
                        ""created_at"": ""Thu Feb 05 20:12:05 +0000 2009"",
                        ""default_profile_image"": false,
                        ""followers_count"": 98478,
                        ""geo_enabled"": false,
                        ""profile_image_url_https"": 
                        ""https://si0.twimg.com/profile_images/1467994261/WWR.Logo.Twitter_normal.png"",
                        ""profile_background_image_url"": 
                        ""http://a0.twimg.com/profile_background_images/117122710/presidents.jpg"",
                        ""profile_background_image_url_https"": 
                        ""https://si0.twimg.com/profile_background_images/117122710/presidents.jpg"",
                        ""utc_offset"": -18000,
                        ""time_zone"": ""Eastern Time (US \u0026 Canada)"",
                        ""profile_use_background_image"": true,
                        ""friends_count"": 625,
                        ""profile_sidebar_fill_color"": ""DDFFCC"",
                        ""screen_name"": """+retweetedTweet.user.ScreenName+@""",
                        ""id_str"": """+retweetedTweet.user.id+@""",
                        ""show_all_inline_media"": false,
                        ""profile_image_url"": 
                        ""http://a3.twimg.com/profile_images/1467994261/WWR.Logo.Twitter_normal.png"",
                        ""listed_count"": 4284,
                        ""is_translator"": false
                    }
                },
                ""text"": """+tweet.Text+@""",
                ""retweeted"": false,
                ""truncated"": true,
                ""entities"": {
                    ""urls"": [],
                    ""hashtags"": [],
                    ""user_mentions"": [
                        {
                         ""id"": 20182089,
                         ""name"": ""West Wing Report"",
                         ""indices"": [
                           3,
                           18
                         ],
                         ""screen_name"": ""WestWingReport"",
                         ""id_str"": ""20182089""
                        }
                    ]
                },
                ""id"": "+tweet.id+@",
                ""source"": ""web"",
                ""favorited"": false,
                ""created_at"": ""Thu Jan 26 14:00:35 +0000 2012"",
                ""retweet_count"": "+tweet.RetweetCountString+@",
                ""id_str"": """+tweet.id+@""",
                ""user"": {
                     ""location"": ""Chillicothe, Ohio 45601"",
                     ""default_profile"": false,
                     ""statuses_count"": 34784,
                     ""profile_background_tile"": true,
                     ""lang"": ""en"",
                     ""profile_link_color"": ""cb9934"",
                     ""id"": "+tweet.user.id+@",
                     ""favourites_count"": 68,
                     ""protected"": false,
                     ""profile_text_color"": ""575e61"",
                     ""description"": ""Citizens, educate yourself/others to EMPOWER communities. Harming working middle class does NOT empower people! STAND UP FOR MIDDLE CLASS \u0026 WORKING POOR!"",
                     ""contributors_enabled"": false,
                     ""verified"": false,
                     ""name"": """+tweet.user.Name+@""",
                     ""profile_sidebar_border_color"": ""454b52"",
                     ""profile_background_color"": ""181c1f"",
                     ""created_at"": ""Fri Feb 20 14:02:37 +0000 2009"",
                     ""default_profile_image"": false,
                     ""followers_count"": 1263,
                     ""geo_enabled"": true,
                     ""profile_image_url_https"": 
                    ""https://si0.twimg.com/profile_images/1462979161/March_12__2011_Chillicothe_Rally_normal.jpg"",
                     ""profile_background_image_url"": 
                    ""http://a2.twimg.com/profile_background_images/340364818/72_PIXELS-2nd_Portia_Rebuilding_the_American_Dream.jpg"",
                     ""profile_background_image_url_https"": 
                    ""https://si0.twimg.com/profile_background_images/340364818/72_PIXELS-2nd_Portia_Rebuilding_the_American_Dream.jpg"",
                     ""url"": ""https://www.facebook.com/?sk\u003dlf#!/portia.a.boulger"",
                     ""utc_offset"": -18000,
                     ""time_zone"": ""Eastern Time (US \u0026 Canada)"",
                     ""profile_use_background_image"": true,
                     ""friends_count"": 1956,
                     ""profile_sidebar_fill_color"": ""0e1621"",
                     ""screen_name"": """+tweet.user.ScreenName+@""",
                     ""id_str"": """+tweet.user.id+@""",
                     ""show_all_inline_media"": true,
                     ""profile_image_url"": 
                    ""http://a0.twimg.com/profile_images/1462979161/March_12__2011_Chillicothe_Rally_normal.jpg"",
                     ""listed_count"": 44,
                     ""is_translator"": false
                }
            }";
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
