using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ForumThreadsTest and is intended
    ///to contain all ForumThreadsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ForumThreadsTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for ForumThreads Constructor
        ///</summary>
        [TestMethod()]
        public void ForumThreadsXmlTest()
        {
            ForumThreads target = ForumThreadsTest.CreateForumThreadsTest();
            Serializer.ValidateObjectToSchema(target, "ForumThreads.xsd");
        }

        static public ForumThreads CreateForumThreadsTest()
        {
            ForumThreads threads = new ForumThreads()
            {
                ModerationStatus = new ModerationStatus()
                {
                    Value = "",
                    Id =0
                },
                OrderBy = string.Empty
                
            };
            threads.Thread = new System.Collections.Generic.List<ThreadSummary>();
            threads.Thread.Add(ThreadSummaryTest.CreateThreadSummaryTest());
            return threads;
        }

        /// <summary>
        ///A test for GetSiteForForumId
        ///</summary>
        [TestMethod()]
        public void GetSiteForForumId_ValidSite_ReturnsCorrectSiteId()
        {
            int siteId=1;
            MockRepository mocks;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            GetSiteForForumIdTestSetup(out mocks, out creator, out siteList);

            ISite actual;
            actual = ForumThreads.GetSiteForForumId(creator, siteList, 0, 0);
            Assert.AreEqual(actual.SiteID, siteId);

        }

        /// <summary>
        ///A test for GetSiteForForumId
        ///</summary>
        [TestMethod()]
        public void GetSiteForForumId_NoSite_ReturnsException()
        {
            int siteId = 1;
            MockRepository mocks;
            IDnaDataReaderCreator creator;
            ISiteList siteList;
            GetSiteForForumIdTestSetup(out mocks, out creator, out siteList);

            ISite actual;

            //check if no site returned
            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(null);
            mocks.ReplayAll();

            try
            {
                actual = ForumThreads.GetSiteForForumId(creator, siteList, 0, 0);
            }
            catch (Exception e)
            {
                Assert.AreEqual(e.Message, "Unknown site id");
            }

        }

        private static void GetSiteForForumIdTestSetup(out MockRepository mocks, out IDnaDataReaderCreator creator, out ISiteList siteList)
        {
            int siteId = 1;
            mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);


            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();
        }

        /// <summary>
        ///A test for GetIndexOfThreadInForum
        ///</summary>
        [TestMethod()]
        public void GetIndexOfThreadInForum_WithRows_ReturnsValidObject()
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
            actual = ForumThreads.GetIndexOfThreadInForum(creator, threadId, forumId, itemsPerPage);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
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

        private static void GetIndexOfThreadInForumTestSetup(out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
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

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
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
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex, out threadOrder, out overFlow, out creator, out siteList);

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId,  itemsPerPage, startIndex, threadId,
                overFlow, threadOrder);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");

            //try desc
            overFlow = false;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId,  itemsPerPage, startIndex, threadId,
                overFlow, threadOrder);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");

        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
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
            CreateForumThreadsFromDatabaseTestSetup(out forumId, out threadId, out itemsPerPage, out startIndex, out threadOrder, out overFlow, out creator, out siteList);

            ForumThreads actual;
            //try desc
            overFlow = false;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId, itemsPerPage, startIndex, threadId,
                overFlow, threadOrder);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");

        }

        private static void CreateForumThreadsFromDatabaseTestSetup(out int forumId, out int threadId, out int itemsPerPage, out int startIndex, out ThreadOrder threadOrder, out bool overFlow, out IDnaDataReaderCreator creator, out ISiteList siteList)
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            forumId = 1;
            threadId = 0;
            itemsPerPage = 10;
            startIndex = 0;
            threadOrder = ThreadOrder.LatestPost;
            overFlow = true;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);


            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);


            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateForumThreadsFromDatabase_OverSizedItemsPerPage_ReturnsCorrectMoreValue()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 0;
            int itemsPerPage = 2000;
            int smallerItemsPerPage = 200;
            int startIndex = 0;
            
            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId,  itemsPerPage, startIndex, threadId, 
                true, threadOrder);
            Assert.AreEqual(actual.Thread.Count, smallerItemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateForumThreadsFromDatabaseTest_WithPostId_ReturnsCorrectThreadList()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 22;
            int itemsPerPage = 20;
            int startIndex = 0;
            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);//extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(itemsPerPage + 1);
            reader.Stub(x => x.NextResult()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId,  itemsPerPage, startIndex, threadId, 
                true, threadOrder);
            Assert.AreEqual(actual.Thread.Count, itemsPerPage);
            Assert.AreEqual(actual.More, "1");
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateForumThreadsFromDatabaseTest_WithPartialRecordset_ReturnsCorrectCount()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 0;
            int itemsPerPage = 20;
            int totalItems = 5;
            int startIndex = 0;
            
            ThreadOrder threadOrder = ThreadOrder.LatestPost;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(totalItems);//extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("ThreadID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("SiteID")).Return(siteId);
            reader.Stub(x => x.DoesFieldExist("ForumPostCount")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumPostCount")).Return(totalItems);
            reader.Stub(x => x.NextResult()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("forumgetthreadlist")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofthread")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("GetForumSiteID")).Return(reader);

            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSite(siteId)).Return(site);
            mocks.ReplayAll();

            ForumThreads actual;
            actual = ForumThreads.CreateForumThreadsFromDatabase(creator, siteList, forumId,  itemsPerPage, startIndex, threadId, 
                true, threadOrder);
            Assert.AreEqual(actual.Thread.Count, totalItems-1);//number of reader.read calls is decremented by other call
            Assert.AreEqual(actual.More, null);
        }
    }
}
