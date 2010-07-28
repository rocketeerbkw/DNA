using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace BBC.Dna.Utils.Tests
{
	/// <summary>
	/// Testing the Statistics class
	/// </summary>
	[TestClass]
	public class StatisticsTests
	{
        private const string _schemaUri = "Statistics.xsd";

        /// <summary>
		/// First tests for the statistics class
		/// </summary>
		[TestMethod]
		public void StatsTests()
		{
            Console.WriteLine("StatsTests");
            //using (FullInputContext _fullInputContext = new FullInputContext(false))
            //{
                Statistics.InitialiseIfEmpty(/*_fullInputContext*/);
                for (int i = 0; i < 5; i++)
                    Statistics.AddCacheHit();
                for (int i = 0; i < 13; i++)
                    Statistics.AddCacheMiss();
                for (int i = 0; i < 3; i++)
                    Statistics.AddHTMLCacheHit();
                for (int i = 0; i < 8; i++)
                    Statistics.AddHTMLCacheMiss();
                for (int i = 0; i < 9; i++)
                    Statistics.AddLoggedOutRequest();
                for (int i = 0; i < 2; i++)
                    Statistics.AddRawRequest();
                for (int i = 0; i < 11; i++)
                    Statistics.AddRequestDuration(123);
                for (int i = 0; i < 11; i++)
                    Statistics.AddIdentityCallDuration(400);
                for (int i = 0; i < 15; i++)
                    Statistics.AddRssCacheHit();
                for (int i = 0; i < 55; i++)
                    Statistics.AddRssCacheMiss();
                for (int i = 0; i < 23; i++)
                    Statistics.AddSsiCacheHit();
                for (int i = 0; i < 34; i++)
                    Statistics.AddSsiCacheMiss();
                for (int i = 0; i < 22; i++)
                    Statistics.AddServerBusy();
                // Get stats per hour
                string sXML = Statistics.GetStatisticsXML();
                Assert.AreNotEqual(String.Empty,sXML);
                DnaXmlValidator validator = new DnaXmlValidator(sXML, _schemaUri);
                validator.Validate();

                XPathNavigator nav = Statistics.CreateStatisticsDocument(60).CreateNavigator(); // 60 used as default in GetStatisticsXML()

                CommonXpathTests1(nav, 60);
                Assert.AreEqual("00:00", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[1]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");
                Assert.AreEqual("01:00", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[2]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");

                sXML = Statistics.GetStatisticsXML(1);
                Assert.AreNotEqual(String.Empty,"Empty XML from GetStatisticsXML");
                validator = new DnaXmlValidator(sXML, _schemaUri);
                validator.Validate();
                nav = Statistics.CreateStatisticsDocument(1).CreateNavigator(); // 60 used as default in GetStatisticsXML()
                CommonXpathTests1(nav, 1);
                Assert.AreEqual("00:00", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[1]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");
                Assert.AreEqual("00:01", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[2]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");
                Assert.AreEqual("00:59", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[60]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");
                Assert.AreEqual("01:00", (string)nav.Evaluate("string(/STATISTICS/STATISTICSDATA[61]/@INTERVALSTARTTIME)"), "Wrong RawRequests value");

                Statistics.ResetCounters();
                sXML = Statistics.GetStatisticsXML();
                validator = new DnaXmlValidator(sXML, _schemaUri);
                validator.Validate();

                nav = Statistics.CreateStatisticsDocument(60).CreateNavigator(); // 60 used as default in GetStatisticsXML()
                Assert.AreEqual(24, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/SERVERBUSYCOUNT)"));
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RAWREQUESTS)"), "Wrong RawRequests value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SERVERBUSYCOUNT)"), "Wrong ServerBusy value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/CACHEHITS)"), "Wrong Cachehits value");
                Assert.AreEqual(00, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RSSCACHEHITS)"), "Wrong RSCachehits value");
                Assert.AreEqual(00, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RSSCACHEMISSES)"), "Wrong RSSCacheMisses value");
                Assert.AreEqual(00, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SSICACHEHITS)"), "Wrong SSICacheHits value");
                Assert.AreEqual(00, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SSICACHEMISSES)"), "Wrong SSICACHEMISSES value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/NONSSOREQUESTS)"), "Wrong NonSSORequests value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/HTMLCACHEHITS)"), "Wrong HtmlCacheHits value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/HTMLCACHEMISSES)"), "Wrong HtmlCacheMisses value");
                Assert.AreEqual(000, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/AVERAGEREQUESTTIME)"), "Wrong Averagerequesttime value");
                Assert.AreEqual(000, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/AVERAGEIDENTITYTIME)"), "Wrong Averageidentitytime value");
                Assert.AreEqual(0, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/IDENTITYREQUESTS)"), "Wrong Identityresuests value");
                Assert.AreEqual(00, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/REQUESTS)"), "Wrong requests value");
                Assert.AreEqual(1, 1);
            //}
		}

		private static void CommonXpathTests1(XPathNavigator nav, int interval)
		{
			int datapointcount = (24 * 60) / interval;
			double numresult = (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/RAWREQUESTS)");
			Assert.AreEqual(numresult, datapointcount);
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/SERVERBUSYCOUNT)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/CACHEHITS)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/CACHEMISSES)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/RSSCACHEHITS)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/RSSCACHEMISSES)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/SSICACHEHITS)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/SSICACHEMISSES)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/NONSSOREQUESTS)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/HTMLCACHEHITS)"));
			Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/HTMLCACHEMISSES)"));
            Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/AVERAGEREQUESTTIME)"));
            Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/AVERAGEIDENTITYTIME)"));
            Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/IDENTITYREQUESTS)"));
            Assert.AreEqual(datapointcount, (double)nav.Evaluate("count(/STATISTICS/STATISTICSDATA/REQUESTS)"));

			Assert.AreEqual(2, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RAWREQUESTS)"), "Wrong RawRequests value");
			Assert.AreEqual(22, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SERVERBUSYCOUNT)"), "Wrong ServerBusy value");
			//Assert.AreEqual(5, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/CACHEHITS)"), "Wrong Cachehits value");
			Assert.AreEqual(15, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RSSCACHEHITS)"), "Wrong RSCachehits value");
			Assert.AreEqual(55, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/RSSCACHEMISSES)"), "Wrong RSSCacheMisses value");
			Assert.AreEqual(23, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SSICACHEHITS)"), "Wrong SSICacheHits value");
			Assert.AreEqual(34, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/SSICACHEMISSES)"), "Wrong SSICACHEMISSES value");
			Assert.AreEqual(9, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/NONSSOREQUESTS)"), "Wrong NonSSORequests value");
			Assert.AreEqual(3, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/HTMLCACHEHITS)"), "Wrong HtmlCacheHits value");
			Assert.AreEqual(8, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/HTMLCACHEMISSES)"), "Wrong HtmlCacheMisses value");
            Assert.AreEqual(123, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/AVERAGEREQUESTTIME)"), "Wrong Averagerequesttime value");
            Assert.AreEqual(400, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/AVERAGEIDENTITYTIME)"), "Wrong Averageidentitytime value");
            Assert.AreEqual(11, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/IDENTITYREQUESTS)"), "Wrong Identityrequests value");
            Assert.AreEqual(11, (double)nav.Evaluate("sum(/STATISTICS/STATISTICSDATA/REQUESTS)"), "Wrong requests value");

		}
	}
}
