using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Rhino.Mocks;
using BBC.Dna.Utils;
using System;
using Rhino.Mocks.Constraints;
using System.Collections.Generic;

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
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader);
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(0);

            Assert.AreEqual(0, target.Names.Count);
            Assert.AreEqual(0, target.Ids.Count);
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_DbException_ThrowsCorrectException()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute()).Throw(new Exception("test exception"));
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(reader);
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(0);

            Assert.AreEqual(0, target.Names.Count);
            Assert.AreEqual(0, target.Ids.Count);
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_ValidRecordset_ReturnsSingleSite()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(0);

            Assert.AreEqual(1, target.Names.Count);
            Assert.AreEqual(1, target.Ids.Count);
        }

        /// <summary>
        ///A test for LoadSiteList
        ///</summary>
        [TestMethod()]
        public void LoadSiteListTest_ValidKidsRecordset_ReturnsSingleSite()
        {
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
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(0);

            Assert.AreEqual(1, target.Names.Count);
            Assert.AreEqual(1, target.Ids.Count);
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteIdNotExist_ReturnsNull()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag); 
            Assert.IsNull(target.GetSite(0));
            diag.AssertWasCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site id. "));
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteNameNotExist_ReturnsNull()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            

            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            Assert.IsNull(target.GetSite(""));
            diag.AssertWasCalled(x => x.WriteWarningToLog("SiteList", "A Site doesn't exist with that site name. "));
        }

        /// <summary>
        ///A test for GetSite
        ///</summary>
        [TestMethod()]
        public void GetSiteTest_SiteIdExist_ReturnsValidObject()
        {
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(1);
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
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());

            
            mocks.ReplayAll();

            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList(1);
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
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

            diag.AssertWasCalled(x => x.WriteTimedEventToLog("SiteList", "Creating list from database"));
            diag.AssertWasCalled(x => x.WriteTimedEventToLog("SiteList", "Completed creating list from database"));
            
        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueInt_WithValidOption_ReturnsCorrectValue()
        {
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetIntSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

            Assert.AreEqual(1, target.GetSiteOptionValueInt(1, "test", "test"));

        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueString_WithValidOption_ReturnsCorrectValue()
        {
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetStringSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

            Assert.AreEqual("1", target.GetSiteOptionValueString(1, "test", "test"));

        }

        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionValueBool_WithValidOption_ReturnsCorrectValue()
        {
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

            Assert.AreEqual(true, target.GetSiteOptionValueBool(1, "test", "test"));

        }


        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void GetSiteOptionListForSite_WithValidOptions_ReturnsCorrectValue()
        {
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

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
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();

            ISiteList actual = SiteList.GetSiteList(creator, null, false);
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Names.Count);
        }

        /// <summary>
        ///A test for GetSiteList
        ///</summary>
        [TestMethod()]
        public void GetSiteList_WithoutIgnoreCache_ReturnsCorrectList()
        {
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchsitedata")).Return(GetSiteListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getreviewforums")).Return(GetReviewForumsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getkeyarticlelist")).Return(GetKeyArticleListMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getsitetopicsopenclosetimes")).Return(GetSiteOpenCloseTimesMockReader());
            creator.Stub(x => x.CreateDnaDataReader("GetTopicDetails")).Return(GetSiteTopicsMockReader());
            creator.Stub(x => x.CreateDnaDataReader("getallsiteoptions")).Return(SiteOptionListTest.GetBoolSiteOptionMockReader());
            IDnaDiagnostics diag = mocks.DynamicMock<IDnaDiagnostics>();
            
            mocks.ReplayAll();

            ISiteList actual = SiteList.GetSiteList(creator, diag);
            Assert.IsNotNull(actual);
            Assert.AreEqual(1, actual.Names.Count);
        }


        /// <summary>
        ///A test for GetSiteOptionValueInt
        ///</summary>
        [TestMethod()]
        public void IsMessageboard_WithValidOption_ReturnsTrue()
        {
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
            SiteList target = new SiteList(creator, diag);
            target.LoadSiteList();

            Assert.IsTrue(target.IsMessageboard(1));

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
