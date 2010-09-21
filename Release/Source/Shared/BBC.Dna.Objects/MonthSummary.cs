using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Xml;
using System.Runtime.Serialization;
using System.Diagnostics;
using BBC.Dna.Common;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(TypeName = "MONTHSUMMARY")]
    [DataContract(Name = "monthSummary")]
    public class MonthSummary : CachableBase<MonthSummary>
    {
        public MonthSummary()
        {
            GuideEntries = new List<ArticleSummary>();
        }

        [XmlArray(ElementName = "GUIDEENTRIES")]
        [XmlArrayItem("ARTICLESUMMARY", IsNullable = false)]
        [DataMember(Name = "guideEntries")]
        public List<ArticleSummary> GuideEntries { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

       /// <summary>
        /// Gets Month Summary data from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static MonthSummary CreateMonthSummary(ICacheManager cache, IDnaDataReaderCreator readerCreator, int siteId)
        {
            return CreateMonthSummary(cache, readerCreator, siteId, false);
        }

        /// <summary>
        /// Gets MOnth Summary from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="ignoreCache"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static MonthSummary CreateMonthSummary(ICacheManager cache, IDnaDataReaderCreator readerCreator, int siteId, bool ignoreCache)
        {
            MonthSummary monthSummary = new MonthSummary();

            string key = monthSummary.GetCacheKey(siteId);
            //check for item in the cache first            
            if (!ignoreCache)
            {
                //not ignoring cache
                monthSummary = (MonthSummary)cache.GetData(key);
                if (monthSummary != null)
                {
                    //check if still valid with db...
                    if (monthSummary.IsUpToDate(readerCreator))
                    {
                        return monthSummary;
                    }
                }
            }
            
            //create from db
            monthSummary = CreateMonthSummaryFromDatabase(readerCreator, siteId);

            //add to cache
            cache.Add(key, monthSummary);

            return monthSummary;
        }

        /// <summary>
        /// Checks the forum last updated flag in db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            // note sure if this is a accurate or useful cache test...
            int seconds = 0;
            DateTime lastUpdate = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegettimeofmostrecentguideentry"))
            {
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

        /// <summary>
        /// Creates the month summary from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static MonthSummary CreateMonthSummaryFromDatabase(IDnaDataReaderCreator readerCreator, int siteId)
        {
            MonthSummary monthSummary = null;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getmonthsummary"))
            {
                reader.AddParameter("siteID", siteId);
                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.MonthSummaryNotFound);
                }
                else
                {
                    monthSummary = new MonthSummary();
                    monthSummary.GuideEntries = new List<ArticleSummary>();
                    do
                    {
                        ArticleSummary articleSummary = new ArticleSummary();
                        articleSummary.H2G2ID = reader.GetInt32NullAsZero("h2g2ID");
                        articleSummary.Name = reader.GetStringNullAsEmpty("Subject");
                        articleSummary.Type = Article.GetArticleTypeFromInt(reader.GetInt32NullAsZero("type"));
                        articleSummary.DateCreated = new DateElement(reader.GetDateTime("datecreated"));

                        monthSummary.GuideEntries.Add(articleSummary);

                    } while (reader.Read());
                }
            }
            return monthSummary;
        }
    }

}
