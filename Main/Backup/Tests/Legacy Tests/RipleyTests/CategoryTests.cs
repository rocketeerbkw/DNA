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
