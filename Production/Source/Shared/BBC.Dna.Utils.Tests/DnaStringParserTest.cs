using System;
using System.Collections;
using System.Collections.Generic;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test utility class DnaStringParser.cs
    /// </summary>
    [TestClass]
    public class DnaStringParserTest
    {
        char[] delimiter;

        /// <summary>
        /// Constructor
        /// </summary>
        public DnaStringParserTest()
        {
            delimiter = new char[] { ',' };
        }

        /// <summary>
        /// Test basic list is parsed properly. 
        /// </summary>
        [TestMethod]
        public void BasicListTest()
        {
            Console.WriteLine("String Parser - BasicListTest");
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3", delimiter,true,true,true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings."); 
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test list with blank elements. 
        /// </summary>
        [TestMethod]
        public void BlankElementTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3, , , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test list with single occurance of double delimiter. 
        /// </summary>
        [TestMethod]
        public void DoubleDelimiterTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1,, blah2, blah3, , , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test list with multiple occurances of double delimiter. 
        /// </summary>
        [TestMethod]
        public void MultipleDoubleDelimiterTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1,, blah2,, blah3, ,, , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test list with single occurance of triple delimiter. 
        /// </summary>
        [TestMethod]
        public void TripleDelimiterTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1,,, blah2, blah3, , , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test another list with single occurance of triple delimiter. 
        /// </summary>
        [TestMethod]
        public void TripleDelimiterTest2()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3, ,,, , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test list with multiple occurances of triple delimiter. 
        /// </summary>
        [TestMethod]
        public void MultipleTripleDelimiterTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2,,, blah3,,,, ,,, , ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test a range of delimiter cominations. 
        /// </summary>
        [TestMethod]
        public void MixedMultiplicityDelimiterTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2,,, blah3,,,, blah4, blah5,,,, blah6, , blah7, ", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 7, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
            Assert.AreEqual("blah4", substrings[3]);
            Assert.AreEqual("blah5", substrings[4]);
            Assert.AreEqual("blah6", substrings[5]);
            Assert.AreEqual("blah7", substrings[6]);
        }

        /// <summary>
        /// Test elimination of duplicated elements. 
        /// </summary>
        [TestMethod]
        public void DuplicateElementTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3, blah3", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
        }

        /// <summary>
        /// Test elimination of duplicated elements. 
        /// </summary>
        [TestMethod]
        public void DuplicateElementCaseTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3, blah3, BLAH3, bLah2", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 5, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
            Assert.AreEqual("BLAH3", substrings[3]);
            Assert.AreEqual("bLah2", substrings[4]);
        }

        /// <summary>
        /// Test elimination of duplicated elements with double delimiters. 
        /// </summary>
        [TestMethod]
        public void DuplicateElementCaseWithDoubleDelimitersTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2,, blah3, blah3, , , , ,, BLAH3,, bLah2", delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 5, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
            Assert.AreEqual("BLAH3", substrings[3]);
            Assert.AreEqual("bLah2", substrings[4]);
        }

        /// <summary>
        /// Test quoted elements. 
        /// </summary>
        [TestMethod]
        public void QuotedElementsTest()
        {
            string param = @"blah1, ""blah2""";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 2, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
        }

        /// <summary>
        /// Multiple quoted elements. 
        /// </summary>
        [TestMethod]
        public void MultipleQuotedElementsTest()
        {
            string param = @"""blah1"", ""blah2""";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 2, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
        }

        /// <summary>
        /// Multiple quoted and non-quoted elements. 
        /// </summary>
        [TestMethod]
        public void QuotedNonQuotedElementMixTest()
        {
            string param = @"""blah1"", blah2, blah3, ""blah4""";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 4, "Unexpected number of substrings.");
            Assert.AreEqual("blah1", substrings[0]);
            Assert.AreEqual("blah2", substrings[1]);
            Assert.AreEqual("blah3", substrings[2]);
            Assert.AreEqual("blah4", substrings[3]);
        }

        /// <summary>
        /// Test quoted elements with spaces.
        /// </summary>
        [TestMethod]
        public void QuotedElementWithSpacesTest()
        {
            string param = @"""blah1 blah2 blah3 blah4"", blah5, blah6,";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1 blah2 blah3 blah4", substrings[0]);
            Assert.AreEqual("blah5", substrings[1]);
            Assert.AreEqual("blah6", substrings[2]);
        }

        /// <summary>
        /// Test multiple quoted elements with spaces.
        /// </summary>
        [TestMethod]
        public void MultipleQuotedElementsWithSpacesTest()
        {
            string param = @"""blah1 blah2 blah3 blah4"", blah5, blah6, ""blah7 blah8""";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 4, "Unexpected number of substrings.");
            Assert.AreEqual("blah1 blah2 blah3 blah4", substrings[0]);
            Assert.AreEqual("blah5", substrings[1]);
            Assert.AreEqual("blah6", substrings[2]);
            Assert.AreEqual("blah7 blah8", substrings[3]);
        }

        /// <summary>
        /// Test quoted elements with spaces and commas.
        /// </summary>
        [TestMethod]
        public void QuotedElementWithSpacesAndCommasTest()
        {
            string param = @"""blah1 blah2, blah3 blah4"", blah5, blah6,";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1 blah2 blah3 blah4", substrings[0]);
            Assert.AreEqual("blah5", substrings[1]);
            Assert.AreEqual("blah6", substrings[2]);
        }

        /// <summary>
        /// Test quoted elements with problem characters.
        /// </summary>
        [TestMethod]
        public void QuotedElementWithProblemCharactersTest()
        {
            string param = @"""blah1 &^%£$"", blah5, blah6,";
            DnaStringParser parser = new DnaStringParser(param, delimiter, true, true, true);
            string[] substrings = parser.Parse();
            Assert.AreEqual(substrings.Length, 3, "Unexpected number of substrings.");
            Assert.AreEqual("blah1 &^%£$", substrings[0]);
            Assert.AreEqual("blah5", substrings[1]);
            Assert.AreEqual("blah6", substrings[2]);
        }

        /// <summary>
        /// Basic comma separated string test. 
        /// </summary>
        [TestMethod]
        public void BasicGetParsedStringTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1, blah2, blah3", delimiter, true, true, true);
            string commaSeparatedString = parser.GetParsedString(',');
            Assert.AreEqual("blah1,blah2,blah3,", commaSeparatedString); 
        }

        /// <summary>
        /// Get comma separated string with double delimiters. 
        /// </summary>
        [TestMethod]
        public void GetParsedStringWithDoubleDelimitersTest()
        {
            DnaStringParser parser = new DnaStringParser("blah1,, blah2, blah3,,,", delimiter, true, true, true);
            string commaSeparatedString = parser.GetParsedString(',');
            Assert.AreEqual("blah1,blah2,blah3,", commaSeparatedString);
        }

        /// <summary>
        /// Get comma separated string with double delimiters and quotes. 
        /// </summary>
        [TestMethod]
        public void GetParsedStringWithDoubleDelimitersAndQuotesTest()
        {
            DnaStringParser parser = new DnaStringParser("\"blah1 blah2, blah3\",, blah4, blah5,,,", delimiter, true, true, true);
            string commaSeparatedString = parser.GetParsedString(',');
            Assert.AreEqual("blah1 blah2 blah3,blah4,blah5,", commaSeparatedString);
        }

        /// <summary>
        /// Get | separated string with spaces and quotes. 
        /// </summary>
        [TestMethod]
        public void GetParsedStringUsingPipesAsDelimitersWithSpacesAndQuotesTest()
        {
            char[] pipe = new char[] { '|' };
            DnaStringParser parser = new DnaStringParser("\"blah1 blah2, blah3\"| blah4| blah5|||", pipe, true, true, true);
            string commaSeparatedString = parser.GetParsedString('|');
            Assert.AreEqual("blah1 blah2, blah3|blah4|blah5|", commaSeparatedString);
        }

        /// <summary>
        /// Check to make sure that parsing to an array does not remove duplicates when specified
        /// </summary>
        [TestMethod]
        public void CheckThatParseToArrayDoesNotRemoveDuplicatesWhenSpecified()
        {
            DnaStringParser parser = new DnaStringParser("blah5 \"blah1 blah2, blah3\"  blah5", new char[] { ' ' }, false, false, false);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 3, "parsing the string with spaces should of only brought back 3 items!");
            Assert.AreEqual("blah5", strings[0], "The first string does not match expected value!");
            Assert.AreEqual("\"blah1 blah2, blah3\"", strings[1], "The second string does not match expected value!");
            Assert.AreEqual("blah5", strings[2], "The third string does not match expected value!");
        }

        /// <summary>
        /// Check to make sure that we parse correctly when asked to remove duplicates only.
        /// </summary>
        [TestMethod]
        public void TestParseToArrayRemovesDuplicatesButNotQuotesAndDelimiters()
        {
            DnaStringParser parser = new DnaStringParser("blah1, \"blah,blah\", blah1", new char[] { ',' }, false, false, true);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 2, "There should be two strings parsed!");
            Assert.AreEqual("blah1", strings[0]);
            Assert.AreEqual("\"blah,blah\"", strings[1]);
        }

        /// <summary>
        /// Check to make sure that we parse correctly when asked to remove duplicates and quotes.
        /// </summary>
        [TestMethod]
        public void TestParseToArrayRemovesDuplicatesAndQuotesButNotDelimiters()
        {
            DnaStringParser parser = new DnaStringParser("blah1, \"blah,blah\", blah1", new char[] { ',' }, false, true, true);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 2, "There should be two strings parsed!");
            Assert.AreEqual("blah1", strings[0]);
            Assert.AreEqual("blah,blah", strings[1]);
        }

        /// <summary>
        /// Check to make sure that we parse correctly when asked to remove duplicates and delimiters.
        /// </summary>
        [TestMethod]
        public void TestParseToArrayRemovesDuplicatesAndDelimitersButNotQuotes()
        {
            DnaStringParser parser = new DnaStringParser("blah1, \"blah,blah\", blah1", new char[] { ',' }, true, false, true);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 2, "There should be two strings parsed!");
            Assert.AreEqual("blah1", strings[0]);
            Assert.AreEqual("\"blahblah\"", strings[1]);
        }

        /// <summary>
        /// Check to make sure that we parse correctly when asked to remove quotes and delimiters.
        /// </summary>
        [TestMethod]
        public void TestParseToArrayRemovesQuotesAndDelimitersButNotDuplicates()
        {
            DnaStringParser parser = new DnaStringParser("blah1, \"blah,blah\", blah1", new char[] { ',' }, true, true, false);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 3, "There should be two strings parsed!");
            Assert.AreEqual("blah1", strings[0]);
            Assert.AreEqual("blahblah", strings[1]);
            Assert.AreEqual("blah1", strings[2]);
        }

        /// <summary>
        /// Check to make sure that we parse correctly when asked to remove quotes and delimiters.
        /// </summary>
        [TestMethod]
        public void TestParseToArrayWithSpaceDelimitedStringPreservingQuotesAndDelimetersAndDuplicates()
        {
            DnaStringParser parser = new DnaStringParser("search for \"phrase in quotes\" another other terms", new char[] { ' ' }, false, false, false);
            ArrayList strings = parser.ParseToArrayList();
            Assert.IsTrue(strings.Count == 6, "There should be five strings parsed!");
            Assert.AreEqual("search", strings[0]);
            Assert.AreEqual("for", strings[1]);
            Assert.AreEqual("\"phrase in quotes\"", strings[2]);
            Assert.AreEqual("another", strings[3]);
            Assert.AreEqual("other", strings[4]);
            Assert.AreEqual("terms", strings[5]);
        }
    }
}