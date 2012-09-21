using System;
using System.Xml;
using System.Collections.Generic;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using BBC.Dna.Data;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// The Site interface
    /// </summary>
    public interface ISite 
    {
        /// <summary>
        /// Method to add to the sites dictionary object of Articles
        /// </summary>
        /// <param name="articleName">The key article name</param>
        void AddArticle(string articleName);

        /// <summary>
        /// Method to Add Open Close Time to the sites list of open close times
        /// </summary>
        /// <param name="dayOfWeek">Day of the Week</param>
        /// <param name="hour">Hour</param>
        /// <param name="minute">Minute</param>
        /// <param name="closed">Whether close or not</param>
        void AddOpenCloseTime(int dayOfWeek, int hour, int minute, int closed);

        /// <summary>
        /// Method to add to the sites dictionary object of Review Forums
        /// </summary>
        /// <param name="forumName">The review forum name</param>
        /// <param name="forumID">The review Forums ID</param>
        void AddReviewForum(string forumName, int forumID);

        /// <summary>
        /// Adds a new skin object to the skin list
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <param name="skinDescription">Description for the skin</param>
        /// <param name="useFrames">whether the skin uses frames</param>
        void AddSkin(string skinName, string skinDescription, bool useFrames);

        /// <summary>
        /// SiteID Property
        /// </summary>
        int SiteID { get; set; }

        /// <summary>
        /// SiteName Property
        /// </summary>
        string SiteName { get; set; }

        /// <summary>
        /// MaxAge Property
        /// </summary>
        int MaxAge { get; }

        /// <summary>
        /// MinAge Property
        /// </summary>
        int MinAge { get; }

        /// <summary>
        /// IsEmergencyClosed Property
        /// </summary>
        bool IsEmergencyClosed { get; set; }

        /// <summary>
        /// 
        /// </summary>
        bool Closed { get; set; }
        

        /// <summary>
        /// DefaultSkin Property
        /// </summary>
        string DefaultSkin { get; }

        /// <summary>
        /// Returns the list of open/close times
        /// </summary>
        List<OpenCloseTime> OpenCloseTimes { get; }

		/// <summary>
		/// Moderation class of the site
		/// </summary>
		int ModClassID { get; }

		/// <summary>
		/// Description field of the site
		/// </summary>
		string Description { get;}

		/// <summary>
		/// Short name field for this site
		/// </summary>
		string ShortName { get; }

        /// <summary>
        /// Does the named skin exist in this site?
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <returns>true if success</returns>
        bool DoesSkinExist(string skinName);

        /// <summary>
        /// Try to Get Skin Set for skin. Empty if not found
        /// </summary>
        /// <returns></returns>
        string SkinSet { get; }
 
        /// <summary>
        /// Editors Email Property
        /// </summary>
        string EditorsEmail { get; set; }

        /// <summary>
        /// Moderators Email Property
        /// </summary>
        string ModeratorsEmail { get; set; }

        /// <summary>
        /// Feedback Email Property
        /// </summary>
        string FeedbackEmail { get; set; }

        /// <summary>
        /// Given a type of email to return return the correct email for the site
        /// </summary>
        /// <param name="emailType">Type of email required</param>
        /// <returns>The selected email for that type requested</returns>
        string GetEmail(Site.EmailType emailType);
     
        /// <summary>
        /// Given a datetime go through the openclosetimes for the site and see if the
        /// last scheduled event closed the site
        /// </summary>
        /// <param name="datetime">A datetime to check against</param>
        /// <returns>Whether the site is in a scheduled closed period</returns>
        bool IsSiteScheduledClosed(DateTime datetime);

        /// <summary>
        /// IsPassworded Property
        /// </summary>
        bool IsPassworded { get; set; }

        /// <summary>
        /// SSO Service name property
        /// </summary>
        string SSOService { get; set;}

        /// <summary>
        /// The Get/Set property for the Identity policy Uri
        /// </summary>
        string IdentityPolicy { get; set; }

        /// <summary>
        /// The moderation status for this site:
        ///     0 = unmoderated
        ///     1 = postmoderated
        ///     2 = premoderated
        /// </summary>
        ModerationStatus.SiteStatus ModerationStatus { get; }

        /// <summary>
        /// Gets the topic list as an XmlNode structure
        /// </summary>
        /// <returns>The topics list root node</returns>
        XmlNode GetTopicListXml();

        /// <summary>
        /// Returns the list of live topics for the site
        /// </summary>
        /// <returns>The list of live topics for this site</returns>
        List<Topic> GetLiveTopics();

        /// <summary>
        /// Returns config value
        /// </summary>
        string Config { get; set; }

        /// <summary>
        /// Get property for the id of the auto message user for the site
        /// </summary>
        int AutoMessageUserID { get; }

#if DEBUG
        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        bool UseIdentitySignInSystem { get; set; }
#else
        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        bool UseIdentitySignInSystem { get; }
#endif

        /// <summary>
        /// Get property for the Thread Edit Time Limit
        /// </summary>
        int ThreadEditTimeLimit { get; }

        /// <summary>
        /// Get property for the Include Crumbtrail
        /// </summary>
        int IncludeCrumbtrail { get; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        BaseResult UpdateEveryMessageBoardAdminStatusForSite(IDnaDataReaderCreator readerCreator, MessageBoardAdminStatus status);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ReaderCreator"></param>
        /// <returns></returns>
        XmlNode GetPreviewTopicsXml(IDnaDataReaderCreator ReaderCreator);


        /// <summary>
        /// Updates the site with a new skin and sets it as the default
        /// </summary>
        /// <param name="skinSet"></param>
        /// <param name="skinName"></param>
        /// <param name="skinDescription"></param>
        /// <param name="useFrames"></param>
        /// <param name="readerCreator"></param>
        /// <returns>A result of type result for ok or error with messaging</returns>
        BaseResult AddSkinAndMakeDefault(string skinSet, string skinName, string skinDescription, bool useFrames, IDnaDataReaderCreator readerCreator);

        /// <summary>
        /// Default site Contact Forms Email Property
        /// </summary>
        string ContactFormsEmail { get; set; }
    }
}
