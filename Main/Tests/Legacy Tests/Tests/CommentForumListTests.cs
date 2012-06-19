﻿using BBC.Dna;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Summary description for CommentForumListTests
    /// </summary>
    [TestClass]
    public class CommentForumListTests
    {
        /// <summary>
        /// 
        /// </summary>
        public CommentForumListTests()
        {
            //
            // TODO: Add constructor logic here
            //
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
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        /// Unit tests the GetParams() private method in the CommentForumListBuilder class
        /// </summary>
        [TestMethod]
        public void ShouldParseGiveninputParams()
        {
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            ISite mockedSite = mock.NewMock<ISite>();

            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            int expectedSiteID = 978456321;
            Stub.On(mockedInputContext).Method("DoesParamExist").With("dnasiteid", "SiteID Filter").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("dnasiteid", @"Site ID filter of the all the Comment Forums to return").Will(Return.Value(expectedSiteID));

            int expectedTermID = 987654321;
            Stub.On(mockedInputContext).Method("DoesParamExist").With("s_termid", "The id of the term to check").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("s_termid", "The id of the term to check").Will(Return.Value(expectedTermID));

            int expectedForumID = 123456789;
            Stub.On(mockedInputContext).Method("DoesParamExist").With("forumid", "Forum ID").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("forumid", "Forum ID").Will(Return.Value(expectedForumID));

            string expectedAction = "SHOWUPDATEFORM";
            Stub.On(mockedInputContext).Method("DoesParamExist").With("action", "Command string for flow").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("GetParamStringOrEmpty").With("action", "Command string for flow").Will(Return.Value(expectedAction));

            string expectedHostPageURL = "http://local.bbc.co.uk/dna/h2g2/commentforumlists";
            Stub.On(mockedInputContext).Method("GetParamStringOrEmpty").With("dnahostpageurl", @"Hostpageurl filter of all the Comment Forums to return").Will(Return.Value(expectedHostPageURL));

            int expectedUidCount = 2;
            string[] expectedUIDs = { "FirstUID", "SecondUID" };
            Stub.On(mockedInputContext).Method("GetParamCountOrZero").With("u", "0, 1 or more dnauids").Will(Return.Value(expectedUidCount));
            Stub.On(mockedInputContext).Method("GetParamStringOrEmpty").With("u", 0, "dnauid").Will(Return.Value(expectedUIDs[0]));
            Stub.On(mockedInputContext).Method("GetParamStringOrEmpty").With("u", 1, "dnauid").Will(Return.Value(expectedUIDs[1]));

            string expectedListPrefix = "listprefix-";
            Stub.On(mockedInputContext).Method("GetParamStringOrEmpty").With("dnacommentforumlistprefix", CommentForumListBuilder_Accessor._docDnaListNs).Will(Return.Value(expectedListPrefix));

            int expectedListCount = 2;
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("dnalistcount", CommentForumListBuilder_Accessor._docDnaListCount).Will(Return.Value(expectedListCount));

            int expectedSkip = 10;
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("dnaskip", CommentForumListBuilder_Accessor._docDnaSkip).Will(Return.Value(expectedSkip));

            int expectedShow = 20;
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("dnashow", CommentForumListBuilder_Accessor._docDnaShow).Will(Return.Value(expectedShow));

            Stub.On(mockedInputContext).Method("DoesParamExist").With("displaycontactforms", "display the contact forms?").Will(Return.Value(true));
            
            int actualSiteID = 0;
            string actualHostPageURL = "";
            int actualSkip = 0;
            int actualShow = 0;
            int uidCount = 0;
            string[] actualUIDs;
            string actualDNAListNs = "";
            int actualListCount = 0;

            CommentForumListBuilder_Accessor privateAccessor = new CommentForumListBuilder_Accessor(mockedInputContext);
            privateAccessor.GetPageParams(ref actualSiteID, ref actualHostPageURL, ref actualSkip, ref actualShow, ref uidCount, out actualUIDs, ref actualDNAListNs, ref actualListCount);

            Assert.AreEqual(expectedSiteID, actualSiteID);
            Assert.AreEqual(expectedTermID, privateAccessor._termId);
            Assert.AreEqual(expectedForumID, privateAccessor._forumId);
            Assert.AreEqual(expectedAction, privateAccessor._cmd);
            Assert.AreEqual(expectedHostPageURL, actualHostPageURL);
            Assert.AreEqual(expectedUidCount, actualUIDs.Length);
            Assert.AreEqual(expectedUIDs[0], actualUIDs[0]);
            Assert.AreEqual(expectedUIDs[1], actualUIDs[1]);
            Assert.AreEqual(expectedListPrefix, actualDNAListNs);
            Assert.AreEqual(expectedListCount, actualListCount);
            Assert.AreEqual(expectedSkip, actualSkip);
            Assert.AreEqual(expectedShow, actualShow);
            Assert.IsTrue(privateAccessor._displayContactForms, "Failed to set displayContactforms flag correctly");
        }
    }
}
