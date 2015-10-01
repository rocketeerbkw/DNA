using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using Tests;

namespace FunctionalTests.Services.Moderation
{
    [TestClass]
    public class ModerationServiceTests
    {
        [TestMethod]
        public void Given_IAmAnEditor_WhenICreateAModerationItem_ThenIGetACreatedResponseCode()
        {
            const int expected = 200;

            var uri = DnaTestURLRequest.CurrentServer + "dna/api/moderation/ModerationService.svc/V1/site/h2g2/items/?d_identityuserid=dotneteditor";

            var moderationItem = new ModerationItem
            {
                CallBackUri = "http://whocares.com",
                Uri = "http://whocares.com/image.png",
                Notes = "This is great",
            };

            var client = new HttpClient();

            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var serialisedModerationItem = JsonConvert.SerializeObject(moderationItem);

            var content = new StringContent(serialisedModerationItem, Encoding.UTF8, "application/json" /*Content-Type*/);

            var response = client.PostAsync(uri, content).Result;

            var actual = (int)response.StatusCode;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void Given_IAmAnEditor_WhenICreateAModerationItem_ThenIGetAnEmptyResponse()
        {
            const string expected = "";

            var uri = DnaTestURLRequest.CurrentServer + "dna/api/moderation/ModerationService.svc/V1/site/h2g2/items/?d_identityuserid=dotneteditor";

            var moderationItem = new ModerationItem
            {
                CallBackUri = "http://whocares.com",
                Uri = "http://whocares.com/image.png",
                Notes = "This is great",
            };

            var client = new HttpClient();

            var serialisedModerationItem = JsonConvert.SerializeObject(moderationItem);

            var content = new StringContent(serialisedModerationItem, Encoding.UTF8, "application/json" /*Content-Type*/);

            var response = client.PostAsync(uri, content).Result;

            var actual = response.Content.ReadAsStringAsync().Result;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void Given_IAmAnEditor_WhenICreateAModerationItem_AndISpecifyTheUserIdentityKey_ThenIGetACreatedResponseCode()
        {
            const int expected = 200;

            var uri = DnaTestURLRequest.CurrentServer + "dna/api/moderation/ModerationService.svc/V1/site/h2g2/items/?d_identityuserid=dotneteditor";

            var moderationItem = new ModerationItem
            {
                CallBackUri = "http://whocares.com",
                Uri = "http://whocares.com/image.png",
                Notes = "This is great",
                BBCUserIdentity = "238011998234330627"
            };

            var client = new HttpClient();

            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            var serialisedModerationItem = JsonConvert.SerializeObject(moderationItem);

            var content = new StringContent(serialisedModerationItem, Encoding.UTF8, "application/json" /*Content-Type*/);

            var response = client.PostAsync(uri, content).Result;

            var actual = (int)response.StatusCode;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        public void Given_IAmAnEditor_WhenICreateAModerationItem_AndISpecifyTheUserIdentityKey_ThenIGetAnEmptyResponse()
        {
            const string expected = "";

            var uri = DnaTestURLRequest.CurrentServer + "dna/api/moderation/ModerationService.svc/V1/site/h2g2/items/?d_identityuserid=dotneteditor";

            var moderationItem = new ModerationItem
            {
                CallBackUri = "http://whocares.com",
                Uri = "http://whocares.com/image.png",
                Notes = "This is great",
                BBCUserIdentity = "238011998234330627"
            };

            var client = new HttpClient();

            var serialisedModerationItem = JsonConvert.SerializeObject(moderationItem);

            var content = new StringContent(serialisedModerationItem, Encoding.UTF8, "application/json" /*Content-Type*/);

            var response = client.PostAsync(uri, content).Result;

            var actual = response.Content.ReadAsStringAsync().Result;

            Assert.AreEqual(expected, actual);
        }
    }
}