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
using BBC.Dna.Api;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{ 
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true, TypeName="SEARCH")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "SEARCH")]
    [DataContract(Name="search")]
    public partial class Search
    {
        /// <remarks/>
        [XmlElement(ElementName="RECENTSEARCHES")]
        public List<SearchTerm> RecentSearches
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName="SEARCHRESULTS")]
        [DataMember(Name = "searchResults")]
        public SearchResults SearchResults
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName="FUNCTIONALITY")]
        public Functionality Functionality
        {
            get;
            set;
        }

        /// <summary>
        /// Gets Search data from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static Search CreateSearch(ICacheManager cache, IDnaDataReaderCreator readerCreator, int siteId, string searchString, string searchType, bool showApproved, bool showNormal, bool showSubmitted, int startIndex, int itemsPerPage, bool useFastSearch)
        {
            return CreateSearch(cache, readerCreator, siteId, searchString, searchType, showApproved, showNormal, showSubmitted, 0, 20, useFastSearch, false);
        }

        /// <summary>
        /// Gets Recommendations from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Search CreateSearch(ICacheManager cache, IDnaDataReaderCreator readerCreator, int siteId, string searchString, string searchType, bool showApproved, bool showNormal, bool showSubmitted, int startIndex, int itemsPerPage, bool useFastSearch, bool ignoreCache)
        {
            var search = new Search();

            //string key = search.GetCacheKey(searchString, searchType, showApproved);
            //check for item in the cache first
            /*
            if (!ignoreCache)
            {
                //not ignoring cache
                search = (Search)cache.GetData(key);
                if (search != null)
                {
                    //check if still valid with db...
                    if (search.IsUpToDate(readerCreator))
                    {
                        return search;
                    }
                }
            }
            */

            if (searchType == "ARTICLE")
            {
                //create article search from db
                search = CreateArticleSearchFromDatabase(readerCreator, siteId, searchString, searchType, showApproved, showNormal, showSubmitted, startIndex, itemsPerPage, useFastSearch);
            }
            else //USER search
            {
                bool allowEmails = false;

                
                //create article search from db
                search = CreateUserSearchFromDatabase(readerCreator, siteId, searchString, searchType, allowEmails, startIndex, itemsPerPage);
            }

            //add to cache
            //cache.Add(key, search);

            return search;
        }

        /// <summary>
        /// Generates an "AND" search query
        /// </summary>
        /// <param name="searchQuery">the original search query</param>
        /// <returns>the search term to pass into the stored proc</returns>
        public static string GenerateANDSearchQuery(string searchQuery)
        {
            char[] delimiters = { ',', ' ' };
            DnaStringParser stringparser = new DnaStringParser(searchQuery, delimiters, true, true, false);
            string[] queries = stringparser.Parse();

            return SearchThreadPosts.FormatSearchTerm(ref queries);
        }

        /// <summary>
        /// Creates the article search from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static Search CreateArticleSearchFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                            int siteId, 
                                                            string searchString, 
                                                            string searchType, 
                                                            bool showApproved, 
                                                            bool showNormal, 
                                                            bool showSubmitted, 
                                                            int startIndex, 
                                                            int itemsPerPage,
                                                            bool useFastSearch)
        {
            Search search = null;
            int count = 0;

            string query = GenerateANDSearchQuery(searchString);

            string searchSP = "searcharticlesadvanced";
            if (useFastSearch)
            {
                searchSP = "searcharticlesfast";
            }


            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(searchSP))
            {
                if (useFastSearch)
                {
                    reader.AddParameter("condition", query);
                    //Cap max results to 200 and then allow skip and show within that range
                    //reader.AddParameter("top", startIndex + itemsPerPage);
                    reader.AddParameter("top", 200);
                }
                else
                {
                    reader.AddParameter("subjectcondition", query);
                    reader.AddParameter("bodycondition", query);
                }

                reader.AddParameter("shownormal", Convert.ToInt32(showNormal));
                reader.AddParameter("showsubmitted", Convert.ToInt32(showSubmitted));
                reader.AddParameter("showapproved", Convert.ToInt32(showApproved));

                reader.AddParameter("primarysite", siteId);
                //Cap max results to 200 and then allow skip and show within that range
                reader.AddParameter("maxresults", 200);

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.NoResults);
                }
                else
                {
                    if (startIndex > 0)
                    {
                        for (int i = 1; i < startIndex; i++)
                        {
                            reader.Read();
                        }
                    }

                    search = new Search();
                    search.SearchResults = new SearchResults();
                    search.SearchResults.SearchTerm = HtmlUtils.HtmlDecode(searchString);
                    search.SearchResults.Type = searchType;
                    search.SearchResults.StartIndex = startIndex;
                    search.SearchResults.ItemsPerPage = itemsPerPage;

                    search.SearchResults.ArticleResults = new List<ArticleResult>();
                    do
                    {                      
                        ArticleResult articleResult = new ArticleResult();

                        articleResult.EntryId = reader.GetInt32NullAsZero("entryid");
                        articleResult.Status = reader.GetInt32NullAsZero("status");
                        articleResult.Type = reader.GetInt32NullAsZero("type");

                        articleResult.Subject = reader.GetStringNullAsEmpty("subject");
                        articleResult.H2G2Id = reader.GetInt32NullAsZero("h2g2id");

                        DateTime dateCreated = DateTime.MinValue;
                        bool existsDateCreated = !reader.IsDBNull("datecreated");
                        if (existsDateCreated)
                        {
                            dateCreated = reader.GetDateTime("datecreated");
                        }
                        articleResult.DateCreated = new DateElement(dateCreated);

                        DateTime dateLastUpdated = DateTime.MinValue;
                        bool existsLastUpdated = !reader.IsDBNull("lastupdated");
                        if (existsLastUpdated)
                        {
                            dateLastUpdated = reader.GetDateTime("lastupdated");
                        }
                        articleResult.LastUpdated = new DateElement(dateLastUpdated);

                        int scorePercent = 0;
                        scorePercent = Convert.ToInt32(reader.GetDouble(reader.GetOrdinal("score")) * 100.0);
                        //scorePercent = reader.GetInt32NullAsZero("score");
                        articleResult.Score = scorePercent;

                        articleResult.SiteId = reader.GetInt32NullAsZero("siteid");
                        articleResult.PrimarySite = (siteId == reader.GetInt32NullAsZero("siteid") ? 1 : 0);

                        articleResult.ExtraInfo = new ExtraInfoCreator();

                        //Only add primary site articles returned for now
                        if (articleResult.PrimarySite == 1)
                        {
                            search.SearchResults.ArticleResults.Add(articleResult);
                            count++;
                        }

                    } while (reader.Read());
                }
                search.SearchResults.Count = count;
            }
            return search;
        }
        /// <summary>
        /// Creates the article search from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static Search CreateUserSearchFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, string searchString, string searchType, bool allowEmails, int startIndex, int itemsPerPage)
        {
            Search search = null;
            int count = 0;

            string query = GenerateANDSearchQuery(searchString);

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("SearchUsersByNameOrEmail"))
            {
                reader.AddParameter("NameOrEmail", query);

                if (allowEmails)
                {
                    reader.AddParameter("searchemails", 1);
                }
                else
                {
                    reader.AddParameter("searchemails", 0);
                }

                reader.AddParameter("SiteID", siteId);
                reader.AddParameter("skip", startIndex);
                reader.AddParameter("show", itemsPerPage);

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.NoResults);
                }
                else
                {
                    search = new Search();
                    search.SearchResults = new SearchResults();
                    search.SearchResults.SearchTerm = searchString;
                    search.SearchResults.Type = searchType;
                    search.SearchResults.StartIndex = startIndex;
                    search.SearchResults.ItemsPerPage = itemsPerPage;
                    search.SearchResults.Total = reader.GetInt32NullAsZero("Total") ;

                    search.SearchResults.UserResults = new List<UserElement>();
                    do
                    {   UserElement user = new UserElement() { user = User.CreateUserFromReader(reader)} ;
                        search.SearchResults.UserResults.Add(user);
                        count++;

                    } while (reader.Read());
                }
                search.SearchResults.Count = count;
            }
            return search;
        }
    }

    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    public partial class SearchTerm
    {
                
        /// <remarks/>
        [XmlElement(ElementName="NAME")]
        public string Name
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "TYPE")]
        public string Type
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "TIMESTAMP")]
        public string Timestamp
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "COUNT")]
        public int Count
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    [DataContract(Name="searchResults")]
    public partial class SearchResults
    {       
        /// <remarks/>
        [XmlElement(ElementName = "SEARCHTERM")]
        [DataMember(Name = "searchTerm")]
        public string SearchTerm
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SAFESEARCHTERM")]
        [DataMember(Name = "safeSearchTerm")]
        public string SafeSearchTerm
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElement("ARTICLERESULT")]
        [DataMember(Name = "articleResults")]
        public List<ArticleResult> ArticleResults
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElement("USERRESULT")]
        [DataMember(Name = "userResults")]
        public List<UserElement> UserResults
        {
            get;
            set;
        }
       
        /// <remarks/>
        public int Skip
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count")]
        public int Count
        {
            get;
            set;
        }

        /// <remarks/>
        [DataMember(Name = "startIndex")]
        public int StartIndex
        {
            get;
            set;
        }
        /// <remarks/>
        [DataMember(Name = "itemsPerPage")]
        public int ItemsPerPage
        {
            get;
            set;
        }
        /// <remarks/>
        [DataMember(Name = "total")]
        public int Total
        {
            get;
            set;
        }
        
        /// <remarks/>
        public int More
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttribute(AttributeName="TYPE")]
        [DataMember(Name = "type")]
        public string Type
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    [DataContract(Name = "articleResult")]
    public partial class ArticleResult
    {       
        /// <remarks/>
        [XmlElement(ElementName = "STATUS")]
        [DataMember(Name = "status")]
        public int Status
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "TYPE")]
        [DataMember(Name = "type")]
        public int Type
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "ENTRYID")]
        [DataMember(Name = "entryId")]
        public int EntryId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "H2G2ID")]
        [DataMember(Name = "H2G2Id")]
        public int H2G2Id
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "DATECREATED")]
        [DataMember(Name = "dateCreated")]
        public DateElement DateCreated
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "LASTUPDATED")]
        [DataMember(Name = "lastUpdated")]
        public DateElement LastUpdated
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SCORE")]
        [DataMember(Name = "score")]
        public int Score
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SITEID")]
        [DataMember(Name = "siteId")]
        public int SiteId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "PRIMARYSITE")]
        [DataMember(Name = "primarySite")]
        public int PrimarySite
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "EXTRAINFO")]
        [DataMember(Name = "extraInfo")]
        public ExtraInfoCreator ExtraInfo
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    public partial class ArticleResultsExtraInfo
    {       
        /// <remarks/>
        [XmlElement(ElementName = "EDITOR")]
        public User Editor
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttribute(AttributeName = "TYPE")]
        public int Type
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    [DataContract(Name = "functionality")]
    public partial class Functionality
    {        
        /// <remarks/>
        [XmlElement (ElementName = "SEARCHARTICLES")]
        public SearchArticles SearchArticles
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SEARCHFORUMS")]
        public string SearchForums
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SEARCHUSERS")]
        public SearchUsers SearchUsers
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true)]
    [DataContract(Name = "searchArticles")]
    public partial class SearchArticles
    {       
        /// <remarks/>
        [XmlElement(ElementName = "SHOWAPPROVED")]
        public int ShowApproved
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SHOWNORMAL")]
        public int ShowNormal
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElement(ElementName = "SHOWSUBMITTED")]
        public int ShowSubmitted
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttribute(AttributeName = "SELECTED")]
        public int Selected
        {
            get;
            set;
        }
    }
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true)]
    [DataContract(Name = "searchUsers")]
    public partial class SearchUsers
    {
        /// <remarks/>
        [XmlAttribute(AttributeName = "SELECTED")]
        public int Selected
        {
            get;
            set;
        }
    }
}
