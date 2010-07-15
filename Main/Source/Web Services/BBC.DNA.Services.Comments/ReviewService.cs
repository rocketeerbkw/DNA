using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Syndication;
using System.ServiceModel.Web;
using System.Text;
using System.Xml;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using System.Linq;


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ReviewService : baseService
    {
        private Reviews _ratingObj=null;
        public ReviewService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            _ratingObj = new Reviews(dnaDiagnostic, readerCreator, cacheManager, Global.siteList);
            _ratingObj.ItemsPerPage = itemsPerPage;
            _ratingObj.StartIndex = startIndex;
            _ratingObj.SignOnType = signOnType;
            _ratingObj.SortBy = sortBy;
            _ratingObj.SortDirection = sortDirection;
            _ratingObj.FilterBy = filterBy;
            _ratingObj.SummaryLength = summaryLength;
            if (bbcUidCookie != Guid.Empty)
            {
                _ratingObj.BbcUid = bbcUidCookie;
            }
            _ratingObj.IpAddress = _iPAddress;
            _ratingObj.BasePath = ConfigurationManager.AppSettings["ServerBasePath"];

        }
        [WebGet(UriTemplate = "V1/site/{siteName}/reviews/{reviewid}")]
        [WebHelp(Comment = "Get the requested review from the Review/Comment ID")]
        [OperationContract]
        public Stream GetComment(string siteName, string reviewid)
        {
            RatingInfo rating = null;
            ISite site = GetSite(siteName);
            Stream output = null;
            try
            {
                rating = _ratingObj.RatingReadByPostID(reviewid, site);

                //if null then send back 404
                if (rating == null)
                {
                    throw ApiException.GetError(ErrorType.CommentNotFound);
                }
                else
                {
                    output = GetOutputStream(rating);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/reviewforum/{reviewForumId}/user/{identityuserid}/")]
        [WebHelp(Comment = "Get the review created by a user")]
        [OperationContract]
        public Stream GetUserReview(string reviewForumId, string siteName, string identityuserid)
        {
            RatingInfo rating = null;
            try
            {
                /* Do we need to validate the identity userid now??
                 * string identityid = String.Empty;
                
                 * if (!Int32.TryParse(userId, out identityid))
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }
                 */

                ISite site = GetSite(siteName);
                rating = _ratingObj.RatingsReadByIdentityID(reviewForumId, site, identityuserid);
                if (rating == null)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumUnknown));
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(rating, DateTime.MinValue);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/reviewforum/{reviewForumId}/")]
        [WebHelp(Comment = "Get the review forum by ID")]
        [OperationContract]
        public Stream GetReviewForum(string reviewForumId, string siteName)
        {
            RatingForum RatingForumData = null;
            Stream output = null;
            if (_ratingObj.FilterBy == FilterBy.EditorPicks)
            {
                return GetReviewForumByEditorsPicks(reviewForumId, siteName);
            }
            if (_ratingObj.FilterBy == FilterBy.UserList)
            {
                return GetReviewForumByUserList(reviewForumId, siteName, filterByData);
            }
            try
            {
                ISite site = GetSite(siteName);
                //_ratingObj.RatingForumGetLastUpdate(uid, site.SiteID)
                if (!GetOutputFromCache(ref output, new CheckCacheDelegate(_ratingObj.RatingForumGetLastUpdate), new object[2] { reviewForumId, site.SiteID }))
                {
                    Statistics.AddHTMLCacheMiss();
                    RatingForumData = _ratingObj.RatingForumReadByUID(reviewForumId, site);
                    
                    //if null then send back 404
                    if (RatingForumData == null)
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumUnknown));
                    }
                    else
                    {
                        output = GetOutputStream(RatingForumData, RatingForumData.LastUpdate);
                    }
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        private Stream GetReviewForumByEditorsPicks(string reviewForumId, string siteName)
        {
            RatingForum RatingForumData = null;
            Stream output = null;
            try
            {
                ISite site = GetSite(siteName);
                RatingForumData = _ratingObj.RatingForumReadByUID(reviewForumId, site);

                if (RatingForumData.ratingsList.ratings.Count > 0)
                {
                    int totalRating = 0;
                    for (int i = 0; i < RatingForumData.ratingsList.ratings.Count; i++)
                    {
                        totalRating += RatingForumData.ratingsList.ratings[i].rating;
                    }
                    RatingForumData.ratingsSummary.Total = RatingForumData.ratingsList.ratings.Count;
                    RatingForumData.ratingsSummary.Average = totalRating / RatingForumData.ratingsList.ratings.Count;
                }
                output = GetOutputStream(RatingForumData, DateTime.MinValue);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/reviewforum/{reviewForumId}/threads")]
        [WebHelp(Comment = "Get the review forum threads by ID")]
        [OperationContract]
        public Stream GetReviewForumThreads(string reviewForumId, string siteName)
        {
            ThreadList ratingForumThreadData = null;
            Stream output = null;
            if (_ratingObj.FilterBy == FilterBy.UserList)
            {
                //return GetReviewForumThreadsByUserList(reviewForumId, siteName, QueryStringHelper.GetQueryParameterAsString("userList", ""));
            }
            try
            {
                ISite site = GetSite(siteName);

                Threads _threadsObj = new Threads(dnaDiagnostic, readerCreator, cacheManager, siteList);

                ratingForumThreadData = _ratingObj.RatingForumThreadsReadByUID(reviewForumId, site);

                //if null then send back 404
                if (ratingForumThreadData == null)
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.NotFound, string.Format("Review forum '{0}' does not exist for site '{1}'", reviewForumId, siteName), null);
                }
                else
                {
                    output = GetOutputStream(ratingForumThreadData, ratingForumThreadData.LastUpdate);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/reviewforum/{reviewForumId}/thread/{threadid}")]
        [WebHelp(Comment = "Get the comments for a thread by ID")]
        [OperationContract]
        public Stream GetReviewForumThreadedComments(string reviewForumId, string siteName, string threadid)
        {
            CommentsList ratingForumThreadCommentData = null;
            Stream output = null;
            if (_ratingObj.FilterBy == FilterBy.UserList)
            {
                //return GetReviewForumThreadsByUserList(reviewForumId, siteName, QueryStringHelper.GetQueryParameterAsString("userList", ""));
            }
            try
            {
                ISite site = GetSite(siteName);
                ratingForumThreadCommentData = _ratingObj.RatingForumThreadCommentReadByID(threadid, site);

                //if null then send back 404
                if (ratingForumThreadCommentData == null)
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.NotFound, string.Format("Review forum '{0}' does not exist for site '{1}'", reviewForumId, siteName), null);
                }
                else
                {
                    output = GetOutputStream(ratingForumThreadCommentData, ratingForumThreadCommentData.LastUpdate);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
            return output;
        }

        /// <summary>
        /// Gets the rating forum by user list
        /// </summary>
        /// <param name="reviewForumId">the forum uid</param>
        /// <param name="siteName">the site name</param>
        /// <param name="userList">A comma delimitted list of user ids - *** IDENTITY IDs ***</param>
        /// <returns>stream of review forum seralised</returns>
        public Stream GetReviewForumByUserList(string reviewForumId, string siteName, string userList)
        {
            if (String.IsNullOrEmpty(userList))
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.BadRequest, string.Format("Userlist parameter cannot be empty"), null);
            }
            RatingForum RatingForumData = null;
            Stream output = null;
            try
            {
                ISite site = GetSite(siteName);
                int[] userIds;
                try
                {//check for valid int list...
                    userIds = userList.Split(',').Select(i => int.Parse(i)).ToArray();
                }
                catch
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.BadRequest, string.Format("Userlist parameter must be a comma seperated list of user IDs"), null);
                }
                RatingForumData = _ratingObj.RatingForumReadByUIDAndUserList(reviewForumId, site, userIds);
                
                // If null then send back 404
                if (RatingForumData == null)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumUnknown));
                }
                else
                {
                    output = GetOutputStream(RatingForumData, DateTime.MinValue);
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{sitename}/reviewforum/{reviewForumId}/")]
        [WebHelp(Comment = "Create a new rating forum for the specified site with rating")]
        [OperationContract]
        public Stream CreateRatingForumWithRating(string sitename, RatingForum ratingForum, string reviewForumId)
        {
            RatingForum RatingForumData = null;
            try
            {
                ratingForum.Id = reviewForumId;
                ISite site = GetSite(sitename);

                _ratingObj.CallingUser = GetCallingUser(site);
                RatingForumData = _ratingObj.RatingForumCreate(ratingForum, site);

                if (ratingForum.ratingsList != null && ratingForum.ratingsList.ratings != null && ratingForum.ratingsList.ratings.Count > 0)
                {//check if there is a rating to add
                    RatingInfo ratingInfo = _ratingObj.RatingCreate(RatingForumData, ratingForum.ratingsList.ratings[0]);
                    return GetOutputStream(ratingInfo); 
                }
                else
                {
                    return GetOutputStream(RatingForumData); 
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }


        }

        
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Create a new rating forum for the specified site")]
        [OperationContract]
        public Stream CreateRatingForum(string sitename, RatingForum RatingForum)
        {
            RatingForum RatingForumData = null;
            try
            {
                ISite site = GetSite(sitename);

                _ratingObj.CallingUser = GetCallingUser(site);
                if (_ratingObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    RatingForumData = _ratingObj.RatingForumCreate(RatingForum, site);
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingEditorCredentials));
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(RatingForumData);
        }
        

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/create.htm")]
        [WebHelp(Comment = "Create a new rating forum for the specified site")]
        [OperationContract]
        public void CreateRatingForumPostData(string sitename, NameValueCollection formsData)
        {
            RatingForum RatingForumData = null;
            ErrorType error = ErrorType.Unknown;
            DnaWebProtocolException _ex = null;
            try
            {
                RatingForumData = new RatingForum
                {
                    Id = formsData["id"],
                    Title = formsData["title"],
                    ParentUri = formsData["parentUri"]
                };
                if(!String.IsNullOrEmpty(formsData["moderationServiceGroup"]))
                {
                    try
                    {
                        RatingForumData.ModerationServiceGroup = (ModerationStatus.ForumStatus)Enum.Parse(ModerationStatus.ForumStatus.Unknown.GetType(), formsData["moderationServiceGroup"]);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidModerationStatus));

                    }
                }
                if (!String.IsNullOrEmpty(formsData["closeDate"]))
                {
                    DateTime closed = DateTime.Now;
                    if (!DateTime.TryParse(formsData["closeDate"], out closed))
                    {
                        throw ApiException.GetError(ErrorType.InvalidForumClosedDate);
                    }
                    RatingForumData.CloseDate = closed;
                }
                CreateRatingForum(sitename, RatingForumData);
                error = ErrorType.Ok;
            }
            catch (DnaWebProtocolException ex)
            {
                error = ex.ErrorType;
                _ex = ex;
            }

            string ptrt = WebFormat.GetPtrtWithResponse(error.ToString());
            if (String.IsNullOrEmpty(ptrt))
            {//none returned...
                if (error == ErrorType.Ok)
                {
                    WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.Created;
                    return;
                }
                else
                {
                    throw _ex;
                }
            }
            //do response redirect...
            WebOperationContext.Current.OutgoingResponse.Location = ptrt;
            WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.MovedPermanently;

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/")]
        [WebHelp(Comment = "Create a new rating for the rating forum")]
        [OperationContract]
        public Stream CreateRating(string RatingForumID, string siteName, RatingInfo rating)
        {
            RatingInfo ratingInfo = null;
            try
            {
                ISite site = GetSite(siteName);
                RatingForum RatingForumData = _ratingObj.RatingForumReadByUID(RatingForumID, site);
                if (RatingForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                _ratingObj.CallingUser = GetCallingUser(site);
                ratingInfo = _ratingObj.RatingCreate(RatingForumData, rating);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(ratingInfo);

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/create.htm")]
        [WebHelp(Comment = "Create a new rating for the rating forum")]
        [OperationContract]
        public void CreateRatingHtml(string RatingForumID, string siteName, NameValueCollection formsData)
        {
            ErrorType error = ErrorType.Unknown;
            DnaWebProtocolException _ex = null;
            RatingInfo ratingInfo = null;
            try
            {
                ratingInfo = new RatingInfo { text = formsData["text"] };
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        ratingInfo.PostStyle = (PostStyle.Style)Enum.Parse(typeof(PostStyle.Style), formsData["PostStyle"]);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidPostStyle));
                    }
                }
                byte rating = 0;
                if (!byte.TryParse(formsData["rating"], out rating))
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidRatingValue));
                }
                ratingInfo.rating = rating;

                CreateRating(RatingForumID, siteName, ratingInfo);
                error = ErrorType.Ok;
            }
            catch (DnaWebProtocolException ex)
            {
                error = ex.ErrorType;
                _ex = ex;
            }


            string ptrt = WebFormat.GetPtrtWithResponse(error.ToString());
            if (String.IsNullOrEmpty(ptrt))
            {//none returned...
                if (error == ErrorType.Ok)
                {
                    WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.Created;
                    return;
                }
                else
                {
                    throw _ex;
                }
            }
            //do response redirect...
            WebOperationContext.Current.OutgoingResponse.Location = ptrt;
            WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.MovedPermanently;


        }
        /// <summary>
        /// Deletes a pick for the specified comment.
        /// </summary>
        /// <param name="editorspickid"></param>
        /// <param name="siteName"></param>
        [WebInvoke(Method = "DELETE", UriTemplate = "V1/site/{siteName}/comments/{commentId}/editorpicks/")]
        [WebHelp(Comment = "Remove Editor Pick from Comment.")]
        [OperationContract]
        public void RemoveEditorPick(string commentId, string siteName)
        {
            ISite site = GetSite(siteName);
            try
            {
                _ratingObj.CallingUser = GetCallingUser(site);
                if (_ratingObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    EditorPicks editorPicks = new EditorPicks(dnaDiagnostic, readerCreator, cacheManager, siteList);
                    editorPicks.RemoveEditorPick(Convert.ToInt32(commentId));
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingEditorCredentials));
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        /// <summary>
        /// Deletes a pick for the specified comment.
        /// </summary>
        /// <param name="editorspickid"></param>
        /// <param name="siteName"></param>
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/comments/{commentId}/editorpicks/delete")]
        [WebHelp(Comment = "Remove Editor Pick from Comment.")]
        [OperationContract]
        public void RemoveEditorPickPost(string commentId, string siteName)
        {
            RemoveEditorPick(commentId, siteName);
        }

        /// <summary>
        /// No Implemented.
        /// </summary>
        /// <param name="sitename"></param>
        /// <param name="commentId"></param>
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/comments/{commentId}/editorpicks/")]
        [WebHelp(Comment = "Create a new editors pick for the specified comment")]
        [OperationContract]
        public void CreateEditorPick(String sitename, String commentId)
        {
            try
            {
                ISite site = GetSite(sitename);
                _ratingObj.CallingUser = GetCallingUser(site);
                if (_ratingObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    EditorPicks editorPicks = new EditorPicks(dnaDiagnostic, readerCreator, cacheManager, siteList);
                    editorPicks.CreateEditorPick(Convert.ToInt32(commentId));
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingEditorCredentials));
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/thread")]
        [WebHelp(Comment = "Create a new rating thread for the rating forum")]
        [OperationContract]
        public Stream CreateRatingThread(string RatingForumID, string siteName, RatingInfo rating)
        {
            ThreadInfo ratingThreadInfo = null;
            try
            {
                ISite site = GetSite(siteName);
                RatingForum ratingForumData = null;
                ratingForumData = _ratingObj.RatingForumReadByUID(RatingForumID, site);
                _ratingObj.CallingUser = GetCallingUser(site);
                ratingThreadInfo = _ratingObj.RatingThreadCreate(ratingForumData, rating);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(ratingThreadInfo);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/thread/create.htm")]
        [WebHelp(Comment = "Create a new rating thread for the rating forum")]
        [OperationContract]
        public Stream CreateRatingThreadHtml(string RatingForumID, string siteName, NameValueCollection formsData)
        {
            RatingInfo ratingInfo = null;
            try
            {
                ratingInfo = new RatingInfo { text = formsData["text"] };
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        ratingInfo.PostStyle =
                            (PostStyle.Style)Enum.Parse(typeof(PostStyle.Style), formsData["PostStyle"], true);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidPostStyle));
                    }
                }
                byte rating = 0;
                if (!byte.TryParse(formsData["rating"], out rating))
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.BadRequest, "Rating value must be between 0 and 255", null);
                }
                ratingInfo.rating = rating;
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
            return CreateRatingThread(RatingForumID, siteName, ratingInfo);

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/thread/{ThreadID}")]
        [WebHelp(Comment = "Create a new comment on a rating forum rating")]
        [OperationContract]
        public Stream CreateRatingThreadComment(string ratingForumID, string threadID, string siteName, CommentInfo comment)
        {
            int id = 0;
            if (!Int32.TryParse(threadID, out id))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidThreadID));
            }
            CommentInfo ratingThreadCommentInfo = null;
            try
            {
                ISite site = GetSite(siteName);
                RatingForum ratingForumData = null;
                ratingForumData = _ratingObj.RatingForumReadByUID(ratingForumID, site);
                _ratingObj.CallingUser = GetCallingUser(site);
                ratingThreadCommentInfo = _ratingObj.RatingCommentCreate(ratingForumData, id, comment);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(ratingThreadCommentInfo);

        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/reviewforum/{RatingForumID}/thread/{ThreadID}/create.htm")]
        [WebHelp(Comment = "Create a new comment on a rating forum rating")]
        [OperationContract]
        public Stream CreateRatingThreadCommentHtml(string ratingForumID, string threadid, string siteName, NameValueCollection formsData)
        {
            CommentInfo ratingThreadCommentInfo = null;
            try
            {
                ratingThreadCommentInfo = new CommentInfo { text = formsData["text"] };
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        ratingThreadCommentInfo.PostStyle =
                            (PostStyle.Style)Enum.Parse(typeof(PostStyle.Style), formsData["PostStyle"], true);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidPostStyle));
                    }
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return CreateRatingThreadComment(ratingForumID, threadid, siteName, ratingThreadCommentInfo);
        }
      
    }
}
