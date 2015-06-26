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
using BBC.Dna;
using BBC.Dna.Component;

public partial class ServerTooBusyPage : BBC.Dna.Page.DnaWebPage
{
    public ServerTooBusyPage()
    {
        //Allow page to be rendered
        UseDotNetRendering = false;

        //Dont create viewing user.
        _basePage.IsRequestAnonymous = true;
    }

    public override string PageType
    {
        get { return "SERVERTOOBUSY"; }
    }

    public override bool IsHtmlCachingEnabled()
    {
        //Always cache.
        return true;
    }

    public override int GetHtmlCachingTime()
    {
        //Cache for 1 day.
        return 24*60*60;
    }

    public override void OnPageLoad()
    {
       //Do Nothing
    }
}

