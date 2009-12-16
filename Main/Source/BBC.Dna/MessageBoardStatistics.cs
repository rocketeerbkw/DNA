using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Simple class to hold ModStatsPerTopic
    /// </summary>
    public class ModStatsPerTopic
    {
        private int _forumID = 0;
        private int _userID = 0;
        private int _numFail = 0;
        private int _numPass = 0;
        private int _numRefer = 0;

        private string _topicTitle = String.Empty;
        private string _userName = String.Empty;
        private string _email = String.Empty;

        /// <summary>
        /// Accessor for ForumID
        /// </summary>
        public int ForumID
        {
            get { return _forumID; }
            set { _forumID = value; }
        }
        /// <summary>
        /// Accessor for UserID
        /// </summary>
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; }
        }
        /// <summary>
        /// Accessor for NumFail
        /// </summary>
        public int NumFail
        {
            get { return _numFail; }
            set { _numFail = value; }
        }
        /// <summary>
        /// Accessor for NumPass
        /// </summary>
        public int NumPass
        {
            get { return _numPass; }
            set { _numPass = value; }
        }
        /// <summary>
        /// Accessor for NumRefer
        /// </summary>
        public int NumRefer
        {
            get { return _numRefer; }
            set { _numRefer = value; }
        }
        /// <summary>
        /// Accessor for TopicTitle
        /// </summary>
        public string TopicTitle
        {
            get { return _topicTitle; }
            set { _topicTitle = value; }
        }
        /// <summary>
        /// Accessor for UserName
        /// </summary>
        public string UserName
        {
            get { return _userName; }
            set { _userName = value; }
        }
        /// <summary>
        /// Accessor for Email
        /// </summary>
        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }
    }

    /// <summary>
    /// Simple class to hold ModStatsTopicTotals
    /// </summary>
    public class ModStatsTopicTotals
    {
        private int _forumID = 0;
        private int _numFail = 0;
        private int _numPass = 0;
        private int _numRefer = 0;
        private int _numComplaints = 0;
        private int _total = 0;

        private string _topicTitle = String.Empty;

        /// <summary>
        /// Accessor for ForumID
        /// </summary>
        public int ForumID
        {
            get { return _forumID; }
            set { _forumID = value; }
        }
        /// <summary>
        /// Accessor for TopicTitle
        /// </summary>
        public string TopicTitle
        {
            get { return _topicTitle; }
            set { _topicTitle = value; }
        }
        /// <summary>
        /// Accessor for NumFail
        /// </summary>
        public int NumFail
        {
            get { return _numFail; }
            set { _numFail = value; }
        }
        /// <summary>
        /// Accessor for NumPass
        /// </summary>
        public int NumPass
        {
            get { return _numPass; }
            set { _numPass = value; }
        }
        /// <summary>
        /// Accessor for NumRefer
        /// </summary>
        public int NumRefer
        {
            get { return _numRefer; }
            set { _numRefer = value; }
        }
        /// <summary>
        /// Accessor for NumComplaints
        /// </summary>
        public int NumComplaints
        {
            get { return _numComplaints; }
            set { _numComplaints = value; }
        }
        /// <summary>
        /// Accessor for Total
        /// </summary>
        public int Total
        {
            get { return _total; }
            set { _total = value; }
        }
    }

    /// <summary>
    /// Simple class to hold HostsPostsPerTopic
    /// </summary>
    public class HostsPostsPerTopic
    {
        private int _forumID = 0;
        private int _userID = 0;
        private int _totalPosts = 0;

        private string _topicTitle = String.Empty;
        private string _userName = String.Empty;
        private string _email = String.Empty;

        /// <summary>
        /// Accessor for ForumID
        /// </summary>
        public int ForumID
        {
            get { return _forumID; }
            set { _forumID = value; }
        }
        /// <summary>
        /// Accessor for UserID
        /// </summary>
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; }
        }
        /// <summary>
        /// Accessor for TotalPosts
        /// </summary>
        public int TotalPosts
        {
            get { return _totalPosts; }
            set { _totalPosts = value; }
        }
        /// <summary>
        /// Accessor for TopicTitle
        /// </summary>
        public string TopicTitle
        {
            get { return _topicTitle; }
            set { _topicTitle = value; }
        }
        /// <summary>
        /// Accessor for UserName
        /// </summary>
        public string UserName
        {
            get { return _userName; }
            set { _userName = value; }
        }
        /// <summary>
        /// Accessor for Email
        /// </summary>
        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }
    }

    /// <summary>
    /// Summary of the MessageBoardStatistics Page object, holds the MessageBoardStatistics for a date and site
    /// </summary>
    public class MessageBoardStatistics : DnaInputComponent
    {
        private const string _docDnaEntryDate = @"Entered Date of the MessageBoard Statistics to look at.";
        private const string _docDnaEmailFrom = @"Entered Email From Date of the MessageBoard Statistics to look at.";
        private const string _docDnaEmailTo = @"Entered Email To Date of the MessageBoard Statistics to look at.";
                    
        /// <summary>
        /// Default constructor for the MessageBoardStatistics component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MessageBoardStatistics(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            DateTime entryDate = DateTime.MinValue;
            string emailFrom = String.Empty;
            string emailTo = String.Empty;

            TryGetPageParams(ref entryDate, ref emailFrom, ref emailTo);

            TryCreateMessageBoardStatisticsXML(entryDate);

            if (emailFrom != String.Empty && emailTo != String.Empty)
            {
                SendMessageBoardStatsEmail(entryDate, emailFrom, emailTo);
            }
        }

 
        /// <summary>
        /// Functions generates the Create MessageBoard Statistics XML
        /// </summary>
        /// <param name="entryDate">Entry Date</param>
        public void TryCreateMessageBoardStatisticsXML(DateTime entryDate)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            //Must be logged in.
            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be logged in to view messageboard statistics.", RootElement);
                return;
            }
            if (!InputContext.ViewingUser.IsEditor && !InputContext.ViewingUser.IsSuperUser)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be an editor or superuser to view messageboard statistics.", RootElement);
                return;
            }
            int siteID = InputContext.CurrentSite.SiteID;

            XmlElement messageBoardStatistics = AddElementTag(RootElement, "MESSAGEBOARDSTATS");
            AddIntElement(messageBoardStatistics, "SITEID", siteID);
            AddDateXml(entryDate, messageBoardStatistics, "DAY");

            // Generate the rest of the XML for this page
            GenerateModStatsPerTopic(messageBoardStatistics, siteID, entryDate);
            GenerateModStatsTopicTotals(messageBoardStatistics, siteID, entryDate);
            GenerateHostsPostsPerTopic(messageBoardStatistics, siteID, entryDate);
        }

        private void GenerateModStatsPerTopic(XmlElement messageBoardStatistics, int siteID, DateTime entryDate)
        {
            Dictionary<string, object> modStatsPerTopic = new Dictionary<string,object> ();
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmbstatsmodstatspertopic"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("date", entryDate);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int forumID = dataReader.GetInt32NullAsZero("ForumID");
                        int userID = dataReader.GetInt32NullAsZero("UserID");

                        string key = forumID.ToString();
                        key += userID.ToString();

                        if (!modStatsPerTopic.ContainsKey(key))
                        {
                            ModStatsPerTopic tmpobj = new ModStatsPerTopic();
                            tmpobj.ForumID = forumID;
                            tmpobj.UserID = userID;

                            tmpobj.TopicTitle = dataReader.GetStringNullAsEmpty("TopicTitle");
                            tmpobj.UserName = dataReader.GetStringNullAsEmpty("UserName");
                            tmpobj.Email = dataReader.GetStringNullAsEmpty("Email");

                            modStatsPerTopic.Add(key, tmpobj);
                        }

                        int statusID = dataReader.GetInt32NullAsZero("StatusID");
                        int total = dataReader.GetInt32NullAsZero("Total");
                        switch (statusID)
                        {
                            case 2: ((ModStatsPerTopic) modStatsPerTopic[key]).NumRefer = total; break;
                            case 3: ((ModStatsPerTopic) modStatsPerTopic[key]).NumPass = total; break;
                            case 4: ((ModStatsPerTopic) modStatsPerTopic[key]).NumFail = total; break;
                        }

                    }
                }
            }
            GenerateModStatPerTopicXML(messageBoardStatistics, modStatsPerTopic);
        }

        private void GenerateModStatPerTopicXML(XmlElement messageBoardStatistics, Dictionary<string, object> modStatsPerTopic)
        {
            XmlElement modStatsPerTopicElement = AddElementTag(messageBoardStatistics, "MODSTATSPERTOPIC");
            foreach (ModStatsPerTopic modStatPerTopic in modStatsPerTopic.Values)
            {
                XmlElement topicModStat = AddElementTag(modStatsPerTopicElement, "TOPICMODSTAT");
                AddTextTag(topicModStat, "TOPICTITLE", modStatPerTopic.TopicTitle);
                AddIntElement(topicModStat, "FORUMID", modStatPerTopic.ForumID);
                AddIntElement(topicModStat, "USERID", modStatPerTopic.UserID);
                AddTextTag(topicModStat, "USERNAME", modStatPerTopic.UserName);
                AddTextTag(topicModStat, "EMAIL", modStatPerTopic.Email);
                AddIntElement(topicModStat, "PASSED", modStatPerTopic.NumPass);
                AddIntElement(topicModStat, "FAILED", modStatPerTopic.NumFail);
                AddIntElement(topicModStat, "REFERRED", modStatPerTopic.NumRefer);
            }
        }


        private void GenerateModStatsTopicTotals(XmlElement messageBoardStatistics, int siteID, DateTime entryDate)
        {
            Dictionary<int, ModStatsTopicTotals> modStatsTopicTotals = new Dictionary<int,ModStatsTopicTotals>();
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmbstatsmodstatstopictotals"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("date", entryDate);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int forumID = dataReader.GetInt32NullAsZero("ForumID");

                        if (!modStatsTopicTotals.ContainsKey(forumID))
                        {
                            ModStatsTopicTotals tmpobj = new ModStatsTopicTotals();
                            tmpobj.ForumID = forumID;
                            tmpobj.TopicTitle = dataReader.GetStringNullAsEmpty("TopicTitle");

                            modStatsTopicTotals.Add(forumID, tmpobj);
                        }

                        int statusID = dataReader.GetInt32NullAsZero("StatusID");
                        int total = dataReader.GetInt32NullAsZero("Total");
                        switch (statusID)
                        {
                            case 2: ((ModStatsTopicTotals) modStatsTopicTotals[forumID]).NumRefer = total; break;
                            case 3: ((ModStatsTopicTotals) modStatsTopicTotals[forumID]).NumPass = total; break;
                            case 4: ((ModStatsTopicTotals) modStatsTopicTotals[forumID]).NumFail = total; break;
                        }

                    }
                }
            }
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmbstatstopictotalcomplaints"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("date", entryDate);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int forumID = dataReader.GetInt32NullAsZero("ForumID");
                        int total = dataReader.GetInt32NullAsZero("Total");
                        modStatsTopicTotals[forumID].NumComplaints = total;

                        modStatsTopicTotals[forumID].Total =
                            modStatsTopicTotals[forumID].NumPass +
                            modStatsTopicTotals[forumID].NumFail +
                            modStatsTopicTotals[forumID].NumRefer +
                            modStatsTopicTotals[forumID].NumComplaints;
                    }
                }
            }
            GenerateModStatsTopicTotalsXML(messageBoardStatistics, modStatsTopicTotals);
        }

        private void GenerateModStatsTopicTotalsXML(XmlElement messageBoardStatistics, Dictionary<int, ModStatsTopicTotals> modStatsTopicTotals)
        {
            XmlElement modStatsTopicTotalsElement = AddElementTag(messageBoardStatistics, "MODSTATSTOPICTOTALS");
            foreach (ModStatsTopicTotals modStatTopicTotals in modStatsTopicTotals.Values)
            {
                XmlElement topicTotals = AddElementTag(modStatsTopicTotalsElement, "TOPICTOTALS");
                AddTextTag(topicTotals, "TOPICTITLE", modStatTopicTotals.TopicTitle);
                AddIntElement(topicTotals, "FORUMID", modStatTopicTotals.ForumID);
                AddIntElement(topicTotals, "PASSED", modStatTopicTotals.NumPass);
                AddIntElement(topicTotals, "FAILED", modStatTopicTotals.NumFail);
                AddIntElement(topicTotals, "REFERRED", modStatTopicTotals.NumRefer);
                AddIntElement(topicTotals, "COMPLAINTS", modStatTopicTotals.NumComplaints);
                AddIntElement(topicTotals, "TOTAL", modStatTopicTotals.Total);
            }
        }

        private void GenerateHostsPostsPerTopic(XmlElement messageBoardStatistics, int siteID, DateTime entryDate)
        {
            Dictionary<string, HostsPostsPerTopic> hostsPostsPerTopic = new Dictionary<string,HostsPostsPerTopic>();
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmbstatshostspostspertopic"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.AddParameter("date", entryDate);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int userID = dataReader.GetInt32NullAsZero("UserID");
                        int forumID = dataReader.GetInt32NullAsZero("ForumID");

                        string key = userID.ToString();
                        key += forumID.ToString();

                        HostsPostsPerTopic tmpobj = new HostsPostsPerTopic();
                        tmpobj.UserID = userID;
                        tmpobj.ForumID = forumID;

                        tmpobj.TopicTitle = dataReader.GetStringNullAsEmpty("TopicTitle");
                        tmpobj.UserName = dataReader.GetStringNullAsEmpty("UserName");
                        tmpobj.Email = dataReader.GetStringNullAsEmpty("Email");
                        tmpobj.TotalPosts = dataReader.GetInt32NullAsZero("Total");

                        hostsPostsPerTopic.Add(key, tmpobj);
                    }
                }
            }
            GenerateHostsPostsPerTopicXML(messageBoardStatistics, hostsPostsPerTopic);
        }

        private void GenerateHostsPostsPerTopicXML(XmlElement messageBoardStatistics, Dictionary<string, HostsPostsPerTopic> hostsPostsPerTopic)
        {
            XmlElement hostsPostsPerTopicElement = AddElementTag(messageBoardStatistics, "HOSTSPOSTSPERTOPIC");
            foreach (HostsPostsPerTopic perHostsPostsPerTopic in hostsPostsPerTopic.Values)
            {
                XmlElement hostsPostsinTopic = AddElementTag(hostsPostsPerTopicElement, "HOSTPOSTSINTOPIC");
                AddIntElement(hostsPostsinTopic, "USERID", perHostsPostsPerTopic.UserID);
                AddTextTag(hostsPostsinTopic, "USERNAME", perHostsPostsPerTopic.UserName);
                AddTextTag(hostsPostsinTopic, "EMAIL", perHostsPostsPerTopic.Email);
                AddTextTag(hostsPostsinTopic, "TOPICTITLE", perHostsPostsPerTopic.TopicTitle);
                AddIntElement(hostsPostsinTopic, "FORUMID", perHostsPostsPerTopic.ForumID);
                AddIntElement(hostsPostsinTopic, "TOTALPOSTS", perHostsPostsPerTopic.TotalPosts);
            }
        }

        /// <summary>
        /// Sends the MessageBoard Statistics email
        /// </summary>
        /// <param name="entryDate">The date for the stats</param>
        /// <param name="emailFrom">From email address</param>
        /// <param name="emailTo">To email address</param>
        public void SendMessageBoardStatsEmail(DateTime entryDate, string emailFrom, string emailTo)
        {
            int siteID = InputContext.CurrentSite.SiteID;

            string date = String.Empty;
            string nameOfSite = String.Empty;
            string emailSubject = String.Empty;
            string emailText = String.Empty;

            date = entryDate.ToString("yyyyMMdd");

            string URL = InputContext.GetSiteRoot(siteID);
            nameOfSite = InputContext.CurrentSite.SiteName;

            URL += "messageboardstats?date=" + date;

            emailSubject = "Moderation stats for site " + nameOfSite;

            /*
                if (ErrorReported())
                {
                    emailText << "The following Error occurred\n\n";
                    emailText << GetLastErrorAsXMLString() << "\n\n";
                    emailText << "The link below may not work\n\n";
                }
            */
            emailText += "Moderation stats are now available:\n\n";
            emailText += "http://" + URL;

            InputContext.SendMailOrSystemMessage(emailTo, emailSubject, emailText, emailFrom, nameOfSite, false, 0, siteID);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="entryDate">Entry Date</param>
        /// <param name="emailFrom">Email from entry</param>
        /// <param name="emailTo">Email to entry</param>
        private void TryGetPageParams(ref DateTime entryDate, ref string emailFrom, ref string emailTo)
        {
            if (InputContext.DoesParamExist("date", _docDnaEntryDate))
            {
                string entryDateText = InputContext.GetParamStringOrEmpty("date", _docDnaEntryDate);

                DateRangeValidation dateValidation = new DateRangeValidation();
                DateRangeValidation.ValidationResult isValid;

                DateTime tempEntryDate;

                isValid = ParseDate(entryDateText, out tempEntryDate);
                if (isValid == DateRangeValidation.ValidationResult.VALID)
                {
                    isValid = dateValidation.ValidateDate(tempEntryDate, false);
                }
                else
                {
                    AddErrorXml("invalidparameters", "Illegal date entry (" + isValid.ToString() + ")", null);
                    return;
                }

                if (isValid == DateRangeValidation.ValidationResult.VALID)
                {
                    entryDate = dateValidation.LastStartDate;
                }
                else
                {
                    AddErrorXml("invalidparameters", "Illegal date parameters (" + isValid.ToString() + ")", null);
                    return;
                }
            }
            else
            {
                entryDate = DateTime.Now.AddDays(-1).Date;
            }
            if (InputContext.DoesParamExist("emailFrom", _docDnaEmailFrom) && InputContext.DoesParamExist("emailTo", _docDnaEmailTo))
            {
                emailFrom = InputContext.GetParamStringOrEmpty("emailFrom", _docDnaEmailFrom);
                emailTo = InputContext.GetParamStringOrEmpty("emailTo", _docDnaEmailTo);
            }
        }
        /// <summary>
        /// Parses and prepares date range params for UserStatistics.
        /// </summary>
        /// <param name="startDateText">Start date</param>
        /// <param name="endDateText">End date</param>
        /// <param name="startDate">Parsed start date</param>
        /// <param name="endDate">Parsed end date</param>
        /// <returns><see cref="DateRangeValidation.ValidationResult"/></returns>
        /// <remarks>If no endDateText is passed in then endDate is set to startDate + 1 day.</remarks>
        public static DateRangeValidation.ValidationResult ParseDateParams(string startDateText, string endDateText, out DateTime startDate, out DateTime endDate)
        {
            CultureInfo ukCulture = new CultureInfo("en-GB");
            startDate = DateTime.MinValue;
            endDate = DateTime.MinValue;

            try
            {
                startDate = DateTime.Parse(startDateText, ukCulture);
            }
            catch (FormatException)
            {
                return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }
            catch (ArgumentException)
            {
                return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }

            // Has the user supplied and end date?
            bool createEndDate = endDateText.Length == 0;
            if (createEndDate)
            {
                // No end date passed in by user so create one using the start date.
                try
                {
                    endDate = startDate.AddDays(1);
                }
                catch (ArgumentOutOfRangeException)
                {
                    // can't create end date from start date.
                    return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
                }
            }
            else
            {
                // There is a user supplied end date so try to create it
                try
                {
                    endDate = DateTime.Parse(endDateText, ukCulture);

                    // DNA assumes that the dates passed into ArticleSearch by a user are inclusive. 
                    // 1 day is therefore added to the end date to represent what the user intended.
                    // E.g. searching for December 1999 they mean 01/12/1999 00:00 to 01/01/2000 00:00 not 01/12/1999 00:00 to 31/12/1999 00:00, which misses out the last 24 hours of the month.
                    endDate = endDate.AddDays(1);
                }
                catch (FormatException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
                catch (ArgumentOutOfRangeException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
                catch (ArgumentException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
            }
            return DateRangeValidation.ValidationResult.VALID;
        }

        /// <summary>
        /// Parses and prepares a date param.
        /// </summary>
        /// <param name="entryDateText">the date</param>
        /// <param name="entryDate">Parsed date</param>
        /// <returns><see cref="DateRangeValidation.ValidationResult"/></returns>
        public static DateRangeValidation.ValidationResult ParseDate(string entryDateText, out DateTime entryDate)
        {
            CultureInfo ukCulture = new CultureInfo("en-GB");
            entryDate = DateTime.MinValue;

            DateRangeValidation.ValidationResult isValid = DateRangeValidation.ValidationResult.VALID;
            try
            {
                entryDate = DateTime.Parse(entryDateText, ukCulture);
            }
            catch (FormatException)
            {
                isValid = DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }
            catch (ArgumentException)
            {
                isValid = DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }
            if (isValid != DateRangeValidation.ValidationResult.VALID)
            {
                try
                {
                    string[] formats = { "yyyyMMdd" };
                    entryDate = DateTime.ParseExact(entryDateText, formats, ukCulture, DateTimeStyles.None);
                    //Got to here so must be valid
                    isValid = DateRangeValidation.ValidationResult.VALID;
                }
                catch (FormatException)
                {
                    isValid = DateRangeValidation.ValidationResult.STARTDATE_INVALID;
                }
                catch (ArgumentException)
                {
                    isValid = DateRangeValidation.ValidationResult.STARTDATE_INVALID;
                }
            }
            return isValid;
        }
    }
}
