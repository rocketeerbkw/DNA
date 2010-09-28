using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Objects;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the UserStatistics Page object, holds the UserStatistics of a user
    /// </summary>
    public class UserStatistics : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of posts to skip.";
        private const string _docDnaShow = @"The number of posts to show.";
        private const string _docDnaUserID = @"User ID of the UserStatistics to look at.";
        private const string _docDnaMode = @"The way the results are returned in by forum or by dateposted.";
        private const string _docDnaStartDate = @"Start Date of the UserStatistics to look at.";
        private const string _docDnaEndDate = @"End Date of the UserStatistics to look at.";

        /// <summary>
        /// Default constructor for the UserStatistics component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserStatistics(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int userID = 0;
            int skip = 0;
            int show = 0;
            int mode = 0;
            DateTime startDate = DateTime.MinValue;
            DateTime endDate = DateTime.MinValue;

            TryGetPageParams(ref userID, ref skip, ref show, ref mode, ref startDate, ref endDate);

            TryCreateUserStatisticsXML(userID, skip, show, mode, startDate, endDate);
        }

        /// <summary>
        /// Functions generates the User Statistics XML
        /// </summary>
        /// <param name="userID">The user of the statistics to get</param>
        /// <param name="skip">Number of posts to skip</param>
        /// <param name="show">Number of posts to show</param>
        /// <param name="mode">Way the records are returned by dateposted or by forum</param>
        /// <param name="startDate">Start Date</param>
        /// <param name="endDate">End Date</param>
        public void TryCreateUserStatisticsXML(int userID, int skip, int show, int mode, DateTime startDate, DateTime endDate)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            //Must be logged in.
            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be logged in to view user statistics.", RootElement);
                return;
            }
            if (!InputContext.ViewingUser.IsEditor && !InputContext.ViewingUser.IsSuperUser)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be an editor or superuser to view user statistics.", RootElement);
                return;
            }

            int recordsCount = 0;
            int total = 0;
            int numberToTryandGet = show + 1;
            bool more = false;

            string userName = String.Empty;

            XmlElement userStatistics = AddElementTag(RootElement, "USERSTATISTICS");
            AddAttribute(userStatistics, "USERID", userID);
            if (mode == 0)
            {
                AddAttribute(userStatistics, "DISPLAYMODE", "byforum");
            }
            else
            {
                AddAttribute(userStatistics, "DISPLAYMODE", "ungrouped");
            }
            AddAttribute(userStatistics, "SKIPTO", skip);
            AddAttribute(userStatistics, "SHOW", show);
            AddDateXml(startDate, userStatistics, "STARTDATE");
            AddDateXml(endDate, userStatistics, "ENDDATE");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(GetUserStatisticsSP(mode)))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", numberToTryandGet);
                dataReader.AddParameter("mode", mode);
                dataReader.AddParameter("startdate", startDate);
                dataReader.AddParameter("enddate", endDate);
                dataReader.AddIntOutputParameter("recordscount");
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, userID, userStatistics);
                    userName = dataReader.GetStringNullAsEmpty("UserName"); ;

                    dataReader.NextResult();
                    if (dataReader.HasRows && dataReader.Read() & numberToTryandGet > 0)
                    {
                        total = dataReader.GetInt32NullAsZero("total");

                        XmlElement forum = CreateElement("FORUM");
                        XmlElement thread = CreateElement("THREAD");

                        int previousForumID = 0;
                        int previousThreadID = 0;

                        do
                        {
                            int forumID = dataReader.GetInt32NullAsZero("ForumID");
                            int threadID = dataReader.GetInt32NullAsZero("ThreadID");
                            int postID = dataReader.GetInt32NullAsZero("EntryID");
                            int hidden = dataReader.GetInt32NullAsZero("Hidden");
                            int siteID = dataReader.GetInt32NullAsZero("SiteID");
                            int postIndex = dataReader.GetInt32NullAsZero("PostIndex");

                            string title = dataReader.GetStringNullAsEmpty("Title");
                            string subject = dataReader.GetStringNullAsEmpty("Subject");
                            string firstSubject = dataReader.GetStringNullAsEmpty("FirstSubject");
                            string siteName = dataReader.GetStringNullAsEmpty("URLName");

                            string url = dataReader.GetStringNullAsEmpty("Url");

                            DateTime datePosted = dataReader.GetDateTime("DatePosted");

                            //close previously opened THREAD if any
                            if (threadID != previousThreadID && previousThreadID != 0)
                            {
                                forum.AppendChild(thread);
                            }

                            //close previously opened FORUM if any
                            if (forumID != previousForumID && previousForumID != 0)
                            {
                                userStatistics.AppendChild(forum);
                            }

                            //check if current forum id differs from the previous one. This will mean
                            //that entries for the previous forum are over and we should close
                            //the xml element for that forum and start new one for the current forum
                            if (forumID != previousForumID)
                            {
                                forum = CreateElement("FORUM");
                                AddAttribute(forum, "FORUMID", forumID);
                                AddTextTag(forum, "SUBJECT", title);
                                AddIntElement(forum, "SITEID", siteID);
                                AddTextTag(forum, "SITENAME", siteName);
                                AddTextTag(forum, "URL", url);

                                thread = CreateElement("THREAD");
                                AddAttribute(thread, "THREADID", threadID);
                                AddTextTag(thread, "SUBJECT", firstSubject);

                                previousForumID = forumID;
                                previousThreadID = threadID;
                            }
                            //check if current thread id differs from the previous one. This will mean
                            //that entries for the previous thread are over and we should close
                            //the xml element for that thread and start new one for the current thread
                            else if (threadID != previousThreadID)
                            {
                                thread = CreateElement("THREAD");
                                AddAttribute(thread, "THREADID", threadID);
                                AddTextTag(thread, "SUBJECT", firstSubject);

                                previousThreadID = threadID;
                            }

                            string body = dataReader.GetStringNullAsEmpty("text");
                            int style = 0;
                            if(dataReader.DoesFieldExist("PostStyle") && !dataReader.IsDBNull("PostStyle"))
                            {
                                style = dataReader.GetTinyIntAsInt("PostStyle");
                            }
                            if (style == 1)
                            {
                                body = ThreadPost.FormatPost(body, BBC.Dna.Moderation.Utils.CommentStatus.Hidden.NotHidden, true);
                                string temp = "<RICHPOST>" + body + "</RICHPOST>";
                                Regex regex = new Regex(@"(<[^<>]+)<BR \/>");
                                while (regex.Match(temp).Success)
                                {
                                    temp = regex.Replace(temp, @"$1 ");
                                }
                                body = temp;
                            }
                            else
                            {
                                body = StringUtils.ConvertPlainText(body);
                            }
                            XmlElement post = CreateElement("POST");
                            AddAttribute(post, "POSTID", postID);
                            AddAttribute(post, "THREADID", threadID);
                            AddAttribute(post, "HIDDEN", hidden);
                            AddTextTag(post, "SUBJECT", subject);

/*                            if (style != 1)
                            {
                                body = StringUtils.ConvertPlainText(body);
                            }
                            else
                            {
                                //TODO Do we need Rich Post stuff for the post style??
                                string temp = "<RICHPOST>" + body.Replace("\r\n", "<BR />").Replace("\n", "<BR />") + "</RICHPOST>";
                                body = temp;
                            }

 */ 
                            AddElement(post, "BODY", body);

                            AddIntElement(post, "PostIndex", postIndex);
                            AddDateXml(datePosted, post, "DATEPOSTED");

                            thread.AppendChild(post);
                            numberToTryandGet--;

                        } while (numberToTryandGet > 1 && dataReader.Read());

                        //close last opened THREAD if any
                        if (previousThreadID != 0)
                        {
                            forum.AppendChild(thread);
                        }

                        //close last opened FORUM if any
                        if (previousForumID != 0)
                        {
                            userStatistics.AppendChild(forum);
                        }

                        // See if there's an extra row waiting
                        if (dataReader.Read())
                        {
                            AddAttribute(userStatistics, "MORE", 1);
                            more = true;
                        }
                    }
                    dataReader.NextResult();
                    dataReader.TryGetIntOutputParameter("recordscount", out recordsCount);
                }
            }
            //The record count will also contain the extra 'more' row 
            //so need to take 1 off it to give a true indictation of the rows returned
            if (more)
            {
                recordsCount--;
            }

            AddAttribute(userStatistics, "COUNT", recordsCount);
            AddAttribute(userStatistics, "TOTAL", total);
            AddAttribute(userStatistics, "USERNAME", StringUtils.EscapeAllXmlForAttribute(userName));
        }

        /// <summary>
        /// Gets the correct SP name to call depending on the mode
        /// </summary>
        /// <param name="mode">By DatePosted = 1 or by Forum = 0</param>
        /// <returns>SP name</returns>
        private string GetUserStatisticsSP(int mode)
        {
            string storedProcedureName = String.Empty;
            if (mode == 1)
            {
                storedProcedureName = "fetchnewuserstatisticsbydateposted";
            }
            else // if (mode == 0)
            {
                storedProcedureName = "fetchnewuserstatisticsbyforum";
            }
            return storedProcedureName;
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="userID">The user of the statistics to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="mode">Way the records are returned by dateposted or by forum</param>
        /// <param name="startDate">Start Date</param>
        /// <param name="endDate">End Date</param>
        private void TryGetPageParams(ref int userID, ref int skip, ref int show, ref int mode, ref DateTime startDate, ref DateTime endDate)
        {
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
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
            mode = 1;
            string modeText = InputContext.GetParamStringOrEmpty("mode", _docDnaMode);
            if (modeText == "byforum")
            {
                mode = 0;
            }

            if (InputContext.DoesParamExist("startDate", _docDnaStartDate))
            {
                string startDateText = InputContext.GetParamStringOrEmpty("startDate", _docDnaStartDate);
                string endDateText = InputContext.GetParamStringOrEmpty("endDate", _docDnaEndDate);

                DateRangeValidation dateValidation = new DateRangeValidation();
                DateRangeValidation.ValidationResult isValid;

                DateTime tempStartDate;
                DateTime tempEndDate;

                isValid = ParseDateParams(startDateText, endDateText, out tempStartDate, out tempEndDate);
                isValid = dateValidation.ValidateDateRange(tempStartDate, tempEndDate, 0, false, false);

                if (isValid == DateRangeValidation.ValidationResult.VALID)
                {
                    startDate = dateValidation.LastStartDate;
                    endDate = dateValidation.LastEndDate;
                }
                else
                {
                    AddErrorXml("invalidparameters", "Illegal date parameters (" + isValid.ToString() + ")", null);
                    return;
                }
            }
            else
            {
                startDate = DateTime.Now.AddMonths(-1);
                if (!InputContext.DoesParamExist("endDate", _docDnaEndDate))
                {
                    endDate = DateTime.Now;
                }
            }

            if (startDate > endDate)
            {
                startDate = endDate.AddMonths(-1);
            }

            TimeSpan timeSpan = endDate - startDate;

            if (timeSpan.Days > 180)
            {
                startDate = endDate.AddDays(-180);
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
    }
}
