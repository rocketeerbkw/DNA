using System;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class UserComplaintPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public UserComplaintPage()
    {
    }

    public override string PageType
    {
        get { return "USERCOMPLAINTPAGE"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the user page object
        AddComponent(new UserComplaint(_basePage));
    }

    /// <summary>
    /// States whether or not we html cahce this page
    /// </summary>
    /// <returns>false. This page should never be cached</returns>
    public override bool IsHtmlCachingEnabled()
    {
        return false;
    }

    private void GenerateXML()
    {


    }
}

