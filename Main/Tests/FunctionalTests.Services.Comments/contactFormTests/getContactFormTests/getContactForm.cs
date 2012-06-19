using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace FunctionalTests.Services.Comments.contactFormTests.getContactFormTests
{
    /// <summary>
    /// Summary description for getContactForm
    /// </summary>
    [TestClass]
    public class getContactForm
    {
        public getContactForm()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;
        private string title = "testcontactform";
        private string id = "newcontactform" + DateTime.Now.Ticks.ToString();
        private string parentUri = "http://local.bbc.co.uk/dna/h2g2";
        private string sitename = "h2g2";

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

        private string CreateNewContactFormAndCreateContactDetails(string textForContactDetails)
        {
            DnaTestURLRequest request = new DnaTestURLRequest("");
            string postData = ContactFormUtils.AddFirstJSONData("id", id);
            postData += ContactFormUtils.AddJSONData("parentUri", parentUri);
            postData += ContactFormUtils.AddJSONData("title", title);
            postData += ContactFormUtils.AddLastJSONData("contactemail", "tester@bbc.co.uk");
            ContactFormUtils.CallCreateContactFormAPIRequest(request, sitename, postData, DnaTestURLRequest.usertype.EDITOR);

            postData = ContactFormUtils.AddFirstJSONData("text", textForContactDetails) + "}";
            ContactFormUtils.CallCreateContactDetailAPIRequest(request, sitename, id, postData, DnaTestURLRequest.usertype.NORMALUSER);
            return id;
        }

        [TestMethod]
        public void GivenValidContactFormWhenCallingTheCommentsForumsAPIShouldNotShowContactDetails()
        {
            string contactFormID = CreateNewContactFormAndCreateContactDetails("Tester telephone +44 7787 123321");

            DnaTestURLRequest request = new DnaTestURLRequest("");
            ContactFormUtils.CallGetCommentsForCommentForum(request, sitename, contactFormID);
            string response = request.GetLastResponseAsString();
            ContactFormUtils.AssertOutputContains(response, "\"text\":\"Contact Form Post\"");
            ContactFormUtils.AssertOutputContains(response, "\"title\":\"" + title + "\"");
            ContactFormUtils.AssertOutputContains(response, "\"parentUri\":\"" + parentUri.Replace("/", "\\/") + "\"");
            ContactFormUtils.AssertOutputContains(response, "\"id\":\"" + id + "\"");
            ContactFormUtils.AssertOutputContains(response, "\"isContactForm\":true");
        }

        //[TestMethod]
        //public void GivenValidContactFormWhenCallingTheCommentForumListPageWithNoFlagsSetShouldNotShowContactDetails()
        //{
        //    string text = "Tester telephone +44 7787 123321";
        //    string contactFormID = CreateNewContactFormAndCreateContactDetails(text);

        //    DnaTestURLRequest request = new DnaTestURLRequest("");
        //    ContactFormUtils.CallCommentForumList(request, sitename, contactFormID, "");
        //    string response = request.GetLastResponseAsString();
        //    ContactFormUtils.AssertOutputContains(response, "\"text\":\"Contact Form Post\"");
        //}
    }
}
