using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for SearchThreadPostTest and is intended
    ///to contain all SearchThreadPostTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SearchThreadPostTest
    {
        /// <summary>
        ///A test for FormatSearchPost
        ///</summary>
        [TestMethod()]
        public void FormatSearchPostTest()
        {
            var searchTerm = new string[]{"myresult"};
            var testDataPlainText = new List<string[]>();
            testDataPlainText.Add(new[] { "This post is ok.", "This post is ok." });//no html
            testDataPlainText.Add(new[] { "This <script src=\"test\">post</script> is ok.", "This post is ok." });//script tags
            testDataPlainText.Add(new[] { "This <p onclick=\"test\">post</p> is ok.", "This post is ok." });//allowed tags with events
            testDataPlainText.Add(new[] { "This <link>post</link> is ok.", "This post is ok." });//invalid tags
            testDataPlainText.Add(new[] { "This <ale> post is ok.", "This  post is ok." });//with smileys translation
            testDataPlainText.Add(new[] { "This <quote>post</quote> is ok.", "This post is ok." });//with quote translation
            testDataPlainText.Add(new[] { "This http://www.bbc.co.uk/ is ok.", "This http://www.bbc.co.uk/ is ok." });//with link translation
            testDataPlainText.Add(new[] { "This newline \r\n is ok.", "This newline  is ok." });//with newline translation
            testDataPlainText.Add(new[] { "1 > 4 < 5", "1 &gt; 4 &lt; 5" });//translates < and > chars
            testDataPlainText.Add(new[] { "jack & jill", "jack &amp; jill" });//translates & chars
            testDataPlainText.Add(new[] { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus at erat id libero iaculis varius sed et magna. Morbi et ligula in diam sagittis mattis. Nulla eu ullamcorper lectus. Quisque sed sem leo posuere.",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus at erat id libero iaculis varius sed et magna. Morbi et ligula in diam sagittis mattis. Nulla eu ullamcorper lectus. Quisque sed sem..."});
            testDataPlainText.Add(new[] { "Lorem ipsum dolor sit amet, consectetur myresult elit. Vivamus at erat id libero iaculis varius sed et magna. Morbi et ligula in diam sagittis mattis. Nulla eu ullamcorper lectus. Quisque sed sem leo posuere.",
                "Lorem ipsum dolor sit amet, consectetur <SEARCHRESULT>myresult</SEARCHRESULT> elit. Vivamus at erat id libero iaculis varius sed et magna. Morbi et ligula in diam sagittis mattis. Nulla eu ullamcorper lectus. Quisque sed sem leo..."});
            testDataPlainText.Add(new[] { "Lorem ipsum dolor sit amet, consectetur elit. Vivamus at erat id libero iaculis varius sed et magna. Morbi et ligula in diam sagittis mattis.myresult Nulla eu ullamcorper lectus. Quisque sed sem leo posuere.",
                "...<SEARCHRESULT>myresult</SEARCHRESULT> Nulla eu ullamcorper lectus. Quisque sed sem leo posuere."});


            foreach (var data in testDataPlainText)
            {
                Assert.AreEqual(data[1], SearchThreadPost.FormatSearchPost(data[0], searchTerm));
            }

        }
    }
}
