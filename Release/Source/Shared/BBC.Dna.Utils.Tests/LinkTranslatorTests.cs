using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Summary description for LinkTranslatorTests
    /// </summary>
    [TestClass]
    public class LinkTranslatorTests
    {

        [TestMethod]
        public void TestExternalLink_PassValidLink_ReturnsCorrectValue()
        {
            string[] input = {"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)", 
                "this is a test with a . at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song).",
                "this is a test with a ? at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song)?",
                "this is a test with in brackets (at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song))",
                "this is a test with a anchor tag at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>",
                "<a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>this is a test with a anchor tag at the end",
                "<a href=\"http://www.bbc.co.uk/\">tests</a> this is a test with a slash at the end",
                "this is a test http://en.wikipedia.org/wiki/Sink_or_Swim_(song) in the middle",
                "link with category in it http://picasaweb.google.com/lh/photo/nJvUd_wNF75UjzHZWKxZTwC9?feat=directlink"
                             };
            string[] expected = {"<LINK HREF=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</LINK>",
                                    "this is a test with a . at the end <LINK HREF=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</LINK>.",
                                    "this is a test with a ? at the end <LINK HREF=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</LINK>?",
                                    "this is a test with in brackets (at the end <LINK HREF=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song))\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song))</LINK>", // this is not entirely correct but unable to work out if last ) is matched
                                    "this is a test with a anchor tag at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>",
                                    "<a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>this is a test with a anchor tag at the end",
                                    "<a href=\"http://www.bbc.co.uk/\">tests</a> this is a test with a slash at the end",
                                    "this is a test <LINK HREF=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</LINK> in the middle",
                                    "link with category in it <LINK HREF=\"http://picasaweb.google.com/lh/photo/nJvUd_wNF75UjzHZWKxZTwC9?feat=directlink\">http://picasaweb.google.com/lh/photo/nJvUd_wNF75UjzHZWKxZTwC9?feat=directlink</LINK>",
                                };

            for (int i = 0; i < input.Length; i++)
            {
                Assert.AreEqual(expected[i], LinkTranslator.TranslateText(input[i]));
            }   
        }

        [TestMethod]
        public void TestCategoryPage_ValidCategory_ReturnsCorrectValue()
        {
            string[] input = {"C1", " C1", " C1 ", "C1 ", "<C1>"};
            string[] expected = { "<LINK DNAID=\"C1\">C1</LINK>", 
                                    " <LINK DNAID=\"C1\">C1</LINK>", 
                                    " <LINK DNAID=\"C1\">C1</LINK> ",
                                    "<LINK DNAID=\"C1\">C1</LINK> ",
                                    "<C1>"};

            for(int i=0; i < input.Length; i++)
            {
                Assert.AreEqual(expected[i], LinkTranslator.TranslateText(input[i]));    
            }   
            
        }

        [TestMethod]
        public void TestUser_ValidUser_ReturnsCorrectValue()
        {
            var input = @" U123434 ";
            var expected = " <LINK BIO=\"U123434\">U123434</LINK> ";

            var actual = LinkTranslator.TranslateText(input);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void TestUser_ReservedUser_ReturnsCorrectValue()
        {
            var input = @"U2";
            var expected = "U2";

            var actual = LinkTranslator.TranslateText(input);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void TestUser_ForumLink_ReturnsCorrectValue()
        {
            var input = @"F150";
            var expected = "<LINK DNAID=\"F150\">F150</LINK>";

            Assert.AreEqual(expected, LinkTranslator.TranslateText(input));
        }


        [TestMethod]
        public void TestUser_ArticleLink_ReturnsCorrectValue()
        {
            var input = @"A150";
            var expected = "<LINK DNAID=\"A150\">A150</LINK>";

            Assert.AreEqual(expected, LinkTranslator.TranslateText(input));
        }

        [TestMethod]
        public void TranslateExLinksToHtml_PassValidLink_ReturnsCorrectValue()
        {
            string[] input = {"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)", 
                "this is a test with a . at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song).",
                "this is a test with a ? at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song)?",
                "this is a test with in brackets (at the end http://en.wikipedia.org/wiki/Sink_or_Swim_(song))",
                "this is a test with a anchor tag at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>",
                "this is a test with a tag directly after link http://en.wikipedia.org/wiki/<br/>",
                             };
            string[] expected = {"<a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</a>",
                                    "this is a test with a . at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</a>.",
                                    "this is a test with a ? at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song)</a>?",
                                    "this is a test with in brackets (at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song))\">http://en.wikipedia.org/wiki/Sink_or_Swim_(song))</a>", // this is not entirely correct but unable to work out if last ) is matched
                                    "this is a test with a anchor tag at the end <a href=\"http://en.wikipedia.org/wiki/Sink_or_Swim_(song)\">tests</a>",
                                    "this is a test with a tag directly after link <a href=\"http://en.wikipedia.org/wiki/\">http://en.wikipedia.org/wiki/</a><br/>",
                                };

            for (int i = 0; i < input.Length; i++)
            {
                Assert.AreEqual(expected[i], LinkTranslator.TranslateExLinksToHtml(input[i]));
            }
        }


    }
}
