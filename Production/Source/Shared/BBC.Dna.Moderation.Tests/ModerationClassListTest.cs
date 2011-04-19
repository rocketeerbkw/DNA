using System.Collections.ObjectModel;
using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Rhino.Mocks;
using System.Xml;
using TestUtils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Utils;
using Rhino.Mocks.Constraints;
using BBC.Dna.Common;

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

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            var diag = Mocks.DynamicMock<IDnaDiagnostics>();

            Mocks.ReplayAll();

            var actual = new ModerationClassListCache(readerCreator, diag, cache, null, null); ;
            Assert.IsNotNull(actual);
            Assert.AreEqual(0, actual.GetObjectFromCache().ModClassList.Count);
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

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            var diag = Mocks.DynamicMock<IDnaDiagnostics>();


            Mocks.ReplayAll();

            var actual = new ModerationClassListCache(readerCreator, diag, cache, null, null); ;
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.GetObjectFromCache().ModClassList.Count);
        }

        /// <summary>
        ///A test for GetAllModerationClassesFromDb
        ///</summary>
        [TestMethod()]
        public void ModerationClassesXml()
        {
            ModerationClassList moderationClassList = GetModerationClassList();


            var expected = "<MODERATION-CLASSES xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><MODERATION-CLASS CLASSID=\"1\"><NAME>test</NAME><DESCRIPTION>test</DESCRIPTION><ITEMRETRIEVALTYPE>Standard</ITEMRETRIEVALTYPE></MODERATION-CLASS></MODERATION-CLASSES>";

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

        public static ModerationClassListCache InitialiseClasses()
        {
            MockRepository _mocks = new MockRepository();
            var cacheObj = GetModerationClassList();

            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains(ModerationClassListCache.GetCacheKey("LASTUPDATE"))).Return(false);
            cache.Stub(x => x.Contains(ModerationClassListCache.GetCacheKey())).Return(true);
            cache.Stub(x => x.GetData(ModerationClassListCache.GetCacheKey())).Return(cacheObj);

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);


            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var tmp =  new ModerationClassListCache(creator, diag, cache, null, null);
            SignalHelper.AddObject(typeof(ModerationClassListCache), tmp);
            return tmp;
        }
    }
}
