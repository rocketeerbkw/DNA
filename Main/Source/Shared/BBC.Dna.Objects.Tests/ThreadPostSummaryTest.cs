using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using System;
using Rhino.Mocks;
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ThreadPostSummaryTest and is intended
    ///to contain all ThreadPostSummaryTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ThreadPostSummaryTest
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
        ///A test for ThreadPostSummary Constructor
        ///</summary>
        //[TestMethod()]
        //public void ThreadPostSummaryXmlTest()
        //{
        //    ThreadPostSummary target = new ThreadPostSummary();
        //    Serializer.ValidateObjectToSchema(target, "PostSummary.xsd");
        //}

        /// <summary>
        ///A test for CreateThreadPostFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromReaderTest()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            mocks.ReplayAll();

            ThreadPostSummary actual;
            actual = ThreadPostSummary.CreateThreadPostFromReader(reader, string.Empty, 0);
            Assert.AreNotEqual(null, actual);
        }

        static public ThreadPostSummary GetThreadPostSummary()
        {
            return new ThreadPostSummary()
            {
                Text = string.Empty,
                Date = new Date(DateTime.Now),
                User = UserTest.CreateTestUser()
            };
        }
    }
}
