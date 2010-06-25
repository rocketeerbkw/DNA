using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
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



namespace FunctionalTests.Services.Articles
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class Article_V1
    {
        private const string _schemaArticle = "Dna.Services.Articles\\article.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("ShutDown Article_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp Article_V1");
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public Article_V1()
        {
          
        }

        
        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void GetArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetArticle_ReadOnly_ReturnsValidXml");

            int[] ids = { 559, 586, 630, 649, 667, 883, 937, 964, 1251, 1422, 79526,87130,87310,
                            88274,88319,88373,89804,91298,92369,92440,92495,99119,99452,99524,101755,101782};
            
            foreach (var id in ids)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
   
                Console.WriteLine("Validing ID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}/xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            
            }



            Console.WriteLine("After GetArticle_ReadOnly_ReturnsValidXml");
        }
    }
}
