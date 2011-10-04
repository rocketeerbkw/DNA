using BBC.Dna.Moderation;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Objects;
using Rhino.Mocks;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for TermsListsTest and is intended
    ///to contain all TermsListsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class TermsListsTest
    {
        public MockRepository Mocks = new MockRepository();


        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_WithoutReason_ReturnsCorrectError()
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
            string reason = string.Empty; 
            int userId = 0;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid reason must be supplied" };

            TermsLists target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsList());
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, true);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            Error forumActual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, false);
            Assert.AreEqual(expected.ErrorMessage, forumActual.ErrorMessage);
            Assert.AreEqual(expected.Type, forumActual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_WithoutUser_ReturnsCorrectError()
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
            int userId = 0;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Valid user must be supplied" };

            TermsLists target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsList());
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, true);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            Error forumActual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, false);

            Assert.AreEqual(expected.ErrorMessage, forumActual.ErrorMessage);
            Assert.AreEqual(expected.Type, forumActual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_WithoutHistoryIdReturned_ReturnsCorrectError()
        {
            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            var historyReader = Mocks.DynamicMock<IDnaDataReader>();
            historyReader.Stub(x => x.GetInt32NullAsZero("historyId")).Return(0);
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
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id" };

            TermsLists target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsList());
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, true);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            Error forumActual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, false);

            Assert.AreEqual(expected.ErrorMessage, forumActual.ErrorMessage);
            Assert.AreEqual(expected.Type, forumActual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_CorrectValue_ReturnsNullError()
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
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id" };

            TermsLists target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsList());
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, true);

            Assert.IsNull(actual);

            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }


        /// <summary>
        ///A test for UpdateTermsInDatabase By ForumId
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabaseForumSpecific_CorrectValue_ReturnsNullError()
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
            creator.Stub(x => x.CreateDnaDataReader("gettermsbyforumid")).Return(getTermsReader);

            Mocks.ReplayAll();
            string reason = "a reason";
            int userId = 1;
            Error expected = new Error { Type = "UpdateTermsInDatabase", ErrorMessage = "Unable to get history id" };

            TermsLists target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsListForAForum());
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, false);

            Assert.AreEqual(actual.ErrorMessage, "Object reference not set to an instance of an object.");
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabase_InvalidTerms_ReturnsCorrectError()
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
            Error expected = new Error { Type = "UpdateTermForModClassId", ErrorMessage = "Term value cannot be empty./r/nTerm value cannot be empty." };

            var termsList = new TermsList(1);
            termsList.Terms.Add(new Term());
            TermsLists target = new TermsLists();
            target.Termslist.Add(termsList);
            target.Termslist.Add(termsList);
            Error actual = target.UpdateTermsInDatabase(creator, cacheManager, reason, userId, true);

            Assert.AreEqual(expected.ErrorMessage, actual.ErrorMessage);
            Assert.AreEqual(expected.Type, actual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }

        /// <summary>
        ///A test for UpdateTermsInDatabase Forum Specific
        ///</summary>
        [TestMethod()]
        public void UpdateTermsInDatabaseForumSpecific_InvalidTerms_ReturnsCorrectError()
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

            creator.Stub(x => x.CreateDnaDataReader("gettermsbyforumid")).Return(getTermsReader);

            Mocks.ReplayAll();
            string forumReason = "a forum specific reason";
            int forumUserId = 3;
            Error forumExpected = new Error { Type = "UpdateTermForForumId", ErrorMessage = "Term value cannot be empty./r/nTerm value cannot be empty." };


            var termsForumList = new TermsList(1, false, true);
            termsForumList.Terms.Add(new Term());
            TermsLists targetForum = new TermsLists();
            targetForum.Termslist.Add(termsForumList);
            targetForum.Termslist.Add(termsForumList);
            Error forumActual = targetForum.UpdateTermsInDatabase(creator, cacheManager, forumReason, forumUserId, false);

            Assert.AreEqual(forumExpected.ErrorMessage, forumActual.ErrorMessage);
            Assert.AreEqual(forumExpected.Type, forumActual.Type);

            creator.AssertWasNotCalled(x => x.CreateDnaDataReader("addtermsfilterterm"));
            creator.AssertWasCalled(x => x.CreateDnaDataReader("addtermsfilterupdate"));
        }

        /// <summary>
        ///A test for GetAllTermsLists
        ///</summary>
        [TestMethod()]
        public void GetAllTermsListsTest()
        {
            var expected = new TermsList();
            expected.Terms.Add(TermTest.CreateTerm());
            string key = expected.GetCacheKey(0);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("gettermsbymodclassid")).Return(reader);

            var cacheManager = Mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData(key)).Return(null);

            Mocks.ReplayAll();


            int[] modClassIds = {1,2}; 
            TermsLists actual = TermsLists.GetAllTermsLists(readerCreator, cacheManager, modClassIds, false);
            Assert.AreEqual(2, actual.Termslist.Count);

        }

        /// <summary>
        ///A test for FilterListByTermId
        ///</summary>
        [TestMethod()]
        public void FilterListByTermIdTest()
        {
            var term = new Term(){Id=1};
            var termsList = new TermsList(1);
            termsList.Terms.Add(term);

            var target = new TermsLists();
            target.Termslist.Add(TermsListTest.GetTermsList());
            target.Termslist.Add(termsList);
            
            target.FilterListByTermId(1);
            Assert.AreEqual(1, target.Termslist.Count);

        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_AlwaysReturnsTrue()
        {
            var target = new TermsLists(); 
            Assert.IsFalse(target.IsUpToDate(null));
        }
    }
}

