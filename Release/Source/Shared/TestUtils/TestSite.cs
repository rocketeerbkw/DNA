using System;
using System.Text;
using System.Xml;
using System.Collections.Generic;

using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using BBC.Dna.Moderation.Utils;

namespace Tests
{
    /// <summary>
    /// Derive from the class to partially implement the ISite interface.
    /// </summary>
    public class TestSite : ISite
    {

        #region ISite Members

        /// <summary>
        /// Method to add to the sites dictionary object of Articles
        /// </summary>
        /// <param name="articleName">The key article name</param>
        public virtual void AddArticle(string articleName)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Method to Add Open Close Time to the sites list of open close times
        /// </summary>
        /// <param name="dayOfWeek">Day of the Week</param>
        /// <param name="hour">Hour</param>
        /// <param name="minute">Minute</param>
        /// <param name="closed">Whether close or not</param>
        public virtual void AddOpenCloseTime(int dayOfWeek, int hour, int minute, int closed)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Method to add Review Forums
        /// </summary>
        /// <param name="forumName">The review forum name</param>
        /// <param name="forumID">The review Forums ID</param>
        public virtual void AddReviewForum(string forumName, int forumID)
        {
            throw new Exception("The method or operation is not implemented.");
        }

		/// <summary>
		/// Description field
		/// </summary>
		public string Description
		{
			get
			{
				throw new Exception("The method or operation is not implemented.");
			}
		}
		/// <summary>
		/// ShortName field
		/// </summary>
		public string ShortName
		{
			get
			{
				throw new Exception("The method or operation is not implemented.");
			}
		}

        /// <summary>
        /// Adds a new skin object to the skins
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <param name="skinDescription">Description for the skin</param>
        /// <param name="useFrames">whether the skin uses frames</param>
        public virtual void AddSkin(string skinName, string skinDescription, bool useFrames)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Public method to generate the Sites XML representation
        /// </summary>
        /// <returns>The subnode representing the site data</returns>
        public virtual System.Xml.XmlNode GenerateXml(System.Xml.XmlNode siteOptionListXml)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// SiteID Property
        /// </summary>
        public virtual int SiteID
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

		/// <summary>
		/// Mod class of the site
		/// </summary>
		public virtual int ModClassID
		{
			get
			{
				throw new NotImplementedException();
			}
		}

        /// <summary>
        /// SiteName Property
        /// </summary>
        public virtual string SiteName
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        public bool Closed
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// MinAge Property
        /// </summary>
        public virtual int MinAge
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// MaxAge Property
        /// </summary>
        public virtual int MaxAge
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// Default Skin Property
        /// </summary>
        public virtual string DefaultSkin
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// IsEmergencyClosed Property
        /// </summary>
        public virtual bool IsEmergencyClosed
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// Does the named skin exist in this site?
        /// </summary>
        /// <param name="skinName">Name of the skin</param>
        /// <returns>true if success</returns>
        public virtual bool DoesSkinExist(string skinName)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// ModeratorsEmail Property
        /// </summary>
        public virtual string ModeratorsEmail
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// EditorsEmail Property
        /// </summary>
        public virtual string EditorsEmail
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }
        /// <summary>
        /// FeedbackEmail Property
        /// </summary>
        public virtual string FeedbackEmail
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// Given a datetime go through the openclosetimes for the site and see if the
        /// last scheduled event closed the site
        /// </summary>
        /// <param name="datetime">A datetime to check against</param>
        /// <returns>Whether the site is in a scheduled closed period</returns>
        public virtual bool IsSiteScheduledClosed(DateTime datetime)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Given a type of email to return return the correct email for the site
        /// </summary>
        /// <param name="emailType">Type of email required</param>
        /// <returns>The selected email for that type requested</returns>
        public virtual string GetEmail(Site.EmailType emailType)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// IsPassworded Property
        /// </summary>
        public virtual bool IsPassworded
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// SiteConfig property
        /// </summary>
        public virtual XmlNode SiteConfig
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// SSOService property
        /// </summary>
        public virtual string SSOService
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
            set
            {
                new Exception("The method or operation is not implemented.");
            }
        }


        public ModerationStatus.SiteStatus ModerationStatus
        {
            get { throw new NotImplementedException("Moderation Status get property not implimented!");  }
        }

        /// <summary>
        /// IncludeCrumbtrail
        /// </summary>
        public int IncludeCrumbtrail
        {
            get { throw new NotImplementedException("IncludeCrumbtrail not supported"); }
        }

        public BaseResult AddSkinAndMakeDefault(string skinSet, string skinName, string skinDescription, bool useFrames, IDnaDataReaderCreator readerCreator)
        {
            throw new NotImplementedException("AddSkinAndMakeDefault not implimented for tests!");
        }

        #endregion

        public XmlNode GetTopicListXml()
        {
            throw new NotImplementedException("GetTopicsListXml not implimented for tests!");
        }
        
        public List<Topic> GetLiveTopics()
        {
            throw new NotImplementedException("GetLiveTopics not implimented for tests!");
        }

        /// <summary>
        /// Get property for the id of the auto message user for the site
        /// </summary>
        public int AutoMessageUserID
        {
            get { throw new NotImplementedException("AutoMessageUserID not supported"); }
        }

        /// <summary>
        /// Get property that states whether or not the current site uses Identity to log users in.
        /// </summary>
        public bool UseIdentitySignInSystem
        {
            get { return false; }
            set { ; }
        }

        /// <summary>
        /// Get/Set property for the identity policy uri
        /// </summary>
        public string IdentityPolicy
        {
            get { return ""; }
            set { ; }
        }

        /// <summary>
        /// Gets the min and max ages for the current site
        /// </summary>
        public void GetSiteMinMaxAgeRangeFromSignInService(IAppContext context)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="skinName"></param>
        /// <returns></returns>
        public virtual string SkinSet
        {
            get
            {
                throw new Exception("The method or operation is not implemented.");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public int ThreadEditTimeLimit
        {
            get { throw new NotImplementedException("ThreadEditTimeLimit not supported"); }
        }

        /// <summary>
        /// Returns site config value
        /// </summary>
        public string Config
        {
            get { return String.Empty; }
            set {  }
        }

        /// <summary>
        /// Returns the list of open/close times
        /// </summary>
        public List<OpenCloseTime> OpenCloseTimes
        {
            get { return null; }
        }

        public BaseResult UpdateEveryMessageBoardAdminStatusForSite(IDnaDataReaderCreator readerCreator, MessageBoardAdminStatus status)
        {
            return new Result("UpdateEveryMessageBoardAdminStatusForSite", "Successful");
        }

        public XmlNode GetPreviewTopicsXml(IDnaDataReaderCreator creator)
        {
            throw new NotImplementedException();
        }

        #region IDnaComponent Members

        /// <summary>
        /// ProcessRequest is called by the DNA framework to ask this object to process the current request
        /// </summary>
        /// <remarks>
        /// If your component is able to work automatically by simply being added to the page,
        /// responding to parameters in the query string, then implement ProcessRequest to build
        /// your XML data, responding to parameters in the query string.
        /// </remarks>
        public virtual void ProcessRequest()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// The name of the component.
        /// </summary>
        public virtual string ComponentName
        {
            get { throw new Exception("The method or operation is not implemented."); }
        }
        
        /// <summary>
        /// Property exposing the root element of this component.
        /// </summary>
        public virtual System.Xml.XmlElement RootElement
        {
            get { throw new Exception("The method or operation is not implemented."); }
        }

        #endregion
    }
}
