using System;
using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using BBC.DNA.Moderation.Utils;
using System.Xml.Linq;
using System.Linq;

namespace BBC.Dna.Api
{
    public class Threads : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="dataReaderCreator"></param>
        /// <param name="cacheManager"></param>
        public Threads(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager,siteList)
        {
        }


        /// <summary>
        /// Reads the threads by the UID
        /// </summary>
        /// <returns>The list of threads</returns>
        public ThreadList ThreadsReadByUid(string uid, ISite site)
        {
            ThreadList threads = null;

            if (ThreadsReadByUidFromCache(uid, site, ref threads))
            {
                Statistics.AddHTMLCacheHit();
                return threads;
            }

            Statistics.AddHTMLCacheMiss();

            using (IDnaDataReader reader = CreateReader("ratingthreadsreadbyuid"))
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
        /// <returns>The list of comments for a thread</returns>
        public ThreadInfo ThreadReadById(int threadId, ISite site)
        {
            ThreadInfo thread = null;

            if (ThreadReadByIDFromCache(threadId, site, ref thread))
            {
                return thread;
            }

            thread.id = threadId;
            thread.count = 0;

            return thread;
        }

        private bool ThreadReadByIDFromCache(int threadId, ISite site, ref ThreadInfo thread)
        {
            return false;
            // throw new NotImplementedException();
        }

        /// <summary>
        /// Reads a specific thread by the ID
        /// </summary>
        /// <returns>The list of comments for a thread</returns>
        public CommentsList ThreadCommentsReadById(int threadId, ISite site)
        {
            CommentsList comments = null;

            if (ThreadCommentsReadByIdFromCache(threadId, site, ref comments))
            {
                return comments;
            }

            var commentsObj = new Comments(DnaDiagnostics, DnaDataReaderCreator, CacheManager, SiteList);
            commentsObj.CallingUser = CallingUser;
            commentsObj.BbcUid = BbcUid;
            commentsObj.IpAddress = IpAddress;

            comments = commentsObj.GetCommentsListByThreadId(threadId, site);

            return comments;
        }

        /// <summary>
        /// Creates a threaded comment for the given rating forum id
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="rating">The comment to add</param>
        /// <returns>The created thread object</returns>
        public ThreadInfo ThreadCreate(Forum forum, RatingInfo rating)
        {
            ISite site = SiteList.GetSite(forum.SiteName);
            var threadInfo = new ThreadInfo();
            threadInfo.rating = rating;

            var commentsObj = new Comments(DnaDiagnostics, DnaDataReaderCreator, CacheManager, SiteList);
            commentsObj.CallingUser = CallingUser;
            commentsObj.BbcUid = BbcUid;
            commentsObj.IpAddress = IpAddress;

            bool ignoreModeration;
            bool forceModeration;
            var notes = string.Empty;
            var profanityxml = string.Empty; 

            List<Term> terms = null;

            commentsObj.ValidateComment(forum, rating, site, out ignoreModeration, out forceModeration, out notes, out terms);

            profanityxml = new Term().GetProfanityXML(terms); ;

            //create unique comment hash
            Guid guid = DnaHasher.GenerateCommentHashValue(rating.text, forum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (IDnaDataReader reader = CreateReader("commentthreadcreate"))
                {
                    reader.AddParameter("commentforumid", forum.Id);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", rating.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));
                    reader.AddParameter("ipaddress", IpAddress);
                    reader.AddParameter("bbcuid", BbcUid);
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int) rating.PostStyle);
                    if (!String.IsNullOrEmpty(notes))
                    {
                        reader.AddParameter("modnotes", notes);
                    }
                    if (false == String.IsNullOrEmpty(profanityxml))
                    {
                        reader.AddParameter("profanityxml", profanityxml);
                    }
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
//all good - create comment
                        threadInfo.rating.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        threadInfo.rating.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        threadInfo.rating.hidden = (threadInfo.rating.IsPreModerated
                                                        ? CommentStatus.Hidden.Hidden_AwaitingPreModeration
                                                        : CommentStatus.Hidden.NotHidden);
                        threadInfo.rating.User = commentsObj.UserReadByCallingUser(site);
                        threadInfo.rating.Created = new DateTimeHelper(DateTime.Now);

                        threadInfo.count = reader.GetInt32NullAsZero("ThreadPostCount");

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {
// no id as it is may be pre moderated
                            threadInfo.rating.ID = reader.GetInt32NullAsZero("postid");
                            var replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", threadInfo.rating.ID.ToString());
                            threadInfo.rating.ComplaintUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                                      UriDiscoverability
                                                                                                          .UriType.
                                                                                                          Complaint,
                                                                                                      replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", forum.Id);
                            replacement.Add("sitename", site.SiteName);
                            threadInfo.rating.ForumUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                                  UriDiscoverability.
                                                                                                      UriType.
                                                                                                      CommentForumById,
                                                                                                  replacement);

                            threadInfo.id = reader.GetInt32NullAsZero("ThreadID");
                        }
                        else
                        {
                            threadInfo.rating.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue;
                        reader.TryGetIntReturnValue(out returnValue);
                        Comments.ParseCreateCommentSpError(returnValue);
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
        /// <param name="siteId"></param>
        /// <returns></returns>
        public DateTime ThreadsGetLastUpdate(string uid, int siteId)
        {
            DateTime lastUpdate = DateTime.MinValue;
            //Can use the comment one as it's the thread entries underneath that change

            using (IDnaDataReader reader = CreateReader("CommentforumGetLastUpdate"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", siteId);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
//all good - read threads
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
        /// <param name="threadid"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public DateTime ThreadGetLastUpdate(int threadid, int siteId)
        {
            var commentsObj = new Comments(DnaDiagnostics, DnaDataReaderCreator, CacheManager, SiteList);
            commentsObj.CallingUser = CallingUser;
            commentsObj.BbcUid = BbcUid;
            commentsObj.IpAddress = IpAddress;
            return commentsObj.CommentListGetLastUpdate(threadid, siteId);
        }

        #region Private Functions

        /// <summary>
        /// Returns the comments for a thread from cache
        /// </summary>
        /// <param name="threadid">The id of the thread</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="comments">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool ThreadCommentsReadByIdFromCache(int threadid, ISite site, ref CommentsList comments)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            object tempLastUpdated = CacheManager.GetData(cacheKey + CacheLastupdated);

            if (tempLastUpdated == null)
            {
//not found
                comments = null;
                Statistics.AddCacheMiss();
                return false;
            }
            var lastUpdated = (DateTime) tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, ThreadGetLastUpdate(threadid, site.SiteID)) != 0)
            {
//cache out of date so delete
                DeleteThreadFromCache(threadid, site);
                comments = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            comments = (CommentsList) CacheManager.GetData(cacheKey);
            if (comments == null)
            {
//cache out of date so delete
                DeleteThreadFromCache(threadid, site);
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
        /// <param name="threads"></param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool ThreadsReadByUidFromCache(string uid, ISite site, ref ThreadList threads)
        {
            string cacheKey = ThreadsCacheKey(uid, site.SiteID);
            object tempLastUpdated = CacheManager.GetData(cacheKey + CacheLastupdated);

            if (tempLastUpdated == null)
            {
//not found
                threads = null;
                Statistics.AddCacheMiss();
                return false;
            }
            var lastUpdated = (DateTime) tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, ThreadsGetLastUpdate(uid, site.SiteID)) != 0)
            {
//cache out of date so delete
                DeleteThreadsFromCache(uid, site);
                threads = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            threads = (ThreadList) CacheManager.GetData(cacheKey);
            if (threads == null)
            {
//cache out of date so delete
                DeleteThreadsFromCache(uid, site);
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
        /// <param name="comments"></param>
        /// <param name="site">the site of the forum</param>
        /// <param name="threadid"></param>
        /// <returns>true if found in cache otherwise false</returns>
        private void ThreadAddToCache(int threadid, CommentsList comments, ISite site)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            //ICacheItemExpiration expiry = SlidingTime.
            CacheManager.Add(cacheKey + CacheLastupdated, comments.LastUpdate, CacheItemPriority.Normal,
                             null, new AbsoluteTime(new TimeSpan(0, Cacheexpiryminutes, 0)));

            CacheManager.Add(cacheKey, comments, CacheItemPriority.Normal,
                             null, new AbsoluteTime(new TimeSpan(0, Cacheexpiryminutes, 0)));
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
            CacheManager.Add(cacheKey + CacheLastupdated, threads.LastUpdate, CacheItemPriority.Normal,
                             null, new AbsoluteTime(new TimeSpan(0, Cacheexpiryminutes, 0)));

            CacheManager.Add(cacheKey, threads, CacheItemPriority.Normal,
                             null, new AbsoluteTime(new TimeSpan(0, Cacheexpiryminutes, 0)));
        }

        private ThreadInfo ThreadCreateFromReader(IDnaDataReader reader, ISite site)
        {
            var thread = new ThreadInfo();
            thread.id = reader.GetInt32NullAsZero("ThreadID");
            thread.count = reader.GetInt32NullAsZero("ThreadPostCount");

            var reviewsObj = new Reviews(DnaDiagnostics, DnaDataReaderCreator, CacheManager, SiteList);
            reviewsObj.CallingUser = CallingUser;
            reviewsObj.BbcUid = BbcUid;
            reviewsObj.IpAddress = IpAddress;

            thread.rating = reviewsObj.RatingCreateFromReader(reader, site);

            return thread;
        }

        private ThreadList ThreadsCreateFromReader(IDnaDataReader reader, ISite site)
        {
            var threads = new ThreadList();
            threads.threads = new List<ThreadInfo>();
            threads.TotalCount = 0;
            threads.ratingsSummary = new RatingsSummary();

            threads.ratingsSummary.Total = 0;
            threads.ratingsSummary.Average = 0;

            var replacements = new Dictionary<string, string>();
            replacements.Add("uid", reader.GetStringNullAsEmpty("uid"));
            replacements.Add("sitename", site.SiteName);

            threads.ratingsSummary.Uri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                  UriDiscoverability.UriType.Threads,
                                                                                  replacements);

            do
            {
                ThreadInfo thread = ThreadCreateFromReader(reader, site);
                threads.threads.Add(thread);

                threads.ratingsSummary.Total += thread.rating.rating;

                threads.TotalCount++;
            } while (reader.Read());
            if (threads.TotalCount > 0)
            {
                threads.ratingsSummary.Average = threads.ratingsSummary.Total/threads.TotalCount;
            }

            return threads;
        }

        /// <summary>
        /// Returns cache key for comments in a thread
        /// </summary>
        /// <param name="threadid"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public string ThreadCacheKey(int threadid, int siteId)
        {
            return string.Format("Thread|{0}|{1}|{2}|{3}|{4}|{5}|{6}", threadid, siteId, StartIndex, ItemsPerPage,
                                 SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Returns cache key for threads in a forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public string ThreadsCacheKey(string uid, int siteId)
        {
            return string.Format("Threads|{0}|{1}|{2}|{3}|{4}|{5}|{6}", uid, siteId, StartIndex, ItemsPerPage,
                                 SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Removes thread from cache
        /// </summary>
        /// <param name="threadid"></param>
        /// <param name="site"></param>
        private void DeleteThreadFromCache(int threadid, ISite site)
        {
            string cacheKey = ThreadCacheKey(threadid, site.SiteID);
            CacheManager.Remove(cacheKey + CacheLastupdated);
            CacheManager.Remove(cacheKey);
        }

        /// <summary>
        /// Removes threads from cache
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="site"></param>
        private void DeleteThreadsFromCache(string uid, ISite site)
        {
            string cacheKey = ThreadsCacheKey(uid, site.SiteID);
            CacheManager.Remove(cacheKey + CacheLastupdated);
            CacheManager.Remove(cacheKey);
        }

        #endregion
    }
}