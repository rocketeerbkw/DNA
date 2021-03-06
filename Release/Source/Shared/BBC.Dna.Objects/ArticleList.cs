﻿using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(TypeName = "ARTICLELIST")]
    [DataContract(Name = "articleList")]
    public class ArticleList : CachableBase<ArticleList>
    {
        public enum ArticleListType : int 
        {
            Approved = 1,
            Normal = 2,
            Cancelled = 3,
            NormalAndApproved = 4
        }

        public ArticleList()
        {
            Articles = new List<ArticleSummary>();
        }

        #region Properties
        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIP")]
        [DataMember(Name = "skip", Order = 1)]
        public int Skip { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SHOW")]
        [DataMember(Name = "show", Order = 2)]
        public int Show { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count", Order = 3)]
        public int Count { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTAL")]
        [DataMember(Name = "total", Order = 4)]
        public int Total { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type", Order = 5)]
        public ArticleListType Type { get; set; }

        /// <remarks/>
        [XmlElement("ARTICLES", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "Articles", Order = 6)]
        public List<ArticleSummary> Articles { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the Users Article list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="dnaUserId"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static ArticleList CreateUsersArticleListFromDatabase(IDnaDataReaderCreator readerCreator,
                                                                        int dnaUserId, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show, 
                                                                        ArticleListType type)
        {
            ArticleList articleList = new ArticleList();
            articleList.Skip = skip;
            articleList.Show = show;
            articleList.Type = type;

            string storedProcedure = String.Empty;
            switch (type)
            {
                case ArticleListType.Normal:
                    storedProcedure = "getuserrecententrieswithguidetype";
                break;
                case ArticleListType.Approved:
                    storedProcedure = "getuserrecentapprovedentrieswithguidetype";
                break;
                /*case ArticleListType.Cancelled:
                    storedProcedure = "getusercancelledentrieswithguidetype";
                break;*/
                default:
                    storedProcedure = "getuserrecentandapprovedentrieswithguidetype";
                break;
            }

            int count = 0;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(storedProcedure))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("skip", skip );
                reader.AddParameter("show", show);
                reader.AddParameter("guidetype", 1);
                reader.AddParameter("currentsiteid", 1);

                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    articleList.Total = reader.GetInt32NullAsZero("Total");
                    //The stored procedure returns one row for each article. 
                    do
                    {
                        count++;

                        //Delegate creation of XML to Article class.
                        ArticleSummary articleSummary = ArticleSummary.CreateArticleSummaryFromReader(reader);
                        articleList.Articles.Add(articleSummary);

                    } while (reader.Read());
                }
            }
            articleList.Count = count;
            return articleList;
        }
        /// <summary>
        /// Gets the users article list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static ArticleList CreateUsersArticleList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateUsersArticleList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, ArticleListType.NormalAndApproved, false, false);
        }
  
        /// <summary>
        /// Gets the users article list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="type"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ArticleList CreateUsersArticleList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                string identifier, 
                                                int siteId, 
                                                int skip, 
                                                int show,
                                                ArticleListType type,
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            int dnaUserId = 0;
            if (!byDnaUserId)
            {
                // fetch all the lovely intellectual property from the database
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getdnauseridfromidentityusername"))
                {
                    reader.AddParameter("identityusername", identifier);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        //1st Result set gets user details.
                        dnaUserId = reader.GetInt32NullAsZero("userid");
                    }
                    else
                    {
                        throw ApiException.GetError(ErrorType.UserNotFound);
                    }
                }
            }
            else
            {
                try
                {
                    dnaUserId = Convert.ToInt32(identifier);
                }
                catch (Exception)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }

            var articleList = new ArticleList();

            string key = articleList.GetCacheKey(dnaUserId, siteId, skip, show, type, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                articleList = (ArticleList)cache.GetData(key);
                if (articleList != null)
                {
                    //check if still valid with db...
                    if (articleList.IsUpToDate(readerCreator, dnaUserId, siteId))
                    {
                        return articleList;
                    }
                }
            }

            //create from db
            articleList = CreateUsersArticleListFromDatabase(readerCreator, dnaUserId, siteId, skip, show, type);

            articleList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, articleList);

            return articleList;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return false;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="userId">The user who's article list to check</param>
        /// <param name="siteId">The site of the article list to check</param>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public bool IsUpToDate(IDnaDataReaderCreator readerCreator, int userId, int siteId)
        {
            // note sure if this is a accurate or useful cache test...
            int seconds = 0;
            DateTime lastUpdate = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetarticlelistdate"))
            {
                reader.AddParameter("UserID", userId);
                reader.AddParameter("SiteID", siteId);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    seconds = reader.GetInt32NullAsZero("seconds");
                    lastUpdate = DateTime.Now.Subtract(new TimeSpan(0, 0, seconds));
                }
            }
            return lastUpdate <= LastUpdated;
        }
    }
}
