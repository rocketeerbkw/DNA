using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using System.Linq;
using System.Runtime.Serialization;
using BBC.Dna.SocialAPI;

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class TwitterService : baseService
    {
        private readonly Comments _commentObj;

        public TwitterService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            _commentObj = new Comments(dnaDiagnostic, readerCreator, cacheManager, Global.siteList);
            _commentObj.ItemsPerPage = itemsPerPage;
            _commentObj.StartIndex = startIndex;
            _commentObj.SignOnType = signOnType;
            _commentObj.SortBy = sortBy;
            _commentObj.SortDirection = sortDirection;
            _commentObj.FilterBy = filterBy;
            _commentObj.SummaryLength = summaryLength;
            if (bbcUidCookie != Guid.Empty)
            {
                _commentObj.BbcUid = bbcUidCookie;
            }
            _commentObj.IpAddress = _iPAddress;
            _commentObj.BasePath = ConfigurationManager.AppSettings["ServerBasePath"];
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/commentsforums/{commentForumId}/")]
        [WebHelp(Comment = "Create a new tweet for the specified site/forum")]
        [OperationContract]
        public Stream CreateTweet(string sitename, string commentForumId, Tweet tweet)
        {
            // Retweets starting with @ are not supported for now
            if (tweet.Text != null && tweet.Text.Trim().StartsWith("@"))
            {
                return GetOutputStream(new CommentInfo()); //empty commentinfo object
            }

            ISite site = GetSite(sitename);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                CommentForum commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site);
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }

                _commentObj.CallingUser = GetCallingTwitterUser(site, tweet);

                if (tweet.IsRetweet)
                    return HandleRetweet(site, commentForumData, tweet);
                else
                    return HandleTweet(site, commentForumData, tweet);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

        }

        /// <summary>
        /// Method that choses the way the retweet needs to be handled
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <param name="commentObj"></param>
        /// <returns></returns>
        private Stream HandleRetweet(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            if (false == string.IsNullOrEmpty(tweet.Text))
            {
                var callingOriginalTweetuser = GetCallingTwitterUser(site, tweet.RetweetedStatus);

                if (callingOriginalTweetuser.IsTrustedUser())
                {
                    return HandleRetweetOriginalTweetByTrustedUsers(site, commentForumData, tweet);
                }
                else
                {
                    return HandleRetweetOriginalTweetByPublicUsers(site, commentForumData, tweet);
                }
            }
            else
            {
                throw ApiException.GetError(ErrorType.EmptyText);
            }
        }

        /// <summary>
        /// Just increments the rating value and ignores the retweet
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <returns></returns>
        private Stream HandleRetweetOriginalTweetByPublicUsers(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            //Capture the retweet info in the thread entry table
            CommentInfo retweetCommentInfo = CreateCommentFromTweet(site, commentForumData, tweet);

            var commentId = _commentObj.GetCommentIdFromTweetId(tweet.RetweetedStatus.id);

            if (commentId > 0) //increment the comment rating value and capture the retweet info
            {
                IncrementCommentRating(site, commentForumData, tweet, commentId);

                if (retweetCommentInfo.IsPreModPosting)
                {
                    _commentObj.CreateRetweetInfoForPreModPostings(retweetCommentInfo.PreModPostingsModId, tweet.id, tweet.RetweetedStatus.id, false);
                }
                else
                {
                    _commentObj.CreateRetweetInfoForComment(retweetCommentInfo.ID, tweet.id, tweet.RetweetedStatus.id, false);
                }

                return GetOutputStream(retweetCommentInfo);
            }
            else // capture the retweet info only as the original tweet doesn't exist
            {
                if (retweetCommentInfo.IsPreModPosting)
                {
                    _commentObj.CreateRetweetInfoForPreModPostings(retweetCommentInfo.PreModPostingsModId, tweet.id, tweet.RetweetedStatus.id, true);
                }
                else
                {
                    _commentObj.CreateRetweetInfoForComment(retweetCommentInfo.ID, tweet.id, tweet.RetweetedStatus.id, true);
                }

                return GetOutputStream(retweetCommentInfo);
            }
        }

        /// <summary>
        /// Adds an entry to the threadmod table and increments the comment rating value
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <returns></returns>
        private Stream HandleRetweetOriginalTweetByTrustedUsers(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            //Add an entry in the ThreadEntry table
            CommentInfo retweetCommentInfo = CreateCommentFromTweet(site, commentForumData, tweet);
            
            var commentId = _commentObj.GetCommentIdFromTweetId(tweet.RetweetedStatus.id);

            if (commentId < 1) //create the original tweet as it doesn't exist in the system and increment the rating value
            {
                CommentInfo originalTweetInfo = CreateCommentFromTweet(site, commentForumData, tweet.RetweetedStatus);

                IncrementCommentRating(site, commentForumData, tweet, originalTweetInfo.ID);
            }
            else //just increment the comment rating value
            {
                IncrementCommentRating(site, commentForumData, tweet, commentId);
            }

            if (retweetCommentInfo.IsPreModPosting)
            {
                _commentObj.CreateRetweetInfoForPreModPostings(retweetCommentInfo.PreModPostingsModId, tweet.id, tweet.RetweetedStatus.id, false);
            }
            else
            {
                _commentObj.CreateRetweetInfoForComment(retweetCommentInfo.ID, tweet.id, tweet.RetweetedStatus.id, false);
            }

            return GetOutputStream(retweetCommentInfo);
        }

        /// <summary>
        /// Increment the original tweet's rating value
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <param name="commentId"></param>
        /// <returns></returns>
        private int IncrementCommentRating(ISite site, CommentForum commentForumData, Tweet tweet, int commentId)
        {
            Guid userHash = DnaHasher.GenerateHash(tweet.RetweetedStatus.id.ToString());
            short ratingValue = tweet.RetweetedStatus.RetweetCount();
            return _commentObj.CreateCommentRating(commentForumData, site, commentId, 0, ratingValue, userHash);
            
        }

        /// <summary>
        /// Create the thread entry and capture the tweet info
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <returns></returns>
        private Stream HandleTweet(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            return GetOutputStream(CreateCommentFromTweet(site, commentForumData, tweet));
        }

        /// <summary>
        /// Creates the tweet and the relevant tweet info
        /// </summary>
        /// <param name="site"></param>
        /// <param name="commentForumData"></param>
        /// <param name="tweet"></param>
        /// <returns></returns>
        private CommentInfo CreateCommentFromTweet(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            _commentObj.CallingUser = GetCallingTwitterUser(site, tweet);

            CommentInfo commentInfo = _commentObj.CreateComment(commentForumData, tweet.CreateCommentInfo());

            if (commentInfo.IsPreModPosting)
                _commentObj.CreateTweetInfoForPreModPostings(commentInfo.PreModPostingsModId, tweet.id, 0, false);
            else
                _commentObj.CreateTweetInfoForComment(commentInfo.ID, tweet.id, 0, false);


            return commentInfo;
        }

        /// <summary>
        /// Creates a twitter user and returns the twitter user details
        /// </summary>
        /// <param name="site"></param>
        /// <param name="tweet"></param>
        /// <returns></returns>
        private CallingTwitterUser GetCallingTwitterUser(ISite site, Tweet tweet)
        {
            var callingTwitterUser = new CallingTwitterUser(readerCreator, dnaDiagnostic, cacheManager);

            callingTwitterUser.CreateUserFromTwitterUser(site.SiteID, tweet.user);
            callingTwitterUser.SynchroniseSiteSuffix(tweet.user.ProfileImageUrl);

            return callingTwitterUser;
        }
     }
}
