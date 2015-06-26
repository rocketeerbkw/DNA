using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Users;
using BBC.Dna.Sites;

namespace BBC.DNA.Dnapages
{
    public partial class WelcomePage : DnaWebPage
    {
        private WelcomePageBuilder welcomePageBuilder = null;

        public override string PageType
        {
            get { return "WELCOME"; }
        }

        public override void OnPageLoad()
        {
            welcomePageBuilder = new WelcomePageBuilder(_basePage);
            welcomePageBuilder.ProcessRequest();
            if (welcomePageBuilder.IsNativeRenderRequest)
            {
                UseDotNetRendering = true;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            RenderASPXPage(welcomePageBuilder);
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
            get { return DnaBasePage.UserTypes.Any; }
        }

        public override bool MustBeSecure
        {
            get { return true; }
        }

        private void RenderASPXPage(WelcomePageBuilder welcomePageBuilder)
        {
            SiteDescription.Text = welcomePageBuilder.CurrentSiteDescription;
            SiteID.Text = welcomePageBuilder.CurrentSiteID.ToString();
            SiteURLName.Text = welcomePageBuilder.CurrentSiteUrlName;

            if (welcomePageBuilder.UserLoggedIn)
            {
                RenderLoggedInUserDetails();

                RenderSuperUserDetails();

                RenderEditorOfSitesDetails();
            }
            else
            {
                HideUserControls();
            }
        }

        private void HideUserControls()
        {
            UserLoginName.Visible = false;
            UserDisplayName.Visible = false;
            UserID.Visible = false;
        }

        private void RenderLoggedInUserDetails()
        {
            UserLoginName.Text = welcomePageBuilder.UserLoginName;
            UserDisplayName.Text = welcomePageBuilder.DNAUserDisplayName;
            UserID.Text = welcomePageBuilder.DNAUserID.ToString();
        }

        private void RenderEditorOfSitesDetails()
        {
            if (welcomePageBuilder.EditorOfSitesList != null && welcomePageBuilder.EditorOfSitesList.Count > 0)
            {
                Control editorsitelist = form2.FindControl("EditorSiteList");
                Label label = new Label();
                label.Text = "Editor of the following sites...<br />";
                editorsitelist.Controls.Add(label);

                Table tableOfSites = new Table();
                tableOfSites.BorderStyle = BorderStyle.Solid;
                tableOfSites.GridLines = GridLines.Both;
                tableOfSites.CellPadding = 2;
                TableHeaderRow header = new TableHeaderRow();
                string[] cellTitles = "Site ID,URL Name,Description".Split(',');
                foreach (string title in cellTitles)
                {
                    TableCell headerCell = new TableCell();
                    headerCell.Text = title;
                    headerCell.Font.Bold = true;
                    header.Cells.Add(headerCell);
                }
                tableOfSites.Rows.Add(header);
                editorsitelist.Controls.Add(tableOfSites);

                foreach (ISite site in welcomePageBuilder.EditorOfSitesList)
                {
                    TableRow row = new TableRow();

                    TableCell id = new TableCell();
                    id.Text = site.SiteID.ToString();

                    TableCell sitename = new TableCell();
                    sitename.Text = site.SiteName;

                    TableCell urlName = new TableCell();
                    urlName.Text = site.Description;

                    row.Cells.Add(id);
                    row.Cells.Add(sitename);
                    row.Cells.Add(urlName);

                    tableOfSites.Rows.Add(row);
                }
            }
        }

        private void RenderSuperUserDetails()
        {
            if (welcomePageBuilder.IsSuperUser)
            {
                Label label = new Label();
                label.Text = "Super User status. Editor of all sites.";
                Control superstatus = form2.FindControl("SuperUserStatus");
                superstatus.Controls.Add(label);
            }
        }
    }
}
