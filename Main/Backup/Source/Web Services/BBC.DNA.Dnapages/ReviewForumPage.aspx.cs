using System;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Page;
using BBC.Dna;

public partial class ReviewForumPage : BBC.Dna.Page.DnaWebPage
{
    ReviewForumBuilder _reviewForum = null;
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ReviewForumPage()
    {
    }

    public override string PageType
    {
        get { return "REVIEWFORUM"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        _reviewForum = new ReviewForumBuilder(_basePage);

        // Now create the review forum builder page object
        AddComponent(_reviewForum);

        PageUI pageInterface = new PageUI(_basePage.ViewingUser.UserID);

        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(pageInterface.RootElement.FirstChild, true));
    }

    /// <summary>
    /// This function is overridden to put the ForumSource xml into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement)_basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");

        if (_reviewForum.GuideEntryElement != null)
        {
            h2g2Element.AppendChild(h2g2Element.OwnerDocument.ImportNode(_reviewForum.GuideEntryElement.FirstChild, true));
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