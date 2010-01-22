using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Test class for testing the xslt caching system
    /// </summary>
    [TestClass]
    public class XSLTCachingTests
    {
        private string _testXSLTFilename = Environment.CurrentDirectory + "DnaXsltCacheTestFile.xsl";
        HtmlCachingTests _htmlCachingTests = null;

        /// <summary>
        /// Default constructor
        /// </summary>
        public XSLTCachingTests()
        {
            _htmlCachingTests = new HtmlCachingTests(false);
        }

        /// <summary>
        /// Setup function that creates the XSLT file that we will test the xslt transform caching with
        /// </summary>
        [TestInitialize]
        public void SetUpXSLTCachingTests()
        {
            // Check to see if the file we want to create already exists
            if (File.Exists(_testXSLTFilename))
            {
                // Delete it, so we start with a clean slate
                File.Delete(_testXSLTFilename);
            }

            // Need to turn off HTML caching for XSLT caching tests to work
            _htmlCachingTests.SaveHtmlCachingSiteOptions();
            _htmlCachingTests.SetHtmlCaching(false);
            _htmlCachingTests.RefreshSiteOptions();
        }

        /// <summary>
        /// Tears down the XSLT caching tests
        /// </summary>
        [TestCleanup]
        public void TearDownXSLTCachingTests()
        {
            // Put back the original HTML caching options
            _htmlCachingTests.RestoreHtmlCachingSiteOptions();
            _htmlCachingTests.RefreshSiteOptions();
        }

        /// <summary>
        /// Test function for testing xslt caching
        /// </summary>
        [TestMethod]
        public void TestXSLTCaching()
        {
            Console.WriteLine("Before TestXSLTCaching");
            // First log the user into the system.
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.NORMALUSER);

            // Now create the test skin to use
            StreamWriter test1file = new StreamWriter(_testXSLTFilename);
            test1file.Write(CreateXSLTFile("XSLT caching test 1"));
            test1file.Close();

            // Now call the acs page with the clear templates flag and
            // check to make sure that it returns the text we supplied in the new xslt file.
            request.RequestPage("acs?d_skinfile=" + _testXSLTFilename + "&clear_templates=1");
            Assert.IsTrue(request.GetLastResponseAsString().Contains("XSLT caching test 1"));

            // Now update the file so that it says something different.
            StreamWriter test2file = new StreamWriter(_testXSLTFilename);
            test2file.Flush();
            test2file.Write(CreateXSLTFile("XSLT caching test 2"));
            test2file.Close();

            // Now call the same page. We should still have the old transform in cache, so the text should still reflect what was in the old file!
            request.RequestPage("acs?d_skinfile=" + _testXSLTFilename);
            Assert.IsTrue(request.GetLastResponseAsString().Contains("XSLT caching test 1"));

            // Now call the acs page and flush the cache. We should now see that it is using the new file and not the old!
            request.RequestPage("acs?d_skinfile=" + _testXSLTFilename + "&clear_templates=1");
            Assert.IsFalse(request.GetLastResponseAsString().Contains("XSLT caching test 1"));
            Assert.IsTrue(request.GetLastResponseAsString().Contains("XSLT caching test 2"));

            // Now delete the file totally! Check to make sure we still have the cached version!
            File.Delete(_testXSLTFilename);
            request.RequestPage("acs?d_skinfile=" + _testXSLTFilename);
            Assert.IsFalse(request.GetLastResponseAsString().Contains("XSLT caching test 1"));
            Assert.IsTrue(request.GetLastResponseAsString().Contains("XSLT caching test 2"));
            
            Console.WriteLine("After TestXSLTCaching");
        }

        /// <summary>
        /// Creates a string that represents a simple xslt file with a given body
        /// </summary>
        /// <param name="body">The text that you want to put in the body</param>
        /// <returns>The string that represents the xslt file</returns>
        private string CreateXSLTFile(string body)
        {
            StringBuilder xslt = new StringBuilder("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xslt.Append("<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">");
            xslt.Append("<xsl:template match=\"/\"><html><body>");
            xslt.Append(body);
            xslt.Append("</body></html></xsl:template></xsl:stylesheet>");
            return xslt.ToString();
        }
    }
}

