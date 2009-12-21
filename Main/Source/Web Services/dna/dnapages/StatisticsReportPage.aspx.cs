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

public partial class StatisticsReportPage : BBC.Dna.Page.DnaWebPage
{
    private int _skip = 0;
    private int _show = 20;
    private int _total = 0;

    private const string _docDnaDate = @"Date of the Statistics to look at.";
    private const string _docDnaInterval = @"Interval of the Statistics to look at.";
    
    /// <summary>
    /// Constructor for the StatisticsReportPage Page
    /// </summary>
    public StatisticsReportPage()
    {
        UseDotNetRendering = true;
    }

    public override string PageType
    {
        get { return "STATISTICSREPORT"; }
    }

    /// <summary>
    /// Setup the page and initialise some of the controls
    /// </summary>
    /// <param name="e"></param>
    protected override void OnInit(EventArgs e)
    {
        DateTime now = DateTime.Now.Date;

        entryDate.SelectionMode = CalendarSelectionMode.Day;

        entryDate.SelectedDate = now;
        entryDate.VisibleDate = now;

        base.OnInit(e);
    }

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        Context.Items["VirtualUrl"] = "StatisticsReport";
        string skin = Request.GetParamStringOrEmpty("skin", "skin");
        string skParam = Request.GetParamStringOrEmpty("_sk", "skin");

        if (!IsDnaUserAllowed())
        {
            ShowHideControls(false);
            DisplayError("PermissionsError", "Insufficient permissions - Editor Status Required");
            return;
        }
        if (!Page.IsPostBack)
        {
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

            DateTime enteredDate = DateTime.MinValue;

            try
            {
                if (Request.DoesParamExist("date", _docDnaDate))
                {
                    string entryDateText = Request.GetParamStringOrEmpty("date", _docDnaDate);

                    DateRangeValidation dateValidation = new DateRangeValidation();
                    DateRangeValidation.ValidationResult isValid;

                    DateTime tempDate;

                    isValid = StatisticsReport.ParseDate(entryDateText, out tempDate);
                    if (isValid == DateRangeValidation.ValidationResult.VALID)
                    {
                        isValid = dateValidation.ValidateDate(tempDate, true);

                        if (isValid == DateRangeValidation.ValidationResult.FUTURE_STARTDATE)
                        {
                            DisplayError("DateError", "Passed in Date is in the future.");
                            return;
                        }
                        else if (isValid != DateRangeValidation.ValidationResult.VALID)
                        {
                            DisplayError("DateError", "Passed in Date not valid.");
                            return;
                        }
                        enteredDate = tempDate;
                    }
                    else
                    {
                        DisplayError("DateError", "Passed in Date not valid.");
                        return;
                    }
                }
                else
                {
                    enteredDate = DateTime.Now;
                }

                entryDate.SelectedDate = enteredDate.Date;
                entryDate.VisibleDate = enteredDate.Date;
            }
            catch (FormatException)
            {
                DisplayError("DateError", "Passed in Date format incorrect. It should be yyyy/mm/dd");
                return;
            }
            interval.SelectedValue = "1";
            if (Request.DoesParamExist("interval", _docDnaInterval))
            {
                string intervalText = Request.GetParamStringOrEmpty("interval", _docDnaInterval);
                if (intervalText == "week")
                {
                    interval.SelectedValue = "2";
                }
                else if (intervalText == "month")
                {
                    interval.SelectedValue = "3";
                }

            }

            if (skin == "purexml" || skParam == "purexml")
            {
                GetStatisticsReport(true);
            }
            else
            {
                GetStatisticsReport(false);
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
        GetStatisticsReport(false);
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
        interval.Visible = show;
        lblInterval.Visible = show;
        entryDate.Visible = show;
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
    /// Generates the results
    /// </summary>
    /// <param name="purexml">Whether to just produce the XML</param>
    private void GetStatisticsReport(bool purexml)
    {
        tblResults.Rows.Clear();
        Count.Text = "";
        lblEntryError.Text = String.Empty;

        DateTime entryDateTime = entryDate.SelectedDate;

        int intervalvalue = 1;
        Int32.TryParse(interval.SelectedValue, out intervalvalue);

        StatisticsReport statisticsReport = new StatisticsReport(_basePage);
        statisticsReport.TryCreateStatisticsReportXML(_skip, _show, entryDateTime, intervalvalue);

        if (!purexml)
        {
            DisplayStatisticsReport(statisticsReport);
        }
        else
        {
            //Replace an existing node
            if (_basePage.WholePageBaseXmlNode.SelectSingleNode("/POSTING-STATISTICS") != null)
            {
                XmlNode statisticsReportNode = _basePage.WholePageBaseXmlNode.SelectSingleNode("/POSTING-STATISTICS");

                _basePage.WholePageBaseXmlNode.ReplaceChild(statisticsReportNode, _basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(statisticsReport.RootElement.FirstChild, true));
            }
            else
            {
                _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(statisticsReport.RootElement.FirstChild, true));
            }
        }
    }

    private void DisplayError(string errorType, string errorMessage)
    {
        string skin = Request.GetParamStringOrEmpty("skin", "skin");
        string skParam = Request.GetParamStringOrEmpty("_sk", "skin");
        if (skin == "purexml" || skParam == "purexml")
        {
            AddDNAErrorXML(errorType, errorMessage);
        }
        else
        {
            lblError.Text = errorMessage;
        }
    }

    private void AddDNAErrorXML(string errorType, string errorMessage)
    {
        XmlElement error = (XmlElement) _basePage.WholePageBaseXmlNode.OwnerDocument.CreateNode(XmlNodeType.Element, "ERROR", null);
        error.InnerText = errorMessage;
        error.SetAttribute("TYPE", errorType);
        _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(error);
    }

    private void DisplayStatisticsReport(StatisticsReport statisticsReport)
    {
        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int postingsCount = 0;

        foreach (XmlNode postings in statisticsReport.RootElement.SelectNodes(@"POSTING-STATISTICS/POSTINGS"))
        {
            if (count == 0)
            {
                TableHeaderCell headerSiteCell = new TableHeaderCell();
                headerSiteCell.Text = "Site";
                headerSiteCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerSiteCell);

                TableHeaderCell headerURLNameCell = new TableHeaderCell();
                headerURLNameCell.Text = "Site Name";
                headerURLNameCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerURLNameCell);

                TableHeaderCell headerForumIDCell = new TableHeaderCell();
                headerForumIDCell.Text = "Forum ID";
                headerForumIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerForumIDCell);

                TableHeaderCell headerIsMessageBoardCell = new TableHeaderCell();
                headerIsMessageBoardCell.Text = "Is Messageboard";
                headerIsMessageBoardCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerIsMessageBoardCell);

