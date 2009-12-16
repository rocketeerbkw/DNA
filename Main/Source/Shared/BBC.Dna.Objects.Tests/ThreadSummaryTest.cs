using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ThreadSummaryTest and is intended
    ///to contain all ThreadSummaryTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ThreadSummaryTest
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
        ///A test for CreateThreadSummaryFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadSummaryFromReaderTest()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetBoolean("ThisCanRead")).Return(true);
            reader.Stub(x => x.GetBoolean("ThisCanWrite")).Return(true);
            reader.Stub(x => x.GetString("FirstSubject")).Return("test>");
            reader.Stub(x => x.DoesFieldExist("FirstPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("FirstPostthreadid")).Return(1);
            reader.Stub(x => x.DoesFieldExist("LastPostthreadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("LastPostthreadid")).Return(2);
            mocks.ReplayAll();

            ThreadSummary actual;
            actual = ThreadSummary.CreateThreadSummaryFromReader(reader, 0,0);
            Assert.AreEqual(actual.CanRead, 1);
            Assert.AreEqual(actual.CanWrite, 1);
            Assert.AreEqual(actual.Subject, "test&gt;");
        }

        /// <summary>
        ///A test for ThreadSummary Constructor
        ///</summary>
        [TestMethod()]
        public void ThreadSummaryXmlTest()
        {
            ThreadSummary target = ThreadSummaryTest.CreateThreadSummaryTest();
            Serializer.ValidateObjectToSchema(target, "ThreadSummary.xsd");
        }

        static public ThreadSummary CreateThreadSummaryTest()
        {
            ThreadSummary summary = new ThreadSummary()
            {
                Subject= string.Empty,
                DateLastPosted = new DateElement(DateTime.Now),
                FirstPost = ThreadPostSummaryTest.GetThreadPostSummary(),
                LastPost = ThreadPostSummaryTest.GetThreadPostSummary(),
            };
            return summary;
        }

        
    }
}
