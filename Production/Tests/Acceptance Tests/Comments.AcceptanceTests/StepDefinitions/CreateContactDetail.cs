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
        [Then(@"I get a Forum Unknown Exception")]
        public void ThenIGetAForumUnknownException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.ForumUnknown);
        }

        [When(@"I post a Contact Detail with no Form ID")]
        public void WhenIPostAContactDetailWithNoFormID()
        {
            try
            {
                ContactFormTestUtils.CallCreateContactDetailAPIRequest(request, "h2g2", "notavalidcontactformID", "", callingUserType);
            }
            catch { }
        }

        [When(@"I post a Contact Detail with invalid site name")]
        public void WhenIPostAContactDetailWithInvalidSiteName()
        {
            try
            {
                ContactFormTestUtils.CallCreateContactDetailAPIRequest(request, "notavalidsitename", "", "", callingUserType);
            }
            catch { }
        }

        [Given(@"I am not logged in")]
        public void GivenIAmNotLoggedIn()
        {
            callingUserType = DnaTestURLRequest.usertype.NOTLOGGEDIN;
        }

        [Then(@"I should get a Missing User Credentials Exception")]
        public void ThenIShouldGetAMissingUserCredentialsException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.MissingUserCredentials);
        }

        [When(@"I post a Contact Detail with valid data")]
        public void WhenIPostAContactDetailWithValidData()
        {
            string text = "Tester telephone +44 7787 123321";
            string contactFormID = CreateNewContactForm();
            string postData = ContactFormTestUtils.AddFirstJSONData("text", text) + "}";
            try
            {
                ContactFormTestUtils.CallCreateContactDetailAPIRequest(request, "h2g2", contactFormID, postData, callingUserType);
            }
            catch { }
        }

        [Then(@"I should get an Empty Text Exception")]
        public void ThenIShouldGetAnEmptyTextException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.EmptyText);
        }

        [When(@"I post a Contact Detail with no text")]
        public void WhenIPostAContactDetailWithNoText()
        {
            string contactFormID = CreateNewContactForm();
            try
            {
                ContactFormTestUtils.CallCreateContactDetailAPIRequest(request, "h2g2", contactFormID, "", callingUserType);
            }
            catch { }
        }

        private string CreateNewContactForm()
        {
            string title = "testcontactform";
            string parentUri = "http://local.bbc.co.uk/dna/h2g2";
            string id = "newcontactform" + DateTime.Now.Ticks.ToString();
            string contactEmail = "tester@bbc.co.uk";
            string postData = ContactFormTestUtils.AddFirstJSONData("id", id);
            postData += ContactFormTestUtils.AddJSONData("parentUri", parentUri);
            postData += ContactFormTestUtils.AddJSONData("title", title);
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", contactEmail);
            DnaTestURLRequest newContactFormRequest = new DnaTestURLRequest("");
            ContactFormTestUtils.CallCreateContactFormAPIRequest(newContactFormRequest, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            return id;
        }
    }
}
