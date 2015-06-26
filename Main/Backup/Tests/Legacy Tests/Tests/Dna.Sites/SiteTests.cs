using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace Tests
{
    /// <summary>
    /// Tests for the Sites Class
    /// </summary>
    [TestClass]
    public class SiteTests
    {
        private const string _schemaUri = "Site.xsd";
        /// <summary>
        /// Creating my test site
        /// </summary>
        Site _testSite = null;

        FullInputContext _inputcontext;

        /// <summary>
        /// Setup the test site for the tests to run against
        /// </summary>
        [TestInitialize]
        public void SetupTestSite()
        {
            _inputcontext = new FullInputContext("");
            _testSite = new Site(1, "h2g2", 0, false, "brunel", true, "H2G2", "h2g2",
                        "moderator@bbc.co.uk", "editor@bbc.co.uk", "feedback@bbc.co.uk", 1090497224, false, true, true, "", "Alert", 2000, 1090497224, 0,
                        1, 1, false, false, 16, 255, 1, "h2g2", false, "brunel", "", "");
        }

        /// <summary>
        /// Test1CreateSitesClassTest
        /// </summary>
        [TestMethod]
        public void Test1CreateSitesClassTest()
        {
            Console.WriteLine("Test1CreateSitesClassTest");
            Assert.IsNotNull(_testSite, "Site object created.");

        }

        /// <summary>
        /// Test2TestSiteID
        /// </summary>
        [TestMethod]
        public void Test2TestSiteID()
        {
            Console.WriteLine("Test2TestSiteID");
            Assert.AreEqual(_testSite.SiteID, 1);
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.Attributes["ID"].InnerText, "1", "Site ID Attribute Xml incorrect");
            }
        }
        
        /// <summary>
        /// Test3TestSiteName
        /// </summary>
        [TestMethod]
        public void Test3TestSiteName()
        {
            Console.WriteLine("Test3TestSiteName");
            Assert.AreEqual(_testSite.SiteName, "h2g2");
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("NAME").InnerText, "h2g2", "Site Name Xml incorrect");
            }
        }

        /// <summary>
        /// Test4TestSSSOService
        /// </summary>
        [TestMethod]
        public void Test4TestSSOService()
        {
            Console.WriteLine("Test4TestSSOService");
            Assert.AreEqual(_testSite.SSOService, "h2g2");
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("SSOSERVICE").InnerText, "h2g2", "Site SSOService Xml incorrect");
            }
        }


        /// <summary>
        /// Test5TestMinAge
        /// </summary>
        [TestMethod]
        public void Test5TestMinAge()
        {
            Console.WriteLine("Test5TestMinAge");
            Assert.AreEqual(_testSite.MinAge, 16);
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("MINAGE").InnerText, "16", "Site Min Age Xml incorrect");
            }
        }

        /// <summary>
        /// Test6TestMaxAge
        /// </summary>
        [TestMethod]
        public void Test6TestMaxAge()
        {
            Console.WriteLine("Test6TestMaxAge");
            Assert.AreEqual(_testSite.MaxAge, 255);
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("MAXAGE").InnerText, "255", "Site Max Age Xml incorrect");
            }
        }

        /// <summary>
        /// Test7TestAddOpenCloseTimesTest
        /// </summary>
        [TestMethod]
        public void Test7TestAddOpenCloseTimesTest()
        {
            Console.WriteLine("Test7TestAddOpenCloseTimesTest");
            _testSite.AddOpenCloseTime(2, 23, 55, 1);
            _testSite.AddOpenCloseTime(2, 1, 5, 0);

            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(testnode != null, "Failed to generate xml for test site!!!");
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("OPENCLOSETIMES/OPENCLOSETIME").Attributes["DAYOFWEEK"].Value, "2", "Start Day Of week incorrect");
                Assert.AreEqual(testnode.SelectSingleNode("OPENCLOSETIMES/OPENCLOSETIME/OPENTIME/HOUR").InnerText, "1", "Start Hour Of week incorrect");
                Assert.AreEqual(testnode.SelectSingleNode("OPENCLOSETIMES/OPENCLOSETIME/OPENTIME/MINUTE").InnerText, "5", "Start Minute Of week incorrect");
                Assert.AreEqual(testnode.SelectSingleNode("OPENCLOSETIMES/OPENCLOSETIME/CLOSETIME/HOUR").InnerText, "23", "End Hour Of week incorrect");
                Assert.AreEqual(testnode.SelectSingleNode("OPENCLOSETIMES/OPENCLOSETIME/CLOSETIME/MINUTE").InnerText, "55", "End Minute Of week incorrect");
            }
        }

        /// <summary>
        /// Test8TestEmergencyClose
        /// </summary>
        [TestMethod]
        public void Test8TestEmergencyClose()
        {
            Console.WriteLine("Test8TestEmergencyClose");
            _testSite.IsEmergencyClosed = true;
            Assert.AreEqual(_testSite.IsEmergencyClosed, true, "Emergency Closed field failed to set");
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("SITECLOSED/@EMERGENCYCLOSED").InnerText, "1", "Site Emergency Closed Xml incorrect");
            }
        }

        /// <summary>
        /// Test9TestSkinExists
        /// </summary>
        [TestMethod]
        public void Test9TestSkinExists()
        {
            Console.WriteLine("Test9TestSkinExists");
            _testSite.AddSkin("testskin","Description for testskin", false);

            Assert.AreEqual(_testSite.DoesSkinExist("testskin"), true);

        }

        /// <summary>
        /// Test10 Test Skin Doesn't Exists
        /// </summary>
        [TestMethod]
        public void Test10TestSkinDoesNotExists()
        {
            Console.WriteLine("Test10TestSkinDoesNotExists");
            Assert.AreEqual(_testSite.DoesSkinExist("falsetestskin"), false);
        }

        /// <summary>
        /// TestA Test Default Skin Doesn't Exists
        /// </summary>
        [TestMethod]
        public void TestATestDefaultSkin()
        {
            Console.WriteLine("TestATestDefaultSkin");
            Assert.AreEqual(_testSite.DefaultSkin, "brunel");
        }

        /// <summary>
        /// TestB Test Get Site Email
        /// </summary>
        [TestMethod]
        public void TestBTestGetEmail()
        {
            Console.WriteLine("TestBTestGetEmail");
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Moderators), "moderator@bbc.co.uk");
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Editors), "editor@bbc.co.uk");
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Feedback), "feedback@bbc.co.uk");
            Assert.AreEqual(_testSite.ModeratorsEmail, "moderator@bbc.co.uk");
            Assert.AreEqual(_testSite.EditorsEmail, "editor@bbc.co.uk");
            Assert.AreEqual(_testSite.FeedbackEmail, "feedback@bbc.co.uk");
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Moderators), _testSite.ModeratorsEmail);
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Editors), _testSite.EditorsEmail);
            Assert.AreEqual(_testSite.GetEmail(Site.EmailType.Feedback), _testSite.FeedbackEmail);
        }
        /// <summary>
        /// TestC Test Is site in a scheduled close time
        /// </summary>
        /// <remarks>The open close events are added in latest first order or Sunday before saturday etc 
        /// and if no events have already happened then</remarks>
        [TestMethod]
        public void TestCTestIsSiteScheduledClosed()
        {
            //setup open/close times
            _testSite.AddOpenCloseTime(2, 23, 55, 1);
            _testSite.AddOpenCloseTime(2, 1, 5, 0);

            Console.WriteLine("TestCTestIsSiteScheduledClosed");
            DateTime date = new DateTime();
            date = Convert.ToDateTime("30/10/06 00:00:00");
            Assert.AreEqual(_testSite.IsSiteScheduledClosed(date), true, "Open - Default behaviour is closed if last event in the week is a closed event)");

            date = Convert.ToDateTime("30/10/06 12:00:00");
            Assert.AreEqual(_testSite.IsSiteScheduledClosed(date), false, "Closed after first open event error");

            date = Convert.ToDateTime("31/10/06 12:00:00");
            Assert.AreEqual(_testSite.IsSiteScheduledClosed(date), true, "Open after first close event (second event)");
        }

        /// <summary>
        /// TestDTestScheduledClosedXml
        /// </summary>
        [TestMethod]
        public void TestDTestScheduledClosedXml()
        {
            Console.WriteLine("TestDTestScheduledClosedXml");
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                string testval = String.Empty;
                if (_testSite.IsSiteScheduledClosed(DateTime.Now))
                {
                    testval = "1";
                }
                else
                {
                    testval = "0";
                }

                Assert.AreEqual(testnode.SelectSingleNode("SITECLOSED/@SCHEDULEDCLOSED").InnerText, testval, "Site Scheduled Close does not match Xml");
            }
        }

        /// <summary>
        /// TestETestSitePassworded
        /// </summary>
        [TestMethod]
        public void TestETestSitePassworded()
        {
            Console.WriteLine("TestETestSitePassworded");
            _testSite.IsPassworded = true;
            Assert.AreEqual(_testSite.IsPassworded, true);

            _testSite.IsPassworded = false;
            Assert.AreEqual(_testSite.IsPassworded, false);
        }

        /// <summary>
        /// TestFTestSiteModerationStatus
        /// </summary>
        [TestMethod]
        public void TestFTestSiteModerationStatus()
        {
            Console.WriteLine("TestFTestSiteModerationStatus");
            Assert.AreEqual((int)_testSite.ModerationStatus, 0);
            SiteXmlBuilder siteXml = new SiteXmlBuilder(_inputcontext);
            XmlNode testnode = siteXml.GenerateXml(null, _testSite);
            DnaXmlValidator validator = new DnaXmlValidator(testnode.OuterXml, _schemaUri);
            validator.Validate();
            if (testnode != null)
            {
                Assert.AreEqual(testnode.SelectSingleNode("MODERATIONSTATUS").InnerText, "0", "Site moderation status Xml incorrect");
            }
        }

        /// <summary>
        /// TestGTestSiteOptions
        /// </summary>
        [TestMethod]
        public void TestGTestSiteOptions()
        {
            Console.WriteLine("TestGTestSiteOptions");
            
            using (FullInputContext fullInputContext = new FullInputContext(""))
            {
                SiteList siteList = new SiteList(fullInputContext.ReaderCreator, fullInputContext.dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);

                SiteXmlBuilder siteXml = new SiteXmlBuilder(fullInputContext);
                XmlNode siteOptionsNode = siteXml.GetSiteOptionListForSiteXml(1, siteList);
                DnaXmlValidator validator = new DnaXmlValidator(siteOptionsNode.OuterXml, "SiteOptions.xsd");
                validator.Validate();
                XmlNode siteOptionNode = siteOptionsNode.SelectSingleNode("/DNAROOT/SITEOPTIONS/SITEOPTION");
                Assert.IsTrue(siteOptionNode != null, "Can't find any SITEOPTION nodes");

                XmlAttributeCollection attribs = siteOptionNode.Attributes;

                int globalAttCount = 0;
                foreach (XmlAttribute a in attribs)
                {
                    if (a.Name == "GLOBAL")
                    {
                        globalAttCount++;
                    }
                    else
                    {
                        Assert.Fail("Unknown attribute on SITEOPTION tag (" + a.Name + ")");
                    }
                }
                Assert.IsTrue(globalAttCount == 1, "There should be 1 GLOBAL attribute on the SITEOPTION tag");
            }
        }
    }
}
