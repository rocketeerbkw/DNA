using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for date
    /// </summary>
    [TestClass]
    public class DateTests
    {
        public DateTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void DateAsObject()
        {

            DateTime dateTime = DateTime.Now.AddHours(-7);

            Date date = new Date(dateTime);

            //test local timings
            Assert.AreEqual(date.Local.Hours, dateTime.Hour);
            Assert.AreEqual(date.Local.Minutes, dateTime.Minute);
            Assert.AreEqual(date.Local.Month, dateTime.Month);
            Assert.AreEqual(date.Local.Seconds, dateTime.Second);
            Assert.AreEqual(date.Local.Year, dateTime.Year);
            Assert.AreEqual(date.Local.Sort, dateTime.ToString("yyyyMMddHHmmss"));
            Assert.AreEqual(date.Local.Relative, DnaDateTime.TryGetRelativeValueForPastDate(dateTime));

            //test universal timings
            dateTime = dateTime.ToUniversalTime();
            Assert.AreEqual(date.Hours, dateTime.Hour);
            Assert.AreEqual(date.Minutes, dateTime.Minute);
            Assert.AreEqual(date.Month, dateTime.Month);
            Assert.AreEqual(date.Seconds, dateTime.Second);
            Assert.AreEqual(date.Year, dateTime.Year);
            Assert.AreEqual(date.Sort, dateTime.ToString("yyyyMMddHHmmss"));
            Assert.AreEqual(date.Relative, DnaDateTime.TryGetRelativeValueForPastDate(dateTime));

        }

        [TestMethod]
        public void DateAsXml()
        {

            DateTime dateTime = DateTime.Now;
            Date date = new Date(dateTime);

            XmlDocument xml = Serializer.SerializeToXml(date);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "date.xsd");
            validator.Validate();

            XmlNode local = xml.SelectSingleNode("DATE/LOCAL");
            Assert.AreEqual(local.Attributes["SECONDS"].Value, dateTime.Second.ToString());
            Assert.AreEqual(local.Attributes["MINUTES"].Value, dateTime.Minute.ToString());
            Assert.AreEqual(local.Attributes["HOURS"].Value, dateTime.Hour.ToString());
            Assert.AreEqual(local.Attributes["DAY"].Value, dateTime.Day.ToString());
            Assert.AreEqual(local.Attributes["MONTH"].Value, dateTime.Month.ToString());
            Assert.AreEqual(local.Attributes["YEAR"].Value, dateTime.Year.ToString());


            local = xml.SelectSingleNode("DATE");
            dateTime = dateTime.ToUniversalTime();
            Assert.AreEqual(local.Attributes["SECONDS"].Value, dateTime.Second.ToString());
            Assert.AreEqual(local.Attributes["MINUTES"].Value, dateTime.Minute.ToString());
            Assert.AreEqual(local.Attributes["HOURS"].Value, dateTime.Hour.ToString());
            Assert.AreEqual(local.Attributes["DAY"].Value, dateTime.Day.ToString());
            Assert.AreEqual(local.Attributes["MONTH"].Value, dateTime.Month.ToString());
            Assert.AreEqual(local.Attributes["YEAR"].Value, dateTime.Year.ToString());
           
        }

        
    }
}

