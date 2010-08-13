using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using System.Runtime.Serialization;
using ISite = BBC.Dna.Sites.ISite;
using BBC.Dna.Common;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "FORUMTHREADS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "FORUMTHREADS")]
    [DataContract (Name="forumThreads")]
    public class ForumThreads : CachableBase<ForumThreads>
    {

        public ForumThreads()
        {
            Thread = new List<ThreadSummary>();
        }

        #region Properties

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "MODERATIONSTATUS")]
        public ModerationStatus ModerationStatus { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("moderationStatus"))]
        public string ModerationStatusValue
        {
            get{ return this.ModerationStatus.Value.ToString();}
            set { }
        }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "ORDERBY")]
        [DataMember(Name = ("sortBy"))]
        public string OrderBy { get; set; }

        /// <remarks/>
        [XmlElement("THREAD", Order = 2)]
        [DataMember(Name = ("threads"))]
        public List<ThreadSummary> Thread { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMID")]
        [DataMember(Name = ("forumId"))]
        public int ForumId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIPTO")]
        [DataMember(Name = ("startIndex"))]
        public int SkipTo { get; set; }

        /// <remarks/>
        [XmlIgnore]
        [DataMember(Name = ("totalCount"))]
        public int Count { get; set; }


        [XmlAttribute(AttributeName = "COUNT")]//this is to support skins who expect the count to be the itemsperpage and not change
        [DataMember(Name = ("itemsPerPage"))]
        public int ItemsPerPage { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTALTHREADS")]
        public int TotalThreads { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMPOSTCOUNT")]
        [DataMember(Name = ("forumPostCount"))]
        public int ForumPostCount { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMPOSTLIMIT")]
        public int ForumPostLimit { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SITEID")]
        [DataMember(Name = ("siteId"))]
        public int SiteId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANREAD")]
        public byte CanRead { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canRead"))]
        public bool CanReadBool
        {
            get { return CanRead == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canWrite"))]
        public bool CanWriteBool
        {
            get { return CanWrite == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "THREADCANREAD")]
        public byte ThreadCanRead { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "THREADCANWRITE")]
        public byte ThreadCanWrite { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "ALERTINSTANTLY")]
        public byte AlertInstantly { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANREAD")]
        public byte DefaultCanRead { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANWRITE")]
        public byte DefaultCanWrite { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "MORE")]
        public string More
        {
            get
            {
                return TotalThreads > SkipTo + ItemsPerPage ? "1" : "0";
            }
            set { }
        }



        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        public int JournalOwner { get; set; }

        /// <summary>
        /// Plumbing for journal owner which is conditional in xml
        /// </summary>
        [XmlAttribute(AttributeName = "JOURNALOWNER")]
        public string JournalOwnerAttribute
        {
            get { return (JournalOwner == 0 ? null : JournalOwner.ToString()); }




        }



        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        [DataMember(Name="lastThreadUpdated")]
        public DateTime LastThreadUpdated { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        [DataMember(Name = "lastForumUpdated")]
        public DateTime LastForumUpdated { get; set; }

        #endregion

        
        /// <summary>
        /// Apply any user settings required. 
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        /// <param name="user">The viewing user</param>
        /// <param name="site">The current site</param>
        public void ApplyUserSettings(IUser user, ISite site)
        {
            if (user == null)
            {
                return;
            }
            bool isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {
//default as editor or super user
                CanRead = 1;
                CanWrite = 1;
                //ripley doesn't grant thread permissions for some reason..
                //ThreadCanRead = 1;
                //ThreadCanWrite = 1;
                isEditor = true;
            }
            //check site is open
            if (!isEditor && CanWrite == 1)
            {
                if (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now))
                {
                    CanWrite = 0;
                }
            }
            //update individual posts
            if (Thread != null)
            {
                foreach (ThreadSummary thread in Thread)
                {
                    thread.ApplyUserSettings(user, site);
                }
            }
        }

        /// <summary>
        /// Checks the forum last updated flag in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            DateTime threadLastUpdate = DateTime.Now;
            DateTime forumLastUpdate = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetforumlastupdate"))
            {
                reader.AddParameter("forumid", ForumId);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    threadLastUpdate = reader.GetDateTime("ThreadLastUpdated");
                    forumLastUpdate = reader.GetDateTime("ForumLastUpdated");
                }
            }
            return threadLastUpdate <= LastThreadUpdated && forumLastUpdate <= LastForumUpdated;
        }

        /// <summary>
        /// Creates forum threads from cache or db
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteList"></param>
        /// <param name="forumId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="threadId"></param>
        /// <param name="overFlow"></param>
        /// <param name="threadOrder"></param>
        /// <param name="viewingUser"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ForumThreads CreateForumThreads(ICacheManager cache, IDnaDataReaderCreator readerCreator,
                                                      ISiteList siteList,
                                                      int forumId, int itemsPerPage, int startIndex, int threadId,
                                                      bool overFlow, ThreadOrder threadOrder, IUser viewingUser,
                                                      bool ignoreCache)
        {
            var forumThreads = new ForumThreads();
            string key = forumThreads.GetCacheKey(forumId,itemsPerPage,startIndex,threadId,overFlow,threadOrder);
           
            if (!ignoreCache)
            {
                var forumThreadsCache = (CachableBase<ForumThreads>)cache.GetData(key);
                if (forumThreadsCache != null && forumThreadsCache.IsUpToDate(readerCreator))
                {
                    forumThreads = (ForumThreads) forumThreadsCache;
                    forumThreads.ApplyUserSettings(viewingUser, siteList.GetSite(forumThreads.SiteId));
                    return forumThreads;
                }
            }
            //create from db
            forumThreads = CreateForumThreadsFromDatabase(readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                          threadId,
                                                          overFlow, threadOrder);

            //add to cache
            cache.Add(key, forumThreads.Clone());

            //apply user settings
            if (viewingUser != null)
            {
                forumThreads.ApplyUserSettings(viewingUser, siteList.GetSite(forumThreads.SiteId));
            }

            return forumThreads;
        }

        /// <summary>
        /// Creates a users forum thread either journal from cache or db
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteList"></param>
        /// <param name="identityusername"></param>
        /// <param name="siteId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="threadId"></param>
        /// <param name="overFlow"></param>
        /// <param name="threadOrder"></param>
        /// <param name="viewingUser"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ForumThreads CreateUsersJournal(ICacheManager cache, IDnaDataReaderCreator readerCreator,
                                                            ISiteList siteList,
                                                            string identityUserName,
                                                            int siteId,
                                                            int itemsPerPage,
                                                            int startIndex, 
                                                            int threadId,
                                                            bool overFlow, 
                                                            ThreadOrder threadOrder, 
                                                            IUser viewingUser, 
                                                            bool byDnaUserId, 
                                                            bool ignoreCache)
        {
            int forumId = GetUsersJournalForumData(readerCreator, identityUserName, siteId, byDnaUserId);

            return CreateForumThreads(cache, readerCreator, siteList, forumId,
                itemsPerPage, startIndex, threadId, overFlow, threadOrder, viewingUser, ignoreCache);
        }



        private static int GetUsersJournalForumData(IDnaDataReaderCreator readerCreator, 
                                                string identityUserName,
                                                int siteId,
                                                bool byDnaUserId)
        {
            int forumId = 0;
            string userSp = String.Empty;
            string paramName = String.Empty;
            int dnaUserId = 0;

            if (byDnaUserId == true)
            {
                userSp = "finduserfromid";
                dnaUserId = Convert.ToInt32(identityUserName);
            }
            else 
            {
                userSp = "finduserfromidentityusername";
            }
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(userSp))
            {
                // Add the identityusername or dnauserid and execute
                if (byDnaUserId == true)
                {
                    reader.AddParameter("userId", dnaUserId);
                }
                else
                {
                    reader.AddParameter("identityusername", identityUserName);
                }

                reader.AddParameter("siteid", siteId);

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
                else
                {
                    forumId = reader.GetInt32NullAsZero("Journal");
                }
            }
            return forumId;
        }

        /// <summary>
        /// Creates the object form the database
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteList"></param>
        /// <param name="forumId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="threadId"></param>
        /// <param name="overFlow"></param>
        /// <param name="threadOrder"></param>
        /// <returns></returns>
        public static ForumThreads CreateForumThreadsFromDatabase(IDnaDataReaderCreator readerCreator,
                                                                  ISiteList siteList, int forumId, int itemsPerPage,
                                                                  int startIndex, int threadId, bool overFlow,
                                                                  ThreadOrder threadOrder)
        {
            //max return count is 200
            itemsPerPage = itemsPerPage > 200 ? 200 : itemsPerPage;
            ISite site = GetSiteForForumId(readerCreator, siteList, forumId, threadId);
            // override startIndex if we want a particular thread
            if (threadId > 0)
            {
                startIndex = GetIndexOfThreadInForum(readerCreator, threadId, forumId, itemsPerPage);
            }
            //setup object
            var threads = new ForumThreads
                              {
                                  ForumId = forumId,
                                  SiteId = site.SiteID,
                                  SkipTo = startIndex,
                                  ItemsPerPage = itemsPerPage
                              };

            //do db call
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("forumgetthreadlist"))
            {
                reader.AddParameter("forumid", forumId);
                reader.AddParameter("threadorder", (int) threadOrder);
                if (overFlow)
                {
                    // We want to fetch the one before the first and the one after the second
                    if (startIndex <= 0)
                    {
                        reader.AddParameter("firstindex", 0);
                        reader.AddParameter("lastindex", itemsPerPage);
                    }
                    else
                    {
                        reader.AddParameter("firstindex", startIndex - 1);
                        reader.AddParameter("lastindex", startIndex + itemsPerPage);
                    }
                }
                else
                {
                    reader.AddParameter("firstindex", startIndex);
                    reader.AddParameter("lastindex", startIndex + itemsPerPage - 1);
                }
                reader.AddParameter("includestickythreads", siteList.GetSiteOptionValueBool(site.SiteID, "Forum", "EnableStickyThreads"));
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    if (reader.DoesFieldExist("JournalOwner"))
                    {
                        threads.JournalOwner = reader.GetInt32NullAsZero("JournalOwner");
                    }
                    threads.TotalThreads = reader.GetInt32NullAsZero("ThreadCount");
                    if (reader.DoesFieldExist("ForumPostCount"))
                    {
                        threads.ForumPostCount = reader.GetInt32NullAsZero("ForumPostCount");
                    }
                    threads.ForumPostLimit = siteList.GetSiteOptionValueInt(site.SiteID, "Forum", "PostLimit");
                    threads.DefaultCanRead = (byte) (reader.GetBoolean("CanRead") ? 1 : 0);
                    threads.DefaultCanWrite = (byte) (reader.GetBoolean("CanWrite") ? 1 : 0);
                    threads.CanRead = (byte) (reader.GetBoolean("CanRead") ? 1 : 0);
                    threads.CanWrite = (byte) (reader.GetBoolean("CanWrite") ? 1 : 0);
                    threads.ThreadCanRead = (byte) (reader.GetBoolean("ThreadCanRead") ? 1 : 0);
                    threads.ThreadCanWrite = (byte) (reader.GetBoolean("ThreadCanWrite") ? 1 : 0);
                    threads.AlertInstantly = (byte) (reader.GetInt32NullAsZero("AlertInstantly") == 1 ? 1 : 0);
                    if (reader.DoesFieldExist("ThreadLastUpdated"))
                    {
                        threads.LastThreadUpdated = reader.GetDateTime("ThreadLastUpdated");
                    }
                    if (reader.DoesFieldExist("ForumLastUpdated"))
                    {
                        threads.LastForumUpdated = reader.GetDateTime("ForumLastUpdated");
                    }
                    
                    threads.ModerationStatus = new ModerationStatus
                                                   {
                                                       Id = forumId,
                                                       Value = reader.GetInt32NullAsZero("ModerationStatus").ToString()
                                                   };
                    threads.OrderBy = threadOrder.ToString().ToLower();

                    if (threads.ForumPostCount > 0)
                    {
//dont bother if no posts
                        threads.Thread = new List<ThreadSummary>();

                        int itemsDisplayed = 0;
                        do
                        {
                            threads.Thread.Add(ThreadSummary.CreateThreadSummaryFromReader(reader, threads.ForumId,
                                                                                           itemsDisplayed));
                            itemsDisplayed++;
                        } while (reader.Read() && itemsDisplayed < itemsPerPage);
                    }
                }
            }

            if(threads.Thread != null)
            {
                threads.Count = threads.Thread.Count;
            }
            return threads;
        }


        /// <summary>
        /// Gets the site for the forumid
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteList"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <returns></returns>
        public static ISite GetSiteForForumId(IDnaDataReaderCreator readerCreator, ISiteList siteList, int forumId,
                                              int threadId)
        {
            ISite site = null;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetForumSiteID"))
            {
                reader.AddParameter("forumid", forumId);
                reader.AddParameter("threadid", threadId);
                reader.Execute();

                if (reader.Read())
                {
                    site = siteList.GetSite(reader.GetInt32NullAsZero("SiteID"));
                }
            }
            if (site == null)
            {
                throw new Exception("Unknown site id");
            }
            return site;
        }

        /// <summary>
        /// Gets the index of the thread within the forum
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <param name="itemsPerPage"></param>
        /// <returns></returns>
        public static int GetIndexOfThreadInForum(IDnaDataReaderCreator readerCreator, int threadId, int forumId,
                                                  int itemsPerPage)
        {
            int startIndex;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getindexofthread"))
            {
                // Add the entry id and execute
                reader.AddParameter("ThreadId", threadId);
                reader.AddParameter("ForumId", forumId);
                reader.Execute();

                int index = 0;
                if (reader.HasRows && reader.Read())
                {
                    index = reader.GetInt32NullAsZero("Index");
                }

                startIndex = index/itemsPerPage;
                startIndex = startIndex*itemsPerPage;
            }
            return startIndex;
        }

        /// <summary>
        /// Works out the skip value for the given thread
        /// </summary>
        /// <param name="threadId"></param>
        public int GetLatestSkipValue(int threadId, int show)
        {
            var threadFound = from t in Thread
                              where t.ThreadId == threadId
                              select t;

            if (threadFound.Count() == 0)
            {
                return 0;
            }

            var thread = threadFound.First();

            int pages = thread.TotalPosts / show;
            int mod = thread.TotalPosts % show;
            if (pages > 0 && mod ==0)
            {
                pages--;
            }
            return pages * show;

        }
    }


    public enum ThreadOrder
    {
        LatestPost = 1,
        CreateDate = 2
    }
}