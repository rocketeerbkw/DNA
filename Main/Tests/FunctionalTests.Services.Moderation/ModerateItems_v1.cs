using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Net;
using Tests;



namespace FunctionalTests.Services.Moderation
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ModerateItems_V1
    {
        private static string _hostAndPort = DnaTestURLRequest.CurrentServer.Host + ":" + DnaTestURLRequest.CurrentServer.Port;
        private static string _server = _hostAndPort;
        private string _siteName = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {

        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {

        }

        /// <summary>
        /// Adds item sto the mod queue via the moderation API
        /// </summary>
        /// <returns></returns>
        [TestMethod]
        public void AddComplaintItemToModQueue()
        {

            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();

            string uri = "http://www.bbc.co.uk/dna/h2g2/";
            string callback = "http://www.bbc.co.uk/dna/h2g2";
            string complaintText = "This is a test complaint";

            string moderationItemXml = String.Format("<item xmlns=\"BBC.Dna.Moderation\">" +
                "<uri>{0}</uri>" +
                "<callbackuri>{1}</callbackuri>" +
                "<complainttext>{2}</complainttext>" +
                "</item>", uri, callback, complaintText);

            // Setup the request url
            string url = String.Format("http://" + _server + "/dna/api/moderation/ModerationService.svc/V1/site/{0}/items/", _siteName);

            // Make a POST Request with the data
            request.RequestPageWithFullURL(url, moderationItemXml, "text/xml");
            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);
        }
    }
}