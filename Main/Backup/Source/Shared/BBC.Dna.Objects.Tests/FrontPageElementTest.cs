using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Objects;


namespace BBC.Dna.Objects.Tests
{
    
    /// <summary>
    ///This is a test class for FrontPageElementTest and is intended
    ///to contain all FrontPageElementTest Unit Tests
    ///</summary>
    [TestClass()]
    public class FrontPageElementTest
    {
        private readonly MockRepository _mocks = new MockRepository();

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateFrontPageElement_ValidRecordset_CorrectTopic()
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

            var actual = new FrontPageElement();
            var result = actual.CreateFrontPageElement(creator, 0, 0);
            Assert.AreEqual(1, actual.Elementid);
            Assert.AreEqual("CreateFrontPageElement", result.Type);
            Assert.AreEqual("Result", result.GetType().Name);
        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateFrontPageElement_NotRead_CorrectError()
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

            var actual = new FrontPageElement();
            var result = actual.CreateFrontPageElement(creator, 0, 0);
            Assert.AreEqual(0, actual.Elementid);
            Assert.AreEqual("CreateFrontPageElement", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);
        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void UpdateFrontPageElements_InvalidValidId_CorrectError()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(0);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createtopic")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);


            _mocks.ReplayAll();

            var actual = new FrontPageElement();
            var result = actual.UpdateFrontPageElements(creator, 0, 0);
            Assert.AreEqual(0, actual.Elementid);
            Assert.AreEqual("UpdateFrontPageElements", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);
        }


        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void UpdateFrontPageElements_NotRead_CorrectError()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("topicid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("TopicElementID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ValidID")).Return(0);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createtopic")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("createtopicelement")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("updatetopicelement")).Return(reader);


            _mocks.ReplayAll();

            var actual = new FrontPageElement();
            var result = actual.UpdateFrontPageElements(creator, 0, 0);
            Assert.AreEqual(0, actual.Elementid);
            Assert.AreEqual("UpdateFrontPageElements", result.Type);
            Assert.AreEqual("Error", result.GetType().Name);
        }

        /// <summary>
        ///A test for TemplateElement
        ///</summary>
        [TestMethod()]
        public void TemplateElement_GetDefined_ReturnsCorrectEnumValue()
        {
            var element = new FrontPageElement();
            element.Template = FrontPageTemplate.ImageAboveText;
            Assert.AreEqual((int)FrontPageTemplate.ImageAboveText, element.TemplateElement);
        }

        /// <summary>
        ///A test for TemplateElement
        ///</summary>
        [TestMethod()]
        public void TemplateElement_GetUndefinedWithImageName_ReturnsCorrectEnumValue()
        {
            var element = new FrontPageElement();
            element.ImageName = "test.jpg";
            element.Template = FrontPageTemplate.UnDefined;
            Assert.AreEqual((int)FrontPageTemplate.ImageAboveText, element.TemplateElement);
        }

        /// <summary>
        ///A test for TemplateElement
        ///</summary>
        [TestMethod()]
        public void TemplateElement_Set_ReturnsCorrectEnumValue()
        {
            var element = new FrontPageElement();
            element.TemplateElement = (int)FrontPageTemplate.ImageAboveText;
            Assert.AreEqual(FrontPageTemplate.ImageAboveText, element.Template);
        }

        /// <summary>
        ///A test for TemplateElement
        ///</summary>
        [TestMethod()]
        public void TemplateElement_SetInvalid_ReturnsUnDefined()
        {
            var element = new FrontPageElement();
            element.TemplateElement = 100;
            
            Assert.AreEqual(FrontPageTemplate.UnDefined, element.Template);
        }
    }
}
