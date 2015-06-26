using System;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test utility class DnaStringParser.cs
    /// </summary>
    [TestClass]
    public class StringUtilsTest
    {
        // Schema to validate GuideML against.
        private const string _schemaUri = "GuideML.xsd";
        
        /// <summary>
        /// Test xml escaping of string without xml chars. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlWithNoXMLCharsTest()
        {
            Console.WriteLine("Before EscapeAllXmlWithNoXMLCharsTest");
            string escapedString = StringUtils.EscapeAllXml("blah blah blah!!£$(*");
            Assert.AreEqual("blah blah blah!!£$(*", escapedString); 
        }

        /// <summary>
        /// Test escaping of xml characters. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlWithXMLCharsTest()
        {
            Console.WriteLine("Before EscapeAllXmlWithXMLCharsTest");
            string escapedString = StringUtils.EscapeAllXml("<blah>Crime & Punishment</blah>");
            Assert.AreEqual("&lt;blah&gt;Crime &amp; Punishment&lt;/blah&gt;", escapedString);
        }

        /// <summary>
        /// Test xml escaping of empty string . 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlWithEmptyStringTest()
        {
            Console.WriteLine("Before EscapeAllXmlWithEmptyStringTest");
            string escapedString = StringUtils.EscapeAllXml("");
            Assert.AreEqual("", escapedString);
        }

        /// <summary>
        /// Test xml escaping null. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlNullTest()
        {
            Console.WriteLine("Before EscapeAllXmlNullTest");
            string s = null;
            string escapedString = StringUtils.EscapeAllXml(s);
            Assert.AreEqual(null, escapedString);
        }

        /// <summary>
        /// Test xml unescaping of string without xml chars.
        /// </summary>
        [TestMethod]
        public void UnescapeAllXmlWithNoXMLCharsTest()
        {
            Console.WriteLine("Before UnescapeAllXmlWithNoXMLCharsTest");
            string escapedString = StringUtils.UnescapeAllXml("blah blah blah!!£$(*");
            Assert.AreEqual("blah blah blah!!£$(*", escapedString); 
        }

        /// <summary>
        /// Test unescaping of xml characters. 
        /// </summary>
        [TestMethod]
        public void UnescapeAllXmlWithXMLCharsTest()
        {
            Console.WriteLine("Before UnescapeAllXmlWithXMLCharsTest");
            string escapedString = StringUtils.UnescapeAllXml("&lt;blah&gt;Crime &amp; Punishment&lt;/blah&gt;");
            Assert.AreEqual("<blah>Crime & Punishment</blah>", escapedString);
        }

        /// <summary>
        /// Test xml escaping of empty string . 
        /// </summary>
        [TestMethod]
        public void UnescapeAllXmlWithEmptyStringTest()
        {
            Console.WriteLine("Before UnescapeAllXmlWithEmptyStringTest");
            string escapedString = StringUtils.UnescapeAllXml("");
            Assert.AreEqual("", escapedString);
        }

        /// <summary>
        /// Test xml escaping null. 
        /// </summary>
        [TestMethod]
        public void UnescapeAllXmlNullTest()
        {
            Console.WriteLine("Before UnescapeAllXmlNullTest");
            string s = null;
            string escapedString = StringUtils.UnescapeAllXml(s);
            Assert.AreEqual(null, escapedString);
        }

        /// <summary>
        /// Test xml escaping of string without xml chars. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlForAttributeWithNoXMLCharsTest()
        {
            Console.WriteLine("Before EscapeAllXmlForAttributeWithNoXMLCharsTest");
            string escapedString = StringUtils.EscapeAllXmlForAttribute("blah blah blah!!£$(*");
            Assert.AreEqual("blah blah blah!!£$(*", escapedString); 
        }

        /// <summary>
        /// Test escaping of xml characters and attributes. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlForAttributelWithXMLCharsTest()
        {
            Console.WriteLine("Before EscapeAllXmlForAttributelWithXMLCharsTest");
            string escapedString = StringUtils.EscapeAllXmlForAttribute("<blah id='1'>'Crime & Punishment'</blah>");
            Assert.AreEqual("&lt;blah id=&apos;1&apos;&gt;&apos;Crime &amp; Punishment&apos;&lt;/blah&gt;", escapedString);
        }

        /// <summary>
        /// Test xml escaping of empty string. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlForAttributeWithEmptyStringTest()
        {
            Console.WriteLine("Before EscapeAllXmlForAttributeWithEmptyStringTest");
            string escapedString = StringUtils.EscapeAllXmlForAttribute("");
            Assert.AreEqual("", escapedString);
        }

        /// <summary>
        /// Test xml escaping null. 
        /// </summary>
        [TestMethod]
        public void EscapeAllXmlForAttributeNullTest()
        {
            Console.WriteLine("Before EscapeAllXmlForAttributeNullTest");
            string s = null;
            string escapedString = StringUtils.EscapeAllXmlForAttribute(s);
            Assert.AreEqual(null, escapedString);
        }

        /// <summary>
        /// Basic tests for plain text to GuideML conversion if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_Basic()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_Basic");
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("http://www.bbc.co.uk/");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</LINK></BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("Check out some nonsense here: http://www.bbc.co.uk/dna/mb606/A123");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Check out some nonsense here: <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK></BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK></BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456 http 3 = http://www.bbc.co.uk/dna/mb606/789 more text");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK> http 3 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/789\">http://www.bbc.co.uk/dna/mb606/789</LINK> more text</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http://www.bbc.co.uk/dna/mb606 is a good site.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK> is a good site.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("Some text?");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Some text?</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Basic tests for marking up plain text if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_Basic()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_Basic");
            string guideML;

            guideML = StringUtils.ConvertPlainText("http://www.bbc.co.uk/");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</LINK>", guideML);

            guideML = StringUtils.ConvertPlainText("Check out some nonsense here: http://www.bbc.co.uk/dna/mb606/A123");
            Assert.AreEqual("Check out some nonsense here: <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK>", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456 http 3 = http://www.bbc.co.uk/dna/mb606/789 more text");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK> http 3 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/789\">http://www.bbc.co.uk/dna/mb606/789</LINK> more text", guideML);

            guideML = StringUtils.ConvertPlainText("http://www.bbc.co.uk/dna/mb606 is a good site.");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK> is a good site.", guideML);

            guideML = StringUtils.ConvertPlainText("Some text?");
            Assert.AreEqual("Some text?", guideML);
        }

        /// <summary>
        /// Tests on tricky terminators for plain text to GuideML conversion if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_Terminators()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_Terminators");
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("http://www.bbc.co.uk/dna/mb606. Another sentance.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>. Another sentance.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("First sentance http://www.bbc.co.uk/dna/mb606? Second sentance.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>First sentance <LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>? Second sentance.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("The following link is in brackets (http://www.bbc.co.uk/dna/mb606).");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>The following link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>).</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("Another link is in brackets (http://www.bbc.co.uk/dna/mb606/).");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Another link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/\">http://www.bbc.co.uk/dna/mb606/</LINK>).</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123, something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>, something else</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123. Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>. Something else</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = @http://www.bbc.co.uk/dna/mb606/A123@ Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = @<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>@ Something else</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("http1 = \"http://www.bbc.co.uk/dna/mb606/A123\",|{^ Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = \"<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>\",|{^ Something else</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests on tricky terminators for plain text markup if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_Terminators()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_Terminators");
            string guideML;

            guideML = StringUtils.ConvertPlainText("http://www.bbc.co.uk/dna/mb606. Another sentance.");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>. Another sentance.", guideML);

            guideML = StringUtils.ConvertPlainText("First sentance http://www.bbc.co.uk/dna/mb606? Second sentance.");
            Assert.AreEqual("First sentance <LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>? Second sentance.", guideML);

            guideML = StringUtils.ConvertPlainText("The following link is in brackets (http://www.bbc.co.uk/dna/mb606).");
            Assert.AreEqual("The following link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>).", guideML);

            guideML = StringUtils.ConvertPlainText("Another link is in brackets (http://www.bbc.co.uk/dna/mb606/).");
            Assert.AreEqual("Another link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/\">http://www.bbc.co.uk/dna/mb606/</LINK>).", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123, something else");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>, something else", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123. Something else");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>. Something else", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = @http://www.bbc.co.uk/dna/mb606/A123@ Something else");
            Assert.AreEqual("http1 = @<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>@ Something else", guideML);

            guideML = StringUtils.ConvertPlainText("http1 = \"http://www.bbc.co.uk/dna/mb606/A123\",|{^ Something else");
            Assert.AreEqual("http1 = \"<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>\",|{^ Something else", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_NoHttpSequence()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_NoHttpSequence");
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("There are known knowns; there are things we know we know.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known knowns; there are things we know we know.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("There are known unknowns http; that is to say we know there are some things we do not know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known unknowns http; that is to say we know there are some things we do not know.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_NoHttpSequence()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_NoHttpSequence");
            string guideML;

            guideML = StringUtils.ConvertPlainText("There are known knowns; there are things we know we know.");
            Assert.AreEqual("There are known knowns; there are things we know we know.", guideML);

            guideML = StringUtils.ConvertPlainText("There are known unknowns http; that is to say we know there are some things we do not know.");
            Assert.AreEqual("There are known unknowns http; that is to say we know there are some things we do not know.", guideML);

            guideML = StringUtils.ConvertPlainText("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            Assert.AreEqual("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_EmptyStrings()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_EmptyStrings");
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("There are known knowns; there are things we know we know.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known knowns; there are things we know we know.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("There are known unknowns http; that is to say we know there are some things we do not know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known unknowns http; that is to say we know there are some things we do not know.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML(String.Empty);
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY></BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_EmptyStrings()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_EmptyStrings");
            string guideML;

            guideML = StringUtils.ConvertPlainText("There are known knowns; there are things we know we know.");
            Assert.AreEqual("There are known knowns; there are things we know we know.", guideML);

            guideML = StringUtils.ConvertPlainText("There are known unknowns http; that is to say we know there are some things we do not know.");
            Assert.AreEqual("There are known unknowns http; that is to say we know there are some things we do not know.", guideML);

            guideML = StringUtils.ConvertPlainText("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            Assert.AreEqual("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.", guideML);

            guideML = StringUtils.ConvertPlainText(String.Empty);
            Assert.AreEqual("", guideML);
        }

        ////////////////////////////////////////

        /// <summary>
        /// Tests for plain text to GuideML conversion if input is null. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_NullInput()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_NullInput");
            string guideML = null;
            try
            {
                guideML = StringUtils.PlainTextToGuideML(guideML);
                Assert.AreEqual("<GUIDE><BODY></BODY></GUIDE>", guideML);
            }
            catch (NullReferenceException ex)
            {
                Assert.IsTrue(ex is NullReferenceException, "Was expecting NullReferenceException but got " + ex.GetType());
            }
        }

        /// <summary>
        /// Tests for marking up plain text if input is null. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_NullInput()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_NullInput");
            string guideML = null;
            try
            {
                guideML = StringUtils.ConvertPlainText(guideML);
                Assert.AreEqual("", guideML);
            }
            catch (NullReferenceException ex)
            {
                Assert.IsTrue(ex is NullReferenceException, "Was expecting NullReferenceException but got " + ex.GetType());
            }
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if urls are long. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_Longurls()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_Longurls");
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd is here.");
            Assert.AreEqual("<GUIDE><BODY>A long url <LINK HREF=\"http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd\">http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd</LINK> is here.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if urls are long. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_Longurls()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_Longurls");
            string guideML;

            guideML = StringUtils.ConvertPlainText("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd is here.");
            Assert.AreEqual("A long url <LINK HREF=\"http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd\">http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd</LINK> is here.", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if urls are too long. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_HttpToClickableLink_InvalidLength()
        {
            Console.WriteLine("Before PlainTextToGuideML_HttpToClickableLink_InvalidLength");
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.");
            Assert.AreEqual("<GUIDE><BODY>A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if urls are too long. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_HttpToClickableLink_InvalidLength()
        {
            Console.WriteLine("Before ConvertPlainText_HttpToClickableLink_InvalidLength");
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = StringUtils.ConvertPlainText("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.");
            Assert.AreEqual("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text that contains carriage returns. 
        /// </summary>
        [TestMethod]
        public void PlainTextToGuideML_CRsToBRs()
        {
            Console.WriteLine("Before PlainTextToGuideML_CRsToBRs");
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = StringUtils.PlainTextToGuideML("A sentence. \r\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("A sentence. \n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("A sentence. \r\n\r\n\r\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /><BR /><BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("A sentence. \n\n\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /><BR /><BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = StringUtils.PlainTextToGuideML("A sentence. \'test\' Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. \'test\' Another sentence.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text that contains carriage returns. 
        /// </summary>
        [TestMethod]
        public void ConvertPlainText_CRsToBRs()
        {
            Console.WriteLine("Before ConvertPlainText_CRsToBRs");
            string guideML;

            guideML = StringUtils.ConvertPlainText("A sentence. \r\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /> Another sentence.", guideML);

            guideML = StringUtils.ConvertPlainText("A sentence. \n Another sentence.");
            Assert.AreEqual("A sentence. <BR /> Another sentence.", guideML);

            guideML = StringUtils.ConvertPlainText("A sentence. \r\n\r\n\r\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /><BR /><BR /> Another sentence.", guideML);

            guideML = StringUtils.ConvertPlainText("A sentence. \n\n\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /><BR /><BR /> Another sentence.", guideML);

            guideML = StringUtils.ConvertPlainText("A sentence. \'test\' Another sentence.");
            Assert.AreEqual("A sentence. \'test\' Another sentence.", guideML);
        }

        /// <summary>
        /// Test Unescaping of strings.
        /// </summary>
        [TestMethod]
        public void BasicUnescapeStringTest()
        {
            Console.WriteLine("Before BasicUnescapeStringTest");
            string unEscapeString = StringUtils.UnescapeString("blah 1, blah2, blah3");
            Assert.AreEqual("blah 1, blah2, blah3", unEscapeString);
        }

		/// <summary>
		/// Test the URI unescape code
		/// </summary>
		[TestMethod]
		public void UriUnescaping()
		{
			Assert.AreEqual(StringUtils.UnescapeString("123456"), "123456");
			Assert.AreEqual(StringUtils.UnescapeString("123+456"), "123 456");
			Assert.AreEqual(StringUtils.UnescapeString("123%2B456"), "123+456");

			Guid result = new Guid("374f00a2-0b73-4594-670a-738fa0fc9ee5");

			Guid guid = DnaHasher.GenerateHash("The quick brown fox");

			Assert.AreEqual(result.ToString(), "374f00a2-0b73-4594-670a-738fa0fc9ee5", "Comparing hashed guid with expected result");

			Assert.AreEqual(DnaHasher.GenerateHashString("The quick brown fox"), "a2004f37730b9445670a738fa0fc9ee5", "Comparing string result from expected result");
		}

        /// <summary>
        /// Test the XMLTags uppercase
        /// </summary>
        [TestMethod]
        public void ConvertXmlTagsToUppercaseTest()
        {
            string actualXML = "<commentsList><itemsPerPage>20</itemsPerPage><startIndex>0</startIndex><totalCount>1</totalCount><sortBy>Created</sortBy><sortDirection>Ascending</sortDirection><filterBy>None</filterBy></commentsList>";
            string expectedXML = "<COMMENTSLIST><ITEMSPERPAGE>20</ITEMSPERPAGE><STARTINDEX>0</STARTINDEX><TOTALCOUNT>1</TOTALCOUNT><SORTBY>Created</SORTBY><SORTDIRECTION>Ascending</SORTDIRECTION><FILTERBY>None</FILTERBY></COMMENTSLIST>";

            Assert.AreEqual(expectedXML, StringUtils.ConvertXmlTagsToUppercase(actualXML));
        }

        /// <summary>
        /// Test the XMLTags lowercase
        /// </summary>
        [TestMethod]
        public void ConvertXmlTagsToLowercaseTest()
        {
            string actualXML = "<commentsList><itemsPerPage>20</itemsPerPage><startIndex>0</startIndex><totalCount>1</totalCount><sortBy>Created</sortBy><sortDirection>Ascending</sortDirection><filterBy>None</filterBy></commentsList>";
            string expectedXML = "<commentslist><itemsperpage>20</itemsperpage><startindex>0</startindex><totalcount>1</totalcount><sortby>Created</sortby><sortdirection>Ascending</sortdirection><filterby>None</filterby></commentslist>"; 

            Assert.AreEqual(expectedXML, StringUtils.ConvertXmlTagsToLowercase(actualXML));
        }
    }
}
