using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Functional Test Class for the Blog Summary Page
    /// </summary>
    [TestClass]
    public class BlogSummaryTests
    {
        string _schemaUri = "H2G2BlogSummaryFlat.xsd";

        /// <summary>
        /// Test the Blog Summary Page exists.
        /// </summary>
        [TestMethod]
        public void BlogSummaryPageExists()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            string url = "BlogSummary?skin=purexml&dna_list_ns=1";

            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

    }
}
