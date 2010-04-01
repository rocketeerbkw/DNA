using System;
using System.Collections.Generic;
using System.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace BBC.Dna.LoadTest
{
    /// <summary>
    /// Summary description for LoadTests
    /// </summary>
    [TestClass]
    public class LoadTests
    {
        private readonly string _server;
        private readonly string _serverName;
        private double _tolerance;
        public LoadTests()
        {
            _server = ConfigurationManager.AppSettings["BBC.Dna.LoadTest.LoadTestServer"];
            _serverName = ConfigurationManager.AppSettings["BBC.Dna.LoadTest.loadTestServerName"];
            int toleranceInt;
            if (!Int32.TryParse(ConfigurationManager.AppSettings["BBC.Dna.LoadTest.TolerancePercentage"], out toleranceInt))
            {
                _tolerance = 1;
            }
            else
            {
                _tolerance = 1 + ((double)toleranceInt / 100);    
            }
            
        }

        [TestMethod]
        public void CommentBox_readwrite()
        {

            var testHandler = new StressTestHandler("commentbox_readwrite", _server, _serverName, _tolerance);
            var uid = "CommentBox_readwrite_loadtest";
            var replace = new Dictionary<string, string> {{"UID", uid}};

            testHandler.InitialiseServer();
            testHandler.MakeReplacements(replace);
            var request = new DnaTestURLRequest("h2g2");
            request.RequestPageWithFullURL(string.Format("http://{0}/dna/h2g2/comments/acswithoutapi?dnauid={1}&dnainitialtitle=TestingCommentBox&dnahostpageurl=http://local.bbc.co.uk/dna/haveyoursay/acs&dnaforumduration=0&skin=purexml", _server, uid));
            testHandler.RunTest();

            Assert.IsFalse(testHandler.DoesRunContainHttpErrors());
            testHandler.CompareResults();
        }

        [TestMethod]
        public void Commentboxusingapi_Readwrite()
        {

            var testHandler = new StressTestHandler("commentboxusingapi_readwrite", _server, _serverName, _tolerance);
            var uid = "commentboxusingapi_readwrite_loadtest";
            var replace = new Dictionary<string, string> { { "UID", uid } };

            testHandler.InitialiseServer();
            testHandler.MakeReplacements(replace);
            var request = new DnaTestURLRequest("h2g2");
            request.RequestPageWithFullURL(string.Format("http://{0}/dna/h2g2/comments/acsapi?dnauid={1}&dnainitialtitle=TestingCommentBox&dnahostpageurl=http://local.bbc.co.uk/dna/haveyoursay/acs&dnaforumduration=0&skin=purexml", _server, uid));
            testHandler.RunTest();

            Assert.IsFalse(testHandler.DoesRunContainHttpErrors());
            testHandler.CompareResults();
        }
    }
}