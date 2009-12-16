using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Dna.SnesIntegration.ExModerationProcessor;
using BBC.Dna.Data;
using DnaEventService.Common;

namespace DnaEventProcessorService.IntegrationTests
{
    /// <summary>
    /// Summary description for ExModerationProcessorTests
    /// </summary>
    [TestClass]
    public class ExModerationProcessorTests
    {
        public ExModerationProcessorTests()
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
        public void ProcessEvents_LogFiles_CorrectNames()
        {
            MockRepository mocks = new MockRepository();

            IDnaDataReaderCreator dataReaderCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            IDnaHttpClientCreator httpClientCreator = mocks.DynamicMock<IDnaHttpClientCreator>();
            IDnaDataReader dataReader = mocks.Stub<IDnaDataReader>();

            dataReaderCreator.Stub(x => x.CreateDnaDataReader("getexmoderationevents")).Return(dataReader);
            dataReader.Stub(x => x.Execute()).Return(dataReader);
            dataReader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            dataReader.Stub(x => x.Read()).Return(false);
            dataReader.Stub(x => x.GetInt32NullAsZero("modid")).Return(0);
            dataReader.Stub(x => x.GetString("notes")).Return("");
            dataReader.Stub(x => x.GetString("uri")).Return("");
            dataReader.Stub(x => x.GetDateTime("datecompleted")).Return(DateTime.Now);
            dataReader.Stub(x => x.GetInt32NullAsZero("status")).Return(0);
            dataReader.Stub(x => x.GetString("callbackuri")).Return("");

            IDnaLogger logger = new DnaLogger();

            mocks.ReplayAll();

            ExModerationProcessor exModProcessor = new ExModerationProcessor(dataReaderCreator, logger, httpClientCreator);

            exModProcessor.ProcessEvents(null);
        }
    }
}
