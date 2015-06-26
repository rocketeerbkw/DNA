using System;
using BBC.Dna.Component;
/// <summary>
/// The Dna page for the comment box
/// </summary>
public partial class CommentBox : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public CommentBox()
    {
    }

	public override string PageType
	{
		get { return "COMMENTBOX"; }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the forum object
        AddComponent(new CommentBoxForum(_basePage));
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
