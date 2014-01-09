using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Page;
using System.Web;
using System.Xml;

namespace Tests
{
    /// <summary>
    /// Summary description for DnaBasePageTests
    /// </summary>
    [TestClass]
    public class DnaBasePageTests
    {
        /// <summary>
        /// 
        /// </summary>
        public DnaBasePageTests()
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

        /// <summary>
        /// 
        /// </summary>
        [TestMethod, ExpectedException(typeof(HttpException))]
        public void ShouldThrowForbidenExceptionIfUserAgentMatchesItemInBannedAgentsList()
        {
            List<string> bannedAgents = new List<string>();
            bannedAgents.Add("bingbot");
            string botUserAgent = "HTTP/1.1 Mozilla/5.0+(compatible;+bingbot/2.0;++http://www.bing.com/bingbot.htm)";
            DnaBasePage basePage = new DnaBasePage(null);

            basePage.CheckForForbiddenUserAgents(botUserAgent, bannedAgents);
        }
        
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void ShouldNotThrowForbidenExceptionIfUserAgentDoesNotMatchesItemInBannedAgentsList()
        {
            List<string> bannedAgents = new List<string>();
            bannedAgents.Add("googlebot");
            string botUserAgent = "HTTP/1.1 Mozilla/5.0+(compatible;+bingbot/2.0;++http://www.bing.com/bingbot.htm)";
            DnaBasePage basePage = new DnaBasePage(null);

            basePage.CheckForForbiddenUserAgents(botUserAgent, bannedAgents);
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void GivenCallToAnyPage_WhenHostSourceParamOfUK_ThenPAGEDOMAINTagIsBBC_CO_UK()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("status-n?hostsource=uk&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsTrue(doc.SelectSingleNode("/H2G2/PAGEDOMAIN").InnerText == "bbc.co.uk");
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void GivenCallToAnyPage_WhenHostSourceParamNotProvided_ThenPAGEDOMAINTagIsBBC_CO_UK()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("status-n?hostsource=uk&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsTrue(doc.SelectSingleNode("/H2G2/PAGEDOMAIN").InnerText == "bbc.co.uk");
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void GivenCallToAnyPage_WhenHostSourceParamOfCOM_ThenPAGEDOMAINTagIsBBC_COM()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("status-n?hostsource=com&skin=purexml");
            XmlDocument doc = request.GetLastResponseAsXML();
            Assert.IsTrue(doc.SelectSingleNode("/H2G2/PAGEDOMAIN").InnerText == "bbc.com");
        }
    }
}
