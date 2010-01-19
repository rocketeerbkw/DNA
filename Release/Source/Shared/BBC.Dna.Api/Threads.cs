using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Data.Objects;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Data;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;


namespace BBC.Dna.Api
{
    public class Threads : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Threads(IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        {}

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public Threads()
        { }

        /// <summary>
        /// Reads the threads by the UID
        /// </summary>
        /// <param name="uId">The specific forum id</param>
        /// <returns>The list of threads</returns>
        public ThreadList ThreadsReadByUID(string uid, ISite site)
        {
            ThreadList threads = null;

            if (ThreadsReadByUIDFromCache(uid, site, ref threads))
            {
                Statistics.AddHTMLCacheHit();
                return threads;
            }

            Statistics.AddHTMLCacheMiss();

            using (StoredProcedureReader reader = CreateReader("ratingthreadsreadbyuid"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", site.SiteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        threads = ThreadsCreateFromReader(reader, site);
                        ThreadsAddToCache(threads, uid, site);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }

            return threads;
        }

        /// <summary>
        /// Reads a specific thread by the ID
        /// </summary>
        /// <param name="id">The specific thread id</param>
        /// <returns>The list of comments for a thread</returns>
        public ThreadInfo ThreadReadByID(int threadID, ISite site)
        {
            ThreadInfo thread = null;

            if (ThreadReadByIDFromCache(threadID, site, ref thread))
            {
                return thread;
            }

            thread.id = threadID;
            thread.count = 0;

            return thread;
        }

        private bool ThreadReadByIDFromCache(int threadID, ISite site, ref ThreadInfo thread)
        {
            return false;
           // throw new NotImplementedException();
        }

        /// <summary>
        /// Reads a specific thread by the ID
        /// </summary>
        /// <param name="id">The specific thread id</param>
        /// <returns>The list of comments for a thread</returns>
        public CommentsList ThreadCommentsReadByID(int threadID, ISite site)
        {
            CommentsList comments = null;

            if (ThreadCommentsReadByIDFromCache(threadID, site, ref comments))
            {
                return comments;
            }

            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;

            comments = commentsObj.CommentsReadByThreadID(threadID, site);

            return comments;
        }

        /// <summary>
        /// Creates a threaded comment for the given rating forum id
        /// </summary>
        /// <param name="ratingForum">The forum to post to</param>
        /// <param name="rating">The comment to add</param>
        /// <returns>The created thread object</returns>
        public ThreadInfo ThreadCreate(Forum forum, RatingInfo rating)
        {
            ISite site = siteList.GetSite(forum.SiteName);
            ThreadInfo threadInfo = new ThreadInfo();
            threadInfo.rating = rating;

            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;

            bool ignoreModeration;
            bool forceModeration;

            commentsObj.ValidateCommentCreate(forum, (CommentInfo) rating, site, out ignoreModeration, out forceModeration);

            //create unique comment hash
            Guid guid = DnaHasher.GenerateCommentHashValue(rating.text, forum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (StoredProcedureReader reader = CreateReader("commentthreadcreate"))
                {
                    reader.AddParameter("commentforumid", forum.Id);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", rating.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));
                    reader.AddParameter("ipaddress", IPAddress);
                    if (!String.IsNullOrEmpty(BBCUid))
                    {
                        Guid BBCUIDGUID = new Guid();
                        if (ApiCookies.CheckGUIDCookie(BBCUid, ref BBCUIDGUID))
                        {
                            reader.AddParameter("bbcuid", BBCUIDGUID);
                        }
                    }
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int)rating.PostStyle);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {//all good - create comment
                        threadInfo.rating.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        threadInfo.rating.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        threadInfo.rating.hidden = (threadInfo.rating.IsPreModerated ? CommentStatus.Hidden.Hidden_AwaitingPreModeration : CommentStatus.Hidden.NotHidden);
                        threadInfo.rating.text = Comments.FormatCommentText(threadInfo.rating.text, threadInfo.rating.hidden, threadInfo.rating.PostStyle);
                        threadInfo.rating.User = commentsObj.UserReadByCallingUser();
                        threadInfo.rating.Created = new DateTimeHelper(DateTime.Now);

                        threadInfo.count = reader.GetInt32NullAsZero("ThreadPostCount");

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {// no id as it is may be pre moderated
                            threadInfo.rating.ID = reader.GetInt32NullAsZero("postid");
                            Dictionary<string, string> replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", threadInfo.rating.ID.ToString());
                            threadInfo.rating.ComplaintUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Complaint, replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", forum.Id);
                            replacement.Add("sitename", site.SiteName);
                            threadInfo.rating.ForumUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentForumByID, replacement);

                            threadInfo.id = reader.GetInt32NullAsZero("ThreadID");
                        }
                        else
                        {
                            threadInfo.rating.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue = 0;
                        reader.TryGetIntReturnValue(out returnValue);
                        Comments.ParseCreateCommentSPError(returnValue);
                    }
                }
            }
            catch (ApiException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
            }

            threadInfo.rating = rating;


            //return new thread with rating and comment complete with id etc
            return threadInfo;
        }

