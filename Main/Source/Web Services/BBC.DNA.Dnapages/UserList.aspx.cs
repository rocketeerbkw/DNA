using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using BBC.Dna.Page;
using BBC.Dna;
using BBC.Dna.Moderation;
using BBC.Dna.Component;

public partial class UserList : DnaWebPage
{
   /// <summary>
    /// </summary>
    public UserList()
    {
        UseDotNetRendering = false;
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "USERLIST"; }
    }

    /// <summary>
    /// OnPageLoad override function which simply adds a new Signal component to the page
    /// </summary>
    public override void OnPageLoad()
    {

        AddComponent(new MemberList(_basePage));
    }

    /// <summary>
    /// Check to see if we need to update anything on the outcome of the components process request.
    /// </summary>
    public override void OnPostProcessRequest()
    {

    }


    public override bool IsHtmlCachingEnabled()
    {
        return false;
    }

    public override int GetHtmlCachingTime()
    {
        return 0;
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }
}
