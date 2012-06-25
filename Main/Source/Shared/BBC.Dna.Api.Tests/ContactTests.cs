using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Sites;

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
        public void TestMethod1()
        {
            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite("h2g2").EditorsEmail).Return("dna@bbc.co.uk");
            Contacts contacts = new Contacts(null, null, null, siteList);
            CommentInfo info = new CommentInfo();
            info.ForumUri = "http://local.bbc.co.uk/dna/api/contactformservice.svc/";
            info.text = "This is a test email";
            contacts.SendDetailstoContactEmail(info, "mark.howitt@bbc.co.uk");
        }
    }
}
