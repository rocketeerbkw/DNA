using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ArticleInfoReferencesEntryLinkTest and is intended
    ///to contain all ArticleInfoReferencesEntryLinkTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ArticleInfoReferencesEntryLinkTest
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
        ///A test for CreateArticleReferences
        ///</summary>
        [TestMethod()]
        public void CreateArticleReferences_Create90References_Returns90CorrectFormat()
        {
            List<int> articleIDs = new List<int>();
            for (int i = 0; i < 100; i++)
            {//create array of 100 items
                articleIDs.Add(i);
            }

            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(90);
            Expect.Call(reader.AddParameter("", 1)).Return(reader).IgnoreArguments().Repeat.Any();
            reader.Stub(x => x.GetInt32("h2g2ID")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("fetcharticles")).Return(reader);

            mocks.ReplayAll();
            List<ArticleInfoReferencesEntryLink> actual;
            actual = ArticleInfoReferencesEntryLink.CreateArticleReferences(articleIDs, creator);
            Assert.AreEqual(actual.Count, 90);//limited to 90
            Assert.AreEqual(actual[0].H2g2, "A1");

        }
    }
}
