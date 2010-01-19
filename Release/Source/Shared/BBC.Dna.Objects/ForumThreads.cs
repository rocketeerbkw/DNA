using BBC.Dna.Data;
using BBC.Dna.Sites;
using System;
using System.Xml.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
namespace BBC.Dna.Objects
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="FORUMTHREADS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="FORUMTHREADS")]
    public partial class ForumThreads : ICloneable
    {

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "MODERATIONSTATUS")]
        public ModerationStatus ModerationStatus
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "ORDERBY")]
        public string OrderBy
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("THREAD", Order = 2)]
        public System.Collections.Generic.List<ThreadSummary> Thread
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "SKIPTO")]
        public int SkipTo
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "COUNT")]
        public int Count
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOTALTHREADS")]
        public int TotalThreads
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUMPOSTCOUNT")]
        public int ForumPostCount
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUMPOSTLIMIT")]
        public int ForumPostLimit
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "SITEID")]
        public int SiteId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "CANREAD")]
        public byte CanRead
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREADCANREAD")]
        public byte ThreadCanRead
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREADCANWRITE")]
        public byte ThreadCanWrite
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ALERTINSTANTLY")]
        public byte AlertInstantly
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "DEFAULTCANREAD")]
        public byte DefaultCanRead
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "DEFAULTCANWRITE")]
        public byte DefaultCanWrite
        {
            get;
            set;
        }

        /// <summary>
        /// Plumbing for journal owner which is conditional in xml
        /// </summary>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "JOURNALOWNER")]
        protected string JournalOwnerAttribute
        {
            get { return (JournalOwner == 0 ? null : JournalOwner.ToString()); }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "MORE")]
        public string More
        {
            get;
            set;
        }


        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        public int JournalOwner
        {
            get;
            set;
        }
        
        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        public DateTime LastThreadUpdated
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        public DateTime LastForumUpdated
        {
            get;
            set;
        }
        #endregion

        /// <summary>
        /// Apply any user settings required. 
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        /// <param name="user">The viewing user</param>
        /// <param name="site">The current site</param>
        public void ApplyUserSettings(IUser user, ISite site)
        {
            bool isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {//default as editor or super user
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
        public bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            // note sure if this is a accurate or useful cache test...
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
        static public ForumThreads CreateForumThreads(ICacheManager cache, IDnaDataReaderCreator readerCreator, ISiteList siteList, 
            int forumId, int itemsPerPage, int startIndex, int threadId, bool overFlow, ThreadOrder threadOrder, IUser viewingUser, bool ignoreCache)
        {
            string key = GetCacheKey(forumId, itemsPerPage, startIndex, threadId, overFlow, threadOrder);
            ForumThreads forumThreads = null;
            if (!ignoreCache)
            {
                forumThreads = (ForumThreads)cache.GetData(key);
                if (forumThreads != null && forumThreads.IsUpToDate(readerCreator))
                {
                    forumThreads.ApplyUserSettings(viewingUser, siteList.GetSite(forumThreads.SiteId));
                    return forumThreads;
                }
            }
            //create from db
            forumThreads = CreateForumThreadsFromDatabase(readerCreator, siteList, forumId, itemsPerPage, startIndex, threadId,
                overFlow, threadOrder);

            //add to cache
            cache.Add(key, forumThreads.Clone());
            
            //apply user settings
            forumThreads.ApplyUserSettings(viewingUser, siteList.GetSite(forumThreads.SiteId));

            return forumThreads;
        }

        /// <summary>
        /// Creates the cache key for the given elements
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="threadId"></param>
        /// <param name="overFlow"></param>
        /// <param name="threadOrder"></param>
        /// <returns></returns>
        static public string GetCacheKey(int forumId, int itemsPerPage, int startIndex, int threadId, bool overFlow, ThreadOrder threadOrder)
        {
            return typeof(ForumThreads).AssemblyQualifiedName + "|" + forumId.ToString() + "|" + itemsPerPage + "|" + startIndex + "|" +
                threadId.ToString() + "|" + overFlow.ToString() + "|" + threadOrder.ToString();
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
        static public ForumThreads CreateForumThreadsFromDatabase(IDnaDataReaderCreator readerCreator, ISiteList siteList, int forumId, int itemsPerPage,
            int startIndex, int threadId, bool overFlow, ThreadOrder threadOrder)
        {
            //max return count is 200
            itemsPerPage = itemsPerPage > 200 ? 200 : itemsPerPage;
            ISite site = ForumThreads.GetSiteForForumId(readerCreator, siteList, forumId, threadId);
            // override startIndex if we want a particular thread
            if (threadId > 0)
            {
                startIndex = ForumThreads.GetIndexOfThreadInForum(readerCreator, threadId, forumId, itemsPerPage);
            }
            //setup object
            ForumThreads threads = new ForumThreads()
            {
                ForumId = forumId,
                SiteId = site.SiteID,
                SkipTo = startIndex,
                Count = itemsPerPage
            };

            //do db call
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("forumgetthreadlist"))
            {
                reader.AddParameter("forumid", forumId);
                reader.AddParameter("threadorder", (int)threadOrder);
                
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
                        reader.AddParameter("firstindex", startIndex-1);
                        reader.AddParameter("lastindex", startIndex+itemsPerPage);
                    }
                }
                else
                {
                    reader.AddParameter("firstindex", startIndex);
                    reader.AddParameter("lastindex", startIndex + itemsPerPage-1);
                }
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    if(reader.DoesFieldExist("JournalOwner"))
                    {
                        threads.JournalOwner = reader.GetInt32NullAsZero("JournalOwner");
                    }
                    threads.TotalThreads = reader.GetInt32NullAsZero("ThreadCount");
                    if (reader.DoesFieldExist("ForumPostCount"))
                    {
                        threads.ForumPostCount = reader.GetInt32NullAsZero("ForumPostCount");
                    }
                    threads.ForumPostLimit = siteList.GetSiteOptionValueInt(site.SiteID, "Forum", "PostLimit");
                    threads.DefaultCanRead = (byte)(reader.GetBoolean("CanRead") ? 1 : 0);
                    threads.DefaultCanWrite = (byte)(reader.GetBoolean("CanWrite") ? 1 : 0);
                    threads.CanRead = (byte)(reader.GetBoolean("CanRead") ? 1 : 0);
                    threads.CanWrite = (byte)(reader.GetBoolean("CanWrite") ? 1 : 0);
                    threads.ThreadCanRead = (byte)(reader.GetBoolean("ThreadCanRead") ? 1 : 0);
                    threads.ThreadCanWrite = (byte)(reader.GetBoolean("ThreadCanWrite") ? 1 : 0);
                    threads.AlertInstantly = (byte)(reader.GetInt32NullAsZero("AlertInstantly") == 1 ? 1:0);
                    if (reader.DoesFieldExist("ThreadLastUpdated"))
                    {
                        threads.LastThreadUpdated = reader.GetDateTime("ThreadLastUpdated");
                    }
                    if (reader.DoesFieldExist("ForumLastUpdated"))
                    {
                        threads.LastForumUpdated = reader.GetDateTime("ForumLastUpdated");
                    }
                    if (threads.TotalThreads > (startIndex + itemsPerPage))
                    {
                        threads.More = "1";
                    }
                    threads.ModerationStatus = new ModerationStatus()
                    {
                        Id = forumId,
                        Value = reader.GetInt32NullAsZero("ModerationStatus").ToString()
                    };
                    threads.OrderBy = threadOrder.ToString().ToLower();

                    if (threads.ForumPostCount > 0)
                    {//dont bother if no posts
                        threads.Thread = new System.Collections.Generic.List<ThreadSummary>();

                        int itemsDisplayed = 0;
                        do
                        {
                            threads.Thread.Add(ThreadSummary.CreateThreadSummaryFromReader(reader, threads.ForumId, itemsDisplayed));
                            itemsDisplayed++;
                        } while (reader.Read() && itemsDisplayed < itemsPerPage);
                    }
                }
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
        static public ISite GetSiteForForumId(IDnaDataReaderCreator readerCreator, ISiteList siteList, int forumId, int threadId)
        {
            ISite site = null;
            using(IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetForumSiteID"))
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
        static public int GetIndexOfThreadInForum(IDnaDataReaderCreator readerCreator, int threadId, int forumId, int itemsPerPage)
        {
            int startIndex = 0;
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

                startIndex = index / itemsPerPage;
                startIndex = startIndex * itemsPerPage;
            }
            return startIndex;
        }


        #region ICloneable Members

        // deep copy in separeate memory space
        public object Clone()
        {
            MemoryStream ms = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(ms, this);
            ms.Position = 0;
            object obj = bf.Deserialize(ms);
            ms.Close();
            return obj;

        }

        #endregion
    }


    public enum ThreadOrder :int
    {
        LatestPost =1,
        CreateDate = 2
    }
    

    
}
