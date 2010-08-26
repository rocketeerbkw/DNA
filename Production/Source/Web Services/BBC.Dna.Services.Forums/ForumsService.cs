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
            return GetOutputStream(ForumThreads.CreateForumThreads(cacheManager, readerCreator, Global.siteList,Int32.Parse(forumId),
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
        [WebHelp(Comment = "Get the thread and posts for a given thread id and specific post id")]
        [OperationContract]
        public Stream GetForumThreadsWithPost(string siteName, string forumId, string threadId, string postId)
        {
            ISite site = Global.siteList.GetSite(siteName);

            return GetOutputStream(ForumThreadPosts.CreateThreadPosts(readerCreator, cacheManager, null, siteList, site.SiteID,
                Int32.Parse(forumId), Int32.Parse(threadId), itemsPerPage, startIndex, Int32.Parse(postId), (SortBy.Created == sortBy), false));
        }
    }
}