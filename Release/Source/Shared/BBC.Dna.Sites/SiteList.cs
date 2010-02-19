using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Diagnostics;
using BBC.Dna.Data;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Summary of the SiteList object, holds the list of 
    /// </summary>
    public class SiteList : Context, ISiteList
    {
        private Dictionary<string, Site> _names = new Dictionary<string, Site>();
        private Dictionary<int, Site> _ids = new Dictionary<int, Site>();
        private SiteOptionList _siteOptionList = null;

        /// <summary>
        /// Site name accessor
        /// </summary>
        public Dictionary<string, Site> Names
        {
            get { return _names; }
        }

        /// <summary>
        /// Site ID accessor
        /// </summary>
        public Dictionary<int, Site> Ids
        {
            get { return _ids; }
        }

        /// <summary>
        /// Class holds the list of Sites contains a private object which is locked when updating or retrieving data
        /// </summary>
        public SiteList(IDnaDataReaderCreator ReaderCreator, IDnaDiagnostics DnaDiag)
            : base(ReaderCreator, DnaDiag)
        {
        }

        private static ISiteList _siteList = null;

        private const string _cacheKey = "DNASITELIST";

        /// <summary>
        /// Returns site list from cache or creates and adds to cache
        /// </summary>
        /// <param name="dnaDiagnostics">The diagnostic object - can be null</param>
        /// <param name="connection">The connection string</param>
        /// <returns>A filled sitelist object</returns>
        public static ISiteList GetSiteList(IDnaDataReaderCreator ReaderCreator, IDnaDiagnostics DnaDiag)
        {
            return GetSiteList(ReaderCreator,DnaDiag, false);

        }
        /// <summary>
        /// Returns site list from cache or creates and adds to cache
        /// </summary>
        /// <param name="dnaDiagnostics">The diagnostic object - can be null</param>
        /// <param name="connection">The connection string</param>
        /// <param name="ignorecache">Forces a refresh of the cache</param>
        /// <returns>A filled sitelist object</returns>
        public static ISiteList GetSiteList(IDnaDataReaderCreator ReaderCreator, IDnaDiagnostics DnaDiag, bool ignorecache)
        {
            if (!ignorecache)
            {
                try
                {
                    if (DnaStaticCache.Exists(_cacheKey))
                    {
                        _siteList = (ISiteList)DnaStaticCache.Get(_cacheKey);
                    }
                }
                catch {}

                if (_siteList != null)
                {
                    return _siteList;
                }
            }

            SiteList siteList = new SiteList(ReaderCreator, DnaDiag);
            siteList.LoadSiteList();
            _siteList = siteList;
            try
            {
                DnaStaticCache.Add(_cacheKey, _siteList);
            }
            catch { }

            return _siteList;
            
        }

        /// <summary>
        /// Method to create a new Site object with the given details and add it into the SiteList
        /// </summary>
        /// <param name="id">SiteID</param>
        /// <param name="name">Site Name</param>
        /// <param name="threadOrder">Default thread order of the Site eith Last Posted or DateCreated</param>
        /// <param name="preModeration">if the site is premoderation or not</param>
        /// <param name="defaultSkin">Default skin for the site</param>
        /// <param name="noAutoSwitch">Whether the site allows switching to other sites for articles etc</param>
        /// <param name="description">Description for the Site</param>
        /// <param name="shortName">Short name</param>
        /// <param name="moderatorsEmail">Moderators email for the site where the moderation emails will report they are from</param>
        /// <param name="editorsEmail">Editors email for the site where the editors emails will report they are from</param>
        /// <param name="feedbackEmail">The email given to be displayed on the site for users feedback</param>
        /// <param name="autoMessageUserID">ID of the user that the emails originate from</param>
        /// <param name="passworded">Is the Site a passworded Site</param>
        /// <param name="unmoderated">Is the Site unmoderated</param>
        /// <param name="articleGuestBookForums">Default article forum style if the article forums are displayed in guestbook style</param>
        /// <param name="config">Config XML block for this site</param>
        /// <param name="emailAlertSubject">Default email subject for an alert from the site</param>
        /// <param name="threadEditTimeLimit">Time delay for editing threads for the site</param>
        /// <param name="eventAlertMessageUserID">The user id that the Alert email will come from</param>
        /// <param name="allowRemoveVote">Allow users to remove their votes</param>
        /// <param name="includeCrumbtrail">Whether the site includes/displays a crumbtrail through the category nodes</param>
        /// <param name="allowPostCodesInSearch">Whether the site allows searches on postcodes</param>
        /// <param name="queuePostings">Whether this site uses the post queue functionality</param>
        /// <param name="emergencyClosed">Whether the Site has been emergency closed</param>
        /// <param name="minAge">The minimum age of the site (to restrict allowedable users)</param>
        /// <param name="maxAge">The maximum age of the site (to restrict allowedable users)</param>
		/// <param name="modClassID">The Moderation Class of this site</param>
        /// <param name="ssoservice">The sso service to b eused for the site</param>
        /// <param name="useIdentitySignInSystem">A flag that states whether or not to use Identity to loig the user in</param>
        /// <param name="skinSet">The SkinSet</param>
        /// <param name="IdentityPolicy">The Identity policy Uri to use</param>
        public void AddSiteDetails(int id, string name, int threadOrder, bool preModeration, string defaultSkin, 
					                bool noAutoSwitch, string description, string shortName,
					                string moderatorsEmail, string editorsEmail,
					                string feedbackEmail, int autoMessageUserID, bool passworded,
					                bool unmoderated, bool articleGuestBookForums,
					                string config, string emailAlertSubject, int threadEditTimeLimit, 
					                int eventAlertMessageUserID, int allowRemoveVote, int includeCrumbtrail,
					                int allowPostCodesInSearch, bool queuePostings, bool emergencyClosed,
                                    int minAge, int maxAge, int modClassID, string ssoservice, bool useIdentitySignInSystem,
                                    string skinSet, string IdentityPolicy)
        {
            Site siteData = new Site(id, name, threadOrder, preModeration, defaultSkin, 
					                noAutoSwitch, description, shortName,
					                moderatorsEmail, editorsEmail,
					                feedbackEmail, autoMessageUserID, passworded,
					                unmoderated, articleGuestBookForums,
					                config, emailAlertSubject, threadEditTimeLimit, 
					                eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail,
					                allowPostCodesInSearch, queuePostings, emergencyClosed,
					                minAge, maxAge, modClassID, ssoservice,  useIdentitySignInSystem,
                                    skinSet, IdentityPolicy);

            _names.Add(name, siteData);
            _ids.Add(id, siteData);
        }

        /// <summary>
        /// Return the Site with the given name
        /// </summary>
        /// <param name="name">Name of the site</param>
        /// <param name="context">The context</param>
        /// <returns>The Site oject with that name or null</returns>
        public ISite GetSite(string name)
        {
            bool siteInList = _names.ContainsKey(name);
            if (!siteInList)
            {
                DnaDiagnostics.WriteWarningToLog("SiteList","A Site doesn't exist with that site name. ");
                return null;
            }

            return _names[name];
        }

        /// <summary>
        /// Return the Site with the given id
        /// </summary>
        /// <param name="id">Site ID</param>
        /// <param name="context">The context</param>
        /// <returns>The Site with that ID or null</returns>
        public ISite GetSite(int id)
        {
            bool siteInList = _ids.ContainsKey(id);
            if (!siteInList)
            {
                DnaDiagnostics.WriteWarningToLog("SiteList","A Site doesn't exist with that site id. ");
                return null;
            }

            return _ids[id];
        }

        /// <summary>
        /// Public method to Load the Site List with data from all of the Sites.
        /// Also loads in site options for all sites too
        /// </summary>
        public void LoadSiteList()
        {
            DnaDiagnostics.WriteTimedEventToLog("SiteList", "Creating list from database");
            LoadSiteList(0);
            DnaDiagnostics.WriteTimedEventToLog("SiteList", "Completed creating list from database");

            //get siteoptions
            _siteOptionList = new SiteOptionList(ReaderCreator, DnaDiagnostics);
            _siteOptionList.CreateFromDatabase();
        }


        /// <summary>
        /// Public method to Load the Site List with data for or all particular sites
        /// </summary>
        /// <param name="context">The context</param>
        /// <param name="id">Can load just a specific site</param>
        public void LoadSiteList(int id)
        {
            try
            {
                string getSiteData = "fetchsitedata";
                using (IDnaDataReader dataReader = ReaderCreator.CreateDnaDataReader(getSiteData))
                {
                    if (id > 0)
                    {
                        dataReader.AddParameter("@siteid", id);
                    }
                    dataReader.Execute();

                    if (dataReader.HasRows)
                    {
                        ProcessSiteData(dataReader);
                    }
                }
            }
            catch (Exception ex)
            {
                DnaDiagnostics.WriteExceptionToLog(ex);
            }
        }

        /// <summary>
        /// Given the DataReader containing the site data build the site list dictionary
        /// </summary>
        /// <param name="dataReader">DataReader object contain the site list data</param>
        /// <param name="context">The context it's called in</param>
        private void ProcessSiteData(IDnaDataReader dataReader)
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

                    AddSiteDetails(id, urlName, threadOrder, preModeration,
                                        defaultSkin, noAutoSwitch, description,
                                        shortName, moderatorsEmail, editorsEmail,
                                        feedbackEmail, autoMessageUserID, passworded,
                                        unmoderated, articleGuestBookForums, siteConfig,
                                        emailAlertSubject, threadEditTimeLimit,
                                        eventAlertMessageUserID, allowRemoveVote, includeCrumbtrail,
                                        allowPostCodesInSearch, queuePostings, siteEmergencyClosed,
                                        minAge, maxAge, modClassID, ssoservice, useIdentitySignInSystem, skinSet, IdentityPolicy);
                    prevSiteID = id;
                }

                string skinName = dataReader.GetStringNullAsEmpty("SkinName");
                string skinDescription = dataReader.GetStringNullAsEmpty("SkinDescription");
                bool useFrames = (dataReader.GetInt32NullAsZero("UseFrames") == 1);
                AddSkinToSite(urlName, skinName, skinDescription, useFrames);
            }

            //// Go through each site getting the min max ages 
            //foreach (int id in _ids.Keys)
            //{
            //    // Get the site min max ages from SSO/Identity
            //    _ids[id].GetSiteMinMaxAgeRangeFromSignInService(context);
            //}

			GetKeyArticleList();
			GetReviewForums();
            GetSiteTopics();
            GetSiteOpenCloseTimes();
        }

        /// <summary>
        /// This method gets the topics for the given site
        /// </summary>
        /// <param name="context">The context in which it's being called</param>
        private void GetSiteTopics()
        {
            // Get the topics for the given site
            using (IDnaDataReader reader = ReaderCreator.CreateDnaDataReader("GetTopicDetails"))
            {
                reader.AddParameter("TopicStatus", 0);
                //reader.AddParameter("SiteID", id);
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
                        AddTopic(id, topicID, title, h2g2ID, forumID);
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
        private void GetReviewForums()
        {
            using (IDnaDataReader dataReader = ReaderCreator.CreateDnaDataReader("getreviewforums"))
            {
                dataReader.AddParameter("@siteID", 0);	// site zero means get all sites
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
						int id = dataReader.GetInt32NullAsZero("SiteID");
						string urlFriendlyName = dataReader.GetStringNullAsEmpty("URLFriendlyName").ToString();
                        int forumid = dataReader.GetInt32NullAsZero("ReviewForumID");
                        AddReviewForum(id, urlFriendlyName, forumid);
                    }
                }
            }
        }
        
        /// <summary>
        /// Gets the list of Key articles for this site from the database
        /// </summary>
        /// <param name="context">The context it's called in</param>
        private void GetKeyArticleList()
        {
            using (IDnaDataReader dataReader = ReaderCreator.CreateDnaDataReader("getkeyarticlelist"))
            {
                dataReader.AddParameter("@siteID", 0);	// zero means get all sites data
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
						int id = dataReader.GetInt32NullAsZero("SiteID");
                        string articleName = dataReader.GetStringNullAsEmpty("ArticleName");
                        AddArticle(id, articleName);
                    }
                }
            }
        }

        /// <summary>
        /// Gets the Open and Close times from the databse for the site
        /// </summary>
        /// <param name="context">The context it's called in</param>
        private void GetSiteOpenCloseTimes()
        {
            using (IDnaDataReader dataReader = ReaderCreator.CreateDnaDataReader("getsitetopicsopenclosetimes"))
            {
				//dataReader.AddParameter("@siteID", id)
				//.Execute();
				dataReader.Execute();
                if (dataReader.HasRows)
                {
                    //For each row/site in the database add it's details
                    while (dataReader.Read())
                    {
                        byte dayofWeek = dataReader.GetByte("DayWeek");	// subtract one because C++ date code starts from Sunday = 1
						//dayofWeek -= 1;									// while .NET starts from Sunday = 0
                        byte hour = dataReader.GetByte("Hour");
                        byte minute = dataReader.GetByte("Minute");
                        int closed = (int)dataReader.GetByte("Closed");
						int id = dataReader.GetInt32NullAsZero("SiteID");
                        AddSiteOpenCloseTime(id, dayofWeek, hour, minute, closed);
                    }
                }
            }
        }

        /// <summary>
        /// Adds the given topic to the list of topics for the specified site
        /// </summary>
        /// <param name="id">The ID of the site you want to add the topic to</param>
        /// <param name="topicID">The ID of the topic you want to add</param>
        /// <param name="title">The title of the topic</param>
        /// <param name="h2g2ID">The h2g2id that represents the topic page</param>
        /// <param name="forumID">The forum id of the topic</param>
        private void AddTopic(int id, int topicID, string title, int h2g2ID, int forumID)
        {
            _ids[id].AddTopic(topicID, title, h2g2ID, forumID, 0);
        }

        /// <summary>
        /// Adds the given article name to the list of articles for the site in the sitelist dictionary with the given ID
        /// </summary>
        /// <param name="id">id of the site to add the key article name to</param>
        /// <param name="articleName">Name of the Key Article</param>
        private void AddArticle(int id, string articleName)
        {
            _ids[id].AddArticle(articleName);
        }
             
        /// <summary>
        /// Method that gets the specific site object in the siteid Dictionary to add the Open Close time info to it's OpenCloseTime list 
        /// </summary>
        /// <param name="id">Site ID</param>
        /// <param name="dayOfWeek">Day of the Week</param>
        /// <param name="hour">Hour of the day</param>
        /// <param name="minute">minute of the hour</param>
        /// <param name="closed">Whether its closed or not</param>
        private void AddSiteOpenCloseTime(int id, int dayOfWeek, int hour, int minute, int closed)
        {
            _ids[id].AddOpenCloseTime(dayOfWeek, hour, minute, closed);
        }

        /// <summary>
        /// Methods that calls the specific skin in the skin name Dictionary to add a skin to it's skin list
        /// </summary>
        /// <param name="siteName">Name of the site to add the skin to</param>
        /// <param name="skinName">Name of the skin to add to the list of skins for a site</param>
        /// <param name="skinDescription">Description of the skin to add to the list of skins for a site</param>
        /// <param name="useFrames">Whether the skin uses frames or not</param>
        private void AddSkinToSite(string siteName, string skinName, string skinDescription, bool useFrames)
        {
            _names[siteName].AddSkin(skinName, skinDescription, useFrames);          
        }

        /// <summary>
        /// Method to add the Review Forums for a given site
        /// </summary>
        /// <param name="id">Site ID to add the review forums to</param>
        /// <param name="forumName">The forum name</param>
        /// <param name="forumid">The forum id</param>
        private void AddReviewForum(int id, string forumName, int forumid)
        {
            _ids[id].AddReviewForum(forumName, forumid);
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
            return _siteOptionList.GetValueInt(siteId, section, name);
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
            return _siteOptionList.GetValueBool(siteId, section, name);
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
            return _siteOptionList.GetValueString(siteId, section, name);
        }

        /// <summary>
        /// Returns site options for a given site
        /// </summary>
        /// <param name="siteId">The id of the site to retrieve</param>
        /// <returns></returns>
        public List<SiteOption> GetSiteOptionListForSite(int siteId)
        {
            return _siteOptionList.GetSiteOptionListForSite(siteId);
        }

        /// <summary>
        /// Method to say whether this site is a message board
        /// </summary>
        public bool IsMessageboard(int siteID)
        {
           return _siteOptionList.GetValueBool(siteID, "General", "IsMessageboard");
        }

   }
}
