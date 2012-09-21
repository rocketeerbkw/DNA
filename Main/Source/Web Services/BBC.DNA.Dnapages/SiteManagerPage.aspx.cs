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
using System.Collections.Generic;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Data;

public partial class SiteManagerPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// The default constructor
    /// </summary>
    public SiteManagerPage()
    {
        UseDotNetRendering = false;
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "SITEMANAGER"; }
    }

    /// <summary>
    /// Allowed Editors property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }

    /// <summary>
    /// OnPageLoad method 
    /// </summary>
    public override void OnPageLoad()
    {
        AddComponent(new SiteManager(_basePage));
        AddComponent(new ModerationClasses(_basePage));
    }

	private void AddSkinToSite(int siteId, string skinName)
	{
		using (IDnaDataReader reader = _basePage.CreateDnaDataReader("addskintosite"))
		{
			reader.AddParameter("siteid", siteId);
			reader.AddParameter("skinname", skinName);
			reader.AddParameter("description", skinName);
			reader.AddParameter("useframes", 0);
			reader.Execute();
		}
	}

    private int GetIntValue(string s,string cntrlName)
    {
        int res;
        if (int.TryParse(s, out res))
        {
            return res;
        }

        throw new FormatException("The value of " + cntrlName + " should be a number.  It's currently "+s);
    }

    private int GetYesNoValue(DropDownList ddl)
    {
        if (ddl.SelectedValue.Equals("yes", StringComparison.OrdinalIgnoreCase))
        {
            return 1;
        }
        return 0;
    }

    protected void ddSiteType_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
}
