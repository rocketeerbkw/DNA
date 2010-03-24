using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Creates recent Search XML
    /// </summary>
    public class RecentSearch : DnaInputComponent
    {
        /// <summary>
        /// List of valid search types
        /// </summary>
        public enum SEARCHTYPE{ 
            /// <summary>
            /// Search type article
            /// </summary>
            ARTICLE =0,
            /// <summary>
            /// Search type FORUM - 1
            /// </summary>
            FORUM=1,
            /// <summary>
            /// Search type USER - 2
            /// </summary>
            USER=2,
            /// <summary>
            /// Search type HIERARCHY - 3
            /// </summary>
            HIERARCHY=3,
            /// <summary>
            /// Search type KEYPHRASE 
            /// </summary>
            KEYPHRASE=4 };

        private string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor of RecentSearch
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public RecentSearch(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            if (GetRecentSearchFromCache())
            {
                return;//got cache so no more work here
            }

            //prepare XML Doc
            RootElement.RemoveAll();
            XmlElement recentSearch = AddElementTag(RootElement, "RECENTSEARCHES");

            //get data from DB
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("GetRecentSearches"))
            {
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                //get searches and add to xml
                while (dataReader.Read())
                {
                    XmlNode searchterm = CreateElementNode("SEARCHTERM");
                    AddTextTag(searchterm, "NAME", dataReader.GetStringNullAsEmpty("TERM"));

                    switch (dataReader.GetTinyIntAsInt("TYPE"))
                    {
                        case (int)SEARCHTYPE.ARTICLE:
                            AddTextTag(searchterm, "TYPE", "ARTICLE");
                            break;

                        case (int)SEARCHTYPE.FORUM:
                            AddTextTag(searchterm, "TYPE", "FORUM");
                            break;

                        case (int)SEARCHTYPE.HIERARCHY:
                            AddTextTag(searchterm, "TYPE", "HIERARCHY");
                            break;

                        case (int)SEARCHTYPE.KEYPHRASE:
                            AddTextTag(searchterm, "TYPE", "KEYPHRASE");
                            break;

                        case (int)SEARCHTYPE.USER:
                            AddTextTag(searchterm, "TYPE", "USER");
                            break;

                        default:
                            InputContext.Diagnostics.WriteToLog("Recent Search", "Unknown TYPE provided");
                            return;
                    }

                    AddTextTag(searchterm, "TIMESTAMP", dataReader.GetDateTime("STAMP").ToString());
                    AddTextTag(searchterm, "COUNT", dataReader.GetInt32NullAsZero("COUNT"));

                    //add to root xml
                    recentSearch.AppendChild(searchterm);

                    dataReader.NextResult();
                };
            }

            //add to cache
            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "recentsearch", _cacheName, recentSearch.OuterXml);            
        }

        /// <summary>
        /// Checks and returns RecentSearch XML from cache
        /// </summary>
        /// <returns>Whether cache available and used</returns>
        private bool GetRecentSearchFromCache()
        {
            bool gotFromCache = false;
            _cacheName = String.Format("recentsearch-{0}.xml", InputContext.CurrentSite.SiteID);

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(5);  // expire after x minutes set in the siteoptions
            string recentSearchXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "recentsearch", _cacheName, ref expiry, ref recentSearchXML))
            {
                RipleyAddInside(RootElement, recentSearchXML);
                gotFromCache = true;
            }

            return gotFromCache;

 
        }

        /// <summary>
        /// Adds a new search term to the database
        /// </summary>
        /// <param name="search">Search term</param>
        /// <param name="type">Type of search</param>
        /// <returns>true on success</returns>
        public bool AddSearchTerm(string search, SEARCHTYPE type)
        {
            bool bSuccess = false;
             
            if (EmailAddressFilter.CheckForEmailAddresses(search))
            {//check if search contains an email - if so don't add
                return bSuccess;
            }

            //check profanity filter
            
            string matchingProfanity;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, search, out matchingProfanity);
            

            if (ProfanityFilter.FilterState.Pass == state)
            {
                IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updateRecentSearch");
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("type", type);
                dataReader.AddParameter("searchterm", search);
                dataReader.Execute();
                bSuccess = true;
            }

            return bSuccess;
        }
    }
}
