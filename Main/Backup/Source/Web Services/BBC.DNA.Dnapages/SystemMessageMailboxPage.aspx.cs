using System;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class SystemMessageMailboxPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public SystemMessageMailboxPage()
    {
    }

    public override string PageType
    {
        get { return "SYSTEMMESSAGEMAILBOX"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the user page object
        AddComponent(new SystemMessageMailbox(_basePage));
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