using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;


public partial class UserReputationReport : BBC.Dna.Page.DnaWebPage
    {
        public override string PageType
        {
            get {
                return "USERREPUTATIONREPORT"; 
            }
        }
    
        /// <summary>
        /// This function is where the page gets to create and insert all the objects required
        /// </summary>
        public override void OnPageLoad()
        {
            AddComponent(new UserReputationReportBuilder(_basePage));
            AddComponent(new ModerationClasses(_basePage));
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
