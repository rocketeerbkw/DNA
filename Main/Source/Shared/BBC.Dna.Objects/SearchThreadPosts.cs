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
using System.Collections;

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
            var tempSeachText = FormatSearchTerm(ref searchTextArray);

            if (string.IsNullOrEmpty(tempSeachText))
            {
                return thread;
            }

            //get posts from db
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("searchthreadentriesfast")) 
            {
                // Add the entry id and execute
                reader.AddParameter("siteid", site.SiteID);
                reader.AddParameter("condition", tempSeachText);
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

        private static string[] BadSearchChars = { "!", "\"", "&", "(", ")", "[", "]", "~", ",", "|"};
        private static List<string> NoiseWords;

        private static List<string> GetNoiseWords()
        {
            if (NoiseWords != null)
            {
                return NoiseWords;
            }

            NoiseWords = new List<string>();
            NoiseWords.Add("about");
            NoiseWords.Add("after");
            NoiseWords.Add("all");
            NoiseWords.Add("also");
            NoiseWords.Add("an");
            NoiseWords.Add("and");
            NoiseWords.Add("another");
            NoiseWords.Add("any");
            NoiseWords.Add("are");
            NoiseWords.Add("as");
            NoiseWords.Add("at");
            NoiseWords.Add("be");
            NoiseWords.Add("because");
            NoiseWords.Add("been");
            NoiseWords.Add("before");
            NoiseWords.Add("being");
            NoiseWords.Add("between");
            NoiseWords.Add("both");
            NoiseWords.Add("but");
            NoiseWords.Add("by");
            NoiseWords.Add("came");
            NoiseWords.Add("can");
            NoiseWords.Add("come");
            NoiseWords.Add("could");
            NoiseWords.Add("did");
            NoiseWords.Add("do");
            NoiseWords.Add("does");
            NoiseWords.Add("each");
            NoiseWords.Add("else");
            NoiseWords.Add("for");
            NoiseWords.Add("from");
            NoiseWords.Add("get");
            NoiseWords.Add("got");
            NoiseWords.Add("has");
            NoiseWords.Add("had");
            NoiseWords.Add("he");
            NoiseWords.Add("have");
            NoiseWords.Add("her");
            NoiseWords.Add("here");
            NoiseWords.Add("him");
            NoiseWords.Add("himself");
            NoiseWords.Add("his");
            NoiseWords.Add("how");
            NoiseWords.Add("if");
            NoiseWords.Add("in");
            NoiseWords.Add("into");
            NoiseWords.Add("is");
            NoiseWords.Add("it");
            NoiseWords.Add("its");
            NoiseWords.Add("just");
            NoiseWords.Add("like");
            NoiseWords.Add("make");
            NoiseWords.Add("many");
            NoiseWords.Add("me");
            NoiseWords.Add("might");
            NoiseWords.Add("more");
            NoiseWords.Add("most");
            NoiseWords.Add("much");
            NoiseWords.Add("must");
            NoiseWords.Add("my");
            NoiseWords.Add("never");
            NoiseWords.Add("no");
            NoiseWords.Add("now");
            NoiseWords.Add("of");
            NoiseWords.Add("on");
            NoiseWords.Add("only");
            NoiseWords.Add("or");
            NoiseWords.Add("other");
            NoiseWords.Add("our");
            NoiseWords.Add("out");
            NoiseWords.Add("over");
            NoiseWords.Add("re");
            NoiseWords.Add("said");
            NoiseWords.Add("same");
            NoiseWords.Add("see");
            NoiseWords.Add("should");
            NoiseWords.Add("since");
            NoiseWords.Add("so");
            NoiseWords.Add("some");
            NoiseWords.Add("still");
            NoiseWords.Add("such");
            NoiseWords.Add("take");
            NoiseWords.Add("than");
            NoiseWords.Add("that");
            NoiseWords.Add("the");
            NoiseWords.Add("their");
            NoiseWords.Add("them");
            NoiseWords.Add("then");
            NoiseWords.Add("there");
            NoiseWords.Add("these");
            NoiseWords.Add("they");
            NoiseWords.Add("this");
            NoiseWords.Add("those");
            NoiseWords.Add("through");
            NoiseWords.Add("to");
            NoiseWords.Add("too");
            NoiseWords.Add("under");
            NoiseWords.Add("up");
            NoiseWords.Add("use");
            NoiseWords.Add("very");
            NoiseWords.Add("want");
            NoiseWords.Add("was");
            NoiseWords.Add("way");
            NoiseWords.Add("we");
            NoiseWords.Add("well");
            NoiseWords.Add("were");
            NoiseWords.Add("what");
            NoiseWords.Add("when");
            NoiseWords.Add("where");
            NoiseWords.Add("which");
            NoiseWords.Add("while");
            NoiseWords.Add("who");
            NoiseWords.Add("will");
            NoiseWords.Add("with");
            NoiseWords.Add("would");
            NoiseWords.Add("you");
            NoiseWords.Add("your");
            return NoiseWords;
        }

        /// <summary>
        /// formats the search terms into & delimited terms
        /// </summary>
        /// <param name="searchTextArray"></param>
        /// <returns></returns>
        public static string FormatSearchTerm(ref string[] searchTextArray)
        {
            string tempSeachText = string.Empty;
            List<string> goodTerms = new List<string>();
            foreach (var term in searchTextArray)
            {

                string tempTerm = term;
                foreach (var badChar in BadSearchChars)
                {
                    tempTerm = tempTerm.Replace(badChar, "");
                }
                tempTerm = tempTerm.Trim();
                if (!string.IsNullOrEmpty(tempTerm) && !GetNoiseWords().Contains(tempTerm) && tempTerm.Length> 1)
                {
                    goodTerms.Add(tempTerm);
                    tempSeachText += tempTerm + "&";
                }
            }

            if (String.IsNullOrEmpty(tempSeachText))
            {
                return tempSeachText;
            }
            //strip any trailing & chars
            if (tempSeachText.LastIndexOf("&") == tempSeachText.Length - 1)
            {
                tempSeachText = tempSeachText.Substring(0, tempSeachText.Length-1);
            }

            searchTextArray = goodTerms.ToArray();
            return tempSeachText;
        }

    }
}