        /// <summary>
        /// Returns last update of threads for a uid
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime ThreadsGetLastUpdate(string uid, int siteID)
        {
            DateTime lastUpdate = DateTime.MinValue;
            //Can use the comment one as it's the thread entries underneath that change

            using (StoredProcedureReader reader = CreateReader("CommentforumGetLastUpdate"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", siteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {//all good - read threads
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch
                {
                }
            }

            return lastUpdate;
        }


        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime ThreadGetLastUpdate(int threadid, int siteID)
        {
            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;
            return commentsObj.CommentListGetLastUpdate(threadid, siteID);
        }

        #region Private Functions

        /// <summary>
        /// Returns the comments for a thread from cache
        /// </summary>
        /// <param name="threadid">The id of the thread</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="comments">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool ThreadCommentsReadByIDFromCache(int threadid, ISite site, ref CommentsList comments)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);
            
            if (tempLastUpdated == null)
            {//not found
                comments = null;
                Statistics.AddCacheMiss();
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, ThreadGetLastUpdate(threadid, site.SiteID)) != 0 )
            {//cache out of date so delete
                DeleteThreadFromCache(threadid, site);
                comments = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            comments = (CommentsList)_cacheManager.GetData(cacheKey);
            if (comments == null)
            {//cache out of date so delete
                DeleteThreadFromCache(threadid, site);
                comments = null;
                Statistics.AddCacheMiss();
                return false;
            }
            Statistics.AddCacheHit();

            //re-add to cache to add sliding window affect
            ThreadAddToCache(threadid, comments, site);
            return true;
        }

        /// <summary>
        /// Returns the threads for a forum from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="comments">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool ThreadsReadByUIDFromCache(string uid, ISite site, ref ThreadList threads)
        {
            string cacheKey = ThreadsCacheKey(uid, site.SiteID);
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);

