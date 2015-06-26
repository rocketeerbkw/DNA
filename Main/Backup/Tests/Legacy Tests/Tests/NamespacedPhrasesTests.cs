using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for the namespace phrases class
    /// </summary>
    [TestClass]
    public class NamespacedPhrasesTests
    {
        /// <summary>
        /// Check to make sure non quoted tokenized phrases get parsed correctly
        /// </summary>
        [TestMethod]
        public void NonQuotedTokenizedPhrasesSplitCorrectly()
        {
            // Mock the context for the object
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            Stub.On(context).Method("GetSiteOptionValueString").With("KeyPhrases", "DelimiterToken").Will(Return.Value(","));

            // Create an instance of the class to test
            NamespacePhrases nsp = new NamespacePhrases(context);

            // Set up the phrases and namespace to test against
            string phrases = "one,two,three,four and a bit";
            string namespaces = "test";

            // Create a list of tokenized namespaced phrases to test
            List<TokenizedNamespacedPhrases> phrasesToTest = new List<TokenizedNamespacedPhrases>();
            phrasesToTest.Add(new TokenizedNamespacedPhrases(namespaces, phrases));

            // Now try to parse the list
            List<Phrase> parsedPrases = nsp.ParseTokenizedPhrases(phrasesToTest);

            Assert.AreEqual(4, parsedPrases.Count);
            Assert.AreEqual("one", parsedPrases[0].PhraseName);
            Assert.AreEqual("two", parsedPrases[1].PhraseName);
            Assert.AreEqual("three", parsedPrases[2].PhraseName);
            Assert.AreEqual("four and a bit", parsedPrases[3].PhraseName);

            Assert.AreEqual("test", parsedPrases[0].NameSpace);
            Assert.AreEqual("test", parsedPrases[1].NameSpace);
            Assert.AreEqual("test", parsedPrases[2].NameSpace);
            Assert.AreEqual("test", parsedPrases[3].NameSpace);
        }

        /// <summary>
        /// Check to make sure quoted tokenized phrases get parsed correctly
        /// </summary>
        [TestMethod]
        public void QuotedTokenizedPhrasesSplitCorrectly()
        {
            // Mock the context for the object
            IInputContext context = DnaMockery.CurrentMockery.NewMock<IInputContext>();
            Stub.On(context).Method("GetSiteOptionValueString").With("KeyPhrases", "DelimiterToken").Will(Return.Value(","));

            // Create an instance of the class to test
            NamespacePhrases nsp = new NamespacePhrases(context);

            // Set up the phrases and namespace to test against
            string phrases1 = "one,\"two,three\",four and a bit";
            string namespaces1 = "test";
            string phrases2 = "\"two,three\",four and a bit,last";
            string namespaces2 = "";
            string phrases3 = "\"two,three\",four and a bit,\"last, but not least\"";
            string namespaces3 = "lots of name space";

            // Create a list of tokenized namespaced phrases to test
            List<TokenizedNamespacedPhrases> phrasesToTest = new List<TokenizedNamespacedPhrases>();
            phrasesToTest.Add(new TokenizedNamespacedPhrases(namespaces1, phrases1));
            phrasesToTest.Add(new TokenizedNamespacedPhrases(namespaces2, phrases2));
            phrasesToTest.Add(new TokenizedNamespacedPhrases(namespaces3, phrases3));

            // Now try to parse the list
            List<Phrase> parsedPrases = nsp.ParseTokenizedPhrases(phrasesToTest);

            Assert.AreEqual(9, parsedPrases.Count);
            Assert.AreEqual("one", parsedPrases[0].PhraseName);
            Assert.AreEqual("two,three", parsedPrases[1].PhraseName);
            Assert.AreEqual("four and a bit", parsedPrases[2].PhraseName);

            Assert.AreEqual("test", parsedPrases[0].NameSpace);
            Assert.AreEqual("test", parsedPrases[1].NameSpace);
            Assert.AreEqual("test", parsedPrases[2].NameSpace);

            Assert.AreEqual("two,three", parsedPrases[3].PhraseName);
            Assert.AreEqual("four and a bit", parsedPrases[4].PhraseName);
            Assert.AreEqual("last", parsedPrases[5].PhraseName);

            Assert.AreEqual("", parsedPrases[3].NameSpace);
            Assert.AreEqual("", parsedPrases[4].NameSpace);
            Assert.AreEqual("", parsedPrases[5].NameSpace);

            Assert.AreEqual("two,three", parsedPrases[6].PhraseName);
            Assert.AreEqual("four and a bit", parsedPrases[7].PhraseName);
            Assert.AreEqual("last, but not least", parsedPrases[8].PhraseName);

            Assert.AreEqual("lots of name space", parsedPrases[6].NameSpace);
            Assert.AreEqual("lots of name space", parsedPrases[7].NameSpace);
            Assert.AreEqual("lots of name space", parsedPrases[8].NameSpace);
        }
    }
}
