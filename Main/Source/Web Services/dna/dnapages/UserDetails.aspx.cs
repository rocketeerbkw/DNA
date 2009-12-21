using System;
using BBC.Dna.Component;
/// <summary>
/// The Dna page for the subbed article status page
/// </summary>
public partial class UserDetails : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public UserDetails()
    {
    }

	public override string PageType
	{
        get { return "USERDETAILS"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        
        // Now create the forum object
        AddComponent(new BBC.Dna.Component.UserDetailsPageBuilder(_basePage));
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
