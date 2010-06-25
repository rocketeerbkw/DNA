using System;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna;
using BBC.Dna.Utils;

public partial class UserStatisticsPage : BBC.Dna.Page.DnaWebPage
{
    private int _skip = 0;
    private int _show = 20;
    private int _total = 0;

    private const string _docDnaStartDate = @"Start Date of the UserStatistics to look at.";
    private const string _docDnaEndDate = @"End Date of the UserStatistics to look at.";
    
    /// <summary>
    /// Constructor for the UserStatisticsPage Page
    /// </summary>
    public UserStatisticsPage()
    {
        UseDotNetRendering = true;
    }

    public override string PageType
    {
        get { return "USERSTATISTICS"; }
    }

    /// <summary>
    /// Setup the page and initialise some of the controls
    /// </summary>
    /// <param name="e"></param>
    protected override void OnInit(EventArgs e)
    {
        DateTime now = DateTime.Now.Date;
        DateTime monthago = now.Date.AddMonths(-1);

        endDate.SelectionMode = CalendarSelectionMode.Day;
        startDate.SelectionMode = CalendarSelectionMode.Day;

        endDate.SelectedDate = now;
        endDate.VisibleDate = now;

        startDate.SelectedDate = monthago;
        startDate.VisibleDate = monthago;

        base.OnInit(e);
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        Context.Items["VirtualUrl"] = "UserStatistics";

        if (!IsDnaUserAllowed())
        {
            ShowHideControls(false);
            lblError.Text = "Insufficient permissions - Editor Status Required";
            return;
        }
        if (!Page.IsPostBack)
        {
            int userId = Request.GetParamIntOrZero("userid", "UserId");

            if (userId != 0)
            {
                txtEntry.Text = userId.ToString();
            }

            int passedInShow = Request.GetParamIntOrZero("show", "show");
            if (passedInShow == 0)
            {
                _show = _basePage.GetSiteOptionValueInt("ArticleSearch", "DefaultShow");
            }
            else if (passedInShow > 200)
            {
                _show = 200;
            }
            else
            {
                _show = passedInShow;
            }

            int passedInSkip = Request.GetParamIntOrZero("skip", "skip");
            _skip = passedInSkip;

            DateTime enteredStartDate = DateTime.MinValue;
            DateTime enteredEndDate = DateTime.MinValue;

            try
            {
                if (Request.DoesParamExist("startDate", _docDnaStartDate))
                {
                    string startDateText = Request.GetParamStringOrEmpty("startDate", _docDnaStartDate);
                    string endDateText = Request.GetParamStringOrEmpty("endDate", _docDnaEndDate);

                    DateRangeValidation dateValidation = new DateRangeValidation();
                    DateRangeValidation.ValidationResult isValid;

                    DateTime tempStartDate;
                    DateTime tempEndDate;

                    isValid = UserStatistics.ParseDateParams(startDateText, endDateText, out tempStartDate, out tempEndDate);
                    isValid = dateValidation.ValidateDateRange(tempStartDate, tempEndDate, 0, false, false);

                    if (isValid == DateRangeValidation.ValidationResult.VALID)
                    {
                        enteredStartDate = dateValidation.LastStartDate;
                        enteredEndDate = dateValidation.LastEndDate;
                    }
                    else
                    {
                        lblError.Text = "Passed in Date not valid.";
                        return;
                    }
                }
                else
                {
                    enteredStartDate = DateTime.Now.AddMonths(-1);
                    if (!Request.DoesParamExist("endDate", _docDnaEndDate))
                    {
                        enteredEndDate = DateTime.Now;
                    }
                }

                if (enteredStartDate > enteredEndDate)
                {
                    enteredStartDate = enteredEndDate.AddMonths(-1);
                }

                TimeSpan timeSpan = enteredEndDate - enteredStartDate;

                if (timeSpan.Days > 180)
                {
                    enteredStartDate = enteredEndDate.AddDays(-180);
                }

                startDate.SelectedDate = enteredStartDate.Date;
                startDate.VisibleDate = enteredStartDate.Date;
                endDate.SelectedDate = enteredEndDate.Date;
                endDate.VisibleDate = enteredEndDate.Date;
            }
            catch (FormatException)
            {
                lblError.Text = "Passed in Date format incorrect. It should be dd/mm/yyyy";
                return;
            }

            if (userId != 0)
            {
                txtEntry.Text = userId.ToString();
            }

            string skin = Request.GetParamStringOrEmpty("skin", "skin");
            string skParam = Request.GetParamStringOrEmpty("_sk", "skin");
            if (skin == "purexml" || skParam == "purexml")
            {
                GetUserStatistics(true);
            }
            else
            {
                GetUserStatistics(false);
                ShowHideControls(true);
            }
        }
        else
        {
            ShowHideResultControls(false);
        }

    }

