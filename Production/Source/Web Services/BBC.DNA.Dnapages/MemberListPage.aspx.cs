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
using BBC.Dna.Users;


public partial class MemberListPage : BBC.Dna.Page.DnaWebPage
{   
    /// <summary>
    /// Constructor for the Search For Users Page
    /// </summary>
    public MemberListPage()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type for this page
    /// </summary>
    public override string PageType
    {
        get { return "MEMBERLIST"; }
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
        UserStatusDescription.SelectedIndex = 0;
        Duration.Visible = false;
    }

    /// <summary>
    /// Overridden OnPageLoad Event just checks that the user is allowed to view the page if not hide
    /// the controls and post the error message
    /// </summary>
    public override void OnPageLoad()
    {
		Context.Items["VirtualUrl"] = "MemberList";
        if (!IsDnaUserAllowed())
        {
            ShowHideControls(false);
            lblError.Text = "Insufficient permissions - Editor Status Required";
            return;
        }

        int userId = Request.GetParamIntOrZero("userid", "UserId");

        if (userId != 0)
        {
            rdSearchType.SelectedIndex = 0;
            txtEntry.Text = userId.ToString();
        }

        GetMemberList();

        ShowHideControls(true);
    }

    /// <summary>
    /// The action fire when the search button is pressed.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Search_Click(object sender, EventArgs e)
    {
        ClearApplyToAll();
        GetMemberList();
        SetUserStatusDescription();
    }


    /// <summary>
    /// Action event fired when the Apply a
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ApplyResetUserName_Click(object sender, EventArgs e)
    {
        int rowCount = 0;
        CheckBox applyToAll = (CheckBox)tblResults.Rows[0].FindControl("ApplyToAll");
        ArrayList userIDList = new ArrayList();

        foreach (TableRow row in tblResults.Rows)
        {
            if (row.GetType() != typeof(TableHeaderRow))
            {
                CheckBox checkBox = (CheckBox)row.FindControl("Check" + rowCount.ToString());
                if (checkBox.Checked)
                {
                    //Get UserId
                    int userID = 0;
                    Int32.TryParse(row.Cells[1].Text, out userID);

                    //Get SiteId
                    int siteID = 0;
                    Int32.TryParse(row.Cells[2].Text, out siteID);

                    //Get userName
                    String userName = row.Cells[3].Text;

                    try
                    {
                        //Reset Email on selected accounts
                        ModerateNickNames resetNickName = new ModerateNickNames(_basePage);
                        resetNickName.ResetNickName(userName, userID, siteID);
                    }
                    catch (Exception err)
                    {
                        lblError.Text = lblError.Text + err.Message + "\r\n";
                    }
                }
                rowCount++;
            }
        }

        GetMemberList();
        ClearApplyToAll();
    }

