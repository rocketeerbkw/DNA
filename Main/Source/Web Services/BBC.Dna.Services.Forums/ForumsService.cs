using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Api;
using BBC.Dna.Users;
using BBC.Dna.Moderation.Utils;


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ForumsService : baseService
    {

        public ForumsService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/recentactivity/")]
        [WebHelp(Comment = "Get the recent activity for a given site")]
        [OperationContract]
        public Stream GetRecentActivity(string siteName)
        {
            ISite site = Global.siteList.GetSite(siteName);
            return GetOutputStream(RecentActivity.GetSiteRecentActivity(site.SiteID, readerCreator, dnaDiagnostic, cacheManager));
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}")]
        [WebHelp(Comment = "Get the forums for a given site")]
        [OperationContract]
        public Stream GetForum(string siteName, string forumId)
        {
            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }
            return GetOutputStream(ForumThreads.CreateForumThreads(cacheManager, readerCreator, Global.siteList, Int32.Parse(forumId),
                        itemsPerPage, startIndex, 0, true, threadOrder, null, false));
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}")]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]
        public Stream GetForumThreads(string siteName, string forumId, string threadId)
        {
            return GetForumThreadsWithPost(siteName, forumId, threadId, "0");
        }



        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/post/{postId}")]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]        
        public Stream GetForumThreadsWithPost(string siteName, string forumId, string threadId, string postId)
        {
            ISite site = Global.siteList.GetSite(siteName);

            return GetOutputStream(ForumThreadPosts.CreateThreadPosts(readerCreator, cacheManager, null, siteList, site.SiteID,
                Int32.Parse(forumId), Int32.Parse(threadId), itemsPerPage, startIndex, Int32.Parse(postId), (SortBy.Created == sortBy), false));
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/posts/{postId}")]
        [WebHelp(Comment = "Gets a thread post by id")]
        [OperationContract]
        public Stream GetThreadPost(string siteName, string postId)
        {
            int postIdAsInt = Convert.ToInt32(postId);
            Stream output;
            ThreadPost returnedPost = null;
            ISite site = GetSite(siteName);
            try
            {
                returnedPost = ThreadPost.FetchPostFromDatabase(readerCreator, postIdAsInt);
                output = GetOutputStream(returnedPost);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/create.htm")]
        [WebHelp(Comment = "Creates a thread post from Html form")]
        [OperationContract]
        public void CreateThreadHtml(string siteName, string forumId, NameValueCollection formsData)
        {
            CreateThreadPostHtml(siteName, forumId, "0", formsData);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads")]
        [WebHelp(Comment = "Creates a thread post")]
        [OperationContract]
        public void CreateThread(string siteName, string forumId, ThreadPost threadPost)
        {
            CreateThreadPost(siteName, forumId, "0", threadPost);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/{threadid}/create.htm")]
        [WebHelp(Comment = "Creates a thread post from Html form")]
        [OperationContract]
        public void CreateThreadPostHtml(string siteName, string forumId, string threadId, NameValueCollection formsData)
        {
            ErrorType error;
            DnaWebProtocolException webEx = null;
            try
            {
                ThreadPost post = new ThreadPost();
                post.InReplyTo = Convert.ToInt32(formsData["inReplyTo"]);
                post.ThreadId = Convert.ToInt32(threadId);
                post.Subject = formsData["subject"];
                post.Text = formsData["text"];
                post.Style = (BBC.Dna.Objects.PostStyle.Style)Enum.Parse(typeof(BBC.Dna.Objects.PostStyle.Style), formsData["style"]);

                CreateThreadPost(siteName, forumId, threadId, post);                
                
                error = ErrorType.Ok;
                
            }
            catch (DnaWebProtocolException ex)
            {
                error = ex.ErrorType;
                webEx = ex;
            }            
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/{threadid}")]
        [WebHelp(Comment = "Creates a thread post")]
        [OperationContract]
        public void CreateThreadPost(string siteName, string forumId, string threadId, ThreadPost threadPost)
        {
            int forumIdAsInt;
            try
            {
                forumIdAsInt = Convert.ToInt32(forumId);
            }
            catch
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumIDNotWellFormed));
            }
            
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);
            
            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);            
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MissingUserCredentials));
            }
            bool isNotable = callingUser.IsUserA(UserTypes.Notable);

            // Check 3) check threadid is well formed
            int threadIdAsInt = 0;
            if (!Int32.TryParse(threadId, out threadIdAsInt))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidThreadID));
            }

            ForumHelper helper = new ForumHelper(readerCreator);

            // Check 4) check threadid exists and user has permission to write
            if (threadIdAsInt != 0)
            {
                bool canReadThread = false;
                bool canWriteThread = false;                
                helper.GetThreadPermissions(callingUser.UserID, threadIdAsInt, ref canReadThread, ref canWriteThread);
                if (!canReadThread)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ThreadNotFound));
                }
                if (!canWriteThread)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumReadOnly));
                }
            }

            // Check 5) check forum exists. Note, Check 4 and 5 must be done in this order.
            bool canReadForum = false;
            bool canWriteForum = false;
            helper.GetForumPermissions(callingUser.UserID, forumIdAsInt, ref canReadForum, ref canWriteForum);
            if (!canReadForum)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumUnknown));                
            }

            // Check 6) check if the posting is secure
            bool requireSecurePost = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "EnforceSecurePosting") == 1;
            if (requireSecurePost && !callingUser.IsSecureRequest)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotSecure));
            }

            // Check 7) get the ignore moderation value            
            if (callingUser.IsUserA(UserTypes.BannedUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UserIsBanned));
            }

            // Check 8) check if site is open
            bool ignoreModeration = callingUser.IsUserA(UserTypes.Editor) || callingUser.IsUserA(UserTypes.SuperUser);
            if (!ignoreModeration && (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now)))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.SiteIsClosed));
            }

            // Check 9) is thread post empty
            if (String.IsNullOrEmpty(threadPost.Text))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.EmptyText));
            }

            // Check 10) check for MaxCommentCharacterLength
            try
            {
                
                int maxCharCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "MaxCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(threadPost.Text);
                if (maxCharCount != 0 && tmpText.Length > maxCharCount)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ExceededTextLimit));
                }
            }
            catch (SiteOptionNotFoundException)
            {
            }

            // Check 11) check for MinCommentCharacterLength
            try
            {
                //check for option - if not set then it throws exception
                int minCharCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "MinCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(threadPost.Text);
                if (minCharCount != 0 && tmpText.Length < minCharCount)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.MinCharLimitNotReached));
                }
            }
            catch (SiteOptionNotFoundException)
            {
            }

            //strip out invalid chars
            /*
            comment.text = StringUtils.StripInvalidXmlChars(comment.text);            
                        // Check to see if we're doing richtext and check if its valid xml
                        if (comment.PostStyle == PostStyle.Style.unknown)
                        {
            //default to plain text...
                            comment.PostStyle = PostStyle.Style.richtext;
                        }
                        if (comment.PostStyle == PostStyle.Style.richtext)
                        {
                            string errormessage = string.Empty;
                            // Check to make sure that the comment is made of valid XML
                            if (!HtmlUtils.ParseToValidGuideML(comment.text, ref errormessage))
                            {
                                DnaDiagnostics.WriteWarningToLog("Comment box post failed xml parse.", errormessage);
                                throw ApiException.GetError(ErrorType.XmlFailedParse);
                            }
                        }
            */

            // Check 12: Profanities
            bool forceModeration;
            CheckForProfanities(site, threadPost.Text, out forceModeration);


            bool forcePreModeration = false;
            // PreModerate first post in discussion if site premoderatenewdiscussions option set.
            if ((threadPost.InReplyTo == 0) && siteList.GetSiteOptionValueBool(site.SiteID, "Moderation", "PreModerateNewDiscussions"))
            {
                if (!ignoreModeration && !isNotable)
                {
                    forcePreModeration = true;
                }
            }

            // save the Post in the database
            ThreadPost post = new ThreadPost();
            post.InReplyTo = threadPost.InReplyTo;
            post.ThreadId = threadIdAsInt;
            post.Subject = threadPost.Subject;
            post.Text = threadPost.Text;
            post.Style = threadPost.Style;

            post.CreateForumPost(readerCreator, callingUser.UserID, forumIdAsInt, false, isNotable, _iPAddress, bbcUidCookie, false, false, forcePreModeration, forceModeration);
        }

        private static void CheckForProfanities(ISite site, string textToCheck, out bool forceModeration)
        {
            string matchingProfanity;
            forceModeration = false;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, textToCheck,
                                                                                    out matchingProfanity);
            if (ProfanityFilter.FilterState.FailBlock == state)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ProfanityFoundInText));
            }
            if (ProfanityFilter.FilterState.FailRefer == state)
            {
                forceModeration = true;
            }
        }
    }
}






