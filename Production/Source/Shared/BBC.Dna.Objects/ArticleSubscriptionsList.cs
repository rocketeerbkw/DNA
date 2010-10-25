using System;
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
    [XmlType(TypeName = "ARTICLESUBSCRIPTIONSLIST")]
    [DataContract(Name = "articleSubscriptionsList")]
    public class ArticleSubscriptionsList : CachableBase<ArticleSubscriptionsList>
    {
        public ArticleSubscriptionsList()
        {
           Articles = new List<Article>();
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
        [XmlElement("ARTICLES", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "articles", Order = 5)]
        public List<Article> Articles { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the article subscriptions from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns></returns>
        public static ArticleSubscriptionsList CreateArticleSubscriptionsListFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        string identifier, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show, 
                                                                        bool byDnaUserId)
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

            ArticleSubscriptionsList articleSubscriptions = new ArticleSubscriptionsList();
            int total = 0;
            int count = 0;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getsubscribedarticles"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("firstindex", skip);
                reader.AddParameter("lastindex", skip + show - 1);

                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    //TODO PUT KEY ARTICLES PHRASES HERE IF NEEDED LATER                    
                    reader.NextResult();

                    if (reader.Read())
                    {
                        total = reader.GetInt32NullAsZero("TOTAL");

                        //The stored procedure returns one row for each article. 
                        do
                        {
                            count++;

                            //Paged List of Article Subscriptions.
                            //Delegate creation of XML to Article class.
                            Article newArticle = Article.CreateArticleFromReader(readerCreator, reader, false);
                            newArticle.Type = Article.ArticleType.Article;
                            articleSubscriptions.Articles.Add(newArticle);

                        } while (reader.Read());
                    }
                }
            }
            articleSubscriptions.Count = count;
            articleSubscriptions.Total = total;
            return articleSubscriptions;
        }
        /// <summary>
        /// Gets the user subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static ArticleSubscriptionsList CreateUserSubscriptionsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateArticleSubscriptionsList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false);
        }
  
        /// <summary>
        /// Gets the user subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ArticleSubscriptionsList CreateArticleSubscriptionsList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                string identifier, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var articleSubscriptionsList = new ArticleSubscriptionsList();

            string key = articleSubscriptionsList.GetCacheKey(identifier, siteID, skip, show, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                articleSubscriptionsList = (ArticleSubscriptionsList)cache.GetData(key);
                if (articleSubscriptionsList != null)
                {
                    //check if still valid with db...
                    if (articleSubscriptionsList.IsUpToDate(readerCreator))
                    {
                        return articleSubscriptionsList;
                    }
                }
            }

            //create from db
            articleSubscriptionsList = CreateArticleSubscriptionsListFromDatabase(readerCreator, identifier, siteID, skip, show, byDnaUserId);

            articleSubscriptionsList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, articleSubscriptionsList);

            return articleSubscriptionsList;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            // not used always get a new one for now
            return false;
        }
    }
}
