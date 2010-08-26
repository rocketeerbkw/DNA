using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MoreSubscribingUsersPageTests.cs
    /// </summary>
    [TestClass]
    public class MoreSubscribingUsersPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MoreSubscribingUsersFlat.xsd";
        private IInputContext _context = DnaMockery.CreateDatabaseInputContext();

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                //_request.UseEditorAuthentication = true;
                // _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMoreSubscribingUsersPageTest()
        {
            Console.WriteLine("Before Test01CreateMoreSubscribingUsersPageTest");
            _request.RequestPage("MSU6?skin=purexml");
            Console.WriteLine("After Test01CreateMoreSubscribingUsersPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }

        /// <summary>
        /// Test we get a more User Subscriptions page for the call. 
        /// </summary>
        [TestMethod]
        public void Test02GetMoreSubscribingUsersPageTest()
        {
            Console.WriteLine("Before Test02GetMoreSubscribingUsersPageTest");
            _request.RequestPage("MSU6?skin=purexml");
            Console.WriteLine("After Test02GetMoreSubscribingUsersPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST") != null, "The Subscribing Users list page has not been generated!!!");
        }

        /// <summary>
        /// Test we get a User Subscriptions page for the call and it's valid 
        /// </summary>
        [TestMethod]
        public void Test03CheckOutputFormatMoreSubscribingUsersPageTest()
        {
            Console.WriteLine("Before Test03CheckOutputFormatMoreSubscribingUsersPageTest");
            _request.RequestPage("MSU6?skin=purexml");
            Console.WriteLine("After Test03CheckOutputFormatMoreSubscribingUsersPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST") != null, "The Subscribing Users list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST/@SKIP") != null, "The Subscribing Users list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORESUBSCRIBINGUSERS/SUBSCRIBINGUSERS-LIST/@SHOW") != null, "The Subscribing Users list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MORESUBSCRIBINGUSERS[@USERID='6']") != null, "The Subscribing Users list page has not been generated correctly - USERID!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
    }
}

