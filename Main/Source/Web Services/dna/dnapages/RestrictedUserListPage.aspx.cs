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


public partial class RestrictedUserListPage : BBC.Dna.Page.DnaWebPage
{
    private static int _resultsPerPage = 20;
    private int _searchType = 0;
    private int _selectedSiteID = 0;
    private int _skip = 0;
    private int _show = _resultsPerPage;
    private string _letter = "a";

    /// <summary>
    /// Constructor for the Restricted Users Page
    /// </summary>
    public RestrictedUserListPage()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type for this page
    /// </summary>
    public override string PageType
    {
        get { return "RESTRICTEDUSERLIST"; }
    }

    /// <summary>
    /// A page just for the editors and better
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }

    /// <summary>
    /// Setup the page and initialise some of the controls
    /// </summary>
    /// <param name="e"></param>
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        UserStatusTypes.SelectedIndex = 0;
    }

    /// <summary>
    /// Overridden OnPageLoad Event just checks that the user is allowed to view the page if not hide
    /// the controls and post the error message
    /// </summary>
    public override void OnPageLoad()
    {
        Context.Items["VirtualUrl"] = "RestrictedUsers";
        if (!IsDnaUserAllowed())
        {
            lblError.Visible = true;
            ShowHideControls(false);
            lblError.Text = "Insufficient permissions - Editor Status Required";
            return;
        }
        else
        {
            ShowHideControls(true);
        }

        // Add the default search term into the viewstate if doesn't already exist
        if (ViewState["searchterm"] == null)
        {
            ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        }
        // Add the default selected site id into the viewstate if doesn't already exist
        if (ViewState["selectedsiteid"] == null)
        {
            ViewState.Add("selectedsiteid", 0);
        }
        // Now display all the restricted users. First check to make sure we're not in a postback
        if (!Page.IsPostBack)
        {
            LoadSiteListDropDown();
            CalculateSearchTerm();
            GetRestrictedUserList();
        }
    }
    /// <summary>
    /// The action fired when the SiteList drop down is changed.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void SiteList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState.Add("selectedsiteid", SiteList.SelectedValue);
        ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        CalculateSearchTerm();
        GetRestrictedUserList();
    }

    /// <summary>
    /// Fired when the UserStatusTypes dropdown is changed 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void UserStatusTypes_SelectedIndexChanged(object sender, EventArgs e)
    {
        UserStatusTypesValue = UserStatusTypes.SelectedItem.Value;
        ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        CalculateSearchTerm();
        GetRestrictedUserList();
    }

    /// <summary>
    /// Hides or shows the controls on the page
    /// </summary>
    /// <param name="show">Whether to show or hide the user status dropdown</param>
    private void ShowHideControls(bool show)
    {
        UserStatusTypes.Visible = show;
        btnA.Visible = show;
        btnB.Visible = show;
        btnC.Visible = show;
        btnD.Visible = show;
        btnE.Visible = show;
        btnF.Visible = show;
        btnG.Visible = show;
        btnH.Visible = show;
        btnI.Visible = show;
        btnJ.Visible = show;
        btnK.Visible = show;
        btnL.Visible = show;
        btnM.Visible = show;
        btnN.Visible = show;
        btnO.Visible = show;
        btnP.Visible = show;
        btnQ.Visible = show;
        btnR.Visible = show;
        btnS.Visible = show;
        btnT.Visible = show;
        btnU.Visible = show;
        btnV.Visible = show;
        btnW.Visible = show;
        btnX.Visible = show;
        btnY.Visible = show;
        btnZ.Visible = show;
        btnAll.Visible = show;
        btnMostRecent.Visible = show;
        btnFirst.Visible = show;
        btnPrevious.Visible = show;
        lbPage.Visible = show;
        btnNext.Visible = show;
        btnLast.Visible = show;
        btnFirst2.Visible = show;
        btnPrevious2.Visible = show;
        lbPage2.Visible = show;
        btnNext2.Visible = show;
        btnLast2.Visible = show;
        //Count.Visible = show;
        //lbTotalResults.Visible = show;
        CountAndTotal.Visible = show;
        SiteList.Visible = show;
        Site.Visible = show;
        Status.Visible = show;
    }

    /// <summary>
    /// Function that is always called to recreate the table
    /// </summary>
    private void GetRestrictedUserList()
    {
        tblResults.Rows.Clear();

        int siteID = 0;
        int userStatusTypes = 0;

        userStatusTypes = GetUserStatusTypes();

        siteID = GetSiteID();

        // Get the emails based on the search term
        if (_letter.CompareTo("All") == 0)
        {
            _letter = "";
        }

        RestrictedUserList restrictedUserList = new RestrictedUserList(_basePage);
        restrictedUserList.CreateRestrictedUserList(siteID, _skip, _show, userStatusTypes, _searchType, _letter);
               
        string orderedBy = "by most recent";
        if (_searchType == 1)
        {
            if (_letter == "")
            {
                orderedBy = "alphabetically";
            }
            else
            {
                orderedBy = "by the letter " + _letter.ToUpper();
            }
        }

        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int previousUserID = 0;
        int accountCount = 0;

        foreach (XmlNode node in restrictedUserList.RootElement.SelectNodes(@"RESTRICTEDUSER-LIST/USERACCOUNTS/USERACCOUNT"))
        {
            if (count == 0)
            {
                TableHeaderCell headerFirstCell = new TableHeaderCell();
                headerFirstCell.Text = "User ID";
                headerFirstCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerFirstCell);
            }

            TableRow row = new TableRow();

            TableCell firstCell = new TableCell();
            firstCell.HorizontalAlign = HorizontalAlign.Center;

            string userIDText = node.SelectSingleNode(@"@USERID").InnerText;
            firstCell.Text = userIDText;
            int currentUserID = Convert.ToInt32(userIDText);
            if (currentUserID != previousUserID)
            {
                accountCount++;
                previousUserID = currentUserID;
            }

            if (accountCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            HyperLink link = new HyperLink();
            link.NavigateUrl = "MemberDetailsAdmin?userid=" + userIDText;
            link.Text = "U" + userIDText;

            firstCell.Controls.Add(link);

            row.Cells.Add(firstCell);

            foreach (XmlNode data in node.ChildNodes)
            {
                TableCell nextCell = new TableCell();

                if (data.LocalName == "PREFSTATUS")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, "STATUS");
                    }

                    HtmlImage img = new HtmlImage();
                    string path = @"/dnaimages/moderation/images/icons/status" + data.InnerText + ".gif";
                    img.Src = path;

                    nextCell.HorizontalAlign = HorizontalAlign.Center;
                    nextCell.Controls.Add(img);
                    row.Cells.Add(nextCell);
                }
                else if (data.LocalName == "SITEID")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, "SITEID");
                    }
                    nextCell.HorizontalAlign = HorizontalAlign.Center;
                    nextCell.Text = data.InnerText;
                    row.Cells.Add(nextCell);
                }
                else if (data.LocalName == "PREFSTATUSCHANGEDDATE")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, "CHANGEDDATE");
                    }

                    nextCell.HorizontalAlign = HorizontalAlign.Center;

                    DateTime date = new DateTime();
                    string sortDate = String.Empty;

                    if (data.SelectSingleNode("DATE/@SORT") != null)
                    {
                        DateTimeFormatInfo UKDTFI = new CultureInfo("en-GB", false).DateTimeFormat;

                        sortDate = data.SelectSingleNode("DATE/@SORT").InnerText;
                        DateTime.TryParseExact(sortDate, "yyyyMMddHHmmss", UKDTFI, DateTimeStyles.NoCurrentDateDefault, out date);
                        nextCell.Text = date.ToString();
                    }
                    else
                    {
                        nextCell.Text = "";
                    }
                    row.Cells.Add(nextCell);
                }
                else if (data.LocalName == "PREFSTATUSDURATION")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, "DURATION");
                    }
                    nextCell.HorizontalAlign = HorizontalAlign.Center;
                    nextCell.Text = GetPrefStatusDurationDisplayText(data.InnerText);
                    row.Cells.Add(nextCell);
                }
                else if (data.LocalName == "SHORTNAME")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, "SITE");
                    }
                    nextCell.HorizontalAlign = HorizontalAlign.Center;
                    nextCell.Text = data.InnerText;
                    row.Cells.Add(nextCell);
                }
                else if (data.LocalName != "USERSTATUSDESCRIPTION" &&
                    data.LocalName != "URLNAME")
                {
                    if (count == 0)
                    {
                        AddHeaderCell(headerRow, data.LocalName);
                    }

                    nextCell.HorizontalAlign = HorizontalAlign.Center;
                    nextCell.Text = data.InnerText;
                    row.Cells.Add(nextCell);
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
            Count.Text = "";
        }
        else
        {
            Count.Text = count.ToString();
        }

        tblResults.Rows.AddAt(0, headerRow);

        tblResults.CellSpacing = 5;
        tblResults.BorderWidth = 2;
        tblResults.BorderStyle = BorderStyle.Outset;


        // Update the paging controls
        int currentPage = ((_skip + 1) / _show) + 1;
        int totalPages = 1;
        int totalUsers = restrictedUserList.TotalUsers;

        if (totalUsers > 0)
        {
            // Set the total matches for this search
            lbTotalResults.Text = totalUsers.ToString();
            CountAndTotal.Text = String.Format(@"Here are {0} of {1} total entries ", count.ToString(), totalUsers.ToString());
            CountAndTotal.Visible = true;

            totalPages = (int)Math.Ceiling((double)totalUsers / (double)_show);
        }
        else
        {
            CountAndTotal.Text = "";
            CountAndTotal.Visible = false;
        }

        btnFirst.Enabled = (_skip > 0);
        btnPrevious.Enabled = (_skip > 0);
        btnNext.Enabled = ((_skip + _show) < totalUsers);
        btnLast.Enabled = ((_skip + _show) < totalUsers);
        lbPage.Text = "Page " + currentPage + " of " + totalPages;

        btnFirst2.Enabled = (_skip > 0);
        btnPrevious2.Enabled = (_skip > 0);
        btnNext2.Enabled = ((_skip + _show) < totalUsers);
        btnLast2.Enabled = ((_skip + _show) < totalUsers);
        lbPage2.Text = "Page " + currentPage + " of " + totalPages;
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

    /// <summary>
    /// Gets the User Status Description selected in the dropdown
    /// </summary>
    private void SetUserStatusDescription()
    {
        UserStatusTypes.SelectedItem.Value = UserStatusTypesValue;
    }

    /// <summary>
    /// Gets the Site ID from the selected item in the drop down
    /// </summary>
    /// <returns>The selected Site ID</returns>
    private int GetSiteID()
    {
        int selectedSiteID=0;
        Int32.TryParse(SiteList.SelectedValue, out selectedSiteID);
        _selectedSiteID = selectedSiteID;
        return selectedSiteID;
    }

    /// <summary>
    /// Gets the UserStatus number from it's description
    /// </summary>
    /// <returns>The user status corresponding to the description</returns>
    private int GetUserStatusTypes()
    {
        if (UserStatusTypes.Text == "Premoderated")
        {
            return 1;
        }
        else if (UserStatusTypes.Text == "Restricted")
        {
            return 4;
        }
        else //Both
        {
            return 0;
        }
    }

    /// <summary>
    /// Returns the text to display for a given duration in seconds
    /// </summary>
    /// <param name="prefStatusDuration">The pref status duration value text</param>
    /// <returns>The associated pref status duration</returns>
    private static string GetPrefStatusDurationDisplayText(string prefStatusDuration)
    {
        string newPrefStatusValue = String.Empty;

        switch (prefStatusDuration)
        {
            case "1440":
                newPrefStatusValue = @"1 day";
                break;
            case "10080":
                newPrefStatusValue = @"1 week";
                break;
            case "20160":
                newPrefStatusValue = @"2 weeks";
                break;
            case "40320":
                newPrefStatusValue = @"1 month";
                break;
            default:
                newPrefStatusValue = @"no limit";
                break;
        }
        return newPrefStatusValue;
    }

    /// <summary>
    /// Accessor for UserStatusTypes Value in the view state
    /// </summary>
    public string UserStatusTypesValue
    {
        get
        {
            string result = "Standard";
            object v = ViewState["UserStatusTypes"];

            if (v != null)
            {
                result = (string)v;
            }

            return result;
        }

        set
        {
            ViewState["UserStatusTypes"] = value;
        }
    }


    /// <summary>
    /// Handles the search by letter button clicks
    /// </summary>
    /// <param name="sender">The object that fired the event</param>
    /// <param name="e">Any arguments </param>
    protected void ViewByLetter(object sender, EventArgs e)
    {
        // Set the search term to look at the first set of results for the search letter
        Button letter = (Button)sender;
        ViewState.Add("searchterm", "byletter:0:" + _show.ToString() + ":" + letter.ID.Substring(3));
        CalculateSearchTerm();
        GetRestrictedUserList();
    }

    /// <summary>
    /// Handles the search by most recent button click. When clicked the page will show page one of the most recent emails.
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void ViewMostRecent(object sender, EventArgs e)
    {
        // Just set the search term to look at the first set of most recent emails
        ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        CalculateSearchTerm();
        GetRestrictedUserList();
    }

    /// <summary>
    /// Handles the show firstpage button click. When clicked, the user is shown page one of the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void ShowFirst(object sender, EventArgs e)
    {
        // Get the last search term
        CalculateSearchTerm();

        // Set the skip and show to display the first page of results
        _skip = 0;
        _show = _resultsPerPage;

        // Now set the current search term
        SetNewSearchTerm();

        // Display the results
        GetRestrictedUserList();
    }

    /// <summary>
    /// Handles the show previous page button click. When clicked, the user is shown the previous page of results for the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void ShowPrevious(object sender, EventArgs e)
    {
        // Get the last search term
        CalculateSearchTerm();

        // Calculate the new skip and show values
        _skip -= _show;
        if (_skip < 0)
        {
            _skip = 0;
        }

        // Now set the current search term
        SetNewSearchTerm();

        // Display the results
        GetRestrictedUserList();
    }

    /// <summary>
    /// Handles the show next page button click. When clicked, the user is shown the next page for the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void ShowNext(object sender, EventArgs e)
    {
        // Get the last search term
        CalculateSearchTerm();

        // Calculate the new skip and show values
        _skip += _show;
        int previousTotal = Convert.ToInt32(lbTotalResults.Text);
        if (_skip > previousTotal)
        {
            _skip -= _show;
        }

        // Now set the current search term
        SetNewSearchTerm();

        // Display the results
        GetRestrictedUserList();
    }

    /// <summary>
    /// Handles the show lastpage button click. When clicked, the user is shown page one of the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void ShowLast(object sender, EventArgs e)
    {
        // Get the last search term
        CalculateSearchTerm();

        // Calculate the new skip and show values
        int previousTotal = Convert.ToInt32(lbTotalResults.Text);
        _skip = (previousTotal / _show) * _show;
        if (_skip == previousTotal)
        {
            _skip -= _show;
        }

        // Now set the current search term
        SetNewSearchTerm();

        // Display the results
        GetRestrictedUserList();
    }

    /// <summary>
    /// Creates the new search term from the calculated values
    /// </summary>
    private void SetNewSearchTerm()
    {
        // Make a note of which type of search we're doing
        if (_searchType == 0)
        {
            ViewState.Add("searchterm", "mostrecent:" + _skip.ToString() + ":" + _show.ToString());
        }
        else if (_searchType == 1)
        {
            ViewState.Add("searchterm", "byletter:" + _skip.ToString() + ":" + _show.ToString() + ":" + _letter);
        }
        ViewState.Add("selectedsiteid", _selectedSiteID);
    }

    /// <summary>
    /// Calculates the search term from the searchterm label
    /// </summary>
    private void CalculateSearchTerm()
    {
        // Get the search terms from the search term lable
        string searchTerm = (string)ViewState["searchterm"];
        string[] searchTerms = searchTerm.Split(new char[] { ':' });
        _searchType = 0;
        _skip = 0;
        _show = _resultsPerPage;
        _letter = "a";
        Int32.TryParse(ViewState["selectedsiteid"].ToString(), out _selectedSiteID);

        // Check to make sure we've got a valid search term
        if (searchTerms.Length >= 3)
        {
            if (searchTerms[0].CompareTo("mostrecent") == 0)
            {
                _searchType = 0;
            }
            else if (searchTerms[0].CompareTo("byletter") == 0)
            {
                _searchType = 1;
            }
            _skip = Convert.ToInt32(searchTerms[1]);
            _show = Convert.ToInt32(searchTerms[2]);
            if (searchTerms.Length > 3)
            {
                _letter = searchTerms[3];
            }
            else if (_searchType == 1)
            {
                _searchType = 0;
            }
        }
    }
    /// <summary>
    /// Loads the SiteList drop down
    /// </summary>
    private void LoadSiteListDropDown()
    {
        SiteList.Items.Clear();

        ListItem siteAll = new ListItem(@"All", "0");
        SiteList.Items.Add(siteAll);

        XmlElement editorSitesList = _basePage.ViewingUser.GetSitesThisUserIsEditorOfXML();
        foreach (XmlNode node in editorSitesList.SelectNodes(@"SITE-LIST/SITE"))
        {
            int siteid = 0;
            Int32.TryParse(node.Attributes["ID"].Value, out siteid);
            string sitename = node.SelectSingleNode(@"SHORTNAME").InnerText;
            ListItem site = new ListItem(sitename, siteid.ToString());
            SiteList.Items.Add(site);
        }
        SiteList.SelectedValue = _selectedSiteID.ToString();
    }
}
