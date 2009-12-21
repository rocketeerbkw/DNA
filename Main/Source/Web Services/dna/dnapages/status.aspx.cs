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

public partial class status : DnaWebPage
{
	/// <summary>
	/// General page handling
	/// </summary>
	public override void OnPageLoad()
	{
        AddComponent(new Status(_basePage));
	}

	/// <summary>
	/// PageType: Status
	/// </summary>
	public override string PageType
	{
		get { return "STATUSPAGE"; }
	}

}
