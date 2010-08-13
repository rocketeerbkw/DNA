using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Rhino.Mocks;
using BBC.Dna.Utils;
using System;
using Rhino.Mocks.Constraints;
using System.Collections.Generic;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Collections.Specialized;

namespace BBC.Dna.Sites.Tests
{
    
    
    /// <summary>
    ///This is a test class for SiteListTest and is intended
    ///to contain all SiteListTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SiteListTest
    {
        public MockRepository mocks = new MockRepository();

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_NoRows_ReturnsNothing()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader);

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            
            
            Assert.AreEqual(0, target.Ids.Count);
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_DbException_ThrowsCorrectException()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Throw(new Exception("test exception"));
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader);

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            
            Assert.AreEqual(0, target.Ids.Count);
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_ValidRecordsetMultipleSkins_ReturnsSitesAndSkins()
        {
            var mockedReader = mocks.DynamicMock<IDnaDataReader>();
            mockedReader.Stub(x => x.HasRows).Return(true);
            mockedReader.Stub(x => x.GetInt32("SiteID")).Return(1);
            mockedReader.Stub(x => x["URLName"]).Return("h2g2");
            var queue = new Queue<string>();
            queue.Enqueue("skin1");
            queue.Enqueue("skin2");
            mockedReader.Stub(x => x.GetStringNullAsEmpty("SkinName")).Return("").WhenCalled(x => x.ReturnValue = queue.Dequeue());
            mockedReader.Stub(x => x.Read()).Return(true).Repeat.Twice();

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(mockedReader);
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            
            Assert.AreEqual(1, target.Ids.Count);
            Assert.IsTrue(target.Ids[1].DoesSkinExist("skin1"));
            Assert.IsTrue(target.Ids[1].DoesSkinExist("skin2"));
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_ValidKidsRecordset_ReturnsSingleSite()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x["URLName"]).Return("h2g2");
            reader.Stub(x => x["config"]).Return("");
            reader.Stub(x => x.GetString("config")).Return("");
            reader.Stub(x => x.Exists("UseIdentitySignIn")).Return(true);
            reader.Stub(x => x.GetTinyIntAsInt("UseIdentitySignIn")).Return(1);
            reader.Stub(x => x.Exists("IsKidsSite")).Return(true);
            reader.Stub(x => x.GetTinyIntAsInt("IsKidsSite")).Return(1);
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);

            Assert.AreEqual(1, target.Ids.Count);
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteIdNotExist_ReturnsNull()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null); 
            Assert.IsNull(target.GetSite(0));
            diag.AssertWasCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site id. "));
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteNameNotExist_ReturnsNull()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            Assert.IsNull(target.GetSite(""));
            diag.AssertWasCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site name. "));
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteIdExist_ReturnsValidObject()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            ISite site = target.GetSite(1);
            Assert.IsNotNull(site);
            Assert.AreEqual("h2g2", site.SiteName);
            diag.AssertWasNotCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site id. "));
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteNameExist_ReturnsValidObject()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag, cache, null, null);
            ISite site = target.GetSite("h2g2");
            Assert.IsNotNull(site);
            Assert.AreEqual(1, site.SiteID);
            diag.AssertWasNotCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site id. "));
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteList_WithOptions_LogsCorrectly()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader readerOptions = mocks.DynamicMock<IDnaDataReader>();
            readerOptions.Stub(x => x.Read()).Return(false);
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(readerOptions);
            

            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);

            diag.AssertWasCalled(x => x.WriteTimedEventToLog("SiteList.LoadSiteList", "Loading sitelist for all sites"));
            diag.AssertWasCalled(x => x.WriteTimedEventToLog("SiteList.LoadSiteList", "Completed loading sitelist for all sites"));
   
        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueInt_WithValidOption_ReturnsCorrectValue()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetIntSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            Assert.AreEqual(1, target.GetSiteOptionValueInt(1, "test", "test"));

        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueString_WithValidOption_ReturnsCorrectValue()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetStringSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            Assert.AreEqual("1", target.GetSiteOptionValueString(1, "test", "test"));

        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueBool_WithValidOption_ReturnsCorrectValue()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            Assert.AreEqual(true, target.GetSiteOptionValueBool(1, "test", "test"));

        }


        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionListForSite_WithValidOptions_ReturnsCorrectValue()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            List<SiteOption> optionList = target.GetSiteOptionListForSite(1);
            Assert.IsNotNull(optionList);
            Assert.AreEqual(1, optionList.Count);

        }


        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void GetSiteList_WithoutCache_ReturnsCorrectList()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, null,
                null);

            ISiteList actual = SiteList.GetSiteList();
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Ids.Count);
        }


        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void HandleSignal_CorrectSignalNoSiteId_RefreshesAllSites()
        {
            var reader = GetSiteListMockReader();
            var reader2 = GetSiteListMockReader2();
            var readerQueue = new Queue<IDnaDataReader>();
            readerQueue.Enqueue(reader);
            readerQueue.Enqueue(reader2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader).WhenCalled(x => x.ReturnValue = readerQueue.Dequeue());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();

            NameValueCollection args =null;

            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, null, null);
            mocks.ReplayAll();

            Assert.IsTrue(siteList.HandleSignal(siteList.SignalKey, args));
            reader.AssertWasNotCalled(x => x.AddParameter("@siteid", 0));
        }


        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void HandleSignal_InCorrectSignal_ReturnsFalse()
        {
            var reader = GetSiteListMockReader();
            var reader2 = GetSiteListMockReader2();
            var readerQueue = new Queue<IDnaDataReader>();
            readerQueue.Enqueue(reader);
            readerQueue.Enqueue(reader2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader).WhenCalled(x => x.ReturnValue = readerQueue.Dequeue());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();

            NameValueCollection args = null;

            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, null, null);
            mocks.ReplayAll();

            Assert.IsFalse(siteList.HandleSignal(siteList.SignalKey+ "not the key", args));
            
        }

        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void HandleSignal_CorrectSignalWithSiteId_RefreshesIndividualSite()
        {
            var reader = GetSiteListMockReader();
            var reader2 = GetSiteListMockReader2();
            var readerQueue = new Queue<IDnaDataReader>();
            readerQueue.Enqueue(reader);
            readerQueue.Enqueue(reader2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();

            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader).WhenCalled(x => x.ReturnValue = readerQueue.Dequeue());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();

            NameValueCollection args = new NameValueCollection();
            args.Add("siteid", "1");

            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, null, null);
            mocks.ReplayAll();

            Assert.IsTrue(siteList.HandleSignal(siteList.SignalKey, args));
            reader2.AssertWasCalled(x => x.AddParameter("@siteid", 1));
        }

        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void GetSiteList_WithoutIgnoreCache_ReturnsCorrectList()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, null, null);
            ISiteList actual = SiteList.GetSiteList();
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Ids.Count);
        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void IsMessageboard_WithValidOption_ReturnsTrue()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("Type")).Return(1);
            reader.Stub(x => x.GetString("Value")).Return("1");
            reader.Stub(x => x.GetString("Section")).Return("General");
            reader.Stub(x => x.GetString("Name")).Return("IsMessageboard");
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x.GetString("description")).Return("IsMessageboard");
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(reader);

            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag, cache, null, null);
            

            Assert.IsTrue(target.IsMessageboard(1));

        }

        [TestMethod]
        public void SendSignal_WithoutSiteId_SendsCorrectSignals()
        {
            var url = "1.0.0.1";
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            List<string> servers = new List<string>() { url };


            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, servers, servers);
            ISiteList actual = SiteList.GetSiteList();
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Ids.Count);

            siteList.SendSignal();
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/signal?action=recache-site", url)));
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/dnasignal?action=recache-site", url)));
        }

        [TestMethod]
        public void SendSignal_WithSiteId_SendsCorrectSignals()
        {
            var url = "1.0.0.1";
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            List<string> servers = new List<string>() { url };


            mocks.ReplayAll();

            var siteList = new SiteList(creator, diag, cache, servers, servers);
            ISiteList actual = SiteList.GetSiteList();
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Ids.Count);

            var siteId = 1;
            siteList.SendSignal(siteId);
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/signal?action=recache-site&siteid={1}", url, siteId)));
            diag.AssertWasCalled(x => x.WriteToLog("SendingSignal", string.Format("http://{0}/dna/h2g2/dnasignal?action=recache-site&siteid={1}", url, siteId)));
        }

        [TestMethod]
        public void GetSiteStats_GetsValidStats_ReturnsValidObject()
        {
            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();


            mocks.ReplayAll();

            SiteList siteList = new SiteList(creator, diag, cache, null, null);

            var stats = siteList.GetStats();
            Assert.IsNotNull(stats);
            Assert.AreEqual(typeof(SiteListCache).AssemblyQualifiedName, stats.Name);
            Assert.AreEqual(siteList.GetCachedObject().Ids.Count.ToString(), stats.Values["NumberOfSites"]);
            Assert.AreEqual(siteList.GetCachedObject().SiteOptionList.GetAllOptions().Count.ToString(), stats.Values["NumberOfSiteOptions"]);
            
        }




        private IDnaDataReader GetSiteListMockReader()
        {

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x["URLName"]).Return("h2g2");
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            return reader;
        }

        private IDnaDataReader GetSiteListMockReader2()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32("SiteID")).Return(1);
            reader.Stub(x => x["URLName"]).Return("h2g2calledagain");
            reader.Stub(x => x.GetStringNullAsEmpty("SkinName")).Return("skin2");
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            return reader;
        }

        private IDnaDataReader GetReviewForumsMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(1);
            return reader;
        }

        private IDnaDataReader GetKeyArticleListMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(1);
            return reader;
        }

        private IDnaDataReader GetSiteOpenCloseTimesMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            reader.Stub(x => x.GetByte("")).Constraints(Is.Anything()).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(1);

            return reader;
        }

        private IDnaDataReader GetSiteTopicsMockReader()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetStringNullAsEmpty("")).Constraints(Is.Anything()).Return("");
            reader.Stub(x => x.GetByte("")).Constraints(Is.Anything()).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(1);

            return reader;
        }
       
    }
}
