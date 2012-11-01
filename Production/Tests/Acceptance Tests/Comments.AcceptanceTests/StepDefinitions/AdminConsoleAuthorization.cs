using TechTalk.SpecFlow;
using Comments.AcceptanceTests.Support;
using BBC.Dna.Api;
using Tests;
using System;
using System.Net;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Comments.AcceptanceTests.StepDefinitions
{
    public partial class StepDefinitions
    {
        [When(@"I visit the admin console as an editor")]
        public void WhenIVisitTheAdminConsoleAsAnEditor()
        {
            string requestURL = "http://" + DnaTestURLRequest.CurrentServer + "/dna/moderation/admin/twitterprofilelist?skin=purexml";
            try
            {
                request.SetCurrentUserEditor();
                request.RequestPageWithFullURL(requestURL, string.Empty, "text/xml");
            }
            catch{ }
        }

        [Then(@"I can see the Buzz Profile list page")]
        public void ThenICanSeeTheBuzzProfileListPage()
        {
            var responseXml = request.GetLastResponseAsXML();
            var twitterProfileListXml = responseXml.SelectSingleNode("//H2G2/TWITTERPROFILELIST");
            Assert.IsNotNull(twitterProfileListXml);
            Assert.AreNotEqual("0", twitterProfileListXml.Attributes["COUNT"].Value);
        }


        [When(@"I visit the admin console as a normal user")]
        public void WhenIVisitTheAdminConsoleAsANormalUser()
        {
            string requestURL = "http://" + DnaTestURLRequest.CurrentServer + "/dna/moderation/admin/twitterprofilelist?skin=purexml";
            try
            {
                request.SetCurrentUserNormal();
                request.RequestPageWithFullURL(requestURL, string.Empty, "text/xml");
            }
            catch { }
        }

        [Then(@"I should see an appropriate error message")]
        public void ThenIShouldSeeAnAppropriateErrorMessage()
        {
            var responseXml = request.GetLastResponseAsXML();
            var errorXml = responseXml.SelectSingleNode("//H2G2/ERROR");
            Assert.IsNotNull(errorXml);
            Assert.AreEqual("Authorization", errorXml.Attributes["TYPE"].Value);
        }
    }
}
