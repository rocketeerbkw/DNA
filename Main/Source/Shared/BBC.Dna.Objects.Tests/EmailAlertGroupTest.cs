using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for EmailAlertGroupTest and is intended
    ///to contain all EmailAlertGroupTest Unit Tests
    ///</summary>
    [TestClass()]
    public class EmailAlertGroupTest
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
        ///A test for HasGroupAlertOnItem
        ///</summary>
        [TestMethod()]
        public void HasGroupAlertOnItem_ITThread_ReturnsValidObject()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);
            
            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);

        }

        [TestMethod()]
        public void HasGroupAlertOnItem_ITFORUM_ReturnsValidObject()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);

            //test with IT_FORUM flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumgroupalertid")).Return(reader);
            mocks.ReplayAll();
            itemType = EmailAlertList.IT_FORUM;

            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);

        }

        [TestMethod()]
        public void HasGroupAlertOnItem_ITCLUB_ReturnsValidObject()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);

            //test with IT_CLUB flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getclubgroupalertid")).Return(reader);
            mocks.ReplayAll();
            itemType = EmailAlertList.IT_CLUB;

            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);

        }

        [TestMethod()]
        public void HasGroupAlertOnItem_ITH2G2_ReturnsValidObject()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);

            //test with IT_H2G2 flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getarticlegroupalertid")).Return(reader);
            mocks.ReplayAll();
            itemType = EmailAlertList.IT_H2G2;

            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);
        }

        [TestMethod()]
        public void HasGroupAlertOnItem_ITNODE_ReturnsValidObject()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);

            
            //test with IT_NODE flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getnodegroupalertid")).Return(reader);
            mocks.ReplayAll();
            itemType = EmailAlertList.IT_NODE;

            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);

        }

        [TestMethod()]
        public void HasGroupAlertOnItem_ITPOST_ReturnsNotImplementedException()
        {
            int groupId = 10;
            int groupIdExpected = 112;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            HasGroupAlertOnItemTestSetup(groupIdExpected, out mocks, out reader, out creator);


            //test with IT_POST flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getarticlegroupalertid")).Return(reader);
            mocks.ReplayAll();
            itemType = EmailAlertList.IT_POST;

            try
            {
                EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            }
            catch (NotImplementedException)
            {
            }


        }

        private static void HasGroupAlertOnItemTestSetup(int groupIdExpected, out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("GroupID")).Return(groupIdExpected);

            //test with Thread flag
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);
            mocks.ReplayAll();
        }

        /// <summary>
        ///A test for HasGroupAlertOnItem
        ///</summary>
        [TestMethod()]
        public void HasGroupAlertOnItemTest_NoRows_ReturnsNoData()
        {
            int groupId = 10;
            int groupIdExpected = 0;
            int UserId = 0;
            int siteId = 0;
            EmailAlertList itemType = EmailAlertList.IT_THREAD;
            int itemId = 0;

            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("GroupID")).Return(112);

            //test with Thread flag
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);
            mocks.ReplayAll();

            EmailAlertGroup.HasGroupAlertOnItem(creator, ref groupId, UserId, siteId, itemType, itemId);
            Assert.AreEqual(groupIdExpected, groupId);
        }
    }
}
