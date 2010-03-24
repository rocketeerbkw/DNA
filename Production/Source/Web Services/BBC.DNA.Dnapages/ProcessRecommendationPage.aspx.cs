using System;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class ProcessRecommendationPage : BBC.Dna.Page.DnaWebPage
{
    ProcessRecommendation _processRecommendation = null;
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ProcessRecommendationPage()
    {
    }

    public override string PageType
    {
        get { return "PROCESS-RECOMMENDATION"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the recommend Entry object
        _processRecommendation = new ProcessRecommendation(_basePage);

        AddComponent(_processRecommendation);
    }

    /// <summary>
    /// This function is overridden to put the ForumSource xml into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement)_basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");
        h2g2Element.SetAttribute("MODE", _processRecommendation.ProcessRecommendationMode);
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
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }
}