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
    /// Summary of the StatisticsReport Page object
    /// </summary>
    public class StatisticsReport : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaInterval = @"The interval for the report.";
        private const string _docDnaEntryDate = @"Date of the Statistics Report to look at.";

        /// <summary>
        /// Default constructor for the StatisticsReport component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public StatisticsReport(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int skip = 0;
            int show = 0;
            int interval = 1;
            DateTime entryDate = DateTime.MinValue;

            TryGetPageParams(ref skip, ref show, ref entryDate, ref interval);

            TryCreateStatisticsReportXML(skip, show, entryDate, interval);
        }

        /// <summary>
        /// Functions generates the StatisticsReport XML
        /// </summary>
        /// <param name="skip">Number of posts to skip</param>
        /// <param name="show">Number of posts to show</param>
        /// <param name="entryDate">entry Date</param>
        /// <param name="interval">Report interval</param>
        public void TryCreateStatisticsReportXML(int skip, int show, DateTime entryDate, int interval)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            //Must be logged in.
            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be logged in to view the statistics report.", RootElement);
                return;
            }
            if (!InputContext.ViewingUser.IsEditor && !InputContext.ViewingUser.IsSuperUser)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be an editor or superuser to view the statistics report.", RootElement);
                return;
            }

            int recordsCount = 0;
            int total = 0;
            int numberToTryandGet = show + 1;

            string intervalText = String.Empty;

            XmlElement statisticsReport = AddElementTag(RootElement, "POSTING-STATISTICS");
            if (interval == 1)
            {
                intervalText = "day";
            }
            else if (interval == 2)
            {
                intervalText = "week";
            }
            else if (interval == 3)
            {
                intervalText = "month";
            }
            AddAttribute(statisticsReport, "INTERVAL", intervalText);

            AddAttribute(statisticsReport, "SKIPTO", skip);
            AddAttribute(statisticsReport, "SHOW", show);
            AddDateXml(entryDate, statisticsReport, "ENTRYDATE");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("stats_getpostingstats"))
            {
                dataReader.AddParameter("rawstartdate", entryDate);
                dataReader.AddParameter("interval", interval);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    AddDateXml(dataReader, statisticsReport, "startdate", "STARTDATE");
                    AddDateXml(dataReader, statisticsReport, "enddate", "ENDDATE");
                    
                    do
                    {
                        XmlElement postings = AddElementTag(statisticsReport, "POSTINGS");
                        AddAttribute(postings, "SITEID", dataReader.GetInt32NullAsZero("SiteID"));

                        string siteName = dataReader.GetStringNullAsEmpty("URLName");
                        string escapedURLName = StringUtils.EscapeAllXmlForAttribute(siteName);
                        AddAttribute(postings, "URLNAME", escapedURLName);

                        int forumID = dataReader.GetInt32NullAsZero("ForumID");
                        if (forumID == 0)
                        {
                            AddAttribute(postings, "ISMESSAGEBOARD", 0);
                        }
                        else
                        {
                            AddAttribute(postings, "ISMESSAGEBOARD", 1);
                            AddAttribute(postings, "FORUMID", forumID);
                            string title = dataReader.GetStringNullAsEmpty("Title");
                            string escapedTitle = StringUtils.EscapeAllXmlForAttribute(title);
                            AddAttribute(postings, "TITLE", escapedTitle);
                        }

                        int totalPosts = dataReader.GetInt32NullAsZero("TotalPosts");
                        int totalUsers = dataReader.GetInt32NullAsZero("TotalUsers");

                        AddAttribute(postings, "TOTALPOSTS", totalPosts);
                        AddAttribute(postings, "TOTALUSERS", totalUsers);

                        total++;
                        recordsCount++;

                    } while (dataReader.Read());
                }
            }

            AddAttribute(statisticsReport, "COUNT", recordsCount);
            AddAttribute(statisticsReport, "TOTAL", total);
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="skip">number of postings to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="entryDate">Entry Date of search</param>
        /// <param name="interval">Interval of search</param>
        private void TryGetPageParams(ref int skip, ref int show, ref DateTime entryDate, ref int interval)
        {
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }

            //find out which display mode is requested
            interval = 1;
            string intervalText = InputContext.GetParamStringOrEmpty("interval", _docDnaInterval);
            if (intervalText == "week")
            {
                interval = 2;
            }
            else if (intervalText == "month")
            {
                interval = 3;
            }
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
                entryDate = DateTime.Now;
            }

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
