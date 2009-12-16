using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MonthSummary Page object
    /// </summary>
    public class MonthSummary : DnaInputComponent
    {
        private string _cachedFileName = String.Empty;

        /// <summary>
        /// Default constructor for the MonthSummary component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MonthSummary(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            TryCreateMonthSummaryXML();
        }

        /// <summary>
        /// Functions generates the TryCreateMonthSummaryXML
        /// </summary>
        public void TryCreateMonthSummaryXML()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            //find out the time of the last posted entry
            DateTime expiryDate = CacheGetTimeOfMostRecentGuideEntry();

            _cachedFileName = "monthSummary-" + InputContext.CurrentSite.SiteID.ToString();
            _cachedFileName += ".xml";

            string cachedMonthSummary = "";
            if (InputContext.FileCacheGetItem("monthSummary", _cachedFileName, ref expiryDate, ref cachedMonthSummary) && cachedMonthSummary.Length > 0)
            {
                // Create the journal from the cache
                CreateAndInsertCachedXML(cachedMonthSummary, "MONTHSUMMARY", true);

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return;
            }

            // if didn't get data from cache then get it from the DB
            // Actually do the fetching of the data
            XmlElement monthSummary = AddElementTag(RootElement, "MONTHSUMMARY");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmonthsummary"))
            {
                dataReader.AddParameter("siteID", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    do
                    {
                        string subject = dataReader.GetStringNullAsEmpty("Subject");

                        int h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                        DateTime dateCreated = DateTime.MinValue;
                        bool existsDateCreated = !dataReader.IsDBNull("DateCreated");
                        if (existsDateCreated)
                        {
                            dateCreated = dataReader.GetDateTime("DateCreated");
                        }

                        XmlElement guideEntry = AddElementTag(monthSummary, "GUIDEENTRY");
                        AddAttribute(guideEntry, "H2G2ID", h2g2ID);

                        if (existsDateCreated)
                        {
                            guideEntry.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("DateCreated"), true));
                        }
                        AddTextTag(guideEntry, "SUBJECT", subject);

                    } while (dataReader.Read());
                }
            }
            InputContext.FileCachePutItem("monthSummary", _cachedFileName, monthSummary.OuterXml);
        }

        /// <summary>
        /// Gets the time of last posted entry
        /// </summary>
        /// <returns>Time of last posted entry</returns>
        private DateTime CacheGetTimeOfMostRecentGuideEntry()
        {
            // Get the date from the database
            int seconds = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("cachegettimeofmostrecentguideentry"))
            {
                reader.Execute();

                // If we found the info, set the number of seconds
                if (reader.HasRows && reader.Read())
                {
                    seconds = reader.GetInt32NullAsZero("seconds");
                }
            }
            //return the now time minus the number of seconds
            return DateTime.Now.Subtract(new TimeSpan(0, 0, seconds));
            //return DateTime.Now.AddSeconds((double)(seconds * -1));
        }
    }
}
