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
using BBC.Dna;
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
        /// Test CreateArticle method from service
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
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();            
            }
            Console.WriteLine("After GetArticle_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test CreateRandomArticle method from service
        /// </summary>
        [TestMethod]
        public void GetRandomArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetRandomArticle_ReadOnly_ReturnsValidXml");

            for(int i=0 ;i < 50; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                Console.WriteLine("Get Random Article");
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/random?type=Edited&format=xml", _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetRandomArticle_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetComingUpArticles method from service
        /// </summary>
        [TestMethod]
        public void GetComingUpArticles_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetComingUpArticles_ReadOnly_ReturnsValidXml");

            for (int i = 0; i < 10; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/comingup?format=xml", _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();


                //DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                //validator.Validate();
            }
            Console.WriteLine("After GetComingUpArticles_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetMonthlySummary method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");

            for (int i = 0; i < 10; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

                try
                {
                    // now get the response
                    request.RequestPageWithFullURL(url, null, "text/xml");
                }
                catch (Exception Ex)
                {
                    Assert.IsTrue(Ex.Message.Contains("Month summary not found"));
                }
            }
            Console.WriteLine("After GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");
        }
        /// <summary>
        /// Test GetMonthlySummaryArticles_WithSomeArticles method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_WithSomeArticles()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_WithSomeArticles");

            SetupMonthSummaryArticle();

            for (int i = 0; i < 10; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                XmlDocument xml = request.GetLastResponseAsXML();
            }
            Console.WriteLine("After GetMonthlySummaryArticles_WithSomeArticles");
        }

        /// <summary>
        /// Test GetSearchArticles method from service
        /// Needs guide entry cat on smallguide created
        /// </summary>
        [TestMethod]
        public void GetSearchArticles()
        {
            Console.WriteLine("Before GetSearchArticles");

            SetupFullTextIndex();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles?querystring=dinosaur&showapproved=1&type=ARTICLE&format=xml", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After GetSearchArticles");
        }


        private void SetupFullTextIndex()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT CATALOG GuideEntriesCat WITH ACCENT_SENSITIVITY = OFF");
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT INDEX ON dbo.GuideEntries(Subject, text) KEY INDEX PK_GuideEntries ON GuideEntriesCat WITH CHANGE_TRACKING AUTO");
            }

            //wait a bit for the cat to be filled
            System.Threading.Thread.Sleep(20000);
        }


        private void SetupMonthSummaryArticle()
        {
            int entryId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {

                reader.ExecuteDEBUGONLY("SELECT TOP 1 * from guideentries where status=1 and siteid=1 ORDER BY EntryID DESC");
                if (reader.Read())
                {
                    entryId = reader.GetInt32("entryid");
                }
                if (entryId > 0)
                {
                    reader.ExecuteDEBUGONLY(string.Format("update guideentries set datecreated = getdate() where entryid={0}", entryId));
                }
            }
        }
    }
}
