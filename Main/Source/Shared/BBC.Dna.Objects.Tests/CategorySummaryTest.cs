using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for CategorySummaryTest
    /// </summary>
    [TestClass]
    public class CategorySummaryTest
    {
        private readonly int _test_nodeid = 55;
        private readonly int _test_categoryid = 100;
        private readonly string _test_unstrippedname = "the stripped name";
        private readonly string _test_strippedname = "stripped name";

        public void GetCategoryAncestry_SetupDefaultMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
        }

        public void GetChildCategories_SetupDefaultMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
        }

        public CategorySummaryTest()
        {
            //
            // TODO: Add constructor logic here
            //
        }

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
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        /// Tests if GetCategoryAncestry correctly populates all immediate child properties of the first returned instance in the list
        /// </summary>
        [TestMethod()]
        public void GetCategoryAncestry_WithOneAncestor_ReturnsValidFirstChild()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetCategoryAncestry_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getancestryReader = mocks.DynamicMock<IDnaDataReader>();
            getancestryReader.Stub(x => x.HasRows).Return(true);
            getancestryReader.Stub(x => x.Read()).Return(true).Repeat.Times(1); ;
            getancestryReader.Stub(x => x.GetInt32NullAsZero("AncestorID")).Return(123);
            getancestryReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1);
            getancestryReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return(_test_unstrippedname);
            getancestryReader.Stub(x => x.GetInt32NullAsZero("TreeLevel")).Return(2);
            // TODO: test redirect node

            readerCreator.Stub(x => x.CreateDnaDataReader("getancestry")).Return(getancestryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetCategoryAncestry(readerCreator, _test_categoryid);

            // VERIFY THE RESULTS
            Assert.IsNotNull(actual.First());
            Assert.AreEqual(123, actual.First().NodeID);
            Assert.AreEqual(_test_unstrippedname, actual.First().Name);
            Assert.AreEqual(_test_strippedname, actual.First().StrippedName);
            Assert.AreEqual(1, actual.First().Type);
            Assert.AreEqual(2, actual.First().TreeLevel);
        }


        /// <summary>
        /// Tests if GetCategoryAncestry returns multiple results when it has multiple ancestors
        /// </summary>
        [TestMethod()]
        public void GetCategoryAncestry_WithMultipleAncestors_ReturnsMultipleObjects()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetCategoryAncestry_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getancestryReader = mocks.DynamicMock<IDnaDataReader>();
            getancestryReader.Stub(x => x.HasRows).Return(true);
            getancestryReader.Stub(x => x.Read()).Return(true).Repeat.Times(10); ;
            getancestryReader.Stub(x => x.GetInt32NullAsZero("AncestorID")).Return(123);
            getancestryReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1);
            getancestryReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return(_test_unstrippedname);
            getancestryReader.Stub(x => x.GetInt32NullAsZero("TreeLevel")).Return(2);
            readerCreator.Stub(x => x.CreateDnaDataReader("getancestry")).Return(getancestryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetCategoryAncestry(readerCreator, _test_categoryid);

            // VERIFY THE RESULTS
            Assert.AreEqual(actual.Count, 10);
        }

        /// <summary>
        /// Tests if GetCategoryAncestry returns an empty list when there aren't any ancestors
        /// </summary>
        [TestMethod()]
        public void GetCategoryAncestry_WithoutAncestors_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetCategoryAncestry_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getancestryReader = mocks.DynamicMock<IDnaDataReader>();
            getancestryReader.Stub(x => x.HasRows).Return(false);
            getancestryReader.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("getancestry")).Return(getancestryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetCategoryAncestry(readerCreator, _test_categoryid);

            // VERIFY THE RESULTS
            Assert.AreEqual(actual.Count, 0);
        }

        /// <summary>
        /// Tests if GetChildCategories correctly populates the first Category instance in the results
        /// </summary>
        [TestMethod()]
        public void GetChildCategories_WithOneChild_ReturnsValidFirstChild()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildCategories_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getsubjectsincategoryReader = mocks.DynamicMock<IDnaDataReader>();
            getsubjectsincategoryReader.Stub(x => x.HasRows).Return(true);
            getsubjectsincategoryReader.Stub(x => x.Read()).Return(true).Repeat.Times(1); ;
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeID")).Return(123);
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeCount")).Return(1);
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(2);
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("ArticleCount")).Return(3);
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("AliasCount")).Return(4);
            getsubjectsincategoryReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return(_test_unstrippedname);            
            readerCreator.Stub(x => x.CreateDnaDataReader("getsubjectsincategory")).Return(getsubjectsincategoryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetChildCategories(readerCreator, _test_nodeid);

            // VERIFY THE RESULTS
            Assert.IsNotNull(actual.First());
            Assert.AreEqual(123, actual.First().NodeID);
            Assert.AreEqual(1, actual.First().NodeCount );
            Assert.AreEqual(2, actual.First().Type);
            Assert.AreEqual(3, actual.First().ArticleCount);
            Assert.AreEqual(4, actual.First().AliasCount);
            Assert.AreEqual(_test_unstrippedname, actual.First().Name);
            Assert.AreEqual(_test_strippedname, actual.First().StrippedName);
        }


        /// <summary>
        /// Tests if GetChildCategories returns an empty list when there aren't any children.
        /// </summary>
        [TestMethod()]
        public void GetChildCategories_WithoutChildren_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildCategories_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getsubjectsincategoryReader = mocks.DynamicMock<IDnaDataReader>();
            getsubjectsincategoryReader.Stub(x => x.HasRows).Return(false);
            getsubjectsincategoryReader.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("getsubjectsincategory")).Return(getsubjectsincategoryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetChildCategories(readerCreator, _test_categoryid);

            // VERIFY THE RESULTS
            Assert.AreEqual(actual.Count, 0);
        }

        /// <summary>
        /// Tests if GetChildCategories returns the correct subnode structure when the category has subnodes
        /// </summary>
        [TestMethod()]
        public void GetChildCategories_WithSubNodes_ReturnsValidSubNodes()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            GetChildCategories_SetupDefaultMocks(out mocks, out readerCreator);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader getsubjectsincategoryReader = mocks.DynamicMock<IDnaDataReader>();
            getsubjectsincategoryReader.Stub(x => x.HasRows).Return(true);
            getsubjectsincategoryReader.Stub(x => x.Read()).Return(true).Repeat.Times(2);
            
            // first row (child 1)
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeID")).Return(999).Repeat.Twice();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeCount")).Return(5).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("ArticleCount")).Return(7).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("AliasCount")).Return(8).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return("Parent").Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetStringNullAsEmpty("SubName")).Return("Child1").Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("SubNodeType")).Return(1).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.DoesFieldExist("SubName")).Return(true).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.IsDBNull("SubName")).Return(false).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("SubNodeID")).Return(123).Repeat.Once();            

            // second row (child 2)
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeID")).Return(999).Repeat.Twice();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("NodeCount")).Return(9).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("Type")).Return(1).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("ArticleCount")).Return(11).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("AliasCount")).Return(12).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return("Parent").Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.DoesFieldExist("SubName")).Return(true).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.IsDBNull("SubName")).Return(false).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetStringNullAsEmpty("SubName")).Return("Child2").Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("SubNodeType")).Return(1).Repeat.Once();
            getsubjectsincategoryReader.Stub(x => x.GetInt32NullAsZero("SubNodeID")).Return(456).Repeat.Once();

            readerCreator.Stub(x => x.CreateDnaDataReader("getsubjectsincategory")).Return(getsubjectsincategoryReader);

            // EXECUTE THE TEST
            mocks.ReplayAll();
            List<CategorySummary> actual = CategorySummary.GetChildCategories(readerCreator, _test_nodeid);

            // VERIFY THE RESULTS
            // check the subnode structure was created correctly
            Assert.IsNotNull(actual.First());
            Assert.IsNotNull(actual.First().SubNodes);
            Assert.IsNotNull(actual.First().SubNodes.First());
            Assert.AreEqual(123, actual.First().SubNodes.First().ID);
            Assert.AreEqual(1, actual.First().SubNodes.First().Type);
            Assert.AreEqual("Child1", actual.First().SubNodes.First().Value);
            Assert.AreEqual(456, actual.First().SubNodes[1].ID);
            Assert.AreEqual(1, actual.First().SubNodes[1].Type);
            Assert.AreEqual("Child2", actual.First().SubNodes[1].Value);
        }

 
    }
}
