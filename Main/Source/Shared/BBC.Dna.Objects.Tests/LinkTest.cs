using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for LinkTest and is intended
    ///to contain all LinkTest Unit Tests
    ///</summary>
    [TestClass()]
    public class LinkTest
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

        public static Link CreateLink()
        {
            Link target = new Link()
            {
                Type = "article",
                DateLinked = new DateElement(DateTime.Now),
                DnaUid = "123456",
                Description = "Here is my Test Link",
                LinkId = 1,
                Private = 0,
                Relationship = "Bookmark",
                Submitter = new UserElement() { user = UserTest.CreateTestUser() },
                TeamId = 1
            };
            return target;
        }

        /// <summary>
        ///A test for ListTest
        ///</summary>
        [TestMethod]
        public void CreateListTest()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupLinkMocks(out mocks, out creator, out reader, 2);

            Link link;

            link = Link.CreateLinkFromReader(reader);
            Assert.AreNotEqual(null, link);

            XmlDocument xml = Serializer.SerializeToXml(link);
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }
        private void SetupLinkMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader);

            if (rowsToReturn > 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true).Repeat.Times(rowsToReturn);
            }
            else
            {
                reader.Stub(x => x.HasRows).Return(false);
                reader.Stub(x => x.Read()).Return(false);
            }
            AddLinksListTestDatabaseRows(reader);

            mocks.ReplayAll();
        }

        private void AddLinksListTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("destinationtype")).Return("article");
            reader.Stub(x => x.GetStringNullAsEmpty("relationship")).Return("Bookmark");
            reader.Stub(x => x.GetInt32NullAsZero("linkid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("teamid")).Return(12345);
            reader.Stub(x => x.GetInt32NullAsZero("DestinationID")).Return(24088151);
            reader.Stub(x => x.GetTinyIntAsInt("private")).Return(0);

        }
    }
}