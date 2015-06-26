using BBC.Dna;
using BBC.Dna.Page;


    public partial class TermsFilterImport : DnaWebPage
    {
        public override string PageType
        {
            get {
                return "TERMSFILTERIMPORT"; 
            }
        }
    
        /// <summary>
        /// This function is where the page gets to create and insert all the objects required
        /// </summary>
        public override void OnPageLoad()
        {
            // Now create the forum object
            AddComponent(new TermsFilterImportPageBuilder(_basePage));
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
                return DnaBasePage.UserTypes.Administrator;
            }
        }
    }
