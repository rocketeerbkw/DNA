using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace RipleyTests
{
    /// <summary>
    /// Tests for ThreadSearch Phrase XML.
    /// </summary>
    [TestClass]
    public class ThreadSearchPhraseTests
    {
        private DnaTestURLRequest _request = new DnaTestURLRequest("england");

        /// <summary>
        /// Do a Thread Key Phrase search . No phrase specified.
        /// </summary>
        [TestMethod]
        public void TestThreadSearchPhraseNoPhrase()
        {
            Console.WriteLine("ThreadSearchPhraseTest");
            _request.RequestPage("tsp?skin=purexml&clear_templates=1");
            Console.WriteLine("ThreadSearchPhraseTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode(@"H2G2/THREADSEARCHPHRASE/PHRASES[@COUNT=0]") != null, "Incorrect Phrase count. Expecting 0");

            DnaXmlValidator validator = new DnaXmlValidator(xml.SelectSingleNode("H2G2/THREADSEARCHPHRASE").OuterXml, "threadsearchphrase.xsd");
            validator.Validate();
        }

        /// <summary>
        /// Do a Thread Key Phrase Search - Single Phrase Specified.
        /// </summary>
        [TestMethod]
        public void TestThreadSearchPhraseSinglePhrase()
        {
            Console.WriteLine("ThreadSearchPhraseTest");
            _request.RequestPage("tsp?skin=purexml&phrase=test");
            Console.WriteLine("ThreadSearchPhraseTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/THREADSEARCHPHRASE/PHRASES[@COUNT=1]") != null, "Incorrect Phrase count. Expecting 1.");
            Assert.AreEqual(xml.SelectSingleNode("H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME").InnerText, "test");

            DnaXmlValidator validator = new DnaXmlValidator(xml.SelectSingleNode("H2G2/THREADSEARCHPHRASE").OuterXml, "threadsearchphrase.xsd");
            validator.Validate();
        }
    }
}
