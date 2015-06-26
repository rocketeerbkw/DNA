using System;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class UITemplateDefinitionPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public UITemplateDefinitionPage()
    {
    }

    public override string PageType
    {
        get { return "UITEMPLATEDEFINITION"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the comment forum list object
        AddComponent(new UITemplateDefinition(_basePage));
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
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }
}
