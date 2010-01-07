using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace RipleyTests
{
    [TestClass]
    public class CategoryTests
    {
        public CategoryTests() { }

        [TestMethod]
        public void TestRedirectNodeMissingForNonHiddenNodes()
        {
            Console.WriteLine("Before TestRedirectNodeMissingForNonHiddenNodes");
            // Connect to Actionnetwork and navigate to a known unhidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            request.RequestPage("C35474?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("//HIERARCHYDETAILS/REDIRECTNODEID") == null);
            Console.WriteLine("After TestRedirectNodeMissingForNonHiddenNodes");
        }

        [TestMethod, Ignore]
        public void TestRedirectNodeExistsForHiddenNodes()
        {
            Console.WriteLine("Before TestRedirectNodeExistsForHiddenNodes");
            // Connect to Actionnetwork and navigate to a known hidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            request.RequestPage("C10225?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("//HIERARCHYDETAILS/REDIRECTNODEID") != null);
            Console.WriteLine("After TestRedirectNodeExistsForHiddenNodes");
        }

        [TestMethod, Ignore]
        public void TestRedirectNodeExistsForAncestorsOnHiddenNodes()
        {
            Console.WriteLine("Before TestRedirectNodeExistsForAncestorsOnHiddenNodes");
            // Connect to Actionnetwork and navigate to a known hidden node with hidden ancestors
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            request.RequestPage("C10225?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("//HIERARCHYDETAILS/REDIRECTNODEID") != null);
            Assert.IsTrue(xml.SelectSingleNode("//HIERARCHYDETAILS/ANCESTRY/ANCESTOR/REDIRECTNODEID") != null);
            Console.WriteLine("After TestRedirectNodeExistsForAncestorsOnHiddenNodes");
        }

        [TestMethod, Ignore]
        public void TestHierarchySearchResultContainRedirectNodeIDs()
        {
            Console.WriteLine("Before TestHierarchySearchResultContainRedirectNodeIDs");
            // Connect to actionnetwork and search for a known hidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            request.RequestPage("search?searchtype=article&hierarchy=1&forum=1&thissite=1&searchstring=Burneston?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("//SEARCH/SEARCHRESULTS/HIERARCHYRESULT/REDIRECTNODEID") != null);
            Assert.IsTrue(xml.SelectSingleNode("//SEARCH/SEARCHRESULTS/HIERARCHYRESULT/ANCESTOR/@REDIRECTNODEID") != null);
            Console.WriteLine("After TestHierarchySearchResultContainRedirectNodeIDs");
        }

        [TestMethod]
        public void TestReturnKeyPhrasesInCategoryList()
        {
            Console.WriteLine("Before TestReturnKeyPhrasesInCategoryList");
            // Connect to Actionnetwork and navigate to a known unhidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            request.RequestPage("C36138?skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("//HIERARCHYDETAILS/REDIRECTNODEID") == null);
            Console.WriteLine("After TestReturnKeyPhrasesInCategoryList");
        }
    }
}
