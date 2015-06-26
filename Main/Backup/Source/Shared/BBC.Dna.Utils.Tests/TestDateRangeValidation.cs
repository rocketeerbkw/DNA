using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// TestDateRangeValidation - Test suit for date range validation code
    /// </summary>
    [TestClass]
    public class TestDateRangeValidation
    {
        XmlDocument testDoc = new XmlDocument();
        DateRangeValidation dateValidation = new DateRangeValidation();

        /// <summary>
        /// Test a valid date range without future date checking
        /// </summary>
        [TestMethod]
        public void TestValidDateRangeWithNoFutureDateCheck()
        {
            Console.WriteLine("Before TestValidDateRangeWithNoFutureDateCheck");
            DateTime startDate = new DateTime(1972, 2, 26);
            DateTime endDate = new DateTime(1972, 2, 27);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Valid date range failed when it should of passed!");
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.LastResult, "Valid date range failed when it should of passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Assert.AreEqual(new DateTime(1972, 2, 26), dateValidation.LastStartDate, "Make sure last start date matches given start date");
            Assert.AreEqual(new DateTime(1972, 2, 27), dateValidation.LastEndDate, "Make sure last end date matches given end date");
            Console.WriteLine("After TestValidDateRangeWithNoFutureDateCheck");
        }

        /// <summary>
        /// Test a valid date range with future date checking
        /// </summary>
        [TestMethod]
        public void TestValidDateRangeWithFutureDateCheck()
        {
            Console.WriteLine("Before TestValidDateRangeWithFutureDateCheck");
            DateTime startDate = new DateTime(1972, 2, 26);
            DateTime endDate = new DateTime(1972, 2, 27);
            int timeInterval = 1;
            bool errorOnFutureDates = true;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Valid date range failed when it should of passed!");
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.LastResult, "Valid date range failed when it should of passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Assert.AreEqual(new DateTime(1972, 2, 26), dateValidation.LastStartDate, "Make sure last start date matches given start date");
            Assert.AreEqual(new DateTime(1972, 2, 27), dateValidation.LastEndDate, "Make sure last end date matches given end date");
            Console.WriteLine("After TestValidDateRangeWithFutureDateCheck");
        }

        /// <summary>
        /// Test an invalid start date - start date before SmallDateTime range
        /// </summary>
        [TestMethod]
        public void TestInvalidStartDate_StartDateBeforeSmallDateTimeRange()
        {
            Console.WriteLine("Before TestInvalidStartDate_StartDateBeforeSmallDateTimeRange");
            DateTime startDate = new DateTime(1889, 12, 1);
            DateTime endDate = new DateTime(1972, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.STARTDATE_INVALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid start date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "StartDateInvalid", "Error code not of expected type");
            Console.WriteLine("After TestInvalidStartDate_StartDateBeforeSmallDateTimeRange");
        }

        /// <summary>
        /// Test an invalid start date - start date after SmallDateTime range
        /// </summary>
        [TestMethod]
        public void TestInvalidStartDate_StartDateAfterSmallDateTimeRange()
        {
            Console.WriteLine("Before TestInvalidStartDate_StartDateAfterSmallDateTimeRange");
            DateTime startDate = new DateTime(2079, 7, 7);
            DateTime endDate = new DateTime(1990, 1, 1);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.STARTDATE_INVALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid start date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "StartDateInvalid", "Error code not of expected type");
            Console.WriteLine("After TestInvalidStartDate_StartDateAfterSmallDateTimeRange");
        }

        /// <summary>
        /// Test an invalid end date - end date before SmallDateTime range
        /// </summary>
        [TestMethod]
        public void TestInvalidEndDate_EndDateBeforeSmallDateTimeRange()
        {
            Console.WriteLine("Before TestInvalidEndDate_EndDateBeforeSmallDateTimeRange");
            DateTime startDate = new DateTime(1900, 1, 1);
            DateTime endDate = new DateTime(1889, 1, 1);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.ENDDATE_INVALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid end date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "EndDateInvalid", "Error code not of expected type");
            Console.WriteLine("After TestInvalidEndDate_EndDateBeforeSmallDateTimeRange");
        }

        /// <summary>
        /// Test an invalid end date - end date after SmallDateTime range
        /// </summary>
        [TestMethod]
        public void TestInvalidEndDate_EndDateAfterSmallDateTimeRange()
        {
            Console.WriteLine("Before TestInvalidEndDate_EndDateAfterSmallDateTimeRange");
            DateTime startDate = new DateTime(2079, 6, 5);
            DateTime endDate = new DateTime(2079, 7, 7);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.ENDDATE_INVALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid end date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "EndDateInvalid", "Error code not of expected type");
            Console.WriteLine("After TestInvalidEndDate_EndDateAfterSmallDateTimeRange");
        }

        /// <summary>
        /// Test future start date when erroring on future dates
        /// </summary>
        [TestMethod]
        public void TestFutureStartDateWhenErroringOnFutureDate()
        {
            Console.WriteLine("Before TestFutureStartDateWhenErroringOnFutureDate");
            DateTime startDate = new DateTime(2025, 1, 1);
            DateTime endDate = new DateTime(2025, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = true;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.FUTURE_STARTDATE, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Future start date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "StartDateInFuture", "Error code not of expected type");
            Console.WriteLine("After TestFutureStartDateWhenErroringOnFutureDate");
        }

        /// <summary>
        /// Test future start date when erroring on future dates
        /// </summary>
        [TestMethod]
        public void TestFutureStartDateWhenNotErroringOnFutureDate()
        {
            Console.WriteLine("Before TestFutureStartDateWhenNotErroringOnFutureDate");
            DateTime startDate = new DateTime(2025, 1, 1);
            DateTime endDate = new DateTime(2025, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Future start date failed when it should have passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Console.WriteLine("After TestFutureStartDateWhenNotErroringOnFutureDate");
        }

        /// <summary>
        /// Test future end date when erroring on future dates
        /// </summary>
        [TestMethod]
        public void TestFutureEndDateWhenErroringOnFutureDate()
        {
            Console.WriteLine("Before TestFutureEndDateWhenErroringOnFutureDate");
            DateTime startDate = new DateTime(2007, 10, 28);
            DateTime endDate = new DateTime(2025, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = true;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.FUTURE_ENDDATE, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Future end date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "EndDateInTheFuture", "Error code not of expected type");
            Console.WriteLine("After TestFutureEndDateWhenErroringOnFutureDate");
        }

        /// <summary>
        /// Test future end date when not erroring on future dates
        /// </summary>
        [TestMethod]
        public void TestFutureEndDateWhenNotErroringOnFutureDate()
        {
            Console.WriteLine("Before TestFutureEndDateWhenNotErroringOnFutureDate");
            DateTime startDate = new DateTime(2007, 10, 28);
            DateTime endDate = new DateTime(2025, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Future end date failed when it should have passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Console.WriteLine("After TestFutureEndDateWhenNotErroringOnFutureDate");
        }

        /// <summary>
        /// Test for start date equals end date
        /// </summary>
        [TestMethod]
        public void TestStartDateEqualsEndDate()
        {
            Console.WriteLine("Before TestStartDateEqualsEndDate");
            DateTime startDate = new DateTime(1972, 1, 1);
            DateTime endDate = new DateTime(1972, 1, 1);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.STARTDATE_EQUALS_ENDDATE, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Start date equals end date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "StartDateEqualsEndDate", "Error code not of expected type");
            Console.WriteLine("After TestStartDateEqualsEndDate");
        }

        /// <summary>
        /// Test for start date greater than end date
        /// </summary>
        [TestMethod]
        public void TestStartDateGreaterThanEndDate()
        {
            Console.WriteLine("Before TestStartDateGreaterThanEndDate");
            DateTime startDate = new DateTime(1972, 2, 1);
            DateTime endDate = new DateTime(1972, 1, 1);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.STARTDATE_GREATERTHAN_ENDDATE, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Start date greater than end date passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "StartDateGreaterThanEndDate", "Error code not of expected type");
            Console.WriteLine("After TestStartDateGreaterThanEndDate");
        }

        /// <summary>
        /// Test for an invalid time interval
        /// </summary>
        [TestMethod]
        public void TestInvalidTimeIntervalWhenErroringOnInvalidTimeIntervals()
        {
            Console.WriteLine("Before TestInvalidTimeIntervalWhenErroringOnInvalidTimeIntervals");
            DateTime startDate = new DateTime(1972, 1, 1);
            DateTime endDate = new DateTime(1972, 1, 2);
            int timeInterval = 5;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.TIMEINTERVAL_INVALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid time interval passed when it should of failed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "TimeIntervalInvalid", "Error code not of expected type");
            Console.WriteLine("After TestInvalidTimeIntervalWhenErroringOnInvalidTimeIntervals");
        }

        /// <summary>
        /// Test for an invalid time interval
        /// </summary>
        [TestMethod]
        public void TestInvalidTimeIntervalWhenNotErroringOnInvalidTimeIntervals()
        {
            Console.WriteLine("Before TestInvalidTimeIntervalWhenNotErroringOnInvalidTimeIntervals");
            DateTime startDate = new DateTime(1972, 1, 1);
            DateTime endDate = new DateTime(1972, 1, 2);
            int timeInterval = 5;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = false;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Invalid time interval failed when it should have passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Console.WriteLine("After TestInvalidTimeIntervalWhenNotErroringOnInvalidTimeIntervals");
        }

        /// <summary>
        /// Test for an valid time interval
        /// </summary>
        [TestMethod]
        public void TestValidTimeInterval()
        {
            Console.WriteLine("Before TestValidTimeInterval");
            DateTime startDate = new DateTime(1972, 1, 1);
            DateTime endDate = new DateTime(1972, 1, 2);
            int timeInterval = 1;
            bool errorOnFutureDates = false;
            bool errorOnInvalidTimeInterval = true;
            Assert.AreEqual(DateRangeValidation.ValidationResult.VALID, dateValidation.ValidateDateRange(startDate, endDate, timeInterval, errorOnFutureDates, errorOnInvalidTimeInterval), "Valid time interval failed when it should have passed!");
            XmlElement validationResult = dateValidation.GetLastValidationResultAsXmlElement(testDoc);
            Assert.AreEqual(validationResult.Attributes.GetNamedItem("CODE").Value, "NoError", "Error code not of expected type");
            Console.WriteLine("After TestValidTimeInterval");
        }
    }
}
