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
    ///This is a test class for LocationTest and is intended
    ///to contain all LocationTest Unit Tests
    ///</summary>
    [TestClass()]
    public class LocationTest
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

        public static Location CreateLocation()
        {
            Location target = new Location()
            {
            };
            return target;
        }

        /// <summary>
        ///A test for LocationTest
        ///</summary>
        [TestMethod]
        public void CreateLocationTest()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;

            SetupLocationMocks(out mocks, out creator, out reader, 2);

            Location location;

            location = Location.CreateLocationFromReader(reader);
            Assert.AreNotEqual(null, location);

            XmlDocument xml = Serializer.SerializeToXml(location);
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupLocationMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, int rowsToReturn)
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
            AddLocationsTestDatabaseRows(reader);

            mocks.ReplayAll();
        }

        private void AddLocationsTestDatabaseRows(IDnaDataReader reader)
        {
            reader.Stub(x => x.GetStringNullAsEmpty("description")).Return("Test Location 1");
            reader.Stub(x => x.GetStringNullAsEmpty("title")).Return("Test Location 1");
            reader.Stub(x => x.GetInt32NullAsZero("locationid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("ownerid")).Return(1090497224);
            reader.Stub(x => x.GetInt32NullAsZero("siteid")).Return(1);
            reader.Stub(x => x.GetDateTime("CreatedDate")).Return(DateTime.Now);
        }
    }
}