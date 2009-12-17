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

        // Set the VirtualUrl item in the context to the page name. This is done to get round the problems
        // with post backs
        /*Context.Items["VirtualUrl"] = "SiteManager";

        // Check to see if the user has permissions for this page
        if (!IsDnaUserAllowed() || !ViewingUser.IsSuperUser)
        {
            // Hide the UI
            foreach (Control control in form1.Controls)
            {
                control.Visible = false;
            }

            // Tell the user.
            if (ViewingUser.UserID != 0 && ViewingUser.UserLoggedIn)
            {
                DisplayErrorMessage("You are not logged into site " + CurrentSite.SiteName);
            }
            else
            {
                DisplayErrorMessage("You are not authorised to view this page");
            }

            return;
        }

        DisplayErrorMessage("");*/
    }

/*
    protected void bnCreate_Click(object sender, EventArgs e)
    {
        try
        {
            if (tbUrlName.Text.Length < 1 || tbDescription.Text.Length < 1 || tbShortName.Text.Length < 1)
            {
                DisplayErrorMessage("You must provide a URL Name, Short Name and Description");
                return;
            }

            ISite site = GetSite(tbUrlName.Text);
            if (site != null)
            {
                DisplayErrorMessage("The site " + tbUrlName.Text + " already exists");
                return;
            }

            string siteConfig = ""; // Assume no site config in the default case
            string defaultSkin = tbDefaultSkin.Text;
            string skinSet = tbSkinSet.Text;
            string siteType = ddSiteType.SelectedValue;
			bool bCommentsSite = false, bMessageboardSite = false, bBlogSite = false;
            switch (ddSiteType.SelectedValue)
            {
                case "Messageboard":
                    siteConfig = GetMessageboardSiteConfig(tbUrlName.Text);
                    bMessageboardSite = true;
                    break;
                case "Comments":
                    siteConfig = GetCommentsSiteConfig(tbUrlName.Text);
                    // The current commenting sites have "boards" set as their default, with the
                    // "acs" skin added as an extra skin.  This gives the commenting sites a bit more
                    // functionality, but is really a hack.  The "acs" skin needs developing to have all
                    // the functionality that comments need, and commenting sites should only have the 
                    // "acs" skin assigned to them
                    bCommentsSite = true;
                    break;
				case "Blog":
                    siteConfig = GetBlogSiteConfig(tbUrlName.Text);
					bBlogSite = true;
					break;
            }

            int premoderationValue = 0, unmoderatedValue = 1;   // Default to Unmoderated
            switch (ddModerationType.SelectedValue)
            {
                case "Post moderated": premoderationValue = 0; unmoderatedValue = 0; break;
                case "Premoderated"  : premoderationValue = 1; unmoderatedValue = 0; break;
            }

            int threadOrder = 1;
            if (ddThreadSortOrder.SelectedValue.Equals("createdate"))
            {
                threadOrder = 2;
            }

            string ssoService = tbSsoService.Text;
            if (ssoService.Length < 1)
            {
                ssoService = tbUrlName.Text;  // Default to URL name, if no SSO service is specified
            }

            int siteId = 0;
            using (IDnaDataReader reader = _basePage.CreateDnaDataReader("createnewsite"))
            {
                reader.AddParameter("urlname", tbUrlName.Text);
                reader.AddParameter("shortname", tbShortName.Text);
                reader.AddParameter("description", tbDescription.Text);

                reader.AddParameter("defaultskin", defaultSkin);
                reader.AddParameter("skindescription", defaultSkin);
                reader.AddParameter("skinset", skinSet);
                reader.AddParameter("useframes", GetYesNoValue(ddUseFrames));

                reader.AddParameter("premoderation", premoderationValue);
                reader.AddParameter("noautoswitch", GetYesNoValue(ddPreventCrossLinking));
                reader.AddParameter("customterms", GetYesNoValue(ddCustomTerms));

                reader.AddParameter("moderatorsemail", tbModeratorsEmail.Text);
                reader.AddParameter("editorsemail", tbEditorsEmail.Text);
                reader.AddParameter("feedbackemail", tbFeedbackEmail.Text);

                reader.AddParameter("automessageuserid", GetIntValue(tbAutoMessageUserId.Text, "Auto Message User ID"));
                reader.AddParameter("passworded", GetYesNoValue(ddRequirePassword));
                reader.AddParameter("unmoderated", unmoderatedValue);
                reader.AddParameter("articleforumstyle", GetYesNoValue(ddArticleGuestBook));
                reader.AddParameter("threadorder", threadOrder);
                reader.AddParameter("threadedittimelimit", GetIntValue(tbThreadEditTimeLimit.Text,"Thread Edit Time Limit"));

                reader.AddParameter("eventemailsubject", tbAlertEmailSubject.Text);
                reader.AddParameter("eventalertmessageuserid", GetIntValue(tbEventAlertMessageUserId.Text,"Event Alert Message User ID"));

                reader.AddParameter("includecrumbtrail", GetYesNoValue(ddIncludeCrumbtrail));
                reader.AddParameter("allowpostcodesinsearch", GetYesNoValue(ddAlowPostCodesInSearch));

                reader.AddParameter("ssoservice", ssoService);

                reader.Execute();
                reader.Read();
                siteId = reader.GetInt32("SiteID");
            }

            if (siteId == 0)
            {
                DisplayErrorMessage("Site creation failed.  Please check the server logs");
                return;
            }

            if (bCommentsSite)
            {
                // Add the "acs" skin to the site, for Comments sites.
                using (IDnaDataReader reader = _basePage.CreateDnaDataReader("addskintosite"))
                {
                    reader.AddParameter("siteid", siteId);
                    reader.AddParameter("skinname", "acs");
                    reader.AddParameter("description", "acs");
                    reader.AddParameter("useframes", GetYesNoValue(ddUseFrames));
                    reader.Execute();
                }
            }

			//if (bBlogSite)
			//{
				// Add the vanilla skin
			//	AddSkinToSite(siteId, "vanilla");
			//	AddSkinToSite(siteId, "vanilla-json");
			// }

            if (bCommentsSite || bMessageboardSite || bBlogSite)
            {
                using (IDnaDataReader reader = _basePage.CreateDnaDataReader("updatesiteconfig"))
                {
                    reader.AddParameter("siteid", siteId);
                    reader.AddParameter("config", siteConfig);
                    reader.Execute();
                }
            }
            else
            {
                AppContext.TheAppContext.SendSignal("action=new-skin&skinname=" + tbUrlName.Text);
            }

            AppContext.TheAppContext.SendSignal("action=recache-site");

            DisplayMessage("Site " + tbUrlName.Text + " has been created");
        }
        catch (FormatException ex)
        {
            
        }
    }
*/

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
       /* switch (ddSiteType.SelectedValue)
        {
            case "Messageboard":
                tbDefaultSkin.Text = "default";
                tbSkinSet.Text = "boards";
                break;
            case "Comments":
                tbSkinSet.Text = "boards";
                tbDefaultSkin.Text = "default";
                break;
            case "Blog":
                tbSkinSet.Text = "boards";
                tbDefaultSkin.Text = "default";
                break;
            default:
                tbSkinSet.Text = "";
                tbDefaultSkin.Text = "default";
                break;
        }    */    
    }
}
