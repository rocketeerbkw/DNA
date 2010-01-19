using System;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace BBC.Dna.Utils.Tests
{
    /// <summary>
    /// Test GuideMLTranslator
    /// </summary>
    [TestClass]
    public class GuideMLTranslatorTests
    {
        private const string _schemaUri = "GuideML.xsd";
        /// <summary>
        /// Basic tests for plain text to GuideML conversion if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_Basic()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator(); 
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("http://www.bbc.co.uk/");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</LINK></BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("Check out some nonsense here: http://www.bbc.co.uk/dna/mb606/A123");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Check out some nonsense here: <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK></BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK></BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456 http 3 = http://www.bbc.co.uk/dna/mb606/789 more text");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK> http 3 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/789\">http://www.bbc.co.uk/dna/mb606/789</LINK> more text</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http://www.bbc.co.uk/dna/mb606 is a good site.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK> is a good site.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("Some text?");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Some text?</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Basic tests for marking up plain text if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_Basic()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("http://www.bbc.co.uk/");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</LINK>", guideML);

            guideML = guideMLTranslator.ConvertPlainText("Check out some nonsense here: http://www.bbc.co.uk/dna/mb606/A123");
            Assert.AreEqual("Check out some nonsense here: <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK>", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123 http2 http://www.bbc.co.uk/dna/mb606/A456 http 3 = http://www.bbc.co.uk/dna/mb606/789 more text");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK> http2 <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A456\">http://www.bbc.co.uk/dna/mb606/A456</LINK> http 3 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/789\">http://www.bbc.co.uk/dna/mb606/789</LINK> more text", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http://www.bbc.co.uk/dna/mb606 is a good site.");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK> is a good site.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("Some text?");
            Assert.AreEqual("Some text?", guideML);
        }

        /// <summary>
        /// Tests on tricky terminators for plain text to GuideML conversion if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_Terminators()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator(); 
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("http://www.bbc.co.uk/dna/mb606. Another sentance.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>. Another sentance.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("First sentance http://www.bbc.co.uk/dna/mb606? Second sentance.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>First sentance <LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>? Second sentance.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("The following link is in brackets (http://www.bbc.co.uk/dna/mb606).");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>The following link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>).</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("Another link is in brackets (http://www.bbc.co.uk/dna/mb606/).");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>Another link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/\">http://www.bbc.co.uk/dna/mb606/</LINK>).</BODY></GUIDE>", guideML);

			guideML = guideMLTranslator.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123, something else");
			validator = new DnaXmlValidator(guideML, _schemaUri);
			validator.Validate();
			Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>, something else</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http1 = http://www.bbc.co.uk/dna/mb606/A123. Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>. Something else</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http1 = @http://www.bbc.co.uk/dna/mb606/A123@ Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = @<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>@ Something else</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("http1 = \"http://www.bbc.co.uk/dna/mb606/A123\",|{^ Something else");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>http1 = \"<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>\",|{^ Something else</BODY></GUIDE>", guideML);
			
			// http://www.guardian.co.uk/alqaida/story/0,,2173071,00.html
			guideML = guideMLTranslator.PlainTextToGuideML("Guardian link: http://www.guardian.co.uk/alqaida/story/0,,2173071,00.html");
			validator = new DnaXmlValidator(guideML, _schemaUri);
			validator.Validate();
			Assert.AreEqual("<GUIDE><BODY>Guardian link: <LINK HREF=\"http://www.guardian.co.uk/alqaida/story/0,,2173071,00.html\">http://www.guardian.co.uk/alqaida/story/0,,2173071,00.html</LINK></BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests on tricky terminators for plain text markup if input contains http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_Terminators()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("http://www.bbc.co.uk/dna/mb606. Another sentance.");
            Assert.AreEqual("<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>. Another sentance.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("First sentance http://www.bbc.co.uk/dna/mb606? Second sentance.");
            Assert.AreEqual("First sentance <LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>? Second sentance.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("The following link is in brackets (http://www.bbc.co.uk/dna/mb606).");
            Assert.AreEqual("The following link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606\">http://www.bbc.co.uk/dna/mb606</LINK>).", guideML);

            guideML = guideMLTranslator.ConvertPlainText("Another link is in brackets (http://www.bbc.co.uk/dna/mb606/).");
            Assert.AreEqual("Another link is in brackets (<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/\">http://www.bbc.co.uk/dna/mb606/</LINK>).", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123, something else");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>, something else", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = http://www.bbc.co.uk/dna/mb606/A123. Something else");
            Assert.AreEqual("http1 = <LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>. Something else", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = @http://www.bbc.co.uk/dna/mb606/A123@ Something else");
            Assert.AreEqual("http1 = @<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>@ Something else", guideML);

            guideML = guideMLTranslator.ConvertPlainText("http1 = \"http://www.bbc.co.uk/dna/mb606/A123\",|{^ Something else");
            Assert.AreEqual("http1 = \"<LINK HREF=\"http://www.bbc.co.uk/dna/mb606/A123\">http://www.bbc.co.uk/dna/mb606/A123</LINK>\",|{^ Something else", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_NoHttpSequence()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator(); 
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("There are known knowns; there are things we know we know.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known knowns; there are things we know we know.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("There are known unknowns http; that is to say we know there are some things we do not know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known unknowns http; that is to say we know there are some things we do not know.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_NoHttpSequence()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("There are known knowns; there are things we know we know.");
            Assert.AreEqual("There are known knowns; there are things we know we know.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("There are known unknowns http; that is to say we know there are some things we do not know.");
            Assert.AreEqual("There are known unknowns http; that is to say we know there are some things we do not know.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            Assert.AreEqual("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_EmptyStrings()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator(); 
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("There are known knowns; there are things we know we know.");
            DnaXmlValidator validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known knowns; there are things we know we know.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("There are known unknowns http; that is to say we know there are some things we do not know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>There are known unknowns http; that is to say we know there are some things we do not know.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY>But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML(String.Empty);
            validator = new DnaXmlValidator(guideML, _schemaUri);
            validator.Validate();
            Assert.AreEqual("<GUIDE><BODY></BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if input does not contain http:// sequence. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_EmptyStrings()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("There are known knowns; there are things we know we know.");
            Assert.AreEqual("There are known knowns; there are things we know we know.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("There are known unknowns http; that is to say we know there are some things we do not know.");
            Assert.AreEqual("There are known unknowns http; that is to say we know there are some things we do not know.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.");
            Assert.AreEqual("But there are also unknown unknowns -- www.cbsnews.com/blogs/2006/11/09/publiceye/entry2165872.shtml -- the ones we don't know we don't know.", guideML);

            guideML = guideMLTranslator.ConvertPlainText(String.Empty);
            Assert.AreEqual("", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if input is null. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_NullInput()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator(); 
            string guideML = null;
            try
            {
                guideML = guideMLTranslator.PlainTextToGuideML(guideML);
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
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_NullInput()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML = null;
            try
            {
                guideML = guideMLTranslator.ConvertPlainText(guideML);
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
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_Longurls()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd is here.");
            Assert.AreEqual("<GUIDE><BODY>A long url <LINK HREF=\"http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd\">http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd</LINK> is here.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if urls are long. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_Longurls()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd is here.");
            Assert.AreEqual("A long url <LINK HREF=\"http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd\">http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andadd</LINK> is here.", guideML);
        }

        /// <summary>
        /// Tests for plain text to GuideML conversion if urls are too long. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_HttpToClickableLink_InvalidLength()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.");
            Assert.AreEqual("<GUIDE><BODY>A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.</BODY></GUIDE>", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text if urls are too long. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_HttpToClickableLink_InvalidLength()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.");
            Assert.AreEqual("A long url http://www.reallylongurlsareusbecausewecan.con/onceuponatime/inaland/far/far/far/away/gremlin/Thepurposebehindgreekingistoforceyourreviewerstoignorethetextandjustfocusonthedesignelementsonthepage/everydesignerhasexperiencedthereviewsessionwherethereviewersfound13typosinthesampletextthatwasusedordecidedthatthe10-wordmarketingtextreallyshouldbe12/Andsoon/Andsoon/thiscanbereallyfrustratingwhenyouretryingtodecidebetweena2-columnlayoutanda3-columnlayout/ButonceyourepasttheinitialdesignphasetheGreektextshouldbereplacedwithcontentthatisasclosetowhatwillreallybethereasyoucanpossiblyget/becausetextonWebpagesismeanttoberead/Greekedtextwillforcereviewerstoignorethefactthatthecolumnissowideornarrowthatthescan-lineisimpossible/Orthatthefontsizeistoosmallformostpeopletoread/Thatsbecausetheyarentreadingit/OnonesiteIworkedontherewasspaceforapproximately50charactersinthisonesectionofthepage/Butthedatafeedthatdeliveredthatcontentwasa128characterelement/Wedecidedtoalwayscutthefeedoffatawordendjustbeforecharacter46andaddblahblah is here.", guideML);
        }

        /// <summary>
        /// Tests for marking up plain text that contains carriage returns. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_PlainTextToGuideML_CRsToBRs()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.PlainTextToGuideML("A sentence. \r\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("A sentence. \n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("A sentence. \r\n\r\n\r\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /><BR /><BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("A sentence. \n\n\n Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. <BR /><BR /><BR /> Another sentence.</BODY></GUIDE>", guideML);

            guideML = guideMLTranslator.PlainTextToGuideML("A sentence. \'test\' Another sentence.");
            Assert.AreEqual("<GUIDE><BODY>A sentence. \'test\' Another sentence.</BODY></GUIDE>", guideML);
        }

		/// <summary>
		/// Tests that a CR after a link doesn't screw up
		/// </summary>
		[TestMethod]
		public void PlainTextToGuideMLMixingLinksAndReturns()
		{
			GuideMLTranslator translator = new GuideMLTranslator();
			string guideML;

			guideML = translator.PlainTextToGuideML("1 < 2");
			Assert.AreEqual("<GUIDE><BODY>1 &lt; 2</BODY></GUIDE>", guideML);

			guideML = translator.PlainTextToGuideML("http://www.h2g2.com");
			Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.h2g2.com\">http://www.h2g2.com</LINK></BODY></GUIDE>", guideML);

			guideML = translator.PlainTextToGuideML("http://www.h2g2.com/test?abc=1&bcd='2'");
			Assert.AreEqual("<GUIDE><BODY><LINK HREF=\"http://www.h2g2.com/test?abc=1&amp;bcd=&apos;2&apos;\">http://www.h2g2.com/test?abc=1&amp;bcd=&apos;2&apos;</LINK></BODY></GUIDE>", guideML);

			guideML = translator.PlainTextToGuideML("Testing URLs: http://www.h2g2.com\r\n");
			Assert.AreEqual("<GUIDE><BODY>Testing URLs: <LINK HREF=\"http://www.h2g2.com\">http://www.h2g2.com</LINK><BR /></BODY></GUIDE>",guideML);
		}

        /// <summary>
        /// Tests for marking up plain text that contains carriage returns. 
        /// </summary>
        [TestMethod]
        public void GuideMLTranslatorTests_ConvertPlainText_CRsToBRs()
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML;

            guideML = guideMLTranslator.ConvertPlainText("A sentence. \r\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /> Another sentence.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("A sentence. \n Another sentence.");
            Assert.AreEqual("A sentence. <BR /> Another sentence.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("A sentence. \r\n\r\n\r\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /><BR /><BR /> Another sentence.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("A sentence. \n\n\n Another sentence.");
            Assert.AreEqual("A sentence. <BR /><BR /><BR /> Another sentence.", guideML);

            guideML = guideMLTranslator.ConvertPlainText("A sentence. \'test\' Another sentence.");
            Assert.AreEqual("A sentence. \'test\' Another sentence.", guideML);
        }
    }
}