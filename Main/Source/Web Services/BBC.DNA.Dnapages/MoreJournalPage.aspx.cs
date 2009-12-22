using System;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class MoreJournalPage : BBC.Dna.Page.DnaWebPage
{
    MoreJournal _moreJournal = null;
    /// <summary>
    /// Default constructor.
    /// </summary>
    public MoreJournalPage()
    {
    }

    public override string PageType
    {
        get { return "JOURNAL"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        _moreJournal = new MoreJournal(_basePage);

        // Now create the more pages page object
        AddComponent(_moreJournal);
    }
    /// <summary>
    /// This function is overridden to put the ForumSource xml into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement)_basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");
        //_moreJournal.
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