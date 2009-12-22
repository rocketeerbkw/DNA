using System;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class SiteSummaryPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public SiteSummaryPage()
    {
        UseDotNetRendering = false;
        //SetDnaXmlDataSource = true;
    }

    public override string PageType
    {
        get { return "SITESUMMARY"; }
    }


    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        DnaXmlDataSourceContolIDs.Add(new DnaXmlSourceDetails("SiteSummaryList", "H2G2/SITESUMMARY")); // Demonstrates using the root node
        AddComponent(new SiteSummary(_basePage));
        //Context.Items["VirtualUrl"] = "SiteSummary";
    }

    /// <summary>
    /// Check to see if we need to update anything on the outcome of the components process request.
    /// </summary>
    public override void OnPostProcessRequest()
    {
        
    }


    public override bool IsHtmlCachingEnabled()
    {
        return false;
    }

    public override int GetHtmlCachingTime()
    {
        return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }
}
