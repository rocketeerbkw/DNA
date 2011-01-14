using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
using System;
using System.Collections.Generic;
using Rhino.Mocks;
using TestUtils.Mocks.Extentions;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using TestUtils;
using BBC.Dna.Sites;
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for ForumSourceTest and is intended
    ///to contain all ForumSourceTest Unit Tests
    ///</summary>
    [TestClass]
    public class FrontPageTopicElementListTests
    {
        private MockRepository mocks = new MockRepository();


        /// <summary>
        ///A test for ForumSourceTest
        ///</summary>
        [TestMethod]
        public void GetFrontPageElementListFromCache_NoCache_ReturnsDBItem()
        {
            int siteId=1;
            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null);

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            mocks.ReplayAll();


            var frontPageList = FrontPageTopicElementList.GetFrontPageElementListFromCache(creator, TopicStatus.Live, false, cache, DateTime.Now, false, siteId);
            Assert.AreEqual(frontPageList.Status , TopicStatus.Live);
            Assert.AreEqual(1, frontPageList.Topics.Count);
        }

        [TestMethod]
        public void GetFrontPageElementListFromCache_ValidCacheStatusNotLive_ReturnsDBItem()
        {
            int siteId = 1;
            DateTime lastUpdate = DateTime.Now;
            TopicStatus status = TopicStatus.Preview;

            var obj = GenerateFrontPageTopicElementListObj(status, lastUpdate);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(obj);


            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            mocks.ReplayAll();


            var frontPageList = FrontPageTopicElementList.GetFrontPageElementListFromCache(creator, status, false, cache, lastUpdate, false, siteId);
            Assert.AreEqual(frontPageList.Status, status);
            Assert.AreEqual(1, frontPageList.Topics.Count);
        }

        [TestMethod]
        public void GetFrontPageElementListFromCache_OldCache_ReturnsDBItem()
        {
            int siteId = 1;
            DateTime lastUpdate = DateTime.Now;
            TopicStatus status = TopicStatus.Live;

            var obj = GenerateFrontPageTopicElementListObj(status, lastUpdate);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(obj);


            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            mocks.ReplayAll();


            var frontPageList = FrontPageTopicElementList.GetFrontPageElementListFromCache(creator, status, false, cache, DateTime.MaxValue, false, siteId);
            Assert.AreEqual(frontPageList.Status, status);
            Assert.AreEqual(1, frontPageList.Topics.Count);
            Assert.AreNotEqual(obj.Topics[0].Title, frontPageList.Topics[0].Title);
        }

        [TestMethod]
        public void GetFrontPageElementListFromCache_WithIgnoreCache_ReturnsDBItem()
        {
            int siteId = 1;
            DateTime lastUpdate = DateTime.Now;
            TopicStatus status = TopicStatus.Live;

            var obj = GenerateFrontPageTopicElementListObj(status, lastUpdate);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(obj);


            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            mocks.ReplayAll();


            var frontPageList = FrontPageTopicElementList.GetFrontPageElementListFromCache(creator, status, false, cache, lastUpdate, true, siteId);
            Assert.AreEqual(frontPageList.Status, status);
            Assert.AreEqual(1, frontPageList.Topics.Count);
            Assert.AreNotEqual(obj.Topics[0].Title, frontPageList.Topics[0].Title);
        }

        [TestMethod]
        public void GetFrontPageElementListFromCache_ValidCacheStatusAsLive_ReturnsCache()
        {
            int siteId = 1;
            DateTime lastUpdate = DateTime.Now;
            TopicStatus status = TopicStatus.Live;

            var obj = GenerateFrontPageTopicElementListObj(status, lastUpdate);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(obj);


            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettopicsforsiteid2")).Return(reader);
            mocks.ReplayAll();


            var frontPageList = FrontPageTopicElementList.GetFrontPageElementListFromCache(creator, status, false, cache, lastUpdate, false, siteId);
            Assert.AreEqual(frontPageList.Status, status);
            Assert.AreEqual(1, frontPageList.Topics.Count);
            Assert.AreEqual(obj.Topics[0].Title, frontPageList.Topics[0].Title);
        }

        private FrontPageTopicElementList GenerateFrontPageTopicElementListObj(TopicStatus status, DateTime lastUpdated)
        {
            var frontPageTopicElementList = new FrontPageTopicElementList()
            {
                Status = status,
                LastUpdated = lastUpdated
            };
            frontPageTopicElementList.Topics.Add(new FrontPageElement()
            {
                Title = "test"
            });

            return frontPageTopicElementList;
        }

    }
}
