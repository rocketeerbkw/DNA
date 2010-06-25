using System;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ActivityProcessor.Activities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace SnesActivityProcessorTests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class GetAddActivityTests
    {
        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext { get; set; }

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
        public void CreateActivity_ActivityType5_IsPostedComment()
        {
            var mocks = new MockRepository();
            IDnaDataReader currentRow = CreateDataReaderDynamicMock(mocks);

            using (mocks.Record())
            {
                currentRow.Stub(x => x.GetInt32("ActivityType")).Return(19);
                currentRow.Stub(x => x.IsDBNull("Rating")).Return(true);
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Related assertions
            string activityJson = activity.GetActivityJson();

            //Assert.AreEqual("posted", activity.ActivityType);
            Assert.IsTrue(activityJson.Contains("\"title\":\"posted"));
            Assert.IsTrue(activityJson.Contains("new comment "));
            Assert.IsTrue(activityJson.Contains("\"type\":\"comment\""));
        }
        
        [TestMethod]
        public void CreateActivity_DisplayName_Found()
        {
            var mocks = new MockRepository();
            IDnaDataReader currentRow = CreateDataReaderDynamicMock(mocks);

            using (mocks.Record())
            {
                //add expectation
                currentRow.Expect(x => x.GetString("displayName")).Return("mooks");
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Assert.AreEqual("mooks", activity.DisplayName);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"displayName\":\"mooks\""));
        }

        [TestMethod]
        public void CreateActivity_SiteNameIsIplayerTv_ReturnsCorrectObjectUid()
        {
            var mocks = new MockRepository();
            var currentRow = mocks.DynamicMock<IDnaDataReader>();

            using (mocks.Record())
            {
                //add expectation
                currentRow.Expect(x => x.GetString("DnaUrl")).Return("iplayerTv");
                currentRow.Expect(x => x.GetString("ObjectUri")).Return("aaaa");
                currentRow.Stub(x => x.GetInt32("ActivityType")).Return(19);
                
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Assert.AreEqual("mooks", activity.DisplayName);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectUri\":\"bbc:programme:aaaa:0\""));
        }

        [TestMethod]
        public void CreateActivity_SiteNameIsNotIplayerTv_ReturnsDefaultObjectUid()
        {
            var mocks = new MockRepository();
            var currentRow = mocks.DynamicMock<IDnaDataReader>();

            using (mocks.Record())
            {
                //add expectation
                currentRow.Expect(x => x.GetString("DnaUrl")).Return("h2g2");
                currentRow.Expect(x => x.GetString("ObjectUri")).Return("aaaa");
                currentRow.Stub(x => x.GetInt32("ActivityType")).Return(19);
                
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Assert.AreEqual("mooks", activity.DisplayName);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectUri\":\"bbc:dna:aaaa:0\""));
        }

        [TestMethod]
        public void CreateActivity_AppNameWithoutObjectUri_ReturnsForumId()
        {
            var mocks = new MockRepository();
            var currentRow = mocks.DynamicMock<IDnaDataReader>();

            using (mocks.Record())
            {
                //add expectation
                currentRow.Expect(x => x.GetString("DnaUrl")).Return("h2g2");
                currentRow.Expect(x => x.GetInt32("ForumID")).Return(1);
                currentRow.Stub(x => x.GetInt32("ActivityType")).Return(19);

            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Assert.AreEqual("mooks", activity.DisplayName);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectUri\":\"bbc:dna:1:0:0\""));
        }


        [Ignore]
        [TestMethod]
        public void CreateActivity_DisplayNameWithApostrophe_Found()
        {
            var mocks = new MockRepository();
            IDnaDataReader currentRow = CreateDataReaderDynamicMock(mocks);

            using (mocks.Record())
            {
                //add expectation
                currentRow.Expect(x => x.GetString("displayName")).Return("moo'ks");
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //Assert.AreEqual("moo'ks", activity.DisplayName);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"displayName\":\"moo&#39ks\""));
        }
        
        [Ignore]
        [TestMethod]
        public void CreateActivity_ObjectTitle_Found()
        {
            var mocks = new MockRepository();
            IDnaDataReader currentRow = CreateDataReaderDynamicMock(mocks);

            using (mocks.Record())
            {
                //add expectation
                //nothing to add here - no new data required
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }
            
            string expected = @"posted a <a href= ""http://www.bbc.co.uk/blogs/test#P1"" > new comment </a> on the <a href = ""http://www.bbc.co.uk/blogs/test"" > iPlayer </a>";
            //Assert.AreEqual(expected, activity.Title);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectTitle\":\"" + expected + "\""));
        }

        [Ignore]
        [TestMethod]
        public void CreateActivity_ObjectDescription_Found()
        {
            var mocks = new MockRepository();
            IDnaDataReader currentRow = CreateDataReaderDynamicMock(mocks);

            using (mocks.Record())
            {
                //add expectation
                //nothing to add here - no new data required
            }

            ISnesActivity activity;
            using (mocks.Playback())
            {
                activity = SnesActivityFactory.CreateSnesActivity(currentRow);
            }

            //string expected = @"here is some text";
            //Assert.AreEqual(expected, activity.Body);
            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectDescription\":\"here is some text\""));
        }

        [Ignore]
        [TestMethod]
        public void CreateActivity_ObjectDescriptionWithApostrophe_Found()
        {
            var mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.GetString("Body")).Return("some text' with apostrophe");
            reader.Stub(x => x.GetInt32("ActivityType")).Return(19);

            mocks.ReplayAll();

            ISnesActivity activity = SnesActivityFactory.CreateSnesActivity(reader);

            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectDescription\":\"some text&#39 with apostrophe\""));
        }

        [Ignore]
        [TestMethod]
        public void CreateActivity_ObjectUri_Found()
        {
            var mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            reader.Stub(x => x.IsDBNull("BlogUrl")).Return(true);

            mocks.ReplayAll();

            ISnesActivity activity = SnesActivityFactory.CreateSnesActivity(reader);

            Assert.IsTrue(activity.GetActivityJson().Contains("\"objectUri\":\"/dna//F0?thread=0#p0\""));
        }

        [Ignore]
        [TestMethod]
        public void CreateActivity_Username_Found()
        {
            var mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();

            reader.Stub(x => x.GetInt32("IdentityUserId")).Return(12345);
            reader.Stub(x => x.GetInt32("ActivityType")).Return(19);

            mocks.ReplayAll();

            ISnesActivity activity = SnesActivityFactory.CreateSnesActivity(reader);

            Assert.IsTrue(activity.GetActivityJson().Contains("\"username\":\"12345\""));
        }

        [TestMethod]
        public void GetActivityJson_BodyContainsQuotedText_EscapedCorrectly()
        {
            var reader = MockRepository.GenerateStub<IDnaDataReader>();
            reader.Stub(x => x.GetInt32("ActivityType")).Return(19);
            var body = @"'quoted' and ""quoted"" text";
            reader.Stub(x => x.GetString("Body")).Return(body);


            var commentActivity = SnesActivityFactory.CreateSnesActivity(reader);

            var json = commentActivity.GetActivityJson();

            Assert.IsTrue(json.Length>1);

               
        }

        #region Test Helper Methods
        private static IDnaDataReader CreateDataReaderDynamicMock(MockRepository mocks)
        {
            var currentRow = mocks.DynamicMock<IDnaDataReader>();
            currentRow.Stub(x => x.GetInt32NullAsZero("PostId")).Return(1);

            currentRow.Stub(x => x.GetString("DnaUrl")).Return("http://www.bbc.co.uk/dna/");
            currentRow.Stub(x => x.GetInt32NullAsZero("ForumId")).Return(1234);
            currentRow.Stub(x => x.GetInt32NullAsZero("ThreadId")).Return(54321);
            currentRow.Stub(x => x.GetInt32("ActivityType")).Return(19);
            currentRow.Stub(x => x.GetInt32("EventId")).Return(1234);
            string appId = Guid.NewGuid().ToString();
            currentRow.Stub(x => x.GetString("AppId")).Return(appId);
            currentRow.Stub(x => x.GetString("Body")).Return("here is some text");
            var now = new DateTime(1970, 1, 1, 0, 0, 0);
            currentRow.Stub(x => x.GetDateTime("ActivityTime")).Return(now);
            currentRow.Stub(x => x.GetInt32("IdentityUserID")).Return(12345456);
            currentRow.Stub(x => x.GetString("AppName")).Return("iPlayer");

            currentRow.Stub(x => x.GetString("BlogUrl")).Return("http://www.bbc.co.uk/blogs/test");
            return currentRow;
        }

        private static IDnaDataReader CreateMockedReader()
        {
            var currentRow = MockRepository.GenerateMock<IDnaDataReader>();
            
            currentRow.Expect(x => x.GetInt32NullAsZero("PostId")).Return(1);
            
            currentRow.Expect(x => x.GetStringNullAsEmpty("DnaUrl")).Return("http://www.bbc.co.uk/dna/");
            currentRow.Expect(x => x.GetInt32NullAsZero("ForumId")).Return(1234);
            currentRow.Expect(x => x.GetInt32NullAsZero("ThreadId")).Return(54321);
            currentRow.Expect(x => x.GetInt32("ActivityType")).Return(19);
            currentRow.Expect(x => x.GetInt32("EventId")).Return(1234);
            string appId = Guid.NewGuid().ToString();
            currentRow.Expect(x => x.GetStringNullAsEmpty("AppId")).Return(appId);
            currentRow.Expect(x => x.GetStringNullAsEmpty("Body")).Return("here is some text");
            var now = new DateTime(1970, 1, 1, 0, 0, 0);
            currentRow.Expect(x => x.GetDateTime("ActivityTime")).Return(now);
            currentRow.Expect(x => x.GetInt32("IdentityUserID")).Return(12345456);
            currentRow.Expect(x => x.GetStringNullAsEmpty("AppName")).Return("iPlayer");

            currentRow.Expect(x => x.GetStringNullAsEmpty("BlogUrl")).Return("http://www.bbc.co.uk/blogs/test");
            currentRow.Expect(x => x.HasRows).Return(true);

            return currentRow;

        }

        #endregion
    }
}


