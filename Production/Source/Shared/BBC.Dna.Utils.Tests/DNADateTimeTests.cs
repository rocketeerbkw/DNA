using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Schema;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test utility class DnaDateTime.cs
    /// </summary>
    [TestClass]
    public class DNADateTimeTests
    {
        private const string _schemaUri = "Date.xsd";
        private XmlDocument _xmlDocument;
        private XmlElement _dnaDateDefault; 

        /// <summary>
        /// Constructor
        /// </summary>
        public DNADateTimeTests()
        {
            _xmlDocument = new XmlDocument();

            _dnaDateDefault = CreateTestElement("Monday", "00", "00", "00", "31", "12", "December", "1899", "Unknown","00","31","Monday","12","December","Unknown");
        }

        /// <summary>
        /// Creates a XmlElement representing a date
        /// </summary>
        /// <param name="dayName">Day name</param>
        /// <param name="seconds">Seconds</param>
        /// <param name="minutes">Minutes</param>
        /// <param name="hours">Hours</param>
        /// <param name="day">Day</param>
        /// <param name="month">Month</param>
        /// <param name="monthName">Month name</param>
        /// <param name="year">Year</param>
        /// <param name="relative">Relative</param>
        /// <param name="localHour">Hour in local time</param>
        /// <param name="localDay">Day in local time</param>
        /// <param name="localDayName">Dayname in local time</param>
        /// <param name="localMonth">Month in local time</param>
        /// <param name="localMonthName">MonthName in local time</param>
        /// <param name="localRelative">Relative in local time</param>
        /// <returns>XmlElement representing a date</returns>
        private XmlElement CreateTestElement(string dayName, string seconds, string minutes, string hours, string day, string month, string monthName, string year, string relative, string localHour, string localDay, string localDayName, string localMonth, string localMonthName, string localRelative)
        {
            XmlElement dateElement = _xmlDocument.CreateElement("DATE");
            dateElement.SetAttribute("DAYNAME", dayName);
            dateElement.SetAttribute("SECONDS", seconds);
            dateElement.SetAttribute("MINUTES", minutes);
            dateElement.SetAttribute("HOURS", hours);
            dateElement.SetAttribute("DAY", day);
            dateElement.SetAttribute("MONTH", month);
            dateElement.SetAttribute("MONTHNAME", monthName);
            dateElement.SetAttribute("YEAR", year);
            dateElement.SetAttribute("SORT", year + month + day + hours + minutes + seconds);
            dateElement.SetAttribute("RELATIVE", relative);
            
            //Date in Local Time adjusted for BST .
            XmlElement localElement = _xmlDocument.CreateElement("LOCAL");
            localElement.SetAttribute("DAYNAME", localDayName);
            localElement.SetAttribute("SECONDS", seconds);
            localElement.SetAttribute("MINUTES", minutes);
            localElement.SetAttribute("HOURS", localHour);
            localElement.SetAttribute("DAY", localDay);
            localElement.SetAttribute("MONTH", localMonth);
            localElement.SetAttribute("MONTHNAME", localMonthName);
            localElement.SetAttribute("YEAR", year);
            localElement.SetAttribute("SORT", year + localMonth + localDay + localHour + minutes + seconds);
            localElement.SetAttribute("RELATIVE", localRelative);
            dateElement.AppendChild(localElement);
            return dateElement;
        }

        /// <summary>
        /// Checks equality of XML. 
        /// </summary>
        /// <param name="dateTime1">First XmlElement representing a date</param>
        /// <param name="dateTime2">Second XmlElement representing a date</param>
        /// <remarks>Returns void but asserts if the objects do not have the same values.</remarks>
        private void CheckEqualityOfXmlElementsRepresentingDates(XmlElement dateTime1, XmlElement dateTime2)
        {
            Assert.IsTrue(dateTime1.Name == "DATE", "dateTime1 is not a DATE");
            Assert.IsTrue(dateTime2.Name == "DATE", "dateTime2 is not a DATE");
            Assert.IsTrue(dateTime1.OuterXml == dateTime2.OuterXml, "Dates do not have the same attribute values."); 
        }

        /// <summary>
        /// Check month name is returned correctly. 
        /// </summary>
        [TestMethod]
        public void GetValidMonthNameTests()
        {
            Console.WriteLine("Before GetValidMonthNameTests");
            string month = DnaDateTime.GetMonthName(1);
            Assert.AreEqual("January", month);

            month = DnaDateTime.GetMonthName(12);
            Assert.AreEqual("December", month);
            Console.WriteLine("After GetValidMonthNameTests");
        }

        /// <summary>
        /// Check invalid month is processed appropriately. 
        /// </summary>
        [TestMethod]
        public void GetInValidMonthNameTests()
        {
            Console.WriteLine("Before GetInValidMonthNameTests");
            string month = DnaDateTime.GetMonthName(0);
            Assert.AreEqual("Unknown", month);

            month = DnaDateTime.GetMonthName(38843843);
            Assert.AreEqual("Unknown", month);

            month = DnaDateTime.GetMonthName(-347347);
            Assert.AreEqual("Unknown", month);
            Console.WriteLine("Before GetInValidMonthNameTests");
        }

        /// <summary>
        /// Check default date XML is as expected. 
        /// </summary>
        [TestMethod]
        public void GetDefaultDNADateTimeXMLTest()
        {
            Console.WriteLine("Before GetDefaultDNADateTimeXMLTest");
            XmlElement testElement = _dnaDateDefault; 
            XmlElement date = DnaDateTime.GetDefaultDateTimeAsElement(_xmlDocument);
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date);
            Console.WriteLine("After GetDefaultDNADateTimeXMLTest");
        }

        /// <summary>
        /// Check valid date string is processed as expected. 
        /// </summary>
        [TestMethod]
        public void ValidDateStringTest()
        {
            Console.WriteLine("Before ValidDateStringTest");
            XmlElement testElement = CreateTestElement("Friday", "00", "00", "00", "23", "09", "September", "2005", "Sep 23, 2005", "01", "23", "Friday", "09", "September", "Sep 23, 2005");
            XmlElement date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, "2005-09-23");
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date);
            Console.WriteLine("After ValidDateStringTest");
        }

        /// <summary>
        /// Check invalid month string is processed appropriately. 
        /// </summary>
        [TestMethod]
        public void InvalidDateStringTests()
        {
            Console.WriteLine("Before InvalidDateStringTests");
            XmlElement testElement = _dnaDateDefault; 

            XmlElement date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, "asldkjfalskjdf");
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date); 

            string param = "";
            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, param);
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date); 

            param = "23i9823<&*£>";
            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, param);
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date);
            Console.WriteLine("After InvalidDateStringTests");
        }

        /// <summary>
        /// Check valid DateTime is processed as expected. 
        /// </summary>
        [TestMethod]
        public void ValidDateTimeTest()
        {
            Console.WriteLine("Before ValidDateTimeTest");
            XmlElement testElement = CreateTestElement("Friday", "00", "00", "00", "23", "09", "September", "2005", "Sep 23, 2005", "01", "23", "Friday", "09", "September", "Sep 23, 2005");
            DateTime testDate = new DateTime(2005, 9, 23,0,0,0,DateTimeKind.Utc);
            XmlElement date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, testDate);
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date);
            Console.WriteLine("After ValidDateTimeTest");
        }

        /// <summary>
        /// Check invalid DateTime is processed appropriately. 
        /// </summary>
        [TestMethod]
        public void InvalidDateTimeTest()
        {
            Console.WriteLine("Before InvalidDateTimeTest");
            XmlElement testElement = _dnaDateDefault;
            DateTime testDate = new DateTime();
            XmlElement date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, testDate);
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            CheckEqualityOfXmlElementsRepresentingDates(testElement, date);
            Console.WriteLine("After InvalidDateTimeTest");
        }

        /// <summary>
        /// Test @Relative for appropriate values with simulating time in the past. 
        /// </summary>
        [TestMethod]
        public void RelativeAttributeTests()
        {
            Console.WriteLine("Before RelativeAttributeTests");
            XmlElement date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddSeconds(-5)); 
            DnaXmlValidator validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("Just Now", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddSeconds(-70));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("1 Minute Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddSeconds(-100));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("2 Minutes Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddMinutes(-5));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("5 Minutes Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddHours(-1));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("1 Hour Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddHours(-14));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("14 Hours Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddHours(-24));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("Yesterday", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddDays(-1));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("Yesterday", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddDays(-5));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("5 Days Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddDays(-7));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("Last Week", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddDays(-14));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("2 Weeks Ago", date.GetAttribute("RELATIVE"));

            date = DnaDateTime.GetDateTimeAsElement(_xmlDocument, DateTime.UtcNow.AddDays(-23));
            validator = new DnaXmlValidator(date, _schemaUri);
            validator.Validate();
            Assert.AreEqual("3 Weeks Ago", date.GetAttribute("RELATIVE"));

            Console.WriteLine("After RelativeAttributeTests");
        }

        /// <summary>
        /// SmallDateTime range tests. 
        /// </summary>
        [TestMethod]
        public void SmallDateTimeRangeTest()
        {
            Console.WriteLine("Before SmallDateTimeRangeTest");
            DateTime d = new DateTime(2007, 1, 1, 0, 0, 0);
            Assert.IsTrue(DnaDateTime.IsDateWithinDBSmallDateTimeRange(d), "Date unexpectedly lies outside SmallDateTime range.");

            d = new DateTime(1753, 1, 1, 0, 0, 0);
            Assert.IsFalse(DnaDateTime.IsDateWithinDBSmallDateTimeRange(d), "Date unexpectedly lies inside SmallDateTime range.");

            d = new DateTime(2080, 1, 1, 0, 0, 0);
            Assert.IsFalse(DnaDateTime.IsDateWithinDBSmallDateTimeRange(d), "Date unexpectedly lies inside SmallDateTime range.");
            Console.WriteLine("After SmallDateTimeRangeTest");
        }

        /// <summary>
        /// SmallDateTime range tests. 
        /// </summary>
        [TestMethod]
        public void DateTimeRangeTest()
        {
            Console.WriteLine("Before DateTimeRangeTest");
            DateTime d = new DateTime(2007, 1, 1, 0, 0, 0);
            Assert.IsTrue(DnaDateTime.IsDateWithinDBDateTimeRange(d), "Date unexpectedly lies outside SmallDateTime range.");

            d = new DateTime(1753, 1, 1, 0, 0, 0);
            Assert.IsTrue(DnaDateTime.IsDateWithinDBDateTimeRange(d), "Date unexpectedly lies outside SmallDateTime range.");

            d = new DateTime(1751, 1, 1, 0, 0, 0);
            Assert.IsFalse(DnaDateTime.IsDateWithinDBDateTimeRange(d), "Date unexpectedly lies inside SmallDateTime range.");
            Console.WriteLine("After DateTimeRangeTest");
        }
    }
}
