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

public partial class MessageBoardStatsPage : BBC.Dna.Page.DnaWebPage
{
    private const string _docDnaDate = @"Date of the MessageBoard Statistics to look at.";
    
    /// <summary>
    /// Constructor for the MessageBoardStatsPage Page
    /// </summary>
    public MessageBoardStatsPage()
    {
        UseDotNetRendering = true;
    }

    public override string PageType
    {
        get { return "MESSAGEBOARDSTATS"; }
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
        Context.Items["VirtualUrl"] = "MessageBoardStats";
        string skin = Request.GetParamStringOrEmpty("skin", "skin");

        if (!IsDnaUserAllowed())
        {
            if (skin != "purexml")
            {
                ShowHideControls(false);
                lblError.Text = "Insufficient permissions - Editor Status Required";
            }
            else
            {
                XmlDocument errorDoc = new XmlDocument();
                errorDoc.LoadXml("<ERROR TYPE='invalidcredentials' ERRORMESSAGE = 'Must be an editor or superuser to view messageboard statistics' />");

                //Replace an existing node
                if (_basePage.WholePageBaseXmlNode.SelectSingleNode("/MESSAGEBOARDSTATS") != null)
                {
                    XmlNode messageBoardStatisticsNode = _basePage.WholePageBaseXmlNode.SelectSingleNode("/MESSAGEBOARDSTATS");

                    _basePage.WholePageBaseXmlNode.ReplaceChild(messageBoardStatisticsNode, _basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(errorDoc.FirstChild, true));
                }
                else
                {
                    _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(errorDoc.FirstChild, true));
                }
            }
            return;
        }
        if (!Page.IsPostBack)
        {
            DateTime enteredDate = DateTime.MinValue;

            try
            {
                if (Request.DoesParamExist("date", _docDnaDate))
                {
                    string entryDateText = Request.GetParamStringOrEmpty("date", _docDnaDate);

                    DateRangeValidation dateValidation = new DateRangeValidation();
                    DateRangeValidation.ValidationResult isValid;

                    DateTime tempDate;

                    isValid = MessageBoardStatistics.ParseDate(entryDateText, out tempDate);
                    if (isValid == DateRangeValidation.ValidationResult.VALID)
                    {
                        isValid = dateValidation.ValidateDate(tempDate, true);

                        if (isValid == DateRangeValidation.ValidationResult.FUTURE_STARTDATE)
                        {
                            lblError.Text = "Passed in Date is in the future.";
                            return;
                        }
                        else if (isValid != DateRangeValidation.ValidationResult.VALID)
                        {
                            lblError.Text = "Passed in Date not valid.";
                            return;
                        }
                        enteredDate = tempDate;
                    }
                    else
                    {
                        lblError.Text = "Passed in Date not valid.";
                        return;
                    }
                }
                else
                {
                    //Yesterday
                    enteredDate = DateTime.Now.AddDays(-1).Date;
                }

                entryDate.SelectedDate = enteredDate.Date;
                entryDate.VisibleDate = enteredDate.Date;
            }
            catch (FormatException)
            {
                lblError.Text = "Passed in Date format incorrect. It should be dd/mm/yyyy";
                return;
            }

            if (skin != "purexml")
            {
                GetMessageBoardStatistics(false);

                ShowHideControls(true);
            }
            else
            {
                GetMessageBoardStatistics(true);
            }

            string emailFrom = Request.GetParamStringOrEmpty("emailFrom", "emailFrom address");
            string emailTo = Request.GetParamStringOrEmpty("emailTo", "emailTo address");

            MessageBoardStatistics messageBoardStatistics = new MessageBoardStatistics(_basePage);
            messageBoardStatistics.SendMessageBoardStatsEmail(enteredDate, emailFrom, emailTo);
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
        GetMessageBoardStatistics(false);
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
        entryDate.Visible = show;
        lblSearchParams.Visible = show;
    }

