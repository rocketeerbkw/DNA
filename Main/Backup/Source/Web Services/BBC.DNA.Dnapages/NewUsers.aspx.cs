using System;
using BBC.Dna.Component;
using BBC.Dna;
/// <summary>
/// The Dna page for the subbed article status page
/// </summary>
public partial class NewUsers : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public NewUsers()
    {
    }

	public override string PageType
	{
        get { return "NEWUSERS"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {       
        // Now create the forum object
        AddComponent(new BBC.Dna.Component.NewUsersPageBuilder(_basePage));

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
