using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Transactions;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using DnaEventService.Common;
using Microsoft.Http;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;

namespace DnaEventProcessorService.IntegrationTests
{
    /// <summary>
    /// Summary description for LogFileSeperationTests
    /// </summary>
    [TestClass]
    public class LogFileSeperationTests
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
        public void ProcessEvents_SeperateLogFilesGeneratedByAssemblyName()
        {
            var mocks = new MockRepository();

            var getSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            getSnesEvents.Stub(x => x.GetInt32("ActivityType")).Return(19);
            var removeHandledSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            removeHandledSnesEvents
                .Stub(x => x.AddParameter("eventids", ""))
                .Constraints(Is.Equal("eventids"), Is.Anything())
                .Return(removeHandledSnesEvents);

            Expect.Call(removeHandledSnesEvents.Execute()).Return(removeHandledSnesEvents);
            Expect.Call(removeHandledSnesEvents.Dispose);
            
            var dataReaderCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            IDnaLogger logger = new DnaLogger();          

            var httpClientCreator = MockRepository.GenerateStub<IDnaHttpClientCreator>();
            
            var httpClient = MockRepository.GenerateStub<IDnaHttpClient>();
            httpClientCreator.Stub(x => x.CreateHttpClient()).Return(httpClient);

            StubHttpClientPostMethod(httpClient);

            using (mocks.Record())
            {
                MockCurrentRowDataReader(getSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("removehandledsnesevents"))
                    .Return(removeHandledSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("getsnesevents")).Return(getSnesEvents);
            }

            using (mocks.Playback())
            {
                var processor = CreateSnesActivityProcessor(dataReaderCreator, logger, httpClientCreator);
                processor.ProcessEvents(null);
            }

            Assert.IsTrue(File.Exists("snesactivityprocessor.responses.log"));
            Assert.IsTrue(File.Exists("snesactivityprocessor.requests.log"));
        }

        [TestMethod]
        public void Integration_CommentActivityEndToEnd_HttpStatusOK()
        {
            using (new TransactionScope())
            {
                //Setup up a comment forum for test using createcommentforum sp
                string connectionString = Properties.Settings.Default.guideConnectionString;
                IDnaDataReaderCreator creator = new DnaDataReaderCreator(connectionString);

                var uid = Guid.NewGuid().ToString();
                var url = "http://www.bbc.co.uk/";
                var title = "Test comment forum title";
                var siteId = "h2g2";

                CreateCommentForum(creator, uid, url, title, siteId);

                //Add comment to comment forum
                var hash = Guid.NewGuid().ToString();
                var content = "content";
                var userId = 6;

                CreateComment(creator, uid, userId, content, hash);

                SetupTestData(creator);
                
                ProcessEvents(creator);

                var mocks = new MockRepository();
                var httpClientCreator = mocks.Stub<IDnaHttpClientCreator>();
                var httpClient = MockRepository.GenerateStub<IDnaHttpClient>();

                SetupResult.For(httpClientCreator.CreateHttpClient()).Return(httpClient);
                
                StubHttpClientPostMethod(httpClient);

                var logger = MockRepository.GenerateStub<IDnaLogger>();

                mocks.ReplayAll();

                var processor = CreateSnesActivityProcessor(creator, logger, httpClientCreator);
                processor.ProcessEvents(null);

                httpClient.AssertWasCalled(client => client.Post(new Uri("", UriKind.Relative), 
                    HttpContent.Create("")), op => op.Constraints(Is.Anything(),Is.Anything()));
            }
        }

