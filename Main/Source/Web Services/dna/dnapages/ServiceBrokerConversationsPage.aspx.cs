using System;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class ServiceBrokerConversationsPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ServiceBrokerConversationsPage()
    {
        UseDotNetRendering = false;
    }

    public override string PageType
    {
        get { return "SERVICEBROKERCONVERSATIONS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the comment forum list object
        AddComponent(new ServiceBrokerConversations(_basePage));
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
            return DnaBasePage.UserTypes.Any; // TODO - tighten this up so only Administrators have access. 
        }
    }
}
