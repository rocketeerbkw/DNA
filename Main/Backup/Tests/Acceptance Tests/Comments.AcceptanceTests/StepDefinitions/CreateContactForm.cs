using System;
using System.Net;
using BBC.Dna.Api;
using Comments.AcceptanceTests.Support;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TechTalk.SpecFlow;
using Tests;

namespace Comments.AcceptanceTests.StepDefinitions
{
    public partial class StepDefinitions
    {
        [Given(@"I am logged in as an editor")]
        public void GivenIAmLoggedInAsAnEditor()
        {
            callingUserType = DnaTestURLRequest.usertype.EDITOR;
        }

        [Given(@"I am logged in as a normal user")]
        public void GivenIAmLoggedInAsANormalUser()
        {
            callingUserType = DnaTestURLRequest.usertype.NORMALUSER;
        }

        [Then(@"I get a 201 Response code")]
        public void ThenIGetA201ResponseCode()
        {
            Assert.AreEqual(HttpStatusCode.Created, request.CurrentWebResponse.StatusCode);
        }

        [When(@"I call the Create Contact Form API with valid data")]
        public void WhenICallTheCreateContactFormAPIWithValidData()
        {
            string title = "testcontactform";
            string parentUri = "http://local.bbc.co.uk/dna/h2g2";
            string id = "newcontactform" + DateTime.Now.Ticks.ToString();
            string contactEmail = "tester@bbc.co.uk";
            string postData = ContactFormTestUtils.AddFirstJSONData("id", id);
            postData += ContactFormTestUtils.AddJSONData("parentUri", parentUri);
            postData += ContactFormTestUtils.AddJSONData("title", title);
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", contactEmail);
            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [Then(@"I get an Unknown Site Exception")]
        public void ThenIGetAnUnknownSiteException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.UnknownSite);
        }

        [When(@"I call the Create Contact Form API with an invalid site")]
        public void WhenICanTheCreateContactFormAPIWithInvalidSite()
        {
            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "notavalidsitename", "", callingUserType);
            }
            catch { }
        }

        [Then(@"I get an Invalid Contact Email Exception")]
        public void ThenIGetAnInvalidContactEmailException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidContactEmail);
        }

        [When(@"I call the Create Contact Form API with no contact email")]
        public void WhenICallTheCreateContactFormAPIWithNoContactEmail()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormTestUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormTestUtils.AddLastJSONData("id", "newcontactform");

            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [When(@"I call the Create Contact Form API with no form data")]
        public void WhenICallTheCreateContactFormAPIWithNoFormData()
        {
            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", "", callingUserType);
            }
            catch { }
        }

        [When(@"I call the Create Contact Form API with an invalid contact email")]
        public void WhenICallTheCreateContactFormAPIWithAnInvalidContactEmail()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormTestUtils.AddJSONData("id", "newcontactform");
            postData += ContactFormTestUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", "NotAValidEmailAddress.com");

            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [Then(@"I get an Invalid Forum Title Exception")]
        public void ThenIGetAnInvalidForumTitleException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumUid);
        }

        [When(@"I call the Create Contact Form API with no title")]
        public void WhenICallTheCreateContactFormAPIWithNoTitle()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormTestUtils.AddJSONData("id", "newcontactform");
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [Then(@"I get an Not Authorised Exception")]
        public void ThenIGetAnNotAuthorisedException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.NotAuthorized);
        }

        [Then(@"I get an Invalid Forum Parent URI Exception")]
        public void ThenIGetAnInvalidForumParentURIException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumParentUri);
        }

        [When(@"I call the Create Contact Form API with invalid parent uri")]
        public void WhenICallTheCreateContactFormAPIWithInvalidParentUri()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("id", "newcontactform");
            postData += ContactFormTestUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormTestUtils.AddJSONData("parentUri", "http://local.dodgy.com/dna/h2g2");
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");
            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [When(@"I call the Create Contact Form API with no parent uri")]
        public void WhenICallTheCreateContactFormAPIWithNoParentUri()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("id", "newcontactform");
            postData += ContactFormTestUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");
            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }

        [Then(@"I get an Invalid Forum UID Exception")]
        public void ThenIGetAnInvalidForumUIDException()
        {
            ContactFormTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumUid);
        }

        [When(@"I call the Create Contact Form API with no forum UID")]
        public void WhenICallTheCreateContactFormAPIWithNoForumUID()
        {
            string postData = ContactFormTestUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormTestUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormTestUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, callingUserType);
            }
            catch { }
        }
    }
}