using System;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class MorePagesPage : BBC.Dna.Page.DnaWebPage
{
    MorePages _morePages = null;

    /// <summary>
    /// Default constructor.
    /// </summary>
    public MorePagesPage()
    {
    }

    public override string PageType
    {
        get { return "MOREPAGES"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the more pages page object
        _morePages = new MorePages(_basePage);

        AddComponent(_morePages);

        _basePage.AddAllSitesXmlToPage();
    }

    /// <summary>
    /// This function is overridden to put the PageOwner xml into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement)_basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");

        if (_morePages.PageOwnerElement != null)
        {
            h2g2Element.AppendChild(h2g2Element.OwnerDocument.ImportNode(_morePages.PageOwnerElement.FirstChild, true));
        }
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