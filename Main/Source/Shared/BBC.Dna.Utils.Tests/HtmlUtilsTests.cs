using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;


namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test suite for HtmlUtils
    /// </summary>
    [TestClass]
    public class HtmlUtilsTests
    {
        /// <summary>
        /// Check for amps at the front of text
        /// </summary>
        [TestMethod]
        public void AtTheFront()
        {
            string testText = "& this is at the front";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp; this is at the front", fixedText);
        }

        /// <summary>
        /// Check for amps athe end of text
        /// </summary>
        [TestMethod]
        public void AtTheEnd()
        {
            string testText = "this is at the end &";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("this is at the end &amp;", fixedText);
        }

        /// <summary>
        /// Check for amps in the middle of text
        /// </summary>
        [TestMethod]
        public void InTheMiddle()
        {
            string testText = "this is in &the middle";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("this is in &amp;the middle", fixedText);
        }

        /// <summary>
        /// Check for amps at both ends
        /// </summary>
        [TestMethod]
        public void AtBothEnds()
        {
            string testText = "&At both ends &";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;At both ends &amp;", fixedText);
        }

        /// <summary>
        /// Check for mixed escaped and non escaped
        /// </summary>
        [TestMethod]
        public void MixedEscapedAndNon1()
        {
            string testText = "&amp;Now with &mixed versions&";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for mixed escaped and non escaped
        /// </summary>
        [TestMethod]
        public void MixedEscapedAndNon2()
        {
            string testText = "&Now with &amp;mixed versions&";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for mixed escaped and non escaped
        /// </summary>
        [TestMethod]
        public void MixedEscapedAndNon3()
        {
            string testText = "&Now with &mixed versions&amp;";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for all escaped amps
        /// </summary>
        [TestMethod]
        public void AllEscaped()
        {
            string testText = "&amp;Now with &amp;mixed versions&amp;";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp
        /// </summary>
        [TestMethod]
        public void TwoOfThreeEscaped1()
        {
            string testText = "&amp;Now with &amp;mixed versions&";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp
        /// </summary>
        [TestMethod]
        public void TwoOfThreeEscaped2()
        {
            string testText = "&Now with &amp;mixed versions&amp;";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp
        /// </summary>
        [TestMethod]
        public void TwoOfThreeEscaped3()
        {
            string testText = "&amp;Now with &mixed versions&amp;";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("&amp;Now with &amp;mixed versions&amp;", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp in mixed postitions
        /// </summary>
        [TestMethod]
        public void MixedPositionsAndTypes1()
        {
            string testText = "Now &amp; with &mixed versions&amp; to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; with &amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp in mixed postitions
        /// </summary>
        [TestMethod]
        public void MixedPositionsAndTypes2()
        {
            string testText = "Now & with &amp;mixed versions&amp; to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; with &amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for all but one escaped amp in mixed positions
        /// </summary>
        [TestMethod]
        public void MixedPositionsAndTypes3()
        {
            string testText = "Now &amp; with &amp;mixed versions& to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; with &amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for amps and semi colons in mixed positions
        /// </summary>
        [TestMethod]
        public void MixedSemicolons1()
        {
            string testText = "Now & with ;&amp;mixed versions& to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; with ;&amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for amps and semi colons in mixed positions
        /// </summary>
        [TestMethod]
        public void MixedSemicolons2()
        {
            string testText = "Now &amp; with ;&mixed versions& to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; with ;&amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for amps that look escaped, but are not
        /// </summary>
        [TestMethod]
        public void LooksEscapedButIsNot()
        {
            string testText = "Now & this; with ;&mixed versions& to boot";
            string fixedText = HtmlUtils.EscapeNonEscapedAmpersands(testText);
            Assert.AreEqual("Now &amp; this; with ;&amp;mixed versions&amp; to boot", fixedText);
        }

        /// <summary>
        /// Check for valid xml
        /// </summary>
        [TestMethod]
        public void ValidGuideML()
        {
            string errorMessage = "";
            string testText = "<b>Now & this; with ;&mixed versions& to boot</b>";
            bool validML = HtmlUtils.ParseToValidGuideML(testText, ref errorMessage);
            Assert.IsTrue(validML, "This is valid ML but returned false!!!");
            Assert.AreEqual("", errorMessage, "The XML is valid, so no error message should be given");
        }

        /// <summary>
        /// Check for correct error is returned for invalid xml.
        /// </summary>
        [TestMethod]
        public void NonValidGuideMLDueToBadAngleBracketInTagName()
        {
            string errorMessage = "";
            string testText = "<<Now> & this; with ;&mixed versions& to boot";
            bool validML = HtmlUtils.ParseToValidGuideML(testText, ref errorMessage);
            Assert.IsFalse(validML, "This is invalid ML but returned true!!!");
            Assert.AreEqual("Name cannot begin with the '<' character on line 1", errorMessage);
        }

        /// <summary>
        /// Check for correct error is returned for invalid xml.
        /// </summary>
        [TestMethod]
        public void NonValidGuideMLDueToSemiolonInsideTags()
        {
            string errorMessage = "";
            string testText = "<b> & <this; </b>with ;&mixed versions& to boot";
            bool validML = HtmlUtils.ParseToValidGuideML(testText, ref errorMessage);
            Assert.IsFalse(validML, "This is invalid ML but returned true!!!");
            Assert.AreEqual("The ';' character, cannot be included in a name on line 1", errorMessage);
        }

        /// <summary>
        /// Check for correct error is returned for invalid xml.
        /// </summary>
        [TestMethod]
        public void NonValidGuideMLDueToSingleQuoteInAttributeTag()
        {
            string errorMessage = "";
            string testText = "<b> <a href='this isn't correct'> this is a link </a> </b>";
            bool validML = HtmlUtils.ParseToValidGuideML(testText, ref errorMessage);
            Assert.IsFalse(validML, "This is invalid ML but returned true!!!");
            Assert.AreEqual("'t' is an unexpected token on line 1", errorMessage);
        }

        /// <summary>
        /// Tests the removal of bad tags and allowance of good tags
        /// </summary>
        [TestMethod]
        public void RemoveBadHtmlTags_WithScriptTag()
        {
            string[] badTags = {
                "applet",
                "body", 
                "embed", 
                "frame", 
                "script", 
                "frameset", 
                "html", 
                "iframe", 
                "img", 
                "style", 
                "layer", 
                "ilayer", 
                "meta", 
                "object", 
                "style"
            };
            foreach (string tag in badTags)
            {
                string test = String.Format("this is a <{0}>test</{0}> for bad html tags.", tag);
                string result = HtmlUtils.RemoveBadHtmlTags(test);
                Assert.IsTrue(result.IndexOf(String.Format("<{0}>", tag)) < 0);//removed
                Assert.IsTrue(result.IndexOf(String.Format("</{0}>", tag)) < 0);//removed
            }

            string[] goodTags = { "a", "blockquote", "br", "em", "li", "link", "p", "pre", "q", "strong", "ul" };
            foreach (string tag in goodTags)
            {
                string test = String.Format("this is a <{0}>test</{0}> for good html tags.", tag);
                string result = HtmlUtils.RemoveBadHtmlTags(test);
                Assert.IsTrue(result.IndexOf(String.Format("<{0}>", tag)) >= 0);
                Assert.IsTrue(result.IndexOf(String.Format("</{0}>", tag)) >= 0);
            }
        }

    }
}
