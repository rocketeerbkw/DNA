using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;



namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for CrumbTrailsTest and is intended
    ///to contain all CrumbTrailsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class CrumbTrailsTest
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
        ///A test for GetCrumbtrailForItem
        ///</summary>
        [TestMethod()]
        public void GetCrumbtrailForItem_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(2);
            reader.Stub(x => x.GetString("DisplayName")).Return("test");
            mocks.ReplayAll();

            CrumbTrails actual;
            actual = CrumbTrails.GetCrumbtrailForItem(reader);
            Assert.AreEqual(actual.CrumbTrail.Count, 2);
            Assert.AreEqual(actual.CrumbTrail[0].Ancestor.Count, 1);
            Assert.AreEqual(actual.CrumbTrail[0].Ancestor[0].Name, "test");
        }

        /// <summary>
        ///A test for CreateArticleCrumbtrail
        ///</summary>
        [TestMethod()]
        public void CreateArticleCrumbtrail_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(2);
            reader.Stub(x => x.GetString("DisplayName")).Return("test");
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getarticlecrumbtrail")).Return(reader);
            mocks.ReplayAll();

            CrumbTrails actual;
            actual = CrumbTrails.GetCrumbtrailForItem(reader);
            Assert.AreEqual(actual.CrumbTrail.Count, 2);
            Assert.AreEqual(actual.CrumbTrail[0].Ancestor.Count, 1);
            Assert.AreEqual(actual.CrumbTrail[0].Ancestor[0].Name, "test");

            
        }

        


        public static CrumbTrails CreateCrumbTrails()
        {
            CrumbTrails target = new CrumbTrails();
            target.CrumbTrail.Add(new CrumbTrail());
            target.CrumbTrail.Add(new CrumbTrail());
            target.CrumbTrail[0].Ancestor.Add(CrumbTrailsTest.CreateCrumbTrailAncestor());
            target.CrumbTrail[0].Ancestor.Add(CrumbTrailsTest.CreateCrumbTrailAncestor());
            target.CrumbTrail[1].Ancestor.Add(CrumbTrailsTest.CreateCrumbTrailAncestor());
            target.CrumbTrail[1].Ancestor.Add(CrumbTrailsTest.CreateCrumbTrailAncestor());
            return target;
        }


        public static CrumbTrailAncestor CreateCrumbTrailAncestor()
        {
            return new CrumbTrailAncestor()
            {
                Name = "Top"
            };

        }
    }
}
