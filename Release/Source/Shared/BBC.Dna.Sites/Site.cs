using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using System.Net.Sockets;
using System.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// The Site class holds all the data regarding a Site
    /// </summary>
    public class Site : Context, ISite
    {
        /// <summary>
        /// Dictionary of the skins associated with the site
        /// </summary>
        private Dictionary<string, Skin> _skins = new Dictionary<string, Skin>();
        /// <summary>
        /// Dictionary of the Review forums associated with the site
        /// </summary>
        private Dictionary<string, int> _reviewForums = new Dictionary<string, int>();
        /// <summary>
        /// Dictionary of the key articles associated with the site
        /// </summary>
        private Dictionary<string, int> _articles = new Dictionary<string, int>();

        /// <summary>
        /// List for the topics associated with the site
        /// </summary>
        private List<Topic> _topics = new List<Topic>();

        /// <summary>
        /// List for the open close times associated with the site
        /// </summary>
        private List<OpenCloseTime> _openCloseTimes = new List<OpenCloseTime>();

        /// <summary>
        /// The Site ID of the Site
        /// </summary>
        private int _id = 0;
        /// <summary>
        /// The Site name of the Site
        /// </summary>
        private string _name = String.Empty;

        private int _threadOrder;
        private int _allowRemoveVote;
        private int _includeCrumbtrail;
        private int _allowPostCodesInSearch;
        private int _threadEditTimeLimit;
        private int _autoMessageUserID;
        private int _eventAlertMessageUserID;
 
        private int _minAge;
        private int _maxAge;
		private int _modClassID;

        private bool _preModeration;
        private bool _noAutoSwitch;
        private bool _passworded;

        private bool _unmoderated;
        private bool _articleGuestBookForums;
        private bool _queuePostings;

        private bool _emergencyClosed;
        private string _defaultSkin;

        private string _description;
        private string _shortName;
        private string _ssoService;
        private string _skinSet;
        private string _IdentityPolicy;

        private bool _useIdentitySignInSystem;

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

        private string _moderatorsEmail;
        private string _editorsEmail;
        private string _feedbackEmail;

        private string _config;
        private string _emailAlertSubject;
 


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
		/// <param name="modClassID">The moderation class of this site</param>
        /// <param name="ssoService">The sso service</param>
        /// <param name="useIdentitySignInSystem">A flag that states whether or not to use Identity to loig the user in</param>
        /// <param name="skinSet"></param>
        /// <param name="IdentityPolicy">The Identity Policy Uri to use</param>
        public Site(int id, string name, int threadOrder, bool preModeration, string defaultSkin, 
								                bool noAutoSwitch, string description, string shortName,
								                string moderatorsEmail, string editorsEmail,
								                string feedbackEmail, int autoMessageUserID, bool passworded,
								                bool unmoderated, bool articleGuestBookForums,
								                string config, string emailAlertSubject, int threadEditTimeLimit, 
								                int eventAlertMessageUserID, int allowRemoveVote, int includeCrumbtrail,
								                int allowPostCodesInSearch, bool queuePostings, bool emergencyClosed,
                                                int minAge, int maxAge, int modClassID, string ssoService, bool useIdentitySignInSystem,
                                                string skinSet, string IdentityPolicy, IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        {
            _id = id;
            _name = name;
            _threadOrder = threadOrder;
            _preModeration = preModeration;
            _defaultSkin = defaultSkin;
            _noAutoSwitch = noAutoSwitch;
            _description = description;
            _shortName = shortName;
            _moderatorsEmail = moderatorsEmail;
            _editorsEmail = editorsEmail;
            _feedbackEmail = feedbackEmail;
            _autoMessageUserID = autoMessageUserID;
            _passworded = passworded;
            _unmoderated = unmoderated;
            _articleGuestBookForums = articleGuestBookForums;
            _config = config;
            _emailAlertSubject = emailAlertSubject;
            _threadEditTimeLimit = threadEditTimeLimit;
            _eventAlertMessageUserID = eventAlertMessageUserID;
            _allowRemoveVote = allowRemoveVote;
            _includeCrumbtrail = includeCrumbtrail;
            _allowPostCodesInSearch = allowPostCodesInSearch;
            _queuePostings = queuePostings;
            _emergencyClosed = emergencyClosed;
            _minAge = minAge;
            _maxAge = maxAge;
			_modClassID = modClassID;
            _ssoService = ssoService;
            _useIdentitySignInSystem = useIdentitySignInSystem;
            _skinSet = skinSet;
            _IdentityPolicy = IdentityPolicy;

        }

        /// <summary>
        /// SiteID Property
        /// </summary>
        public int SiteID
        {
            get
            {
                return _id;
            }
            set
            {
                _id = value;
            }
        }

		/// <summary>
		/// The Moderation Class of this site
		/// </summary>
		public int ModClassID
		{
			get
			{
				return _modClassID;
			}
		}

        /// <summary>
        /// SiteName Property
        /// </summary>
        public string SiteName
        {
            get
            {
                return _name;
            }
            set
            {
                _name = value;
            }
        }

        /// <summary>
        /// ssoService Property
        /// </summary>
        public string SSOService
        {
            get
            {
                return _ssoService;
            }
            set
            {
                _ssoService = value;
            }
        }

        /// <summary>
        /// Get/Set property for the Identity policy Uri
        /// </summary>
        public string IdentityPolicy
        {
            get { return _IdentityPolicy; }
            set { _IdentityPolicy = value; }
        }

        /// <summary>
        /// MinAge property
        /// </summary>
        public int MinAge
        {
            get 
            { 
                return _minAge; 
            }
            set 
            { 
                _minAge = value; 
            }
        }

        /// <summary>
        /// MaxAge property
        /// </summary>
        public int MaxAge
        {
            get 
            { 
                return _maxAge; 
            }
            set 
            { 
                _maxAge = value; 
            }
        }

        /// <summary>
        /// MaxAge property
        /// </summary>
        public string SkinSet
        {
            get
            {
                return _skinSet;
            }
        }

        /// <summary>
        /// Emergency Closed property
        /// </summary>
        public bool IsEmergencyClosed
        {
            get 
            { 
                return _emergencyClosed; 
            }
            set 
            { 
                _emergencyClosed = value; 
            }
        }

        /// <summary>
        /// Default Skin property
        /// </summary>
        public string DefaultSkin
        {
            get
            {
                return _defaultSkin;
            }
        }

        /// <summary>
        /// Editors Email Property
        /// </summary>
        public string EditorsEmail
        {
            get
            {
                return _editorsEmail;
            }
            set
            {
                _editorsEmail = value;
            }
        }

        /// <summary>
        /// Moderators Email Property
        /// </summary>
        public string ModeratorsEmail
        {
            get
            {
                return _moderatorsEmail;
            }
            set
            {
                _moderatorsEmail = value;
            }
        }

        /// <summary>
        /// Feedback Email Property
        /// </summary>
        public string FeedbackEmail
        {
            get
            {
                return _feedbackEmail;
            }
            set
            {
                _feedbackEmail = value;
            }
        }

        /// <summary>
        /// Returns the list of open/close times
        /// </summary>
        public List<OpenCloseTime> OpenCloseTimes
        {
            get { return _openCloseTimes; }
        }

		/// <summary>
		/// Description field
		/// </summary>
		public string Description
		{
			get
			{
				return _description;
			}
		}

		/// <summary>
		/// ShortName field
		/// </summary>
		public string ShortName
		{
			get
			{
				return _shortName;
			}
		}

        /// <summary>
        /// Is the site passworded
        /// </summary>
        public bool IsPassworded
        {
            get 
            { 
                return _passworded; 
            }
            set 
            { 
                _passworded = value; 
            }
        }

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
                {
                    return BBC.Dna.Moderation.Utils.ModerationStatus.SiteStatus.PreMod;   // Premoderated
                }
                else
                {
                    if (_unmoderated)
                    {
                        return BBC.Dna.Moderation.Utils.ModerationStatus.SiteStatus.UnMod;   // Unmoderated
                    }
                    else
                    {
                        return BBC.Dna.Moderation.Utils.ModerationStatus.SiteStatus.PostMod;   // Implied postmoderated
                    }
                }
            }
        }

        /// <summary>
        /// Get property for the Thread Edit Time Limit
        /// </summary>
        public int ThreadEditTimeLimit
        {
            get { return _threadEditTimeLimit; }
        }

        /// <summary>
        /// Get property for the Include Crumbtrail
        /// </summary>
        public int IncludeCrumbtrail
        {
            get { return _includeCrumbtrail; }
        }

        /// <summary>
        /// Get property for the id of the auto message user for the site
        /// </summary>
        public int AutoMessageUserID
        {
            get { return _autoMessageUserID; }
        }

        /// <summary>
        /// Returns site config value
        /// </summary>
        public string Config
        {
            get { return _config; }
            set { _config = value; }
        }

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
            int openCloseTimesCount = _openCloseTimes.Count;

            if (openCloseTimesCount == 0)
            {
                // No scheduled closures. 
                return false;
            }

            for (int i = 0; i < openCloseTimesCount; i++)
            {
                openCloseTime = _openCloseTimes[i];
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
            openCloseTime = _openCloseTimes[0];

            if (openCloseTime.Closed == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
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
	        Skin newskin = new Skin(skinName, skinDescription, useFrames);
            string keyName = skinName.ToUpper();
	        _skins.Add(keyName, newskin);
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
            OpenCloseTime openCloseTime = new OpenCloseTime(dayOfWeek, hour, minute, closed);
            _openCloseTimes.Add(openCloseTime);
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
            _topics.Add(new Topic(topicID, title, h2g2ID, forumID, status));
        }

        /// <summary>
        /// Returns the list of live topics for the site
        /// </summary>
        /// <returns>The list of live topics for this site</returns>
        public List<Topic> GetLiveTopics()
        {
            return _topics;
        }
        
        /// <summary>
        /// Returns you the topics list as an XML structure
        /// </summary>
        /// <returns>The root XML node for the list</returns>
        public XmlNode GetTopicListXml()
        {
            // Create the root node
            XmlDocument doc = new XmlDocument();
            XmlElement listNode = doc.CreateElement("TOPICLIST");

            // Now go through the topics list adding them as nodes
            foreach (Topic topic in _topics)
            {
                // Create the container
                XmlElement topicElement = doc.CreateElement("TOPIC");

                // Add the topic id
                XmlElement topicID = doc.CreateElement("TOPICID");
                topicID.InnerText = topic.TopicID.ToString();
                topicElement.AppendChild(topicID);

                // Add the topic Title
                XmlElement topicTitle = doc.CreateElement("TITLE");
                topicTitle.AppendChild(doc.CreateTextNode(""));
                topicTitle.InnerXml = topic.Title;
                topicElement.AppendChild(topicTitle);

                // Add the topic h2g2id
                XmlElement topicH2G2ID = doc.CreateElement("H2G2ID");
                topicH2G2ID.InnerText = topic.h2g2ID.ToString();
                topicElement.AppendChild(topicH2G2ID);

                // Add the topic forumid
                XmlElement topicForumID = doc.CreateElement("FORUMID");
                topicForumID.InnerText = topic.ForumID.ToString();
                topicElement.AppendChild(topicForumID);

                // Now add the topic to the list
                listNode.AppendChild(topicElement);
            }

            // Return the list
            return listNode;
        }


#if DEBUG
        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        public bool UseIdentitySignInSystem
        {
            get { return _useIdentitySignInSystem; }
            set { _useIdentitySignInSystem = value; }
        }
#else
        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        public bool UseIdentitySignInSystem
        {
            get { return _useIdentitySignInSystem; }
        }
#endif

    }
}
