using System;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class ReservedArticlesPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ReservedArticlesPage()
    {
    }

    public override string PageType
    {
        get { return "RESERVED-ARTICLES"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the user page object
        AddComponent(new ReservedArticles(_basePage));
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