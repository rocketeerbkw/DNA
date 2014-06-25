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
using BBC.Dna.Page;
using BBC.Dna.Utils;
using BBC.Dna.Common;
using System.Reflection;
using System.IO;
using System.Text;

public partial class status : DnaWebPage
{
    public status()
    {
        UseDotNetRendering = true;
    }

    protected Label lblHostName;
    protected Table tblStats;
    
    /// <summary>
	/// General page handling
	/// </summary>
	public override void OnPageLoad()
	{
        int interval = 60;
        if (!Int32.TryParse(Request.QueryString["interval"], out interval))
        {
            interval = 60;
        }

        if (Request.QueryString["reset"] == "1")
        {
            Statistics.ResetCounters();
        }

        StatusUI statusUI = new StatusUI();
        statusUI.AddFileinfo(ref lbFileInfo);

        if (Request.QueryString["skin"] == "purexml")
        {
            statusUI.OutputXML(interval, this, _basePage.Diagnostics);
        }
        else
        {
            statusUI.OutputHTML(interval, ref lblHostName, _basePage.CurrentServerName, ref tblStats);
        }
	}

	/// <summary>
	/// PageType: Status
	/// </summary>
	public override string PageType
	{
		get { return "STATUSPAGE"; }
	}
}
