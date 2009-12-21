using System;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class MoreUserSubscriptionsPage : BBC.Dna.Page.DnaWebPage
{
    public override string PageType
    {
        get { return "MOREUSERSUBSCRIPTIONS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the More User Subscriptions object
        AddComponent(new MoreUserSubscriptions(_basePage));
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
