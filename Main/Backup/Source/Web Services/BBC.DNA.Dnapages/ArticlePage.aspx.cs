using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using BBC.Dna;
using BBC.Dna.Page;

public partial class ArticlePage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ArticlePage()
    {
    }

    /// <summary>
    /// The page type get property
    /// </summary>
    public override string PageType
    {
        get { return "ARTICLE"; }
    }

    /// <summary>
    /// The Allowed Users get property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.Any;
        }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Create an article object to do the work
        AddComponent(new ArticleBuilder(_basePage));
    }
}
