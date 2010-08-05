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
    /// Summary description for categories
    /// </summary>
    [TestClass]
    public class categories
    {
        private const string _schemaArticle = @"Dna.Services.Categories\category.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        public categories()
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
            Console.WriteLine("ShutDown Category_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp Category_V1");
            //SnapshotInitialisation.RestoreFromSnapshot();
        }

        [TestMethod]
        public void GetCategory_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetCategory_ReadOnly_ReturnsValidXml");

            int[] ids = { 889,  // top level element, no ancestors
                          74,   // child of 889
                          4,     // 2 ancestors, categories with subndodes
                          50    // contains an article summary
                        };

            foreach (var id in ids)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Validing ID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/categories/{1}?format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }

            Console.WriteLine("After GetCategory_ReadOnly_ReturnsValidXml");
        }

        [TestMethod]
        public void GetCategory_UnknownSite_Returns404()
        {
            Console.WriteLine("Before GetCategory_UnknownSite_Returns404");


            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            int id = 889;
            string unknownSite = "unknown_site";

            Console.WriteLine("Validing site:" + unknownSite);
            string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/categories/{1}?format=xml", unknownSite, id);
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

            Console.WriteLine("After GetCategory_UnknownSite_Returns404");
        }

        [TestMethod]
        public void GetCategory_UnknownCategory_Returns404()
        {
            Console.WriteLine("Before GetCategory_UnknownSite_Returns404");


            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            int unknown_id = 1; // non existing 

            Console.WriteLine("Validing category:" + unknown_id);
            string url = String.Format("http://" + _server + "/dna/api/categories/categoryservice.svc/V1/site/{0}/categories/{1}?format=xml", _sitename, unknown_id);
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
            Assert.AreEqual(ErrorType.CategoryNotFound.ToString(), errorData.Code);

            Console.WriteLine("After GetCategory_UnknownSite_Returns404");
        }
    }
}
