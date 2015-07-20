using BBC.Dna.Api;
using BBC.Dna.Api.Contracts;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class CommentsService : baseService
    {
        private readonly Comments _commentObj;

        public CommentsService()
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

        [WebGet(UriTemplate = "V1/site/{siteName}/mostrecentlycommentedcommentforum/")]
        [WebHelp(Comment = "Get the most recently commented comment forums.<br/>Param : count. Defines the max number of forums to return, default = 5<br/>Param : prefix. Defines the prefix that the returned forums should begin with, default = Empty String")]
        [OperationContract]
        public Stream GetMostRecentlyCommentedCommentForumsForSite(string siteName)
        {
            int commentForumCount = QueryStringHelper.GetQueryParameterAsInt("count", 5);
            string prefix = QueryStringHelper.GetQueryParameterAsString("prefix", "");
            MostCommentedCommentForumList mostRecentlyCommentedCommentForumList = GetMostRecentlyCommented(siteName, commentForumCount, prefix);
            return GetOutputStream(mostRecentlyCommentedCommentForumList);
        }

        private MostCommentedCommentForumList GetMostRecentlyCommented(string siteName, int commentForumCount, string prefix)
        {
            MostCommentedCommentForumList mostRecentlyCommentedCommentForumList;
            try
            {
                ISite site = GetSite(siteName);
                mostRecentlyCommentedCommentForumList = _commentObj.GetMostRecentlyCommentedCommentForumList(site, prefix, commentForumCount);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return mostRecentlyCommentedCommentForumList;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/mostcommentedcommentforum/")]
        [WebHelp(Comment = "Get the most commented comment forums for a given sitename.<br/>Param : count. Defines the max number of forums to return, default = 5<br/>Param : prefix. Defines the prefix that the returned forums should begin with, default = Empty String")]
        [OperationContract]
        public Stream GetMostCommentedCommentForumBySiteName(string siteName)
        {
            int commentForumCount = QueryStringHelper.GetQueryParameterAsInt("count", 5);
            string prefix = QueryStringHelper.GetQueryParameterAsString("prefix", "");
            MostCommentedCommentForumList mostCommentedCommentForumList = GetMostCommented(siteName, commentForumCount, prefix);
            return GetOutputStream(mostCommentedCommentForumList);
        }

        private MostCommentedCommentForumList GetMostCommented(string siteName, int commentForumCount, string prefix)
        {
            MostCommentedCommentForumList mostCommentedCommentForumList;
            try
            {
                ISite site = GetSite(siteName);
                mostCommentedCommentForumList = _commentObj.GetMostCommentedCommentForumList(site, prefix, commentForumCount);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return mostCommentedCommentForumList;
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Get the comment forums for given sitename")]
        [OperationContract]
        public Stream GetCommentForumsBySitename(string sitename)
        {
            ISite site = GetSite(sitename);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            CommentForumList commentForumList;
            try
            {
                switch (filterBy)
                {
                    case FilterBy.PostsWithinTimePeriod:
                        int timePeriod;
                        if (!Int32.TryParse(filterByData, out timePeriod))
                        {
                            timePeriod = 24;
                        }
                        commentForumList = _commentObj.GetCommentForumListBySiteWithinTimeFrame(site, prefix, timePeriod);
                        break;

                    default:
                        commentForumList = _commentObj.GetCommentForumListBySite(site, prefix);
                        break;
                }


            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumList);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/coalescedcommentsforum/{commentForumIdList}/")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream GetCommentForumByUIDs(string commentForumIdList, string siteName)
        {
            ISite site = GetSite(siteName);
            CommentForum commentForumData;
            Stream output = null;
            try
            {
                //get the startindex to include the post id
                var postValue = QueryStringHelper.GetQueryParameterAsString("includepostid", string.Empty);
                if (postValue != string.Empty)
                {
                    int postId = 0;
                    if (!Int32.TryParse(postValue, out postId))
                    {
                        throw ApiException.GetError(ErrorType.CommentNotFound);
                    }
                    _commentObj.StartIndex = _commentObj.GetStartIndexForPostId(postId);
                }


                commentForumData = _commentObj.GetCommentForumByUids(commentForumIdList, site);

                //if null then send back 404
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                output = GetOutputStream(commentForumData, commentForumData.LastUpdate);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream GetCommentForum(string commentForumId, string siteName)
        {
            ISite site = GetSite(siteName);
            CommentForum commentForumData;
            Stream output = null;
            try
            {
                //get the startindex to include the post id
                var postValue = QueryStringHelper.GetQueryParameterAsString("includepostid", string.Empty);
                if (postValue != string.Empty)
                {
                    int postId = 0;
                    if (!Int32.TryParse(postValue, out postId))
                    {
                        throw ApiException.GetError(ErrorType.CommentNotFound);
                    }
                    _commentObj.StartIndex = _commentObj.GetStartIndexForPostId(postId);
                }


                commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site, true);

                //if null then send back 404
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                output = GetOutputStream(commentForumData, commentForumData.LastUpdate);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/comment/{commentId}/")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream GetCommentForumWithCommentId(string commentForumId, string siteName, string commentId)
        {
            int postId = 0;
            try
            {
                if (!Int32.TryParse(commentId, out postId))
                {
                    throw ApiException.GetError(ErrorType.CommentNotFound);
                }
                _commentObj.StartIndex = _commentObj.GetStartIndexForPostId(postId);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetCommentForum(commentForumId, siteName);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/comments/{commentid}")]
        [WebHelp(Comment = "Get the requested comment from the Comment ID")]
        [OperationContract]
        public Stream GetComment(string commentid, string siteName)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            Stream output;
            try
            {
                CommentInfo commentData = _commentObj.CommentReadByPostId(commentid, site);

                //if null then send back 404
                if (commentData == null)
                {
                    throw ApiException.GetError(ErrorType.CommentNotFound);
                }
                output = GetOutputStream(commentData);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/comments/")]
        [WebHelp(Comment = "Get the comments by Site")]
        [OperationContract]
        public Stream GetCommentListBySiteName(string sitename)
        {
            ISite site = GetSite(sitename);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            CommentsList commentList;
            Stream output = null;
            try
            {
                commentList = String.IsNullOrEmpty(prefix) ? _commentObj.GetCommentsListBySite(site) : _commentObj.GetCommentsListBySite(site, prefix);
                output = GetOutputStream(commentList, commentList.LastUpdate);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{sitename}/commentsforums/{commentForumID}/")]
        [WebHelp(Comment = "Create a new comment forum for the specified site with comment")]
        [OperationContract]
        public Stream CreateCommentForumWithComment(string sitename, CommentForum commentForum, string commentForumId)
        {
            ISite site = GetSite(sitename);
            try
            {
                commentForum.Id = commentForumId;
                CommentForum commentForumData = _commentObj.CreateCommentForum(commentForum, site);

                _commentObj.CallingUser = GetCallingUserOrNotSignedInUser(site, commentForumData);

                if (commentForum.commentList != null && commentForum.commentList.comments != null &&
                    commentForum.commentList.comments.Count > 0)
                {
                    //check if there is a rating to add
                    CommentInfo commentInfo = _commentObj.CreateComment(commentForumData,
                                                                        commentForum.commentList.comments[0]);
                    return GetOutputStream(commentInfo);
                }
                return GetOutputStream(commentForumData);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Create/Update a  comment forum for the specified site")]
        [OperationContract]
        public Stream CreateCommentForum(string sitename, CommentForum commentForum)
        {
            CommentForum commentForumData;
            try
            {
                var site = GetSite(sitename);
                try
                {
                    _commentObj.CallingUser = GetCallingUser(site);
                }
                catch (ApiException e)
                {
                    if (!_internalRequest)
                    {
                        throw e;
                    }
                }

                if (_internalRequest || _commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    commentForumData = _commentObj.CreateAndUpdateCommentForum(commentForum, site, null);
                }
                else
                {
                    throw ApiException.GetError(ErrorType.MissingEditorCredentials);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumData);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/open")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream OpenCommentForum(string commentForumId, string siteName)
        {
            ISite site = GetSite(siteName);
            CommentForum commentForum;
            Stream output = null;
            try
            {
                try
                {
                    _commentObj.CallingUser = GetCallingUser(site);
                }
                catch (ApiException e)
                {
                    if (!_internalRequest)
                    {
                        throw e;
                    }
                }
                commentForum = _commentObj.GetCommentForumByUid(commentForumId, site, true);

                //if null then send back 404
                if (commentForum == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                if (_internalRequest || _commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    commentForum = _commentObj.CreateAndUpdateCommentForum(commentForum, site, false);
                }
                else
                {
                    throw ApiException.GetError(ErrorType.MissingEditorCredentials);
                }
                output = GetOutputStream(commentForum);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/close")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream CloseCommentForum(string commentForumId, string siteName)
        {
            ISite site = GetSite(siteName);
            CommentForum commentForum;
            Stream output = null;
            try
            {
                try
                {
                    _commentObj.CallingUser = GetCallingUser(site);
                }
                catch (ApiException e)
                {
                    if (!_internalRequest)
                    {
                        throw e;
                    }
                }
                commentForum = _commentObj.GetCommentForumByUid(commentForumId, site, true);
                //if null then send back 404
                if (commentForum == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                if (_internalRequest || _commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    commentForum = _commentObj.CreateAndUpdateCommentForum(commentForum, site, true);
                }
                else
                {
                    throw ApiException.GetError(ErrorType.MissingEditorCredentials);
                }
                output = GetOutputStream(commentForum);

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/create.htm")]
        [WebHelp(Comment = "Create a new comment forum for the specified site")]
        [OperationContract]
        public void CreateCommentForumPostData(string sitename, NameValueCollection formsData)
        {
            CommentForum commentForumData;
            ErrorType error;
            DnaWebProtocolException webEx = null;
            try
            {
                commentForumData = new CommentForum
                                       {
                                           Id = formsData["id"],
                                           Title = formsData["title"],
                                           ParentUri = formsData["parentUri"]
                                       };
                if (!String.IsNullOrEmpty(formsData["moderationServiceGroup"]))
                {
                    try
                    {
                        commentForumData.ModerationServiceGroup =
                            (ModerationStatus.ForumStatus)
                            Enum.Parse(ModerationStatus.ForumStatus.Unknown.GetType(),
                                       formsData["moderationServiceGroup"], true);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidModerationStatus));
                    }
                }
                if (!String.IsNullOrEmpty(formsData["closeDate"]))
                {
                    DateTime closed;
                    if (!DateTime.TryParse(formsData["closeDate"], out closed))
                    {
                        throw ApiException.GetError(ErrorType.InvalidForumClosedDate);
                    }
                    commentForumData.CloseDate = closed;
                }
                CreateCommentForum(sitename, commentForumData);
                error = ErrorType.Ok;
            }
            catch (DnaWebProtocolException ex)
            {
                error = ex.ErrorType;
                webEx = ex;
            }
            string ptrt = WebFormat.GetPtrtWithResponse(error.ToString());
            if (String.IsNullOrEmpty(ptrt))
            {
                //none returned...
                if (error == ErrorType.Ok)
                {
                    WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.Created;
                    return;
                }
                throw webEx;
            }
            //do response redirect...
            WebOperationContext.Current.OutgoingResponse.Location = ptrt;
            WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.MovedPermanently;
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/")]
        [WebHelp(Comment = "Create a new comment for the comment forum")]
        [OperationContract]
        public Stream CreateComment(string commentForumId, string siteName, CommentInfo comment)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            CommentInfo commentInfo;
            try
            {
                CommentForum commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site, true);
                _commentObj.CallingUser = GetCallingUser(site);
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                commentInfo = _commentObj.CreateComment(commentForumData, comment);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentInfo);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/preview")]
        [WebHelp(Comment = "Create a new comment for the comment forum")]
        [OperationContract]
        public Stream CreateCommentPreview(string commentForumId, string siteName, CommentInfo comment)
        {
            bool isEditor = false;
            try
            {
                ISite site = GetSite(siteName);
                _commentObj.CallingUser = GetCallingUser(site);
                isEditor = _commentObj.CallingUser.IsUserA(UserTypes.Editor);
            }
            catch { }
            comment.text = CommentInfo.FormatComment(comment.text, comment.PostStyle, comment.hidden, isEditor);
            return GetOutputStream(comment);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumId}/create.htm")]
        [WebHelp(Comment = "Create a new comment for the comment forum")]
        [OperationContract]
        public void CreateCommentHtml(string commentForumId, string siteName, NameValueCollection formsData)
        {
            ErrorType error;
            DnaWebProtocolException dnaWebProtocolException = null;
            CommentInfo commentInfo;
            try
            {
                commentInfo = new CommentInfo { text = formsData["text"] };
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        commentInfo.PostStyle =
                            (PostStyle.Style)Enum.Parse(typeof(PostStyle.Style), formsData["PostStyle"]);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidPostStyle));
                    }
                }
                CreateComment(commentForumId, siteName, commentInfo);
                error = ErrorType.Ok;
            }
            catch (DnaWebProtocolException ex)
            {
                error = ex.ErrorType;

                dnaWebProtocolException = ex;
            }


            string ptrt = WebFormat.GetPtrtWithResponse(error.ToString());
            if (String.IsNullOrEmpty(ptrt))
            {
                //none returned...
                if (error == ErrorType.Ok)
                {
                    WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.Created;
                    return;
                }
                else
                {
                    throw dnaWebProtocolException;
                }
            }
            //do response redirect...
            WebOperationContext.Current.OutgoingResponse.Location = ptrt;
            WebOperationContext.Current.OutgoingResponse.StatusCode = HttpStatusCode.MovedPermanently;
        }

        /// <summary>
        /// Deletes a pick for the specified comment.
        /// </summary>
        /// <param name="commentId"></param>
        /// <param name="siteName"></param>
        [WebInvoke(Method = "DELETE", UriTemplate = "V1/site/{siteName}/comments/{commentId}/editorpicks/")]
        [WebHelp(Comment = "Remove Editor Pick from Comment.")]
        [OperationContract]
        public void RemoveEditorPick(string commentId, string siteName)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            try
            {
                _commentObj.CallingUser = GetCallingUser(site);
                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    var editorPicks = new EditorPicks(dnaDiagnostic, readerCreator, cacheManager, siteList);
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
        /// <param name="commentId"></param>
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
            ISite site = GetSite(sitename);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            try
            {
                _commentObj.CallingUser = GetCallingUser(site);
                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    var editorPicks = new EditorPicks(dnaDiagnostic, readerCreator, cacheManager, siteList);
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

        ///// <summary>
        ///// Helper method for getting the site object given a sitename
        ///// </summary>
        ///// <param name="siteName">The name of the site you want to get</param>
        ///// <returns>The site object for the given sitename</returns>
        ///// <exception cref="ApiException">Thrown if the site does not exist</exception>
        [WebGet(UriTemplate = "V1/site/{siteName}")]
        [WebHelp(Comment = "Get the site")]
        [OperationContract]
        public Stream GetSiteObject(string siteName)
        {
            var siteObject = (Sites.Site)GetSite(siteName);
            siteObject.SiteOptions = siteList.GetSiteOptionListForSite(siteObject.SiteID);
            //siteObject.SiteOptions = siteObject.SiteOptions.FindAll(x => x.Section.ToUpper() == "COMMENTFORUM" || x.Section.ToUpper() == "GENERAL");


            return GetOutputStream(siteObject);
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{sitename}/commentsforums/{commentForumUid}/comment/{commentId}/rate/up")]
        [WebHelp(Comment = "Increase the nero rating of a comment")]
        [OperationContract]
        public Stream NeroRatingIncrease(string sitename, string commentForumUid, string commentId)
        {
            NeroRatingInfo ratingInfo = ApplyNeroRating(sitename, commentForumUid, commentId, 1, 1);
            return GetOutputStream(ratingInfo.neroValue);
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{sitename}/commentsforums/{commentForumUid}/comment/{commentId}/rate/down")]
        [WebHelp(Comment = "Decrease the nero rating of a comment")]
        [OperationContract]
        public Stream NeroRatingDecrease(string sitename, string commentForumUid, string commentId)
        {
            NeroRatingInfo ratingInfo = ApplyNeroRating(sitename, commentForumUid, commentId, -1, 1);
            return GetOutputStream(ratingInfo.neroValue);
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V2/site/{sitename}/commentsforums/{commentForumUid}/comment/{commentId}/rate/up")]
        [WebHelp(Comment = "Increase the nero rating of a comment")]
        [OperationContract]
        public Stream NeroRatingIncreaseV2(string sitename, string commentForumUid, string commentId)
        {
            NeroRatingInfo ratingInfo = ApplyNeroRating(sitename, commentForumUid, commentId, 1, 2);
            return GetOutputStream(ratingInfo);
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V2/site/{sitename}/commentsforums/{commentForumUid}/comment/{commentId}/rate/down")]
        [WebHelp(Comment = "Decrease the nero rating of a comment")]
        [OperationContract]
        public Stream NeroRatingDecreaseV2(string sitename, string commentForumUid, string commentId)
        {
            NeroRatingInfo ratingInfo = ApplyNeroRating(sitename, commentForumUid, commentId, -1, 2);
            return GetOutputStream(ratingInfo);
        }

        /// <summary>
        /// Validates call and processes nero rating
        /// </summary>
        /// <param name="sitename"></param>
        /// <param name="commentForumId"></param>
        /// <param name="commentId"></param>
        /// <param name="value"></param>
        /// <returns>The new aggregate value for the given comment</returns>
        private NeroRatingInfo ApplyNeroRating(string sitename, string commentForumUid, string commentIdStr, short value, short outputType)
        {
            ISite site = GetSite(sitename);
            var userId = 0;
            try
            {
                _commentObj.CallingUser = GetCallingUser(site);
                userId = _commentObj.CallingUser.UserID;
            }
            catch
            { //anonymous call...
                userId = 0;
            }
            if (userId == 0 && !siteList.GetSiteOptionValueBool(site.SiteID, "CommentForum", "AllowNotSignedInRating"))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }
            if (userId == 0 && (bbcUidCookie == Guid.Empty || string.IsNullOrEmpty(_iPAddress)))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingUserAttributes));
            }
            var commentId = 0;
            try
            {
                commentId = Int32.Parse(commentIdStr);
            }
            catch
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.CommentNotFound));
            }

            var commentForumData = _commentObj.GetCommentForumByUid(commentForumUid, site, true);
            if (commentForumData == null)
            {
                throw ApiException.GetError(ErrorType.ForumUnknown);
            }

            return _commentObj.CreateCommentRating(commentForumData, site, commentId, userId, value);
        }

        //2. GetConversations()
        [WebGet(UriTemplate = "V1/site/{sitename}/commentsforums/{commentForumUid}/conversations")]
        [WebHelp(Comment = "Get the conversations for a comment forum.")]
        [OperationContract]
        public Stream GetConversationsForCommentForum(string siteName, string commentForumUid)
        {
            var conversations = new Conversations();
            return GetOutputStream(conversations);
        }

        //Numbers reference API spec - https://confluence.dev.bbc.co.uk/display/DNA/Initial+API+Mock+data
        //5. CreateConversation()
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumUid}/conversations")]
        [WebHelp(Comment = "Create a new conversation in a comment forum")]
        [OperationContract]
        public Stream CreateConversation(string siteName, string commentForumUid)
        {
            var threadId = _commentObj.CreateConversation(commentForumUid);
            return GetOutputStream(threadId);
        }

        //6. CreateCommentInConversatioin()
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumUid}/conversations/{conversationId}/comments")]
        [WebHelp(Comment = "Post a comment to a conversation")]
        [OperationContract]
        public Stream PostCommentToConversation(string siteName, string commentForumUid, string conversationId, CommentInfo commentInfo)
        {
            var threadId = int.Parse(conversationId);

            //Yuck!!!
            _commentObj.CallingUser = GetCallingUser(GetSite(siteName));
            var comment = _commentObj.PostCommentToConversation(siteName, commentForumUid, threadId, commentInfo);
            return GetOutputStream(comment);
        }

        //3. GetCommentsByConversation
        [WebGet(UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumUid}/conversations/{conversationId}/comments")]
        [WebHelp(Comment = "Get comments for a conversation")]
        [OperationContract]
        public Stream GetCommentsForConversation(string siteName, string commentForumUid, string conversationId)
        {
            var comments = new object();
            return GetOutputStream(comments);
        }

        //4. GetConversationsByUser
        [WebGet(UriTemplate = "V1/site/{siteName}/commentsforums/myconversations")]
        [WebHelp(Comment = "Get Conversations for the signed in user")]
        [OperationContract]
        public Stream GetConversationsForUser(string siteName)
        {
            var usersConversations = new object();
            return GetOutputStream(usersConversations);
        }

        //7. UpdateConversation
        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumUid}/conversations/{conversationId}")]
        [WebHelp(Comment = "Get Conversations for the signed in user")]
        [OperationContract]
        public Stream UpdateConversation(string siteName, string commentForumUid, string conversationId)
        {
            var conversation = new object();
            return GetOutputStream(conversation);
        }

        [WebGet(UriTemplate = "v1/commentforums/mostrecentactivity")]
        [WebHelp(Comment = "Gets most recent activity across all comment forums in the last ?minutes=X minutes, or since ?startdate. Both are capped at 60 mins max. Resolution to 1 minute")]
        [OperationContract]
        public Stream MostRecentActivity()
        {
            int minutes = QueryStringHelper.GetQueryParameterAsInt("minutes", 1);
            string startDateString = QueryStringHelper.GetQueryParameterAsString("startdate", "");
            CommentForumsActivityList commentForumsActivityList = _commentObj.GetCommentForumsActivity(minutes, startDateString);
            return GetOutputStream(commentForumsActivityList);
        }

        [WebGet(UriTemplate = "v1/commentforums/mostrecentratingactivity")]
        [WebHelp(Comment = "Gets most recent rating activity across all comment forums in the last ?minutes=X minutes, or since ?startdate. Both are capped at 60 mins max. Resolution to 1 minute")]
        [OperationContract]
        public Stream MostRecentRatingActivity()
        {
            int minutes = QueryStringHelper.GetQueryParameterAsInt("minutes", 1);
            string startDateString = QueryStringHelper.GetQueryParameterAsString("startdate", "");
            CommentForumsRatingActivityList commentForumsRatingActivity = _commentObj.GetCommentForumsRatingActivity(minutes, startDateString);
            return GetOutputStream(commentForumsRatingActivity);
        }
    }
}