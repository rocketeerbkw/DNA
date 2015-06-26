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
using System.Xml;
using System.Drawing;
using System.Globalization;

using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Moderation;


public partial class ArticleHistoryPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Constructor for the Article History Page
    /// </summary>
    public ArticleHistoryPage()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type for this page
    /// </summary>
    public override string PageType
    {
        get { return "ARTICLEHISTORY"; }
    }

    /// <summary>
    /// A page just for the editors and better
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.Any;
        }
    }

    /// <summary>
    /// Setup the page and initialise some of the controls
    /// </summary>
    /// <param name="e"></param>
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
    }

    /// <summary>
    /// Overridden OnPageLoad Event just checks that the user is allowed to view the page if not hide
    /// the controls and post the error message
    /// </summary>
    public override void OnPageLoad()
    {
        Context.Items["VirtualUrl"] = "ArticleHistory";
        if (!IsDnaUserAllowed())
        {
            ShowHideControls(false);
            lblError.Text = "Insufficient permissions - Editor Status Required";
            return;
        }

        int h2g2ID = Request.GetParamIntOrZero("entryno", "H2G2 ID of the article");

        if (h2g2ID != 0)
        {
            txtEntry.Text = h2g2ID.ToString();
        }

        GetArticleHistory();

        ShowHideControls(true);
    }

    /// <summary>
    /// The action fire when the search button is pressed.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Search_Click(object sender, EventArgs e)
    {
        GetArticleHistory();
    }

    /// <summary>
    /// Hides or shows the controls on the page
    /// </summary>
    /// <param name="show"></param>
    private void ShowHideControls(bool show)
    {
        //Reset any previous error text.
        lblError.Text = "";

        if (show)
        {
            Search.Visible = true;
            txtEntry.Visible = true;
            lblSearchParams.Visible = true;
            Count.Visible = true;

            if (tblResults.Rows.Count > 0)
            {
                //Show Controls that rely on results.
                lblArticleSubject.Visible = true;
            }
            else
            {
                //Hide Controls that rely on results.
                lblArticleSubject.Visible = false;
            }
        }
        else
        {
            //Hide all controls.
            Search.Visible = false;
            txtEntry.Visible = false;
            lblSearchParams.Visible = false;
            Count.Visible = false;
        }
    }
    /// <summary>
    /// Function that is always called to recreate the table
    /// </summary>
    private void GetArticleHistory()
    {
        tblResults.Rows.Clear();
        lblEntryError.Text = String.Empty;
        Count.Text = String.Empty;
        int count = 0;
        if (txtEntry.Text != String.Empty)
        {
            int h2g2ID = 0;
            if (!Int32.TryParse(txtEntry.Text, out h2g2ID))
            {
                lblEntryError.Text = "Please enter a valid H2G2 ID";
                return;
            }
            int entryID = h2g2ID / 10;
            ArticleHistory articleHistory = new ArticleHistory(_basePage);
            articleHistory.GetArticleHistoryXml(entryID);

            TableHeaderRow headerRow = new TableHeaderRow();
            headerRow.BackColor = Color.MistyRose;

            int accountCount = 0;
            foreach (XmlNode node in articleHistory.RootElement.SelectNodes(@"ARTICLEHISTORY/ITEMS/ITEM"))
            {
                TableRow row = new TableRow();
                foreach (XmlNode data in node.ChildNodes)
                {
                    TableCell dataCell = new TableCell();

                    if (data.LocalName == "USERID")
                    {
                        if (count == 0)
                        {
                            AddHeaderCell(headerRow, "User ID");
                        }

                        dataCell.HorizontalAlign = HorizontalAlign.Center;

                        string userIDText = data.InnerText;
                        dataCell.Text = userIDText;
                        accountCount++;

                        if (accountCount % 2 == 0)
                            row.BackColor = Color.LightGray;
                        else
                            row.BackColor = Color.Linen;

                        HyperLink link = new HyperLink();
                        link.NavigateUrl = "/dna/moderation/MemberDetails?userid=" + userIDText;
                        link.Text = "U" + userIDText;
                        dataCell.Controls.Add(link);
                        row.Cells.Add(dataCell);
                    }
                    else if (data.LocalName == "ACTION")
                    {
                        if (count == 0)
                        {
                            AddHeaderCell(headerRow, "Action");
                        }
                        dataCell.HorizontalAlign = HorizontalAlign.Center;
                        dataCell.Text = GetActionText(data.InnerText);
                        row.Cells.Add(dataCell);
                    }
                    else if (data.LocalName == "DATEPERFORMED")
                    {
                        if (count == 0)
                        {
                            AddHeaderCell(headerRow, "Date Performed");
                        }

                        dataCell.HorizontalAlign = HorizontalAlign.Center;

                        DateTime date = new DateTime();
                        string sortDate = String.Empty;

                        if (data.SelectSingleNode("DATE/@SORT") != null)
                        {
                            DateTimeFormatInfo UKDTFI = new CultureInfo("en-GB", false).DateTimeFormat;

                            sortDate = data.SelectSingleNode("DATE/@SORT").InnerText;
                            DateTime.TryParseExact(sortDate, "yyyyMMddHHmmss", UKDTFI, DateTimeStyles.NoCurrentDateDefault, out date);
                            dataCell.Text = date.ToString();
                        }
                        else
                        {
                            dataCell.Text = "";
                        }
                        row.Cells.Add(dataCell);
                    }
                    else if (data.LocalName == "COMMENT")
                    {
                        if (count == 0)
                        {
                            AddHeaderCell(headerRow, "Comments");
                        }
                        dataCell.HorizontalAlign = HorizontalAlign.Center;
                        dataCell.Text = data.InnerText;
                        row.Cells.Add(dataCell);
                    }
                }
                tblResults.Rows.Add(row);
                count++;
            }
            if (count == 0)
            {
                TableRow nodatarow = new TableRow();
                TableCell nodataCell = new TableCell();
                nodataCell.ColumnSpan = 4;
                nodataCell.Text = @"No data for those details";
                nodatarow.Cells.Add(nodataCell);
                tblResults.Rows.Add(nodatarow);
                Count.Text = String.Empty;
            }
            else
            {
                Count.Text = String.Format(@"There are {0} entries.", count.ToString());
            }

            tblResults.Rows.AddAt(0, headerRow);

            tblResults.CellSpacing = 5;
            tblResults.BorderWidth = 2;
            tblResults.BorderStyle = BorderStyle.Outset;
        }
    }

    private string GetActionText(string action)
    {
        string actionText = String.Empty;

        switch (action)
        {
            case "0": actionText = "Null action";
            break;
            case "1": actionText = "Created by user";
            break;
            case "2": actionText = "Created by editor";
            break;
            case "3": actionText = "Modified by user";
            break;
            case "4": actionText = "Modified by editor";
            break;
            case "5": actionText = "Status change by user";
            break;
            case "6": actionText = "Status change by editor";
            break;
            case "7": actionText = "Editor change";
            break;
            case "8": actionText = "Accepted for editing";
            break;
            case "9": actionText = "Rejected";
            break;
            case "10": actionText = "Stamped official";
            break;
            case "11": actionText = "Copied from user entry";
            break;
            case "12": actionText = "Copied version made official";
            break;
            case "13": actionText = "Cancelled by editor";
            break;
            case "14": actionText = "Superceded";
            break;
            default: actionText = "Unknown";
            break;
        }
        return actionText;
    }
    /// <summary>
    /// Generic Function to add a header cell to the table
    /// </summary>
    /// <param name="headerRow">The row that holds the header info</param>
    /// <param name="headerText">Text to display</param>
    private static void AddHeaderCell(TableHeaderRow headerRow, string headerText)
    {
        TableHeaderCell headerNextCell = new TableHeaderCell();
        headerNextCell.Text = headerText;
        headerNextCell.Scope = TableHeaderScope.Column;
        headerRow.Cells.Add(headerNextCell);
    }
}