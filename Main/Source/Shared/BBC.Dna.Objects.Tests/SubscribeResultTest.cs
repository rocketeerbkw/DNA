using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for SubscribeResultTest and is intended
    ///to contain all SubscribeResultTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SubscribeResultTest
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
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToForum_SubscribeCanRead_ReturnsValidObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(1);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("subscribetoforum")).Return(reader);
            mocks.ReplayAll();


            int userId = 1; 
            int forumId = 1; 
            bool unSubcribe = false; 
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToForum(creator, userId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.ToForum);
            Assert.AreEqual(0, actual.Failed);
            
        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToForum_SubscribeCannotRead_ReturnsValidObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(0);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("subscribetoforum")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            bool unSubcribe = false;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToForum(creator, userId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.ToForum);
            Assert.AreEqual(3, actual.Failed);
            Assert.AreEqual("You don't have permission to read this forum", actual.Value);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToForum_UnSubscribeCanRead_ReturnsValidObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(1);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromforum")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            bool unSubcribe = true;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToForum(creator, userId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.FromForum);
            Assert.AreEqual(0, actual.Failed);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToForum_UnSubscribeCannotRead_ReturnsValidObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(0);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromforum")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            bool unSubcribe = true;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToForum(creator, userId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.FromForum);
            Assert.AreEqual(3, actual.Failed);
            Assert.AreEqual("You don't have permission to read this forum", actual.Value);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToThread_SubscribeCanRead_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("subscribetothread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            int threadId = 1;
            bool unSubcribe = false;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToThread(creator, userId, threadId, forumId, unSubcribe);
            Assert.AreEqual(threadId, actual.ToThreadId);
            Assert.AreEqual(0, actual.Failed);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToThread_SubscribeCannotRead_ReturnsFailedObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(0);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("subscribetothread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            int threadId = 1;
            bool unSubcribe = false;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToThread(creator, userId, forumId, threadId, unSubcribe);
            Assert.AreEqual(threadId, actual.ToThreadId);
            Assert.AreEqual(5, actual.Failed);
            Assert.AreEqual("You don't have permission to read this thread", actual.Value);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToThread_UnSubscribeCanRead_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromthread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            int threadId = 1;
            bool unSubcribe = true;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToThread(creator, userId, threadId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.FromThreadId);
            Assert.AreEqual(0, actual.Failed);

        }

        /// <summary>
        ///A test for SubscribeToForum
        ///</summary>
        [TestMethod()]
        public void SubscribeToThread_UnSubscribeCannotRead_ReturnsFailedObject()
        {
            int canReadOut = 0;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(0);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromthread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1;
            int forumId = 1;
            int threadId = 1;
            bool unSubcribe = true;
            SubscribeResult actual;
            actual = SubscribeResult.SubscribeToThread(creator, userId, threadId, forumId, unSubcribe);
            Assert.AreEqual(forumId, actual.FromThreadId);
            Assert.AreEqual(5, actual.Failed);
            Assert.AreEqual("You don't have permission to read this thread", actual.Value);

        }

        /// <summary>
        ///A test for UnSubscribeFromJournalThread
        ///</summary>
        [TestMethod()]
        public void UnSubscribeFromJournalThread_ValidateDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Result")).Return(0);
            //reader.Stub(x => x.AddParameter("reviewforumid", id)).Return(reader).AssertWasNotCalled(y => y.Throw(new Exception("AddParameter(reviewforumid, id) not called")));

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromjournalthread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1; 
            int threadId = 1; 
            int forumId =1; 
            SubscribeResult actual;
            actual = SubscribeResult.UnSubscribeFromJournalThread(creator, userId, threadId, forumId);
            Assert.AreEqual(1, actual.FromThreadId);
            Assert.AreEqual(1, actual.Journal);
            Assert.AreEqual(0, actual.Failed);
            
        }

        /// <summary>
        ///A test for UnSubscribeFromJournalThread
        ///</summary>
        [TestMethod()]
        public void UnSubscribeFromJournalThread_ErrorCode_ReturnsFailedObject()
        {
            string error = "testerror";
            int retCode = 4;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Result")).Return(retCode);
            reader.Stub(x => x.GetString("Reason")).Return(error);
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("unsubscribefromjournalthread")).Return(reader);
            mocks.ReplayAll();


            int userId = 1; 
            int threadId = 1; 
            int forumId = 1; 
            SubscribeResult actual;
            actual = SubscribeResult.UnSubscribeFromJournalThread(creator, userId, threadId, forumId);
            Assert.AreEqual(1, actual.FromThreadId);
            Assert.AreEqual(1, actual.Journal);
            Assert.AreEqual(retCode, actual.Failed);
            Assert.AreEqual(error, actual.Value);
            

        }

        static public SubscribeResult GetSubscribeResult()
        {
            return new SubscribeResult()
            {
                Value= string.Empty
            };
        }
    }
}
