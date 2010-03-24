using System.Xml;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ExtraInfoTest and is intended
    ///to contain all ExtraInfoTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ExtraInfoTest
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
        ///A test for CreateExtraInfo
        ///</summary>
        [TestMethod()]
        public void CreateExtraInfo_ValidXml_ReturnsValidObject()
        {
            string text = "this is a test";
            string xml = "<test>" + text + "</test>";
            XmlElement actual;
            actual = ExtraInfoCreator.CreateExtraInfo(xml);
            Assert.AreEqual(actual.ChildNodes.Count, 1);
            Assert.AreEqual(actual.ChildNodes[0].InnerText, text);

        }

        [TestMethod()]
        public void CreateExtraInfo_InvalidXml_ReturnsInvalidObject()
        {
            string text = "this is a test";
            string xml = "<test>" + text + "</test>";
            XmlElement actual;

            //now for the crap xml
            xml = xml = "<test>" + text;
            actual = ExtraInfoCreator.CreateExtraInfo(xml);
            Assert.AreEqual(actual, null);

        }
    }
}
