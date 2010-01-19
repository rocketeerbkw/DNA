using System;
using System.Text; 
using System.Xml;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Utility class for getting DNA's XML representation of a date as a string. 
    /// For standard DateTime operations use .NET DateTime structure. 
    /// </summary>
    public sealed class DnaDateTime
    {
        /// <summary>
		/// Create and return a &lt;DATE&gt; element for the given XML document
		/// </summary>
		/// <param name="doc">Document with which to create the element</param>
        /// <param name="dateTime">Value to represent in XML</param>
		/// <returns>XmlElement representing the date</returns>
        public static XmlElement GetDateTimeAsElement(XmlDocument doc, string dateTime)
        {
            DateTime dateTimeStructure;
            DateTime.TryParse(dateTime, System.Threading.Thread.CurrentThread.CurrentCulture, System.Globalization.DateTimeStyles.AssumeUniversal, out dateTimeStructure);

            return GetDateTimeAsElement(doc, dateTimeStructure); 
        }

		/// <summary>
		/// Create and return a &lt;DATE&gt; element for the given XML document
		/// </summary>
		/// <param name="doc">Document with which to create the element</param>
		/// <param name="dateTime">Value to represent in XML</param>
		/// <returns>XmlElement representing the date</returns>
		/// <remarks>This method always includes the Relative attribute. See overloaded methods for other options.</remarks>
		public static XmlElement GetDateTimeAsElement(XmlDocument doc, DateTime dateTime)
		{
            if (dateTime.Equals(DateTime.MinValue))
            {
                return GetDefaultDateTimeAsElement(doc);
            }
			
			return GetDateTimeAsElement(doc, dateTime, true);
		}

		/// <summary>
		/// Create and return a &lt;DATE&gt; element for the given Xml document
		/// </summary>
		/// <param name="doc">Document with which to create the element</param>
		/// <param name="dateTime">Value to represent in XML</param>
		/// <param name="bIncludeRelative">true if you want the RELATIVE attribute, false if you don't</param>
		/// <returns>XmlElement representing the date</returns>
		public static XmlElement GetDateTimeAsElement(XmlDocument doc, DateTime dateTime, bool bIncludeRelative)
		{
			// Ouput date in GMT regardless of settings on local machine.
            dateTime = dateTime.ToUniversalTime();
			XmlElement dateElement = doc.CreateElement("DATE");
			dateElement.SetAttribute("DAYNAME", dateTime.DayOfWeek.ToString());
			dateElement.SetAttribute("SECONDS", dateTime.ToString("ss"));
			dateElement.SetAttribute("MINUTES", dateTime.ToString("mm"));
			dateElement.SetAttribute("HOURS", dateTime.ToString("HH"));
			dateElement.SetAttribute("DAY", dateTime.ToString("dd"));
			dateElement.SetAttribute("MONTH", dateTime.ToString("MM"));
			dateElement.SetAttribute("MONTHNAME", GetMonthName(dateTime.Month));
			dateElement.SetAttribute("YEAR", dateTime.ToString("yyyy"));
			dateElement.SetAttribute("SORT", DnaDateTime.GetSortValue(dateTime));
			if (bIncludeRelative)
			{
				dateElement.SetAttribute("RELATIVE", TryGetRelativeValueForPastDate(dateTime));
			}

            // Generate Local Time - takes account of BST .
            DateTime localTime = TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(dateTime);
            XmlElement localElement = doc.CreateElement("LOCAL");
            localElement.SetAttribute("DAYNAME", localTime.DayOfWeek.ToString());
            localElement.SetAttribute("SECONDS", localTime.ToString("ss") );
            localElement.SetAttribute("MINUTES", localTime.ToString("mm") );
            localElement.SetAttribute("HOURS", localTime.ToString("HH"));
            localElement.SetAttribute("DAY", localTime.ToString("dd"));
            localElement.SetAttribute("MONTH", localTime.ToString("MM"));
            localElement.SetAttribute("MONTHNAME", GetMonthName(localTime.Month));
            localElement.SetAttribute("YEAR", localTime.ToString("yyyy"));
            localElement.SetAttribute("SORT", DnaDateTime.GetSortValue(localTime));
            if (bIncludeRelative)
            {
                String test = TryGetRelativeValueForPastDateLocal(dateTime);
                localElement.SetAttribute("RELATIVE",  test);
            }
            dateElement.AppendChild(localElement);
            
			return dateElement;
		}

        /// <summary>
        /// Get the given date as an XmlNode
        /// </summary>
        /// <param name="time">DateTime value to change to Xml</param>
        /// <returns>DATE node from the resulting Xml</returns>
        public static XmlNode GetDateTimeAsNode(DateTime time)
        {
            XmlDocument doc = new XmlDocument();
            return GetDateTimeAsElement(doc, time); 
        }

        /// <summary>
        /// Returns full month name. 
        /// </summary>
        /// <param name="month">Month number (e.g. 1 = January, 2 = February etc.</param>
        /// <returns>Full month name (i.e. January | February etc.)</returns>
        public static string GetMonthName(int month)
        {
            switch (month)
            {
                case 1: return "January";
                case 2: return "February";
                case 3: return "March";
                case 4: return "April";
                case 5: return "May";
                case 6: return "June";
                case 7: return "July";
                case 8: return "August";
                case 9: return "September";
                case 10: return "October";
                case 11: return "November";
                case 12: return "December";
                default: return "Unknown";
            }
        }

        /// <summary>
        /// Get DNA's default XML representation of a date as an XmlElement. 
        /// </summary>
        /// <returns>XmlElement representing DNA's default date.</returns>
        public static XmlElement GetDefaultDateTimeAsElement(XmlDocument doc)
        {
            XmlElement dateElement = doc.CreateElement("DATE");
            dateElement.SetAttribute("DAYNAME", "Monday");
            dateElement.SetAttribute("SECONDS", "00");
            dateElement.SetAttribute("MINUTES", "00");
            dateElement.SetAttribute("HOURS", "00");
            dateElement.SetAttribute("DAY", "31");
            dateElement.SetAttribute("MONTH", "12");
            dateElement.SetAttribute("MONTHNAME", "December");
            dateElement.SetAttribute("YEAR", "1899");
            dateElement.SetAttribute("SORT", "18991231000000");
            dateElement.SetAttribute("RELATIVE", "Unknown");

            XmlElement localElement = doc.CreateElement("LOCAL");
            localElement.SetAttribute("DAYNAME", "Monday");
            localElement.SetAttribute("SECONDS", "00");
            localElement.SetAttribute("MINUTES", "00");
            localElement.SetAttribute("HOURS", "00");
            localElement.SetAttribute("DAY", "31");
            localElement.SetAttribute("MONTH", "12");
            localElement.SetAttribute("MONTHNAME", "December");
            localElement.SetAttribute("YEAR", "1899");
            localElement.SetAttribute("SORT", "18991231000000");
            localElement.SetAttribute("RELATIVE", "Unknown");
            dateElement.AppendChild(localElement);

            return dateElement;
        }

        /// <summary>
        /// Returns sort value for a date. 
        /// </summary>
        /// <param name="dateTime">A date</param>
        /// <returns>Sort value as a string</returns>
        private static string GetSortValue(DateTime dateTime)
        {
			return dateTime.ToString("yyyyMMddHHmmss");//"" + dateTime.Year + dateTime.Month + dateTime.Day + dateTime.Hour + dateTime.Minute + dateTime.Second; 
        }

        /// <summary>
        /// Returns relative value for a date. 
        /// </summary>
        /// <param name="dateTime">A date. Must be in the past.</param>
        /// <returns>Textual description of time elapsed between param and now (e.g. x minutes ago, last week etc.)</returns>
        /// <remarks>Returns empty string if date is not in the past. All dates compared with UtcNow (i.e. current time in GMT).</remarks>
        public static string TryGetRelativeValueForPastDate(DateTime dateTime )
        {
            DateTime now = DateTime.Now.ToUniversalTime();
            TimeSpan timeSpan = now - dateTime; 

            if (timeSpan.Ticks < 0)
            {
                return "Just Now";
            }

            // Now do all the relative stuff

            double totalSeconds = Math.Round(timeSpan.TotalSeconds);
            double totalMinutes = Math.Round(timeSpan.TotalMinutes);
            double totalHours = Math.Round(timeSpan.TotalHours);
            double totalDays = Math.Round(timeSpan.TotalDays);

            if (totalSeconds < 60)
            {
                return "Just Now";
            }
            else if (totalMinutes < 60)
            {
                if (totalMinutes == 1)
                {
	                return "1 Minute Ago";
                }
                else
                {
	                return totalMinutes + " Minutes Ago";
                }
            }

            else if (totalHours < 24)
            {
                if (totalHours == 1)
                {
	                return "1 Hour Ago";
                }
                else
                {
	                return totalHours + " Hours Ago";
                }
            }

            else
            {
                if (totalDays <= 1)
                {
	                return "Yesterday";
                }
                else if (totalDays < 7)
                {
                    return totalDays + " Days Ago";
                }
                else if (totalDays < 14)
                {
	                return "Last Week";
                }
                else if (totalDays < 42)
                {
                    double totalWeeks = Math.Round(totalDays / 7);
                    return totalWeeks + " Weeks Ago";
                }
                else
                {
                    return DnaDateTime.GetMonthName(dateTime.Month).Substring(0, 3) + " " + dateTime.Day + ", " + dateTime.Year;
                }
            }
        }

        /// <summary>
        /// Returns relative value for a date in local time. 
        /// </summary>
        /// <param name="dateTime">A date. Must be in the past.</param>
        /// <returns>Textual description of time elapsed between param and now (e.g. x minutes ago, last week etc.)</returns>
        /// <remarks>Returns empty string if date is not in the past. All dates compared in UTC then conveted to local time for result.</remarks>
        public static string TryGetRelativeValueForPastDateLocal(DateTime dateTime)
        {
            DateTime now = DateTime.UtcNow;
            TimeSpan timeSpan = now - dateTime.ToUniversalTime();

            if (timeSpan.Ticks < 0)
            {
                return String.Empty;
            }

            // Now do all the relative stuff

            double totalSeconds = Math.Round(timeSpan.TotalSeconds);
            double totalMinutes = Math.Round(timeSpan.TotalMinutes);
            double totalHours = Math.Round(timeSpan.TotalHours);
            double totalDays = Math.Round(timeSpan.TotalDays);

            if (totalSeconds < 60)
            {
                return "Just Now";
            }
            else if (totalMinutes < 60)
            {
                if (totalMinutes == 1)
                {
                    return "1 Minute Ago";
                }
                else
                {
                    return totalMinutes + " Minutes Ago";
                }
            }

            else if (totalHours < 24)
            {
                if (totalHours == 1)
                {
                    return "1 Hour Ago";
                }
                else
                {
                    return totalHours + " Hours Ago";
                }
            }

            else
            {
                if (totalDays <= 1)
                {
                    return "Yesterday";
                }
                else if (totalDays < 7)
                {
                    return totalDays + " Days Ago";
                }
                else if (totalDays < 14)
                {
                    return "Last Week";
                }
                else if (totalDays < 42)
                {
                    double totalWeeks = Math.Round(totalDays / 7);
                    return totalWeeks + " Weeks Ago";
                }
                else
                {
                    DateTime local = TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(dateTime);
                    return DnaDateTime.GetMonthName(local.Month).Substring(0, 3) + " " + local.Day + ", " + local.Year;
                }
            }
        }

        /// <summary>
        /// Checks if date param is within database DateTime range.
        /// </summary>
        /// <param name="dateTime">Checked date</param>
        /// <returns>True if date within database DateTime range, otherwise false.</returns>
        public static bool IsDateWithinDBDateTimeRange (DateTime dateTime)
        {
	        DateTime minDBDateTime = new DateTime(1753, 1, 1, 0, 0, 0);
            DateTime maxDBDateTime = new DateTime(9999, 12, 31, 0, 0, 0);

            if (dateTime < minDBDateTime)
	        {
		        return false;
	        }

            if (dateTime > maxDBDateTime)
	        {
		        return false;
	        }

	        return true; 
        }

        /// <summary>
        /// Checks if date param is within database SmallDateTime range.
        /// </summary>
        /// <param name="dateTime">Checked date</param>
        /// <returns>True if date within database SmallDateTime range, otherwise false.</returns>
        public static bool IsDateWithinDBSmallDateTimeRange(DateTime dateTime)
        {
            DateTime minDBDateTime = new DateTime(1900, 1, 1, 0, 0, 0);
            DateTime maxDBDateTime = new DateTime(2079, 6, 6, 0, 0, 0);

            if (dateTime < minDBDateTime)
            {
                return false;
            }

            if (dateTime > maxDBDateTime)
            {
                return false;
            }

            return true;
        }
    }
}
