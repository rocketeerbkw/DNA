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


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class CommentsService : baseService
    {
        private Comments _commentObj = null;

        public CommentsService() : base(Global.connectionString, Global.siteList)
        {
            _commentObj = new Comments();
            _commentObj.siteList = Global.siteList;
            _commentObj.ItemsPerPage = _itemsPerPage;
            _commentObj.StartIndex = _startIndex;
            _commentObj.SignOnType = _signOnType;
            _commentObj.SortBy = _sortBy;
            _commentObj.SortDirection = _sortDirection;
            _commentObj.FilterBy = _filterBy;
            _commentObj.SummaryLength = _summaryLength;
            if (_BBCUidCookie != Guid.Empty)
            {
                _commentObj.BBCUid = _BBCUidCookie.ToString();
            }
            _commentObj.IPAddress = _iPAddress;
            _commentObj.BasePath = ConfigurationManager.AppSettings["ServerBasePath"];
        }

        [WebGet(UriTemplate = "V1/commentsforums/")]
        [WebHelp(Comment = "Get the comments forums in XML format")]
        [OperationContract]
        public Stream GetCommentForums()
        {
            CommentForumList commentForumList = null;
            try
            {
                commentForumList = _commentObj.CommentForumsRead(null);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumList);

        }

        [WebGet(UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Get the comment forums for given sitename")]
        [OperationContract]
        public Stream GetCommentForumsBySitename(string sitename)
        {
            CommentForumList commentForumList = null;
            try
            {
                string prefix = QueryStringHelper.GetQueryParameterAsString("prefix", "");
                if (String.IsNullOrEmpty(prefix))
                {
                    commentForumList = _commentObj.CommentForumsRead(sitename);
                }
                else
                {
                    commentForumList = _commentObj.CommentForumsRead(sitename, prefix);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumList);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumID}/")]
        [WebHelp(Comment = "Get the comments forum by ID")]
        [OperationContract]
        public Stream GetCommentForum(string commentForumID, string siteName)
        {
            CommentForum commentForumData = null;
            Stream output = null;
            try
            {
                ISite site = GetSite(siteName);
                if (!GetOutputFromCache(ref output, new CheckCacheDelegate(_commentObj.CommentForumGetLastUpdate), new object[2]{commentForumID, site.SiteID}))
                {
                    Statistics.AddHTMLCacheMiss();
                    commentForumData = _commentObj.CommentForumReadByUID(commentForumID, site);
                    
                    //if null then send back 404
                    if (commentForumData == null)
                    {
                        throw ApiException.GetError(ErrorType.ForumUnknown);
                    }
                    else
                    {
                        output = GetOutputStream(commentForumData, commentForumData.LastUpdate);
                    }
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return output;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/comments/{commentid}")]
        [WebHelp(Comment = "Get the requested comment from the Comment ID")]
        [OperationContract]
        public Stream GetComment(string commentid, string siteName)
        {
            CommentInfo commentData = null;
            ISite site = GetSite(siteName);
            Stream output = null;
            try
            {
                commentData = _commentObj.CommentReadByPostID(commentid, site);

                //if null then send back 404
                if (commentData == null)
                {
                    throw ApiException.GetError(ErrorType.CommentNotFound);
                }
                else
                {
                    output = GetOutputStream(commentData);
                }
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
            CommentsList commentList = null;
            Stream output = null;
            try
            {
                ISite site = GetSite(sitename);
                

                //_commentObj.CommentListGetLastUpdate(site.SiteID, prefix)
                if (!GetOutputFromCache(ref output, new CheckCacheDelegate(_commentObj.CommentListGetLastUpdate), new object[2] { site.SiteID, _prefix }))
                {
                    Statistics.AddHTMLCacheMiss();

                    if (String.IsNullOrEmpty(_prefix))
                    {
                        commentList = _commentObj.CommentsReadBySite(site);
                    }
                    else
                    {
                        commentList = _commentObj.CommentsReadBySite(site, _prefix);
                    }
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
        public Stream CreateCommentForumWithComment(string sitename, CommentForum commentForum, string commentForumID)
        {
            CommentForum commentForumData = null;
            try
            {
                commentForum.Id = commentForumID;
                ISite site = GetSite(sitename);
                _commentObj.CallingUser = GetCallingUser(site);

                commentForumData = _commentObj.CommentForumCreate(commentForum, site);

                if (commentForum.commentList != null && commentForum.commentList.comments != null && commentForum.commentList.comments.Count > 0)
                {//check if there is a rating to add
                    CommentInfo commentInfo = _commentObj.CommentCreate(commentForumData, commentForum.commentList.comments[0]);
                    return GetOutputStream(commentInfo);
                }
                else
                {
                    return GetOutputStream(commentForumData);
                }

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
            CommentForum commentForumData = null;
            try
            {
                ISite site = GetSite(sitename);
                _commentObj.CallingUser = GetCallingUser(site);
                
                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    commentForumData = _commentObj.CommentForumCreate(commentForum, site);
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
            CommentForum commentForumData = null;
            ErrorType error = ErrorType.Unknown;
            DnaWebProtocolException _ex = null;
            try
            {
                commentForumData = new CommentForum
                {
                    Id = formsData["id"],
                    Title = formsData["title"],
                    ParentUri = formsData["parentUri"]
                };
                if(!String.IsNullOrEmpty(formsData["moderationServiceGroup"]))
                {
                    try
                    {
                        commentForumData.ModerationServiceGroup = (ModerationStatus.ForumStatus)Enum.Parse(ModerationStatus.ForumStatus.Unknown.GetType(), formsData["moderationServiceGroup"]);
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
                    commentForumData.CloseDate = closed;
                }
                CreateCommentForum(sitename, commentForumData);
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

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumID}/")]
        [WebHelp(Comment = "Create a new comment for the comment forum")]
        [OperationContract]
        public Stream CreateComment(string commentForumID, string siteName, CommentInfo comment)
        {
            CommentInfo commentInfo = null;
            try
            {
                ISite site = GetSite(siteName);
                CommentForum commentForumData = null;
                commentForumData = _commentObj.CommentForumReadByUID(commentForumID, site);
                _commentObj.CallingUser = GetCallingUser(site);
                if (commentForumData == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }
                else
                {
                    commentInfo = _commentObj.CommentCreate(commentForumData, comment);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentInfo);

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/commentsforums/{commentForumID}/create.htm")]
        [WebHelp(Comment = "Create a new comment for the comment forum")]
        [OperationContract]
        public void CreateCommentHtml(string commentForumID, string siteName, NameValueCollection formsData)
        {
            ErrorType error = ErrorType.Unknown;
            DnaWebProtocolException _ex = null;
            CommentInfo commentInfo = null;
            try
            {
                commentInfo = new CommentInfo{text = formsData["text"]};
                if (!String.IsNullOrEmpty(formsData["PostStyle"]))
                {
                    try
                    {
                        commentInfo.PostStyle = (PostStyle.Style)Enum.Parse(typeof(PostStyle.Style), formsData["PostStyle"]);
                    }
                    catch
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidPostStyle));
                    }
                }
                CreateComment(commentForumID, siteName, commentInfo);
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
                _commentObj.CallingUser = GetCallingUser(site);
                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    EditorPicks editorPicks = new EditorPicks();
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
        public void CreateEditorPick(String sitename, String commentId )
        {
            try
            {
                ISite site = GetSite(sitename);
                _commentObj.CallingUser = GetCallingUser(site);
                if (_commentObj.CallingUser.IsUserA(UserTypes.Editor))
                {
                    EditorPicks editorPicks = new EditorPicks();
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
