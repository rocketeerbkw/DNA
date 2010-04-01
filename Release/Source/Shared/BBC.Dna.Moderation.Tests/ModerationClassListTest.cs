using System.Collections.ObjectModel;
using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Rhino.Mocks;
using System.Xml;
using TestUtils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for ModerationClassListTest and is intended
    ///to contain all ModerationClassListTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ModerationClassListTest
    {
        public MockRepository Mocks = new MockRepository();

        

        /// <summary>
        ///A test for GetAllModerationClassesFromDb
        ///</summary>
        [TestMethod()]
        public void GetAllModerationClassesFromDb_NoReads_ReturnsEmptyList()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

            Mocks.ReplayAll();

            ModerationClassList actual = ModerationClassList.GetAllModerationClassesFromDb(readerCreator);
            Assert.IsNotNull(actual);
            Assert.AreEqual(0, actual.ModClassList.Count);
        }

        /// <summary>
        ///A test for GetAllModerationClassesFromDb
        ///</summary>
        [TestMethod()]
        public void GetAllModerationClassesFromDb_WithReads_ReturnsCorrect()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

            Mocks.ReplayAll();

            ModerationClassList actual = ModerationClassList.GetAllModerationClassesFromDb(readerCreator);
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.ModClassList.Count);
        }

        /// <summary>
        ///A test for GetAllModerationClassesFromDb
        ///</summary>
        [TestMethod()]
        public void ModerationClassesXml()
        {
            ModerationClassList moderationClassList = GetModerationClassList();
            

            var expected = "<MODERATION-CLASSES xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><MODERATION-CLASS CLASSID=\"0\"><NAME>test</NAME><DESCRIPTION>test</DESCRIPTION></MODERATION-CLASS></MODERATION-CLASSES>";

            XmlDocument xml = Serializer.SerializeToXml(moderationClassList);
            Assert.AreEqual(expected, xml.SelectSingleNode("MODERATION-CLASSES").OuterXml);
        }

        /// <summary>
        /// returns test object
        /// </summary>
        /// <returns></returns>
        public static ModerationClassList GetModerationClassList()
        {
            ModerationClassList moderationClassList = new ModerationClassList{ModClassList = new Collection<ModerationClass>()};
            moderationClassList.ModClassList.Add(ModerationClassTest.GetModClass());
            return moderationClassList;
        }

        /// <summary>
        ///A test for GetAllModerationClasses
        ///</summary>
        [TestMethod()]
        public void GetAllModerationClasses_InCache_ReturnsCachedObject()
        {

            ModerationClassList expected = GetModerationClassList();
            string key = expected.GetCacheKey();

            //var reader = Mocks.DynamicMock<IDnaDataReader>();
            //reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(key)).Return(expected);

            Mocks.ReplayAll();

            ModerationClassList actual  = ModerationClassList.GetAllModerationClasses(readerCreator, cacheManager, false);
            Assert.AreEqual(expected.ModClassList.Count, actual.ModClassList.Count);
            Assert.AreEqual(expected.ModClassList[0].Name, actual.ModClassList[0].Name);
            Assert.IsTrue(expected.IsUpToDate(readerCreator));//just for coverage
        }

        /// <summary>
        ///A test for GetAllModerationClasses
        ///</summary>
        [TestMethod()]
        public void GetAllModerationClasses_NotInCache_ReturnsDBObject()
        {

            ModerationClassList expected = GetModerationClassList();
            string key = expected.GetCacheKey();

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(key)).Return(null);

            Mocks.ReplayAll();

            ModerationClassList actual = ModerationClassList.GetAllModerationClasses(readerCreator, cacheManager, false);
            Assert.AreEqual(1, actual.ModClassList.Count);
            
        }
    }
}
