using System;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna.Component;

public partial class BannedEmailsPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public BannedEmailsPage()
    {
        UseDotNetRendering = true;
        SetDnaXmlDataSource = true;
    }

    public override string PageType
    {
        get { return "BANNEDEMAILS"; }
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // See if we're wanting .net rendering?
        Context.Items["VirtualUrl"] = "BannedEmails";

        if (!_basePage.ViewingUser.IsSuperUser)
        {
            return;
        }

        // Only update the aspx controls if we're using .net rendering
        if (UseDotNetRendering)
        {
            // Add the control ids to the xml source control ids list to indicate that they require
            // the final wholepage xml to be their datasource
            DnaXmlDataSourceContolIDs.Add(new DnaXmlSourceDetails("BannedEmailsList", "H2G2/BANNEDEMAILS/BANNEDEMAILLIST")); // Demonstrates using the root node
            DnaXmlDataSourceContolIDs.Add(new DnaXmlSourceDetails("NavigationTop", "H2G2/BANNEDEMAILS")); // Demonstrates using the root node
            DnaXmlDataSourceContolIDs.Add(new DnaXmlSourceDetails("NavigationBottom", "H2G2/BANNEDEMAILS")); // Demonstrates using the root node
        }

        // Now create the comment forum list object
        AddComponent(new BannedEmailsPageBuilder(_basePage));
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.ModeratorAndAbove; }
    }
}
