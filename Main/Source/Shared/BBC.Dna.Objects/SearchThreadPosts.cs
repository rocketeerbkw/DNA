using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Runtime.Serialization;
using ISite = BBC.Dna.Sites.ISite;
using BBC.Dna.Common;
using System.Linq;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "SEARCHTHREADPOSTS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "SEARCHTHREADPOSTS")]
    [DataContract(Name = "searchThreadPosts")]
    public class SearchThreadPosts : CachableBase<SearchThreadPosts>
    {
        #region Properties

        public SearchThreadPosts()
        {
            Posts = new List<SearchThreadPost>();
        }

        /// <remarks/>
        [XmlElement("POST", Order = 1)]
        [DataMember(Name = "posts")]
        public List<SearchThreadPost> Posts { get; set; }


        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIPTO")]
        [DataMember(Name = "startIndex")]
        public int SkipTo { get; set; }

        /// <remarks/>
        [XmlIgnore]
        [DataMember(Name = "count")]
        public int Count { get; set; }

        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = ("itemsPerPage"))]
        public int ItemsPerPage { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTALPOSTCOUNT")]
        [DataMember(Name = "totalCount")]
        public int TotalPostCount { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SITEID")]
        [DataMember(Name = "siteId")]
        public int SiteId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMID")]
        [DataMember(Name = "forumId")]
        public int ForumId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "THREADID")]
        [DataMember(Name = "threadId")]
        public int ThreadId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SEARCHTERM")]
        [DataMember(Name = "searchTerm")]
        public string SearchTerm { get; set; }
       
        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion

        /// <summary>
        /// Checks the forum last updated flag in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {//cache for an hour?
            return LastUpdated > DateTime.Now.AddHours(-1);
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
        public static SearchThreadPosts GetSearchThreadPosts(IDnaDataReaderCreator readerCreator, ICacheManager cache,
                                                         ISite site, int forumId,
                                                         int threadId, int itemsPerPage, int startIndex, string searchText,
                                                         bool ignoreCache)
        {
            var searchThreadPosts = new SearchThreadPosts();
            string key = searchThreadPosts.GetCacheKey(site.SiteID, forumId, itemsPerPage, startIndex, threadId, 
                searchText);

            if (!ignoreCache)
            {
                searchThreadPosts = (SearchThreadPosts)cache.GetData(key);
                if (searchThreadPosts != null && searchThreadPosts.IsUpToDate(readerCreator))
                {
                    return searchThreadPosts;
                }
            }
            //create from db
            searchThreadPosts = CreateThreadFromDatabase(readerCreator, site, forumId, threadId, itemsPerPage, 
                startIndex, searchText);
            //add to cache
            cache.Remove(key);
            cache.Add(key, searchThreadPosts.Clone());

            return searchThreadPosts;
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
        public static SearchThreadPosts CreateThreadFromDatabase(IDnaDataReaderCreator readerCreator, ISite site,
                                                                int forumId, int threadId, int itemsPerPage,
                                                                int startIndex, string searchText)
        {

            searchText = searchText.Trim();
            //max return count is 200
            itemsPerPage = itemsPerPage > 200 ? 200 : itemsPerPage;

            //create the base object
            var thread = new SearchThreadPosts
            {
                ForumId = forumId,
                ThreadId = threadId,
                SiteId = site.SiteID,
                SearchTerm = searchText,
                ItemsPerPage = itemsPerPage
            };

            //format search string for full text search
            var searchTextArray = searchText.Split(' ');
            foreach (var term in searchTextArray)
            {
                if (term != "&" && !string.IsNullOrEmpty(term))
                {
                    searchText += term + "&";
                }
            }
            if (searchText.LastIndexOf("&") == 0)
            {
                searchText = searchText.Substring(0, searchText.Length - 1);
            }

            //get posts from db
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("searchthreadentriesfast")) 
            {
                // Add the entry id and execute
                reader.AddParameter("siteid", site.SiteID);
                reader.AddParameter("condition", searchText);
                reader.AddParameter("startIndex", startIndex <= 0 ? startIndex : startIndex - 1);
                reader.AddParameter("itemsPerPage", itemsPerPage);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    thread.TotalPostCount = reader.GetInt32NullAsZero("totalresults");
                    
                    thread.SkipTo = startIndex;
                    int itemsDisplayed = 0;
                    do
                    {
                        //cycle through remaing rows to add posts
                        thread.Posts.Add(SearchThreadPost.CreatePostFromReader(reader,
                                                                              reader.GetInt32NullAsZero("EntryID"), searchTextArray));
                        itemsDisplayed++;
                    } while (reader.Read());

                }
            }

            return thread;
        }

    }
}
