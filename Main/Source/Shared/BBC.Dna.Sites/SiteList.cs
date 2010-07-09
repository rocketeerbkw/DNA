using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Diagnostics;
using BBC.Dna.Data;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using System.Collections.Specialized;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Summary of the SiteList object, holds the list of 
    /// </summary>
    [Serializable]
    public class SiteList : SignalBase<SiteListCache>, ISiteList
    {
        private const string _signalKey = "recache-site";
        /// <summary>
        /// Class holds the list of Sites contains a private object which is locked when updating or retrieving data
        /// </summary>
        public SiteList(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            InitialiseObject = new InitialiseObjectDelegate(LoadSiteList);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetSiteStats);
            CheckVersionInCache();
            //register object with signal helper
            SignalHelper.AddObject(typeof(SiteList), this);
        }

        /// <summary>
        /// Public method to Load the Site List with data from all of the Sites.
        /// Also loads in site options for all sites too
        /// </summary>
        private SiteListCache LoadSiteList()
        {
            return LoadSiteList(0, null);
        }

        /// <summary>
        /// Public method to Load the Site List with data for or all particular sites
        /// </summary>
        /// <param name="context">The context</param>
        /// <param name="id">Can load just a specific site</param>
        private SiteListCache LoadSiteList(int siteId, SiteListCache siteList)
        {
            _dnaDiagnostics.WriteTimedEventToLog("SiteList.LoadSiteList", "Loading sitelist for " +
                (siteId == 0 ? "all sites" : "siteid=" + siteId.ToString()));
            if (siteList == null)
            {
                siteList = new SiteListCache();
            }
            try
            {
                string getSiteData = "fetchsitedata";
                using (IDnaDataReader dataReader = _readerCreator.CreateDnaDataReader(getSiteData))
                {
                    if (siteId > 0)
                    {
                        dataReader.AddParameter("@siteid", siteId);
                    }
                    dataReader.Execute();

                    if (dataReader.HasRows)
                    {
                        ProcessSiteData(siteId, dataReader, ref siteList);
                        GetKeyArticleList(siteId, ref siteList);
                        GetReviewForums(siteId, ref siteList);
                        GetSiteTopics(siteId, ref siteList);
                        GetSiteOpenCloseTimes(siteId, ref siteList);
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
                return siteList;
            }

            //always refresh all options
            siteList.SiteOptionList.CreateFromDatabase(_readerCreator, _dnaDiagnostics);
            _dnaDiagnostics.WriteTimedEventToLog("SiteList.LoadSiteList", "Completed loading sitelist for " +
                (siteId == 0 ? "all sites" : "siteid=" + siteId.ToString()));
            return siteList;
        }

        /// <summary>
        /// Hanldes the signal and refreshes cache
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        private bool HandleSignal(NameValueCollection args)
        {
            SiteListCache siteListCache = null;
            var siteId = 0;

            if (args != null && args.AllKeys.Contains("siteid"))
            {
                if (Int32.TryParse(args["siteid"], out siteId))
                {//get the existing cache to update only the new site value
                    siteListCache = GetCachedObject();
                }
            }

            _object = LoadSiteList(siteId, siteListCache);
            UpdateCache();

            return true;
        }

        /// <summary>
        /// Returns site list statistics
        /// </summary>
        /// <returns></returns>
        private NameValueCollection GetSiteStats()
        {
            var values = new NameValueCollection();

            GetCachedObject();
            values.Add("NumberOfSites", _object.Ids.Count.ToString());
            values.Add("NumberOfSiteOptions", _object.SiteOptionList.GetAllOptions().Count.ToString());
            return values;
        }

        /// <summary>
        /// Site ID accessor
        /// </summary>
        public Dictionary<int, Site> Ids
        {
            get { return GetCachedObject().Ids; }
        }

        /// <summary>
        /// Returns site list from cache or creates and adds to cache
        /// </summary>
        /// <param name="dnaDiagnostics">The diagnostic object - can be null</param>
        /// <param name="connection">The connection string</param>
        /// <param name="ignorecache">Forces a refresh of the cache</param>
        /// <returns>A filled sitelist object</returns>
        public static ISiteList GetSiteList()
        {
            SiteList siteList =  (SiteList)SignalHelper.GetObject(typeof(SiteList));
            siteList.GetCachedObject();
            return (ISiteList)siteList;
        }

        /// <summary>
        /// Return the Site with the given name
        /// </summary>
        /// <param name="name">Name of the site</param>
        /// <param name="context">The context</param>
        /// <returns>The Site oject with that name or null</returns>
        public ISite GetSite(string name)
        {

            ISite site = _object.Ids.Values.FirstOrDefault(x => x.SiteName == name);
            if (site == null)
            {
                _dnaDiagnostics.WriteWarningToLog("SiteList", "A Site doesn't exist with that site name. ");
                return null;
            }

            return site;
        }

        /// <summary>
        /// Return the Site with the given id
        /// </summary>
        /// <param name="id">Site ID</param>
        /// <param name="context">The context</param>
        /// <returns>The Site with that ID or null</returns>
        public ISite GetSite(int id)
        {
            bool siteInList = _object.Ids.ContainsKey(id);
            if (!siteInList)
            {
                _dnaDiagnostics.WriteWarningToLog("SiteList", "A Site doesn't exist with that site id. ");
                return null;
            }

            return _object.Ids[id];
        }

        /// <summary>
        /// Given the DataReader containing the site data build the site list dictionary
        /// </summary>
        /// <param name="dataReader">DataReader object contain the site list data</param>
        /// <param name="context">The context it's called in</param>
        private void ProcessSiteData(int siteId, IDnaDataReader dataReader, ref SiteListCache siteList)
        {
            // Information we need to get from the database:
            // List of sites and their rules
            int prevSiteID = 0;

            //For each row/site in the database add it's details
            while (dataReader.Read())
            {
                int id = dataReader.GetInt32("SiteID");
                string urlName = dataReader["URLName"].ToString();
                if (id != prevSiteID)
                {
                    int threadOrder = dataReader.GetInt32NullAsZero("ThreadOrder");
                    byte allowRemoveVote = dataReader.GetByteNullAsZero("AllowRemoveVote");
                    byte includeCrumbtrail = dataReader.GetByteNullAsZero("IncludeCrumbtrail");
                    int allowPostCodesInSearch = dataReader.GetInt32NullAsZero("AllowPostCodesInSearch");
                    bool siteEmergencyClosed = (dataReader.GetInt32NullAsZero("SiteEmergencyClosed") == 1);
                    int threadEditTimeLimit = dataReader.GetInt32NullAsZero("ThreadEditTimeLimit");
                    int eventAlertMessageUserID = dataReader.GetInt32NullAsZero("EventAlertMessageUserID");
                    string description = dataReader.GetStringNullAsEmpty("Description");
                    string defaultSkin = dataReader.GetStringNullAsEmpty("DefaultSkin");
                    string shortName = dataReader.GetStringNullAsEmpty("ShortName");
                    string ssoservice = dataReader.GetStringNullAsEmpty("SSOService");
                    string moderatorsEmail = dataReader.GetStringNullAsEmpty("ModeratorsEmail");
                    string editorsEmail = dataReader.GetStringNullAsEmpty("EditorsEmail");
                    string feedbackEmail = dataReader.GetStringNullAsEmpty("FeedbackEmail");
                    string emailAlertSubject = dataReader.GetStringNullAsEmpty("EventEMailSubject");
                    bool preModeration = (dataReader.GetByteNullAsZero("PreModeration") == 1);
                    bool noAutoSwitch = (dataReader.GetByteNullAsZero("NoAutoSwitch") == 1);
                    bool passworded = (dataReader.GetByteNullAsZero("Passworded") == 1);
                    bool unmoderated = (dataReader.GetByteNullAsZero("Unmoderated") == 1);
                    bool queuePostings = (dataReader.GetByteNullAsZero("QueuePostings") == 1);
                    bool articleGuestBookForums = false;
                    int modClassID = dataReader.GetInt32NullAsZero("ModClassID");
                    articleGuestBookForums = (dataReader.GetByteNullAsZero("ArticleForumStyle") == 1);

                    int autoMessageUserID = dataReader.GetInt32NullAsZero("AutoMessageUserID");
                    string skinSet = dataReader.GetStringNullAsEmpty("SkinSet");
                    string IdentityPolicy = dataReader.GetStringNullAsEmpty("IdentityPolicy");
                    string siteConfig = String.Empty;
                    
                    if (dataReader["config"] != null)
                    {
                        siteConfig = dataReader.GetString("config");
                    }

                    // Check to see which system we are meant to use to sign in with
                    bool useIdentitySignInSystem = false;

                    if (dataReader.Exists("UseIdentitySignIn"))
                    {
                        useIdentitySignInSystem = dataReader.GetTinyIntAsInt("UseIdentitySignIn") > 0;
                    }

                    bool isKidsSite = false;
                    if (dataReader.Exists("IsKidsSite"))
                    {
                        isKidsSite = dataReader.GetTinyIntAsInt("IsKidsSite") > 0;
                    }

                    // Read site-related information from the SSO database
                    // Default values to -1.  This means that if SSO is unavailable at this point, we will know about it.
                    // Once SSO is available again, we can recahce the site info.
                    int minAge = -1;
                    int maxAge = -1;
                    if (isKidsSite)
                    {
                        maxAge = 16;
                        minAge = 0;
                    }
                    else
                    {
                        maxAge = 255;
                        minAge = 0;
                    }

                    Site siteData = new Site(id, urlName, threadOrder, preModeration, defaultSkin,
                                    noAutoSwitch, description, shortName,
                                    moderatorsEmail, editorsEmail,
                                    feedbackEmail, autoMessageUserID, passworded,
                                    unmoderated, articleGuestBookForums,
                                    siteConfig, emailAlertSubject, threadEditTimeLimit,
                                    eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail,
                                    allowPostCodesInSearch, queuePostings, siteEmergencyClosed,
                                    minAge, maxAge, modClassID, ssoservice, useIdentitySignInSystem,
                                    skinSet, IdentityPolicy);


                    string skinName = dataReader.GetStringNullAsEmpty("SkinName");
                    string skinDescription = dataReader.GetStringNullAsEmpty("SkinDescription");
                    bool useFrames = (dataReader.GetInt32NullAsZero("UseFrames") == 1);
                    siteData.AddSkin(skinName, skinDescription, useFrames);

                    if(siteList.Ids.ContainsKey(id))
                    {
                        siteList.Ids[id] = siteData;
                    }
                    else
                    {
                        siteList.Ids.Add(id,siteData);
                    }
                    
                    prevSiteID = id;
                    
                }
            }
			
        }

        /// <summary>
        /// This method gets the topics for the given site
        /// </summary>
        /// <param name="context">The context in which it's being called</param>
        private void GetSiteTopics(int siteId, ref SiteListCache siteList)
        {
            //remove old values
            if (siteId > 0)
            {
                siteList.Ids[siteId].ClearAllTopics();
            }
            else
            {
                foreach (var id in siteList.Ids.Keys)
                {
                    siteList.Ids[id].ClearAllTopics();
                }
            }
            // Get the topics for the given site
            using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("GetTopicDetails"))
            {
                reader.AddParameter("TopicStatus", 0);
                reader.AddParameter("SiteID", siteId);
                reader.Execute();

                // Check to see if we got anything
                if (reader.HasRows)
                {
                    // Add each topic to the current site
                    while (reader.Read())
                    {
						int id = reader.GetInt32NullAsZero("SiteID");
                        int topicID = reader.GetInt32("TopicID");
                        string title = reader.GetString("Title");
                        int h2g2ID = reader.GetInt32("h2g2ID");
                        int forumID = reader.GetInt32("ForumID");

                        try
                        {
                            siteList.Ids[id].AddTopic(topicID, title, h2g2ID, forumID, 0);
                        }
                        catch(Exception err)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(err);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Method that gets the Review forums for a particular site from the database 
        /// Goes through each of those rows and adds the Review Forums info into a dictionary in the
        /// Site object
        /// </summary>
        /// <param name="context">The context it's called in</param>
        private void GetReviewForums(int siteId, ref SiteListCache siteList)
        {
            //remove old values
            if (siteId > 0)
            {
                siteList.Ids[siteId].ClearAllReviewForums();
            }
            else
            {
                foreach (var id in siteList.Ids.Keys)
                {
                    siteList.Ids[id].ClearAllReviewForums();
                }
            }
            using (IDnaDataReader dataReader = _readerCreator.CreateDnaDataReader("getreviewforums"))
            {
                dataReader.AddParameter("@siteID", siteId);	// site zero means get all sites
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
						int id = dataReader.GetInt32NullAsZero("SiteID");
						string urlFriendlyName = dataReader.GetStringNullAsEmpty("URLFriendlyName").ToString();
                        int forumid = dataReader.GetInt32NullAsZero("ReviewForumID");
                        try
                        {
                            siteList.Ids[id].AddReviewForum(urlFriendlyName, forumid);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                }
            }
        }
        
        /// <summary>
        /// Gets the list of Key articles for this site from the database
        /// </summary>
        /// <param name="context">The context it's called in</param>
        private void GetKeyArticleList(int siteId, ref SiteListCache siteList)
        {

            if (siteId > 0)
            {
                siteList.Ids[siteId].ClearArticles();
            }
            else
            {
                foreach (var id in siteList.Ids.Keys)
                {
                    siteList.Ids[id].ClearArticles();
                }
            }
            using (IDnaDataReader dataReader = _readerCreator.CreateDnaDataReader("getkeyarticlelist"))
            {
                dataReader.AddParameter("@siteID", siteId);	// zero means get all sites data
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
						int id = dataReader.GetInt32NullAsZero("SiteID");
                        string articleName = dataReader.GetStringNullAsEmpty("ArticleName");
                        try
                        {
                            siteList.Ids[id].AddArticle(articleName);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Gets the Open and Close times from the databse for the site
        /// </summary>
        /// <param name="context">The context it's called in</param>
        private void GetSiteOpenCloseTimes(int siteId, ref SiteListCache siteList)
        {
            //remove old values
            if (siteId > 0)
            {
                siteList.Ids[siteId].ClearOpenCloseTimes();
            }
            else
            {
                foreach (var id in siteList.Ids.Keys)
                {
                    siteList.Ids[id].ClearOpenCloseTimes();
                }
            }

            using (IDnaDataReader dataReader = _readerCreator.CreateDnaDataReader("getsitetopicsopenclosetimes"))
            {
                dataReader.AddParameter("@siteID", siteId);
				dataReader.Execute();
                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
                        var dayofWeek = dataReader.GetByte("DayWeek");	// subtract one because C++ date code starts from Sunday = 1
						//dayofWeek -= 1;									// while .NET starts from Sunday = 0
                        var hour = dataReader.GetByte("Hour");
                        var minute = dataReader.GetByte("Minute");
                        var closed = dataReader.GetInt32("Closed");
						var id = dataReader.GetInt32NullAsZero("SiteID");
                        try
                        {
                            siteList.Ids[id].AddOpenCloseTime(dayofWeek, hour, minute, closed);
                        }
                        catch (Exception e)
                        {
                            _dnaDiagnostics.WriteExceptionToLog(e);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Gets the given int site option for the current site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public int GetSiteOptionValueInt(int siteId, string section, string name)
        {
            return _object.SiteOptionList.GetValueInt(siteId, section, name);
        }

        /// <summary>
        /// Gets the given bool site option for the current site
        /// <see cref="SiteOptionList.GetValueBool"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public bool GetSiteOptionValueBool(int siteId, string section, string name)
        {
            return _object.SiteOptionList.GetValueBool(siteId, section, name);
        }

        /// <summary>
        /// Gets the given String site option for the current site
        /// <see cref="SiteOptionList.GetValueString"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        public string GetSiteOptionValueString(int siteId, string section, string name)
        {
            return _object.SiteOptionList.GetValueString(siteId, section, name);
        }

        /// <summary>
        /// Returns site options for a given site
        /// </summary>
        /// <param name="siteId">The id of the site to retrieve</param>
        /// <returns></returns>
        public List<SiteOption> GetSiteOptionListForSite(int siteId)
        {
            return _object.SiteOptionList.GetSiteOptionListForSite(siteId);
        }

        /// <summary>
        /// Method to say whether this site is a message board
        /// </summary>
        public bool IsMessageboard(int siteID)
        {
            return _object.SiteOptionList.GetValueBool(siteID, "General", "IsMessageboard");
        }

        /// <summary>
        /// Sends the signal
        /// 
        /// </summary>
        public void SendSignal()
        {
            SendSignal(0);
        }

        /// <summary>
        /// Send signal with siteid
        /// </summary>
        /// <param name="siteId"></param>
        public void SendSignal(int siteId)
        {
            NameValueCollection args = new NameValueCollection();
            if (siteId != 0)
            {
                args.Add("siteid", siteId.ToString());
            }
            SendSignals(args);
        }

        

   }
}
