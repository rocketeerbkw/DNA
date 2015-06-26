using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;

namespace FunctionalTests
{
    [TestClass]
    public class MorePagesPageTests
    {
        /// <summary>
        /// Check the page exists
        /// </summary>
        [TestMethod]
        public void TestMorePagesPage()
        {
            Console.WriteLine("Before MorePagesPage Tests - TestMorePagesPage");
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage(@"MA" + request.CurrentUserID.ToString() + "&skin=purexml");

            // now get the response
            XmlDocument xml = request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[@TYPE='MOREPAGES']") != null, "MorePages type does not exist!");

            Console.WriteLine("After MorePagesPage Tests - TestMorePagesPage");
        }
    }
}