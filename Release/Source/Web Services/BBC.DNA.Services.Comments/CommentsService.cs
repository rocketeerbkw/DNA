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

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class CommentsService : baseService
    {
        private readonly Comments _commentObj;

        public CommentsService() : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
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

        /*
        [WebGet(UriTemplate = "V1/commentsforums/")]
        [WebHelp(Comment = "Get the comments forums in XML format")]
        [OperationContract]
        public Stream GetCommentForums()
        {
            CommentForumList commentForumList;
            try
            {
                commentForumList = _commentObj.GetCommentForumListBySite(null);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumList);
        }*/

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
                switch(filterBy)
                {
                    case FilterBy.PostsWithinTimePeriod:
                        int timePeriod;
                        if(!Int32.TryParse(filterByData, out timePeriod))
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
                if(postValue != string.Empty)
                {
                    int postId =0;
                    if (!Int32.TryParse(postValue, out postId))
                    {
                        throw ApiException.GetError(ErrorType.CommentNotFound);
                    }
                    _commentObj.StartIndex = _commentObj.GetStartIndexForPostId(postId);
                }


                if (
                    !GetOutputFromCache(ref output, new CheckCacheDelegate(_commentObj.CommentForumGetLastUpdate),
                                        new object[] {commentForumId, site.SiteID}))
                {
                    Statistics.AddHTMLCacheMiss();
                    commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site);

                    //if null then send back 404
                    if (commentForumData == null)
                    {
                        throw ApiException.GetError(ErrorType.ForumUnknown);
                    }
                    output = GetOutputStream(commentForumData, commentForumData.LastUpdate);
                }
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


                //_commentObj.CommentListGetLastUpdate(site.SiteID, prefix)
                if (
                    !GetOutputFromCache(ref output, new CheckCacheDelegate(_commentObj.CommentListGetLastUpdate),
                                        new object[] {site.SiteID, prefix}))
                {
                    Statistics.AddHTMLCacheMiss();

                    commentList = String.IsNullOrEmpty(prefix) ? _commentObj.GetCommentsListBySite(site) : _commentObj.GetCommentsListBySite(site, prefix);
                    output = GetOutputStream(commentList, commentList.LastUpdate);
                }
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
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            try
            {
                commentForum.Id = commentForumId;
                _commentObj.CallingUser = GetCallingUser(site);

                CommentForum commentForumData = _commentObj.CreateCommentForum(commentForum, site);

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
        [WebHelp(Comment = "Create a new comment forum for the specified site")]
        [OperationContract]
        public Stream CreateCommentForum(string sitename, CommentForum commentForum)
        {
            CommentForum commentForumData;
            try
            {
                var site = GetSite(sitename);
                _commentObj.CallingUser = GetCallingUser(site);

                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    commentForumData = _commentObj.CreateCommentForum(commentForum, site);
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

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/create.htm")]
        [WebHelp(Comment = "Create a new comment forum for the specified site")]
        [OperationContract]
        public void CreateCommentForumPostData(string sitename, NameValueCollection formsData)
        {
            CommentForum commentForumData;
            ErrorType error;
            DnaWebProtocolException  webEx = null;
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
                CommentForum commentForumData = _commentObj.GetCommentForumByUid(commentForumId, site);
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
                commentInfo = new CommentInfo {text = formsData["text"]};
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        commentInfo.PostStyle =
                            (PostStyle.Style) Enum.Parse(typeof (PostStyle.Style), formsData["PostStyle"]);
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
    }
}