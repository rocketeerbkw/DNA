using BBC.Dna;
using BBC.Dna.Page;


public partial class HostDashboardActivityPage : BBC.Dna.Page.DnaWebPage
    {
        public override string PageType
        {
            get {
                return "HOSTDASHBOARDACTIVITYPAGE"; 
            }
        }
    
        /// <summary>
        /// This function is where the page gets to create and insert all the objects required
        /// </summary>
        public override void OnPageLoad()
        {
            AddComponent(new HostDashboardActivityFeed(_basePage));
        }
        public override bool IsHtmlCachingEnabled()
        {
            return GetSiteOptionValueBool("cache", "HTMLCaching");
        }

        public override int GetHtmlCachingTime()
        {
            return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
        }

        public override DnaBasePage.UserTypes AllowedUsers
        {
            get
            {
                return DnaBasePage.UserTypes.EditorAndAbove;
            }
        }
    }
