using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna.Component;

namespace BBC.DNA.Dnapages
{
    public partial class SiteOptions : BBC.Dna.Page.DnaWebPage
    {
        /// <summary>
        /// Page type property
        /// </summary>
        public override string PageType
        {
            get { return "SITEOPTIONS"; }
        }

        /// <summary>
        /// Allowed Editors property
        /// </summary>
        public override DnaBasePage.UserTypes AllowedUsers
        {
            get { return DnaBasePage.UserTypes.EditorAndAbove; }
        }

        /// <summary>
        /// OnPageLoad method 
        /// </summary>
        public override void OnPageLoad()
        {
            AddComponent(new SiteOptionsPageBuilder(_basePage));
        }
    }
}
