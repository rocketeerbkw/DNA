using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;

namespace BBC.Dna.Api.Tests
{
    /// <summary>
    /// Summary description for ContactTests
    /// </summary>
    [TestClass]
    public class ContactTests
    {
        public ContactTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;
        private MockRepository mocks = new MockRepository();

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
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void ShouldSendEmailWhenGivenValidContactDetails()
        {
            string siteContactEmail = "mark.howitt@bbc.co.uk";
            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite("h2g2").ContactFormsEmail).Return(siteContactEmail);

            mocks.ReplayAll();

            Contacts contacts = new Contacts(null, null, null, siteList);
            contacts.EmailServerAddress = "";
            contacts.FileCacheFolder = TestContext.TestDir;
            ContactDetails info = new ContactDetails();
            info.ForumUri = "http://local.bbc.co.uk/dna/api/contactformservice.svc/";
            info.text = "This is a test email";

            string failedEmailFileName = "ContactDetails-ShouldSendEmailWhenGivenValidContactDetails-TestFailedEmail.txt";
            contacts.SetFailedEmailFileName(failedEmailFileName);

            // NOTE! Slight lie about sending the mail, it actually fails on sending and saves the email in the FailedEmails folder for the purpose of this test
            contacts.SendDetailstoContactEmail(info, "");

            Statistics stats = new Statistics();
            Statistics.InitialiseIfEmpty();

            DateTime expires = new DateTime();
            string failedEmailContent = "";
            FileCaching.GetItem(null, TestContext.TestDir, "failedmails", failedEmailFileName, ref expires, ref failedEmailContent);

            string expectedInfo = "From: " + siteContactEmail + "\r\nRecipient: \r\n" + info.ForumUri + "\r\n" + info.text;
            Assert.AreEqual(expectedInfo, failedEmailContent);
        }

        [TestMethod]
        public void ShouldDeserialiseToContactFormMessageString()
        {
            ContactForm contactForm = new ContactForm();
            contactForm.Id = "FirstContactForm_111";
            contactForm.ParentUri = "http://local.bbc.co.uk/dna/h2g2";
            contactForm.Title = "FirstContactForm+1";
            contactForm.contactDetailsList = new ContactDetailsList();
            contactForm.contactDetailsList.contacts = new List<ContactDetails>();
            ContactDetails contactDetail = new ContactDetails();
            contactForm.contactDetailsList.contacts.Add(contactDetail);
            
            ContactFormMessage msg = new ContactFormMessage();
            msg.Subject = "testing Subject";
            msg.Body = new Dictionary<string, string>();
            msg.Body.Add("Your Email","myemail@bbc.co.uk");
            msg.Body.Add("Your Suggestions","Improve the contact form");
            msg.Body.Add("Your Favourite Social Network","facebook");
            msg.Body.Add("Favourite BBC site","sport");
            msg.Body.Add("Gender","m");

            contactDetail.text = StringUtils.SerializeToJsonReturnAsString(msg);

            string stringContactForm = StringUtils.SerializeToJsonReturnAsString(contactForm);

            string body = "";
            ContactFormMessage message = (ContactFormMessage)StringUtils.DeserializeJSONObject(contactDetail.text, typeof(ContactFormMessage));
            string subject = message.Subject;

            foreach (KeyValuePair<string, string> content in message.Body.ToList<KeyValuePair<string, string>>())
            {
                string messageLine = content.Key + " : " + content.Value + "\n";
                body += messageLine;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowUnknownSiteExceptionWhenCreatingANewFormGivenANullSite()
        {
            Contacts contacts = new Contacts(null, null, null, null);
            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(null, null);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.UnknownSite).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowNotAuthorizedExceptionWhenCreatingANullCallingUser()
        {
            string sitename = "h2g2";
            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.SiteName).Return(sitename);

            ContactForm form = new ContactForm() { Id = "doesnotexist", SiteName = sitename };
            IDnaDataReader mockedDataReader = MockedGetContactFormDetailFromFormID(form, false);
            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, null);

            mocks.ReplayAll();

            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(form, mockedSite);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.NotAuthorized).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowNotAuthorizedExceptionWhenCreatingANewFormGivenANormalCallingUser()
        {
            string sitename = "h2g2";
            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.SiteName).Return(sitename);

