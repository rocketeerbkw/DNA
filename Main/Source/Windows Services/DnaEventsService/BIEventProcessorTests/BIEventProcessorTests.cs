using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Dna.BIEventSystem;
using BBC.Dna.Data;
using TestUtils.Mocks.Extentions;
using System.Data.SqlClient;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary;

namespace BIEventProcessorTests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class BIEventProcessorTests
    {
        public BIEventProcessorTests()
        {
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

        private MockRepository _mocks = new MockRepository();
        private IDnaDataReader _mockreader;
        private IDnaDataReaderCreator _mockcreator;

        private DateTime _DT = DateTime.Now;

        [TestMethod]
        public void BIEvent_CreateBIPostNeedsRiskAssessmentEvent_ExpectAllPropertiesToBeCorrect()
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostNeedsRiskAssessmentRow(11, _DT, 12, 13, 14, 15, 16, 17, DateTime.Parse("2010-09-12"), "hello", 23));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "", out _mockcreator, out _mockreader, rows);

            _mockreader.Read();
            BIPostNeedsRiskAssessmentEvent ev = (BIPostNeedsRiskAssessmentEvent)BIEvent.CreateBiEvent(_mockreader, null, null);

            Assert.AreEqual(11, ev.EventId);
            Assert.AreEqual(EventTypes.ET_POSTNEEDSRISKASSESSMENT, ev.EventType);
            Assert.AreEqual(12, ev.ThreadEntryId);
            Assert.AreEqual(13, ev.ModClassId);
            Assert.AreEqual(14, ev.SiteId);
            Assert.AreEqual(15, ev.ForumId);
            Assert.AreEqual(16, ev.ThreadId);
            Assert.AreEqual(17, ev.UserId);
            Assert.AreEqual(DateTime.Parse("2010-09-12"), ev.DatePosted);
            Assert.AreEqual("hello", ev.Text);
            Assert.AreEqual(23, ev.RiskModThreadEntryQueueId);
        }

        [TestMethod]
        public void BIEvent_CreateBIPostToForumEvent_ExpectAllPropertiesToBeCorrect()
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostToForumRow(81, _DT, 82, 83, 84, 85, 86, 87, 88, 89, 90, 92, DateTime.Parse("2090-09-12"), "bye"));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "", out _mockcreator, out _mockreader, rows);

            _mockreader.Read();

            BIPostToForumEvent ev = (BIPostToForumEvent)BIEvent.CreateBiEvent(_mockreader, null, null);

            Assert.AreEqual(81, ev.EventId);
            Assert.AreEqual(EventTypes.ET_POSTTOFORUM, ev.EventType);
            Assert.AreEqual(82, ev.ThreadEntryId);
            Assert.AreEqual(83, ev.ModClassId);
            Assert.AreEqual(84, ev.SiteId);
            Assert.AreEqual(85, ev.ForumId);
            Assert.AreEqual(86, ev.ThreadId);
            Assert.AreEqual(87, ev.UserId);
            Assert.AreEqual(88, ev.NextSibling);
            Assert.AreEqual(89, ev.Parent);
            Assert.AreEqual(90, ev.PrevSibling);
            Assert.AreEqual(92, ev.FirstChild);
            Assert.AreEqual(DateTime.Parse("2090-09-12"), ev.DatePosted);
            Assert.AreEqual("bye", ev.Text);
        }

        [TestMethod]
        public void BIEvent_CreateBIPostModerationDecisionEvent_ExpectAllPropertiesToBeCorrect()
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostModDecisionRow(81, _DT, 82, 3, true));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "", out _mockcreator, out _mockreader, rows);

            _mockreader.Read();

            BIPostModerationDecisionEvent ev = (BIPostModerationDecisionEvent)BIEvent.CreateBiEvent(_mockreader, null, null);

            Assert.AreEqual(81, ev.EventId);
            Assert.AreEqual(EventTypes.ET_MODERATIONDECISION_POST, ev.EventType);
            Assert.AreEqual(_DT, ev.EventDate);
            Assert.AreEqual(82, ev.ThreadEntryId);
            Assert.AreEqual(3, ev.ModDecisionStatus);
            Assert.AreEqual(true, ev.IsComplaint);
        }

        [TestMethod]
        public void BIEvent_CreateBIEvent_ExpectExceptionForUnknownEventTypes()
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(new BIEventTestDatabaseRow(11, EventTypes.ET_ARTICLEEDITED, _DT));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "", out _mockcreator, out _mockreader, rows);

            try
            {
                BIPostNeedsRiskAssessmentEvent ev = (BIPostNeedsRiskAssessmentEvent)BIEvent.CreateBiEvent(_mockreader, null, null);
            }
            catch (InvalidOperationException ex)
            {
                Assert.IsTrue(ex.Message.CompareTo("Event Type " + EventTypes.ET_ARTICLEEDITED.ToString() + " not supported") == 0);
                return;
            }

            Assert.Fail("Shouldn't get here.  No exception thrown");
        }

        [TestMethod]
        public void TheGuideSystem_GetBIEvents_ExpectListOfEvents()
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostNeedsRiskAssessmentRow(11, _DT, 12, 13, 14, 15, 16, 17, DateTime.Parse("2010-09-12"), "hello", 23));
            rows.Add(BIEventTestDatabaseRow.CreatePostNeedsRiskAssessmentRow(50, _DT, null, 53, 54, 55, 56, 57, DateTime.Parse("2015-09-12"), "goodbye", 63));
            rows.Add(BIEventTestDatabaseRow.CreatePostToForumRow(70, _DT, 72, 73, 74, 75, 76, 77, 78, 79, 80, 82, DateTime.Parse("2020-09-12"), "eh?"));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "getbievents", out _mockcreator, out _mockreader, rows);

            var riskModSystem = _mocks.Stub<IRiskModSystem>();

            var g = new TheGuideSystem(_mockcreator, riskModSystem);

            var eventList = g.GetBIEvents();

            Assert.AreEqual(3, eventList.Count);

            Assert.IsTrue(eventList[0] is BIPostNeedsRiskAssessmentEvent);
            Assert.IsTrue(eventList[1] is BIPostNeedsRiskAssessmentEvent);
            Assert.IsTrue(eventList[2] is BIPostToForumEvent);

            Assert.AreEqual(EventTypes.ET_POSTNEEDSRISKASSESSMENT, eventList[0].EventType);
            Assert.AreEqual(EventTypes.ET_POSTNEEDSRISKASSESSMENT, eventList[1].EventType);
            Assert.AreEqual(EventTypes.ET_POSTTOFORUM, eventList[2].EventType);
        }

        [TestMethod]
        public void TheGuideSystem_ProcessPostRiskAssessment_ExpectNoExceptions()
        {
            BIPostNeedsRiskAssessmentEvent ev = MakeTestBIPostNeedsRiskAssessmentEvent(12);
            TheGuideSystem g = MakeTestTheGuideSystem();

            _mockreader.Stub(x => x.DoesFieldExist("OuterErrorCode")).Return(false);

            g.ProcessPostRiskAssessment(ev, true);

            _mockreader.AssertWasCalled(x => x.DoesFieldExist("OuterErrorCode"));
            // If we get here, no exceptions were thrown, which is good.
        }

        [TestMethod]
        public void TheGuideSystem_ProcessPostRiskAssessment_TestExceptionHandling()
        {
            BIPostNeedsRiskAssessmentEvent ev = MakeTestBIPostNeedsRiskAssessmentEvent(12);
            TheGuideSystem g = MakeTestTheGuideSystem();  // Expects MakeTestTheGuideSystem() to set up _mockreader. (puke!)

            _mockreader.Stub(x => x.DoesFieldExist("OuterErrorCode")).Return(true);

            try
            {
                g.ProcessPostRiskAssessment(ev, true);
            }
            catch (Exception ex)
            {
                Assert.IsTrue(ex.Message.CompareTo("ProcessPostRiskAssessment: SP Error from riskmod_processriskassessmentforthreadentry (99): This is a test") == 0);
                _mockreader.AssertWasCalled(x => x.DoesFieldExist("OuterErrorCode"));
                return;
            }
            Assert.Fail("Shouldn't get this far");
        }

        [TestMethod]
        public void TheGuideSystem_TestRecordRiskModDecisionsOnPosts_RiskyAndProcessed_CheckTheParamsAreCorrect()
        {
            Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(true,true);
        }

        [TestMethod]
        public void TheGuideSystem_TestRecordRiskModDecisionsOnPosts_NotRiskyAndProcessed_CheckTheParamsAreCorrect()
        {
            Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(true, false);
        }

        [TestMethod]
        public void TheGuideSystem_TestRecordRiskModDecisionsOnPosts_NoRiskyValueAndProcessed_CheckTheParamsAreCorrect()
        {
            Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(true, null);
        }

        [TestMethod]
        public void TheGuideSystem_TestRecordRiskModDecisionsOnPosts_RiskyValueAndNotProcessed_CheckTheParamsAreCorrect()
        {
            Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(false, true);
        }

        [TestMethod]
        public void TheGuideSystem_TestRecordRiskModDecisionsOnPosts_NoRiskyValueAndNotProcessed_CheckTheParamsAreCorrect()
        {
            Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(false, null);
        }

        private void Helper_TheGuideSystem_TestRecordRiskModDecisionsOnPosts_Processed_CheckTheParamsAreCorrect(bool process, bool? RiskyValue)
        {
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "riskmod_recordriskmoddecisionforthreadentry", out _mockcreator, out _mockreader, null);
            var mockreader = _mockreader;
            TheGuideSystem g = new TheGuideSystem(_mockcreator, null);

            var logger = new TestDnaLogger();
            BIEventProcessor.BIEventLogger = logger;

            // We need a IRiskModSystem do we can "Process" the event
            var rm = _mocks.Stub<IRiskModSystem>();
            bool? dummyrisky;
            rm.Stub(x => x.RecordPostToForumEvent(null, out dummyrisky)).IgnoreArguments().OutRef(RiskyValue).Return(true);

            // Create an event and process it
            var evList = new List<BIPostToForumEvent>();
            var ev = MakeTestBIPostToForumEvent(42, rm);
            if (process)
                ev.Process();
            evList.Add(ev);

            // Record the decision in TheGuide system 
            g.RecordRiskModDecisionsOnPosts(evList);

            if (process)
            {
                // Check the logging
                Assert.IsNotNull(logger.logList.Find(x => x.Message == "RecordRiskModDecisionsOnPost() end"));
                Assert.AreEqual(logger.logList[0].ExtendedProperties["SiteId"], 74);
                Assert.AreEqual(logger.logList[0].ExtendedProperties["ForumId"], 75);
                Assert.AreEqual(logger.logList[0].ExtendedProperties["ThreadEntryId"], 42);
                if (RiskyValue.HasValue)
                    Assert.AreEqual(logger.logList[0].ExtendedProperties["Risky"], RiskyValue);
                else
                    Assert.AreEqual(logger.logList[0].ExtendedProperties["Risky"], "NULL");

                // Check the params sent to the sp
                mockreader.AssertWasCalled(x => x.AddParameter("siteid", 74));
                mockreader.AssertWasCalled(x => x.AddParameter("forumid", 75));
                mockreader.AssertWasCalled(x => x.AddParameter("threadentryid", 42));
                mockreader.AssertWasCalled(x => x.AddParameter("risky", RiskyValue));

                mockreader.AssertWasCalled(x => x.Execute());
            }
            else
            {
                Assert.IsTrue(logger.logList.Count == 0);

                mockreader.AssertWasNotCalled(x => x.Execute());
            }
        }

        
        private BIPostNeedsRiskAssessmentEvent MakeTestBIPostNeedsRiskAssessmentEvent(int threadEntryId)
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostNeedsRiskAssessmentRow(11, _DT, threadEntryId, 13, 14, 15, 16, 17, DateTime.Parse("2010-09-12"), "hello", 23));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "getbievents", out _mockcreator, out _mockreader, rows);
            return (BIPostNeedsRiskAssessmentEvent)BIEvent.CreateBiEvent(_mockreader, null, null);
        }

        private BIPostToForumEvent MakeTestBIPostToForumEvent(int threadEntryId, IRiskModSystem rm)
        {
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(BIEventTestDatabaseRow.CreatePostToForumRow(70, _DT,threadEntryId, 73, 74, 75, 76, 77, 78, 79, 80, 82, DateTime.Parse("2020-09-12"), "eh?"));
            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "getbievents", out _mockcreator, out _mockreader, rows);
            return (BIPostToForumEvent)BIEvent.CreateBiEvent(_mockreader, null, rm);
        }

        private TheGuideSystem MakeTestTheGuideSystem()
        {
            var r = new DataReaderFactory.TestDatabaseRow();
            r.AddGetInt32ColumnValue("OuterErrorCode", 99);
            r.AddGetStringColumnValue("OuterErrorMessage", "This is a test");
            var rows = new List<DataReaderFactory.TestDatabaseRow>();
            rows.Add(r);

            DataReaderFactory.CreateMockedDataBaseObjects(_mocks, "riskmod_processriskassessmentforthreadentry", out _mockcreator, out _mockreader, rows);

            var riskModSystem = _mocks.Stub<IRiskModSystem>();
            return new TheGuideSystem(_mockcreator, riskModSystem);
        }

        private RiskModSystem MakeTestRiskModSystem(int? modResult)
        {
            IDnaDataReaderCreator creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            DataReaderFactory.AddMockedDataReader(_mocks, "predict", creator, out _mockreader, null);

            _mockreader.Stub(x => x.GetNullableIntOutputParameter("moderation")).Return(modResult);

            return new RiskModSystem(creator, false);
        }

        private class BIEventTestDatabaseRow : DataReaderFactory.TestDatabaseRow
        {
            public BIEventTestDatabaseRow(int eventId, EventTypes eventType, DateTime eventDate) 
            {
                AddGetInt32ColumnValue("EventId", eventId);
                AddGetInt32ColumnValue("EventType", (int)eventType);
                AddGetDateTimeColumnValue("EventDate", eventDate);
            }

            /// <summary>
            /// BIEventTestDatabaseRow
            /// </summary>
            /// <remarks>
            /// The params should match the result set from getbievents.sql
            /// </remarks>
            public static DataReaderFactory.TestDatabaseRow CreatePostToForumRow(int eventId, DateTime eventDate, int threadEntryId, int modClassId,
                                                                                 int siteId, int forumId, int threadId, int userId, int? nextSibling, int? parent,
                                                                                 int? prevSibling, int? firstChild, DateTime datePosted, string text)
            {
                var row = new BIEventTestDatabaseRow(eventId, EventTypes.ET_POSTTOFORUM, eventDate);

                row.AddGetInt32ColumnValue("ThreadEntryId", threadEntryId);
                row.AddGetInt32ColumnValue("ModClassId", modClassId);
                row.AddGetInt32ColumnValue("SiteId", siteId);
                row.AddGetInt32ColumnValue("ForumId", forumId);
                row.AddGetInt32ColumnValue("ThreadId", threadId);
                row.AddGetInt32ColumnValue("UserId", userId);
                row.AddGetNullableInt32ColumnValue("NextSibling", nextSibling);
                row.AddGetNullableInt32ColumnValue("Parent", parent);
                row.AddGetNullableInt32ColumnValue("PrevSibling", prevSibling);
                row.AddGetNullableInt32ColumnValue("FirstChild", firstChild);
                row.AddGetDateTimeColumnValue("DatePosted", datePosted);
                row.AddGetStringColumnValue("text", text);

                return row;
            }

            public static DataReaderFactory.TestDatabaseRow CreatePostNeedsRiskAssessmentRow(int eventId, DateTime eventDate, int? threadEntryId, int modClassId, int siteId, 
                                                                                                int forumId, int threadId, int userId, DateTime datePosted, string text, 
                                                                                                int riskModThreadEntryQueueId)
            {
                var row = new BIEventTestDatabaseRow(eventId, EventTypes.ET_POSTNEEDSRISKASSESSMENT, eventDate);

                row.AddGetNullableInt32ColumnValue("ThreadEntryId", threadEntryId);
                row.AddGetInt32ColumnValue("ModClassId", modClassId);
                row.AddGetInt32ColumnValue("SiteId", siteId);
                row.AddGetInt32ColumnValue("ForumId", forumId);
                row.AddGetInt32ColumnValue("ThreadId", threadId);
                row.AddGetInt32ColumnValue("UserId", userId);
                row.AddGetDateTimeColumnValue("DatePosted", datePosted);
                row.AddGetStringColumnValue("text", text);
                row.AddGetInt32ColumnValue("RiskModThreadEntryQueueId", riskModThreadEntryQueueId);

                return row;
            }
            
            public static DataReaderFactory.TestDatabaseRow CreatePostModDecisionRow(int eventId, DateTime eventDate, int threadEntryId, int modDecisionStatus, bool isComplaint)
            {
                var row = new BIEventTestDatabaseRow(eventId, EventTypes.ET_MODERATIONDECISION_POST, eventDate);

                row.AddGetInt32ColumnValue("ThreadEntryId", threadEntryId);
                row.AddGetInt32ColumnValue("ModDecisionStatus", modDecisionStatus);
                row.AddGetBooleanColumnValue("IsComplaint", isComplaint);

                return row;
            }
        }

        [TestMethod]
        public void BIPostNeedsRiskAssessmentEvent_Process_IsRisky()
        {
            var m = new MockRepository();

            var mockITheGuideSystem = m.Stub<ITheGuideSystem>();
            mockITheGuideSystem.Stub(x => x.ProcessPostRiskAssessment(null, true)).IgnoreArguments();

            var mockIRiskModSystem = m.Stub<IRiskModSystem>();
            mockIRiskModSystem.Stub(x => x.IsRisky(null)).Return(true).IgnoreArguments();

            m.ReplayAll();

            var ev = new BIPostNeedsRiskAssessmentEvent(mockITheGuideSystem, mockIRiskModSystem);
            ev.Process();

            mockIRiskModSystem.AssertWasCalled(x => x.IsRisky(ev));
            mockITheGuideSystem.AssertWasCalled(x => x.ProcessPostRiskAssessment(ev, true));
        }

        [TestMethod]
        public void BIPostNeedsRiskAssessmentEvent_Process_IsNotRisky()
        {
            var m = new MockRepository();

            var mockITheGuideSystem = m.Stub<ITheGuideSystem>();
            mockITheGuideSystem.Stub(x => x.ProcessPostRiskAssessment(null, true)).IgnoreArguments();

            var mockIRiskModSystem = m.Stub<IRiskModSystem>();
            mockIRiskModSystem.Stub(x => x.IsRisky(null)).Return(false).IgnoreArguments();

            m.ReplayAll();

            var ev = new BIPostNeedsRiskAssessmentEvent(mockITheGuideSystem, mockIRiskModSystem);
            ev.Process();

            mockIRiskModSystem.AssertWasCalled(x => x.IsRisky(ev));
            mockITheGuideSystem.AssertWasCalled(x => x.ProcessPostRiskAssessment(ev, false));
        }

        [TestMethod]
        public void RiskModSystem_IsRisky_TestNotRiskyResult()
        {
            var ev = MakeTestBIPostNeedsRiskAssessmentEvent(12);

            var m = new MockRepository();
            var reader = m.DynamicMock<IDnaDataReader>();
            var creator = m.Stub<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("predict_withoutentryid")).Return(reader);
            reader.Stub(x => x.GetIntReturnValue()).Return(0);
            m.ReplayAll();

            var rm = new RiskModSystem(creator, false);

            bool risky = rm.IsRisky(ev);

            Assert.IsFalse(risky);
        }

        [TestMethod]
        public void RiskModSystem_IsRisky_TestExceptionHandledAndReturnsTrue()
        {
            var ev = MakeTestBIPostNeedsRiskAssessmentEvent(12);

            var m = new MockRepository();
            var reader = m.DynamicMock<IDnaDataReader>();
            var creator = m.Stub<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("predict_withoutentryid")).Return(reader);
            reader.Stub(x => x.GetIntReturnValue()).Return(0).WhenCalled(x => { throw new Exception("Hello!"); });
            m.ReplayAll();

            var rm = new RiskModSystem(creator, false);

            bool risky = rm.IsRisky(ev);

            Assert.IsTrue(risky);
        }

        [TestMethod]
        public void RiskModSystem_When_Disabled_Check_IsRisky_Returns_True()
        {
            // Create with "Disabled" is true
            var rm = new RiskModSystem(null, true);

            var postAssessEvent = new BIPostNeedsRiskAssessmentEvent(null, null);
            bool risky = rm.IsRisky(postAssessEvent);
            Assert.IsTrue(risky);
        }

        [TestMethod]
        public void RiskModSystem_When_Disabled_Check_RecordPostToForumEvent_Returns_False()
        {
            // Create with "Disabled" is true
            var rm = new RiskModSystem(null, true);

            var postEvent = new BIPostToForumEvent(null);
            bool? risky;
            bool recPost = rm.RecordPostToForumEvent(postEvent, out risky);
            Assert.IsFalse(recPost);
        }

        [TestMethod]
        public void RiskModSystem_When_Disabled_Check_RecordPostModerationDecision_Returns_False()
        {
            // Create with "Disabled" is true
            var rm = new RiskModSystem(null, true);

            var postModDecisionEvent = new BIPostModerationDecisionEvent(null);
            bool recModDec = rm.RecordPostModerationDecision(postModDecisionEvent);
            Assert.IsFalse(recModDec);
        }

        [TestMethod]
        public void RiskModSystem_IsRisky_TestRiskyResult()
        {
            var ev = MakeTestBIPostNeedsRiskAssessmentEvent(12);

            var m = new MockRepository();
            var reader = m.DynamicMock<IDnaDataReader>();
            var creator = m.Stub<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("predict_withoutentryid")).Return(reader);
            reader.Stub(x => x.GetIntReturnValue()).Return(1);
            m.ReplayAll();

            var rm = new RiskModSystem(creator, false);

            bool risky = rm.IsRisky(ev);

            Assert.IsTrue(risky);
        }

        [TestMethod]
        public void RiskModSystem_ProcessPostRiskAssessment_PredictSaysRisky()
        {
            RiskModSystem_ProcessPostRiskAssessment(1, true);
        }

        [TestMethod]
        public void RiskModSystem_ProcessPostRiskAssessment_PredictSaysNotRisky()
        {
            RiskModSystem_ProcessPostRiskAssessment(0, false);
        }

        [TestMethod]
        public void RiskModSystem_ProcessPostRiskAssessment_PredictDoesNotKnowIfItsRisky()
        {
            RiskModSystem_ProcessPostRiskAssessment(null, null);
        }

        void RiskModSystem_ProcessPostRiskAssessment(int? predictSPRiskyResult, bool? expectedRiskyResult)
        {
            RiskModSystem rm = MakeTestRiskModSystem(predictSPRiskyResult);
            var mockreader = _mockreader;
            BIPostToForumEvent ev = MakeTestBIPostToForumEvent(42, rm);

            ev.Process();

            mockreader.AssertWasCalled(x => x.AddParameter("EntryId", 42));
            mockreader.AssertWasCalled(x => x.Execute());

            if (expectedRiskyResult.HasValue)
                Assert.AreEqual(expectedRiskyResult.Value, ev.Risky.Value);
            else
                Assert.IsFalse(ev.Risky.HasValue);
        }

        [TestMethod]
        public void BIEventProcessor_Process_AllEventsProcessed()
        {
            var mockCreator = _mocks.Stub<IDnaDataReaderCreator>();

            BIEventProcessor bep = BIEventProcessor.CreateBIEventProcessor(null, mockCreator, mockCreator, 1, false, false, 1);

            var evRisk = _mocks.DynamicMock<BIPostNeedsRiskAssessmentEvent>(null,null);
            var evPost = _mocks.DynamicMock<BIPostToForumEvent>(new object[] { null });
            var evModD = _mocks.DynamicMock<BIPostModerationDecisionEvent>(new object[] { null });

            var eventList = new List<BIEvent>() { evRisk, evPost, evModD };

            _mocks.ReplayAll();

            bep.ProcessEvents(eventList,1);

            evRisk.AssertWasCalled(x => x.Process());
            evPost.AssertWasCalled(x => x.Process());
            evModD.AssertWasCalled(x => x.Process());
        }

        [TestMethod]
        public void BIEventProcessor_CreateBIEventProcessor_CannotBeCalledTwice()
        {
            var mockCreator = _mocks.Stub<IDnaDataReaderCreator>();

            BIEventProcessor bep1 = BIEventProcessor.CreateBIEventProcessor(null, mockCreator, mockCreator, 1, false, false, 1);
            BIEventProcessor bep2 = BIEventProcessor.CreateBIEventProcessor(null, mockCreator, mockCreator, 1, false, false, 1);

            Assert.AreNotEqual(bep1,bep2);
        }

        [TestMethod]
        public void BIEventProcessor_BIEventProcessor_Elapsed_TestHandlerCalled()
        {
            // Don't add any rows because we don't want Process to be called on any events
            var biEventRows = new List<DataReaderFactory.TestDatabaseRow>();
            biEventRows.Add(BIEventTestDatabaseRow.CreatePostNeedsRiskAssessmentRow(11, _DT, 12, 13, 14, 15, 16, 17, DateTime.Parse("2010-09-12"), "hello", 23));
            biEventRows.Add(BIEventTestDatabaseRow.CreatePostToForumRow(70, _DT, 72, 73, 74, 75, 76, 77, 78, 79, 80, 82, DateTime.Parse("2020-09-12"), "eh?"));
            biEventRows.Add(BIEventTestDatabaseRow.CreatePostModDecisionRow(90, _DT, 92, 3, false));

            IDnaDataReaderCreator creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            
            IDnaDataReader getbieventsReader, predictNoEntryIdReader, processReader, predictReader, removeReader, moderationReader, recordDecisionReader;

            DataReaderFactory.AddMockedDataReader(_mocks, "getbievents", creator, out getbieventsReader, biEventRows);
            DataReaderFactory.AddMockedDataReader(_mocks, "predict_withoutentryid", creator, out predictNoEntryIdReader, null);
            DataReaderFactory.AddMockedDataReader(_mocks, "riskmod_processriskassessmentforthreadentry", creator, out processReader, null);
            DataReaderFactory.AddMockedDataReader(_mocks, "predict", creator, out predictReader, null);
            DataReaderFactory.AddMockedDataReader(_mocks, "removehandledbievents", creator, out removeReader, null);
            DataReaderFactory.AddMockedDataReader(_mocks, "moderation", creator, out moderationReader, null);
            DataReaderFactory.AddMockedDataReader(_mocks, "riskmod_recordriskmoddecisionforthreadentry", creator, out recordDecisionReader, null);

            _mocks.ReplayAll();

            var bep = BIEventProcessor.CreateBIEventProcessor(null, creator, creator, 1, false, true, 10);

            bep.Start();
            System.Threading.Thread.Sleep(200);
            bep.Stop();
            bep.WaitWhileHandlingEvent();

            creator.AssertWasCalled(x => x.CreateDnaDataReader("getbievents"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("predict_withoutentryid"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("riskmod_processriskassessmentforthreadentry"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("predict"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("removehandledbievents"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("moderation"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("riskmod_recordriskmoddecisionforthreadentry"));

            // We can't test that any methods are called in "bep" because it is not a mocked object.
            // However this test should ensure 100% code coverage, so at least it exercises the code
        }
    }

    class TestDnaLogger : IDnaLogger
    {
        #region IDnaLogger Members

        public List<Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry> logList = new List<Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry>();

        public void Write(Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry log)
        {
            logList.Add(log);
        }

        #endregion
    }
}
