﻿using BBC.Dna;
using BBC.Dna.Page;


public partial class CommentsListPage : BBC.Dna.Page.DnaWebPage
{
   
    public override string PageType
    {
        get {
            return "COMMENTSLIST"; 
        }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        AddComponent(new ForumCommentsList(_basePage));
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
            return DnaBasePage.UserTypes.EditorAndAbove;
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




