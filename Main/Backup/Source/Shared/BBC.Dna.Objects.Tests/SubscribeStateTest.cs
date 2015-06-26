using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for SubscribeStateTest and is intended
    ///to contain all SubscribeStateTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SubscribeStateTest
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
        ///A test for GetThreadSubscriptionState
        ///</summary>
        [TestMethod()]
        public void GetThreadSubscriptionState_ValidThread_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadSubscribed")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("LastPostCountRead")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("LastUserPostID")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("isusersubscribed")).Return(reader);
            mocks.ReplayAll();

            int userId = 10;
            SubscribeState actual;
            actual = SubscribeState.GetSubscriptionState(creator, userId, 0, 0);
            Assert.AreEqual(1, actual.Thread);
            Assert.AreEqual(1, actual.LastUserPostId);
            Assert.AreEqual(1, actual.LastPostCountRead);
        }

        /// <summary>
        ///A test for GetThreadSubscriptionState
        ///</summary>
        [TestMethod()]
        public void GetThreadSubscriptionState_ValidForum_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ForumSubscribed")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("isusersubscribed")).Return(reader);
            mocks.ReplayAll();

            int userId = 10;
            SubscribeState actual;
            actual = SubscribeState.GetSubscriptionState(creator, userId, 0, 0);
            Assert.AreEqual(1, actual.Forum);
            Assert.AreEqual(0, actual.Thread);
        }

        static public SubscribeState GetSubscribeState()
        {
            return new SubscribeState()
            {
                
            };
        }
    }
}
