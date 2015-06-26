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
using BBC.Dna.Component;
using BBC.Dna.Moderation;

public partial class EditPost : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public EditPost()
    {
    }

	public override string PageType
	{
        get { return "EDIT-POST"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the forum object
        AddComponent(new EditPostPageBuilder(_basePage));
        AddComponent(new ModerationReasons(_basePage));
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
