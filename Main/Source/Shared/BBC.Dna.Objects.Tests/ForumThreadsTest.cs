using System;
using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Objects;
using BBC.Dna.Common;
using BBC.Dna.Api;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for ForumThreadsTest and is intended
    ///to contain all ForumThreadsTest Unit Tests
    ///</summary>
    [TestClass]
    public class ForumThreadsTest
    {
        public MockRepository Mocks = new MockRepository();

        public static ForumThreads CreateForumThreadsTest()
        {
            var threads = new ForumThreads
                              {
                                  ModerationStatus = new ModerationStatus
                                                         {
                                                             Value = "",
                                                             Id = 0
                                                         },
                                  OrderBy = string.Empty,
                                  Thread = new List<ThreadSummary>
                                               {ThreadSummaryTest.CreateThreadSummaryTest()}
                              };
            return threads;
        }

        /// <summary>
        ///A test for GetSiteForForumId
        ///</summary>
        [TestMethod]
        public void GetSiteForForumId_ValidSite_ReturnsCorrectSiteId()
        {
            const int siteId = 1;
            MockRepository mocks;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            GetSiteForForumIdTestSetup(out mocks, out creator, out siteList);

            ISite actual = ForumThreads.GetSiteForForumId(creator, siteList, 0, 0);
            Assert.AreEqual(actual.SiteID, siteId);
        }

        /// <summary>
        ///A test for GetSiteForForumId
        ///</summary>
        [TestMethod]
        public void GetSiteForForumId_NoSite_ReturnsException()
        {
            const int siteId = 1;
            MockRepository mocks;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            GetSiteForForumIdTestSetup(out mocks, out creator, out siteList);


            //check if no site returned
            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(null);
            mocks.ReplayAll();

            try
            {
                ForumThreads.GetSiteForForumId(creator, siteList, 0, 0);
            }
            catch (Exception e)
            {
                Assert.AreEqual(e.Message, "Unknown site id");
            }
        }

        /// <summary>
        ///A test for GetIndexOfThreadInForum
        ///</summary>
        [TestMethod]
        public void GetIndexOfThreadInForum_WithRows_ReturnsValidObject()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetIndexOfThreadInForumTestSetup(out mocks, out reader, out creator);

            int expected = 20;
            int actual = ForumThreads.GetIndexOfThreadInForum(creator, 0, 0, 10);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void GetIndexOfThreadInForum_WithoutRows_ReturnsValidEmptyObject()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetIndexOfThreadInForumTestSetup(out mocks, out reader, out creator);

            int threadId = 0;
            int itemsPerPage = 10;
            int expected = 20;
            int actual;
            int forumId = 0;

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            mocks.ReplayAll();

            expected = 0;
            actual = ForumThreads.GetIndexOfThreadInForum(creator, threadId, forumId, itemsPerPage);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabase_UsingAsc_ReturnsCorrectNumberThreads()
        {
            int forumId;
            int threadId;
            int itemsPerPage;
            int startIndex;
            ThreadOrder threadOrder;
            bool overFlow;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            int siteId = 0;
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out creator, out siteList, out siteId);

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 overFlow, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");

            //try desc
            overFlow = false;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 overFlow, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabase_UsingDesc_ReturnsCorrectNumberThreads()
        {
            int forumId;
            int threadId;
            int itemsPerPage;
            int startIndex;
            ThreadOrder threadOrder;
            bool overFlow;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            int siteId = 0;
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out creator, out siteList, out siteId);

            ForumThreads actual;
            //try desc
            overFlow = false;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 overFlow, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabase_OverSizedItemsPerPage_ReturnsCorrectMoreValue()
        {
            var mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 0;
            int itemsPerPage = 2000;
            int smallerItemsPerPage = 200;
            int startIndex = 0;

            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            var siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 true, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, smallerItemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabaseTest_WithPostId_ReturnsCorrectThreadList()
        {
            var mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 22;
            int itemsPerPage = 20;
            int startIndex = 0;
            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true); //extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.NextResult()).Return(true);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            var siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 true, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabaseTest_WithPartialRecordset_ReturnsCorrectCount()
        {
            var mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 0;
            int itemsPerPage = 20;
            int totalItems = 5;
            int startIndex = 0;

            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(totalItems); //extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(totalItems);
            reader.Stub(x => x.NextResult()).Return(true);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            var siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                 threadId,
                                                                 true, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, totalItems - 1);
            //number of reader.read calls is decremented by other call
            Assert.AreEqual("0", actual.More);
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabase_WithStartIndex_ReturnsCorrectNumberThreads()
        {
            int forumId=1;
            int threadId=0;
            int itemsPerPage=10;
            int startIndex;
            int siteId=1;
            var threadOrder = ThreadOrder.LatestPost;
            var overFlow = true;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.DoesFieldExist("")).Constraints(Is.Anything()).Return(true);
            reader.Stub(x => x.GetBoolean("")).Constraints(Is.Anything()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("AlertInstantly")).Return(1);
            reader.Stub(x => x.GetStringNullAsEmpty("FirstPosttext")).Return("some text");
            reader.Stub(x => x.GetStringNullAsEmpty("LastPosttext")).Return("some text");
            

            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetDateTime("ThreadLastUpdated")).Return(DateTime.MinValue);
            reader.Stub(x => x.GetDateTime("ForumLastUpdated")).Return(DateTime.MinValue);



            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);



            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            var siteList = Mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            Mocks.ReplayAll();


            startIndex = 1;
            ForumThreads actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                              threadId,
                                                                              overFlow, threadOrder, false);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual("0", actual.More);

        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod]
        public void CreateForumThreadsFromDatabase_WithoutRows_ReturnsEmpty()
        {
            int forumId = 1;
            int threadId = 0;
            int itemsPerPage = 10;
            int startIndex;
            int siteId = 1;
            var threadOrder = ThreadOrder.LatestPost;
            var overFlow = true;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);



            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            var siteList = Mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            Mocks.ReplayAll();


            startIndex = 1;
            ForumThreads actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex,
                                                                              threadId,
                                                                              overFlow, threadOrder, false);
            Assert.AreEqual(0, actual.Thread.Count);
            Assert.AreEqual("0", actual.More);

        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_IsEditor_ReturnsCanWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(true);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads
                             {
                                 Thread = new List<ThreadSummary> {ThreadSummaryTest.CreateThreadSummaryTest()}
                                 , CanWrite=0
                                 ,DefaultCanWrite=0
                             };


            target.ApplyUserSettings(user, site);
            Assert.AreEqual(1, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_IsSuperUser_ReturnsCanWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(true);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads(){ CanWrite=0,DefaultCanWrite=0};
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(1, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_SiteClosed_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(true);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads {CanWrite = 1, DefaultCanWrite=1};
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_SiteScheduledClosed_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(true);
            Mocks.ReplayAll();

            var target = new ForumThreads {CanWrite = 1,DefaultCanWrite=1};
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_CanWriteIsZeroSiteOpen_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads { CanWrite = 0, DefaultCanWrite = 0 };
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_NormalUserWithCanWriteIsOneAndDefaultIsZero_ReturnsCannotWrite()
        {
            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsEditor).Return(false);
            user.Stub(x => x.IsSuperUser).Return(false);

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads { CanWrite = 1, DefaultCanWrite =0 };
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod]
        public void ApplyUserSettings_NullUserWithCanWriteIsOneAndDefaultIsZero_ReturnsCannotWrite()
        {
            IUser user = null;

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);
            Mocks.ReplayAll();

            var target = new ForumThreads { CanWrite = 1, DefaultCanWrite = 0 };
            target.ApplyUserSettings(user, site);
            Assert.AreEqual(0, target.CanWrite);
        }

        /// <summary>
        ///A test for Clone
        ///</summary>
        [TestMethod]
        public void CloneTest()
        {
            var target = new ForumThreads
                             {
                                 Thread = new List<ThreadSummary> {ThreadSummaryTest.CreateThreadSummaryTest()}
                             };
            var actual = (ForumThreads) target.Clone();
            Assert.AreEqual(1, actual.Thread.Count);
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var forumThread = new ForumThreads();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof (ForumThreads).AssemblyQualifiedName);
            string actual = forumThread.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for CreateForumThreads
        ///</summary>
        [TestMethod]
        public void CreateForumThreads_FromDatabase_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateForumThreads(cache, readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                                  threadId, overFlow, threadOrder, viewingUser, ignoreCache, false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateForumThreads
        ///</summary>
        [TestMethod]
        public void CreateForumThreads_WithIgnoreCache_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = true;
            int siteId = 0;
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateForumThreads(cache, readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                                  threadId, overFlow, threadOrder, viewingUser, ignoreCache, false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateForumThreads
        ///</summary>
        [TestMethod]
        public void CreateForumThreads_NotUpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = Mocks.DynamicMock<CachableBase<ForumThreads>>();
            forumThreads.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateForumThreads(cache, readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                                  threadId, overFlow, threadOrder, viewingUser, ignoreCache, false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateForumThreads
        ///</summary>
        [TestMethod]
        public void CreateForumThreads_UpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            ISiteList siteList = null;
            int siteId = 0;

            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList,
                                                    out siteId);

           
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = new ForumThreads()
                                   {
                                       LastForumUpdated = DateTime.MaxValue,
                                       LastThreadUpdated = DateTime.MaxValue,
                                       SiteId = siteId
                                   };
            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateForumThreads(cache, readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                                  threadId, overFlow, threadOrder, viewingUser, ignoreCache, false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        [TestMethod]
        public void FetchPostFromDatabase_WithValidValues_ReturnsValidObject()
        {
            int threadId = 11;
            int siteId = 5;
            int postid = 123;
            string subject = "test subject";
            string text = "text";
            int hidden = 0;
            int postindex = 11;
            int postStyle = 0;
            DateTime datePosted = DateTime.Now;

            // 1) prepare the test            
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            reader.Stub(x => x.DoesFieldExist("postid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.DoesFieldExist("siteid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("datePosted")).Return(true);
            reader.Stub(x => x.GetDateTime("datePosted")).Return(datePosted);
            reader.Stub(x => x.DoesFieldExist("postindex")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postindex")).Return(postindex);            
            reader.Stub(x => x.DoesFieldExist("subject")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("subject")).Return(subject);
            reader.Stub(x => x.DoesFieldExist("text")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("text")).Return(text);
            reader.Stub(x => x.DoesFieldExist("postStyle")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postStyle")).Return(postStyle);            
            reader.Stub(x => x.DoesFieldExist("hidden")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(hidden);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetchpostdetails")).Return(reader);
            Mocks.ReplayAll();

            // 2) execute the test
            ThreadPost threadPost = ThreadPost.FetchPostFromDatabase(creator, postid, false);

            // 3) verify the results
            Assert.AreEqual(postid, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);
            Assert.AreEqual(datePosted.ToShortDateString(), threadPost.DatePosted.Date.DateTime.ToShortDateString());
            Assert.AreEqual(postindex, threadPost.Index);
            Assert.AreEqual(subject, threadPost.Subject);
            Assert.AreEqual(text, threadPost.Text);
            Assert.AreEqual(postStyle, (int)threadPost.Style);
            Assert.AreEqual(hidden, (int)threadPost.Hidden);
        }


        [TestMethod]
        public void FetchPostFromDatabase_WithNonExistingPost_ThrowsException()
        {
            int postid = 123;

            // 1) prepare the test                        
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.CanCache).Return(false);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("fetchpostdetails")).Return(reader);
            Mocks.ReplayAll();

            // 2) execute the test
            ThreadPost threadPost;
            try
            {
                threadPost = ThreadPost.FetchPostFromDatabase(readerCreator, postid, false);
            }
            catch (ApiException e)
            {

                // 3) verify the results
                Assert.AreEqual(e.type, ErrorType.ThreadPostNotFound);
            }
        }

        [TestMethod]
        public void CreateThreadPost_WithValidValues_CreatesRecord()
        {
            // 1) prepare the test
            int postid = 222;
            int threadid = 333;
            int userid = 999;
            int forumid = 888;
            int inReplyTo = 123;
            int threadId = 465;
            string subject = "subject";
            string text = "text";
            bool ignoreModeration = true;
            bool notablable = true;
            bool iscomment = false;
            string ipAddress = "1.1.1.1";
            Guid bbcUID = Guid.NewGuid();
            bool allowQueing = false;
            bool forcePreModerate = true;
            bool forceModerate = true;

            // essential details
            ThreadPost newThreadPost = new ThreadPost();            
            newThreadPost.InReplyTo = inReplyTo;
            newThreadPost.ThreadId = threadId;
            newThreadPost.Subject = subject;
            newThreadPost.Text = text;
            newThreadPost.Style = PostStyle.Style.richtext;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postid);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadid);             

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("posttoforum")).Return(reader);
            Mocks.ReplayAll();

            // 2) execute the test
            newThreadPost.CreateForumPost(readerCreator,
                userid,
                forumid,
                ignoreModeration,
                notablable,
                ipAddress,
                bbcUID,
                iscomment,
                allowQueing,
                forcePreModerate,
                forceModerate,
                "");

            // 3) verify the results
            Assert.AreEqual(postid, newThreadPost.PostId);
            Assert.AreEqual(threadid, newThreadPost.ThreadId);

        }


        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_NoRows_ReturnsCorrect()
        {
            ForumThreads target = new ForumThreads()
            {
                LastForumUpdated = DateTime.MaxValue,
                LastThreadUpdated = DateTime.MaxValue

            };

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);
            Mocks.ReplayAll();

            Assert.AreEqual(true, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_ReadFalse_ReturnsCorrect()
        {
            var target = new ForumThreads()
            {
                LastForumUpdated = DateTime.MaxValue,
                LastThreadUpdated = DateTime.MaxValue

            };

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);
            Mocks.ReplayAll();

            Assert.AreEqual(true, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_ForumOutOfDate_ReturnsCorrect()
        {
            var target = new ForumThreads()
            {
                LastForumUpdated = DateTime.MinValue,
                LastThreadUpdated = DateTime.MaxValue

            };

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);
            Mocks.ReplayAll();

            Assert.AreEqual(false, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod()]
        public void IsUpToDate_ThreadOutOfDate_ReturnsCorrect()
        {
            var target = new ForumThreads()
            {
                LastForumUpdated = DateTime.MaxValue,
                LastThreadUpdated = DateTime.MinValue

            };

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);
            Mocks.ReplayAll();

            Assert.AreEqual(false, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for JournalOwnerAttribute
        ///</summary>
        [TestMethod()]
        public void JournalOwnerAttribute_Not0_ReturnsString()
        {
            var target = new ForumThreads { JournalOwner = 1 };
            Assert.AreEqual("1", target.JournalOwnerAttribute);
        }

        /// <summary>
        ///A test for JournalOwnerAttribute
        ///</summary>
        [TestMethod()]
        public void JournalOwnerAttribute_Is0_ReturnsString()
        {
            var target = new ForumThreads();
            Assert.IsNull(target.JournalOwnerAttribute);
        }

        [TestMethod()]
        public void GetLatestSkipValue_NoThreadFound_Returns0()
        {
            var threads = new ForumThreads();
            Assert.AreEqual(0, threads.GetLatestSkipValue(0,1));

        }

        [TestMethod()]
        public void GetLatestSkipValue_ThreadFoundWith10PostsAndShow10_Returns0()
        {
            var threads = new ForumThreads();
            threads.Thread.Add(new ThreadSummary {ThreadId = 1,  TotalPosts = 10 });
            Assert.AreEqual(0, threads.GetLatestSkipValue(1, 10));

        }

        [TestMethod()]
        public void GetLatestSkipValue_ThreadFoundWith10PostsAndShow5_Returns5()
        {
            var threads = new ForumThreads();
            threads.Thread.Add(new ThreadSummary { ThreadId = 1, TotalPosts = 10 });
            Assert.AreEqual(5, threads.GetLatestSkipValue(1, 5));

        }

        [TestMethod()]
        public void GetLatestSkipValue_ThreadFoundWith11PostsAndShow5_Returns10()
        {
            var threads = new ForumThreads();
            threads.Thread.Add(new ThreadSummary { ThreadId = 1, TotalPosts = 11 });
            Assert.AreEqual(10, threads.GetLatestSkipValue(1, 5));

        }

        /// <summary>
        ///A test for CreateJournal
        ///</summary>
        [TestMethod]
        public void CreateJournal_WithIgnoreCache_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            string identityUserName;
            int userId;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = true;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateUsersJournal(cache, 
                                                            readerCreator, 
                                                            siteList,
                                                            identityUserName,
                                                            1,
                                                            itemsPerPage, 
                                                            startIndex,                
                                                            threadId, 
                                                            overFlow, 
                                                            threadOrder, 
                                                            viewingUser,
                                                            false,
                                                            ignoreCache, 
                                                            false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateJournal
        ///</summary>
        [TestMethod]
        public void CreateJournal_NotUpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int userId;
            string identityUserName;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = Mocks.DynamicMock<CachableBase<ForumThreads>>();
            forumThreads.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateUsersJournal(cache, 
                                                            readerCreator, 
                                                            siteList, 
                                                            identityUserName,
                                                            1,
                                                            itemsPerPage, 
                                                            startIndex,
                                                            threadId, 
                                                            overFlow, 
                                                            threadOrder, 
                                                            viewingUser,
                                                            false,
                                                            ignoreCache,
                                                            false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateJournal
        ///</summary>
        [TestMethod]
        public void CreateJournal_UpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int userId;
            string identityUserName;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);


            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = new ForumThreads()
            {
                LastForumUpdated = DateTime.MaxValue,
                LastThreadUpdated = DateTime.MaxValue,
                SiteId = siteId

            };
            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateUsersJournal(cache,
                                                            readerCreator,
                                                            siteList,
                                                            identityUserName,
                                                            1,
                                                            itemsPerPage,
                                                            startIndex,
                                                            threadId,
                                                            overFlow,
                                                            threadOrder,
                                                            viewingUser,
                                                            false,
                                                            ignoreCache,
                                                            false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateJournalByDNAUserId
        ///</summary>
        [TestMethod]
        public void CreateJournalByDNAUserId_WithIgnoreCache_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int userId;
            string identityUserName;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = true;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateUsersJournal(cache,
                                                            readerCreator,
                                                            siteList,
                                                            userId.ToString(),
                                                            1,
                                                            itemsPerPage,
                                                            startIndex,
                                                            threadId,
                                                            overFlow,
                                                            threadOrder,
                                                            viewingUser,
                                                            true,
                                                            ignoreCache,
                                                            false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateJournalByDNAUserId
        ///</summary>
        [TestMethod]
        public void CreateJournalByDNAUserId_NotUpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int userId;
            string identityUserName;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);
            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = Mocks.DynamicMock<CachableBase<ForumThreads>>();
            forumThreads.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateForumThreads(cache, readerCreator, siteList, forumId, itemsPerPage, startIndex,
                                                                  threadId, overFlow, threadOrder, viewingUser, ignoreCache, false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }

        /// <summary>
        ///A test for CreateJournalByDNAUserId
        ///</summary>
        [TestMethod]
        public void CreateJournalByDNAUserId_UpToDate_ReturnsValidObject()
        {
            IDnaDataReaderCreator readerCreator;
            ISiteList siteList;
            int userId;
            string identityUserName;
            int forumId;
            int itemsPerPage;
            int startIndex;
            int threadId;
            bool overFlow;
            ThreadOrder threadOrder;
            bool ignoreCache = false;
            int siteId = 0;
            CreateJournalTestSetup(out userId, out identityUserName, out forumId, out threadId, out itemsPerPage, out startIndex,
                                                    out threadOrder, out overFlow, out readerCreator, out siteList, out siteId);


            var viewingUser = Mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            var forumThreads = new ForumThreads()
            {
                LastForumUpdated = DateTime.MaxValue,
                LastThreadUpdated = DateTime.MaxValue,
                SiteId = siteId
            };
            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumThreads);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            Mocks.ReplayAll();

            ForumThreads actual = ForumThreads.CreateUsersJournal(cache,
                                                            readerCreator,
                                                            siteList,
                                                            userId.ToString(),
                                                            1,
                                                            itemsPerPage,
                                                            startIndex,
                                                            threadId,
                                                            overFlow,
                                                            threadOrder,
                                                            viewingUser,
                                                            true,
                                                            ignoreCache,
                                                            false);
            Assert.IsNotNull(actual);
            //Assert.Inconclusive("Verify the correctness of this test method.");
        }


        #region Helper methods

        private static void GetSiteForForumIdTestSetup(out MockRepository mocks, out IDnaDataReaderCreator creator,
                                                       out ISiteList siteList)
        {
            const int siteId = 1;
            mocks = new MockRepository();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);


            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();
        }


        private static void CreateForumThreadsFromDatabaseTestSetup(out int forumId, out int threadId,
                                                                   out int itemsPerPage, out int startIndex,
                                                                   out ThreadOrder threadOrder, out bool overFlow,
                                                                   out IDnaDataReaderCreator creator,
                                                                   out ISiteList siteList, out int siteId)
        {
            var mocks = new MockRepository();
            siteId = 1;
            forumId = 1;
            threadId = 0;
            itemsPerPage = 10;
            startIndex = 0;
            threadOrder = ThreadOrder.LatestPost;
            overFlow = true;

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetDateTime("ThreadLastUpdated")).Return(DateTime.MinValue);
            reader.Stub(x => x.GetDateTime("ForumLastUpdated")).Return(DateTime.MinValue);



            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);



            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(false);

            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(1)).Return(site);
            mocks.ReplayAll();
        }

        private static void CreateJournalTestSetup(out int userId, out string identityUserName, out int forumId, out int threadId,
                                                           out int itemsPerPage, out int startIndex,
                                                           out ThreadOrder threadOrder, out bool overFlow,
                                                           out IDnaDataReaderCreator creator,
                                                           out ISiteList siteList, out int siteId)
        {
            var mocks = new MockRepository();
            siteId = 1;
            userId = 6;
            identityUserName = "Damnyoureyes";
            forumId = 7;
            threadId = 0;
            itemsPerPage = 10;
            startIndex = 0;
            threadOrder = ThreadOrder.LatestPost;
            overFlow = true;

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Journal")).Return(forumId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetDateTime("ThreadLastUpdated")).Return(DateTime.MinValue);
            reader.Stub(x => x.GetDateTime("ForumLastUpdated")).Return(DateTime.MinValue);



            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("finduserfromidentityusername")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("finduserfromid")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("cachegetforumlastupdate")).Return(reader);

            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(1)).Return(site);
            mocks.ReplayAll();
        }


        private static void GetIndexOfThreadInForumTestSetup(out MockRepository mocks, out IDnaDataReader reader,
                                                             out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Index")).Return(25);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            mocks.ReplayAll();
        }

        #endregion


       
    }
}