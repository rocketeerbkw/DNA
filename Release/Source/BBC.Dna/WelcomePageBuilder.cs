using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;

namespace BBC.Dna.Component
{
    /// <summary>
    /// 
    /// </summary>
    public class WelcomePageBuilder : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        public bool IsNativeRenderRequest { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public bool UserLoggedIn { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string UserLoginName { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public int DNAUserID { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string DNAUserDisplayName { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string CurrentSiteDescription { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public string CurrentSiteUrlName { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public int CurrentSiteID { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public List<ISite> EditorOfSitesList { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        public bool IsSuperUser { get; private set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public WelcomePageBuilder(IInputContext context)
            : base(context)
        {
            IsNativeRenderRequest = true;
            UserLoggedIn = false;
            UserLoginName = "";
            DNAUserDisplayName = "";
            DNAUserID = 0;
            EditorOfSitesList = null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override void ProcessRequest()
        {
            GetRequestParams();
            GetCurrentSiteDetals();
            GetCurrentUserDetails();

            if (IsNativeRenderRequest)
            {
                return;
            }

            GenerateXML();
        }

        private void GetCurrentSiteDetals()
        {
            CurrentSiteDescription = InputContext.CurrentSite.Description;
            CurrentSiteUrlName = InputContext.CurrentSite.SiteName;
            CurrentSiteID = InputContext.CurrentSite.SiteID;
        }

        private void GetCurrentUserDetails()
        {
            if (InputContext.ViewingUser == null)
            {
                return;
            }

            UserLoginName = InputContext.ViewingUser.LoginName;
            DNAUserDisplayName = InputContext.ViewingUser.UserName;
            DNAUserID = InputContext.ViewingUser.UserID;
            IsSuperUser = InputContext.ViewingUser.IsSuperUser;
            UserLoggedIn = true;

            EditorOfSitesList = new List<ISite>();
            UserGroups userGroups = UserGroups.GetObject();
            foreach (int siteID in userGroups.GetSitesUserIsMemberOf(DNAUserID, "editor"))
            {
                EditorOfSitesList.Add(InputContext.TheSiteList.GetSite(siteID));
            }
        }

        private void GetRequestParams()
        {
            if (InputContext.GetParamStringOrEmpty("normalrender","Get the skin name to use for the page").ToLower() == "1")
            {
                IsNativeRenderRequest = false;
            }
        }

        private void GenerateXML()
        {

        }
    }
}
