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


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ForumsService : baseService
    {

        public ForumsService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/recentactivity/", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the recent activity in JSON format for a given site")]
        [OperationContract]
        public RecentActivity GetRecentActivity(string siteName)
        {
            ISite site = Global.siteList.GetSite(siteName);
            return RecentActivity.GetSiteRecentActivity(site.SiteID, readerCreator, dnaDiagnostic, cacheManager);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/recentactivity/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the recent activity in XML format for a given site")]
        [OperationContract]
        public RecentActivity GetRecentActivityXML(string siteName)
        {
            return GetRecentActivity(siteName);
        }


        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}", ResponseFormat=WebMessageFormat.Json )]
        [WebHelp(Comment = "Get the forums in JSON format for a given site")]
        [OperationContract]
        public ForumThreads GetForum(string siteName, string forumId)
        {
            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }
            return ForumThreads.CreateForumThreads(cacheManager, readerCreator, Global.siteList,Int32.Parse(forumId),
                        itemsPerPage, startIndex, 0, true, threadOrder, null, false);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the forums in XML format for a given site")]
        [OperationContract]
        public ForumThreads GetForumXml(string siteName, string forumId)
        {
            return GetForum(siteName, forumId);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]
        public ForumThreadPosts GetForumThreads(string siteName, string forumId, string threadId)
        {
            format = WebFormat.format.JSON;
            return GetForumThreadsWithPostXml(siteName, forumId, threadId, "0");

        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]
        public ForumThreadPosts GetForumThreadsXml(string siteName, string forumId, string threadId)
        {
            return GetForumThreadsWithPostXml(siteName, forumId, threadId, "0");
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/post/{postId}", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the thread and posts for a given thread id and specific post id")]
        [OperationContract]
        public ForumThreadPosts GetForumThreadsWithPost(string siteName, string forumId, string threadId, string postId)
        {
            format = WebFormat.format.JSON;
            return GetForumThreadsWithPostXml(siteName, forumId, threadId, postId);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/forums/{forumId}/threads/{threadId}/post/{postId}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the thread and posts for a given thread id")]
        [OperationContract]
        public ForumThreadPosts GetForumThreadsWithPostXml(string siteName, string forumId, string threadId, string postId)
        {
            ISite site = Global.siteList.GetSite(siteName);

            return ForumThreadPosts.CreateThreadPosts(readerCreator, cacheManager, null, siteList, site.SiteID,
                Int32.Parse(forumId), Int32.Parse(threadId), itemsPerPage, startIndex, Int32.Parse(postId), (SortBy.Created == sortBy), false);

        }

    }
}