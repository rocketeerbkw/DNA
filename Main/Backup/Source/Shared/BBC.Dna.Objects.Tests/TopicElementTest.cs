using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using System;

namespace BBC.Dna.Objects.Tests
{

    /// <summary>
    ///This is a test class for TopicElementTest and is intended
    ///to contain all TopicElementTest Unit Tests
    ///</summary>
    [TestClass()]
    public class TopicElementTest
    {
        private readonly MockRepository _mocks = new MockRepository();

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateTopic_ValidRecordset_CorrectTopic()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("itopicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(1);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createtopic")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);
            
            
            _mocks.ReplayAll();

            var actual = new TopicElement();
            var result = actual.CreateTopic(creator, 0, 0);
            Assert.AreEqual(1, actual.TopicId);
            Assert.AreEqual("UpdateFrontPageElements", result.Type);
            Assert.AreEqual("Result", result.GetType().Name);

        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateTopic_NoRead_CorrectError()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(1);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createtopic")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);


            _mocks.ReplayAll();

            var actual = new TopicElement();
            var result = actual.CreateTopic(creator, 0, 0);
            Assert.AreEqual(0, actual.TopicId);
            Assert.AreEqual("CreateTopic", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);

        }


        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void UpdateTopic_ValidRecordset_CorrectTopic()
        {
            var guid = Guid.NewGuid();
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidEditKey")).Return(2);
            

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("edittopic2")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);
            reader.Stub(x => x.GetGuid("NewEditKey")).Return(guid);


            _mocks.ReplayAll();

            var actual = new TopicElement();
            var result = actual.UpdateTopic(creator, 0);
            Assert.AreEqual(guid, actual.Editkey);
            Assert.AreEqual("UpdateFrontPageElements", result.Type);
            Assert.AreEqual("Result", result.GetType().Name);

        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void UpdateTopic_NoRead_CorrectTopic()
        {
            var guid = Guid.NewGuid();

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidEditKey")).Return(2);
            reader.Stub(x => x.GetGuid("NewEditKey")).Return(guid);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("edittopic2")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);


            _mocks.ReplayAll();

            var actual = new TopicElement();
            var result = actual.UpdateTopic(creator, 0);
            Assert.AreNotEqual(guid, actual.Editkey);
            Assert.AreEqual("UpdateTopic", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);

        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void UpdateTopic_InvalidEditKey_CorrectTopic()
        {
            var guid = Guid.NewGuid();

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidEditKey")).Return(0);
            reader.Stub(x => x.GetGuid("NewEditKey")).Return(guid);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("edittopic2")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);


            _mocks.ReplayAll();

            var actual = new TopicElement();
            var result = actual.UpdateTopic(creator, 0);
            Assert.AreNotEqual(guid, actual.Editkey);
            Assert.AreEqual("UpdateTopic", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);

        }

        [TestMethod]
        public void DescriptionElement_EmptyDescription_ReturnsValidGuideML()
        {
            var topic = new TopicElement();
            topic.Description = string.Empty;

            Assert.AreEqual("<GUIDE><BODY></BODY></GUIDE>", topic.DescriptionElement.OuterXml);
        }

        [TestMethod]
        public void DescriptionElement_NonEmptyDescription_ReturnsValidGuideML()
        {
            var topic = new TopicElement();
            topic.Description = "<GUIDE><BODY>test</BODY></GUIDE>";

            Assert.AreEqual("<GUIDE><BODY>test</BODY></GUIDE>", topic.DescriptionElement.OuterXml);
        }

        [TestMethod]
        public void MakePreviewTopicsActiveForSiteID_ValidResponse_CorrectResult()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(true);
            var reader2 = _mocks.DynamicMock<IDnaDataReader>();
            reader2.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(true);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicsActiveForSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicElementsActive")).Return(reader2);
            


            _mocks.ReplayAll();

            var result = TopicElement.MakePreviewTopicsActiveForSiteID(creator, 0 ,0);
            Assert.AreEqual("Result", result.GetType().Name);
            Assert.AreEqual("MakePreviewTopicsActiveForSiteID", result.Type);
        }

        [TestMethod]
        public void MakePreviewTopicsActiveForSiteID_NoResponseForTopics_CorrectError()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(false);
            var reader2 = _mocks.DynamicMock<IDnaDataReader>();
            reader2.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(true);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicsActiveForSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicElementsActive")).Return(reader2);


            _mocks.ReplayAll();

            var result = TopicElement.MakePreviewTopicsActiveForSiteID(creator, 0, 0); 
            Assert.AreEqual("Error", result.GetType().Name);
            Assert.AreEqual("MakePreviewTopicsActiveForSiteID", result.Type);
        }

       
        [TestMethod]
        public void MakePreviewTopicsActiveForSiteID_InvalidResponseForTopics_CorrectError()
        {
            var retVal = 0;
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(3).Return(true);
            var reader2 = _mocks.DynamicMock<IDnaDataReader>();
            reader2.Stub(x => x.TryGetIntReturnValue(out retVal)).OutRef(0).Return(true);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicsActiveForSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("MakePreviewTopicElementsActive")).Return(reader2);



            _mocks.ReplayAll();

            var result = TopicElement.MakePreviewTopicsActiveForSiteID(creator, 0, 0); 
            Assert.AreEqual("Error", result.GetType().Name);
            Assert.AreEqual("MakePreviewTopicsActiveForSiteID", result.Type);
        }

        
    }
}
