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
using BBC.Dna.Sites;
using System.Data;
using System.Data.SqlClient;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Objects
{
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "SCOUT-RECOMMENDATION")]
    [DataContract(Name = "scoutRecommendations")]
    public partial class ScoutRecommendations : CachableBase<ScoutRecommendations>
    {
        #region Properties

        public ScoutRecommendations()
        {
            Articles = new List<ArticleSummary>();
        }

        /// <remarks/>
        [DataMember(Name = "submittedArticleH2G2Id", Order = 1)]
        public int SubmittedArticleH2G2Id { get; set; }

        /// <remarks/>
        [XmlElement("ARTICLES", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "Articles", Order = 2)]
        public List<ArticleSummary> Articles { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        public static ScoutRecommendations RecommendArticle(IDnaDataReaderCreator readerCreator, 
                BBC.Dna.Sites.ISite site,
                int scoutId,
                int articleId,
                string comments)
        {
            ScoutRecommendations scoutRecommendationsResponse = new ScoutRecommendations();

            int entryId = articleId / 10;

            bool alreadyRecommended = false;
            bool wrongStatus = false;
            bool okay = false;
            int userID = 0;
            string username = String.Empty;

            //Submit the article
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("StoreScoutRecommendation"))
            {
                reader.AddParameter("ScoutID", scoutId);
                reader.AddParameter("EntryID", articleId);
                if (comments != String.Empty)
                {
                    reader.AddParameter("Comments", comments);
                }

                reader.Execute();
                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {

                    alreadyRecommended = reader.GetBoolean("AlreadyRecommended");
                    wrongStatus = reader.GetBoolean("WrongStatus");
                    okay = reader.GetBoolean("Success");
                    userID = reader.GetInt32NullAsZero("UserID");
                    username = reader.GetStringNullAsEmpty("Username");

                }
            }
            if (okay)
            {
                scoutRecommendationsResponse.SubmittedArticleH2G2Id = articleId;
            }
            else
            {
            }

            return scoutRecommendationsResponse;
        }

        public static ScoutRecommendations CreateScoutRecommendationsFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, int skip, int show)
        {
            ScoutRecommendations scoutRecommendations = new ScoutRecommendations();

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("FetchUndecidedRecommendations"))
            {
                reader.AddParameter("siteid", siteId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    //The stored procedure returns one row for each article. 
                    do
                    {
                        //Delegate creation of XML to Article class.
                        ArticleSummary articleSummary = ArticleSummary.CreateArticleSummaryFromReader(reader);
                        scoutRecommendations.Articles.Add(articleSummary);

                    } while (reader.Read());
                }
            }
            return scoutRecommendations;
        }
        /// <summary>
        /// Gets the scout recommendation list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static ScoutRecommendations CreateScoutRecommendations(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                int siteId)
        {
            return CreateScoutRecommendations(cache, readerCreator, siteId, 0, 20, false);
        }
  
        /// <summary>
        /// Gets the scout recommendation list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ScoutRecommendations CreateScoutRecommendations(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                int siteId, 
                                                int skip, 
                                                int show,
                                                bool ignoreCache)
        {
            var scoutRecommendations = new ScoutRecommendations();

            string key = scoutRecommendations.GetCacheKey(siteId, skip, show);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                scoutRecommendations = (ScoutRecommendations)cache.GetData(key);
                if (scoutRecommendations != null)
                {
                    //check if still valid with db...
                    if (scoutRecommendations.IsUpToDate(readerCreator))
                    {
                        return scoutRecommendations;
                    }
                }
            }

            //create from db
            scoutRecommendations = CreateScoutRecommendationsFromDatabase(readerCreator, siteId, skip, show);

            scoutRecommendations.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, scoutRecommendations);

            return scoutRecommendations;
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
    }
}
