using System;
using BBC.Dna;
using BBC.Dna.Component;
/// <summary>
/// The Dna page for the subbed article status page
/// </summary>
public partial class SecureRequiredPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public SecureRequiredPage()
    {
    }

	public override string PageType
	{
        get { return "SECUREREQUIRED"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
       
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
