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
    public class SubEditorAllocationTest : WebFormTestCase
    {
        private int[] entryIDs;
        private int[] h2g2IDs;
        private int[] recommendationIds;
        private int[] userIDs;
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
        public void Test01_NonEditorError()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserNormal();
            dnaRequest.UseEditorAuthentication = false;
            string relativePath = @"AllocateSubs?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError != null, "No error returned for non-editor access");
            Assert.IsTrue(xmlError.Attributes["TYPE"] != null, "No error type returned for non-editor access");
            Assert.IsTrue(xmlError.Attributes["TYPE"].Value == "NOT-EDITOR", "Incorrect type returned for non-editor access");
            xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR/ERRORMESSAGE");
            Assert.IsTrue(xmlError != null && !String.IsNullOrEmpty(xmlError.InnerText), "No error message returned for non-editor access");
      

        }

        /// <summary>
        /// Tests that accessing the page without parameters returns correct values
        /// </summary>
        [TestMethod]
        public void Test02_CorrectReturnViewing()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"AllocateSubs?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, "AllocateSubs.xsd");
            validator.Validate();


        }

        /// <summary>
        /// Test real time functionality that allocates and deallocates entries
        /// </summary>
        [TestMethod]
        public void Test03_CorrectAllocationTests()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();

            //create a dummy articles
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            ISite siteContext = DnaMockery.CreateMockedSite(context, 1, "", "h2g2", false);
            TestDataCreator testData = new TestDataCreator(context);
            entryIDs = new int[10];
            h2g2IDs = new int[10];
            Assert.IsTrue(testData.CreateEntries(siteContext.SiteID, dnaRequest.CurrentUserID, 3001, 3, ref entryIDs, ref h2g2IDs), "Articles not created");

            recommendationIds = new int[10];
            Assert.IsTrue(testData.CreateRecommendations(dnaRequest.CurrentUserID, entryIDs, ref recommendationIds), "Recommendation not created");
            Assert.IsTrue(testData.AcceptRecommendations(dnaRequest.CurrentUserID, recommendationIds), "Recommendation accepted");

            //create test sub editors
            userIDs = new int[10];
            Assert.IsTrue(testData.CreateNewUsers(siteContext.SiteID, ref userIDs), "Test users not created");
            Assert.IsTrue(testData.CreateNewUserGroup(dnaRequest.CurrentUserID, "subs"), "CreateNewUserGroup not created");
            Assert.IsTrue(testData.AddUsersToGroup(userIDs, siteContext.SiteID, "subs"), "Unable to add users to group not created");

            //get unallocated values from list
            dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = "allocatesubs?skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/UNALLOCATED-RECOMMENDATIONS") != null, "Incorrect data returned");
            //update entryids with unallocated values
            XmlNode unallocRecommendations = xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/UNALLOCATED-RECOMMENDATIONS/ARTICLE-LIST");
            for (int i = 0; i < entryIDs.Length && i < unallocRecommendations.ChildNodes.Count; i++)
            {
                entryIDs[i] = Int32.Parse(unallocRecommendations.ChildNodes[i].SelectSingleNode("ENTRY-ID").InnerText);
            }


            //allocate 2 articles to sub editor
            dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            relativePath = "allocatesubs?&Command=ALLOCATE&EntryID=" + entryIDs[0] + "&EntryID=" + entryIDs[1] + "&SubID=" + userIDs[0] + "&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            xmlResponse = dnaRequest.GetLastResponseAsXML();
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/SUCCESSFUL-ALLOCATIONS") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/FAILED-ALLOCATIONS") != null, "Incorrect data returned");

            //deallocate those two
            relativePath = @"AllocateSubs?command=DEALLOCATE&DeallocateID=" + entryIDs[0] + "&DeallocateID=" + entryIDs[1] + "&SubID=" + userIDs[0] + "&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            xmlResponse = dnaRequest.GetLastResponseAsXML();
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/SUCCESSFUL-DEALLOCATIONS") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/FAILED-DEALLOCATIONS") != null, "Incorrect data returned");
            
            //auto allocate some
            relativePath = @"AllocateSubs?command=AUTOALLOCATE&Amount=2&SubID=" + userIDs[0] + "&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            xmlResponse = dnaRequest.GetLastResponseAsXML();
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/SUCCESSFUL-ALLOCATIONS") != null, "Incorrect data returned");
            Assert.IsTrue(xmlResponse.SelectSingleNode("/H2G2/SUB-ALLOCATION-FORM/FAILED-ALLOCATIONS") != null, "Incorrect data returned");
        }

    }
}
