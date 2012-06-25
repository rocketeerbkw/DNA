using System;
using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace FunctionalTests.Services.Comments.contactFormTests.createContactFormTests
{
    /// <summary>
    /// Summary description for createNewContatcForm
    /// </summary>
    [TestClass]
    public class createNewContactForm
    {
        public createNewContactForm()
        {
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion
 
        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowUnknownSiteExceptionWhenGivenInvalidSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "notavalidsitename", "{}", DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.UnknownSite);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidContactEmailExceptionWhenGivenNoPostData()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", "{}", DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidContactEmail);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidContactEmailExceptionWhenGivenNoContactEmail()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddLastJSONData("id", "newcontactform");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidContactEmail);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidContactEmailExceptionWhenGivenInvalidContactEmail()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormUtils.AddJSONData("id", "newcontactform");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "NotAValidEmailAddress.com");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidContactEmail);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowNotAuthorizedExceptionWhenCreatingAsNormalUser()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormUtils.AddJSONData("id", "newcontactform");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.NORMALUSER);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.NotAuthorized);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidForumUidExceptionWhenGivenNoFormID()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumUid);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidForumParentUriExceptionWhenNoParentURIGiven()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("id", "newcontactform");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumParentUri);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidForumParentUriExceptionWhenGivenAnInvalidParentURI()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("id", "newcontactform");
            postData += ContactFormUtils.AddJSONData("title", "testcontactform");
            postData += ContactFormUtils.AddJSONData("parentUri", "http://local.dodgy.com/dna/h2g2");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumParentUri);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidForumTitleExceptionWhenNoTitleGiven()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("parentUri", "http://local.bbc.co.uk/dna/h2g2");
            postData += ContactFormUtils.AddJSONData("id", "newcontactform");
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");

            try
            {
                ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.InvalidForumTitle);
                throw ex;
            }
        }

        [TestMethod]
        public void ShouldCreateContactFormWhenGivenValidPostData()
        {
            string title = "testcontactform";
            string parentUri = "http://local.bbc.co.uk/dna/h2g2";
            string id = "newcontactform" + DateTime.Now.Ticks.ToString();
            string contactEmail = "tester@bbc.co.uk";
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("id", id);
            postData += ContactFormUtils.AddJSONData("parentUri", parentUri);
            postData += ContactFormUtils.AddJSONData("title", title);
            postData += ContactFormUtils.AddLastJSONData("contactemail", contactEmail);

            ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            CommentForum newContactForm = (CommentForum)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentForum));
            Assert.AreEqual(title, newContactForm.Title);
            Assert.AreEqual(parentUri, newContactForm.ParentUri);
            Assert.IsTrue(newContactForm.isContactForm);
            Assert.AreEqual(id, newContactForm.Id);
        }
    }
}
