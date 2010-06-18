using System;
using System.Collections.Generic;
using System.Xml;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using BBC.Dna.Data;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// The Site class holds all the data regarding a Site
    /// </summary>
    public class Site : ISite
    {
        /// <summary>
        /// Dictionary of the skins associated with the site
        /// </summary>
        private readonly Dictionary<string, Skin> _skins = new Dictionary<string, Skin>();

        /// <summary>
        /// Dictionary of the Review forums associated with the site
        /// </summary>
        private readonly Dictionary<string, int> _reviewForums = new Dictionary<string, int>();

        /// <summary>
        /// Dictionary of the key articles associated with the site
        /// </summary>
        private readonly Dictionary<string, int> _articles = new Dictionary<string, int>();

        /// <summary>
        /// List for the topics associated with the site
        /// </summary>
        private readonly TopicList _topics = new TopicList();


        private readonly bool _unmoderated;
        private readonly bool _preModeration;


        private int _threadOrder;
        private int _allowRemoveVote;
        private int _allowPostCodesInSearch;
        private int _eventAlertMessageUserId;
        private bool _noAutoSwitch;
        private bool _articleGuestBookForums;
        private bool _queuePostings;
        private string _emailAlertSubject;

        /// <summary>
        /// Defines Site Email Types.
        /// </summary>
        public enum EmailType
        {
            /// <summary>
            /// 
            /// </summary>
            Moderators,
            /// <summary>
            /// 
            /// </summary>
            Editors,
            /// <summary>
            /// 
            /// </summary>
            Feedback
        }


        /// <summary>
        /// Constructor for a site Object
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
        /// <param name="autoMessageUserId">ID of the user that the emails originate from</param>
        /// <param name="passworded">Is the Site a passworded Site</param>
        /// <param name="unmoderated">Is the Site unmoderated</param>
        /// <param name="articleGuestBookForums">Default article forum style if the article forums are displayed in guestbook style</param>
        /// <param name="config">Config XML block for this site</param>
        /// <param name="emailAlertSubject">Default email subject for an alert from the site</param>
        /// <param name="threadEditTimeLimit">Time delay for editing threads for the site</param>
        /// <param name="eventAlertMessageUserId">The user id that the Alert email will come from</param>
        /// <param name="allowRemoveVote">Allow users to remove their votes</param>
        /// <param name="includeCrumbtrail">Whether the site includes/displays a crumbtrail through the category nodes</param>
        /// <param name="allowPostCodesInSearch">Whether the site allows searches on postcodes</param>
        /// <param name="queuePostings">Whether this site uses the post queue functionality</param>
        /// <param name="emergencyClosed">Whether the Site has been emergency closed</param>
        /// <param name="minAge">The minimum age of the site (to restrict allowedable users)</param>
        /// <param name="maxAge">The maximum age of the site (to restrict allowedable users)</param>
        /// <param name="modClassId">The moderation class of this site</param>
        /// <param name="ssoService">The sso service</param>
        /// <param name="useIdentitySignInSystem">A flag that states whether or not to use Identity to loig the user in</param>
        /// <param name="skinSet"></param>
        /// <param name="identityPolicy">The Identity Policy Uri to use</param>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="connection"></param>
        public Site(int id, string name, int threadOrder, bool preModeration, string defaultSkin,
                    bool noAutoSwitch, string description, string shortName,
                    string moderatorsEmail, string editorsEmail,
                    string feedbackEmail, int autoMessageUserId, bool passworded,
                    bool unmoderated, bool articleGuestBookForums,
                    string config, string emailAlertSubject, int threadEditTimeLimit,
                    int eventAlertMessageUserId, int allowRemoveVote, int includeCrumbtrail,
                    int allowPostCodesInSearch, bool queuePostings, bool emergencyClosed,
                    int minAge, int maxAge, int modClassId, string ssoService, bool useIdentitySignInSystem,
                    string skinSet, string identityPolicy)
        {
            OpenCloseTimes = new List<OpenCloseTime>();
            SiteID = id;
            SiteName = name;
            _threadOrder = threadOrder;
            _preModeration = preModeration;
            DefaultSkin = defaultSkin;
            _noAutoSwitch = noAutoSwitch;
            Description = description;
            ShortName = shortName;
            ModeratorsEmail = moderatorsEmail;
            EditorsEmail = editorsEmail;
            FeedbackEmail = feedbackEmail;
            AutoMessageUserID = autoMessageUserId;
            IsPassworded = passworded;
            _unmoderated = unmoderated;
            _articleGuestBookForums = articleGuestBookForums;
            Config = config;
            _emailAlertSubject = emailAlertSubject;
            ThreadEditTimeLimit = threadEditTimeLimit;
            _eventAlertMessageUserId = eventAlertMessageUserId;
            _allowRemoveVote = allowRemoveVote;
            IncludeCrumbtrail = includeCrumbtrail;
            _allowPostCodesInSearch = allowPostCodesInSearch;
            _queuePostings = queuePostings;
            IsEmergencyClosed = emergencyClosed;
            MinAge = minAge;
            MaxAge = maxAge;
            ModClassID = modClassId;
            SSOService = ssoService;
            UseIdentitySignInSystem = useIdentitySignInSystem;
            SkinSet = skinSet;
            this.IdentityPolicy = identityPolicy;
        }

        /// <summary>
        /// SiteID Property
        /// </summary>
        public int SiteID { get; set; }

        /// <summary>
        /// The Moderation Class of this site
        /// </summary>
        public int ModClassID { get; private set; }

        /// <summary>
        /// SiteName Property
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// ssoService Property
        /// </summary>
        public string SSOService { get; set; }

        /// <summary>
        /// Get/Set property for the Identity policy Uri
        /// </summary>
        public string IdentityPolicy { get; set; }

        /// <summary>
        /// MinAge property
        /// </summary>
        public int MinAge { get; set; }

        /// <summary>
        /// MaxAge property
        /// </summary>
        public int MaxAge { get; set; }

        /// <summary>
        /// MaxAge property
        /// </summary>
        public string SkinSet { get; private set; }

        /// <summary>
        /// Emergency Closed property
        /// </summary>
        public bool IsEmergencyClosed { get; set; }

        /// <summary>
        /// Default Skin property
        /// </summary>
        public string DefaultSkin { get; private set; }

        /// <summary>
        /// Editors Email Property
        /// </summary>
        public string EditorsEmail { get; set; }

        /// <summary>
        /// Moderators Email Property
        /// </summary>
        public string ModeratorsEmail { get; set; }

        /// <summary>
        /// Feedback Email Property
        /// </summary>
        public string FeedbackEmail { get; set; }

        /// <summary>
        /// Returns the list of open/close times
        /// </summary>
        public List<OpenCloseTime> OpenCloseTimes { get; private set; }

        /// <summary>
        /// Description field
        /// </summary>
        public string Description { get; private set; }

        /// <summary>
        /// ShortName field
        /// </summary>
        public string ShortName { get; private set; }

        /// <summary>
        /// Is the site passworded
        /// </summary>
        public bool IsPassworded { get; set; }

        /// <summary>
        /// The moderation status for this site:
        ///     0 = unmoderated
        ///     1 = postmoderated
        ///     2 = premoderated
        /// </summary>
        public ModerationStatus.SiteStatus ModerationStatus
        {
            get
            {
                // Premoderation flag overrides the Unmoderated flag when set
                if (_preModeration)
                {//TODO: Look at where this namespace conflict is coming from
                    return Moderation.Utils.ModerationStatus.SiteStatus.PreMod; // Premoderated
                }
                if (_unmoderated)
                {
                    return Moderation.Utils.ModerationStatus.SiteStatus.UnMod; // Unmoderated
                }
                return Moderation.Utils.ModerationStatus.SiteStatus.PostMod; // Implied postmoderated
            }
        }

        /// <summary>
        /// Get property for the Thread Edit Time Limit
        /// </summary>
        public int ThreadEditTimeLimit { get; private set; }

        /// <summary>
        /// Get property for the Include Crumbtrail
        /// </summary>
        public int IncludeCrumbtrail { get; private set; }

        /// <summary>
        /// Get property for the id of the auto message user for the site
        /// </summary>
        public int AutoMessageUserID { get; private set; }

        /// <summary>
        /// Returns site config value
        /// </summary>
        public string Config { get; set; }

        /// <summary>
        /// Given a type of email to return return the correct email for the site
        /// </summary>
        /// <param name="emailType">Type of email required</param>
        /// <returns>The selected email for that type requested</returns>
        public string GetEmail(EmailType emailType)
        {
            string retval = String.Empty;
            switch (emailType)
            {
                case EmailType.Editors:
                    retval = EditorsEmail;
                    break;
                case EmailType.Moderators:
                    retval = ModeratorsEmail;
                    break;
                case EmailType.Feedback:
                    retval = FeedbackEmail;
                    break;
            }
            return retval;
        }

        /// <summary>
        /// Does the named skin exist in this site?
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <returns>true if success</returns>
        public bool DoesSkinExist(string skinName)
        {
            bool retval = false;
            if (skinName != null)
            {
                string keyName = skinName.ToUpper();
                retval = _skins.ContainsKey(keyName);
            }
            return retval;
        }

        /// <summary>
        /// Given a datetime go through the openclosetimes for the site and see if the
        /// last scheduled event closed the site
        /// </summary>
        /// <param name="datetime">A datetime to check against</param>
        /// <returns>Whether the site is in a scheduled closed period</returns>
        public bool IsSiteScheduledClosed(DateTime datetime)
        {
            OpenCloseTime openCloseTime;
            int openCloseTimesCount = OpenCloseTimes.Count;

            if (openCloseTimesCount == 0)
            {
                // No scheduled closures. 
                return false;
            }

            for (int i = 0; i < openCloseTimesCount; i++)
            {
                openCloseTime = OpenCloseTimes[i];
                bool hasScheduledEventAlreadyHappened = openCloseTime.HasAlreadyHappened(datetime);
                if (hasScheduledEventAlreadyHappened)
                {
                    if (openCloseTime.Closed == 1)
                    {
                        // The last scheduled event closed topics on this site. 
                        return true;
                    }
                    else
                    {
                        // The last scheduled event opened topics on this site. 
                        return false;
                    }
                }
            }

            // no opening/closing time has passed yet so get the first one in the array.
            openCloseTime = OpenCloseTimes[0];

            if (openCloseTime.Closed == 1)
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// Checks if the Site is closed whether emergency closed or scheduled closed
        /// </summary>
        /// <returns>Whether the site is closed period</returns>
        public bool IsSiteClosed()
        {
            bool isClosed = false;
            isClosed = (IsSiteScheduledClosed(DateTime.Now) || IsEmergencyClosed);
            return isClosed;
        }

        /// <summary>
        /// Adds a new skin object to the skin list
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <param name="skinDescription">Description for the skin</param>
        /// <param name="useFrames">whether the skin uses frames</param>
        public void AddSkin(string skinName, string skinDescription, bool useFrames)
        {
            var newskin = new Skin(skinName, skinDescription, useFrames);
            string keyName = skinName.ToUpper();
            if (!_skins.ContainsKey(keyName))
            {
                _skins.Add(keyName, newskin);
            }
        }

        /// <summary>
        /// Adds a new skin object to the skin list
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <param name="skinDescription">Description for the skin</param>
        /// <param name="useFrames">whether the skin uses frames</param>
        /// <param name="readerCreator">used to commit to database</param>
        public BaseResult AddSkinAndMakeDefault(string skinSet, string skinName, string skinDescription, bool useFrames, IDnaDataReaderCreator readerCreator)
        {
            using (var reader = readerCreator.CreateDnaDataReader("updatesitedefaultskin"))
            {
                reader.AddParameter("siteid", SiteID);
                reader.AddParameter("defaultskin", skinName);
                reader.AddParameter("skinset", skinSet);
                reader.AddParameter("skindescription", skinDescription);
                reader.AddParameter("useframes", useFrames?1:0);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    if (reader.GetInt32NullAsZero("Result") == 1)
                    {
                        return new Error("AddSkinAndMakeDefault", reader.GetStringNullAsEmpty("Error"));
                    }
                    else
                    {
                        AddSkin(skinName, skinDescription, useFrames);
                        DefaultSkin = skinName;
                        SkinSet = skinSet;
                    }
                }
                else
                {
                    return new Error("AddSkinAndMakeDefault", "No response from database");
                }
            }
            return new Result("AddSkinAndMakeDefault", "OK");
        }

        /// <summary>
        /// Method to add to the sites dictionary object of Review Forums
        /// </summary>
        /// <param name="forumName">The review forum name</param>
        /// <param name="forumID">The review Forums ID</param>
        public void AddReviewForum(string forumName, int forumID)
        {
            string name = forumName.ToUpper();
            _reviewForums.Add(forumName, forumID);
        }

        /// <summary>
        /// Method to Add Open Close Time to the sites list of open close times
        /// </summary>
        /// <param name="dayOfWeek">Day of the Week</param>
        /// <param name="hour">Hour</param>
        /// <param name="minute">Minute</param>
        /// <param name="closed">Whether close or not</param>
        public void AddOpenCloseTime(int dayOfWeek, int hour, int minute, int closed)
        {
            var openCloseTime = new OpenCloseTime(dayOfWeek, hour, minute, closed);
            OpenCloseTimes.Add(openCloseTime);
        }

        /// <summary>
        /// Method to add to the sites dictionary object of Articles
        /// </summary>
        /// <param name="articleName">The key article name</param>
        public void AddArticle(string articleName)
        {
            string name = articleName.ToUpper();
            _articles.Add(name, 1);
        }


        /// <summary>
        /// Adds a topic to the topics list for this site
        /// </summary>
        /// <param name="topicID">The id of the topic</param>
        /// <param name="title">The title of the topic</param>
        /// <param name="h2g2ID">The h2g2ID for the topic page</param>
        /// <param name="forumID">The forumid for the topic</param>
        /// <param name="status">The status of the topic. 0 - Live, 1 - Preview, 2 - Deleted, 3 - Archived Live, 4 - Archived Preview</param>
        public void AddTopic(int topicID, string title, int h2g2ID, int forumID, int status)
        {
            _topics.Topics.Add(new Topic(topicID, title, h2g2ID, forumID, status));
        }

        /// <summary>
        /// Returns the list of live topics for the site
        /// </summary>
        /// <returns>The list of live topics for this site</returns>
        public List<Topic> GetLiveTopics()
        {
            return _topics.Topics;
        }

        /// <summary>
        /// This method gets the topics for the given site
        /// </summary>
        /// <param name="context">The context in which it's being called</param>
        public XmlNode GetPreviewTopicsXml(IDnaDataReaderCreator ReaderCreator)
        {
            var previewTopics = new TopicList() { Status = "PREVIEW" };
            // Get the topics for the given site
            using (IDnaDataReader reader = ReaderCreator.CreateDnaDataReader("GetTopicDetails"))
            {
                reader.AddParameter("TopicStatus", 1);
                reader.AddParameter("SiteID", SiteID);
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
                        previewTopics.Topics.Add(new Topic(){SiteId =id, TopicId=topicID, Title = title, H2G2Id = h2g2ID, ForumId = forumID});
                    }
                }
            }
            var doc = new XmlDocument();
            doc.LoadXml(StringUtils.SerializeToXmlUsingXmlSerialiser(previewTopics));
            // Return the list)
            return doc.DocumentElement;
        }

        /// <summary>
        /// Returns you the topics list as an XML structure
        /// </summary>
        /// <returns>The root XML node for the list</returns>
        public XmlNode GetTopicListXml()
        {
            var doc = new XmlDocument();
            doc.LoadXml(StringUtils.SerializeToXmlUsingXmlSerialiser(_topics));
            // Return the list)
            return doc.DocumentElement;
        }

        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        public bool UseIdentitySignInSystem { get; set; }

        /// <summary>
        /// Updates every message board admin status for the site
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        public BaseResult UpdateEveryMessageBoardAdminStatusForSite(IDnaDataReaderCreator readerCreator, MessageBoardAdminStatus status)
        {
            using (var reader = readerCreator.CreateDnaDataReader("UpdateEveryMessageBoardAdminStatusForSite"))
            {
                reader.AddIntReturnValue();
                reader.AddParameter("SiteID", SiteID);
                reader.AddParameter("Status", (int)status);
                reader.Execute();

                int retVal = -1;
                if (!reader.TryGetIntReturnValue(out retVal) || retVal != 0)
                {
                    return new Error("UpdateEveryMessageBoardAdminStatusForSite", "Error returned:" + retVal.ToString());
                }
            }
            return new Result("UpdateEveryMessageBoardAdminStatusForSite", "Successful");
        }
    }

    public enum MessageBoardAdminStatus
	{
		Unread= 0,
		Edited= 1,
	};
}