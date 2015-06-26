using BBC.Dna.Component;
using BBC.Dna.Page;

namespace BBC.DNA.Dnapages
{
    public partial class ModerationEmailManagementPage : BBC.Dna.Page.DnaWebPage
    {
        /// <summary>
        /// Default constructor.
        /// </summary>
        public ModerationEmailManagementPage()
        {
        }

	    public override string PageType
	    {
            get { return "MOD-EMAIL-MANAGEMENT"; }
	    }
        
        public override void OnPageLoad()
        {
            AddComponent(new ModerationEmailManagementBuilder(_basePage));
        }

        public override bool IsHtmlCachingEnabled()
        {
            return false;
        }

        public override int GetHtmlCachingTime()
        {
            return 0;
        }

        public override BBC.Dna.Page.DnaBasePage.UserTypes AllowedUsers
        {
            get { return DnaBasePage.UserTypes.EditorAndAbove; }
        }
    }
}
