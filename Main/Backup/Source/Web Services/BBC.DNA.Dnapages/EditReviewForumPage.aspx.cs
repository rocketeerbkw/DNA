using System;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class EditReviewForumPage : BBC.Dna.Page.DnaWebPage
{
    EditReviewForum _edirReviewForum = null;

    /// <summary>
    /// Default constructor.
    /// </summary>
    public EditReviewForumPage()
    {
        UseDotNetRendering = false;
    }

    public override string PageType
    {
        get { return "EDITREVIEW"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        _edirReviewForum = new EditReviewForum(_basePage);
 
        // Now create the edit review forum object
        AddComponent(_edirReviewForum);
    }

    /// <summary>
    /// This function is overridden to put the type attribute into the H2G2 element
    /// </summary>
    public override void OnPostProcessRequest()
    {
        XmlElement h2g2Element = (XmlElement)_basePage.WholePageBaseXmlNode.SelectSingleNode("H2G2");
        h2g2Element.SetAttribute("MODE", _edirReviewForum.EditReviewForumMode);
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