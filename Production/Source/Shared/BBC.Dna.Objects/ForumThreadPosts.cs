using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using ISite = BBC.Dna.Sites.ISite;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "FORUMTHREADPOSTS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "FORUMTHREADPOSTS")]
    public class ForumThreadPosts : CachableBase<ForumThreadPosts>
    {
        #region Properties

        public ForumThreadPosts()
        {
            Post = new List<ThreadPost>();
        }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "FIRSTPOSTSUBJECT")]
        public string FirstPostSubject { get; set; }

        /// <remarks/>
        [XmlElement("POST", Order = 1)]
        public List<ThreadPost> Post { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMID")]
        public int ForumId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "ALERTINSTANTLY")]
        public byte AlertInstantly { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "THREADID")]
        public int ThreadId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIPTO")]
        public int SkipTo { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "COUNT")]
        public int Count { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANREAD")]
        public byte CanRead { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMPOSTCOUNT")]
        public int ForumPostCount { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMPOSTLIMIT")]
        public int ForumPostLimit { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTALPOSTCOUNT")]
        public int TotalPostCount { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SITEID")]
        public int SiteId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANREAD")]
        public byte DefaultCanRead { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANWRITE")]
        public byte DefaultCanWrite { get; set; }

        /// <summary>
        /// This is actually never used... yet...
        /// </summary>
        [XmlAttribute(AttributeName = "GUESTBOOK")]
        public int GuestBook { get; set; }

        /// <remarks/>
        /// TODO: remove this as it is been replaced by correct logic in the skins... finally
        [XmlAttribute(AttributeName = "MORE")]
        public byte More { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "GROUPALERTID")]
        public int GroupAlertId { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion

        /// <summary>
        /// Applies the current siteoptions
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        public void ApplySiteOptions(IUser user, ISiteList siteList)
        {
            bool isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {
//default as editor or super user
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
        /// <param name="readerCreator"></param>
        public void ApplyUserSettings(IUser user, IDnaDataReaderCreator readerCreator)
        {
            if (user != null && user.UserId != 0)
            {
                ApplyGroupAlert(user, readerCreator);

                if (user.IsEditor || user.IsSuperUser)
                {
//default as editor or super user
                    CanRead = 1;
                    CanWrite = 1;
                }
                else
                {
//check sp for full permissions
                    using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getthreadpermissions"))
                    {
                        reader.AddParameter("userid", user.UserId);
                        reader.AddParameter("threadid", ThreadId);
                        reader.Execute();

                        if (reader.Read())
                        {
                            CanRead = (byte) (reader.GetBoolean("CanRead") ? 1 : 0);
                            CanWrite = (byte) (reader.GetBoolean("CanWrite") ? 1 : 0);
                        }
                    }
                }
            }


            //finally remove posts if canread is false
            if (CanRead == 0)
            {
                Post = new List<ThreadPost>();
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
            EmailAlertGroup.HasGroupAlertOnItem(readerCreator, ref groupId, user.UserId, SiteId,
                                                EmailAlertList.IT_THREAD, ThreadId);
            GroupAlertId = groupId;
        }

        /// <summary>
        /// Checks the forum last updated flag in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
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
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="cache"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteList"></param>
        /// <param name="siteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="postId"></param>
        /// <param name="orderByDatePostedDesc"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ForumThreadPosts CreateThreadPosts(IDnaDataReaderCreator readerCreator, ICacheManager cache,
                                                         IUser viewingUser, ISiteList siteList, int siteId, int forumId,
                                                         int threadId, int itemsPerPage, int startIndex, int postId,
                                                         bool orderByDatePostedDesc, bool ignoreCache)
        {
            var forumThreadPosts = new ForumThreadPosts();
            string key = forumThreadPosts.GetCacheKey(forumId, itemsPerPage, startIndex, threadId, postId, orderByDatePostedDesc);
            
            if (!ignoreCache)
            {
                forumThreadPosts = (ForumThreadPosts) cache.GetData(key);
                if (forumThreadPosts != null && forumThreadPosts.IsUpToDate(readerCreator))
                {
                    forumThreadPosts.ApplyUserSettings(viewingUser, readerCreator);
                    forumThreadPosts.ApplySiteOptions(viewingUser, siteList);
                    return forumThreadPosts;
                }
            }
            //create from db
            forumThreadPosts = CreateThreadFromDatabase(readerCreator, siteId, forumId, threadId, itemsPerPage,
                                                        startIndex, postId, orderByDatePostedDesc);
            //add to cache
            cache.Remove(key);
            cache.Add(key, forumThreadPosts.Clone());
            //apply user settings
            forumThreadPosts.ApplySiteOptions(viewingUser, siteList);
            forumThreadPosts.ApplyUserSettings(viewingUser, readerCreator);

            return forumThreadPosts;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startIndex"></param>
        /// <param name="postId"></param>
        /// <param name="orderByDatePostedDesc"></param>
        /// <returns></returns>
        public static ForumThreadPosts CreateThreadFromDatabase(IDnaDataReaderCreator readerCreator, int siteId,
                                                                int forumId, int threadId, int itemsPerPage,
                                                                int startIndex, int postId, bool orderByDatePostedDesc)
        {
            //create the base object
            var thread = new ForumThreadPosts
                             {
                                 ForumId = forumId,
                                 ThreadId = threadId,
                                 SiteId = siteId
                             };
            //max return count is 200
            itemsPerPage = itemsPerPage > 200 ? 200 : itemsPerPage;

            // if we want to display a post, find its position - which block it's in
            if (postId > 0)
            {
                startIndex = GetIndexOfPostInThread(readerCreator, threadId, postId, itemsPerPage);
            }

            IDnaDataReader reader;
            reader = readerCreator.CreateDnaDataReader(orderByDatePostedDesc ? "threadlistposts2_desc" : "threadlistposts2");

            //get posts from db
            using (reader)
            {
                // Add the entry id and execute
                reader.AddParameter("ThreadId", threadId);
                reader.AddParameter("start", startIndex <= 0 ? startIndex : startIndex - 1);
                reader.AddParameter("end", startIndex + itemsPerPage);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    thread.DefaultCanRead = (byte) (reader.GetBoolean("CanRead") ? 1 : 0);
                    thread.DefaultCanWrite = (byte) (reader.GetBoolean("CanWrite") ? 1 : 0);
                    thread.CanRead = (byte) (reader.GetBoolean("CanRead") ? 1 : 0);
                    thread.CanWrite = (byte) (reader.GetBoolean("CanWrite") ? 1 : 0);
                    thread.TotalPostCount = reader.GetInt32NullAsZero("Total");
                    thread.AlertInstantly = (byte) (reader.GetInt32NullAsZero("AlertInstantly") > 0 ? 1 : 0);
                    thread.SkipTo = startIndex;
                    thread.Count = itemsPerPage;
                    thread.Post = new List<ThreadPost>();
                    thread.LastUpdated = reader.GetDateTime("threadlastupdate");

                    int prevIndex = reader.GetInt32NullAsZero("EntryID");
                    int firstPostOnNextPage = 0;
                    bool activeRow = true;
                    if (startIndex > 0)
                    {
//move forward to start on correct index
                        activeRow = reader.Read();
                    }
                    if (activeRow)
                    {
//possible that moving forward a result has hit end of reader or amount to read
                        thread.FirstPostSubject = StringUtils.EscapeAllXml(reader.GetString("FirstPostSubject") ?? "");

                        int itemsDisplayed = 0;
                        do
                        {
//cycle through remaing rows to add posts
                            thread.Post.Add(ThreadPost.CreateThreadPostFromReader(reader,
                                                                                  reader.GetInt32NullAsZero("EntryID")));
                            itemsDisplayed++;
                        } while (reader.Read() && itemsDisplayed < itemsPerPage);

                        if (reader.Read())
                        {
//the recordset returns 1 more than the required amount if there are more
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
                            prevIndex = thread.Post[counter].PostId; //move prevIndex forward

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
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="itemsPerPage"></param>
        /// <returns></returns>
        public static int GetIndexOfPostInThread(IDnaDataReaderCreator readerCreator, int threadId, int postId,
                                                 int itemsPerPage)
        {
            int startIndex;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getindexofpost"))
            {
                // Add the entry id and execute
                reader.AddParameter("ThreadId", threadId);
                reader.AddParameter("PostId", postId);
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

    }
}