    private void ShowHideResultControls(bool show)
    {
        tblModStatsPerTopic.Visible = show;
        tblModStatsTopicTotals.Visible = show;
        tblHostsPostsPerTopic.Visible = show;
        lblModStatsPerTopic.Visible = show;
        lblModStatsTopicTotals.Visible = show;
        lblHostsPostsPerTopic.Visible = show;
    }

    /// <summary>
    /// Generates the results
    /// </summary>
    /// <param name="purexml">Whether to just produce the XML</param>
    private void GetMessageBoardStatistics(bool purexml)
    {
        tblModStatsPerTopic.Rows.Clear();
        tblModStatsTopicTotals.Rows.Clear();
        tblHostsPostsPerTopic.Rows.Clear();
        lblEntryError.Text = String.Empty;

        DateTime entryDateTime = entryDate.SelectedDate;

        if (entryDateTime >= DateTime.Now.Date)
        {
            lblEntryError.Text = "The date selected must be before today.";
            return;
        }

        MessageBoardStatistics messageBoardStatistics = new MessageBoardStatistics(_basePage);
        messageBoardStatistics.TryCreateMessageBoardStatisticsXML(entryDateTime);

        if (!purexml)
        {
            DisplayMessageBoardStatistics(messageBoardStatistics);
        }
        else
        {
            //Replace an existing node
            if (_basePage.WholePageBaseXmlNode.SelectSingleNode("/MESSAGEBOARDSTATS") != null)
            {
                XmlNode messageBoardStatisticsNode = _basePage.WholePageBaseXmlNode.SelectSingleNode("/MESSAGEBOARDSTATS");

                _basePage.WholePageBaseXmlNode.ReplaceChild(messageBoardStatisticsNode, _basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(messageBoardStatistics.RootElement.FirstChild, true));
            }
            else
            {
                _basePage.WholePageBaseXmlNode.FirstChild.AppendChild(_basePage.WholePageBaseXmlNode.OwnerDocument.ImportNode(messageBoardStatistics.RootElement.FirstChild, true));
            }
        }
    }

    private void DisplayMessageBoardStatistics(MessageBoardStatistics messageBoardStatistics)
    {
        DisplayModStatsPerTopic(messageBoardStatistics);
        DisplayModStatsTopicTotals(messageBoardStatistics);
        DisplayHostsPostsPerTopic(messageBoardStatistics);

        ShowHideResultControls(true);
    }

    private void DisplayModStatsPerTopic(MessageBoardStatistics messageBoardStatistics)
    {
        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int modStatsPerTopicCount = 0;

        foreach (XmlNode topicModStat in messageBoardStatistics.RootElement.SelectNodes(@"MESSAGEBOARDSTATS/MODSTATSPERTOPIC/TOPICMODSTAT"))
        {
            if (count == 0)
            {
                TableHeaderCell headerTopicTitleCell = new TableHeaderCell();
                headerTopicTitleCell.Text = "Topic Title";
                headerTopicTitleCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTopicTitleCell);

                TableHeaderCell headerForumIDCell = new TableHeaderCell();
                headerForumIDCell.Text = "Forum ID";
                headerForumIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerForumIDCell);

                TableHeaderCell headerUserIDCell = new TableHeaderCell();
                headerUserIDCell.Text = "User ID";
                headerUserIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerUserIDCell);

