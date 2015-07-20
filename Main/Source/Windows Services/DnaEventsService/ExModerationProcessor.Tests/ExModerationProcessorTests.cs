using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils.Mocks.Extentions;
using BBC.Dna.Data;
using Dna.ExModerationProcessor;

namespace ExModerationProcessor.Tests
{
    [TestClass]
    public class ExModerationProcessorTests
    {
        private IDnaDataReader _mockreader;
        private int _modId = 528737;
        private string _notes = "Blistering barnacles";
        private string _uri = "http://www.ben.bbc.co.uk/reactive";
        private string _uriAsJSON = "http:\\/\\/www.ben.bbc.co.uk\\/reactive";
        private DateTime _completedDate = DateTime.Parse("2015-07-17");
        private string _completedDateAsString = "17\\/07\\/2015 00:00:00";
        private int _decisionId = 4;
        private string _callbackUri = "http://localhost:8089/";
        private string _reasonType = "PoliticalInsert";
        private string _reasonText = "Esta decisión se tomó dado que contiene contenido que puede ser difamatorio.";

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectModIdToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_modId, activity.ModId);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectNotesToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_notes, activity.Notes);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectUriToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_uri, activity.Uri);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectDateCompletedToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_completedDate, activity.DateCompleted);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectDecisionToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_decisionId, activity.Decision);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectCallbackUriToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_callbackUri, activity.CallBackUri);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectReasonTypeToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_reasonType, activity.ReasonType);
        }

        [TestMethod]
        public void ExModerationEvent_BuildExModerationEvents_ExpectReasonTextToBeCorrect()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(0);
            _mockreader.Stub(c => c.GetString("notes")).Return(null);
            _mockreader.Stub(c => c.GetString("uri")).Return(null);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(DateTime.MinValue);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(0);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            Assert.AreEqual(_reasonText, activity.ReasonText);
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectModIdToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"id\":" + _modId.ToString()));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectNotesToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"notes\":\"" + _notes + "\""));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectStatusToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();
            string statusValue = Enum.GetName(typeof(ModDecisionEnum), _decisionId);

            Assert.IsTrue(json.Contains("\"status\":\"" + statusValue + "\""));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectUriToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"uri\":\"" + _uriAsJSON + ""));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectDateCompletedToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"datecompleted\":\"" + _completedDateAsString + "\""));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectReasonTypeToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"reasontype\":\"" + _reasonType + "\""));
        }

        /// <remarks>
        /// To ensure backwards compatibility, we need to return empty string for reasontype for those moderation items failed with  
        /// a reason before fix for MYMODCOMM-892 was rolled out
        /// </remarks>
        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectReasonTypeToBeSentEvenIfFailedModerationItemHadNoReasonTypeStoredInDatabase()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"reasontype\":\"\""));
        }

        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectReasonTextToBeSent()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(_reasonType);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(_reasonText);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"reasontext\":\"" + _reasonText + "\""));
        }

        /// <remarks>
        /// To ensure backwards compatibility, we need to return empty string for reasontext for those moderation items failed with  
        /// a reason before fix for MYMODCOMM-892 was rolled out
        /// </remarks>
        [TestMethod]
        public void ExModerationEvent_SendExModerationEvents_ExpectReasonTextToBeSentEvenIfFailedModerationItemHadNoReasonTextStoredInDatabase()
        {
            _mockreader = MockRepository.GenerateStub<IDnaDataReader>();

            _mockreader.Stub(c => c.GetInt32NullAsZero("modid")).Return(_modId);
            _mockreader.Stub(c => c.GetString("notes")).Return(_notes);
            _mockreader.Stub(c => c.GetString("uri")).Return(_uri);
            _mockreader.Stub(c => c.GetDateTime("datecompleted")).Return(_completedDate);
            _mockreader.Stub(c => c.GetInt32NullAsZero("status")).Return(_decisionId);
            _mockreader.Stub(c => c.GetString("callbackuri")).Return(_callbackUri);
            _mockreader.Stub(c => c.GetString("reasontype")).Return(null);
            _mockreader.Stub(c => c.GetString("reasontext")).Return(null);

            ExModerationEvent activity = new ExModerationEvent();
            activity = ExModerationEvent.CreateExModerationEvent(_mockreader);

            string json = activity.ToJSON();

            Assert.IsTrue(json.Contains("\"reasontext\":\"\""));
        }

        private class ExModerationEventTestDatabaseRow : DataReaderFactory.TestDatabaseRow
        {
            public ExModerationEventTestDatabaseRow() { }

            /// <summary>
            /// ExModerationEventTestDatabaseRow
            /// </summary>
            /// <remarks>
            /// The params should match the result set from getexmoderationevents.sql
            /// </remarks>
            public static DataReaderFactory.TestDatabaseRow CreateExModerationEvent(int modId, string uri, string callbackUri, string notes, int status, DateTime dateCompleted, string reasonType, string reasonText)
            {
                var row = new ExModerationEventTestDatabaseRow();

                row.AddGetNullableInt32ColumnValue("modid", modId);
                row.AddGetStringColumnValue("uri", uri);
                row.AddGetStringColumnValue("callbackuri", callbackUri);
                row.AddGetStringColumnValue("notes", notes);
                row.AddGetNullableInt32ColumnValue("status", status);
                row.AddGetDateTimeColumnValue("datecompleted", dateCompleted);
                row.AddGetStringColumnValue("reasontype", reasonType);
                row.AddGetStringColumnValue("reasontext", reasonText);

                return row;
            }
        }
    }
}
