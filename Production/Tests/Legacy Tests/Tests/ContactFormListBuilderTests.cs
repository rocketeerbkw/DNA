using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna;
using NMock2;
using BBC.Dna.Sites;
using BBC.Dna.Data;

namespace Tests
{
    /// <summary>
    /// Summary description for ContactFormListBuilderTests
    /// </summary>
    [TestClass]
    public class ContactFormListBuilderTests
    {
        /// <summary>
        /// 
        /// </summary>
        public ContactFormListBuilderTests()
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
        /// 
        /// </summary>
        [TestMethod]
        [Ignore]
        //TODO: Talk with Mark H to understand the purpose of this test.
        //Why is this relevent specifically to ContactFormListBuilder for example?
        //Is it not a more generic unit test for base functionality?
        public void GivenCallingProcessInputParametersShouldSetSkipAndShowVariables()
        {
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            ISite mockedSite = mock.NewMock<ISite>();

            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            ContactFormListBuilder_Accessor privateAccessor = new ContactFormListBuilder_Accessor(mockedInputContext);

            int expectedShow = 20;
            int expectedSkip = 10;
            int expectedSiteID = 66;

            Stub.On(mockedInputContext).Method("DoesParamExist").With("skip", "Items to skip").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("DoesParamExist").With("show", "Items to show").Will(Return.Value(true));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("skip", "Items to skip").Will(Return.Value(expectedSkip));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("show", "Items to show").Will(Return.Value(expectedShow));
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").With("dnasiteid", "The specified site").Will(Return.Value(expectedSiteID));

            privateAccessor.ProcessInputParameters();

            Assert.AreEqual(privateAccessor.show, expectedShow);
            Assert.AreEqual(privateAccessor.skip, expectedSkip);
            Assert.AreEqual(privateAccessor.requestedSiteID, expectedSiteID);
        }

        //[TestMethod]
        //public void GivenValidDataReaderShouldCreateXML()
        //{
        //    Mockery mock = new Mockery();
        //    IInputContext mockedInputContext = mock.NewMock<IInputContext>();
        //    IDnaDataReader mockedReader = mock.NewMock<IDnaDataReader>();

        //    Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getcontactformslist").Will(Return.Value(mockedReader));

        //    ContactFormListBuilder_Accessor privateAccessor = new ContactFormListBuilder_Accessor(mockedInputContext);

        //    privateAccessor.GenerateXMLFromDataReader(mockedReader);
        //}
    }
}
