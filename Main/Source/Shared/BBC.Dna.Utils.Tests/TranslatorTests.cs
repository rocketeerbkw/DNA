using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;
using Rhino.Mocks;
using Tests;




namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Tests for the translator objects
    /// </summary>
    [TestClass()]
    public class TranslatorTests
    {
        private string sample1 = "&lt;quote&gt;this is quoted text.&lt;/quote&gt;";
        private string sample1expected = "<QUOTE>this is quoted text.</QUOTE>";

        private string sample2 = @"&lt;quote&gt;this is quoted text
over two lines.&lt;/quote&gt;";
        private string sample2expected = @"<QUOTE>this is quoted text
over two lines.</QUOTE>";

        private string sample3 = "&lt;QUOTE&gt;this is upper cased quoted text.&lt;/QUOTE&gt;";
        private string sample3expected = "<QUOTE>this is upper cased quoted text.</QUOTE>";

        private string sample4 = @"&lt;QUOTE&gt;this is upper cased quoted text
over two lines.&lt;/QUOTE&gt;";
        private string sample4expected = @"<QUOTE>this is upper cased quoted text
over two lines.</QUOTE>";

        private string sample5 = "&lt;quote&gt;This is not a fully quoted text.";
        private string sample5expected = "&lt;quote&gt;This is not a fully quoted text.";

        private string sample6 = "This is not a fully quoted text.&lt;/quote&gt;";
        private string sample6expected = "This is not a fully quoted text.&lt;/quote&gt;";

        private string sample7 = "This is &lt;quote&gt; a double &lt;quote&gt; quoted &lt;/quote&gt; text &lt;/quote&gt; test.";
        private string sample7expected = "This is <QUOTE> a double <QUOTE> quoted </QUOTE> text </QUOTE> test.";

        private string sample8 = "This is &lt;quote user='testuser' userid='12345'&gt; a quoted text with username and id &lt;/quote&gt; test.";
        private string sample8expected = "This is <QUOTE USER='testuser' USERID='12345'> a quoted text with username and id </QUOTE> test.";

        private string sample9 = "This is &lt;quote userid='12345' user='testuser'&gt; a quoted text with username and id &lt;/quote&gt; test.";
        private string sample9expected = "This is <QUOTE USERID='12345' USER='testuser'> a quoted text with username and id </QUOTE> test.";

        private string sample9a = "This is &lt;quote userid='12345' user='test&gt;user'&gt; a quoted text with username and id &lt;/quote&gt; test.";
        private string sample9aexpected = "This is <QUOTE USERID='12345' USER='test&gt;user'> a quoted text with username and id </QUOTE> test.";

        private string sample10 = "This is &lt;quote userid='12345' user='testuser' a quoted text with username and id &lt;/quote&gt; test.";
        private string sample10expected = "This is &lt;quote userid='12345' user='testuser' a quoted text with username and id &lt;/quote&gt; test.";

        private string sample11 = @"To be, or not to be: that is the question:
&lt;quote&gt;Whether it is nobler in the mind to suffer
The slings and arrows of outrageous fortune,
Or to take arms against a sea of troubles,
And by opposing[,] end them? &lt;/quote&gt; To die: to sleep; [Unsuitable/Broken URL removed by Moderator]
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to, 'tis a consummation
Devoutly to be wish'd. To die, to sleep;
To sleep: perchance to dream: ay, there's the rub;
For in that sleep of death what dreams may come
&lt;QUOTE&gt;When we have shuffled off this mortal coil,&lt;/QUOTE&gt;
Must give us pause: there's the respect
That makes calamity of so long life;
For who would bear the whips and scorns of time,
The oppressor's wrong, the proud man's contumely,
&lt;quote user='munter' userid='1090494625'&gt;The pangs of despised love, the law's delay,&lt;/quote&gt;&lt;biggrin&gt;
The insolence of office and the spurns
That patient merit of the unworthy takes,
When he himself might his quietus make
&lt;quote user='munter'&gt;With a bare bodkin? who would fardels bear,&lt;/quote&gt;
To grunt and sweat under a weary life,
&lt;quote userid='1090494625'&gt;But that the dread of something after death, &lt;/quote&gt;
The undiscover'd country from whose bourn
No traveller returns, puzzles the will
And makes us rather bear those ills we have
Than fly to others that we know not of?
Thus conscience does make cowards of us all;
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pith and moment
With this regard their currents turn awry,
And lose the name of action. ";

        private string sample11expected = @"To be, or not to be: that is the question:
<QUOTE>Whether it is nobler in the mind to suffer
The slings and arrows of outrageous fortune,
Or to take arms against a sea of troubles,
And by opposing[,] end them? </QUOTE> To die: to sleep; [Unsuitable/Broken URL removed by Moderator]
No more; and by a sleep to say we end
The heart-ache and the thousand natural shocks
That flesh is heir to, 'tis a consummation
Devoutly to be wish'd. To die, to sleep;
To sleep: perchance to dream: ay, there's the rub;
For in that sleep of death what dreams may come
<QUOTE>When we have shuffled off this mortal coil,</QUOTE>
Must give us pause: there's the respect
That makes calamity of so long life;
For who would bear the whips and scorns of time,
The oppressor's wrong, the proud man's contumely,
<QUOTE USER='munter' USERID='1090494625'>The pangs of despised love, the law's delay,</QUOTE>&lt;biggrin&gt;
The insolence of office and the spurns
That patient merit of the unworthy takes,
When he himself might his quietus make
<QUOTE USER='munter'>With a bare bodkin? who would fardels bear,</QUOTE>
To grunt and sweat under a weary life,
<QUOTE USERID='1090494625'>But that the dread of something after death, </QUOTE>
The undiscover'd country from whose bourn
No traveller returns, puzzles the will
And makes us rather bear those ills we have
Than fly to others that we know not of?
Thus conscience does make cowards of us all;
And thus the native hue of resolution
Is sicklied o'er with the pale cast of thought,
And enterprises of great pith and moment
With this regard their currents turn awry,
And lose the name of action. ";



        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test01QuoteTranslator_SimpleLC()
        {
            string result = QuoteTranslator.TranslateText(sample1);
            Assert.AreEqual(sample1expected, result, "sample1");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test02QuoteTranslator_SimpleUC()
        {
            string result = QuoteTranslator.TranslateText(sample2);
            Assert.AreEqual(sample2expected, result, "sample2");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test03QuoteTranslator_SimpleAcrossLinesLC()
        {
            string result = QuoteTranslator.TranslateText(sample3);
            Assert.AreEqual(sample3expected, result, "sample3");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test04QuoteTranslator_SimpleAcrossLinesUC()
        {
            string result = QuoteTranslator.TranslateText(sample4);
            Assert.AreEqual(sample4expected, result, "sample4");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test05QuoteTranslator_OpenQuoteNoClosingLC()
        {
            string result = QuoteTranslator.TranslateText(sample5);
            Assert.AreEqual(sample5expected, result, "sample5");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test06QuoteTranslator_NoOpenQuoteWithClosingLC()
        {
            string result = QuoteTranslator.TranslateText(sample6);
            Assert.AreEqual(sample6expected, result, "sample6");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test07QuoteTranslator_QuotesWithInQuotes()
        {
            string result = QuoteTranslator.TranslateText(sample7);
            Assert.AreEqual(sample7expected, result, "sample7");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test08QuoteTranslator_ComplexQuoteUserThenUserIDWithGraterThanInName()
        {
            string result = QuoteTranslator.TranslateText(sample8);
            Assert.AreEqual(sample8expected, result, "sample8");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test09QuoteTranslator_ComplexQuoteUserIDThenUserWithGraterThanInName()
        {
            string result = QuoteTranslator.TranslateText(sample9);
            Assert.AreEqual(sample9expected, result, "sample9");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        /// <remarks>This test is being ignored as we don't cope with > in user names. When we do, put this back ;)
        /// TFS bug 1520
        /// </remarks>
        [Ignore]
        public void Test09aQuoteTranslator_ComplexQuoteUserIDThenUserWithGraterThanInName()
        {
            string result = QuoteTranslator.TranslateText(sample9a);
            Assert.AreEqual(sample9aexpected, result, "sample9a");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test10QuoteTranslator_ComplexBrokenQuoteUserIDThenUserWithGraterThanInName()
        {
            string result = QuoteTranslator.TranslateText(sample10);
            Assert.AreEqual(sample10expected, result, "sample10");
        }

        /// <summary>
        /// Check to make sure the quote translator translates as expected
        /// </summary>
        [TestMethod()]
        public void Test11QuoteTranslator_ComplexBrokenQuotes()
        {
            string result = QuoteTranslator.TranslateText(sample11);
            Assert.AreEqual(sample11expected, result, "sample11");
        }
    }
}
