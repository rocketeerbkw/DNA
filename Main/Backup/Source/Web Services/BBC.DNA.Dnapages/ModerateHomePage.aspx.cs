using System;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class ModerateHomePage : BBC.Dna.Page.DnaWebPage
{
    ModerateHome _moderateHome = null;

    /// <summary>
    /// Default constructor.
    /// </summary>
    public ModerateHomePage()
    {
    }

    public override string PageType
    {
        get { return "MODERATE-HOME"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the more pages page object
        _moderateHome = new ModerateHome(_basePage);

        AddComponent(_moderateHome);

        ModerationClasses _moderationClasses = new ModerationClasses(_basePage);
        AddComponent(_moderationClasses);

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

    /// <summary> 
    /// Must Be Secure property
    /// </summary>
    public override bool MustBeSecure
    {
        get { return true; }
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