using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test the hierarchy page via the web host system
    /// </summary>
    [TestClass]
    public class HierarchyHostPageTests
    {
        /// <summary>
        /// Create the asp host before we start the tests
        /// </summary>
        [TestInitialize]
        public void SetUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Call the hierarchy page with the nocache setting and siteid = 16.
        /// </summary>
        [TestMethod]
        public void Test01RequestHierarchyPageWithSiteIDAndNoCaching()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            Console.WriteLine("Test01RequestHierarchyPageWithSiteIDAndNoCaching");
            request.RequestAspxPage("HierarchyPage.aspx", "siteid=16&d_nocache=1&skin=purexml");
            XmlDocument xmldoc = new XmlDocument();
            try
            {
                xmldoc.LoadXml(request.GetLastResponseAsString());
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message + request.GetLastResponseAsString());
                //Assert.Fail(e.Message + _asphost.ResponseString);
            }

            Assert.IsNotNull(xmldoc.SelectSingleNode("//HIERARCHYNODES"), "Expected a HIERARCHYNODES XML Tag!!!");
            Assert.AreEqual("16", xmldoc.SelectSingleNode("//HIERARCHYNODES").Attributes["SITEID"].Value, "Incorrect site id in XML");
        }

        /// <summary>
        /// Call the hierarchy page with siteid = 16.
        /// </summary>
        [TestMethod]
        public void Test02RequestHierarchyPageWithSiteID()
        {
            Console.WriteLine("Test02RequestHierarchyPageWithSiteID");
            XmlDocument xmldoc = new XmlDocument();
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            try
            {
                request.RequestAspxPage("HierarchyPage.aspx", "siteid=16&skin=purexml");
                xmldoc.LoadXml(request.GetLastResponseAsString());
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message + request.GetLastResponseAsString());
                //Assert.Fail(e.Message + _asphost.ResponseString);
            }
            Assert.IsNotNull(xmldoc.SelectSingleNode("//HIERARCHYNODES"), "Expected a HIERARCHYNODES XML Tag!!!");
            Assert.AreEqual("16", xmldoc.SelectSingleNode("//HIERARCHYNODES").Attributes["SITEID"].Value, "Incorrect site id in XML");
        }

        /// <summary>
        /// Call the hierarchy page.
        /// </summary>
        [TestMethod]
        public void Test03RequestHierarchyPage()
        {
            Console.WriteLine("Test03RequestHierarchyPage");
            XmlDocument xmldoc = new XmlDocument();
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            try
            {
                request.RequestAspxPage("HierarchyPage.aspx", "_si=actionnetwork&skin=purexml");
                xmldoc.LoadXml(request.GetLastResponseAsString());
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message + request.GetLastResponseAsString());
                //Assert.Fail(e.Message + _asphost.ResponseString);
            }
            Assert.IsNotNull(xmldoc.SelectSingleNode("//HIERARCHYNODES"), "Expected a HIERARCHYNODES XML Tag!!!");
            Assert.AreEqual("16", xmldoc.SelectSingleNode("//HIERARCHYNODES").Attributes["SITEID"].Value, "Incorrect site id in XML");
        }

        /// <summary>
        /// Call the hierarchy page on a site with no hierarchy.
        /// </summary>
        [TestMethod]
        public void Test04RequestHierarchyPageForSiteWithNoHierarchy()
        {
            Console.WriteLine("Test04RequestHierarchyPageForSiteWithNoHierarchy");
            XmlDocument xmldoc = new XmlDocument();
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            try
            {
                request.RequestAspxPage("HierarchyPage.aspx", "_si=mb606&skin=purexml");
                xmldoc.LoadXml(request.GetLastResponseAsString());
            }
            catch (Exception e)
            {
                System.Console.Write(e.Message + request.GetLastResponseAsString());
                //Assert.Fail(e.Message + _asphost.ResponseString);
            }
            
            Assert.IsNotNull(xmldoc.SelectSingleNode("//ERROR"), "Expected an error tag!!!");
            Assert.AreEqual("nohierarchydata", xmldoc.SelectSingleNode("//ERROR").Attributes["TYPE"].Value, "Make sure the error returned is of type nohierarchydata");
        }

        /// <summary>
        /// Call the hierarchy page on Action Network. Exersise the HTML Transformer
        /// </summary>
        [Ignore]
        public void Test05RequestHierarchyPageForActionNetwork()
        {
            Console.WriteLine("Test05RequestHierarchyPageForActionNetwork");
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.RequestAspxPage("HierarchyPage.aspx", @"s_popup=1");
           
            string pageOutput = request.GetLastResponseAsString();
            Assert.IsTrue(pageOutput.Contains("Location"), "Returned page did not contain \"Location\". Returned page:\n" + pageOutput);
        }
    }

    /// <summary>
    /// Test utility class HierarchyPageTests.cs
    /// </summary>
    [TestClass]
    public class HierarchyPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("actionnetwork");

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
                //_request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateHierarchyPageTest()
        {
            Console.WriteLine("Test01CreateHierarchyPageTest");
            _request.RequestPage("Hierarchy?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }

        /// <summary>
        /// Test we can get to the page with the site parameter. 
        /// </summary>
        [TestMethod]
        public void Test02CheckHierarchyForSiteTest()
        {
            Console.WriteLine("Test02CheckHierarchyForSiteTest");
            _request.RequestPage("Hierarchy?siteid=1&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/HIERARCHYNODES[@SITEID='1']") != null, "The hierarchy nodes for site 16 do not exist!!!");
        }

        /// <summary>
        /// Test we can get to the top node. 
        /// </summary>
        [TestMethod]
        void Test03CheckHierarchyXmlFormatTest()
        {
            Console.WriteLine("Test03CheckHierarchyXmlFormatTest");
            _request.RequestPage("Hierarchy?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/HIERARCHYNODES/NODE[@NODEID='1290']") != null, "The top node does not exist!!!");
        }

        /// <summary>
        /// Test we can get to the Work life balance node. This should be an issue type
        /// </summary>
        [Ignore]
        void Test04CheckWorklifebalanceHierarchyXmlFormatTest()
        {
            Console.WriteLine("Test04CheckWorklifebalanceHierarchyXmlFormatTest");
            _request.RequestPage("Hierarchy?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlElement element = (XmlElement)xml.SelectSingleNode("H2G2/HIERARCHYNODES//NODE[@NODEID='2222']");
            Assert.IsTrue(element != null, "The node 2222 does not exist!!!");
            Assert.AreEqual("Work life balance", element.Attributes["NAME"].InnerText, "The Work life balance element 2222 does not exist!!!");
            Assert.AreEqual("5", element.Attributes["TREELEVEL"].InnerText, "The Work life balance tree level is not one!!!");
            Assert.AreEqual("2", element.Attributes["TYPE"].InnerText, "The Work life balance type is not 1!!!");
        }

        /// <summary>
        /// Test we can get to the Basildon node. This should be a location type
        /// </summary>
        [Ignore]
        void Test05CheckBasildonHierarchyXmlFormatTest()
        {
            Console.WriteLine("Test05CheckBasildonHierarchyXmlFormatTest");
            _request.RequestPage("Hierarchy?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            XmlElement element = (XmlElement)xml.SelectSingleNode("H2G2/HIERARCHYNODES/NODE[@NODEID='1290']/NODE[@NODEID='2654']/NODE[@NODEID='10220']/NODE[@NODEID='30939']/NODE[@NODEID='30940']/NODE[@NODEID='31812']");
            Assert.IsTrue(element != null, "The Basildon node does not exist!!!");
            Assert.AreEqual("Basildon", element.Attributes["NAME"].InnerText, "The Basildon element 31812 does not exist!!!");
            Assert.AreEqual("5", element.Attributes["TREELEVEL"].InnerText, "The Basildon tree level is not five!!!");
            Assert.AreEqual("3", element.Attributes["TYPE"].InnerText, "The Basildon type is not 3!!!");
        }
    }
}