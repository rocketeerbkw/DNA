using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Tests;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for RelatedClubsTest and is intended
    ///to contain all RelatedClubsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class RelatedClubsTest
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
        ///A test for GetRelatedClubs
        ///</summary>
        [TestMethod()]
        public void GetRelatedClubsXMLTest()
        {
            RelatedClubs clubs = CreateRelatedClubs();

            XmlDocument xml = Serializer.SerializeToXml(clubs);
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "relatedclubs.xsd");
            validator.Validate();



        }

        public static RelatedClubs CreateRelatedClubs()
        {
            RelatedClubs clubs = new RelatedClubs();

            RelatedClubsMember newRelatedClubsMember = new RelatedClubsMember()
            {
                ClubId = 1,
                Name = "myclub"
            };
            newRelatedClubsMember.ExtraInfo = "<EXTRAINFO><TEST>thisisatest</TEST></EXTRAINFO>";
            clubs.ClubMember.Add(newRelatedClubsMember);

            newRelatedClubsMember = new RelatedClubsMember()
            {
                ClubId = 2,
                Name = "myclub2"
            };
            newRelatedClubsMember.ExtraInfo = "<EXTRAINFO><TEST>thisisatest</TEST></EXTRAINFO>";
            clubs.ClubMember.Add(newRelatedClubsMember);
            return clubs;
        }

        /// <summary>
        ///A test for GetRelatedClubs
        ///</summary>
        [TestMethod()]
        public void GetRelatedClubs_ValidDataSet_ReturnsValidObject()
        {
            int h2g2ID = 0; 
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            reader.Stub(x => x.GetInt32("ClubID")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getrelatedclubs")).Return(reader);
            mocks.ReplayAll();

            
            RelatedClubs actual;
            actual = RelatedClubs.GetRelatedClubs(h2g2ID, creator);
            Assert.AreEqual(actual.ClubMember.Count, 1);
            Assert.AreEqual(actual.ClubMember[0].ClubId, 1);

        }
    }
}
