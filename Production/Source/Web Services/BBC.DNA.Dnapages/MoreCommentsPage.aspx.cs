using System;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class MoreCommentsPage : BBC.Dna.Page.DnaWebPage
{
    public override string PageType
    {
        get { return "MORECOMMENTS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the more comments object
        AddComponent(new MoreComments(_basePage));
        _basePage.AddAllSitesXmlToPage();
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
            return DnaBasePage.UserTypes.Any;
        }
    }
}
