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
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;

public partial class BannedEmailAdminPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// The default constructor
    /// </summary>
    public BannedEmailAdminPage()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "BANNEDEMAILS-ADMIN"; }
    }

    /// <summary>
    /// Allowed users property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }

    private static int _resultsPerPage = 20;
    private int _searchType = 0;
    private int _skip = 0;
    private int _show = _resultsPerPage;
    private string _letter = "a";
    private List<Button> _removeButtons = new List<Button>();
    private List<CheckBox> _signinBannedCheckBoxes = new List<CheckBox>();
    private List<CheckBox> _complaintBannedCheckBoxes = new List<CheckBox>();
    private bool _signInCheckBoxChange = false;
    private bool _complaintCheckBoxChange = false;
    private string _checkBoxChangeID = "";
    private string _checkBoxChangeEmail = "";

    /// <summary>
    /// OnPageLoad method 
    /// </summary>
    public override void OnPageLoad()
    {
        // Set the VirtualUrl item in the context to the page name. This is done to get round the problems
        // with post backs
        Context.Items["VirtualUrl"] = "BannedEmailsAdmin";
        lbMessage.Visible = false;
        padding1.Visible = false;
        padding2.Visible = false;

        // Put the place holder buttons into the form
        for (int i = 0; i <= _resultsPerPage; i++)
        {
            Button removeButton = new Button();
            removeButton.EnableViewState = true;
            removeButton.ID = "btnRemove" + i.ToString();
            removeButton.CommandName = "Remove";
            removeButton.CommandArgument = (string)ViewState[removeButton.ID];
            removeButton.Text = "Remove";
            removeButton.Click += new EventHandler(btnRemove_Click);
            _removeButtons.Add(removeButton);
            removeButton.Visible = false;
            form1.Controls.Add(removeButton);

            CheckBox bannedSignInCB = new CheckBox();
            bannedSignInCB.ID = "cbSignInBan" + i.ToString();
            bannedSignInCB.Visible = false;
            bannedSignInCB.AutoPostBack = true;
            bannedSignInCB.EnableViewState = true;
            _signinBannedCheckBoxes.Add(bannedSignInCB);
            form1.Controls.Add(bannedSignInCB);

            CheckBox bannedComplaintCB = new CheckBox();
            bannedComplaintCB.ID = "cbComplaintBan" + i.ToString();
            bannedComplaintCB.Visible = false;
            bannedComplaintCB.AutoPostBack = true;
            bannedComplaintCB.EnableViewState = true;
            _complaintBannedCheckBoxes.Add(bannedComplaintCB);
            form1.Controls.Add(bannedComplaintCB);
        }

        // Add the search term into the viewstate if doesn't already exist
        if (ViewState["searchterm"] == null)
        {
            ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        }
        
        // Now display all the banned emails. First check to make sure we're not in a postback
        if (!Page.IsPostBack)
        {
            CalculateSearchTerm();
            DisplayBannedEmails();
        }
        else
        {
            CheckTargetControl();
        }
    }

    /// <summary>
    /// Checks to see what the target control was for the postback
    /// </summary>
    private void CheckTargetControl()
    {
        // Check to see if one of the check boxes was changed
        string targetControl = Page.Request.Params["__EVENTTARGET"];
        if (targetControl.Length > 11 && targetControl.Substring(0, 11).CompareTo("cbSignInBan") == 0)
        {
            // Update on the change
            BannedSignInCheckBoxChanged(targetControl);
        }
        else if (targetControl.Length > 14 && targetControl.Substring(0, 14).CompareTo("cbComplaintBan") == 0)
        {
            // Update on the change
            BannedComplaintCheckBoxChanged(targetControl);
        }
    }

    protected override void OnLoadComplete(EventArgs e)
    {
        base.OnLoadComplete(e);
    }

    /// <summary>
    /// Used to display a message to the user
    /// </summary>
    /// <param name="message">The message you want to display</param>
    /// <param name="goodMsg">If set to true, then the message is displayed in green, else it will be red</param>
    private void DisplayUserMessage(string message, bool goodMsg)
    {
        // Set the text and make the message visible
        lbMessage.Text = message;
        lbMessage.Visible = true;
        padding1.Visible = true;
        padding2.Visible = true;
        if (goodMsg)
        {
            lbMessage.ForeColor = System.Drawing.Color.Green;
        }
        else
        {
            lbMessage.ForeColor = System.Drawing.Color.Red;
        }
    }

    /// <summary>
    /// Adds all the banned emails to the table for display
    /// </summary>
    private void DisplayBannedEmails()
    {
        // Check to see if we're a super user. If not, hide the UI
        if (!_basePage.ViewingUser.IsSuperUser)
        {
            // Remove the UI
            foreach (Control control in form1.Controls)
            {
                control.Visible = false;
            }

            // Show the super user only message
            DisplayUserMessage("This is a superuser only page!", false);
            return;
        }

        // Get the emails from the database
        BannedEmails bannedEmails = new BannedEmails(_basePage);

        // Get the emails based on the search term
        if (_letter.CompareTo("All") == 0)
        {
            _letter = "";
        }
        bool showSignInBannedOnly = rbFilterSignIn.Checked;
        bool showComplaintBannedOnly = rbFilterComplaint.Checked;
        bool showAll = rbFilterAll.Checked;
        ArrayList bannedEmailArray = bannedEmails.GetBannedEmails(_skip,_show,_searchType,_letter,showSignInBannedOnly,showComplaintBannedOnly,showAll);
        tblBannedEmails.Rows.Clear();

        // Create the table header
        TableHeaderRow headerRow = new TableHeaderRow();
        TableCell emailCell = new TableCell();
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
        emailCell.Text = "Email address ordered " + orderedBy;
        emailCell.Font.Bold = true;
        headerRow.Cells.Add(emailCell);

        TableCell signInBan = new TableCell();
        signInBan.Text = "Sign In Banned";
        signInBan.Font.Bold = true;
        headerRow.Controls.Add(signInBan);

        TableCell complaintBan = new TableCell();
        complaintBan.Text = "Complaint Banned";
        complaintBan.Font.Bold = true;
        headerRow.Controls.Add(complaintBan);

        TableCell dateCell = new TableCell();
        dateCell.Text = "Date Banned";
        dateCell.Font.Bold = true;
        headerRow.Cells.Add(dateCell);

        TableCell addedByCell = new TableCell();
        addedByCell.Text = "Added By";
        addedByCell.Font.Bold = true;
        headerRow.Cells.Add(addedByCell);
        tblBannedEmails.Rows.Add(headerRow);

        // Add a row to the table for each item
        int i = 0;
        foreach (BannedEmail email in bannedEmailArray)
        {
            // Add the item
            CreateTableEntryForEmailItem(email,i++);
        }

        // Set the total matches for this search
        lbTotalResults.Text = bannedEmails.TotalEmails.ToString();

        // Update the paging controls
        int currentPage = ((_skip + 1) / _show) + 1;
        int totalPages = 1;
        if (bannedEmails.TotalEmails > 0)
        {
            totalPages = (int)Math.Ceiling((double)bannedEmails.TotalEmails / (double)_show);
        }

        btnFirst.Enabled = (_skip > 0);
        btnPrevious.Enabled = (_skip > 0);
        btnNext.Enabled = ((_skip + _show) < bannedEmails.TotalEmails);
        btnLast.Enabled = ((_skip + _show) < bannedEmails.TotalEmails);
        lbPage.Text = "Page " + currentPage + " of " + totalPages;

        btnFirst2.Enabled = (_skip > 0);
        btnPrevious2.Enabled = (_skip > 0);
        btnNext2.Enabled = ((_skip + _show) < bannedEmails.TotalEmails);
        btnLast2.Enabled = ((_skip + _show) < bannedEmails.TotalEmails);
        lbPage2.Text = "Page " + currentPage + " of " + totalPages;
    }

    /// <summary>
    /// Creates a table row for a banned email item
    /// </summary>
    /// <param name="item">The bannedEmail object that contains the details to fill the row in</param>
    private void CreateTableEntryForEmailItem(BannedEmail item, int rowIndex)
    {
         // Create the row and then add the cells to it
        TableRow row = new TableRow();
        row.EnableViewState = true;
        string newid = Guid.NewGuid().ToString();
        row.ID = newid;

        // Create the email textbox
        TableCell emailCell = new TableCell();
        emailCell.EnableViewState = true;
        TextBox tbEmail = new TextBox();
        tbEmail.EnableViewState = true;
        tbEmail.Text = item.Email;
        tbEmail.ID = "tbBannedEmailAddress" + rowIndex.ToString();
        tbEmail.Width = new Unit("98%");
        tbEmail.ReadOnly = true;
        emailCell.Controls.Add(tbEmail);
        emailCell.Width = new Unit("100%");
        row.Cells.Add(emailCell);

        // Create the banned from signin check box
        TableCell bannedSignInCell = new TableCell();
        CheckBox bannedSignInCB = _signinBannedCheckBoxes[rowIndex];
        bannedSignInCB.Checked = item.BannedFromSignIn;
        bannedSignInCB.Visible = true;
        bannedSignInCB.Attributes.Add("Email", item.Email);
        bannedSignInCell.Controls.Add(bannedSignInCB);
        row.Cells.Add(bannedSignInCell);
        if (_signInCheckBoxChange && _checkBoxChangeID.CompareTo(bannedSignInCB.ID) == 0)
        {
            _checkBoxChangeEmail = item.Email;
        }

        // Create the banned from complaining check box
        TableCell bannedComplainingCell = new TableCell();
        CheckBox bannedCompCB = _complaintBannedCheckBoxes[rowIndex];
        bannedCompCB.Checked = item.BannedFromComplaining;
        bannedCompCB.Visible = true;
        bannedCompCB.Attributes.Add("Email", item.Email);
        bannedComplainingCell.Controls.Add(bannedCompCB);
        row.Cells.Add(bannedComplainingCell);
        if (_complaintCheckBoxChange && _checkBoxChangeID.CompareTo(bannedCompCB.ID) == 0)
        {
            _checkBoxChangeEmail = item.Email;
        }

        // Create the date added
        TableCell dateAddedCell = new TableCell();
        dateAddedCell.EnableViewState = true;
        dateAddedCell.Text = item.DateAdded.ToShortDateString();
        row.Cells.Add(dateAddedCell);

        // Create the Editor who added it
        TableCell editorIDCell = new TableCell();
        editorIDCell.EnableViewState = true;
        HyperLink lbtEditor = new HyperLink();
        lbtEditor.EnableViewState = true;
        lbtEditor.Text = item.EditorName;
        lbtEditor.NavigateUrl = "http://www.bbc.co.uk/dna/" + _basePage.CurrentSite.SiteName + "/U" + item.EditorID;
        editorIDCell.Controls.Add(lbtEditor);
        row.Cells.Add(editorIDCell);

        // Only add the remove button if the user is a super user
        if (_basePage.ViewingUser.IsSuperUser)
        {
            // Create the remove button
            TableCell removeCell = new TableCell();
            Button btnRemove = _removeButtons[rowIndex];
            btnRemove.CommandArgument = item.Email;
            ViewState.Add(btnRemove.ID, item.Email);
            btnRemove.Visible = true;
            removeCell.Controls.Add(btnRemove);
            row.Cells.Add(removeCell);
        }

        tblBannedEmails.Rows.Add(row);
    }

    /// <summary>
    /// Handles the add new email button
    /// </summary>
    /// <param name="sender">The object that sent the event</param>
    /// <param name="e">Any event arguments that are associated with the event</param>
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        // Add the new email to the list, basic checks first to avoid 
        if ( EmailAddressFilter.IsValidEmailAddresses(tbNewEmail.Text) )
        {
            BannedEmails bannedEmails = new BannedEmails(_basePage);
            if (bannedEmails.AddEmailToBannedList(tbNewEmail.Text, _basePage.ViewingUser.UserID, cbNewSignInBanned.Checked, cbNewComplaintBanned.Checked))
            {
                // Tell the user which email they just removed
                DisplayUserMessage("Email address '" + tbNewEmail.Text + "' has just been added", true);

                ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
                CalculateSearchTerm();
            }
            else
            {
                // Tell the user the email already exists or we failed to add it
                DisplayUserMessage("Email address '" + tbNewEmail.Text + "' already exists or could not be added!", false);
            }
        }
        else
        {
            //Display Error
            DisplayUserMessage("Email address '" + tbNewEmail.Text + "' failed email validation.", false);
        }
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the remove email button event
    /// </summary>
    /// <param name="sender">The object that sent the event</param>
    /// <param name="e">Any arguments associated with the event</param>
    protected void btnRemove_Click(object sender, EventArgs e)
    {
        Button btClicked = ((Button)sender);
        if (btClicked.CommandName.CompareTo("Remove") == 0)
        {
            // Now get the id from the command argument and delete the namespace from the database
            string cmdArg = btClicked.CommandArgument;

            // Remove the email from the list
            BannedEmails bannedEmails = new BannedEmails(_basePage);
            bannedEmails.RemoveEmail(cmdArg);

            // Tell the user which email they just removed
            DisplayUserMessage("Email address '" + cmdArg + "' has just been removed", true);

            CalculateSearchTerm();
            DisplayBannedEmails();
        }
    }

    /// <summary>
    /// Handles the signin banned check box event for a list item
    /// </summary>
    /// <param name="checkBoxName">The name of the check box that has been changed</param>
    private void BannedSignInCheckBoxChanged(string checkBoxName)
    {
        // Set the flags to state that a check box has changed a we want to make a note of the email
        // When we get the items to display
        _signInCheckBoxChange = true;
        _checkBoxChangeID = checkBoxName;

        // Now show the changes
        CalculateSearchTerm();
        DisplayBannedEmails();

        // Get the email and settings to update with
        UpdateBannedEmailSettings(_checkBoxChangeEmail, true, false);
    }

    /// <summary>
    /// Handles the complaint banned check box event for a list item
    /// </summary>
    /// <param name="checkBoxName">The name of the check box that has been changed</param>
    private void BannedComplaintCheckBoxChanged(string checkBoxName)
    {
        // Set the flags to state that a check box has changed a we want to get the email
        // When we get the items to display
        _complaintCheckBoxChange = true;
        _checkBoxChangeID = checkBoxName;

        // Now show the changes
        CalculateSearchTerm();
        DisplayBannedEmails();

        // Get the email and settings to update with
        UpdateBannedEmailSettings(_checkBoxChangeEmail, false, true);
    }

    /// <summary>
    /// This method is used to update a given EMail settings
    /// </summary>
    /// <param name="email">The email address you want to update the settings for</param>
    /// <param name="toggleSignInBanned">The signin banned setting you want to set</param>
    /// <param name="toggleComplaintBanned">The complaint banned setting you want to set</param>
    private void UpdateBannedEmailSettings(string email, bool toggleSignInBanned, bool toggleComplaintBanned)
    {
        // Update the select email
        BannedEmails bannedEmails = new BannedEmails(_basePage);
        bannedEmails.UpdateBannedEmail(email, _basePage.ViewingUser.UserID, toggleSignInBanned, toggleComplaintBanned);

        // Tell the user
        string msg = "Email address '" + email + "' ";
        if (toggleComplaintBanned)
        {
            msg += "complaint";
        }
        else if (toggleSignInBanned)
        {
            msg += "sign in";
        }

        msg += " settings have just been updated";
        DisplayUserMessage(msg, true);
    }

    /// <summary>
    /// Handles the search by letter button clicks
    /// </summary>
    /// <param name="sender">The object that fired the event</param>
    /// <param name="e">Any arguments </param>
    protected void btnViewByLetter(object sender, EventArgs e)
    {
        // Set the search term to look at the first set of results for the search letter
        Button btnLetter = (Button)sender;
        ViewState.Add("searchterm", "byletter:0:" + _show.ToString() + ":" + btnLetter.ID.Substring(3));
        CalculateSearchTerm();
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the search by most recent button click. When clicked the page will show page one of the most recent emails.
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnViewMostRecent(object sender, EventArgs e)
    {
        // Just set the search term to look at the first set of most recent emails
        ViewState.Add("searchterm", "mostrecent:0:" + _show.ToString());
        CalculateSearchTerm();
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the show firstpage button click. When clicked, the user is shown page one of the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnShowFirst(object sender, EventArgs e)
    {
        // Get the last search term
        CalculateSearchTerm();

        // Set the skip and show to display the first page of results
        _skip = 0;
        _show = _resultsPerPage;

        // Now set the current search term
        SetNewSearchTerm();

        // Display the results
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the show previous page button click. When clicked, the user is shown the previous page of results for the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnShowPrevious(object sender, EventArgs e)
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
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the filter radio button changes
    /// </summary>
    /// <param name="sender">The radio button that what clicked</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void rbFilterChanged(object sender, EventArgs e)
    {
        // Calculate the search terms and show the results
        CalculateSearchTerm();
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the show next page button click. When clicked, the user is shown the next page for the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnShowNext(object sender, EventArgs e)
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
        DisplayBannedEmails();
    }

    /// <summary>
    /// Handles the show lastpage button click. When clicked, the user is shown page one of the current search type
    /// </summary>
    /// <param name="sender">The button that fired the event</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnShowLast(object sender, EventArgs e)
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
        DisplayBannedEmails();
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
    }

    /// <summary>
    /// Calculates the search term from the searchterm lable
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
}
