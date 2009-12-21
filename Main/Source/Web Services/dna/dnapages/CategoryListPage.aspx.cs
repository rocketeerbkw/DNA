using System;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class CategoryListPage : BBC.Dna.Page.DnaWebPage
{
    CategoryListPageBuilder _categoryList = null;

    /// <summary>
    /// Default constructor.
    /// </summary>
    public CategoryListPage()
    {

    }

    public override string PageType
    {
        get { return "CATEGORYLIST"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        _categoryList = new CategoryListPageBuilder(_basePage);
        // Now create the category page list builder object
        AddComponent(_categoryList);
    }
    /// <summary>
    /// This function is overridden to put the MODE attribure into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement) _basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");
        h2g2Element.SetAttribute("MODE", _categoryList.CategoryListMode);
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