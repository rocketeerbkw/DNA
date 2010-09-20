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
    [XmlType(TypeName = "INDEX")]
    [DataContract(Name = "index")]
    public class Index : CachableBase<Index>
    {
        public Index()
        {
            IndexEntries = new List<ArticleSummary>();
        }

        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count", Order=1)]
        public int Count { get; set; }

        [XmlAttribute(AttributeName = "LETTER")]
        [DataMember(Name = "letter", Order = 2)]
        public string Letter { get; set; }

        [XmlArray(ElementName = "INDEXENTRIES")]
        [XmlArrayItem("ARTICLESUMMARY", IsNullable = false)]
        [DataMember(Name = "indexEntries", Order = 3)]
        public List<ArticleSummary> IndexEntries { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        /// <summary>
        /// Gets Default Index data from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public static Index CreateIndex(ICacheManager cache, IDnaDataReaderCreator readerCreator, int siteId)
        {
            return CreateIndex(cache, readerCreator, siteId, "", true, false, false, "", 0, false);
        }

        /// <summary>
        /// Gets Index data from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator">Data Reader Creator</param>
        /// <param name="siteId">Site ID</param>
        /// <param name="letter">Articles beginning with this letter</param>
        /// <param name="showApproved">Whether to include Edit Guide Entries</param>
        /// <param name="showSubmitted">Whether to include Submitted Guide Entries</param>
        /// <param name="showUnapproved">Whether to include User Entries</param>
        /// <param name="groups">groups filter</param>
        /// <param name="order by">sort order by clause
        ///	orderBy - A Variable to determine the ordering of the results.
        ///	(Empty)		= Sort By Subject		= 0
        ///	datecreated	= Sort by date created	= 1
        ///	lastupdated	= Sort by last updated	= 2</param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Index CreateIndex(ICacheManager cache, 
                                        IDnaDataReaderCreator readerCreator, 
                                        int siteId, 
                                        string letter, 
                                        bool showApproved, 
                                        bool showSubmitted, 
                                        bool showUnapproved, 
                                        string groups,
                                        int orderBy,
                                        bool ignoreCache)
        {
            Index index = new Index();

            if (letter.ToUpper() == "ALL")
            {
                letter = String.Empty;
            }
            else if (letter.Length > 0)
            {
                letter = letter.Substring(0, 1);
                if (!Char.IsLetter(letter, 0))
                {
                    letter = ".";
                }
            }

            string key = index.GetCacheKey(siteId, letter, showApproved, showSubmitted, showUnapproved, groups, orderBy);

            //check for item in the cache first            
            if (!ignoreCache)
            {
                //not ignoring cache
                index = (Index)cache.GetData(key);
                if (index != null)
                {
                    //check if still valid with db...
                    if (index.IsUpToDate(readerCreator))
                    {
                        return index;
                    }
                }
            }

            //create from db
            index = CreateIndexFromDatabase(readerCreator, siteId, letter, showApproved, showSubmitted, showUnapproved, groups, orderBy);

            //add to cache
            cache.Add(key, index);

            return index;
        }

        /// <summary>
        /// Checks the time of most recent guide entry in db
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
        /// Creates the Index from the DB
        /// </summary>
        /// <param name="readerCreator">Data Reader Creator</param>
        /// <param name="siteId">Site ID</param>
        /// <param name="letter">Articles beginning with this letter</param>
        /// <param name="showApproved">Whether to include Edit Guide Entries</param>
        /// <param name="showSubmitted">Whether to include Submitted Guide Entries</param>
        /// <param name="showUnapproved">Whether to include User Entries</param>
        /// <param name="groups">groups filter</param>
        /// <param name="order by">sort order by clause</param>
        /// <returns></returns>
        public static Index CreateIndexFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, string letter, bool showApproved, bool showSubmitted, bool showUnapproved, string groups, int orderBy)
        {
            Index index = null;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("articlesinindex"))
            {
                // add the letter they asked for and the kinds of status we want to show
                reader.AddParameter("char", letter);
                reader.AddParameter("siteID", siteId);

                reader.AddParameter("showApproved", showApproved);
                reader.AddParameter("showSubmitted", showSubmitted);
                reader.AddParameter("showUnapproved", showUnapproved);

                // Check to see if we're looking for results with users in a specific group

                if (groups.Length > 0)
                {
                    reader.AddParameter("Group", groups);
                }

                // If we've been given a sort value, add it
                if (orderBy > 0)
                {
                     reader.AddParameter("OrderBy", orderBy);
                }

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.IndexNotFound);
                }
                else
                {
                    index = new Index();
                    index.Count = reader.GetInt32NullAsZero("Count");
                    index.Letter = letter;
                    index.IndexEntries = new List<ArticleSummary>();
                    do
                    {
                        ArticleSummary articleSummary = new ArticleSummary();
                        articleSummary.H2G2ID = reader.GetInt32NullAsZero("h2g2ID");
                        articleSummary.Name = reader.GetStringNullAsEmpty("Subject");
                        articleSummary.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("subject")); 
                        articleSummary.Status = ArticleStatus.GetStatus(reader.GetInt32NullAsZero("status"));
                        articleSummary.Type = (Article.ArticleType)Enum.Parse(typeof(Article.ArticleType), reader.GetInt32NullAsZero("type").ToString());
                        articleSummary.Editor = new UserElement() { user = User.CreateUserFromReader(reader) };

                        articleSummary.DateCreated = new DateElement(reader.GetDateTime("datecreated"));
                        articleSummary.LastUpdated = new DateElement(reader.GetDateTime("lastupdated"));

                        index.IndexEntries.Add(articleSummary);

                    } while (reader.Read());
                }
            }
            return index;
        }
    }

}
