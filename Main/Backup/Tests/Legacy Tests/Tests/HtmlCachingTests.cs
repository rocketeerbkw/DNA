using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// HTML caching tests
    /// </summary>
    [TestClass]
    public class HtmlCachingTests : FullInputContext
    {
        private string _testXSLTFilename = Environment.CurrentDirectory + "DnaHtmlCacheTestFile.xsl";

        private bool _initialHtmlCachingValue;
        private int _initialHtmlCachingExpiryTimeValue;

        private SiteOptionList _siteOptionList;

        string _siteUrlName = "haveyoursay";
        int _siteId = 0;

        /// <summary>
        /// Constructor
        /// </summary>
        public HtmlCachingTests(string debugUserDetails)
            : base(debugUserDetails)
        {
            ReadSiteOptionListFromDatabase();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public HtmlCachingTests()
            : base("")
        {
            ReadSiteOptionListFromDatabase();
        }

        private void ReadSiteOptionListFromDatabase()
        {
            _testXSLTFilename = base.DnaConfig.CachePath + "DnaHtmlCacheTestFile.xsl";
            _siteOptionList = new SiteOptionList();
            _siteOptionList.CreateFromDatabase(ReaderCreator, base.dnaDiagnostics);
        }

        /// <summary>
        /// Sets the HTML Caching option in the database
        /// </summary>
        /// <param name="value">the new value</param>
        public void SetHtmlCaching(bool value)
        {
            _siteOptionList.SetValueBool(_siteId, "Cache", "HTMLCaching", value, DnaMockery.CreateDatabaseReaderCreator(), null);
        }

        /// <summary>
        /// Sets the HTML caching expiry time in the database
        /// </summary>
        /// <param name="value">the new value</param>
        public void SetHtmlCachingExpiryTime(int value)
        {
            _siteOptionList.SetValueInt(_siteId, "Cache", "HTMLCachingExpiryTime", value, ReaderCreator, base.dnaDiagnostics);
        }

        /// <summary>
        /// Saves the current HTML caching options
        /// <see cref="RestoreHtmlCachingSiteOptions"/>
        /// </summary>
        public void SaveHtmlCachingSiteOptions()
        {
            _initialHtmlCachingValue = _siteOptionList.GetValueBool(_siteId, "Cache", "HTMLCaching");
            _initialHtmlCachingExpiryTimeValue = _siteOptionList.GetValueInt(_siteId, "Cache", "HTMLCachingExpiryTime");
        }

        /// <summary>
        /// Restores the values saved by a call to SaveHtmlCachingSiteOptions()
        /// <see cref="SaveHtmlCachingSiteOptions"/>
        /// </summary>
        public void RestoreHtmlCachingSiteOptions()
        {
            SetHtmlCaching(_initialHtmlCachingValue);
            SetHtmlCachingExpiryTime(_initialHtmlCachingExpiryTimeValue);
        }

        /// <summary>
        /// Sets up the HTML caching tests
        /// </summary>
        [TestInitialize]
        public void SetUpHtmlCachingTests()
        {
            base.SetUseIdentity = false;
            _siteId = SiteList.GetSite(_siteUrlName).SiteID;
            SaveHtmlCachingSiteOptions();
        }

        /// <summary>
        /// Tears down the HTML caching tests
        /// </summary>
        [TestCleanup]
        public void TearDownHtmlCachingTests()
        {
            RestoreHtmlCachingSiteOptions();
            RefreshSiteOptions();

            File.Delete(_testXSLTFilename);
        }

        private string RequestPage(DnaTestURLRequest request)
        {
            request.RequestPage("acs?d_skinfile=" + _testXSLTFilename + "&clear_templates=1");
            return request.GetLastResponseAsString();
        }

        /// <summary>
        /// Makes the web server refresh it's site options 
        /// </summary>
        public void RefreshSiteOptions()
        {
            SendSignal("action=recache-site");
        }

        /// <summary>
        /// Tests behaviour when HTML caching is off
        /// </summary>
        [TestMethod]
        public void TestHtmlCachingOffNotLoggedIn()
        {
            Console.WriteLine("TestHtmlCachingOffNotLoggedIn");
            int expiryTime = 30;

            SetHtmlCaching(false);
            SetHtmlCachingExpiryTime(expiryTime);
            RefreshSiteOptions();

            CreateXSLTFile("HTML caching is OFF");

            DateTime start = DateTime.Now;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteUrlName);
            request.SetCurrentUserNotLoggedInUser();
            string s = RequestPage(request);
            Assert.IsTrue(s.Contains("HTML caching is OFF"),"Initial request doesn't contain correct string");

            CreateXSLTFile("HTML caching is STILL OFF");

            s = RequestPage(request);
            Assert.IsTrue(s.Contains("HTML caching is STILL OFF"), "Second request doesn't contain new string");

            DateTime end = DateTime.Now;

            // This test has to complete within a time limit
            TimeSpan ts = end.Subtract(start);
            Assert.IsTrue(ts.Seconds < expiryTime,"Test didn't complete in time");
        }

        /// <summary>
        /// Tests behavour when HTML caching is on
        /// </summary>
        [TestMethod]
        public void TestHtmlCachingOnNotLoggedIn()
        {
            Console.WriteLine("TestHtmlCachingOnNotLoggedIn");
            int expiryTime = 30;

            SetHtmlCaching(true);
            SetHtmlCachingExpiryTime(expiryTime);
            RefreshSiteOptions();

            CreateXSLTFile("HTML caching is ON");

            DateTime start = DateTime.Now;

            DnaTestURLRequest request = new DnaTestURLRequest(_siteUrlName);
            request.SetCurrentUserNotLoggedInUser();
            string s = RequestPage(request);
            Assert.IsTrue(s.Contains("HTML caching is ON"),"Initial request doesn't contain correct string");

            CreateXSLTFile("HTML caching is STILL ON");

            s = RequestPage(request);
            Assert.IsTrue(s.Contains("HTML caching is ON"),"Second request doesn't contain initial string");
            Assert.IsFalse(s.Contains("HTML caching is STILL ON"),"Second request contains new string when it should still be the old one");

            TimeSpan ts = DateTime.Now.Subtract(start);
            Assert.IsTrue(ts.Seconds < expiryTime,"Test didn't run fast enough");

            // Sleep until the HTML caching has expired
            System.Threading.Thread.Sleep((expiryTime+1) * 1000 - ts.Milliseconds);

            s = RequestPage(request);
            Assert.IsFalse(s.Contains("HTML caching is ON"),"Request still has initial string - it should be the new on now");
            Assert.IsTrue(s.Contains("HTML caching is STILL ON"),"The new string is not there yet");
        }

        /// <summary>
        /// Tests behavour when HTML caching is on
        /// </summary>
        [TestMethod]
        public void TestHtmlCachingOnLoggedInUsingIdentity()
        {
            Console.WriteLine("TestHtmlCachingOnNotLoggedInUsingIdentity");
            int expiryTime = 30;
            _siteId = SiteList.GetSite("identity606").SiteID;

            base.SetUseIdentity = true;
            SetHtmlCaching(true);
            SetHtmlCachingExpiryTime(expiryTime);
            RefreshSiteOptions();

            CreateXSLTFile("First call");

            DateTime start = DateTime.Now;

            DnaTestURLRequest request = new DnaTestURLRequest("identity606");
            request.SetCurrentUserAsIdentityTestUser();
            request.UseIdentitySignIn = true;
            string s = RequestPage(request);
            Assert.IsTrue(s.Contains("First call"), "Initial request doesn't contain correct string");

            CreateXSLTFile("Second call");

            s = RequestPage(request);
            Assert.IsTrue(s.Contains("Second call"), "Second request doesn't contain new string");

            DateTime end = DateTime.Now;

            // This test has to complete within a time limit
            TimeSpan ts = end.Subtract(start);
            Assert.IsTrue(ts.Seconds < expiryTime, "Test didn't complete in time");
        }

        private void CreateXSLTFile(string body)
        {
            StringBuilder xslt = new StringBuilder("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            xslt.Append("<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">");
            xslt.Append("<xsl:template match=\"/\"><html><body>");
            xslt.Append(body);
            xslt.Append("</body></html></xsl:template></xsl:stylesheet>");
            
            StreamWriter file = new StreamWriter(_testXSLTFilename);
            file.Write(xslt.ToString());
            file.Close();
        }
    }
}
