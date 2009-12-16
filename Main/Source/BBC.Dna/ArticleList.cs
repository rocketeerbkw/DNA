using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class to retrieve a list of articles of certain types
    /// </summary>
    public class ArticleList : DnaInputComponent
    {
        /// <summary>
        /// ArticleList Typ enum
        /// </summary>
        public enum ArticleListType
        {
            /// <summary>
            /// First Article Type
            /// </summary>
            ARTICLELISTTYPE_FIRST = 1,

            /// <summary>
            /// Approved Articles
            /// </summary>
            ARTICLELISTTYPE_APPROVED = 1,

            /// <summary>
            /// 
            /// </summary>
            ARTICLELISTTYPE_NORMAL = 2,

            /// <summary>
            /// Cancelled Articles
            /// </summary>
            ARTICLELISTTYPE_CANCELLED = 3,

            /// <summary>
            /// Normal and Approved Articles
            /// </summary>
            ARTICLELISTTYPE_NORMALANDAPPROVED = 4,


            /// <summary>
            /// Last article type
            /// </summary>
            ARTICLELISTTYPE_LAST = 4	// Don't forget to update this!!!
        };

        string _cachedFileName = String.Empty;

        /// <summary>
        /// Default Constructor for the ArticleList object
        /// </summary>
        public ArticleList(IInputContext context)
            : base(context)
        {
        }
        /// <summary>
        /// Functions generates the Recent Article List
        /// </summary>
        /// <param name="userID">The user of the Articles to get</param>
        /// <param name="siteID">Site of the Articles</param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRecentArticleList(int userID, int siteID, int skip, int show, int guideType)
        {
            return CreateArticleList(userID, siteID, skip, show, ArticleList.ArticleListType.ARTICLELISTTYPE_NORMAL, guideType);
        }
        /// <summary>
        /// Functions generates the Recent Approved Articles List
        /// </summary>
        /// <param name="userID">The user of the Articles to get</param>
        /// <param name="siteID">Site of the Articles</param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRecentApprovedArticlesList(int userID, int siteID, int skip, int show, int guideType)
        {
            return CreateArticleList(userID, siteID, skip, show, ArticleList.ArticleListType.ARTICLELISTTYPE_APPROVED, guideType);
        }

        /// <summary>
        /// Functions generates the Cancelled Articles List
        /// </summary>
        /// <param name="userID">The user of the Articles to get</param>
        /// <param name="siteID">Site of the Articles</param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateCancelledArticlesList(int userID, int siteID, int skip, int show, int guideType)
        {
	        return CreateArticleList(userID, siteID, skip, show, ArticleList.ArticleListType.ARTICLELISTTYPE_CANCELLED, guideType);
        }

        /// <summary>
        /// Functions generates the Recent Normal And Approved Articles List
        /// </summary>
        /// <param name="userID">The user of the Articles to get</param>
        /// <param name="siteID">Site of the Articles</param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRecentNormalAndApprovedArticlesList(int userID, int siteID, int skip, int show, int guideType)
        {
	        return CreateArticleList(userID, siteID, skip, show, ArticleList.ArticleListType.ARTICLELISTTYPE_NORMALANDAPPROVED, guideType);
        }

        /// <summary>
        /// Creates a list of articles representing the recommendations made
		///		by this particular scout.
        /// </summary>
        /// <param name="scoutID">The scout id for the recommended Articles to get</param>
        /// <param name="numberOfUnits">Number of Articles to show</param>
        /// <param name="unitType">Type of Article to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateScoutRecommendationsList(int scoutID, int numberOfUnits, string unitType)
        {
            RootElement.RemoveAll();
            XmlElement articleList = AddElementTag(RootElement, "ARTICLE-LIST");
            // now set the list type attribute
            AddAttribute(articleList, "TYPE", "SCOUT-RECOMMENDATIONS");
            AddAttribute(articleList, "UNIT-TYPE", unitType.ToLower());

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchScoutRecommendationsList"))
            {
                dataReader.AddParameter("ScoutID", scoutID);
                dataReader.AddParameter("UnitType", unitType.ToLower());
                dataReader.AddParameter("NumberOfUnits", numberOfUnits + 1);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    // use the generic helper method to create the actual list
                    CreateList(articleList, dataReader, 0, numberOfUnits + 1);
                }
            }
            return true;
        }

        /// <summary>
        /// Creates a list of articles representing the articles currently in
		///		the recommended entries list.
        /// </summary>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateUndecidedRecommendationsList(int skip, int show)
        {
            RootElement.RemoveAll();
            XmlElement articleList = AddElementTag(RootElement, "ARTICLE-LIST");
            // now set the list type attribute
            AddAttribute(articleList, "TYPE", "UNDECIDED-RECOMMENDATIONS");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchUndecidedRecommendations"))
            {
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    // use the generic helper method to create the actual list
                    CreateList(articleList, dataReader, skip, show + 1);
                }
            }
            return true;
        }

        /// <summary>
        /// Functions generates an Article List of the given type
        /// </summary>
        /// <param name="userID">The user of the Articles to get</param>
        /// <param name="siteID">Site of the Articles</param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <param name="whichType">Type of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Whether created ok</returns>
        private bool CreateArticleList(int userID, int siteID, int skip, int show, ArticleListType whichType, int guideType)
        {
            // check object is not already initialised
            if (userID <= 0 || show <= 0)
            {
                return false;
            }

            // Get the cache article list date
            DateTime expiryDate = CacheGetArticleListDate(userID, siteID);

            // Check to see if the article list is cached
            _cachedFileName = "AL" + userID.ToString() + "-" + Convert.ToString(skip + show - 1) + "-" + skip.ToString() + "-" + whichType.ToString() + "-" + siteID.ToString();
            // If we have a guidetype then add this as well. Leave it out when 0 will reuse older existing cached files.
            if (guideType > 0)
            {
                _cachedFileName += "-" + guideType.ToString();
            }
            _cachedFileName += ".xml";

            string cachedArticleList = "";
            if (InputContext.FileCacheGetItem("articlelist", _cachedFileName, ref expiryDate, ref cachedArticleList) && cachedArticleList.Length > 0)
            {
                // Create the journal from the cache
                CreateAndInsertCachedXML(cachedArticleList, "ARTICLE-LIST", true);

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return true;
            }
            
            int count = show;

            XmlElement articleList = AddElementTag(RootElement, "ARTICLE-LIST");
            AddAttribute(articleList, "COUNT", show);
            AddAttribute(articleList, "SKIPTO", skip);

            // now set the list type attribute
            switch (whichType)
            {
                case ArticleListType.ARTICLELISTTYPE_APPROVED :
                {
                    AddAttribute(articleList, "TYPE", "USER-RECENT-APPROVED");
                    break;
                }
                case ArticleListType.ARTICLELISTTYPE_NORMAL : 
                {
                    AddAttribute(articleList, "TYPE", "USER-RECENT-ENTRIES"); 
                    break;
                }
                case ArticleListType.ARTICLELISTTYPE_CANCELLED : 
                {
                    AddAttribute(articleList, "TYPE", "USER-RECENT-CANCELLED"); 
                    break;
                }
                case ArticleListType.ARTICLELISTTYPE_NORMALANDAPPROVED : 
                {
                    AddAttribute(articleList, "TYPE", "USER-RECENT-NORMALANDAPPROVED"); 
                    break;
                }
                default: 
                {
                    AddAttribute(articleList, "TYPE", "USER-RECENT-ENTRIES"); 
                    break;
                }
            }

            using (IDnaDataReader dataReader = GetUsersMostRecentEntries(userID, siteID, skip, show, whichType, guideType))	// Get +1 so we know if there are more left
            {
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    count = CreateList(articleList, dataReader, skip, show);
                }
            }
            //AddAttribute(commentsList, "COUNT", count);

            return true;
        }

        /// <summary>
        /// Helper method to create the list after a specific stored procedure
		///		has been called to return an appropriate results set.
        /// </summary>
        /// <param name="articleList"></param>
        /// <param name="dataReader"></param>
        /// <param name="skip">Number of Articles to skip</param>
        /// <param name="show">Number of Articles to show</param>
        /// <returns></returns>
        public int CreateList(XmlElement articleList, IDnaDataReader dataReader, int skip, int show)
        {
            int count = show;
            bool records = true;

            //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
            //the one required
            for (int i = 0; i < skip; i++)
            {
                records = dataReader.Read();
                if (!records)
                {
                    break;
                }
            }

            if (records)
            {
                do
                {
                    // Setup the article
                    XmlElement article = AddElementTag(articleList, "ARTICLE");

                    if (dataReader.DoesFieldExist("EntryID"))
                    {
                        AddIntElement(article, "ENTRY-ID", dataReader.GetInt32NullAsZero("EntryID"));
                    }
                    if (dataReader.DoesFieldExist("h2g2ID"))
                    {
                        AddAttribute(article, "H2G2ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                        //TODO: remove the H2G2-ID from all schemas and skins...
                        AddIntElement(article, "H2G2-ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                    }
                    if (dataReader.DoesFieldExist("SiteID"))
                    {
                        AddIntElement(article, "SITEID", dataReader.GetInt32NullAsZero("SiteID"));
                    }
                    if (dataReader.DoesFieldExist("RecommendationID"))
                    {
                        AddIntElement(article, "RECOMMENDATION-ID", dataReader.GetInt32NullAsZero("RecommendationID"));
                    }
                    if (dataReader.DoesFieldExist("NotificationSent"))
                    {
                        AddIntElement(article, "NOTIFIED", dataReader.GetBoolean("NotificationSent") ? 1 : 0);
                    }

                    User user = new User(InputContext);
                    if (dataReader.DoesFieldExist("Editor"))
                    {
                        // place all user details within a USER tag and structure them appropriately
                        // editor info
                        int editorID = dataReader.GetInt32NullAsZero("Editor");
                        XmlElement editorTag = AddElementTag(article, "EDITOR");
                        user.AddPrefixedUserXMLBlock(dataReader, editorID, "Editor", editorTag);
                    }

                    if (dataReader.DoesFieldExist("AuthorID"))
                    {
                        // author info
                        int authorID = dataReader.GetInt32NullAsZero("AuthorID");
                        XmlElement authorTag = AddElementTag(article, "AUTHOR");
                        user.AddPrefixedUserXMLBlock(dataReader, authorID, "Author", authorTag);
                    }

                    if (dataReader.DoesFieldExist("AcceptorID"))
                    {
                        // acceptor info (user that accepted a recommendation)
                        int acceptorID = dataReader.GetInt32NullAsZero("AcceptorID");
                        XmlElement acceptorTag = AddElementTag(article, "ACCEPTOR");
                        user.AddPrefixedUserXMLBlock(dataReader, acceptorID, "Acceptor", acceptorTag);
                    }

                    if (dataReader.DoesFieldExist("AllocatorID"))
                    {
                        // allocator info (user that allocated a recommendation to a sub)
                        int allocatorID = dataReader.GetInt32NullAsZero("AllocatorID");
                        XmlElement allocatorTag = AddElementTag(article, "ALLOCATOR");
                        user.AddPrefixedUserXMLBlock(dataReader, allocatorID, "Allocator", allocatorTag);
                    }

                    if (dataReader.DoesFieldExist("ScoutID"))
                    {
                        // scout info
                        int scoutID = dataReader.GetInt32NullAsZero("ScoutID");
                        XmlElement scoutTag = AddElementTag(article, "SCOUT");
                        user.AddPrefixedUserXMLBlock(dataReader, scoutID, "Scout", scoutTag);
                    }

                    if (dataReader.DoesFieldExist("SubEditorID"))
                    {
                        // sub editor info
                        int subEditorID = dataReader.GetInt32NullAsZero("SubEditorID");
                        XmlElement subEditorTag = AddElementTag(article, "SUBEDITOR");
                        user.AddPrefixedUserXMLBlock(dataReader, subEditorID, "SubEditor", subEditorTag);
                    }

                    if (dataReader.DoesFieldExist("Status"))
                    {
                        AddIntElement(article, "STATUS", dataReader.GetInt32NullAsZero("Status"));
                    }
                    if (dataReader.DoesFieldExist("RecommendationStatus"))
                    {
                        AddIntElement(article, "RECOMMENDATION-STATUS", dataReader.GetInt32NullAsZero("RecommendationStatus"));
                    }
                    if (dataReader.DoesFieldExist("SubbingStatus"))
                    {
                        AddIntElement(article, "SUBBING-STATUS", dataReader.GetInt32NullAsZero("SubbingStatus"));
                    }
                    if (dataReader.DoesFieldExist("Style"))
                    {
                        AddIntElement(article, "STYLE", dataReader.GetInt32NullAsZero("Style"));
                    }

                    if (dataReader.DoesFieldExist("Subject"))
                    {
                        AddTextTag(article, "SUBJECT", dataReader.GetStringNullAsEmpty("Subject"));
                    }

                    if (dataReader.DoesFieldExist("DateCreated"))
                    {
                        AddDateXml(dataReader, article, "DateCreated", "DATE-CREATED");
                    }
                    if (dataReader.DoesFieldExist("LastUpdated"))
                    {
                        AddDateXml(dataReader, article, "LastUpdated", "LASTUPDATED");
                    }
                    if (dataReader.DoesFieldExist("DateRecommended"))
                    {
                        AddDateXml(dataReader, article, "DateRecommended", "DATE-RECOMMENDED");
                    }
                    if (dataReader.DoesFieldExist("DecisionDate"))
                    {
                        AddDateXml(dataReader, article, "DecisionDate", "RECOMMENDATION-DECISION-DATE");
                    }
                    if (dataReader.DoesFieldExist("DateAllocated"))
                    {
                        AddDateXml(dataReader, article, "DateAllocated", "DATE-ALLOCATED");
                    }
                    if (dataReader.DoesFieldExist("DateReturned"))
                    {
                        AddDateXml(dataReader, article, "DateReturned", "DATE-RETURNED");
                    }

                    //TODO add Extra Info correctly
                    if (dataReader.DoesFieldExist("ExtraInfo"))
                    {
                        //Add Extra Info XML where it exists.
                        string extraInfo = dataReader.GetAmpersandEscapedStringNullAsEmpty("ExtraInfo");
                        if (extraInfo != string.Empty)
                        {
                            XmlDocument extraInfoXml = new XmlDocument();
                            extraInfoXml.LoadXml(extraInfo);
                            article.AppendChild(ImportNode(extraInfoXml.FirstChild));
                        }

                        //TODO Use Extra Info Class will need to change SP to get out the guide entry Type
                        //ExtraInfo extraInfo = new ExtraInfo();
                        //extraInfo.TryCreate(dataReader.GetInt32NullAsZero("Type"), dataReader.GetStringNullAsEmpty("ExtraInfo"));
                        //AddInside(article, extraInfo);
                    }

                    if (dataReader.DoesFieldExist("ForumPostCount"))
                    {
                        AddIntElement(article, "FORUMPOSTCOUNT", dataReader.GetInt32NullAsZero("ForumPostCount"));
                        AddIntElement(article, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
                    }

                    if (dataReader.DoesFieldExist("StartDate") && !dataReader.IsDBNull("StartDate"))
                    {
                        AddDateXml(dataReader, article, "StartDate", "DATERANGESTART");
                    }
                    // Take a day from the end date as stored in the database for UI purposes. 
                    // E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
                    // This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
                    // original dates submitted by the user inorder to match their expectations.
                    if (dataReader.DoesFieldExist("EndDate") && !dataReader.IsDBNull("EndDate"))
                    {
                        AddDateXml(dataReader.GetDateTime("EndDate").AddDays(-1), article, "DATERANGEEND");
                    }

                    if (dataReader.DoesFieldExist("TimeInterval"))
                    {
                        AddIntElement(article, "TIMEINTERVAL", dataReader.GetInt32NullAsZero("TimeInterval"));
                    }

                    if (dataReader.DoesFieldExist("LASTPOSTED"))
                    {
                        AddDateXml(dataReader, article, "LASTPOSTED", "FORUMLASTPOSTED");
                    }
                    //////////


                    if (dataReader.DoesFieldExist("BookmarkCount"))
                    {
                        AddTextTag(article, "BOOKMARKCOUNT", dataReader.GetInt32NullAsZero("BookmarkCount"));
                    }

                    if (dataReader.DoesFieldExist("ZeitgeistScore"))
                    {
                        AddElement(article, "ZEITGEIST", "<SCORE>" + dataReader.GetDoubleNullAsZero("ZeitgeistScore") + "</SCORE>");
                    }

                    #region LocationXML
                    //***********************************************************************
                    // Location Info
                    //***********************************************************************
                    if (dataReader.DoesFieldExist("Latitude") && !dataReader.IsDBNull("Latitude"))
                    {
                        AddTextTag(article, "LATITUDE", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                        AddTextTag(article, "LONGITUDE", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                        if (dataReader.DoesFieldExist("Distance"))
                        {
                            if (dataReader.GetDoubleNullAsZero("Distance") < 0.0001)
                            {
                                AddTextTag(article, "DISTANCE", "0");
                            }
                            else
                            {
                                AddTextTag(article, "DISTANCE", dataReader.GetDoubleNullAsZero("Distance").ToString());
                            }
                        }
                        AddTextTag(article, "LOCATIONTITLE", dataReader.GetString("LocationTitle"));
                        AddTextTag(article, "LOCATIONDESCRIPTION", dataReader.GetString("LocationDescription"));
                        AddTextTag(article, "LOCATIONZOOMLEVEL", dataReader.GetInt32NullAsZero("LocationZoomLevel").ToString());
                        AddTextTag(article, "LOCATIONUSERID", dataReader.GetInt32NullAsZero("LocationUserID").ToString());
                        AddDateXml(dataReader.GetDateTime("LocationDateCreated"), article, "LOCATIONDATECREATED");
                    }
                    //***********************************************************************
                    #endregion

                    if (dataReader.DoesFieldExist("MediaAssetID"))
                    {
                        AddMediaAssetXml(dataReader, article, dataReader.GetInt32NullAsZero("MediaAssetID"));
                    }

                    if (dataReader.DoesFieldExist("CRPollID"))
                    {
                        AddPollXml(dataReader, article);
                    }



                    count--;

                } while (count > 0 && dataReader.Read());	// dataReader.Read won't get called if count == 0

                // See if there's an extra row waiting
                if (count == 0 && dataReader.Read())
                {
                    AddAttribute(articleList, "MORE", 1);
                }
            }
            return count;
        }


        /// <summary>
        /// Does the correct call to the database to get the most recent articles
        /// </summary>
        /// <param name="userID">The user id to look for</param>
        /// <param name="siteID">SiteID of the articles list to get</param>
        /// <param name="skip">The number of articles to skip</param>
        /// <param name="show">The number of articles to show</param>
        /// <param name="whichType">Type of Articles to show</param>
        /// <param name="guideType">Type of Guide Article to show</param>
        /// <returns>Dataset</returns>
        IDnaDataReader GetUsersMostRecentEntries(int userID, int siteID, int skip, int show, ArticleListType whichType, int guideType)
        {
            IDnaDataReader dataReader;
            string storedProcedure = String.Empty;

	        // Check to see which procedures to call
	        // This depends on the whichType and guideType parameters
	        if (guideType > 0)
	        {
		        // We've been given a GuideType to filter on, call the relavent procedure depending on the status type
		        if (whichType == ArticleListType.ARTICLELISTTYPE_APPROVED)
		        {
                    storedProcedure = "getuserrecentapprovedentrieswithguidetype";
		        }
		        else if (whichType == ArticleListType.ARTICLELISTTYPE_NORMAL)
		        {
			        storedProcedure = "getuserrecententrieswithguidetype";
		        }
                else if (whichType == ArticleListType.ARTICLELISTTYPE_NORMALANDAPPROVED)
		        {
			        storedProcedure = "getuserrecentandapprovedentrieswithguidetype";
		        }
		        else
		        {
			        storedProcedure = "getusercancelledentrieswithguidetype";
		        }

                dataReader = InputContext.CreateDnaDataReader(storedProcedure);
                
                // Now add the guide type as a parameter
		        dataReader.AddParameter("guidetype", guideType);
	        }
	        else
	        {
		        // Just call the relavent procedure depending on the status type
		        if (whichType == ArticleListType.ARTICLELISTTYPE_APPROVED)
		        {
			        storedProcedure = "getuserrecentapprovedentries";
		        }
		        else if (whichType == ArticleListType.ARTICLELISTTYPE_NORMAL)
		        {
			        storedProcedure = "getuserrecententries";
		        }
                else if (whichType == ArticleListType.ARTICLELISTTYPE_NORMALANDAPPROVED)
		        {
			        storedProcedure = "getuserrecentandapprovedentries";
		        }
		        else
		        {
			        storedProcedure = "getusercancelledentries";
		        }

                dataReader = InputContext.CreateDnaDataReader(storedProcedure);
            }


            dataReader.AddParameter("userid", userID);
            dataReader.AddParameter("siteid", siteID);
            dataReader.AddParameter("currentsiteid", InputContext.CurrentSite.SiteID);
            //dataReader.AddParameter("firstindex", skip);
            //dataReader.AddParameter("lastindex", skip + show - 1);

            dataReader.Execute();

            return dataReader;
        }
        /// <summary>
        /// Gets the expiry time of the article list for a user on a site was cached
        /// </summary>
        /// <param name="userID">The user who's article list to check</param>
        /// <param name="siteID">The site of the article list to check</param>
        /// <returns>Time of expiry</returns>
        private DateTime CacheGetArticleListDate(int userID, int siteID)
        {
            // Get the date from the database
            int seconds = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("cachegetarticlelistdate"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", siteID);
                reader.Execute();

                // If we found the info, set the number of seconds
                if (reader.HasRows && reader.Read())
                {
                    seconds = reader.GetInt32NullAsZero("seconds");
                }
            }
            return DateTime.Now.AddSeconds((double) seconds);
        }

        /// <summary>
        /// AddPollXml - Delegates esponsibility of producing standard Poll Xml to the Poll Class.
        /// Only produces Poll Xml where a valid Poll exists in the resultset.
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="article">Parent node to add the xml to</param>
        private void AddPollXml(IDnaDataReader dataReader, XmlNode article)
        {
            int pollId = dataReader.GetInt32NullAsZero("CRPollID");
            if (pollId > 0)
            {
                PollContentRating poll = new PollContentRating(this.InputContext, this.InputContext.ViewingUser);

                poll.PollID = dataReader.GetInt32NullAsZero("CRPollID");
                poll.Hidden = dataReader.GetInt32NullAsZero("Hidden") != 0;
                int voteCount = dataReader.GetInt32NullAsZero("CRVoteCount");
                double avgRating = dataReader.GetDoubleNullAsZero("CRAverageRating");
                poll.SetContentRatingStatistics(voteCount, avgRating);
                XmlNode node = poll.MakePollXML(false);
                if (node != null)
                {
                    article.AppendChild(ImportNode(node));
                }
            }
        }

        /// <summary>
        /// Adds the MediaAsset XML data to the XML document
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="parent">parent to add the xml to</param>
        /// <param name="mediaAssetID">Media asset id in question</param>
        private void AddMediaAssetXml(IDnaDataReader dataReader, XmlNode parent, int mediaAssetID)
        {
            MediaAsset asset = new MediaAsset(InputContext);

            XmlNode node = asset.MakeXml(dataReader);
            if (node != null)
            {
                parent.AppendChild(ImportNode(node));
            }
        }

        /// <summary>
        /// Creates a list of articles representing the articles currently in
		///		the accepted recommendations list that have not yet been allocated.
        /// </summary>
        /// <param name="maxNumber">the max number of entries to include in the list</param>
        /// <param name="skip">the number of entries to skip before starting inclusions</param>
        /// <returns>true if successfull, false if not</returns>
        public bool CreateUnallocatedRecommendationsList(int maxNumber, int skip)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchUnallocatedAcceptedRecommendations"))
            {
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("show", maxNumber);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                RootElement.RemoveAll();
                XmlElement articleList = AddElementTag(RootElement, "ARTICLE-LIST");
                AddAttribute(articleList, "TYPE", "UNALLOCATED-RECOMMENDATIONS");
                if (dataReader.HasRows && dataReader.Read())
                {
                    int articleCount = CreateList(articleList, dataReader, skip, maxNumber);
                }

            }
            return true;
            
        }

        /// <summary>
        /// Creates a list of articles representing the articles currently in
        ///		the accepted recommendations list that have not yet been allocated.
        /// </summary>
        /// <returns>true if successfull, false if not</returns>
        public bool CreateUnallocatedRecommendationsList()
        {
            return CreateUnallocatedRecommendationsList(10000, 0);
        }

        /// <summary>
        /// Gets the list of allocated scout recommendations that have not yet
		///		been returned, and inserts its XML representation into this form.
        /// </summary>
        /// <param name="maxNumber">the max number of entries to include in the list</param>
        /// <param name="skip">the number of entries to skip before starting inclusions</param>
        /// <returns>true for success or false for failure</returns>
        public bool CreateAllocatedRecommendationsList(int maxNumber, int skip)
        {
            RootElement.RemoveAll();
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchallocatedunreturnedrecommendations"))
            {
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("show", maxNumber);
                dataReader.AddParameter("skip", skip);
                dataReader.Execute();

                XmlElement articleList = AddElementTag(RootElement, "ARTICLE-LIST");
                AddAttribute(articleList, "TYPE", "ALLOCATED-RECOMMENDATIONS");
                AddAttribute(articleList, "SKIPTO", skip);
                AddAttribute(articleList, "COUNT", maxNumber);

                if (dataReader.HasRows && dataReader.Read())
                {
                    //don't send the skip parameter as we've already properly skipped them in the SP
                    int articleCount = CreateList(articleList, dataReader, 0, maxNumber);
                }

            }
            return true;

        }
        
    }
}