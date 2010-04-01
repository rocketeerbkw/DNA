using System;
using BBC.Dna.Moderation;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using TestUtils;
using System.Xml;
using BBC.Dna.Objects;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for TermsListTest and is intended
    ///to contain all TermsListTest Unit Tests
    ///</summary>
    [TestClass()]
    public class TermsListTest
    {

        public MockRepository Mocks = new MockRepository();

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_AlwaysReturnsTrue()
        {
            var target = new TermsList(); 
            Assert.IsTrue(target.IsUpToDate(null));
            
        }

        /// <summary>
        ///A test for GetTermsListByModClassIdFromDB
        ///</summary>
        [TestMethod]
        public void GetTermsListByModClassIdFromDB_ReadIsFalse_ReturnsEmptyList()
        {

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            Mocks.ReplayAll();

            TermsList actual = TermsList.GetTermsListByModClassIdFromDB(creator, 0);
            Assert.IsNotNull(actual);
            Assert.AreEqual(0, actual.Terms.Count);
        }

        /// <summary>
        ///A test for GetTermsListByModClassIdFromDB
        ///</summary>
        [TestMethod]
        public void GetTermsListByModClassIdFromDB_ReadIsTrue_ReturnsFilled()
        {

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            Mocks.ReplayAll();

            TermsList actual = TermsList.GetTermsListByModClassIdFromDB(creator, 0);
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Terms.Count);
        }

        /// <summary>
        ///A test for GetTermsListByModClassId
        ///</summary>
        [TestMethod]
        public void GetTermsListByModClassId_CachedVersion_ReturnsCachedVersion()
        {
            TermsList expected = GetTermsList();
            string key = expected.GetCacheKey(0);

            //var reader = Mocks.DynamicMock<IDnaDataReader>();
            //reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(key)).Return(expected);

            Mocks.ReplayAll();

            TermsList actual = TermsList.GetTermsListByModClassId(readerCreator, cacheManager, 0, false);
            Assert.AreEqual(expected.Terms.Count, actual.Terms.Count);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static TermsList GetTermsList()
        {
            var expected = new TermsList(1);
            expected.Terms.Add(TermTest.CreateTerm());
            return expected;
        }

        /// <summary>
        ///A test for GetTermsListByModClassId
        ///</summary>
        [TestMethod]
        public void GetTermsListByModClassId_NonCachedVersion_ReturnsCachedVersion()
        {
            var expected = new TermsList();
            expected.Terms.Add(TermTest.CreateTerm());
            string key = expected.GetCacheKey(0);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(key)).Return(null);

            Mocks.ReplayAll();

            TermsList actual = TermsList.GetTermsListByModClassId(readerCreator, cacheManager, 0, false);
            Assert.AreEqual(expected.Terms.Count, actual.Terms.Count);

        }

        [TestMethod]
        public void TermsListSchemaValidation()
        {
            var expected = "<TERMSLIST xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" MODCLASSID=\"0\"><TERM ID=\"0\" ACTION=\"ReEdit\">term</TERM></TERMSLIST>";

            var target = new TermsList{ModClassId = 0};
            target.Terms.Add(TermTest.CreateTerm());

            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("TERMSLIST").OuterXml);

        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_EmptyReason_ReturnsCorrectError()
        {
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.GetInt32NullAsZero("historyId")).Return(1);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterupdate")).Return(historyReader);

            Mocks.ReplayAll();

            IDnaDataReaderCreator readerCreator = null; 
            ICacheManager cacheManager = null; 
            string reason = string.Empty; 
            int userId = 1;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid reason must be supplied" };

            var target = GetTermsList();
            Error actual = target.UpdateTermsInDatabase(readerCreator, cacheManager, reason, userId);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
            
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_EmptyUser_ReturnsCorrectError()
        {
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.GetInt32NullAsZero("historyId")).Return(1);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterupdate")).Return(historyReader);

            Mocks.ReplayAll();

            IDnaDataReaderCreator readerCreator = null;
            ICacheManager cacheManager = null;
            string reason = "a reason";
            int userId = 0;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid user must be supplied" };

            var target = GetTermsList();
            Error actual = target.UpdateTermsInDatabase(readerCreator, cacheManager, reason, userId);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));

        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_HistoryIdIs0_ReturnsCorrectError()
        {
            var cacheManager = Mocks.DynamicMock < ICacheManager>();
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.GetInt32NullAsZero("historyId")).Return(0);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterupdate")).Return(historyReader);

            Mocks.ReplayAll();


            string reason = "a reason";
            int userId = 1;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id" };

            var target = GetTermsList();
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));

        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_CorrectResponse_ReturnsNullError()
        {
            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.GetInt32NullAsZero("historyId")).Return(1);
            historyReader.Stub(x => x.Read()).Return(true).Repeat.Once();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterupdate")).Return(historyReader);
            var getTermsReader = Mocks.DynamicMock<IDnaDataReader>();
            getTermsReader.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(getTermsReader);

            Mocks.ReplayAll();


            string reason = "a reason";
            int userId = 1;

            var target = GetTermsList();
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId);

            Assert.IsNull(actual);
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));

        }

        /// <summary>
        ///A test for UpdateTermsWithHistoryId
        ///</summary>
        [TestMethod()]
        public void UpdateTermsWithHistoryId_InvalidTerms_ReturnsCorrectError()
        {
            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.Read()).Return(false);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(historyReader);

            Mocks.ReplayAll();

            Error expected = new Error { Type = "UpdateTermForModClassId", ErrorMessage = "Term value cannot be empty." + Environment.NewLine + "Term value cannot be empty." };

            var target = new TermsList();
            target.Terms.Add(new Term());//empty is invalid
            target.Terms.Add(new Term());

            var actual = target.UpdateTermsWithHistoryId(creator, cacheManager, 1);
            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);
            
        }

        /// <summary>
        ///A test for UpdateTermsWithHistoryId
        ///</summary>
        [TestMethod()]
        public void UpdateTermsWithHistoryId_InvalidTermWithCorrectTerm_ReturnsCorrectError()
        {
            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.Read()).Return(false);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(historyReader);

            Mocks.ReplayAll();

            Error expected = new Error { Type = "UpdateTermForModClassId", ErrorMessage = "Term value cannot be empty." };

            var target = GetTermsList();
            target.Terms.Add(new Term());//empty is invalid

            var actual = target.UpdateTermsWithHistoryId(creator, cacheManager, 1);
            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

        }

        /// <summary>
        ///A test for UpdateTermsWithHistoryId
        ///</summary>
        [TestMethod()]
        public void UpdateTermsWithHistoryId_CorrectTerm_ReturnsCorrectError()
        {
            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            var getTermsReader = Mocks.DynamicMock<IDnaDataReader>();
            getTermsReader.Stub(x => x.Read()).Return(false);
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("addtermsfilterterm")).Return(Mocks.DynamicMock<IDnaDataReader>());
            creator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(getTermsReader);

            Mocks.ReplayAll();

            var target = GetTermsList();

            var actual = target.UpdateTermsWithHistoryId(creator, cacheManager, 1);
            Assert.IsNull(actual);

        }

        /// <summary>
        ///A test for FilterByTermId
        ///</summary>
        [TestMethod()]
        public void FilterByTermId_WithValidTerms_ReturnsCorrectList()
        {
            TermsList target = new TermsList(); 
            target.Terms.Add(new Term(){Id=1});
            target.Terms.Add(new Term() { Id = 2 });
            int termId = 1; 
            target.FilterByTermId(termId);
            
            Assert.AreEqual(1, target.Terms.Count);
        }
    }
}