    /// <summary>
    /// Action event fired when the Apply a
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ApplyAction_Click(object sender, EventArgs e)
    {
        ApplyActions();
        ClearApplyToAll();
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
            lblSearchBy.Visible = true;
            txtEntry.Visible = true;
            rdSearchType.Visible = true;
            lblSearchParams.Visible = true;
            if (ViewingUser.IsSuperUser)
            {
                ListItem bbcuid = rdSearchType.Items.FindByText("BBCUID");
                bbcuid.Enabled = true;
            }
            else
            {
                ListItem bbcuid = rdSearchType.Items.FindByText("BBCUID");
                bbcuid.Enabled = false;
            }

            if (tblResults.Rows.Count > 0)
            {
                //Show Controls that rely on results.
                lblAction.Visible = true;
                UserStatusDescription.Visible = true;
                ApplyAction.Visible = true;
                ApplyNickNameReset.Visible = true;
                ShowDuration();
                Count.Visible = true;
            }
            else
            {
                //Hide Controls that rely on results.
                lblAction.Visible = false;
                UserStatusDescription.Visible = false;
                Duration.Visible = false;
                ApplyAction.Visible = false;
                ApplyNickNameReset.Visible = false;
                Count.Visible = false;
            }
        }
        else
        {
            //Hide all controls.
            Search.Visible = false;
            lblSearchBy.Visible = false;
            txtEntry.Visible = false;
            rdSearchType.Visible = false;
            lblSearchParams.Visible = false;
            lblAction.Visible = false;
            UserStatusDescription.Visible = false;
            ApplyAction.Visible = false;
            ApplyNickNameReset.Visible = false;
            Count.Visible = false;
        }
    }

    /// <summary>
    /// Function that is always called to recreate the table and all the check boxes
    /// </summary>
    private void GetMemberList()
    {
        tblResults.Rows.Clear();
        lblEntryError.Text = String.Empty;
        if (txtEntry.Text != String.Empty)
        {
            int userSearchType = rdSearchType.SelectedIndex;

            int userID = 0;
            string userEmail = String.Empty;
            string userName = String.Empty;
            string userIPAddress = String.Empty;
            string userBBCUID = String.Empty;
            string loginName = String.Empty;

            if (userSearchType == 0)
            {
                try
                {
                    userID = Convert.ToInt32(txtEntry.Text);
                }
                catch (System.FormatException Ex)
                {
                    lblEntryError.Text = "Please enter a valid User ID";
                    System.Console.WriteLine(Ex.Message);
                    return;
                }
            }
            else if (userSearchType == 1)
            {
                userEmail = txtEntry.Text;
            }
            else if (userSearchType == 2)
            {
                userName = txtEntry.Text;
            }
            else if (userSearchType == 3)
            {
                userIPAddress = txtEntry.Text;
            }
            else if (userSearchType == 4)
            {
                userBBCUID = txtEntry.Text;

                try
                {
                    Guid tmpBBCUID = new Guid(userBBCUID);
                }
                catch (System.FormatException Ex)
                {
                    lblEntryError.Text = "Please enter a valid BBC UID";
                    System.Console.WriteLine(Ex.Message);
                    return;
                }
            }
            else if (userSearchType == 5)
            {
                loginName = txtEntry.Text;
            }

            bool checkAllSites = false;
            //Sets the get across all sites for the stored procedures
            if (ViewingUser.IsSuperUser)
            {
                checkAllSites = true;
            }
            else
            {
                checkAllSites = false;
            }

            MemberList memberList = new MemberList(_basePage);
            memberList.GetMemberListXml(userSearchType, 
                                        userID, 
                                        userEmail, 
                                        userName, 
                                        userIPAddress, 
                                        userBBCUID, 
                                        loginName,
                                        checkAllSites);

            int count = 0;
            TableHeaderRow headerRow = new TableHeaderRow();
            headerRow.BackColor = Color.MistyRose;

            int previousUserID = 0;
            int accountCount = 0;

            foreach (XmlNode node in memberList.RootElement.SelectNodes(@"MEMBERLIST/USERACCOUNTS/USERACCOUNT"))
            {
                if (count == 0)
                {
                    //No header cell for the tickbox
                    TableHeaderCell headerfirstCheckBoxCell = new TableHeaderCell();
                    CheckBox checkBoxApplyAll = new CheckBox();
                    checkBoxApplyAll.ID = "ApplyToAll";
                    checkBoxApplyAll.Text = "Apply To All";
                    checkBoxApplyAll.Checked = ApplyToAllStatus;
                    checkBoxApplyAll.CheckedChanged += new EventHandler(ApplyToAll_CheckedChanged);
                    checkBoxApplyAll.AutoPostBack = true;
                    checkBoxApplyAll.EnableViewState = true;
                    checkBoxApplyAll.Attributes.Add("onfocus", "document.getElementById('__LASTFOCUS').value=this.id;");


                    headerfirstCheckBoxCell.Controls.Add(checkBoxApplyAll);
                    headerRow.Cells.Add(headerfirstCheckBoxCell);

                    TableHeaderCell headerFirstCell = new TableHeaderCell();
                    headerFirstCell.Text = "User ID";
                    headerFirstCell.Scope = TableHeaderScope.Column;
                    headerRow.Cells.Add(headerFirstCell);
                }

                TableRow row = new TableRow();
                TableCell firstCheckBoxCell = new TableCell();
                firstCheckBoxCell.HorizontalAlign = HorizontalAlign.Center;

                CheckBox checkBoxApply = new CheckBox();
                checkBoxApply.ID = "Check" + count.ToString();
                checkBoxApply.CheckedChanged += new EventHandler(ListApply_CheckedChanged);
                checkBoxApply.AutoPostBack = true;
                checkBoxApply.EnableViewState = true;
                checkBoxApply.Attributes.Add("onfocus", "document.getElementById('__LASTFOCUS').value=this.id;");
                firstCheckBoxCell.Controls.Add(checkBoxApply);
                row.Cells.Add(firstCheckBoxCell);

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
                link.NavigateUrl = "/dna/moderation/MemberDetails?userid=" + userIDText;
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
                        //img.Src = String.Format("http://ops-dna2.national.core.bbc.co.uk/dnaimages/moderation/images/icons/status{0}.gif", data.InnerText);
                        img.Src = path;
                        img.Alt = data.ParentNode.SelectSingleNode("USERSTATUSDESCRIPTION").InnerText;
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
                    else if ( data.LocalName != "USERSTATUSDESCRIPTION" &&
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
                Count.Text = String.Format(@"There are {0} entries.", count.ToString());
            }

            tblResults.Rows.AddAt(0, headerRow);

            tblResults.CellSpacing = 5;
            tblResults.BorderWidth = 2;
            tblResults.BorderStyle = BorderStyle.Outset;

        }
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
    /// Fired when the UserStatus Descriptiuon drop is changed alters whether the Duration menu appears or not
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void UserStatusDescription_SelectedIndexChanged(object sender, EventArgs e)
    {
        ShowDuration();
    }

    /// <summary>
    /// Show the duration combobox if relevant.
    /// </summary>
    private void ShowDuration()
    {
        UserStatusDescriptionValue = UserStatusDescription.SelectedItem.Value;

        if (UserStatusDescription.SelectedItem.Text == "Premoderate" || UserStatusDescription.SelectedItem.Text == "Postmoderate")
        {
            Duration.Visible = true;
        }
        else
        {
            Duration.Visible = false;
            Duration.SelectedIndex = 0;
        }

    }

    private void SetUserStatusDescription()
    {
        UserStatusDescription.SelectedItem.Value = UserStatusDescriptionValue;
    }

    /// <summary>
    /// Accessor for UserStatusDescriptionValue in the view state
    /// </summary>
    public string UserStatusDescriptionValue
    {
        get
        {
            string result = "Standard";
            object v = ViewState["UserStatusDescription"];

            if (v != null)
            {
                result = (string)v;
            }

            return result;
        }

        set
        {
            ViewState["UserStatusDescription"] = value;
        }
    }

    /// <summary>
    /// Accessor for ApplyToAllStatus in the view state
    /// </summary>
    public bool ApplyToAllStatus
    {
        get
        {
            bool result = false;
            object v = ViewState["ApplyToAllStatus"];

            if (v != null)
            {
                result = (bool)v;
            }

            return result;
        }

        set
        {
            ViewState["ApplyToAllStatus"] = value;
        }
    }

    /// <summary>
    /// Accessor for SetControlFocus in the view state
    /// </summary>
    public string SetControlFocus
    {
        get
        {
            string result = String.Empty;
            object v = ViewState["SetControlFocus"];

            if (v != null)
            {
                result = (string)v;
            }

            return result;
        }

        set
        {
            ViewState["SetControlFocus"] = value;
        }
    }

/*    protected override object SaveViewState()
    {
        return new Pair(base.SaveViewState(), null);
    }

    protected override void LoadViewState(object savedState)
    {
        base.LoadViewState(((Pair)savedState).First);
        EnsureChildControls();
    }
*/

    /// <summary>
    /// Function that actions the apply action button
    /// </summary>
    private void ApplyActions()
    {
        int rowCount = 0;
        CheckBox applyToAll = (CheckBox) tblResults.Rows[0].FindControl("ApplyToAll");
        MemberList memberList = new MemberList(_basePage);
        ArrayList userIDList = new ArrayList();
        ArrayList siteIDList = new ArrayList();

        int newPrefStatusValue = GetPrefStatusValueFromDescription(UserStatusDescription.SelectedValue);
        int newPrefStatusDuration = 0;
        Int32.TryParse(Duration.SelectedValue, out newPrefStatusDuration);

        if (applyToAll != null && applyToAll.Checked)
        {
            if (ViewingUser.IsSuperUser)
            {
               // memberList.UpdateModerationStatus(userID, siteID, newPrefStatusValue, newPrefStatusDuration, 0, 1);
            }
            else
            {
               // memberList.UpdateModerationStatusAcrossAllSites(ViewingUser.UserID, userID, siteID, newPrefStatusValue, newPrefStatusDuration);

            }
        }
        
        foreach (TableRow row in tblResults.Rows)
        {
            if (row.GetType() != typeof(TableHeaderRow))
            {
                CheckBox checkBox = (CheckBox)row.FindControl("Check" + rowCount.ToString());
                if (checkBox.Checked)
                {
                    int userID = 0;
                    int siteID = 0;
                    Int32.TryParse(row.Cells[1].Text, out userID);
                    Int32.TryParse(row.Cells[2].Text, out siteID);

                    userIDList.Add(userID);
                    siteIDList.Add(siteID);
                }
                rowCount++;
            }
        }

        if (userIDList.Count > 0)
        {
            memberList.UpdateModerationStatuses(userIDList, siteIDList, newPrefStatusValue, newPrefStatusDuration);
        }

        UserGroups.GetObject().SendSignal();
        GetMemberList();
    }

    /// <summary>
    /// Fires when a checkbox in the table is pressed checks whether to check or un check the apply to all checkbox
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ListApply_CheckedChanged(object sender, EventArgs e)
    {
        bool allChecked = true;
        int rowCount = 0;
        foreach (TableRow row in tblResults.Rows)
        {
            if (row.GetType() != typeof(TableHeaderRow))
            {
                CheckBox checkBox = (CheckBox)row.FindControl("Check" + rowCount.ToString());
                if (!checkBox.Checked)
                {
                    allChecked = false;
                    break;
                }
                rowCount++;
            }
        }
        CheckBox applyToAll = (CheckBox)tblResults.Rows[0].FindControl("ApplyToAll");
        if (applyToAll != null)
        {
            applyToAll.Checked = allChecked;
            ApplyToAllStatus = applyToAll.Checked;
        }
        CheckBox oneThatsTicked = (CheckBox)sender;
        SetControlFocus = oneThatsTicked.ClientID;
    }

    /// <summary>
    /// Function to clear the Apply to All checkbox and the viewstate variable
    /// Checks we actually have a table/checkbox to clear
    /// </summary>
    private void ClearApplyToAll()
    {
        if (tblResults.Rows.Count > 0)
        {
            CheckBox applyToAll = (CheckBox)tblResults.Rows[0].FindControl("ApplyToAll");
            if (applyToAll != null)
            {
                applyToAll.Checked = false;
                ApplyToAllStatus = false;
            }
        }
    }

    /// <summary>
    /// Fires when the check box in the header row is checked or unchecked
    /// Checks or unchecks all the checkboxes in the table
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ApplyToAll_CheckedChanged(object sender, EventArgs e)
    {
        int rowCount = 0;
        CheckBox applyToAll = (CheckBox)tblResults.Rows[0].FindControl("ApplyToAll");

        ApplyToAllStatus = applyToAll.Checked;

        applyToAll.CheckedChanged += new EventHandler(ApplyToAll_CheckedChanged);
        applyToAll.AutoPostBack = true;
        applyToAll.EnableViewState = true;
        if (applyToAll != null)
        {
            foreach (TableRow row in tblResults.Rows)
            {
                if(row.GetType() != typeof(TableHeaderRow))
                {
                    CheckBox checkBox = (CheckBox)row.FindControl("Check" + rowCount.ToString());
                    if (applyToAll.Checked)
                    {
                        checkBox.Checked = true;
                    }
                    else
                    {
                        checkBox.Checked = false;
                    }
                    rowCount++;
                }
            }
        }
    }
    /// <summary>
    /// Returns the pref status value from the given description
    /// </summary>
    /// <param name="newPrefStatusDescription">The pref status description</param>
    /// <returns>The associated pref status value</returns>
    private static int GetPrefStatusValueFromDescription(string newPrefStatusDescription)
    {
        int newPrefStatusValue = 0;

        switch (newPrefStatusDescription)
        {
            case "Standard":
                newPrefStatusValue = 0;
                break;
            case "Premoderate":
                newPrefStatusValue = 1;
                break;
            case "Postmoderate":
                newPrefStatusValue = 2;
                break;
            case "Send for review":
                newPrefStatusValue = 3;
                break;
            case "Restricted":
                newPrefStatusValue = 4;
                break;
            default:
                newPrefStatusValue = 0;
                break;
        }
        return newPrefStatusValue;
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
}