            ContactForm form = new ContactForm() { Id = "doesnotexist", SiteName = sitename };
            IDnaDataReader mockedDataReader = MockedGetContactFormDetailFromFormID(form, false);
            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, null);
            ICallingUser mockedUser = mocks.StrictMock<ICallingUser>();
            mockedUser.Stub(x => x.IsUserA(UserTypes.Editor)).Return(false);
            contacts.CallingUser = mockedUser;

            mocks.ReplayAll();

            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(form, mockedSite);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.NotAuthorized).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowInvalidContactEmailExceptionWhenCreatingANewFormGivenNoContactFormDetails()
        {
            string sitename = "h2g2";
            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.SiteName).Return(sitename);

            Contacts contacts = new Contacts(null, null, null, null);

            mocks.ReplayAll();

            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(null, mockedSite);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.InvalidContactEmail).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowMissingContactEmailExceptionWhenCreatingANewFormGivenNoContactEmail()
        {
            string sitename = "h2g2";
            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.SiteName).Return(sitename);

            ContactForm form = new ContactForm() { Id = "doesnotexist", SiteName = sitename };
            IDnaDataReader mockedDataReader = MockedGetContactFormDetailFromFormID(form, false);
            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, null);

            mockedSite.Stub(x => x.ContactFormsEmail).Return("");

            ICallingUser mockedUser = mocks.StrictMock<ICallingUser>();
            mockedUser.Stub(x => x.IsUserA(UserTypes.Editor)).Return(true);
            contacts.CallingUser = mockedUser;

            mocks.ReplayAll();

            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(form, mockedSite);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.MissingContactEmail).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        [ExpectedException(typeof(ApiException))]
        public void ShouldThrowInvalidContactEmailExceptionWhenCreatingANewFormGivenAnInvalidContactEmailAddress()
        {
            string sitename = "h2g2";
            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.SiteName).Return(sitename);

            ContactForm form = new ContactForm() { Id = "doesnotexist", SiteName = sitename, ContactEmail = "invalid.email@crapemailaddress" };
            IDnaDataReader mockedDataReader = MockedGetContactFormDetailFromFormID(form, false);
            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, null);

            ICallingUser mockedUser = mocks.StrictMock<ICallingUser>();
            mockedUser.Stub(x => x.IsUserA(UserTypes.Editor)).Return(true);
            contacts.CallingUser = mockedUser;

            mocks.ReplayAll();

            try
            {
                ContactForm createdContactForm = contacts.CreateContactForm(form, mockedSite);
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ApiException.GetError(ErrorType.InvalidContactEmail).Message, ex.Message);
                throw ex;
            }
        }

        [TestMethod]
        public void ShouldReturnExistingContactFormWhenGivenExistingContactformDetails()
        {
            string expectedTitle = "testcontactform";
            string expectedParentUri = "http://local.bbc.co.uk/dna/h2g2";
            string expectedId = "newcontactform" + DateTime.Now.Ticks.ToString();
            string expectedContactEmail = "tester@bbc.co.uk";
            string expectedSiteName = "h2g2";
            int expectedForumId = 789123456;
            ModerationStatus.ForumStatus expectedModerationStatus = ModerationStatus.ForumStatus.Reactive;

            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.EditorsEmail).Return("dna@bbc.co.uk");
            mockedSite.Stub(x => x.SiteName).Return(expectedSiteName);

            ISiteList mockedSiteList = mocks.DynamicMock<ISiteList>();
            mockedSiteList.Stub(x => x.GetSite(expectedSiteName)).Return(mockedSite);

            ContactForm existingContactFormDetails = new ContactForm();
            existingContactFormDetails.ContactEmail = expectedContactEmail;
            existingContactFormDetails.Title = expectedTitle;
            existingContactFormDetails.ParentUri = expectedParentUri;
            existingContactFormDetails.Id = expectedId;
            existingContactFormDetails.ModerationServiceGroup = expectedModerationStatus;
            existingContactFormDetails.SiteName = expectedSiteName;
            existingContactFormDetails.ForumID = expectedForumId;

            IDnaDataReader mockedDataReader1 = MockedGetContactFormDetailFromFormID(existingContactFormDetails, true);
            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();

            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader1);
            ICallingUser mockedUser = mocks.StrictMock<ICallingUser>();
            mockedUser.Stub(x => x.IsUserA(UserTypes.Editor)).Return(true);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, mockedSiteList);
            contacts.CallingUser = mockedUser;

            mocks.ReplayAll();

            ContactForm createdContactForm = contacts.CreateContactForm(existingContactFormDetails, mockedSiteList.GetSite("h2g2"));

            Assert.AreEqual(expectedContactEmail, createdContactForm.ContactEmail);
            Assert.AreEqual(expectedForumId, createdContactForm.ForumID);
            Assert.AreEqual(expectedId, createdContactForm.Id);
            Assert.AreEqual(expectedParentUri, createdContactForm.ParentUri);
            Assert.AreEqual(expectedTitle, createdContactForm.Title);
            Assert.AreEqual(expectedSiteName, createdContactForm.SiteName);

            mocks.VerifyAll();
        }

        [TestMethod]
        public void ShouldCreateNewContactFormWhenGivenValidContactFormDetails()
        {
            string expectedTitle = "testcontactform";
            string expectedParentUri = "http://local.bbc.co.uk/dna/h2g2";
            string expectedId = "newcontactform" + DateTime.Now.Ticks.ToString();
            string expectedContactEmail = "tester@bbc.co.uk";
            string expectedSiteName = "h2g2";
            ModerationStatus.ForumStatus expectedModerationStatus = ModerationStatus.ForumStatus.Reactive;

            ISite mockedSite = mocks.StrictMock<ISite>();
            mockedSite.Stub(x => x.EditorsEmail).Return("dna@bbc.co.uk");
            mockedSite.Stub(x => x.SiteName).Return(expectedSiteName);

            ISiteList mockedSiteList = mocks.DynamicMock<ISiteList>();
            mockedSiteList.Stub(x => x.GetSite(expectedSiteName)).Return(mockedSite);

            ContactForm newContactFormDetails = new ContactForm();
            newContactFormDetails.ContactEmail = expectedContactEmail;
            newContactFormDetails.Title = expectedTitle;
            newContactFormDetails.ParentUri = expectedParentUri;
            newContactFormDetails.Id = expectedId;
            newContactFormDetails.ModerationServiceGroup = expectedModerationStatus;
            newContactFormDetails.SiteName = expectedSiteName;

            IDnaDataReader mockedDataReader1 = MockedGetContactFormDetailFromFormID(newContactFormDetails, false);

            int expectedForumId = 789654123; 
            IDnaDataReader mockedDataReader2 = MockedCreateCommentForum(newContactFormDetails, expectedForumId);

            newContactFormDetails.ForumID = expectedForumId; 
            IDnaDataReader mockedDataReader3 =  MockedSetCommentForumAsContactForm(newContactFormDetails);

            IDnaDataReader mockedDataReader4 = MockedGetContactFormDetailFromFormID(newContactFormDetails, true);

            Queue<IDnaDataReader> mockedReaders = new Queue<IDnaDataReader>();
            mockedReaders.Enqueue(mockedDataReader1);
            mockedReaders.Enqueue(mockedDataReader4);

            IDnaDataReaderCreator mockerDataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader1);
            mockerDataReaderCreator.Expect(x => x.CreateDnaDataReader("getcontactformdetailfromformid")).Return(mockedDataReader4);
            mockerDataReaderCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(mockedDataReader2);
            mockerDataReaderCreator.Stub(x => x.CreateDnaDataReader("setcommentforumascontactform")).Return(mockedDataReader3);

            ICallingUser mockedUser = mocks.StrictMock<ICallingUser>();
            mockedUser.Stub(x => x.IsUserA(UserTypes.Editor)).Return(true);

            Contacts contacts = new Contacts(null, mockerDataReaderCreator, null, mockedSiteList);
            contacts.CallingUser = mockedUser;

            mocks.ReplayAll();

            ContactForm createdContactForm = contacts.CreateContactForm(newContactFormDetails, mockedSiteList.GetSite("h2g2"));

            Assert.AreEqual(expectedContactEmail, createdContactForm.ContactEmail);
            Assert.AreEqual(expectedForumId, createdContactForm.ForumID);
            Assert.AreEqual(expectedId, createdContactForm.Id);
            Assert.AreEqual(expectedParentUri, createdContactForm.ParentUri);
            Assert.AreEqual(expectedTitle, createdContactForm.Title);
            Assert.AreEqual(expectedSiteName, createdContactForm.SiteName);

            mocks.VerifyAll();
        }

        private IDnaDataReader MockedGetContactFormDetailFromFormID(ContactForm newContactFormDetails, bool exists)
        {
            IDnaDataReader mockedDataReader = mocks.StrictMock<IDnaDataReader>();

            mockedDataReader.Stub(x => x.AddParameter("contactformid", newContactFormDetails.Id)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("sitename", newContactFormDetails.SiteName)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.Execute()).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.HasRows).Return(exists);

            if (exists)
            {
                mockedDataReader.Stub(x => x.Read()).Return(true);
                mockedDataReader.Stub(x => x.GetString("contactemail")).Return(newContactFormDetails.ContactEmail);
                mockedDataReader.Stub(x => x.GetInt32("forumid")).Return(newContactFormDetails.ForumID);
                mockedDataReader.Stub(x => x.GetString("contactformuid")).Return(newContactFormDetails.Id);
                mockedDataReader.Stub(x => x.GetString("parenturi")).Return(newContactFormDetails.ParentUri);
                mockedDataReader.Stub(x => x.GetString("title")).Return(newContactFormDetails.Title);
            }

            mockedDataReader.Stub(x => x.Dispose());

            return mockedDataReader;
        }

        private IDnaDataReader MockedCreateCommentForum(ContactForm newContactFormDetails, int expectedForumId)
        {
            IDnaDataReader mockedDataReader = mocks.StrictMock<IDnaDataReader>();
            mockedDataReader.Stub(x => x.AddParameter("uid", newContactFormDetails.Id)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("url", newContactFormDetails.ParentUri)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("title", newContactFormDetails.Title)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("sitename", newContactFormDetails.SiteName)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("moderationstatus", (int)newContactFormDetails.ModerationServiceGroup)).Return(mockedDataReader);

            mockedDataReader.Stub(x => x.Execute()).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.Read()).Return(true);

            mockedDataReader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(expectedForumId);
            mockedDataReader.Stub(x => x.Dispose());

            return mockedDataReader;
        }

        private IDnaDataReader MockedSetCommentForumAsContactForm(ContactForm newContactFormDetails)
        {
            IDnaDataReader mockedDataReader = mocks.StrictMock<IDnaDataReader>();
            mockedDataReader.Stub(x => x.AddParameter("forumid", newContactFormDetails.ForumID)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.AddParameter("contactemail", newContactFormDetails.ContactEmail)).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.Execute()).Return(mockedDataReader);
            mockedDataReader.Stub(x => x.Dispose());

            return mockedDataReader;
        }
    }
}
