using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the MonthSummaryPage page showing the monthly articles summary
    /// </summary>
    [TestClass]
    public class MonthSummaryPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MonthSummaryFlat.xsd";

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
                _request.SetCurrentUserNormal();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get monthly summary up page
        /// </summary>
        [TestMethod]
        public void Test01GetMonthSummaryPage()
        {
            Console.WriteLine("Before MonthSummaryPageTests - Test01GetMonthSummaryPage");

            int H2G2ID = SetupASimpleGuideEntry();

            //request the page
            _request.RequestPage("Month?&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/MONTHSUMMARY") != null, "MonthSummary tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/MONTHSUMMARY/GUIDEENTRY") != null, "MonthSummary Guide Entry tag does not exist");

            Console.WriteLine("After Test01GetMonthSummaryPage");
        }
        /// <summary>
        /// Test that the user page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test02ValidateMonthSummaryPage()
        {
            Console.WriteLine("Before Test02ValidateMonthSummaryPage");

            int H2G2ID = SetupASimpleGuideEntry();

            //request the page
            _request.RequestPage("Month?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateMonthSummaryPage");
        }


        private int SetupASimpleGuideEntry()
        {
            int H2G2ID = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("createguideinternal"))
            {
                reader.ExecuteDEBUGONLY("exec createguideentry @subject='Test Entry', @bodytext='Test New Article', @extrainfo='<EXTRAINFO></EXTRAINFO>',@editor=6, @typeid=1, @status=1");
                if (reader.Read())
                {
                    H2G2ID = reader.GetInt32NullAsZero("H2G2ID");
                }
            }
            return H2G2ID;

        }

    }
}