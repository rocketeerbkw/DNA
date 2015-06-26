using System;
using BBC.Dna;
using BBC.Dna.Component;
/// <summary>
/// The Dna page for the subbed article status page
/// </summary>
public partial class Info : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public Info()
    {
    }

	public override string PageType
	{
        get { return "INFO"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        
        // Now create the forum object
        AddComponent(new BBC.Dna.Component.InfoBuilder(_basePage));

        PageUI pageInterface = new PageUI(_basePage.ViewingUser.UserID);

        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(pageInterface.RootElement.FirstChild, true));
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
