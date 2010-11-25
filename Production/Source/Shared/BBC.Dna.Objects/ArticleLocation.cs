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
    [XmlType(TypeName = "ARTICLELOCATION")]
    [DataContract(Name = "articleLocation")]
    public class ArticleLocation : CachableBase<ArticleLocation>
    {
        public ArticleLocation()
        {
           Locations = new List<Location>();
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
        [XmlElement("LOCATIONS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "locations", Order = 5)]
        public List<Location> Locations { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the Article location list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="articleId"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns></returns>
        public static ArticleLocation CreateArticleLocationsFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        int articleId, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show)
        {
            ArticleLocation articleLocations = new ArticleLocation();
            int total = 0;
            int count = 0;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetGuideEntryLocation"))
            {
                reader.AddParameter("h2g2id", articleId);
                reader.AddParameter("siteid", siteId);

                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    total = reader.GetInt32NullAsZero("TOTAL");

                    //The stored procedure returns one row for each article. 
                    do
                    {
                        count++;

                        //Delegate creation of XML to Location class.
                        Location location = Location.CreateLocationFromReader(reader);
                        articleLocations.Locations.Add(location);

                    } while (reader.Read() && count < show);
                }
            }
            articleLocations.Count = count;
            articleLocations.Total = total;
            return articleLocations;
        }
        /// <summary>
        /// Gets the article location list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="articleId"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static ArticleLocation CreateArticleLocations(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                int articleId,
                                                int siteId)
        {
            return CreateArticleLocations(cache, readerCreator, viewingUser, articleId, siteId, 0, 20, false);
        }
  
        /// <summary>
        /// Gets the article location list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="articleId"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ArticleLocation CreateArticleLocations(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                int articleId, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool ignoreCache)
        {
            var articleLocation = new ArticleLocation();

            string key = articleLocation.GetCacheKey(articleId, siteID, skip, show);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                articleLocation = (ArticleLocation)cache.GetData(key);
                if (articleLocation != null)
                {
                    //check if still valid with db...
                    if (articleLocation.IsUpToDate(readerCreator))
                    {
                        return articleLocation;
                    }
                }
            }

            //create from db
            articleLocation = CreateArticleLocationsFromDatabase(readerCreator, articleId, siteID, skip, show);

            articleLocation.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, articleLocation);

            return articleLocation;
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
