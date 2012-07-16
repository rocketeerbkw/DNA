using System;
using System.Net;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace FunctionalTests.Services.Comments.contactFormTests.createNewContactDetailsTests
{
    /// <summary>
    /// Summary description for createNewContactDetailInForm
    /// </summary>
    [TestClass]
    public class createNewContactDetailInForm
    {
        public createNewContactDetailInForm()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;
        private string title = "testcontactform";
        private string id = "newcontactform" + DateTime.Now.Ticks.ToString();
        private string parentUri = "http://local.bbc.co.uk/dna/h2g2";

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

        private string CreateNewContactForm()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("id", id);
            postData += ContactFormUtils.AddJSONData("parentUri", parentUri);
            postData += ContactFormUtils.AddJSONData("title", title);
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");
            ContactFormUtils.CallCreateContactFormAPIRequest(request, "h2g2", postData, DnaTestURLRequest.usertype.EDITOR);
            return id;
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowInvalidSiteExceptionWhenGivenInvalidSiteName()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactDetailAPIRequest(request, "notavalidsitename", "testcontactform", "{}", DnaTestURLRequest.usertype.NORMALUSER);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.UnknownSite);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowForumUnknownExceptionWhenGivenInvalidContactFormID()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactDetailAPIRequest(request, "h2g2", "notavalidcontactformID", "{}", DnaTestURLRequest.usertype.NORMALUSER);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.ForumUnknown);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowMissingUserCredentialsExceptionWhenUserNotLoggedIn()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactDetailAPIRequest(request, "h2g2", "testcontactform", "{}", DnaTestURLRequest.usertype.NOTLOGGEDIN);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.MissingUserCredentials);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(WebException), "The remote server returned an error: (400) Bad Request.")]
        public void ShouldThrowEmptyTextExceptionWhenGivenNoText()
        {
            string contactFormID = CreateNewContactForm();

            DnaTestURLRequest request = new DnaTestURLRequest("");
            try
            {
                ContactFormUtils.CallCreateContactDetailAPIRequest(request, "h2g2", contactFormID, "{}", DnaTestURLRequest.usertype.NORMALUSER);
            }
            catch (WebException ex)
            {
                ContactFormUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.EmptyText);
                throw ex;
            }
        }

        [TestMethod]
        public void ShouldCreateContactDetailWhenGivenValidInputData()
        {
            string text = "Tester telephone +44 7787 123321";
            string contactFormID = CreateNewContactForm();
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("text", text) + "}";
            string url = ContactFormUtils.CallCreateContactDetailAPIRequest(request, "h2g2", contactFormID, postData, DnaTestURLRequest.usertype.NORMALUSER);
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);
            CommentInfo newContactinfo = (CommentInfo)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(CommentInfo));
            Assert.AreEqual(text, newContactinfo.text);
            //Assert.AreEqual(url.Replace(":8081", ""), newContactinfo.ForumUri);
        }
    }
}
