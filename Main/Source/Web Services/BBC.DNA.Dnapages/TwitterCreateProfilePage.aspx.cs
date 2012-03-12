using System;
using BBC.Dna.Page;
using BBC.Dna.Component;


public partial class TwitterCreateProfilePage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public TwitterCreateProfilePage()
    {
    }

    public override string PageType
    {
        get { return "TWITTERCREATEPROFILE"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the twitter create profile object
        AddComponent(new TwitterCreateProfile(_basePage));
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
            return DnaBasePage.UserTypes.Administrator;
        }
    }
}

