using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests.Services.Forums
{
    /// <summary>
    /// Class containing the forumSource_V1 Tests
    /// </summary>
    [TestClass]
    public class forumSource_V1
    {
        private const string _schemaForumSource = "Dna.Services.Forums\\forumSource.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After forumSource_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public forumSource_V1()
        {          
        }
        
        /// <summary>
        /// Test GetForumSource method from service
        /// </summary>
        [TestMethod]
        public void GetForumSource_V1Xml_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetForumSource_V1Xml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/forumsource?format=xml", _sitename, 150, 32);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"","") , _schemaForumSource);
            validator.Validate();

            Console.WriteLine("After GetForumSource_V1Xml_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetForumSource method from service checks that error is thrown
        /// </summary>
        [TestMethod]
        public void GetForumSource_V1Xml_ReadOnly_Returns404()
        {
            Console.WriteLine("Before GetForumSource_V1Xml_ReadOnly_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/forumsource?format=xml", _sitename, 666, 666);
            
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml", String.Empty, null);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ForumOrThreadNotFound.ToString(), errorData.Code);

            Console.WriteLine("After GetForumSource_V1Xml_ReadOnly_Returns404");
            
        }
    }
}
