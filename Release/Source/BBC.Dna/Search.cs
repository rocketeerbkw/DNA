using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Component for implementing free text search.
    /// </summary>
    public class Search : DnaInputComponent
    {
        private XmlElement _searchElement;

        /// <summary>
        /// Default constructor for the Search component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public Search(IInputContext context)
            : base(context)
        {
            _searchElement = AddElementTag(RootElement,"SEARCH");
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {

            string searchQuery = InputContext.GetParamStringOrEmpty("searchstring","searchstring");

            // Show Options.
            bool showApproved = InputContext.GetParamIntOrZero("showapproved", "showapproved") != 0;
            bool showNormal = InputContext.GetParamIntOrZero("shownormal","shownormal") != 0;
            bool showSubmitted = InputContext.GetParamIntOrZero("showsubmitted","showsubmitted") != 0;
            if (showApproved == showNormal == showSubmitted == false)
            {
                showApproved = true;
                showNormal = true;
                showSubmitted = true;
            }
            bool showContentRating = InputContext.GetParamIntOrZero("showcontentratingdata","showcontentratingdata") != 0;
            bool showPhrases = InputContext.GetParamIntOrZero("showphrases","showphrases") != 0;
         
            //Skip and Show.
            int show = InputContext.GetSiteOptionValueInt("ArticleSearch", "DefaultShow");
            if (InputContext.DoesParamExist("show", "show"))
            {
                show = InputContext.GetParamIntOrZero("show", "show");
            }
            int skip = InputContext.GetParamIntOrZero("skip","skip");

            //Get use groups filter as a comma separated string.
            string userGroups = string.Empty;
            for ( int count = 0; count < InputContext.GetParamCountOrZero("usergroups","usergroups"); ++count )
            {
                if ( userGroups != string.Empty )
                {
                    userGroups += ",";
                }
                 userGroups += InputContext.GetParamStringOrEmpty("usergroup",count,"usergroup");
            }

            int nodeId = InputContext.GetParamIntOrZero("category","category");

            //Support for GOOSearch.
            string searchtype = InputContext.GetParamStringOrEmpty("searchtype","searchtype");
            if ( searchtype == "GOOSEARCH")
            {
                if (searchQuery.Contains("@"))
                {
                    searchtype = "USER";
                }
                else
                {
                    searchtype = "ARTICLE";
                }
            }
            

            string failed = string.Empty;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, searchQuery, out failed);
            if ( state == ProfanityFilter.FilterState.FailBlock && !InputContext.ViewingUser.IsEditor )
            {
                //Error - search query failed profanity check.
                //TODO:  Need to insert profanity error.
                return;
            }

            //set up recent search object
            RecentSearch recentsearch = new RecentSearch(InputContext);

            //Article Search
            if ( InputContext.GetParamIntOrZero("article","article") == 1 || searchtype.ToUpper() == "ARTICLE")
            {
                bool useFreeTextSearch = InputContext.GetParamIntOrZero("usefreetextsearch", "UseFreeTextSearch") == 1;
			    int articleType = InputContext.GetParamIntOrZero("articletype","articletype");
			    bool bResults = ArticleSearch(searchQuery, showApproved, showNormal, showSubmitted, showContentRating, showPhrases, userGroups, skip, show,nodeId, articleType, useFreeTextSearch );

                //add recent search values
                recentsearch.AddSearchTerm(searchQuery, RecentSearch.SEARCHTYPE.ARTICLE);
            }

            //User Search.
            if ( InputContext.GetParamIntOrZero("user","user") == 1 || searchtype.ToUpper() == "USER"  )
            {
                bool currentSiteOnly = InputContext.GetParamIntOrZero("thissite","current site only") == 1;
                UserSearch(searchQuery,skip,show,currentSiteOnly);

                //add recent search values
                recentsearch.AddSearchTerm(searchQuery, RecentSearch.SEARCHTYPE.USER);

                
            }

            if (InputContext.GetParamIntOrZero("hierarchy", "hierarchy") == 1 || searchtype.ToUpper() == "HIERARCHY" )
            {
                HierarchySearch(searchQuery, skip, show);

                //add recent search values
                recentsearch.AddSearchTerm(searchQuery, RecentSearch.SEARCHTYPE.HIERARCHY);
            }

            if (InputContext.GetParamIntOrZero("forum", "forum") == 1 || searchtype.ToUpper() == "FORUM")
            {
                int threadId = InputContext.GetParamIntOrZero("forumid","forumid");
                int forumId = InputContext.GetParamIntOrZero("threadid","threadid");
                ForumSearch(searchQuery, skip, show, userGroups, nodeId, threadId, forumId);

                //add recent search values
                recentsearch.AddSearchTerm(searchQuery, RecentSearch.SEARCHTYPE.FORUM);
            }

            //Add All User Groups.
            XmlElement groups = UserGroupsHelper.GetSiteGroupsElement(InputContext.CurrentSite.SiteID, InputContext);
            RootElement.AppendChild(ImportNode(groups));
            
            //Add Functionality / Parameters for each search type.
            /*XmlElement functionality = AddElementTag(RootElement, "FUNCTIONALITY");
            XmlElement searchArticles = AddElementTag(functionality, "SEARCHARTICLES");
            if (InputContext.GetParamIntOrZero("article", "article") == 1)
            {
                AddAttribute(searchArticles, "SELECTED", 1);
            }
            AddElementTag(searchArticles, "SHOWAPPROVED");
            AddElementTag(searchArticles, "SHOWNORMAL");
            AddElementTag(searchArticles, "SHOWSUBMITTED");

            XmlElement searchUsers = AddElementTag(functionality, "SEARCHUSERS");
            if (InputContext.GetParamIntOrZero("users", "users") == 1)
            {
                AddAttribute(searchUsers, "SELECTED", 1);
            }

            XmlElement searchForums = AddElementTag(functionality, "SEARCHFORUMS");
            if (InputContext.GetParamIntOrZero("forums", "forums") == 1)
            {
                AddAttribute(searchForums, "SELECTED", 1);
            }*/
        }

        /// <summary>
        /// Generates the SQL Search Query.
        /// </summary>
        /// <param name="searchQuery"></param>
        /// <returns></returns>
        private string GenerateSearchQuery(string searchQuery)
        {
            char[] delimiters = { ',', ' ' };
            DnaStringParser stringparser = new DnaStringParser(searchQuery, delimiters,true,true,false);
            string[] queries = stringparser.Parse();

            string search = "isabout(";
            string comma = " ";
            foreach (string query in queries)
            {
                search += comma + query + " weight (0.5)";
                comma = ",";
            }

            foreach (string query in queries)
            {
                search += comma + "formsof(inflectional, " + query + ") weight(0.25)";
                comma = ",";
            }

            search += comma + "\"" + searchQuery + "\"" + " weight(1.0)";
            search += ")";

            return search;
        }

        /// <summary>
        /// Generates an "AND" search query
        /// </summary>
        /// <param name="searchQuery">the original search query</param>
        /// <returns>the search term to pass into the stored proc</returns>
        private string GenerateANDSearchQuery(string searchQuery)
        {
            char[] delimiters = { ',', ' ' };
            DnaStringParser stringparser = new DnaStringParser(searchQuery, delimiters,true,true,false);
            string[] queries = stringparser.Parse();

            string search = string.Empty;
            for (int i = 0; i < queries.GetLength(0) - 1; i++)
            {
                search += "\"" + queries[i] + "\"" + " AND ";
            }

            search += "\"" + queries[queries.GetLength(0)-1] + "\"";

            return search;
        }
        /// <summary>
        /// Implements an Article Search.
        /// </summary>
        /// <param name="query"></param>
        /// <param name="showApproved"></param>
        /// <param name="showNormal"></param>
        /// <param name="showSubmitted"></param>
        /// <param name="showContentRating"></param>
        /// <param name="showPhrases"></param>
        /// <param name="userGroups"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="nodeId"></param>
        /// <param name="articleType"></param>
        /// <param name="useFreeTextSearch"></param>
        /// <returns></returns>
        public bool ArticleSearch(string query, bool showApproved, bool showNormal, bool showSubmitted, bool showContentRating, bool showPhrases, string userGroups, int skip, int show, int nodeId, int articleType, bool useFreeTextSearch )
        {
            XmlElement searchResults = AddElementTag(_searchElement, "SEARCHRESULTS");
            AddAttribute(searchResults, "TYPE", "ARTICLE");
            AddTextElement(searchResults, "SEARCHTERM", query);

            AddIntElement(searchResults, "SHOWAPPROVED", Convert.ToInt32(showApproved));
            AddIntElement(searchResults, "SHOWNORMAL", Convert.ToInt32(showNormal));
            AddIntElement(searchResults, "SHOWSUBMITTED", Convert.ToInt32(showSubmitted));
            AddIntElement(searchResults, "SHOWCONTENTRATING", Convert.ToInt32(showContentRating));
            AddIntElement(searchResults, "SHOWPHRASES", Convert.ToInt32(showPhrases));
            AddIntElement(searchResults, "USEFREETEXTSEARCH", Convert.ToInt32(useFreeTextSearch));

            bool bUseFastSearch = UseFastSearch();

            //if (bUseFastSearch)
            //{
            query = GenerateANDSearchQuery(query);
            //}
            //else
            //{
            //    query = GenerateSearchQuery(query);
            //}
            
            string SP = "searcharticlesadvanced";
            if (useFreeTextSearch)
            {
                SP = "searcharticlesadvancedfreetext";
            }
            else if (bUseFastSearch)
            {
                SP = "searcharticlesfast";
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader( SP ))
            {
                if (bUseFastSearch)
                {
                    dataReader.AddParameter("@condition", query);
                    dataReader.AddParameter("@top", skip + show);
                }
                else
                {
                    dataReader.AddParameter("@subjectcondition", query);
                    dataReader.AddParameter("@bodycondition", query);
                }

                dataReader.AddParameter("@shownormal", Convert.ToInt32(showNormal));
                dataReader.AddParameter("showsubmitted", Convert.ToInt32(showSubmitted));
                dataReader.AddParameter("showapproved", Convert.ToInt32(showApproved));
                if (userGroups != string.Empty)
                {
                    dataReader.AddParameter("@usergroups", userGroups);
                }
                dataReader.AddParameter("@primarysite", InputContext.CurrentSite.SiteID);
                if (nodeId > 0)
                {
                    dataReader.AddParameter("@withincategory", nodeId);
                }
                dataReader.AddParameter("@showcontentratingdata", Convert.ToInt32(showContentRating));
                if (articleType > 0)
                {
                    dataReader.AddParameter("@articletype", articleType);
                }
                dataReader.AddParameter("@showkeyphrases", Convert.ToInt32(showPhrases));

                dataReader.Execute();

                //Skip desired items.
                for (int i = 0; i < skip; ++i)
                {
                    dataReader.Read();
                }

                int entryId = 0;
                int results = 0;
                XmlElement result = null;
                XmlElement phrases = null;
                while (dataReader.Read() )
                {
                    if (entryId != dataReader.GetInt32NullAsZero("entryid"))
                    {
                        if (results >= show)
                        {
                            break;
                        }

                        entryId = dataReader.GetInt32NullAsZero("entryid");
                        result = AddElementTag(searchResults, "ARTICLERESULT");
                        AddIntElement(result, "STATUS", dataReader.GetInt32NullAsZero("status"));
                        AddIntElement(result, "TYPE", dataReader.GetInt32NullAsZero("type"));
                        AddIntElement(result, "ENTRYID", entryId );
                        AddTextElement(result, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));
                        AddIntElement(result, "H2G2ID", dataReader.GetInt32NullAsZero("h2g2id"));
                        AddDateXml(dataReader.GetDateTime("datecreated"), result, "DATECREATED");
                        AddDateXml(dataReader.GetDateTime("lastupdated"), result, "LASTUPDATED");

                        if (!dataReader.IsDBNull("startdate"))
                        {
                            AddDateXml(dataReader.GetDateTime("startdate"), result, "DATERANGESTART");
                        }

                        if (!dataReader.IsDBNull("enddate"))
                        {
                            DateTime articlesDateRangeEnd = dataReader.GetDateTime("enddate");
				            // Take a day from the end date as stored in the database for UI purposes. 
				            // E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
				            // This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
				            // original dates submitted by the user inorder to match their expectations.
                            AddDateXml(dataReader.GetDateTime("enddate").AddDays(-1), result, "DATERANGEEND");
                        }

                        if (!dataReader.IsDBNull("timeinterval"))
                        {
                            AddIntElement(result, "TIMEINTERVAL", dataReader.GetInt32NullAsZero("timeinterval"));
                        }

                        int scorePercent = Convert.ToInt32(dataReader.GetDouble(dataReader.GetOrdinal("score")) * 100.0);
                        AddIntElement(result, "SCORE", scorePercent);
                        AddIntElement(result, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
                        AddIntElement(result, "PRIMARYSITE", InputContext.CurrentSite.SiteID == dataReader.GetInt32NullAsZero("siteid") ? 1 : 0);

                        ++results;

                        //Add Extra Info XML where it exists.
                        string extraInfo = dataReader.GetAmpersandEscapedStringNullAsEmpty("extrainfo");
                        if (extraInfo != string.Empty)
                        {
                            XmlDocument extraInfoXml = new XmlDocument();
                            extraInfoXml.LoadXml(extraInfo);
                            result.AppendChild(ImportNode(extraInfoXml.FirstChild));
                        }

                        //Add Content Rating.
                        if (showContentRating)
                        {
                        }

                        if (showPhrases)
                        {
                            phrases = AddElementTag(result, "PHRASES");
                        }
                    }

                    //Add phrases XML.
                    if ( phrases != null && !dataReader.IsDBNull("phrase") )
                    {
                        Phrase phrase = new Phrase();
                        phrase.NameSpace = dataReader.GetStringNullAsEmpty("namespace");
                        phrase.PhraseName = dataReader.GetStringNullAsEmpty("phrase");
                        phrase.AddPhraseXml(phrases);
                    }
                }

                AddIntElement(searchResults,"SKIP",skip);
                AddIntElement(searchResults,"SHOW",show);
                AddIntElement(searchResults,"MORE", Convert.ToInt32(!dataReader.IsClosed) );
            }
            return true;
        }

        static private string useFastSearchDesc = "Set usefastsearch to 0 or 1 to override the FastFreetextSearch siteoption";

        /// <summary>
        /// Determines whether we should use the fast free text search, based on the URL and site option
        /// </summary>
        /// <returns>true if we should use fast free text search</returns>
        private bool UseFastSearch()
        {
            // if usefastsearch is on the URL, use it's value to override the site option setting

            if (InputContext.DoesParamExist("usefastsearch", useFastSearchDesc))
            {
                return InputContext.GetParamIntOrZero("usefastsearch", useFastSearchDesc) == 1;
            }
            else
            {
                return InputContext.GetSiteOptionValueBool("ArticleSearch", "FastFreetextSearch");
            }
        }

        /// <summary>
        /// Implements a user search on users name or email address ( editor only ).
        /// </summary>
        /// <param name="searchQuery"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="currentSiteOnly"></param>
        /// <returns></returns>
        public bool UserSearch(string searchQuery, int skip, int show, bool currentSiteOnly )
        {
            XmlElement searchResults = AddElementTag(_searchElement, "SEARCHRESULTS");
            AddAttribute(searchResults, "TYPE", "USER");
            AddTextElement(searchResults, "SEARCHTERM", searchQuery);
            AddIntElement(searchResults, "CURRENTSITEONLY", Convert.ToInt32(currentSiteOnly));

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("SearchUsersByNameOrEmail"))
            {
                dataReader.AddParameter("NameOrEmail",searchQuery);
                if ( currentSiteOnly )
                {
                    dataReader.AddParameter("siteid",InputContext.CurrentSite.SiteID);
                }

                if (InputContext.ViewingUser.IsEditor)
                {
                    dataReader.AddParameter("searchemails", 1);
                }

                dataReader.Execute();

                //Skip Results.
                for (int i = 0; i < skip; ++i)
                {
                    dataReader.Read();
                }

                int results = 0;
                while (dataReader.Read() && results < show )
                {
                    XmlElement result = AddElementTag(searchResults,"USERRESULT");
                    AddIntElement(result, "USERID", dataReader.GetInt32NullAsZero("userid"));
                    AddTextElement(result, "USERNAME", dataReader.GetStringNullAsEmpty("username"));
                    if (!dataReader.IsDBNull("title"))
                    {
                        AddTextElement(result, "TITLE", dataReader.GetStringNullAsEmpty("title"));
                    }
                    if (!dataReader.IsDBNull("firstnames"))
                    {
                        AddTextElement(result, "FIRTSTNAME", dataReader.GetStringNullAsEmpty("firstnames"));
                    }
                    if (!dataReader.IsDBNull("lastname"))
                    {
                        AddTextElement(result, "LASTNAME", dataReader.GetStringNullAsEmpty("lastname"));
                    }
                    if (!dataReader.IsDBNull("sitesuffix"))
                    {
                        AddTextElement(result, "SITESUFFIX", dataReader.GetStringNullAsEmpty("sitesuffix"));
                    }
                    if (!dataReader.IsDBNull("area"))
                    {
                        AddTextElement(result, "AREA", dataReader.GetStringNullAsEmpty("area"));
                    }
                    if (!dataReader.IsDBNull("TaxonomyNode"))
                    {
                        AddIntElement(result, "TAXONOMYNODE",dataReader.GetInt32NullAsZero("taxonomynode"));
                    }

                    ++results;
                }

                AddIntElement(searchResults, "SKIP", skip);
                AddIntElement(searchResults, "SHOW", show);
                AddIntElement(searchResults, "MORE", Convert.ToInt32(!dataReader.IsClosed));

            }

            return true;
        }

        /// <summary>
        /// Performs a hiearchy Search each result is returned with ancestors.
        /// </summary>
        /// <param name="searchQuery"></param>
        /// <param name="skip">Skip sesarch result + ancestors.</param>
        /// <param name="show">Show result + ancestors.</param>
        /// <returns></returns>
        public bool HierarchySearch( string searchQuery, int skip, int show )
        {
            XmlElement searchresults = AddElementTag(_searchElement, "SEARCHRESULTS");
            AddAttribute(searchresults, "TYPE", "HIERARCHY");
            AddTextElement(searchresults, "SEARCHTERM", searchQuery);

            searchQuery = GenerateSearchQuery(searchQuery);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("searchhierarchy") )
            {
                dataReader.AddParameter("@subjectcondition", searchQuery);
                dataReader.AddParameter("@siteid", InputContext.CurrentSite.SiteID);

                dataReader.Execute();

                //Skip needs to skip each result + ancestors. 
                int count = 0;
                while (dataReader.Read() && skip > count )
                {
                    if (dataReader.GetInt32NullAsZero("nodeid") == dataReader.GetInt32NullAsZero("key"))
                    {
                        ++count;
                    }
                }


                XmlElement hierarchyResult = null;
                while (dataReader.Read() )
                {
                    if (hierarchyResult == null)
                    {
                        hierarchyResult = AddElementTag(searchresults, "HIERARCHYRESULT");
                    }

                    if (dataReader.GetInt32NullAsZero("nodeid") == dataReader.GetInt32NullAsZero("key"))
                    {
                        XmlElement nodeId = AddIntElement(hierarchyResult, "NODEID", dataReader.GetInt32NullAsZero("nodeid"));
                        AddAttribute(nodeId, "USERADD", Convert.ToInt32(dataReader.GetBoolean("useradd")));
                        AddIntElement(hierarchyResult, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
                        AddTextElement(hierarchyResult, "DISPLAYNAME", dataReader.GetStringNullAsEmpty("displayname"));
                        AddIntElement(hierarchyResult, "TYPE", dataReader.GetInt32NullAsZero("type"));
                        AddIntElement(hierarchyResult, "NODECOUNT", dataReader.GetInt32NullAsZero("nodemembers"));
                        if (!dataReader.IsDBNull("redirectnodeid"))
                        {
                            AddIntElement(hierarchyResult, "REDIRECTNODEID", dataReader.GetInt32NullAsZero("redirectnodeid"));
                        }
                        hierarchyResult = null;
                    }
                    else
                    {
                        XmlElement ancestor = AddTextElement(hierarchyResult, "ANCESTOR", dataReader.GetStringNullAsEmpty("displayname"));
                        AddAttribute(ancestor, "NODEID", dataReader.GetInt32NullAsZero("nodeid"));
                        if (!dataReader.IsDBNull("redirectnodeid"))
                        {
                            AddAttribute(ancestor, "REDIRECTID", dataReader.GetInt32NullAsZero("redirectid"));
                        }
                    }
                }

                AddIntElement(searchresults, "SKIP", skip);
                AddIntElement(searchresults, "SHOW", show);
                AddIntElement(searchresults, "MORE", Convert.ToInt32(!dataReader.IsClosed) );
            }
            return true;
        }

        /// <summary>
        /// Executes a forum search and generates XML.
        /// </summary>
        /// <param name="searchQuery"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="groupsFilter"></param>
        /// <param name="category"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        public bool ForumSearch( string searchQuery, int skip, int show, string groupsFilter, int category, int threadId, int forumId)
        {
            XmlElement searchresults = AddElementTag(_searchElement, "SEARCHRESULTS");
            AddAttribute(searchresults, "TYPE", "HIERARCHY");
            AddTextElement(searchresults, "SEARCHTERM", searchQuery);

            searchQuery = GenerateSearchQuery(searchQuery);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("searchforumsadvanced"))
            {
                dataReader.AddParameter("@condition",searchQuery);
                dataReader.AddParameter("@primarysite", InputContext.CurrentSite.SiteID);
                if (forumId > 0)
                {
                    dataReader.AddParameter("@forumid", forumId);
                }
                if (threadId > 0)
                {
                    dataReader.AddParameter("@threadid", threadId);
                }
                if (groupsFilter != string.Empty)
                {
                    dataReader.AddParameter("@usergroups", groupsFilter);
                }
                dataReader.Execute();

                //Need to skip to start of results.
                for (int i = 0; i < skip; ++i)
                {
                    dataReader.Read();
                }

                int results = 0;
                while (dataReader.Read() && results < show)
                {
                    XmlElement forumResult = AddElementTag(searchresults, "FORUMRESULT");
                    AddIntElement(forumResult, "POSTID", dataReader.GetInt32NullAsZero("postid"));
                    AddTextElement(forumResult, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));
                    AddIntElement(forumResult, "FORUMID", dataReader.GetInt32NullAsZero("forumid"));
                    AddIntElement(forumResult, "THREADID", dataReader.GetInt32NullAsZero("threadid"));

                    int score = Convert.ToInt32(dataReader.GetDoubleNullAsZero("score") * 100.0);
                    AddIntElement(forumResult, "SCORE", score);
                    AddIntElement(forumResult, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
                    int primarySite = dataReader.GetInt32NullAsZero("siteid") == InputContext.CurrentSite.SiteID ? 1 : 0;
                    AddIntElement(forumResult, "PRIMARYSITE", primarySite);
                    ++results;
                }

                AddIntElement(searchresults, "SKIP", skip);
                AddIntElement(searchresults, "SHOW", show);
                AddIntElement(searchresults, "MORE", Convert.ToInt32(!dataReader.IsClosed));
                AddIntElement(searchresults, "FORUMID", forumId);
                AddIntElement(searchresults, "THREADID", threadId);
            }
            return true;
        }
    }
}