                TableHeaderCell headerUserNameCell = new TableHeaderCell();
                headerUserNameCell.Text = "User Name";
                headerUserNameCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerUserNameCell);

                TableHeaderCell headerEmailCell = new TableHeaderCell();
                headerEmailCell.Text = "Email";
                headerEmailCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerEmailCell);

                TableHeaderCell headerPassedCell = new TableHeaderCell();
                headerPassedCell.Text = "Passed";
                headerPassedCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerPassedCell);

                TableHeaderCell headerFailedCell = new TableHeaderCell();
                headerFailedCell.Text = "Failed";
                headerFailedCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerFailedCell);

                TableHeaderCell headerReferredCell = new TableHeaderCell();
                headerReferredCell.Text = "Referred";
                headerReferredCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerReferredCell);
            }

            TableRow row = new TableRow();
            string topicTitle = String.Empty;
            if (topicModStat.SelectSingleNode(@"TOPICTITLE") != null)
            {
                topicTitle = topicModStat.SelectSingleNode(@"TOPICTITLE").InnerText;
            }
            string forumID = String.Empty;
            if (topicModStat.SelectSingleNode(@"FORUMID") != null)
            {
                forumID = topicModStat.SelectSingleNode(@"FORUMID").InnerText;
            }
            string userID = String.Empty;
            if (topicModStat.SelectSingleNode(@"USERID") != null)
            {
                userID = topicModStat.SelectSingleNode(@"USERID").InnerText;
            }
            string userName = String.Empty;
            if (topicModStat.SelectSingleNode(@"USERNAME") != null)
            {
                userName = topicModStat.SelectSingleNode(@"USERNAME").InnerText;
            }
            string email = String.Empty;
            if (topicModStat.SelectSingleNode(@"EMAIL") != null)
            {
                email = topicModStat.SelectSingleNode(@"EMAIL").InnerText;
            }
            string passed = String.Empty;
            if (topicModStat.SelectSingleNode(@"PASSED") != null)
            {
                passed = topicModStat.SelectSingleNode(@"PASSED").InnerText;
            }
            string failed = String.Empty;
            if (topicModStat.SelectSingleNode(@"FAILED") != null)
            {
                failed = topicModStat.SelectSingleNode(@"FAILED").InnerText;
            }
            string referred = String.Empty;
            if (topicModStat.SelectSingleNode(@"REFERRED") != null)
            {
                referred = topicModStat.SelectSingleNode(@"REFERRED").InnerText;
            }

            modStatsPerTopicCount++;

            if (modStatsPerTopicCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            TableCell topicTitleCell = new TableCell();
            topicTitleCell.HorizontalAlign = HorizontalAlign.Center;
            topicTitleCell.Text = topicTitle;
            row.Cells.Add(topicTitleCell);

            TableCell forumIDCell = new TableCell();
            forumIDCell.HorizontalAlign = HorizontalAlign.Center;
            HyperLink forumTitleLink = new HyperLink();
            forumTitleLink.NavigateUrl = GetBaseUrl() + _basePage.CurrentSite.SiteName + @"/F" + forumID;
            forumTitleLink.Text = forumID;
            forumIDCell.Controls.Add(forumTitleLink);
            row.Cells.Add(forumIDCell);

            TableCell userIDCell = new TableCell();
            userIDCell.HorizontalAlign = HorizontalAlign.Center;
            HyperLink userIDLink = new HyperLink();
            userIDLink.NavigateUrl = GetBaseUrl() + _basePage.CurrentSite.SiteName + @"/MemberDetailsAdmin?userid=" + userID;
            userIDLink.Text = userID;
            userIDCell.Controls.Add(userIDLink);
            row.Cells.Add(userIDCell);

            TableCell userNameCell = new TableCell();
            userNameCell.HorizontalAlign = HorizontalAlign.Center;
            userNameCell.Text = userName;
            row.Cells.Add(userNameCell);

            TableCell emailCell = new TableCell();
            emailCell.HorizontalAlign = HorizontalAlign.Center;
            emailCell.Text = email;
            row.Cells.Add(emailCell);

            TableCell passedCell = new TableCell();
            passedCell.HorizontalAlign = HorizontalAlign.Center;
            passedCell.Text = passed;
            row.Cells.Add(passedCell);

            TableCell failedCell = new TableCell();
            failedCell.HorizontalAlign = HorizontalAlign.Center;
            failedCell.Text = failed;
            row.Cells.Add(failedCell);

            TableCell referredCell = new TableCell();
            referredCell.HorizontalAlign = HorizontalAlign.Center;
            referredCell.Text = referred;
            row.Cells.Add(referredCell);

            tblModStatsPerTopic.Rows.Add(row);
            count++;
        }

        if (count == 0)
        {
            TableRow nodatarow = new TableRow();
            TableCell nodataCell = new TableCell();
            nodataCell.ColumnSpan = 4;
            nodataCell.Text = @"No data for those details";
            nodatarow.Cells.Add(nodataCell);
            tblModStatsPerTopic.Rows.Add(nodatarow);
        }

        tblModStatsPerTopic.Rows.AddAt(0, headerRow);

        tblModStatsPerTopic.CellSpacing = 5;
        tblModStatsPerTopic.BorderWidth = 2;
        tblModStatsPerTopic.BorderStyle = BorderStyle.Outset;
    }

    private void DisplayModStatsTopicTotals(MessageBoardStatistics messageBoardStatistics)
    {
        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int modStatsPerTopicCount = 0;

        foreach (XmlNode topicTotal in messageBoardStatistics.RootElement.SelectNodes(@"MESSAGEBOARDSTATS/MODSTATSTOPICTOTALS/TOPICTOTALS"))
        {
            if (count == 0)
            {
                TableHeaderCell headerTopicTitleCell = new TableHeaderCell();
                headerTopicTitleCell.Text = "Topic Title";
                headerTopicTitleCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTopicTitleCell);

                TableHeaderCell headerForumIDCell = new TableHeaderCell();
                headerForumIDCell.Text = "Forum ID";
                headerForumIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerForumIDCell);

                TableHeaderCell headerPassedCell = new TableHeaderCell();
                headerPassedCell.Text = "Passed";
                headerPassedCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerPassedCell);

                TableHeaderCell headerFailedCell = new TableHeaderCell();
                headerFailedCell.Text = "Failed";
                headerFailedCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerFailedCell);

                TableHeaderCell headerReferredCell = new TableHeaderCell();
                headerReferredCell.Text = "Referred";
                headerReferredCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerReferredCell);

                TableHeaderCell headerComplaintsCell = new TableHeaderCell();
                headerComplaintsCell.Text = "Complaints";
                headerComplaintsCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerComplaintsCell);

                TableHeaderCell headerTotalCell = new TableHeaderCell();
                headerTotalCell.Text = "Total";
                headerTotalCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTotalCell);
            }

            TableRow row = new TableRow();
            string topicTitle = String.Empty;
            if (topicTotal.SelectSingleNode(@"TOPICTITLE") != null)
            {
                topicTitle = topicTotal.SelectSingleNode(@"TOPICTITLE").InnerText;
            }
            string forumID = String.Empty;
            if (topicTotal.SelectSingleNode(@"FORUMID") != null)
            {
                forumID = topicTotal.SelectSingleNode(@"FORUMID").InnerText;
            }
            string passed = String.Empty;
            if (topicTotal.SelectSingleNode(@"PASSED") != null)
            {
                passed = topicTotal.SelectSingleNode(@"PASSED").InnerText;
            }
            string failed = String.Empty;
            if (topicTotal.SelectSingleNode(@"FAILED") != null)
            {
                failed = topicTotal.SelectSingleNode(@"FAILED").InnerText;
            }
            string referred = String.Empty;
            if (topicTotal.SelectSingleNode(@"REFERRED") != null)
            {
                referred = topicTotal.SelectSingleNode(@"REFERRED").InnerText;
            }
            string complaints = String.Empty;
            if (topicTotal.SelectSingleNode(@"COMPLAINTS") != null)
            {
                complaints = topicTotal.SelectSingleNode(@"COMPLAINTS").InnerText;
            }
            string total = String.Empty;
            if (topicTotal.SelectSingleNode(@"TOTAL") != null)
            {
                total = topicTotal.SelectSingleNode(@"TOTAL").InnerText;
            }

            modStatsPerTopicCount++;

            if (modStatsPerTopicCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            TableCell topicTitleCell = new TableCell();
            topicTitleCell.HorizontalAlign = HorizontalAlign.Center;
            topicTitleCell.Text = topicTitle;
            row.Cells.Add(topicTitleCell);

            TableCell forumIDCell = new TableCell();
            forumIDCell.HorizontalAlign = HorizontalAlign.Center;
            HyperLink forumTitleLink = new HyperLink();
            forumTitleLink.NavigateUrl = GetBaseUrl() + _basePage.CurrentSite.SiteName + @"/F" + forumID;
            forumTitleLink.Text = forumID;
            forumIDCell.Controls.Add(forumTitleLink);
            row.Cells.Add(forumIDCell);

            TableCell topicPassedCell = new TableCell();
            topicPassedCell.HorizontalAlign = HorizontalAlign.Center;
            topicPassedCell.Text = passed;
            row.Cells.Add(topicPassedCell);

            TableCell topicFailedCell = new TableCell();
            topicFailedCell.HorizontalAlign = HorizontalAlign.Center;
            topicFailedCell.Text = failed;
            row.Cells.Add(topicFailedCell);

            TableCell topicReferredCell = new TableCell();
            topicReferredCell.HorizontalAlign = HorizontalAlign.Center;
            topicReferredCell.Text = referred;
            row.Cells.Add(topicReferredCell);

            TableCell topicComplaintsCell = new TableCell();
            topicComplaintsCell.HorizontalAlign = HorizontalAlign.Center;
            topicComplaintsCell.Text = complaints;
            row.Cells.Add(topicComplaintsCell);

            TableCell topicTotalCell = new TableCell();
            topicTotalCell.HorizontalAlign = HorizontalAlign.Center;
            topicTotalCell.Text = total;
            row.Cells.Add(topicTotalCell);

            tblModStatsTopicTotals.Rows.Add(row);
            count++;
        }

        if (count == 0)
        {
            TableRow nodatarow = new TableRow();
            TableCell nodataCell = new TableCell();
            nodataCell.ColumnSpan = 4;
            nodataCell.Text = @"No data for those details";
            nodatarow.Cells.Add(nodataCell);
            tblModStatsTopicTotals.Rows.Add(nodatarow);
        }

        tblModStatsTopicTotals.Rows.AddAt(0, headerRow);

        tblModStatsTopicTotals.CellSpacing = 5;
        tblModStatsTopicTotals.BorderWidth = 2;
        tblModStatsTopicTotals.BorderStyle = BorderStyle.Outset;
    }

    private void DisplayHostsPostsPerTopic(MessageBoardStatistics messageBoardStatistics)
    {
        int count = 0;
        TableHeaderRow headerRow = new TableHeaderRow();
        headerRow.BackColor = Color.MistyRose;

        int hostsPostsPerTopicCount = 0;

        foreach (XmlNode hostPostsInTopic in messageBoardStatistics.RootElement.SelectNodes(@"MESSAGEBOARDSTATS/HOSTSPOSTSPERTOPIC/HOSTPOSTSINTOPIC"))
        {
            if (count == 0)
            {
                TableHeaderCell headerUserIDCell = new TableHeaderCell();
                headerUserIDCell.Text = "User ID";
                headerUserIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerUserIDCell);

                TableHeaderCell headerUserNameCell = new TableHeaderCell();
                headerUserNameCell.Text = "User Name";
                headerUserNameCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerUserNameCell);

                TableHeaderCell headerEmailCell = new TableHeaderCell();
                headerEmailCell.Text = "Email";
                headerEmailCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerEmailCell);

                TableHeaderCell headerTopicTitleCell = new TableHeaderCell();
                headerTopicTitleCell.Text = "Topic Title";
                headerTopicTitleCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTopicTitleCell);

                TableHeaderCell headerForumIDCell = new TableHeaderCell();
                headerForumIDCell.Text = "Forum ID";
                headerForumIDCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerForumIDCell);

                TableHeaderCell headerTotalCell = new TableHeaderCell();
                headerTotalCell.Text = "Total Posts";
                headerTotalCell.Scope = TableHeaderScope.Column;
                headerRow.Cells.Add(headerTotalCell);
            }

            TableRow row = new TableRow();
            string userID = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"USERID") != null)
            {
                userID = hostPostsInTopic.SelectSingleNode(@"USERID").InnerText;
            }
            string userName = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"USERNAME") != null)
            {
                userName = hostPostsInTopic.SelectSingleNode(@"USERNAME").InnerText;
            }
            string email = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"EMAIL") != null)
            {
                email = hostPostsInTopic.SelectSingleNode(@"EMAIL").InnerText;
            }
            string topicTitle = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"TOPICTITLE") != null)
            {
                topicTitle = hostPostsInTopic.SelectSingleNode(@"TOPICTITLE").InnerText;
            }
            string forumID = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"FORUMID") != null)
            {
                forumID = hostPostsInTopic.SelectSingleNode(@"FORUMID").InnerText;
            }
            string totalPosts = String.Empty;
            if (hostPostsInTopic.SelectSingleNode(@"TOTALPOSTS") != null)
            {
                totalPosts = hostPostsInTopic.SelectSingleNode(@"TOTALPOSTS").InnerText;
            }

            hostsPostsPerTopicCount++;

            if (hostsPostsPerTopicCount % 2 == 0)
                row.BackColor = Color.LightGray;
            else
                row.BackColor = Color.Linen;

            TableCell userIDCell = new TableCell();
            userIDCell.HorizontalAlign = HorizontalAlign.Center;
            HyperLink userIDLink = new HyperLink();
            userIDLink.NavigateUrl = GetBaseUrl() + _basePage.CurrentSite.SiteName + @"/MemberDetailsAdmin?userid=" + userID;
            userIDLink.Text = userID;
            userIDCell.Controls.Add(userIDLink);
            row.Cells.Add(userIDCell);

            TableCell userNameCell = new TableCell();
            userNameCell.HorizontalAlign = HorizontalAlign.Center;
            userNameCell.Text = userName;
            row.Cells.Add(userNameCell);

            TableCell emailCell = new TableCell();
            emailCell.HorizontalAlign = HorizontalAlign.Center;
            emailCell.Text = email;
            row.Cells.Add(emailCell);

            TableCell topicTitleCell = new TableCell();
            topicTitleCell.HorizontalAlign = HorizontalAlign.Center;
            topicTitleCell.Text = topicTitle;
            row.Cells.Add(topicTitleCell);

            TableCell forumIDCell = new TableCell();
            forumIDCell.HorizontalAlign = HorizontalAlign.Center;
            HyperLink forumIDLink = new HyperLink();
            forumIDLink.NavigateUrl = GetBaseUrl() + _basePage.CurrentSite.SiteName + @"/F" + forumID;
            forumIDLink.Text = forumID;
            forumIDCell.Controls.Add(forumIDLink);
            row.Cells.Add(forumIDCell);

            TableCell totalPostsCell = new TableCell();
            totalPostsCell.HorizontalAlign = HorizontalAlign.Center;
            totalPostsCell.Text = totalPosts;
            row.Cells.Add(totalPostsCell);

            tblHostsPostsPerTopic.Rows.Add(row);
            count++;
        }

        if (count == 0)
        {
            TableRow nodatarow = new TableRow();
            TableCell nodataCell = new TableCell();
            nodataCell.ColumnSpan = 4;
            nodataCell.Text = @"No data for those details";
            nodatarow.Cells.Add(nodataCell);
            tblHostsPostsPerTopic.Rows.Add(nodatarow);
        }

        tblHostsPostsPerTopic.Rows.AddAt(0, headerRow);

        tblHostsPostsPerTopic.CellSpacing = 5;
        tblHostsPostsPerTopic.BorderWidth = 2;
        tblHostsPostsPerTopic.BorderStyle = BorderStyle.Outset;
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
