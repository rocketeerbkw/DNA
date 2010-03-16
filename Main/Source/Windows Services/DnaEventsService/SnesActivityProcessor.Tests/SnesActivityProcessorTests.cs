using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Net;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using Microsoft.Http;
using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using DnaEventService.Common;

namespace SnesActivityTests
{
    /// <summary>
    /// Summary description for UnitTest2
    /// </summary>
    [TestClass]
    public class SnesActivityProcessorTests
    {
        public SnesActivityProcessorTests()
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

        [TestMethod]
        public void ProcessEvents_WithNoData()
        {
            MockRepository mocks = new MockRepository();

            IDnaDataReader getSnesEvents = mocks.StrictMock<IDnaDataReader>();
            IDnaDataReader removeHandledSnesEvents = mocks.StrictMock<IDnaDataReader>();
            IDnaDataReaderCreator dataReaderCreator = mocks.StrictMock<IDnaDataReaderCreator>();
            IDnaLogger logger = MockRepository.GenerateStub<IDnaLogger>();
            IDnaHttpClientCreator httpClientCreator = MockRepository.GenerateStub<IDnaHttpClientCreator>();

            using (mocks.Record())
            {
                Expect.Call(getSnesEvents.AddParameter("batchSize", 100)).IgnoreArguments();
                Expect.Call(getSnesEvents.Execute()).Return(getSnesEvents);
                Expect.Call(getSnesEvents.HasRows).Return(false);
                Expect.Call(() => getSnesEvents.Dispose());
                Expect.Call(dataReaderCreator.CreateDnaDataReader("getsnesevents")).Return(getSnesEvents);
            }

            using (mocks.Playback())
            {
                SnesActivityProcessor processor = CreateSNeSActivityProcessor(dataReaderCreator, logger, httpClientCreator);
                processor.ProcessEvents(null);
            }
        }

        [TestMethod]
        public void ProcessEvents_WithOneRow()
        {
            // TODO: 
            MockRepository mocks = new MockRepository();

            IDnaDataReader getSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            getSnesEvents.Stub(x => x.GetInt32("ActivityType")).Return(19);
            IDnaDataReader removeHandledSnesEvents = mocks.DynamicMock<IDnaDataReader>();
            removeHandledSnesEvents
                .Stub(x => x.AddParameter("eventids", ""))
                .Constraints(Is.Equal("eventids"), Is.Anything())
                .Return(removeHandledSnesEvents);

            Expect.Call(getSnesEvents.AddParameter("batchSize", 100)).IgnoreArguments();
            Expect.Call(removeHandledSnesEvents.Execute()).Return(removeHandledSnesEvents);
            Expect.Call(removeHandledSnesEvents.Dispose);
            
            IDnaDataReaderCreator dataReaderCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            IDnaLogger logger = MockRepository.GenerateStub<IDnaLogger>();           

            IDnaHttpClientCreator httpClientCreator = MockRepository.GenerateStub<IDnaHttpClientCreator>();
            
            IDnaHttpClient httpClient = MockRepository.GenerateStub<IDnaHttpClient>();
            httpClientCreator.Stub(x => x.CreateHttpClient()).Return(httpClient);

            HttpWebRequestTransportSettings settings = new HttpWebRequestTransportSettings();
            httpClient.Stub(x => x.TransportSettings).Return(settings);
            HttpContent content = HttpContent.Create("");
            HttpResponseMessage newHttpResponseMessage = new HttpResponseMessage();
            newHttpResponseMessage.StatusCode = HttpStatusCode.OK;
            newHttpResponseMessage.Uri = new Uri("http://www.bbc.co.uk/");
            newHttpResponseMessage.Content = content;
            httpClient.Stub(x => x.Post(new Uri("", UriKind.Relative), content)).Constraints(Is.Anything(),Is.Anything()).Return(newHttpResponseMessage);
            

            using (mocks.Record())
            {
                MockCurrentRowDataReader(getSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("removehandledsnesevents")).Return(removeHandledSnesEvents);
                Expect.Call(dataReaderCreator.CreateDnaDataReader("getsnesevents")).Return(getSnesEvents);
                
            }

            using (mocks.Playback())
            {
                SnesActivityProcessor processor = CreateSNeSActivityProcessor(dataReaderCreator, logger, httpClientCreator);
                processor.ProcessEvents(null);
            }
        }

        private SnesActivityProcessor CreateSNeSActivityProcessor(IDnaDataReaderCreator dataReaderCreator, 
            IDnaLogger logger, 
            IDnaHttpClientCreator httpClientCreator)
        {
            return new SnesActivityProcessor(
                dataReaderCreator, 
                logger, 
                httpClientCreator);
        }

        private IDnaDataReader MockCurrentRowDataReader(IDnaDataReader reader)
        {
            Expect.Call(reader.Execute()).Return(reader);
            Expect.Call(reader.HasRows).Return(true);
            Queue<bool> readReturn = new Queue<bool>();
            readReturn.Enqueue(true);
            readReturn.Enqueue(false);
            Expect.Call(reader.Read()).Return(true).WhenCalled( x => x.ReturnValue = readReturn.Dequeue());
            Expect.Call(() => reader.Dispose());
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

            return reader;
        }
    }
}
