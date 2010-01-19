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
    /// Test utility class PageAuthorZeitgeistTest.cs
    /// </summary>
    [TestClass]
    public class PageAuthorZeitgeistTest
    {
        private DnaTestURLRequest _request = new DnaTestURLRequest("actionnetwork");
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01ViewArticleWithPageAuthorPageTest()
        {
            Console.WriteLine("Test01ViewArticleWithPageAuthorPageTest");
            _request.RequestPage("U6?skin=purexml");
            Console.WriteLine("After Test01ViewArticleWithPageAuthorPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/SCORE") != null, "The page author zeitgeist score has not been generated!!!");
        }
    }
}
