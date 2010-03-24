using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Tests;

using TestUtils;
namespace FunctionalTests
{
    /// <summary>
    /// Tests for the UserList class
    /// </summary>
    [TestClass]
    public class InfoPageBuilderTests
    {
        
        /// <summary>
        /// Constructor for the User Tests to set up the context for the tests
        /// </summary>
        public InfoPageBuilderTests()
        {
          
        }

        /// <summary>
        /// Tests edited entries command
        /// </summary>
        [TestMethod]
        public void Test1_CreateTotalApprovedEntries()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"Info?cmd=TAE&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/INFO");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, "info_editedentries.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Tests unedited entries command
        /// </summary>
        [TestMethod]
        public void Test2_CreateUneditedArticleCount()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"Info?cmd=TUE&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/INFO");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, "info_uneditedentries.xsd");
            validator.Validate();
        }


        /// <summary>
        /// Tests unedited entries command
        /// </summary>
        [TestMethod]
        public void Test3_CreateRecentConversations()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"Info?cmd=conv&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/INFO");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, "info_conv.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Tests unedited entries command
        /// </summary>
        [TestMethod]
        public void Test4_CreateRecentArticles()
        {
            DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            //DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
            dnaRequest.SetCurrentUserEditor();
            dnaRequest.UseEditorAuthentication = true;
            string relativePath = @"Info?cmd=ART&skin=purexml";
            dnaRequest.RequestPage(relativePath);
            XmlDocument xmlResponse = dnaRequest.GetLastResponseAsXML();

            //check for error tag
            XmlNode xmlError = xmlResponse.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "Incorrect error returned");

            XmlNode xmlSub = xmlResponse.SelectSingleNode("/H2G2/INFO");
            Assert.IsTrue(xmlSub != null, "Incorrect data returned");
            DnaXmlValidator validator = new DnaXmlValidator(xmlSub.OuterXml, "info_freshest.xsd");
            validator.Validate();
        }
        
    }
}
