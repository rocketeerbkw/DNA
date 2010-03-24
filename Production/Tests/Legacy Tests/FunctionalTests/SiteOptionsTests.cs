using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Xml;

namespace FunctionalTests
{
    /// <summary>
    /// Summary description for SiteOptions
    /// </summary>
    [TestClass]
    public class SiteOptionsTests
    {
        public SiteOptionsTests()
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

        [TestMethod, Ignore]
        public void SiteOptions_ValidateSiteOptionsXMLFromRipley_ExpectValid()
        {
            // Get the XML from the c++
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("Status?skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();
            XmlElement siteoptions = (XmlElement)xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS");
            Assert.IsNotNull(siteoptions, "Failed to get the site options from the XML");
            DnaXmlValidator validator = new DnaXmlValidator(siteoptions, "SiteOptions.xsd");
            validator.Validate();
        }

        [TestMethod]
        public void SiteOptions_ValidateSiteOptionsXMLFromBBCDNA_ExpectValid()
        {
            // Get the XML from the c#
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("Status-n?skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();
            XmlElement siteoptions = (XmlElement)xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS");
            Assert.IsNotNull(siteoptions, "Failed to get the site options from the XML");
            DnaXmlValidator validator = new DnaXmlValidator(siteoptions, "SiteOptions.xsd");
            validator.Validate();
        }

        [TestMethod]
        public void SiteOptions_CheckGlobalAttributeForKidsAndNonKidsSiteInRipley_Expect0ForKids1ForNonKids()
        {
            // Get the XML from the c++
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("Status?skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();
            XmlNode siteoption = xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']");
            Assert.IsNotNull(siteoption, "Failed to get the site options from the XML");
            Assert.AreEqual("1",siteoption.Attributes["GLOBAL"].Value, "Failed to get the site options from the XML");

            request = new DnaTestURLRequest("mbcbbc");
            request.RequestPage("Status?skin=purexml");
            xDoc = request.GetLastResponseAsXML();
            siteoption = xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']");
            Assert.IsNotNull(siteoption, "Failed to get the site options from the XML");
            Assert.AreEqual("0", siteoption.Attributes["GLOBAL"].Value, "Failed to get the site options from the XML");
        }

        [TestMethod]
        public void SiteOptions_CheckGlobalAttributeForKidsAndNonKidsSiteINBBCDNA_Expect0ForKids1ForNonKids()
        {
            // Get the XML from the c#
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("Status-n?skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();
            XmlNode siteoption = xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']");
            Assert.IsNotNull(siteoption, "Failed to get the site options from the XML");
            Assert.AreEqual("1", siteoption.Attributes["GLOBAL"].Value, "Failed to get the site options from the XML");

            request = new DnaTestURLRequest("mbcbbc");
            request.RequestPage("Status?skin=purexml");
            xDoc = request.GetLastResponseAsXML();
            siteoption = xDoc.SelectSingleNode("/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']");
            Assert.IsNotNull(siteoption, "Failed to get the site options from the XML");
            Assert.AreEqual("0", siteoption.Attributes["GLOBAL"].Value, "Failed to get the site options from the XML");
        }
    }
}
