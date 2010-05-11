using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using NUnit.Extensions.Asp;
using NUnit.Extensions.Asp.AspTester;
using NUnit.Extensions.Asp.HtmlTester;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Test subbed article status page builder
    /// </summary>
    [TestClass]
    public class SubbedArticleStatusTest : WebFormTestCase
    {
        /// <summary>
        /// Setup for the tests
        /// </summary>
        protected override void SetUp()
        {
            base.SetUp();
        }

        /// <summary>
        /// Tests that accessing the page via a non-editor returns a failure message
        /// </summary>
        [TestMethod]
        public void Test01RestrictedUsersSubbedArticle()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            Console.WriteLine("Before Test01RestrictedUsersSubbedArticle");
            dnaRequest.SetCurrentUserNormal();
            dnaRequest.UseEditorAuthentication = false;
            string relativePath = @"SubbedArticleStatus?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError != null, "No error returned for non-editor access");
            Assert.IsTrue(xmlError.Attributes["TYPE"] != null, "No error type returned for non-editor access");
            Assert.IsTrue(xmlError.Attributes["TYPE"].Value == "NOT-EDITOR", "Incorrect type returned for non-editor access");
            xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(xmlError != null && !String.IsNullOrEmpty(xmlError.InnerText), "No error message returned for non-editor access");
    
            Console.WriteLine("After Test01RestrictedUsersSubbedArticle");
       

        }

        /// <summary>
        /// Tests that accessing a non-existing article returns a failure message
        /// </summary>
        [TestMethod]
        public void Test02MissingSubbedArticle()
        {

            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            Console.WriteLine("Before Test02MissingSubbedArticle");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"SubbedArticleStatus?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError != null, "No error returned for non-existing content.");
            Assert.IsTrue(xmlError.Attributes["TYPE"] != null, "No error type returned for non-existing content.");
            Assert.IsTrue(xmlError.Attributes["TYPE"].Value == "NO-DETAILS", "Incorrect type returned for non-existing access");
            xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(xmlError != null && !String.IsNullOrEmpty(xmlError.InnerText), "No error message returned for non-existing content.");

            Console.WriteLine("After Test02MissingSubbedArticle");
       

        }


        /// <summary>
        /// Tests that accessing the page via a non-editor returns a failure message
        /// </summary>
        [TestMethod]
        public void Test03CorrectReturn()
        {

            Console.WriteLine("Before Test03CorrectReturn");
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();


            //create a dummy articles
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            ISite siteContext = DnaMockery.CreateMockedSite(context, 1, "", "h2g2", true);
            TestDataCreator testData = new TestDataCreator(context);
            int[] entryIDs = new int[1];
            int[] h2g2IDs = new int[1];
            Assert.IsTrue(testData.CreateEntries(siteContext.SiteID, dnaRequest.CurrentUserID, 3001, 3, ref entryIDs, ref h2g2IDs), "Articles not created");
            
            int[] recommendationIds = new int[1];
            Assert.IsTrue(testData.CreateRecommendations(dnaRequest.CurrentUserID, entryIDs, ref recommendationIds), "Recommendation not created");
            Assert.IsTrue(testData.AcceptRecommendations(dnaRequest.CurrentUserID, recommendationIds), "Recommendation accepted");


            dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"SubbedArticleStatus" + h2g2IDs[0] + "?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/SUBBED-ARTICLES");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            

            Console.WriteLine("After Test02MissingSubbedArticle");


        }


    }
}
