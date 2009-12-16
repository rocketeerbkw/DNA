using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ThreadEntrySearch object, gets a list of posts for the given search
    /// </summary>
    public class ThreadEntrySearch : DnaInputComponent
    {
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaSearchParam = @"Thing to search the posts for.";

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the ThreadEntrySearch component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ThreadEntrySearch(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            TryCreateThreadEntrySearchXml();

        }
        /// <summary>
        /// Method called to try to create the TryCreateThreadEntrySearch xml, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has suceeded with out error</returns>
        private bool TryCreateThreadEntrySearchXml()
        {
            string search = String.Empty;
            int skip = 0;
            int show = 0;

            TryGetPageParams(ref search, ref skip, ref show);

            TryGetThreadSearchXml(search, skip, show);

            return true;
        }

        /// <summary>
        /// Public method to try and get the xml either from cache or DB
        /// </summary>
        /// <param name="search">Search term</param>
        /// <param name="skip">skip</param>
        /// <param name="show">show</param>
        public void TryGetThreadSearchXml(string search, int skip, int show)
        {
            bool cached = GetThreadSearchCachedXml(search, skip, show);

            if (!cached)
            {
                GetThreadSearchXml(search, skip, show);
            }
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// 
        private void TryGetPageParams(ref string search, ref int skip, ref int show)
        {
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);
            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 1)
            {
                skip = 0;
            }

            search = InputContext.GetParamStringOrEmpty("search", _docDnaSearchParam);
        }

        /// <summary>
        /// Calls the post list class to generate the posts matching the search
        /// </summary>
        private void GetThreadSearchXml(string search, int skip, int show)
        {
            // Put in the wrapping <POSTS> tag which has the user ID in it
            XmlElement threadSearch = AddElementTag(RootElement, "THREADENTRY-SEARCH");
            AddTextTag(threadSearch, "SEARCH", search);
            AddIntElement(threadSearch, "SITEID", InputContext.CurrentSite.SiteID);

            XmlElement postlist = AddElementTag(threadSearch, "POST-LIST");
            AddAttribute(postlist, "SKIP", skip);
            AddAttribute(postlist, "SHOW", show);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("searchthreadentriesfast"))
            {
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("condition", search);

                dataReader.Execute();

                int results = 0;
                int more = 0;

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    //Need to skip to start of results. TODO replace with paged results
                    for (int i = 0; i < skip; ++i)
                    {
                        dataReader.Read();
                    }
                    do
                    {
                        XmlElement post = AddElementTag(postlist, "POST");

                        AddIntElement(post, "POSTID", dataReader.GetInt32NullAsZero("entryid"));
                        AddIntElement(post, "THREADID", dataReader.GetInt32NullAsZero("threadID"));
                        AddIntElement(post, "FORUMID", dataReader.GetInt32NullAsZero("forumid"));
                        AddTextTag(post, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));
                        AddTextTag(post, "TEXT", dataReader.GetStringNullAsEmpty("text"));
                        AddDateXml(dataReader.GetDateTime("dateposted"), post, "DATEPOSTED");
                        AddDateXml(dataReader.GetDateTime("lastupdated"), post, "LASTUPDATED");

                        AddIntElement(post, "POSTSTYLE", dataReader.GetTinyIntAsInt("PostStyle"));
                        int score = Convert.ToInt32(dataReader.GetDoubleNullAsZero("score") * 100.0);
                        AddIntElement(post, "SCORE", score);

                        ++results;
                    } while (dataReader.Read() && results < show);
                    if (dataReader.Read())
                    {
                        more = 1;
                    }
                }

                AddAttribute(postlist, "MORE", more);
                AddAttribute(postlist, "COUNT", results);
            }

            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "threadentrysearch", _cacheName, threadSearch.OuterXml);

            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GenerateAllSitesXml(InputContext.TheSiteList).FirstChild));
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <param name="search"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetThreadSearchCachedXml(string search, int skip, int show)
        {
            bool gotFromCache = false;

            _cacheName = "threadentrysearch-";
            _cacheName += StringUtils.MakeStringFileNameSafe(search) + "-";
            _cacheName += InputContext.CurrentSite.SiteID.ToString() + "-"; 
            _cacheName += skip + "-";
            _cacheName += show;
            _cacheName += ".xml"; ;

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(5);  // expire after 5 minutes
            string threadEntrySearchXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "threadentrysearch", _cacheName, ref expiry, ref threadEntrySearchXML))
            {
                RipleyAddInside(RootElement, threadEntrySearchXML);
                gotFromCache = true;
            }

            return gotFromCache;
        }
    }
}