    public override bool IsHtmlCachingEnabled()
    {
        return GetSiteOptionValueBool("cache", "HTMLCaching");
    }

    public override int GetHtmlCachingTime()
    {
        return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }
    /// <summary>
    /// The action fire when the search button is pressed.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Search_Click(object sender, EventArgs e)
    {
        GetUserStatistics(false);
    }
    /// <summary>
    /// Hides or shows the controls on the page
    /// </summary>
    /// <param name="show"></param>
    private void ShowHideControls(bool show)
    {
        //Reset any previous error text.
        lblError.Text = "";

        ShowHideSearchControls(show);
        ShowHideResultControls(show);
    }

    private void ShowHideSearchControls(bool show)
    {
        Search.Visible = show;
        lblSearchBetween.Visible = show;
        txtEntry.Visible = show;
        lblSearchParams.Visible = show;
        startDate.Visible = show;
        endDate.Visible = show;
    }

    private void ShowHideResultControls(bool show)
    {
        tblResults.Visible = show;
        btnFirst.Visible = show;
        btnPrevious.Visible = show;
        btnNext.Visible = show;
        btnLast.Visible = show;
        lbPage.Visible = show;

        btnFirst2.Visible = show;
        btnPrevious2.Visible = show;
        btnNext2.Visible = show;
        btnLast2.Visible = show;
        lbPage2.Visible = show;
        Count.Visible = show;
    }

