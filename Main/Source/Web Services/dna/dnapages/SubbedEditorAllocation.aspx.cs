using System;
using BBC.Dna.Component;
/// <summary>
/// The Dna page for the subbed article status page
/// </summary>
public partial class SubbedEditorAllocation : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public SubbedEditorAllocation()
    {
    }

	public override string PageType
	{
        get { return "SUB-ALLOCATION"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        
        // Now create the forum object
        AddComponent(new BBC.Dna.Component.SubEditorAllocationPageBuilder(_basePage));
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
