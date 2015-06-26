using System;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class BlockedUserSubscriptionsPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public BlockedUserSubscriptionsPage()
    {
    }

    public override string PageType
    {
        get { return "BLOCKEDUSERSUBSCRIPTIONS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the comment forum list object
        AddComponent(new BlockedUserSubscriptions(_basePage));
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
