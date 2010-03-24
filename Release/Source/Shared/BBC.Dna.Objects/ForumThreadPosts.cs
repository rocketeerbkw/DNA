using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Xml.Serialization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "FORUMTHREADPOSTS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "FORUMTHREADPOSTS")]
    public partial class ForumThreadPosts : ICloneable
    {
        #region Properties
        public ForumThreadPosts()
        {
            Post = new System.Collections.Generic.List<ThreadPost>();
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "FIRSTPOSTSUBJECT")]
        public string FirstPostSubject
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("POST", Order = 1)]
        public System.Collections.Generic.List<ThreadPost> Post
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
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ALERTINSTANTLY")]
        public byte AlertInstantly
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREADID")]
        public int ThreadId
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
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOTALPOSTCOUNT")]
        public int TotalPostCount
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
        /// This is actually never used... yet...
        /// </summary>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "GUESTBOOK")]
        public int GuestBook
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "MORE")]
        public byte More
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "GROUPALERTID")]
        public int GroupAlertId
        {
            get;
            set;
        }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated
        {
            get;
            set;
        }
        #endregion

        /// <summary>
        /// Applies the current siteoptions
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        public void ApplySiteOptions(IUser user, ISiteList siteList)
        {
            bool isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {//default as editor or super user
                CanRead = 1;
                CanWrite = 1;
                isEditor = true;
            }

            ISite site = siteList.GetSite(SiteId);
            //check site is open
            if (!isEditor && CanWrite == 1)
            {
                if (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now))
                {
                    CanWrite = 0;
                }
            }

            ForumPostLimit = siteList.GetSiteOptionValueInt(SiteId, "Forum", "PostLimit");
        }

        /// <summary>
        /// Apply any user settings required. 
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        /// <param name="user">The viewing user</param>
        /// <param name="site">The current site</param>
        public void ApplyUserSettings(IUser user, IDnaDataReaderCreator readerCreator)
        {
            if (user != null && user.UserId != 0)
            {
                ApplyGroupAlert(user, readerCreator);

                if (user.IsEditor || user.IsSuperUser)
                {//default as editor or super user
                    CanRead = 1;
                    CanWrite = 1;
                }
                else
                {//check sp for full permissions
                    using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getthreadpermissions"))
                    {
                        reader.AddParameter("userid", user.UserId);
                        reader.AddParameter("threadid", ThreadId);
                        reader.Execute();

                        if (reader.Read())
                        {
                            CanRead = (byte)(reader.GetBoolean("CanRead") ? 1 : 0);
                            CanWrite = (byte)(reader.GetBoolean("CanWrite") ? 1 : 0);
                        }
                    }
                }

            }
            

            //finally remove posts if canread is false
            if (CanRead == 0)
            {
                Post = new System.Collections.Generic.List<ThreadPost>();
            }
        }

        /// <summary>
        /// Applies the group alert based on the current user.
        /// </summary>
        /// <param name="user"></param>
        /// <param name="readerCreator"></param>
        private void ApplyGroupAlert(IUser user, IDnaDataReaderCreator readerCreator)
        {
            int groupId = 0;
            EmailAlertGroup.HasGroupAlertOnItem(readerCreator, ref groupId, user.UserId, SiteId, EmailAlertList.IT_THREAD, ThreadId);
            GroupAlertId = groupId;
        }

        /// <summary>
        /// Checks the forum last updated flag in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            // note sure if this is a accurate or useful cache test...
            DateTime lastUpdate = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetthreadlastupdate"))
            {
                reader.AddParameter("threadid", ThreadId);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    lastUpdate = reader.GetDateTime("LastUpdated");
                }
            }
            return lastUpdate <= LastUpdated;
        }

        /// <summary>
        /// Creates a thread object from the given items
        /// </summary>
        /// <param name="SiteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="postId"></param>
        /// <param name="orderByDatePostedDesc"></param>
        /// <param name="reader"></param>
        /// <returns></returns>
        static public ForumThreadPosts CreateThreadPosts(IDnaDataReaderCreator readerCreator, ICacheManager cache,
            IUser viewingUser, ISiteList siteList, int siteId, int forumId, int threadId, int itemsPerPage, int startIndex, int postId, 
            bool orderByDatePostedDesc, bool ignoreCache)
        {
            string key = GetCacheKey(forumId, itemsPerPage, startIndex, threadId, postId, orderByDatePostedDesc);
            ForumThreadPosts forumThreadPosts = null;
            if (!ignoreCache)
            {
                forumThreadPosts = (ForumThreadPosts)cache.GetData(key);
                if (forumThreadPosts != null && forumThreadPosts.IsUpToDate(readerCreator))
                {
                    forumThreadPosts.ApplyUserSettings(viewingUser, readerCreator);
                    forumThreadPosts.ApplySiteOptions(viewingUser, siteList);
                    return forumThreadPosts;
                }
            }
            //create from db
            forumThreadPosts = CreateThreadFromDatabase(readerCreator, siteId, forumId, threadId, itemsPerPage, startIndex, postId, orderByDatePostedDesc);
            //add to cache
            cache.Remove(key);
            cache.Add(key, forumThreadPosts.Clone());
            //apply user settings
            forumThreadPosts.ApplySiteOptions(viewingUser, siteList);
            forumThreadPosts.ApplyUserSettings(viewingUser, readerCreator);

            return forumThreadPosts;
        }

        /// <summary>
        /// Creates a thread object from the given items
        /// </summary>
        /// <param name="SiteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="postId"></param>
        /// <param name="orderByDatePostedDesc"></param>
        /// <param name="reader"></param>
        /// <returns></returns>
        static public ForumThreadPosts CreateThreadFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, int forumId, int threadId, int itemsPerPage, 
            int startIndex, int postId, bool orderByDatePostedDesc)
        {
            //create the base object
            ForumThreadPosts thread = new ForumThreadPosts()
            {
                ForumId = forumId,
                ThreadId = threadId,
                SiteId = siteId

            };
            //max return count is 200
            itemsPerPage = itemsPerPage > 200? 200: itemsPerPage;

            // if we want to display a post, find its position - which block it's in
            if(postId >0)
            {
                startIndex = GetIndexOfPostInThread(readerCreator, threadId, postId, itemsPerPage);
            }

            IDnaDataReader reader = null;
            if (orderByDatePostedDesc)
            {
                reader = readerCreator.CreateDnaDataReader("threadlistposts2_desc");
            }
            else
            {
                reader = readerCreator.CreateDnaDataReader("threadlistposts2");
            }

            //get posts from db
            using(reader)
            {
                
                // Add the entry id and execute
                reader.AddParameter("ThreadId", threadId);
                reader.AddParameter("start", startIndex <=0? startIndex : startIndex-1);
                reader.AddParameter("end", startIndex+itemsPerPage);
                reader.Execute();

                if(reader.HasRows && reader.Read())
                {
                    thread.DefaultCanRead = (byte)(reader.GetBoolean("CanRead")? 1:0);
                    thread.DefaultCanWrite = (byte)(reader.GetBoolean("CanWrite") ? 1 : 0);
                    thread.CanRead = (byte)(reader.GetBoolean("CanRead") ? 1 : 0);
                    thread.CanWrite = (byte)(reader.GetBoolean("CanWrite") ? 1 : 0);
                    thread.TotalPostCount = reader.GetInt32NullAsZero("Total");
                    thread.AlertInstantly = (byte)(reader.GetInt32NullAsZero("AlertInstantly")>0? 1:0);
                    thread.SkipTo = startIndex;
                    thread.Count = itemsPerPage;
                    thread.Post = new System.Collections.Generic.List<ThreadPost>();
                    thread.LastUpdated = reader.GetDateTime("threadlastupdate");

                    int prevIndex = reader.GetInt32NullAsZero("EntryID");
                    int firstPostOnNextPage =0;
                    bool activeRow = true;
                    if (startIndex > 0)
                    {
//move forward to start on correct index
                        activeRow = reader.Read();
                    }
                    if (activeRow)
                    {//possible that moving forward a result has hit end of reader or amount to read
                        thread.FirstPostSubject = StringUtils.EscapeAllXml(reader.GetString("FirstPostSubject")??"");

                        int itemsDisplayed = 0;
                        do
                        {//cycle through remaing rows to add posts
                            thread.Post.Add(ThreadPost.CreateThreadPostFromReader(reader, reader.GetInt32NullAsZero("EntryID")));
                            itemsDisplayed++;
                        } while (reader.Read() && itemsDisplayed< itemsPerPage);

                        if (reader.Read())
                        {//the recordset returns 1 more than the required amount if there are more
                            thread.More = 1;
                            firstPostOnNextPage = reader.GetInt32NullAsZero("EntryID");
                        }

                        //add add the previndex and nextindex to posts
                        for (int counter = 0; counter < thread.Post.Count; counter++)
                        {
                            if (counter > 0)
                            {
                                thread.Post[counter].PrevIndex = prevIndex;
                            }
                            prevIndex = thread.Post[counter].PostId;//move prevIndex forward

                            if (counter > 0)
                            {
                                thread.Post[counter - 1].NextIndex = thread.Post[counter].PostId;
                            }
                        }
                        thread.Post[thread.Post.Count - 1].NextIndex = firstPostOnNextPage;
                    }
                    
                }
            }
            
            return thread;
        }

        /// <summary>
        /// Gets the amount to skip forum for a given
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="skipped"></param>
        static public int GetIndexOfPostInThread(IDnaDataReaderCreator readerCreator, int threadId, int postId, int itemsPerPage)
        {
            int startIndex = 0;
            using(IDnaDataReader reader = readerCreator.CreateDnaDataReader("getindexofpost"))
            {
                // Add the entry id and execute
                reader.AddParameter("ThreadId", threadId);
                reader.AddParameter("PostId", postId);
                reader.Execute();

                int index = 0;
                if(reader.HasRows && reader.Read())
                {
                    index = reader.GetInt32NullAsZero("Index");
                }

                startIndex = index / itemsPerPage;
                startIndex = startIndex * itemsPerPage;
            }
            return startIndex;
        }

        /// <summary>
        /// Returns the cache key for a list of items
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="orderByDatePostedDesc"></param>
        /// <returns></returns>
        static public string GetCacheKey(int forumId, int itemsPerPage, int startIndex, int threadId, int postId, bool orderByDatePostedDesc)
        {
            return typeof(ForumThreadPosts).AssemblyQualifiedName + "|" + forumId.ToString() + "|" + itemsPerPage + "|" + startIndex + "|" +
                threadId.ToString() + "|" + orderByDatePostedDesc.ToString() + "|" + postId.ToString();
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

}
