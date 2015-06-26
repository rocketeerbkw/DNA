
using System;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class SubmitSubbedEntryPage : BBC.Dna.Page.DnaWebPage
{
    //SubmitSubbedEntry _submitSubbedEntry = null;
    /// <summary>
    /// Default constructor.
    /// </summary>
    public SubmitSubbedEntryPage()
    {
    }

    public override string PageType
    {
        get { return "SUBMIT-SUBBED-ENTRY"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        //_submitSubbedEntry = new SubmitSubbedEntry(_basePage);

        // Now create the submit review forum builder page object
        //AddComponent(_submitReviewForum);
    }

    /// <summary>
    /// This function can be overridden 
    /// </summary>
    public override void OnPostProcessRequest()
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