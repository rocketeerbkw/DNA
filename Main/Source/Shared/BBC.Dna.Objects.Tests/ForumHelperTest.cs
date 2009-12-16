using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ForumHelperTest and is intended
    ///to contain all ForumHelperTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ForumHelperTest
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

        public MockRepository mocks = new MockRepository();

        /// <summary>
        ///A test for MarkThreadRead
        ///</summary>
        [TestMethod()]
        public void MarkThreadRead_ValidDbCall_ReturnsNoExceptions()
        {
            
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("markthreadread")).Return(reader);
            mocks.ReplayAll();

            int userId = 0; 
            int threadId = 0; 
            int postId = 0; 
            bool force = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.MarkThreadRead(userId, threadId, postId, force);
            
        }

        /// <summary>
        ///A test for GetThreadPermissions
        ///</summary>
        [TestMethod()]
        public void GetThreadPermissions_ValidDataSet_ReturnsExpectedResults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            mocks.ReplayAll();

            int userId = 0; 
            int threadId = 0; 
            bool canRead = false; 
            bool canReadExpected = true; 
            bool canWrite = false; 
            bool canWriteExpected = true;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetThreadPermissions(userId, threadId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetThreadPermissions
        ///</summary>
        [TestMethod()]
        public void GetThreadPermissions_NoData_ReturnsUnchangedDefaults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetBoolean("CanRead")).Return(false);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(false);
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            mocks.ReplayAll();

            int userId = 0;
            int threadId = 0;
            bool canRead = false;
            bool canReadExpected = false;
            bool canWrite = false;
            bool canWriteExpected = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetThreadPermissions(userId, threadId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetForumPermissions
        ///</summary>
        [TestMethod()]
        public void GetForumPermissions_ValidDataSet_ReturnsExpectedResults()
        {
            int canReadOut = 0;
            int canWriteOut = 0;
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(1);
            reader.Stub(x => x.TryGetIntOutputParameter("CanWrite", out canWriteOut)).Return(true).OutRef(1);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            mocks.ReplayAll();
 

            int userId = 0; 
            int forumId = 0; 
            bool canRead = false; 
            bool canReadExpected = true; 
            bool canWrite = false; 
            bool canWriteExpected = true;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetForumPermissions(userId, forumId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetForumPermissions
        ///</summary>
        [TestMethod()]
        public void GetForumPermissionsTest_NoData_ReturnsUnchangedDefaults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            mocks.ReplayAll();


            int userId = 0;
            int forumId = 0;
            bool canRead = false;
            bool canReadExpected = false;
            bool canWrite = false;
            bool canWriteExpected = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetForumPermissions(userId, forumId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }
    }
}