                TableHeaderCell headerTitleCell = new TableHeaderCell();
                headerTitleCell.Text = "Title";
                headerTitleCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTitleCell);

                TableHeaderCell headerTotalPostsCell = new TableHeaderCell();
                headerTotalPostsCell.Text = "Total Posts";
                headerTotalPostsCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTotalPostsCell);

                TableHeaderCell headerTotalUsersCell = new TableHeaderCell();
                headerTotalUsersCell.Text = "Total Users";
                headerTotalUsersCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTotalUsersCell);
            }

            TableRow row = new TableRow();
            string forumID = String.Empty;
            if (postings.SelectSingleNode(@"@FORUMID") != null)
            {
                forumID = postings.SelectSingleNode(@"@FORUMID").InnerText;
            }

            string title = String.Empty;
            if (postings.SelectSingleNode(@"@TITLE") != null)
            {
                title = postings.SelectSingleNode(@"@TITLE").InnerText;
            }

            postingsCount++;

            if (postingsCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            string siteID = postings.SelectSingleNode(@"@SITEID").InnerText;
            string siteName = postings.SelectSingleNode(@"@URLNAME").InnerText;
            string isMessageboard = postings.SelectSingleNode(@"@ISMESSAGEBOARD").InnerText;
            string totalPosts = postings.SelectSingleNode(@"@TOTALPOSTS").InnerText;
            string totalUsers = postings.SelectSingleNode(@"@TOTALUSERS").InnerText;

            TableCell siteIDCell = new TableCell();
            siteIDCell.HorizontalAlign = HorizontalAlign.Center;
            siteIDCell.Text = siteID;
            row.Cells.Add(siteIDCell);

            TableCell siteCell = new TableCell();
            siteCell.HorizontalAlign = HorizontalAlign.Center;
            siteCell.Text = siteName;
            row.Cells.Add(siteCell);

            TableCell forumIDCell = new TableCell();
            forumIDCell.HorizontalAlign = HorizontalAlign.Center;
            forumIDCell.Text = forumID;
            HyperLink forumTitleLink = new HyperLink();
            forumTitleLink.NavigateUrl = GetBaseUrl() + siteName + @"/F" + forumID;
            forumIDCell.Controls.Add(forumTitleLink);
            row.Cells.Add(forumIDCell);

            TableCell isMessageboardCell = new TableCell();
            isMessageboardCell.HorizontalAlign = HorizontalAlign.Center;
            isMessageboardCell.Text = isMessageboard;
            row.Cells.Add(isMessageboardCell);

            TableCell titleCell = new TableCell();
            titleCell.HorizontalAlign = HorizontalAlign.Center;
            titleCell.Text = title;
            row.Cells.Add(titleCell);

            TableCell totalPostsCell = new TableCell();
            totalPostsCell.HorizontalAlign = HorizontalAlign.Center;
            totalPostsCell.Text = totalPosts;
            row.Cells.Add(totalPostsCell);

            TableCell totalUsersCell = new TableCell();
            totalUsersCell.HorizontalAlign = HorizontalAlign.Center;
            totalUsersCell.Text = totalUsers;
            row.Cells.Add(totalUsersCell);

            tblResults.Rows.Add(row);
            count++;
        }

        _total = 0;
        string postStatsTotal = statisticsReport.RootElement.SelectSingleNode(@"POSTING-STATISTICS/@TOTAL").InnerText;
        if (postStatsTotal != null)
        {
            Int32.TryParse(postStatsTotal, out _total);
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
        GetStatisticsReport(false);
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
        GetStatisticsReport(false);
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
        GetStatisticsReport(false);
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
        GetStatisticsReport(false);
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
