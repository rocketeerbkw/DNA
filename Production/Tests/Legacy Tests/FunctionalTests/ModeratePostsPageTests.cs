using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    [TestClass]
    public class ModeratePostsPageTests
    {
        /// <summary>
        /// Check Normal User Does not have access .
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageNonModerator()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratePosts?modclassid=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModeratePostsPageXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratePosts?modclassid=1&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModeratePosts.xsd");
            validator.Validate();
        }
    }
}
