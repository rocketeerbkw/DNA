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

public partial class BlogSummaryPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public BlogSummaryPage()
    {
    }

	public override string PageType
	{
		get { return "BLOGSUMMARY"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the forum object
        AddComponent(new BlogSummary(_basePage));
    }
	public override bool IsHtmlCachingEnabled()
	{
		return GetSiteOptionValueBool("cache", "HTMLCaching");
	}

	public override int GetHtmlCachingTime()
	{
		return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
	}
}
