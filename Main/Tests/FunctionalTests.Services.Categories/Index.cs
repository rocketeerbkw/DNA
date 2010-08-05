using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Xml;
using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Utils;

namespace FunctionalTests.Dna.Services.Categories
{
    /// <summary>
    /// Summary description for Index
    /// </summary>
    [TestClass]
    public class Index
    {
        private const string _schemaIndex = @"Dna.Services.Categories\index.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        public Index()
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

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("ShutDown Index_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp Index_V1");
            //SnapshotInitialisation.RestoreFromSnapshot();
        }

        [TestMethod]
        public void GetIndex_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetIndex_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            Console.WriteLine("Get index for A");
            string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/index/A?format=xml", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaIndex);
            validator.Validate();

            Console.WriteLine("After GetIndex_ReadOnly_ReturnsValidXml");
        }

        [TestMethod]
        public void GetIndex_WithOptions()
        {
            Console.WriteLine("Before GetIndex_WithOptions");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            Console.WriteLine("Get index for B with showSubmitted on");
            string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/index/B?format=xml&showApproved=0&showSubmitted=1", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information           
            BBC.Dna.Objects.Index returnedIndex =
                (BBC.Dna.Objects.Index)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Objects.Index));
            Assert.IsTrue(returnedIndex.IndexEntries[0].Status.Value == BBC.Dna.Objects.ArticleStatus.GetStatus(4).Value, "Incorrect Status returned");

            Console.WriteLine("Get index for O with showUnapproved on");
            url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/index/O?format=xml&showApproved=0&showUnapproved=1", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            returnedIndex =
                (BBC.Dna.Objects.Index)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Objects.Index));
            Assert.IsTrue(returnedIndex.IndexEntries[0].Status.Value == BBC.Dna.Objects.ArticleStatus.GetStatus(3).Value, "Incorrect Status returned");

            Console.WriteLine("Get index for S with order by lastupdated");
            url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/index/S?format=xml&showApproved=1&orderby=lastupdated", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            returnedIndex =
                 (BBC.Dna.Objects.Index)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Objects.Index));
            Assert.IsTrue(returnedIndex.IndexEntries[0].Status.Value == BBC.Dna.Objects.ArticleStatus.GetStatus(1).Value, "Incorrect Status returned");

            Console.WriteLine("After GetIndex_WithOptions");
        }

        [TestMethod]
        public void GetIndex_UnknownSite_Returns404()
        {
            Console.WriteLine("Before GetIndex_UnknownSite_Returns404");


            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            string unknownSite = "unknown_site";

            Console.WriteLine("Validing site:" + unknownSite);
            string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/index/A?format=xml", unknownSite);
            // now get the response

            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml", String.Empty, null);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("After GetIndex_UnknownSite_Returns404");
        }
    }
}