        [TestMethod]
        public void ProcessEvents_HttpClientNotReturning200Ok_RemoveHandledEventsNotCalled()
        {
            var mocks = new MockRepository();
            var dataReader = mocks.Stub<IDnaDataReader>();
            var dataCreator = mocks.Stub<IDnaDataReaderCreator>();
            dataCreator.Stub(x => x.CreateDnaDataReader("")).Constraints(Is.Anything()).Return(dataReader);
            var logger = mocks.Stub<IDnaLogger>();

            var httpCreator = mocks.Stub<IDnaHttpClientCreator>();
            var httpClient = mocks.Stub<IDnaHttpClient>();
            httpCreator.Stub(x => x.CreateHttpClient()).Return(httpClient);

            StubHttpClientPostMethod(httpClient, HttpStatusCode.NotFound);

            mocks.ReplayAll();

            var processor = CreateSnesActivityProcessor(dataCreator, logger, httpCreator);
            processor.ProcessEvents(null);

            dataCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("removehandledsnesevents"));
        }

        [TestMethod]
        [DeploymentItem("activities.js")]
        public void OpenSocialActivities_Deserialize()
        {
            var sr = new StreamReader(File.Open(@"activities.js", FileMode.Open));
            var json = sr.ReadToEnd();
            var obj = json.ObjectFromJson<OpenSocialActivities>();

            Assert.IsNotNull(obj);
        }

        private static void ProcessEvents(IDnaDataReaderCreator creator)
        {
            using (var reader = creator.CreateDnaDataReader("processeventqueue"))
            {
                reader.Execute();
            }
        }

        private static void SetupTestData(IDnaDataReaderCreator creator)
        {
            using (var adhoc = creator.CreateDnaDataReader(""))
            {
                adhoc.ExecuteDEBUGONLY(
                    "update signinuseridmapping set identityuserid = 6 where dnauserid = 6");
                adhoc.ExecuteDEBUGONLY("delete from snesapplicationmetadata where siteid = 1");
                adhoc.ExecuteDEBUGONLY(
                    "insert into snesapplicationmetadata(siteid, applicationid, applicationname) values " +
                    "(1, 'h2g2', 'Hitchhiker''s guide to the Galaxy')");
                adhoc.ExecuteDEBUGONLY("update users set loginname = 'Test' where userid = 6");
            }
        }

        private static void StubHttpClientPostMethod(IDnaHttpClient httpClient)
        {
            StubHttpClientPostMethod(httpClient, HttpStatusCode.OK);
        }

        private static void StubHttpClientPostMethod(IDnaHttpClient httpClient, HttpStatusCode returnCode)
        {
            var settings = new HttpWebRequestTransportSettings();
            httpClient.Stub(x => x.TransportSettings).Return(settings);
            var content = HttpContent.Create("");
            var newHttpResponseMessage = new HttpResponseMessage();
            httpClient.Stub(x => x.Post(new Uri("", UriKind.Relative), content))
                .Constraints(Is.Anything(), Is.Anything())
                .Return(newHttpResponseMessage)
                .WhenCalled(x => x.ReturnValue = GetNewHttpResponseMessage(returnCode));
        }

        private static HttpResponseMessage GetNewHttpResponseMessage(HttpStatusCode returnCode)
        {
            var content = HttpContent.Create("");
            var newHttpResponseMessage = new HttpResponseMessage
                                             {
                                                 StatusCode = returnCode,
                                                 Uri = new Uri("http://www.bbc.co.uk/"),
                                                 Content = content
                                             };
            return newHttpResponseMessage;
        }

        private static void CreateComment(IDnaDataReaderCreator creator, 
            string uid, int userId, string content, string hash)
        {
            using (var dataReader = creator.CreateDnaDataReader("commentcreate"))
            {
                dataReader.AddParameter("commentforumid", uid);
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("content", content);
                dataReader.AddParameter("hash", hash);
                dataReader.AddIntReturnValue();

                dataReader.Execute();
            }
        }

        private static void CreateCommentForum(IDnaDataReaderCreator creator, 
            string uid, string url, string title, string siteId)
        {
            using (var reader = creator.CreateDnaDataReader("commentforumcreate"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("url", url);
                reader.AddParameter("title", title);
                reader.AddParameter("sitename", siteId);

                reader.Execute();
            }
        }

        private static SnesActivityProcessor CreateSnesActivityProcessor(IDnaDataReaderCreator dataReaderCreator, 
            IDnaLogger logger, 
            IDnaHttpClientCreator httpClientCreator)
        {
            return new SnesActivityProcessor(
                dataReaderCreator, 
                logger, 
                httpClientCreator);
        }

        private static void MockCurrentRowDataReader(IDnaDataReader reader)
        {
            Expect.Call(reader.Execute()).Return(reader);
            Expect.Call(reader.HasRows).Return(true);
            var readReturn = new Queue<bool>();
            readReturn.Enqueue(true);
            readReturn.Enqueue(false);
            Expect.Call(reader.Read()).Return(true).WhenCalled( x => x.ReturnValue = readReturn.Dequeue());
            Expect.Call(reader.Dispose);
            Expect.Call(reader.GetString("AppId")).Return("iPlayer");

            //Expect.Call(reader.GetInt32NullAsZero("PostId")).Repeat.Times(2).Return(1);

            //Expect.Call(reader.GetStringNullAsEmpty("DnaUrl")).Return("http://www.bbc.co.uk/dna/");
            //Expect.Call(reader.GetInt32NullAsZero("ForumID")).Repeat.Any().Return(1234);
            //Expect.Call(reader.GetInt32NullAsZero("ThreadId")).Repeat.Any().Return(54321);
            //Expect.Call(reader.GetInt32("ActivityType")).Repeat.Times(2).Return(5);
            //Expect.Call(reader.GetInt32("EventID")).Return(1234);
            //string appId = Guid.NewGuid().ToString();
            //Expect.Call(reader.GetStringNullAsEmpty("AppId")).Return(appId);
            //Expect.Call(reader.GetStringNullAsEmpty("Body")).Return("here is some text");
            //DateTime now = new DateTime(1970, 1, 1, 0, 0, 0);
            //Expect.Call(reader.GetDateTime("ActivityTime")).Return(now);
            //Expect.Call(reader.GetInt32("IdentityUserId")).Return(12345456);
            //Expect.Call(reader.GetStringNullAsEmpty("AppName")).Return("iPlayer");

            //Expect.Call(reader.GetStringNullAsEmpty("BlogUrl")).Repeat.Times(2).Return("http://www.bbc.co.uk/blogs/test");

            return;
        }
    }
}
