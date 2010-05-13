using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for TopicListEditTest and is intended
    ///to contain all TopicListEditTest Unit Tests
    ///</summary>
    [TestClass]
    public class TopicListEditTest
    {
        private readonly MockRepository _mocks = new MockRepository();

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void GetTopicListFromDatabase_ValidRecordset_CorrectNumberOfTopics()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            _mocks.ReplayAll();

            var actual = TopicElementList.GetTopicListFromDatabase(creator, 0, TopicStatus.Preview, false);
            Assert.AreEqual(1, actual.Topics.Count);
        }

        [TestMethod]
        public void GetTopicListFromDatabase_ValidGuidMLDescription_CorrectNumberOfTopics()
        {
            var guideXml = "<GUIDE><BODY>golf</BODY></GUIDE>";
            var xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(guideXml);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("description")).Return(guideXml);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            _mocks.ReplayAll();

            var actual = TopicElementList.GetTopicListFromDatabase(creator, 0, TopicStatus.Preview, true);
            Assert.AreEqual(1, actual.Topics.Count);
            Assert.AreEqual(guideXml, actual.Topics[0].Description);
            Assert.AreEqual(xmlDoc.InnerXml, actual.Topics[0].DescriptionElement.OuterXml);
        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void GetTopicListFromDatabase_NoResults_CorrectNumberOfTopics()
        {
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            _mocks.ReplayAll();

            var actual = TopicElementList.GetTopicListFromDatabase(creator, 0, TopicStatus.Preview, false);
            Assert.AreEqual(0, actual.Topics.Count);
        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void GetTopicElementById_WithElement_ReturnsNotNull()
        {
            var list = new TopicElementList();
            list.Topics.Add(new TopicElement { TopicId = 1 });
            list.Topics.Add(new TopicElement { TopicId = 2 });

            var topicFound = list.GetTopicElementById(1);
            Assert.AreEqual(1, topicFound.TopicId);
        }

        /// <summary>
        ///A test for GetTopicListFromDatabase
        ///</summary>
        [TestMethod]
        public void GetTopicElementById_WithoutElement_ReturnsNull()
        {
            var list = new TopicElementList();
            list.Topics.Add(new TopicElement { TopicId = 1 });
            list.Topics.Add(new TopicElement { TopicId = 2 });

            var topicFound = list.GetTopicElementById(4);
            Assert.IsNull(topicFound);
        }

        
    }
}