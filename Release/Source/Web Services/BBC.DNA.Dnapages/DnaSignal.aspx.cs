using System;
using System.Data;
using System.Drawing;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using BBC.Dna.Component;

public partial class DnaSignal : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default Dna Signal page constructor
    /// </summary>
    public DnaSignal()
    {
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "DNASIGNAL"; }
    }

    /// <summary>
    /// OnPageLoad override function which simply adds a new Signal component to the page
    /// </summary>
    public override void OnPageLoad()
    {
        // Simply add a new signal component to the page
        AddComponent(new Signal(_basePage));
    }
}
