using System;
using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class MorePostsPage : BBC.Dna.Page.DnaWebPage
{
    public override string PageType
    {
        get { return "MOREPOSTS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the More Posts object
        AddComponent(new MorePosts(_basePage));

        PageUI pageInterface = new PageUI(_basePage.ViewingUser.UserID);

        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(pageInterface.RootElement.FirstChild, true));

        _basePage.AddAllSitesXmlToPage();

        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(CurrentSite.GetTopicListXml(), true));

            // Add the sites topic list
            //RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            // Add site list xml
            //RootElement.AppendChild(ImportNode(InputContext.TheSiteList.GenerateAllSitesXml().FirstChild));

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