            if (tempLastUpdated == null)
            {//not found
                threads = null;
                Statistics.AddCacheMiss();
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, ThreadsGetLastUpdate(uid, site.SiteID)) != 0)
            {//cache out of date so delete
                DeleteThreadsFromCache(uid, site);
                threads = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            threads = (ThreadList)_cacheManager.GetData(cacheKey);
            if (threads == null)
            {//cache out of date so delete
                DeleteThreadsFromCache(uid, site);
                threads = null;
                Statistics.AddCacheMiss();
                return false;
            }
            Statistics.AddCacheHit();

            //re-add to cache to add sliding window affect
            ThreadsAddToCache(threads, uid, site);
            return true;
        }

        /// <summary>
        /// Returns the thread from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void ThreadAddToCache(int threadid, CommentsList comments, ISite site)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            //ICacheItemExpiration expiry = SlidingTime.
            _cacheManager.Add(cacheKey + CACHE_LASTUPDATED, comments.LastUpdate, CacheItemPriority.Normal,
                null, new AbsoluteTime(new TimeSpan(0, CACHEEXPIRYMINUTES, 0)));

            _cacheManager.Add(cacheKey, comments, CacheItemPriority.Normal,
                null, new AbsoluteTime(new TimeSpan(0, CACHEEXPIRYMINUTES, 0)));
        }

        /// <summary>
        /// Returns the thread list from cache
        /// </summary>
        /// <param name="threads">List of threads</param>
        /// <param name="uid">Uid of the forumss</param>
        /// <param name="site">the site of the forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void ThreadsAddToCache(ThreadList threads, string uid, ISite site)
        {
            string cacheKey = ThreadsCacheKey(uid, site.SiteID);
            //ICacheItemExpiration expiry = SlidingTime.
            _cacheManager.Add(cacheKey + CACHE_LASTUPDATED, threads.LastUpdate, CacheItemPriority.Normal,
                null, new AbsoluteTime(new TimeSpan(0, CACHEEXPIRYMINUTES, 0)));

            _cacheManager.Add(cacheKey, threads, CacheItemPriority.Normal,
                null, new AbsoluteTime(new TimeSpan(0, CACHEEXPIRYMINUTES, 0)));
        }

        private ThreadInfo ThreadCreateFromReader(StoredProcedureReader reader, ISite site)
        {
            ThreadInfo thread = new ThreadInfo();
            thread.id = reader.GetInt32NullAsZero("ThreadID");
            thread.count = reader.GetInt32NullAsZero("ThreadPostCount");

            Reviews reviewsObj = new Reviews();
            reviewsObj.CallingUser = CallingUser;
            reviewsObj.BBCUid = BBCUid;
            reviewsObj.IPAddress = IPAddress;
            reviewsObj.siteList = siteList;

            thread.rating = reviewsObj.RatingCreateFromReader(reader, site);

            return thread;
        }

        private ThreadList ThreadsCreateFromReader(StoredProcedureReader reader, ISite site)
        {
            ThreadList threads = new ThreadList();
            threads.threads = new List<ThreadInfo>();
            threads.TotalCount = 0;
            threads.ratingsSummary = new RatingsSummary();

            threads.ratingsSummary.Total = 0;
            threads.ratingsSummary.Average = 0;

            Dictionary<string, string> replacements = new Dictionary<string, string>();
            replacements.Add("uid", reader.GetStringNullAsEmpty("uid"));
            replacements.Add("sitename", site.SiteName);

            threads.ratingsSummary.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Threads, replacements);

            do
            {
                ThreadInfo thread = ThreadCreateFromReader(reader, site);
                threads.threads.Add(thread);

                threads.ratingsSummary.Total += thread.rating.rating;

                threads.TotalCount++;
            } while (reader.Read());
            if (threads.TotalCount > 0)
            {
                threads.ratingsSummary.Average = threads.ratingsSummary.Total / threads.TotalCount;
            }

            return threads;
        }

        /// <summary>
        /// Returns cache key for comments in a thread
        /// </summary>
        /// <param name="threadid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public string ThreadCacheKey(int threadid, int siteID)
        {
            return string.Format("Thread|{0}|{1}|{2}|{3}|{4}|{5}|{6}", threadid, siteID, StartIndex, ItemsPerPage, SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Returns cache key for threads in a forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public string ThreadsCacheKey(string uid, int siteID)
        {
            return string.Format("Threads|{0}|{1}|{2}|{3}|{4}|{5}|{6}", uid, siteID, StartIndex, ItemsPerPage, SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Removes thread from cache
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="site"></param>
        private void DeleteThreadFromCache(int threadid, ISite site)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            _cacheManager.Remove(cacheKey + CACHE_LASTUPDATED);
            _cacheManager.Remove(cacheKey);
        }

        /// <summary>
        /// Removes threads from cache
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="site"></param>
        private void DeleteThreadsFromCache(string uid, ISite site)
        {
            string cacheKey = ThreadsCacheKey(uid, site.SiteID);
            _cacheManager.Remove(cacheKey + CACHE_LASTUPDATED);
            _cacheManager.Remove(cacheKey);
        }
        #endregion

    }
}
