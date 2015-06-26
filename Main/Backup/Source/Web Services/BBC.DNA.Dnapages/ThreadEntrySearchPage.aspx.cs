using System;
using BBC.Dna;
using BBC.Dna.Component;

/// <summary>
/// The Dna page for the scout recommendations page
/// </summary>
public partial class ThreadEntrySearchPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ThreadEntrySearchPage()
    {
    }

	public override string PageType
	{
        get { return "THREADENTRY-SEARCH"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {       
        // Now create the forum object
        AddComponent(new ThreadEntrySearch(_basePage));
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
