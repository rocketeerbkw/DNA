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
    /// This class tests the Content Signif Admin Builder page showing the settings for the signif content for this site
    /// </summary>
    [TestClass]
    public class ContentSignifAdminBuilderPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2ContentSignifAdminFlat.xsd";

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
                //_request.UseDebugUser = false;
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }
        /// <summary>
        /// Test that we can get ContentSignifAdminBuilderPage
        /// </summary>
        [TestMethod]
        public void Test01GetContentSignifAdminBuilderPage()
        {
            Console.WriteLine("Before ContentSignifAdminBuilderPageTests - Test01GetContentSignifAdminBuilderPage");

            // now get the response
            _request.RequestPage("ContentSignifAdmin?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CONTENTSIGNIFSETTINGS") != null, "ContentSignifAdmin Settings tag does not exist!");

            Console.WriteLine("After Test01GetContentSignifAdminBuilderPage");
        }
        /// <summary>
        /// Test that the Content Signif Admin Builder Page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test02ValidateContentSignifAdminBuilderPage()
        {
            Console.WriteLine("Before Test02ValidateContentSignifAdminBuilderPage");

            //request the page
            _request.RequestPage("ContentSignifAdmin?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02ValidateContentSignifAdminBuilderPage");
        }
        /// <summary>
        /// Test that the Content Signif Admin Builder Page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test03IncrementContentSignifAdminSettings()
        {
            Console.WriteLine("Before Test03IncrementContentSignifAdminSettings");

            //request the page
            _request.RequestPage("ContentSignifAdmin?i_10_1=15&i_11_1=15&i_11_2=15&updatesitesettings=Update+Site+Content+Significance+Settings&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CONTENTSIGNIFSETTINGS") != null, "Settings tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CONTENTSIGNIFSETTINGS/SETTING[ACTION/ID='10'][VALUE='15']") != null, "Settings value is incorrect");


            Console.WriteLine("After Test03IncrementContentSignifAdminSettings");
        }

    }
}