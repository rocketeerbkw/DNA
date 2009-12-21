using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Tests for the SiteListTests Class
    /// </summary>
    [TestClass]
    public class SiteListTests
    {
        SiteList _testSiteList;
        bool _siteListloaded = false;

        /// <summary>
        /// Constructor for the test
        /// </summary>
        public SiteListTests()
        {
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                _testSiteList = new SiteList(inputcontext.dnaDiagnostics, DnaMockery.DnaConfig.ConnectionString);
                inputcontext.SetCurrentSite("h2g2");
                inputcontext.InitDefaultUser();
            }
        }

        /// <summary>
        /// Test1CreateSiteListTest
        /// </summary>
        [TestMethod]
        public void Test1CreateSiteListClassTest()
        {
            Console.WriteLine("Test1CreateSiteListClassTest");
            Assert.IsNotNull(_testSiteList, "SiteList object created.");
        }

        /// <summary>
        /// Test2LoadSiteListTest
        /// </summary>
        [TestMethod]
        public void Test2LoadSiteListTest()
        {
            Console.WriteLine("Test2LoadSiteListTest");
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                _testSiteList.LoadSiteList();
                _siteListloaded = true;
            }
        }

        /// <summary>
        /// Test3GetSiteh2g2byidTest
        /// </summary>
        [TestMethod]
        public void Test3GetSiteh2g2byidTest()
        {
            Console.WriteLine("Test3GetSiteh2g2byidTest");
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                Site h2g2 = (Site)_testSiteList.GetSite(1);
                Assert.AreEqual(h2g2.SiteName, "h2g2");
            }
        }

        /// <summary>
        /// Test4GetSiteh2g2byNameTest
        /// </summary>
        [TestMethod]
        public void Test4GetSiteh2g2byNameTest()
        {
            Console.WriteLine("Test4GetSiteh2g2byNameTest");
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                Site h2g2 = (Site)_testSiteList.GetSite("h2g2");
                Assert.AreEqual(h2g2.SiteID, 1);
            }
        }

        /// <summary>
        /// Test5AddASiteTest
        /// </summary>
        [TestMethod]
        public void Test5AddASiteTest()
        {
            Console.WriteLine("Test5AddASiteTest");
            _testSiteList.AddSiteDetails(999, "MyTestSite", 0, false, "TestSiteSkin", true, "NewTestSite", "TestSite",
                            "moderator@bbc.co.uk", "editor@bbc.co.uk", "feedback@bbc.co.uk", 1090497224, false, true, true, "", "Alert", 2000, 1090497224, 0,
                            1, 1, false, false, 16, 255, 1,"MySSOService",false,"skinset","");

            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                Site h2g2 = (Site)_testSiteList.GetSite(999);
                Assert.AreEqual(h2g2.SiteName, "MyTestSite");

                h2g2 = (Site)_testSiteList.GetSite("MyTestSite");
                Assert.AreEqual(h2g2.SiteID, 999);
                Assert.AreEqual(h2g2.SSOService, "MySSOService");
            }
        }

        /// <summary>
        /// Helper function for other tests. Use this test class functionality to get the site id for a given site
        /// </summary>
        /// <param name="siteName">The name of the site that you want to get the id for</param>
        /// <returns>The ID of the requested site</returns>
        public int GetIDForSiteName(string siteName)
        {
            // Make sure the sitelist has been loaded at least once!
            using (FullInputContext inputcontext = new FullInputContext(false))
            {
                if (!_siteListloaded)
                {
                    _testSiteList.LoadSiteList();
                    _siteListloaded = true;
                }
                return _testSiteList.GetSite(siteName).SiteID;
            }
        }
    }
}
