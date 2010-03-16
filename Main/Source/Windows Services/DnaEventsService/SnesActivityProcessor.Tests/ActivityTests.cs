using System;
using System.Diagnostics;
using BBC.Dna.Api;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ActivityProcessor.Activities;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SnesActivityProcessorTests
{
    /// <summary>
    /// Summary description for ActivityTests
    /// </summary>
    [TestClass]
    public class ActivityTests
    {
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

        [TestMethod]
        public void ReviewActivity_Create()
        {
            var openSocialActivity = new OpenSocialActivity();
            var eventData = new SnesActivityData();

            openSocialActivity.ActivityType = "review";
            openSocialActivity.Body = "some content";
            openSocialActivity.DisplayName = "mooks";
            openSocialActivity.Id = "1234";
            openSocialActivity.ObjectDescription = "some description";
            openSocialActivity.ObjectTitle = "some title";
            openSocialActivity.ObjectUri = new Uri("http://www.example.com/someuri", UriKind.RelativeOrAbsolute);
            openSocialActivity.PostedTime = DateTime.Now.MillisecondsSinceEpoch();
            openSocialActivity.Title = "some title";
            openSocialActivity.Url = new Uri("http://www.example.com/someurl",UriKind.RelativeOrAbsolute);
            openSocialActivity.UserName = "username";

            eventData.ActivityType = 19;
            eventData.AppInfo = new DnaApplicationInfo { AppId = "iplayer", ApplicationName = "iplayer video" };
            
            eventData.BlogUrl = "http://www.example.com/blogurl";
            eventData.EventId = 1;
            eventData.IdentityUserId = 12345;

            eventData.Rating = new Rating { MaxValue = 5, Value = 4 };
            eventData.UrlBuilder = new DnaUrlBuilder { DnaUrl = "iplayer", ForumId = 1, PostId = 1, ThreadId = 1 };


            var activity = CommentActivityBase.CreateActivity(openSocialActivity, eventData);

            Stopwatch sw = new Stopwatch();
            sw.Start();
            var json = activity.GetActivityJson();
            var uri = activity.GetUri();
            sw.Stop();

            long millis = sw.ElapsedMilliseconds;



        }
    }
}
