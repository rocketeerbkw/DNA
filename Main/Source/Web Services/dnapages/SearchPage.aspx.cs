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

public partial class SearchPage : BBC.Dna.Page.DnaWebPage
{
    public SearchPage()
    {
        UseDotNetRendering = false;
    }

    public override string PageType
    {
        get { return "NEWSEARCH"; }
    }

    public override bool IsHtmlCachingEnabled()
    {
        return GetSiteOptionValueBool("cache", "HTMLCaching");
    }

    public override int GetHtmlCachingTime()
    {
        return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
    }

    public override void OnPageLoad()
    {
        AddComponent(new Search(_basePage));
    }
}
