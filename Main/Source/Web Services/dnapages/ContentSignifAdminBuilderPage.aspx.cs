using System;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class ContentSignifAdminBuilderPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ContentSignifAdminBuilderPage()
    {
    }

    public override string PageType
    {
        get { return "CONTENTSIGNIFADMIN"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the Content Signif Admin builder object
        AddComponent(new ContentSignifAdminBuilder(_basePage));

        PageUI pageInterface = new PageUI(_basePage.ViewingUser.UserID);

        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(pageInterface.RootElement.FirstChild, true));

        _basePage.AddAllSitesXmlToPage();
    }

    /// <summary>
    /// Allowed users property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
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