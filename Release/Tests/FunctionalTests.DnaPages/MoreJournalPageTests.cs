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
    /// This class tests the MoreJournal page showing their more journal posts
    /// </summary>
    [TestClass]
    public class MoreJournalPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MoreJournalFlat.xsd";

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
        public void Test01GetMoreJournalPage()
        {
            Console.WriteLine("Before MoreJournalPageTests - Test01GetMoreJournalPage");

            //request the page
            _request.RequestPage("MJ1090501859&journal=7618990?&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/JOURNAL") != null, "MoreJournal tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/JOURNAL/JOURNALPOSTS") != null, "MoreJournal journal tag does not exist");

            Console.WriteLine("After Test01GetMoreJournalPage");
        }
        /// <summary>
        /// Test that the user page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test02ValidateMoreJournalPage()
        {
            Console.WriteLine("Before Test02ValidateMoreJournalPage");

            //request the page
            _request.RequestPage("MJ1090501859&journal=7618990?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateMoreJournalPage");
        }
    }
}