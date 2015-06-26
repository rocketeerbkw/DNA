using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for ExtraInfoCreatorTest
    /// </summary>
    [TestClass]
    public class ExtraInfoCreatorTest
    {
        public ExtraInfoCreatorTest()
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

        [TestMethod]
        public void ArticleExtraInfoCreatorTest()
        {
            string articleExtraInfo = String.Format(@"<EXTRAINFO><TYPE ID=""{0}"" NAME=""{1}""/></EXTRAINFO>", 1, "Article");
            Assert.AreEqual(ExtraInfoCreator.CreateExtraInfo(1), articleExtraInfo) ;
        }
    }
}
