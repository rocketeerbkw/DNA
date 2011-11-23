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
            CommentInfo commentInfo;
            try
            {
                CommentForum commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site);
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }

                var callingUser = new CallingTwitterUser(readerCreator, dnaDiagnostic, cacheManager);

                callingUser.CreateUserFromTwitterUser(site.SiteID, tweet.user.id.ToString(), tweet.user.Name, tweet.user.ScreenName);
                callingUser.SynchroniseSiteSuffix(tweet.user.ProfileImageUrl);

                _commentObj.CallingUser = callingUser;

                commentInfo = _commentObj.CreateComment(commentForumData, tweet.CreateCommentInfo());
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentInfo);
        }
     }
}
