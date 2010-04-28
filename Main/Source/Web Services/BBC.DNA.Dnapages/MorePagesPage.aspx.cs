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

        XmlDocument doc = _basePage.WholePageBaseXmlNode.OwnerDocument;

        // Create an XML declaration. 
        XmlDeclaration xmldecl;
        xmldecl = doc.CreateXmlDeclaration("1.0",null,null);
        xmldecl.Encoding = "ISO8859-1";
        xmldecl.Standalone="yes";     
          
        // Add the new node to the document.
        XmlElement root = doc.DocumentElement;
        doc.InsertBefore(xmldecl, root);
        
        
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