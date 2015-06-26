using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests.Services.Moderation
{
    [TestClass]
    public class ModerateExLinksPageTests
    {
        /// <summary>
        /// Check Normal User Does not have access .
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageNonModerator()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModerateExLinks?modclassid=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageXml()
        {
            //Get an item in to the queue.
            ModerateItems_V1 exlinks = new ModerateItems_V1();
            exlinks.AddComplaintItemToModQueue();

            //Check the item is in the queue
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModerateExLinks?modclassid=1&alerts=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModerateExLinksPage.xsd");
            validator.Validate();
        }
    }
}
