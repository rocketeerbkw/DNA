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

        private Stream HandleRetweet(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            var commentId = _commentObj.GetCommentIdFromTweetId(tweet.RetweetedStatus.id);
            if (commentId > 0)
            {
                Guid userHash = DnaHasher.GenerateHash(tweet.RetweetedStatus.id.ToString());
                short ratingValue = tweet.RetweetedStatus.RetweetCount();
                var newValue = _commentObj.CreateCommentRating(commentForumData, site, commentId, 0, ratingValue, userHash);
                return GetOutputStream("Retweet handled");
            }

            return GetOutputStream("Retweet ignored");
        }

        private Stream HandleTweet(ISite site, CommentForum commentForumData, Tweet tweet)
        {
            var callingUser = new CallingTwitterUser(readerCreator, dnaDiagnostic, cacheManager);

            callingUser.CreateUserFromTwitterUser(site.SiteID, tweet.user);
            callingUser.SynchroniseSiteSuffix(tweet.user.ProfileImageUrl);

            _commentObj.CallingUser = callingUser;

            CommentInfo commentInfo = _commentObj.CreateComment(commentForumData, tweet.CreateCommentInfo());

            // If the comment has a ModId, this means that it's
            if (commentInfo.IsPreModPosting)
                _commentObj.CreateTweetInfoForPreModPostings(commentInfo.PreModPostingsModId, tweet.id);
            else
                _commentObj.CreateTweetInfoForComment(commentInfo.ID, tweet.id);

            return GetOutputStream(commentInfo);
        }
     }
}
