using System;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class CommentForumListPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public CommentForumListPage()
    {
    }

    public override string PageType
    {
        get { return "COMMENTFORUMLIST"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the comment forum list object
        AddComponent(new CommentForumList(_basePage));
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
            return DnaBasePage.UserTypes.Any;
        }
    }

    /// <summary> 
    /// Must Be Secure property
    /// </summary>
    public override bool MustBeSecure
    {
        get { return true; }
    }
}
