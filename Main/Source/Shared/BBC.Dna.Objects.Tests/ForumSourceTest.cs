using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestUtils;
namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ForumSourceTest and is intended
    ///to contain all ForumSourceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ForumSourceTest
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
        ///A test for ForumSource Constructor
        ///</summary>
        [TestMethod()]
        public void ForumSourceXmlTest()
        {
            ForumSource target = new ForumSource();
            target.Type = ForumSourceType.Article;
            target.Article = ArticleTest.CreateArticle();
            Serializer.ValidateObjectToSchema(target, "ForumSource.xsd");
        }
    }
}
