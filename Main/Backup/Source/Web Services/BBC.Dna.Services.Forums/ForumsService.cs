﻿using System;
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
using BBC.DNA.Moderation.Utils;
using System.Collections.Generic;
using BBC.Dna.Common;


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
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }
            return GetOutputStream(ForumThreads.CreateForumThreads(cacheManager, readerCreator, Global.siteList, Int32.Parse(forumId),
                        itemsPerPage, startIndex, 0, true, threadOrder, null, false, applySkin));
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadid}/forumsource")]
        [WebHelp(Comment = "Get the forum source for a given forum id, thread id and site")]
        [OperationContract]
        public Stream GetForumSource(string siteName, string forumId, string threadId)
        {
            ISite site = Global.siteList.GetSite(siteName);

            ForumSource forumSource = ForumSource.CreateForumSource(cacheManager,
                                                                readerCreator,
                                                                null,
                                                                Int32.Parse(forumId),
                                                                Int32.Parse(threadId),
                                                                site.SiteID,
                                                                true,
                                                                false,
                                                                true);
            if (forumSource == null)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumOrThreadNotFound));
            }

            return GetOutputStream(forumSource);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/reviewforums/{reviewForumId}")]
        [WebHelp(Comment = "Get the review forum")]
        [OperationContract]
        public Stream GetReviewForum(string siteName, string reviewForumId)
        {
            ISite site = Global.siteList.GetSite(siteName);
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }

            ReviewForumPage reviewForumPage = null;

            try
            {
                int reviewForumIdInt = 0;
                Int32.TryParse(reviewForumId, out reviewForumIdInt);
                if (reviewForumIdInt > 0)
                {
                    reviewForumPage = ReviewForumPage.CreateReviewForumPage(cacheManager,
                                                                            readerCreator,
                                                                            Global.siteList,
                                                                            null,
                                                                            reviewForumIdInt,
                                                                            site.SiteID,
                                                                            true,
                                                                            itemsPerPage,
                                                                            startIndex,
                                                                            threadOrder,
                                                                            true,
                                                                            applySkin);
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumOrThreadNotFound));
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(reviewForumPage);
        }


        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}")]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]
        public Stream GetForumThreads(string siteName, string forumId, string threadId)
        {
            return GetForumThreadsWithPost(siteName, forumId, threadId, "0");
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/post/{postId}")]
        [WebHelp(Comment = "Get the thread and post for a given thread id and post")]
        [OperationContract]        
        public Stream GetForumThreadsWithPost(string siteName, string forumId, string threadId, string postId)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);
            
            ISite site = Global.siteList.GetSite(siteName);

            ForumThreadPosts forumThreadPosts = null;

            CallingUser callingUser = null;
            try
            {
                callingUser = GetCallingUser(site);
            }
            catch (DnaWebProtocolException)
            {
                callingUser = null;
            }

            int fourmIdInt = Int32.Parse(forumId);
            int threadIdInt = Int32.Parse(threadId);

            forumThreadPosts = ForumThreadPosts.CreateThreadPostsByCallingUser(readerCreator, cacheManager, callingUser, siteList, site.SiteID,
                Int32.Parse(forumId), Int32.Parse(threadId), itemsPerPage, startIndex, Int32.Parse(postId), (SortBy.Created == sortBy), false, applySkin);
            
            try
            {
                if (callingUser.UserID > 0)
                {
                    //get subscriptions
                    SubscribeState subscribeState = SubscribeState.GetSubscriptionState(readerCreator,
                                                                                        callingUser.UserID,
                                                                                        threadIdInt, 
                                                                                        fourmIdInt);

                    if (subscribeState != null && subscribeState.Thread != 0 && forumThreadPosts != null && forumThreadPosts.Post.Count > 0)
                    {
                        //update the last read post if the user is subscribed, increment by 1 because its a 0 based index
                        if (subscribeState.LastPostCountRead < forumThreadPosts.Post[forumThreadPosts.Post.Count - 1].Index + 1)
                        {
                            ForumHelper forumHelper = new ForumHelper(readerCreator);

                            forumHelper.MarkThreadRead(callingUser.UserID, threadIdInt,
                                                        forumThreadPosts.Post[forumThreadPosts.Post.Count - 1].Index + 1, true);
                        }
                    }

                }
            }
            catch
            {
            }

            return GetOutputStream(forumThreadPosts);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/posts/{postId}")]
        [WebHelp(Comment = "Gets a thread post by id")]
        [OperationContract]
        public Stream GetThreadPost(string siteName, string postId)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

            int postIdAsInt = Convert.ToInt32(postId);
            Stream output;
            ThreadPost returnedPost = null;
            ISite site = GetSite(siteName);
            try
            {
                returnedPost = ThreadPost.FetchPostFromDatabase(readerCreator, postIdAsInt, applySkin);
                output = GetOutputStream(returnedPost);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;
        }
        [WebGet(UriTemplate = "V1/site/{siteName}/threads/{threadId}")]
        [WebHelp(Comment = "Gets a thread by id")]
        [OperationContract]
        public Stream GetThread(string siteName, string threadId)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

            int threadIdAsInt = Convert.ToInt32(threadId);
            Stream output;
            ForumThreadPosts returnedThread = null;
            ISite site = GetSite(siteName);
            try
            {
                ForumSource forumSource = ForumSource.CreateForumSource(cacheManager,
                                                                    readerCreator,
                                                                    null,
                                                                    0,
                                                                    Int32.Parse(threadId),
                                                                    site.SiteID,
                                                                    true,
                                                                    false,
                                                                    true);
                if (forumSource == null)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ForumOrThreadNotFound));
                }

                
                returnedThread = ForumThreadPosts.CreateThreadPosts(readerCreator, cacheManager, null, siteList, site.SiteID,
                forumSource.ActualForumId, Int32.Parse(threadId), itemsPerPage, startIndex, 0, (SortBy.Created == sortBy), false, applySkin);
                output = GetOutputStream(returnedThread);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/posts/{postId}/hide")]
        [WebHelp(Comment = "Hides a thread post by id")]
        [OperationContract]
        public void HidePost(string siteName, string postId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || !(callingUser.IsUserA(UserTypes.Editor) || callingUser.IsUserA(UserTypes.SuperUser)))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            int postIdInt = 0;
            Int32.TryParse(postId, out postIdInt);

            try
            {
                ThreadPost.HideThreadPost(readerCreator, postIdInt, BBC.Dna.Moderation.Utils.CommentStatus.Hidden.Removed_FailedModeration);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/create.htm")]
        [WebHelp(Comment = "Creates a new thread and 1st post from Html form")]
        [OperationContract]
        public ThreadPost CreateThreadHtml(string siteName, string forumId, NameValueCollection formsData)
        {
            return CreateThreadPostHtml(siteName, forumId, "0", formsData);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads")]
        [WebHelp(Comment = "Creates a new thread and 1st post")]
        [OperationContract]
        public ThreadPost CreateThread(string siteName, string forumId, ThreadPost threadPost)
        {
            return CreateThreadPost(siteName, forumId, "0", threadPost);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/{threadid}/create.htm")]
        [WebHelp(Comment = "Creates a thread post from Html form")]
        [OperationContract]
        public ThreadPost CreateThreadPostHtml(string siteName, string forumId, string threadId, NameValueCollection formsData)
        {
            ThreadPost post = new ThreadPost();
            post.InReplyTo = Convert.ToInt32(formsData["inReplyTo"]);
            post.ThreadId = Convert.ToInt32(threadId);
            post.Subject = formsData["subject"];
            post.Text = formsData["text"];
            post.Style = (BBC.Dna.Objects.PostStyle.Style)Enum.Parse(typeof(BBC.Dna.Objects.PostStyle.Style), formsData["style"]);

            return CreateThreadPost(siteName, forumId, threadId, post);                                               
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumid}/threads/{threadid}")]
        [WebHelp(Comment = "Creates a thread post")]
        [OperationContract]
        public ThreadPost CreateThreadPost(string siteName, string forumId, string threadId, ThreadPost threadPost)
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
            int threadIdAsInt = 0;
            if (!Int32.TryParse(threadId, out threadIdAsInt))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidThreadID));
            }


            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            bool requireSecurePost = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "EnforceSecurePosting") == 1;
            if (requireSecurePost && !callingUser.IsSecureRequest)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotSecure));
            }

            // Check 3) check threadid is well formed
            
            ForumHelper helper = new ForumHelper(readerCreator);

            
            // save the Post in the database
            threadPost.ThreadId = threadIdAsInt;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, (Objects.User)callingUser, siteList, _iPAddress, bbcUidCookie, forumIdAsInt);
            }
            catch (ApiException e)
            {
                throw new DnaWebProtocolException(e);
            }

            return threadPost;
        }

        [WebInvoke(Method = "GET", UriTemplate = "V1/site/{siteName}/searchposts")]
        [WebHelp(Comment = "Searches and returns posts within the site")]
        [OperationContract]
        public Stream SearchThreadPost(string siteName)
        {
            return SearchThreadPostWithForum(siteName, "0");
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/subscribe")]
        [WebHelp(Comment = "Subscribes to the given forum for a given site")]
        [OperationContract]
        public Stream SubscribeToForum(string siteName, string forumId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            Stream output = null;
            try
            {
                int forumIdInt = Int32.Parse(forumId);

                SubscribeResult subscribeResult = SubscribeResult.SubscribeToForum(readerCreator, callingUser.UserID, forumIdInt, false);
                if (subscribeResult.Failed == 3)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
                }

                output = GetOutputStream(subscribeResult);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/unsubscribe")]
        [WebHelp(Comment = "Unsubscribes from the given forum for a given site")]
        [OperationContract]
        public Stream UnsubscribeFromForum(string siteName, string forumId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            Stream output = null;
            try
            {
                int forumIdInt = Int32.Parse(forumId);

                SubscribeResult subscribeResult = SubscribeResult.SubscribeToForum(readerCreator, callingUser.UserID, forumIdInt, true);
                if (subscribeResult.Failed == 3)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
                }

                output = GetOutputStream(subscribeResult);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;

        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/subscribe")]
        [WebHelp(Comment = "Subscribes to the given thread for a given site")]
        [OperationContract]
        public Stream SubscribeToThread(string siteName, string forumId, string threadId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            Stream output = null;
            try
            {
                int forumIdInt = Int32.Parse(forumId);
                int threadIdInt = Int32.Parse(threadId);

                SubscribeResult subscribeResult = SubscribeResult.SubscribeToThread(readerCreator, callingUser.UserID, threadIdInt, forumIdInt, false);
                if (subscribeResult.Failed == 5)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
                }

                output = GetOutputStream(subscribeResult);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/unsubscribe")]
        [WebHelp(Comment = "Unsubscribes from the given thread for a given site")]
        [OperationContract]
        public Stream UnsubscribeFromThread(string siteName, string forumId, string threadId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            Stream output = null;
            try
            {
                int forumIdInt = Int32.Parse(forumId);
                int threadIdInt = Int32.Parse(threadId);

                SubscribeResult subscribeResult = SubscribeResult.SubscribeToThread(readerCreator, callingUser.UserID, threadIdInt, forumIdInt, true);
                if (subscribeResult.Failed == 5)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
                }

                output = GetOutputStream(subscribeResult);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;

        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/hide")]
        [WebHelp(Comment = "Hides given thread for a given site")]
        [OperationContract]
        public void HideThread(string siteName, string forumId, string threadId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || !callingUser.IsUserA(UserTypes.SuperUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            try
            {
                int forumIdInt = Int32.Parse(forumId);
                int threadIdInt = Int32.Parse(threadId);
                ForumHelper forumHelper = new ForumHelper(readerCreator);

                forumHelper.HideThreadWithCallingUser(forumIdInt, threadIdInt, callingUser);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/unhide")]
        [WebHelp(Comment = "Unhides/Reopens given thread for a given site")]
        [OperationContract]
        public void UnhideThread(string siteName, string forumId, string threadId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || !callingUser.IsUserA(UserTypes.SuperUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            try
            {
                int forumIdInt = Int32.Parse(forumId);
                int threadIdInt = Int32.Parse(threadId);
                ForumHelper forumHelper = new ForumHelper(readerCreator);

                forumHelper.ReOpenThreadWithCallingUser(forumIdInt, threadIdInt, callingUser);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/close")]
        [WebHelp(Comment = "Closes given thread for a given site")]
        [OperationContract]
        public void CloseThread(string siteName, string forumId, string threadId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || !callingUser.IsUserA(UserTypes.SuperUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            try
            {
                int forumIdInt = Int32.Parse(forumId);
                int threadIdInt = Int32.Parse(threadId);
                ForumHelper forumHelper = new ForumHelper(readerCreator);

                forumHelper.CloseThreadWithCallingUser(site.SiteID, forumIdInt, threadIdInt, callingUser, siteList);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        //[WebInvoke(Method = "GET", UriTemplate = "V1/site/{siteName}/forum/{forumId}/searchposts")]
        //[WebHelp(Comment = "Searches and returns posts within the site and forum")]
        //[OperationContract]
        public Stream SearchThreadPostWithForum(string siteName, string forumId)
        {
            ISite site = GetSite(siteName);
            Stream output = null;
            try
            {
                int forumInt = Int32.Parse(forumId);
                var searchText = QueryStringHelper.GetQueryParameterAsString("query", "");
                var searchResults = SearchThreadPosts.GetSearchThreadPosts(readerCreator, cacheManager, site,
                    forumInt, 0, itemsPerPage, startIndex, searchText, false);
                output = GetOutputStream(searchResults);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return output;
        }

        private static void CheckForProfanities(ISite site, string textToCheck, out bool forceModeration)
        {
            string matchingProfanity;
            forceModeration = false;
            List<Term> terms = null;
            int forumID = 0;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, textToCheck,
                                                                                    out matchingProfanity, out terms, forumID);
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






