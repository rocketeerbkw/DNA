using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the Statistics Report page showing the posts per topic for a interval period
    /// </summary>
    [TestClass]
    public class StatisticsReportPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2StatisticsReportFlat.xsd";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("Setting up");
                _request.UseEditorAuthentication = true;
                _request.SetCurrentUserEditor();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }
        /// <summary>
        /// Test that we can get user statistics page
        /// </summary>
        [TestMethod]
        public void Test01GetStatisticsReportPage()
        {
            Console.WriteLine("Before StatisticsReportPageTests - Test01GetStatisticsReportPage");
            
            // now get the response
            _request.RequestPage("StatisticsReport?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/POSTING-STATISTICS") != null, "Statistics Report tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/POSTING-STATISTICS[@INTERVAL='day']") != null, "Interval incorrect");
            Console.WriteLine("After Test01GetStatisticsReportPage");
        }

        /// <summary>
        /// Test that we can get
        /// </summary>
        [TestMethod]
        public void Test02MonthIntervalStatisticsReportPage()
        {
            Console.WriteLine("Before Test02MonthIntervalStatisticsReportPage");

            // now get the response
            _request.RequestPage("StatisticsReport?interval=month&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/POSTING-STATISTICS") != null, "Statistics Report tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/POSTING-STATISTICS[@INTERVAL='month']") != null, "Interval incorrect");

            Console.WriteLine("After Test02MonthIntervalStatisticsReportPage");
        }

        /// <summary>
        /// Test that the statistics report page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test03ValidateStatisticsReportPage()
        {
            Console.WriteLine("Before Test03ValidateStatisticsReportPage");

            // now get the response
            _request.RequestPage("StatisticsReport?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test03ValidateStatisticsReportPage");
        }

    }
}