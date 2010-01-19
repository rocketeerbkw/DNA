using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Component;
using System.Web.Caching;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// 
    /// </summary>
    public class CommentForumListBuilder : DnaInputComponent
    {

        private const string _docDnaShow = @"The number of comment forums to show.";
        private const string _docDnaSkip = "The number of comment forums to skip";
        private const string _docDnaListNs = @"The prefix for a UID. Used to group related comment forums";
        private const string _docDnaListCount = @"The maxium number of comment forum details rows to return";
        private bool _skipUidProcessing = false;
        private bool _skipUrlProcessing = false;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="inputContext"></param>
        public CommentForumListBuilder(IInputContext inputContext)
            : base(inputContext)
        { 
        }

        /// <summary>
        /// 
        /// </summary>
        public bool SkipUidProcessing
        {
            set 
            { 
                _skipUidProcessing = value; 
            }
        }

        /// <summary>
        /// Property to indicate whether the dnahostpageurl parameter is used.
        /// </summary>
        public bool SkipUrlProcessing
        {
            set
            {
                _skipUrlProcessing = value;
            }
        }

        /// <summary>
        /// Method called to try and get the comment forum list. 
        /// </summary>
        public void TryGetCommentForumList()
        {
            int siteID = 0;
            string hostpageurl = String.Empty;
            int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
            int skip = 0;
            int dnaUidCount = 0;
            string[] dnaUids;
            string dnaListNs = String.Empty;
            int dnaListCount = 0;

            GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);
            if (hostpageurl == String.Empty || _skipUrlProcessing == true)
            {
                if (dnaUidCount != 0 && _skipUidProcessing != true)
                {
                    GeneratePageXmlByDnaUids(dnaUids);
                }
                else if (dnaListNs.CompareTo("") != 0)
                {
                    GeneratePageXmlByPrefix(dnaListNs, dnaListCount, siteID);
                }
                else if (siteID == 0)
                {
                    GeneratePageXmlAll(skip, show);
                }
                else
                {
                    GeneratePageXmlBySite(siteID, skip, show);
                }
            }
			else if (hostpageurl.Length > 0)
			{
				GeneratePageXmlByUrl(hostpageurl, skip, show);
			}

        }

		/// <summary>
		/// This can be called on a page which needs lists of comments, like the BlogSummary pages
		/// It removes the logic for this type of data from the commentforumlist page which doesn't require
		/// those lists
		/// </summary>
		public void GetCommentListsFromUids()
		{
			int siteID = 0;
			string hostpageurl = String.Empty;
			int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
			int skip = 0;
			int dnaUidCount = 0;
			string[] dnaUids;
			string dnaListNs = String.Empty;
			int dnaListCount = 0;

			GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);
			if (dnaUidCount != 0)
			{
				GeneratePageXmlByDnaUids(dnaUids);
			}


			//if (hostpageurl.Length > 0)
			//{
			//    GeneratePageXmlByUrl(hostpageurl, skip, show);
			//}
		}

		/// <summary>
		/// If the dna_list_ns parameter exists, this will generate a list of recent posts
		/// and a list of recent threads commented on
		/// </summary>
		public void GetCommentListsFromUidPrefix()
		{
			int siteID = 0;
			string hostpageurl = String.Empty;
			int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
			int skip = 0;
			int dnaUidCount = 0;
			string[] dnaUids;
			string dnaListNs = String.Empty;
			int dnaListCount = 0;

			GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);

			if (dnaListNs.Length > 0)
			{
				GeneratePageXmlByPrefix(dnaListNs, dnaListCount, siteID);
			}
		}

        /// <summary>
        /// Gets a comment forum list from a supplied uid prefix.
        /// </summary>
        /// <param name="dnaListNs">The prefix of the uid.</param>
        /// <param name="dnaListCount">The number of comment forums to retrieve.</param>
        /// <param name="siteID">Allow filtering on given site.</param>
        private void GeneratePageXmlByPrefix(string dnaListNs, int dnaListCount, int siteID)
        {
            string cacheKey = dnaListNs + Convert.ToString(siteID) + "Checker";

            object cacheChecker = InputContext.GetCachedObject(cacheKey);
            if (cacheChecker != null)
            {
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Using cache - " + cacheKey);

                //use cached object
                object cacheData = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedData");
                if (cacheData != null)
                {
                    RootElement.AppendChild(ImportNode((XmlNode)cacheData));
                }
            }
            else
            {
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Not using cache - " + cacheKey);
                DateTime lastUpdated = DateTime.Now;
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcommentforumcachedependencycheck"))
                {
                    dataReader.AddParameter("@prefix", dnaListNs + '%');
                    dataReader.AddParameter("@siteid", siteID);
                    dataReader.Execute();
                    if (dataReader.HasRows)
                    {
                        dataReader.Read();
                        lastUpdated = dataReader.GetDateTime("LastUpdated");
                    }
                }
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Last updated - " + lastUpdated.ToString());

                object cachedDateObj = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedDate");
                DateTime cachedDate = DateTime.MinValue;
                if (cachedDateObj != null)
                {
                    cachedDate = (DateTime)cachedDateObj;
                }

                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "CachedDate - " + cachedDate.ToString());

                if (cachedDate < lastUpdated)
                {
                    InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Cached Date is less than last Updated - " + cacheKey);

                    InputContext.CacheObject(dnaListNs + Convert.ToString(siteID) + "CachedDate", lastUpdated, 10000000);
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcommentforumlistbyuidprefix"))
                    {
                        dataReader.AddParameter("@prefix", dnaListNs + '%')
                            .AddParameter("@count", dnaListCount)
                            .AddParameter("@siteid", siteID);
                        dataReader.Execute();

                        GenerateCommentForumListXml(dataReader, 0, dnaListCount, 0, String.Empty);
                        InputContext.CacheObject(cacheKey, "checkString", 10);
                        InputContext.CacheObject(dnaListNs + Convert.ToString(siteID) + "CachedData", RootElement.FirstChild, 1000000);
                    }
                }
                else
                {
                    InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Cached Date not less than last Updated - " + cacheKey);
                    
                    //use cached object
                    InputContext.CacheObject(cacheKey, "checkString", 10);
                    object cacheData = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedData");
                    if (cacheData != null)
                    {
                        RootElement.AppendChild(ImportNode((XmlNode)cacheData));
                    }
                }
            }
        }
        
        /// <summary>
        /// Gets the complete comment forum list with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlAll(int skip, int show)
        {
            string getCommentForumList = "getcommentforumlist";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();

                GenerateCommentForumListXml(dataReader, skip, show, 0, String.Empty);
            }
        }

        /// <summary>
        /// Gets the comment forum list by site id with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="siteID">site id of comment lists to return for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlBySite(int siteID, int skip, int show)
        {
            string getCommentForumList = "getcommentforumlistbysite";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@siteid", siteID)
                    .AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();

                GenerateCommentForumListXml(dataReader, skip, show, siteID, String.Empty);
            }
        }

        /// <summary>
        /// Gets the comment forum list by hostpageurl with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="hostpageurl">hostpage url to match comment lists for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlByUrl(string hostpageurl, int skip, int show)
        {
            string getCommentForumList = "getcommentforumlistbyurl";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@url", hostpageurl)
                    .AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();

                GenerateCommentForumListXml(dataReader, skip, show, 0, hostpageurl);
            }
        }

        /// <summary>
        /// Get the comment from list from a collection of dnauids
        /// </summary>
        /// <param name="dnaUids">String Array containing the dnauids to return data for.</param>
        private void GeneratePageXmlByDnaUids(string[] dnaUids)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcommentforumlistbydnauids"))
            {
                string sb = "";
                foreach (string s in dnaUids)
                {
                    sb += "<dnauid>" + StringUtils.EscapeAllXmlForAttribute(s) + "</dnauid>";
                }

                reader.AddParameter("@dnauids", sb.ToString());

                reader.Execute();

                GenerateCommentForumListXml(reader, 0, 200, 0, String.Empty);
            }
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="siteID">site id of comment lists to return for otherwise current site.</param>
        /// <param name="hostpageurl">hostpage url to match comment lists for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        /// <param name="dnaUidCount">Number of dnauids specified to retrieve comment forum data for.</param>
        /// <param name="dnaUids">Array of dnauid values.</param>
        /// <param name="dnaListNs">Namespace prefix for the dna uid</param>
        /// <param name="dnaListCount">Count comment forum details to return related by the dna uid namespace</param>
        private void GetPageParams(ref int siteID, ref string hostpageurl, ref int skip, ref int show, ref int dnaUidCount, out string[] dnaUids, ref string dnaListNs, ref int dnaListCount)
        {
            //Default to current site unless stated.
            siteID = InputContext.CurrentSite.SiteID;
            if (InputContext.DoesParamExist("dnasiteid", "SiteID Filter"))
            {
                siteID = InputContext.GetParamIntOrZero("dnasiteid", @"Site ID filter of the all the Comment Forums to return");
            }

            hostpageurl = InputContext.GetParamStringOrEmpty("dnahostpageurl", @"Hostpageurl filter of all the Comment Forums to return");
            int defaultShow = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");

            dnaUidCount = InputContext.GetParamCountOrZero("u", "0, 1 or more dnauids");
                        
            dnaListNs = InputContext.GetParamStringOrEmpty("dnacommentforumlistprefix", _docDnaListNs);
            dnaListCount = InputContext.GetParamIntOrZero("dnalistcount", _docDnaListCount);
            if (dnaListNs != String.Empty && dnaListCount == 0)
            {
                dnaListCount = 10;
            }

            if (dnaUidCount > 0)
            {
                dnaUids = new string[dnaUidCount];
                for (int i = 0; i < dnaUidCount; i++)
                {
                    dnaUids[i] = InputContext.GetParamStringOrEmpty("u", i, "dnauid");
                }
            }
            else
            {
                dnaUids = new string[] { "" };
            }

            skip = InputContext.GetParamIntOrZero("dnaskip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("dnashow", _docDnaShow);
            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = defaultShow;
            }
        }

        /// <summary>
        /// Creates the XML fragment for the Comment CommentBoxForum List
        /// </summary>
        /// <param name="dataReader">The SP reader</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        /// <param name="requestedSiteIDFilter">The requested Site Id filter if present</param>
        /// <param name="requestedUrlFilter">The requested HostPageUrl filter if present</param>
        public void GenerateCommentForumListXml(IDnaDataReader dataReader, int skip, int show, int requestedSiteIDFilter, string requestedUrlFilter)
        {
            XmlNode commentForumList = CreateElementNode("COMMENTFORUMLIST");
            int commentForumListCount = 0;

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    commentForumListCount = dataReader.GetInt32NullAsZero("CommentForumListCount");
                }
            }

            AddAttribute(commentForumList, "COMMENTFORUMLISTCOUNT", commentForumListCount);
            AddAttribute(commentForumList, "SKIP", skip);
            AddAttribute(commentForumList, "SHOW", show);

            if (requestedUrlFilter == String.Empty)
            {
                AddAttribute(commentForumList, "REQUESTEDSITEID", requestedSiteIDFilter);
            }
            else
            {
                AddAttribute(commentForumList, "REQUESTEDURL", StringUtils.EscapeAllXmlForAttribute(requestedUrlFilter));
            }

            //int returnedCount = 20;
            int actualForumListCount = 0;
            if (commentForumListCount > 0)
            {
                do
                {
                    AddCommentForumListXML(dataReader, commentForumList);
                    actualForumListCount++;
					// returnedCount--;
                } while (/*returnedCount > 0 &&*/ dataReader.Read());
            }

            //TODO: Move this to the right place
            RootElement.AppendChild(commentForumList);
        }

        /// <summary>
        /// Generates the individual Comment CommentBoxForum Xml within the Comment CommentBoxForum List xml page
        /// </summary>
        /// <param name="dataReader">SP containing the comment forums</param>
        /// <param name="commentForumList">Parent node to attach to</param>
        private void AddCommentForumListXML(IDnaDataReader dataReader, XmlNode commentForumList)
        {
            // start creating the comment forum structure
            XmlNode commentForum = CreateElementNode("COMMENTFORUM");
            AddAttribute(commentForum, "UID", dataReader.GetStringNullAsEmpty("uid"));
            AddAttribute(commentForum, "FORUMID", dataReader.GetInt32NullAsZero("forumID").ToString());
            AddAttribute(commentForum, "FORUMPOSTCOUNT", dataReader.GetInt32NullAsZero("forumpostcount").ToString());
            AddAttribute(commentForum, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
            AddAttribute(commentForum, "CANWRITE", dataReader.GetByteNullAsZero("CanWrite").ToString());

            AddTextTag(commentForum, "HOSTPAGEURL", dataReader.GetStringNullAsEmpty("url"));
            AddTextTag(commentForum, "TITLE", dataReader.GetStringNullAsEmpty("title"));
            AddTextTag(commentForum, "MODSTATUS", dataReader.GetByteNullAsZero("ModerationStatus"));
            AddTextTag(commentForum, "SITEID", dataReader.GetInt32NullAsZero("siteid"));

            if (dataReader.DoesFieldExist("DateCreated") && !dataReader.IsDBNull("DateCreated"))
            {
                DateTime dateCreated = dataReader.GetDateTime("DateCreated");
                AddElement(commentForum, "DATECREATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateCreated));
            }

            if (dataReader.DoesFieldExist("ForumCloseDate") && !dataReader.IsDBNull("ForumCloseDate"))
            {
                DateTime closeDate = dataReader.GetDateTime("ForumCloseDate");
                AddElement(commentForum, "CLOSEDATE", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, closeDate));
            }

            if (dataReader.DoesFieldExist("LastUpdated") && !dataReader.IsDBNull("LastUpdated"))
            {
                DateTime dateLastUpdated = dataReader.GetDateTime("LastUpdated");
                AddElement(commentForum, "LASTUPDATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateLastUpdated));
            }

            commentForumList.AppendChild(commentForum);
        }

    }
}