    /// <summary>
    /// Function that is always called to recreate the table
    private void GetUserStatistics(bool purexml)
    {
        tblResults.Rows.Clear();
        Count.Text = "";
        lblEntryError.Text = String.Empty;
        if (txtEntry.Text != String.Empty)
        {
            int userID = 0;
            userID = Convert.ToInt32(txtEntry.Text);

            DateTime startDateTime = startDate.SelectedDate;
            DateTime endDateTime = endDate.SelectedDate;
            endDateTime = endDateTime.AddDays(1);

            UserStatistics userStatistics = new UserStatistics(_basePage);
            userStatistics.TryCreateUserStatisticsXML(userID, _skip, _show, 1, startDateTime, endDateTime);

            if (!purexml)
            {
                DisplayUserStatistics(userStatistics);
            }
            else
            {
                //Replace an existing node
                if (_basePage.WholePageBaseXmlNode.SelectSingleNode("/USERSTATISTICS") != null)
                {
                    XmlNode userstats = _basePage.WholePageBaseXmlNode.SelectSingleNode("/USERSTATISTICS");

                    _basePage.WholePageBaseXmlNode.ReplaceChild(userstats, _basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(userStatistics.RootElement.FirstChild, true));
                }
                else
                {
                    _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(userStatistics.RootElement.FirstChild, true));
                }
            }

        }
    }

    private void DisplayUserStatistics(UserStatistics userStatistics)
    {
        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int previousForumID = 0;
        int forumCount = 0;

        foreach (XmlNode post in userStatistics.RootElement.SelectNodes(@"USERSTATISTICS/FORUM/THREAD/POST"))
        {
            XmlNode thread = post.ParentNode;
            XmlNode forum = thread.ParentNode;
            if (count == 0)
            {
                TableHeaderCell headerSiteCell = new TableHeaderCell();
                headerSiteCell.Text = "Site";
                headerSiteCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerSiteCell);

                TableHeaderCell headerForumTitleCell = new TableHeaderCell();
                headerForumTitleCell.Text = "ForumTitle";
                headerForumTitleCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerForumTitleCell);

                TableHeaderCell headerFirstSubjectCell = new TableHeaderCell();
                headerFirstSubjectCell.Text = "Conversation First Subject";
                headerFirstSubjectCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerFirstSubjectCell);

                TableHeaderCell headerPostSubjectCell = new TableHeaderCell();
                headerPostSubjectCell.Text = "Post Subject";
                headerPostSubjectCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerPostSubjectCell);

                TableHeaderCell headerPostTextCell = new TableHeaderCell();
                headerPostTextCell.Text = "Post Text";
                headerPostTextCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerPostTextCell);

                TableHeaderCell headerDatePostedCell = new TableHeaderCell();
                headerDatePostedCell.Text = "Date Posted";
                headerDatePostedCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerDatePostedCell);

                TableHeaderCell headerComplainCell = new TableHeaderCell();
                headerComplainCell.Text = "Complain";
                headerComplainCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerComplainCell);
            }

            TableRow row = new TableRow();

            string forumID = forum.SelectSingleNode(@"@FORUMID").InnerText;
            int currentForumID = Convert.ToInt32(forumID);
            if (currentForumID != previousForumID)
            {
                forumCount++;
                previousForumID = currentForumID;
            }

            if (forumCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            string siteID = forum.SelectSingleNode(@"SITEID").InnerText;
            string siteName = forum.SelectSingleNode(@"SITENAME").InnerText;

            string commentURL = String.Empty;
            bool isComment = false;
            if (forum.SelectSingleNode(@"URL") != null && forum.SelectSingleNode(@"URL").InnerText != String.Empty)
            {
                commentURL = forum.SelectSingleNode(@"URL").InnerText;
                isComment = true;
            }

            TableCell siteCell = new TableCell();
            siteCell.HorizontalAlign = HorizontalAlign.Center;
            siteCell.Text = siteName;
            row.Cells.Add(siteCell);

            TableCell forumTitleCell = new TableCell();
            forumTitleCell.HorizontalAlign = HorizontalAlign.Center;
            string subject = forum.SelectSingleNode(@"SUBJECT").InnerText;
            forumTitleCell.Text = subject;

            HyperLink forumTitleLink = new HyperLink();
            if (!isComment)
            {
                forumTitleLink.NavigateUrl = GetBaseUrl() + siteName + @"/F" + forumID;
            }
            else
            {
                forumTitleLink.NavigateUrl = commentURL;
            }
            forumTitleLink.Text = subject;
            forumTitleCell.Controls.Add(forumTitleLink);
            row.Cells.Add(forumTitleCell);

            TableCell firstSubjectCell = new TableCell();
            firstSubjectCell.HorizontalAlign = HorizontalAlign.Center;
            string firstSubject = thread.SelectSingleNode(@"SUBJECT").InnerText;
            firstSubjectCell.Text = firstSubject;

            string threadID = thread.SelectSingleNode(@"@THREADID").InnerText;

            HyperLink firstSubjectLink = new HyperLink();
            if (!isComment)
            {
                firstSubjectLink.NavigateUrl = GetBaseUrl() + siteName + @"/F" + forumID + "?thread=" + threadID;
            }
            else
            {
                firstSubjectLink.NavigateUrl = commentURL;
            }
            firstSubjectLink.Text = firstSubject;
            firstSubjectCell.Controls.Add(firstSubjectLink);
            row.Cells.Add(firstSubjectCell);

            TableCell postSubjectCell = new TableCell();
            postSubjectCell.HorizontalAlign = HorizontalAlign.Center;
            string postSubject = post.SelectSingleNode(@"SUBJECT").InnerText;
            postSubjectCell.Text = postSubject;

            string postID = post.SelectSingleNode(@"@POSTID").InnerText;

            HyperLink postLink = new HyperLink();
            if (!isComment)
            {
                postLink.NavigateUrl = GetBaseUrl() + siteName + @"/F" + forumID + "?thread=" + threadID + @"&post=" + postID + "#p" + postID;
            }
            else
            {
                string postIndex = post.SelectSingleNode(@"POSTINDEX").InnerText;
                postLink.NavigateUrl = commentURL + "#" + postIndex;
            }
            postLink.Text = postSubject;
            postSubjectCell.Controls.Add(postLink);
            row.Cells.Add(postSubjectCell);

            TableCell postTextCell = new TableCell();
            postTextCell.HorizontalAlign = HorizontalAlign.Center;
            string text = post.SelectSingleNode(@"BODY").InnerText;
            postTextCell.Text = text;
            row.Cells.Add(postTextCell);

            TableCell datePostedCell = new TableCell();
            datePostedCell.HorizontalAlign = HorizontalAlign.Center;
            string dateposted = post.SelectSingleNode(@"DATEPOSTED/DATE/@RELATIVE").InnerText;
            datePostedCell.Text = dateposted;
            row.Cells.Add(datePostedCell);

            TableCell complaintCell = new TableCell();
            complaintCell.HorizontalAlign = HorizontalAlign.Center;
            string path = @"/dnaimages/boards/images/complain.gif";

            HyperLink complaintLink = new HyperLink();
            complaintLink.NavigateUrl = GetBaseUrl() + siteName + @"/UserComplaintPage?PostID=" + postID;
            complaintLink.ImageUrl = path;
            complaintCell.Controls.Add(complaintLink);

            row.Cells.Add(complaintCell);

            tblResults.Rows.Add(row);
            count++;
        }

        XmlNode totalPosts = userStatistics.RootElement.SelectSingleNode(@"USERSTATISTICS/@TOTAL");

        _total = 0;
        if (totalPosts != null)
        {
            Int32.TryParse(totalPosts.InnerText, out _total);
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
            Count.Text = String.Format(@"{0} entries out of {1} in total.", count.ToString(), _total.ToString());
        }

        tblResults.Rows.AddAt(0, headerRow);

        tblResults.CellSpacing = 5;
        tblResults.BorderWidth = 2;
        tblResults.BorderStyle = BorderStyle.Outset;

        ShowHideResultControls(true);
        UpdatePagingControls();
        StoreValues();
    }

    private void StoreValues()
    {
        ViewState.Add("skip", _skip.ToString());
        ViewState.Add("show", _show.ToString());
        ViewState.Add("total", _total.ToString());
    }

    private void RetrieveValues()
    {
        Int32.TryParse(ViewState["skip"].ToString(), out _skip);
        Int32.TryParse(ViewState["show"].ToString(), out _show);
        Int32.TryParse(ViewState["total"].ToString(), out _total);
    }

    protected void btnShowFirst(object sender, EventArgs e)
    {
        // Set the skip and show to display the first page of results
        _skip = 0;
        _show = _basePage.GetSiteOptionValueInt("ArticleSearch", "DefaultShow");
        GetUserStatistics(false);
    }
    protected void btnShowPrevious(object sender, EventArgs e)
    {
        RetrieveValues();
        // Calculate the new skip and show values
        _skip -= _show;
        if (_skip < 0)
        {
            _skip = 0;
        }
        GetUserStatistics(false);
    }

    protected void btnShowNext(object sender, EventArgs e)
    {
        RetrieveValues();
        // Calculate the new skip and show values
        _skip += _show;
        int previousTotal = _total;
        if (_skip > previousTotal)
        {
            _skip -= _show;
        }
        GetUserStatistics(false);
    }

    protected void btnShowLast(object sender, EventArgs e)
    {
        RetrieveValues();
        // Calculate the new skip and show values
        int previousTotal = _total;
        _skip = (previousTotal / _show) * _show;
        if (_skip == previousTotal)
        {
            _skip -= _show;
        }
        GetUserStatistics(false);
    }

    void UpdatePagingControls()
    {
        // Update the paging controls
        int currentPage = ((_skip + 1) / _show) + 1;
        int totalPages = 1;
        if (_total > 0)
        {
            totalPages = (int)Math.Ceiling((double)_total / (double)_show);
        }

        btnFirst.Enabled = (_skip > 0);
        btnPrevious.Enabled = (_skip > 0);
        btnNext.Enabled = ((_skip + _show) < _total);
        btnLast.Enabled = ((_skip + _show) < _total);
        lbPage.Text = "Page " + currentPage + " of " + totalPages;

        btnFirst2.Enabled = (_skip > 0);
        btnPrevious2.Enabled = (_skip > 0);
        btnNext2.Enabled = ((_skip + _show) < _total);
        btnLast2.Enabled = ((_skip + _show) < _total);
        lbPage2.Text = "Page " + currentPage + " of " + totalPages;
    }


    private string GetBaseUrl()
    {
        string url = String.Empty;

        if (_basePage.IsRunningOnDevServer)
        {
            url = "http://dnadev.national.core.bbc.co.uk/dna/";
        }
        else if (_basePage.CurrentServerName.ToUpper().StartsWith("NMSDNA"))
        {
            url = "http://dna-staging.bbc.co.uk/dna/";
        }
        else if (_basePage.CurrentServerName.ToUpper().StartsWith("PC"))
        {
            url = "http://local.bbc.co.uk/dna/";
        }
        else
        {
            url = "http://www.bbc.co.uk/dna/";
        }
        return url;
    }
}
