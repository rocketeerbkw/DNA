using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace BBC.Dna.Users.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class TestUserAccountCheckTests
    {
        public TestUserAccountCheckTests()
        {

        }

        private TestContext testContextInstance;
        private const string TESTURL = "";

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
        public void ProfileAPITestUserShouldSignIn()
        {
            using (DnaTestURLRequest request = new DnaTestURLRequest("comment"))
            {
                request.SetCurrentUserProfileTest();
                request.RequestPageWithFullURL("http://local.bbc.co.uk:8081/dna/api/UsersService/UsersService.svc/V1/site/h2g2/users/callinguser");
            }
        }

        [TestMethod]
        public void DotNetNormalUserUserShouldSignIn()
        {
            using (DnaTestURLRequest request = new DnaTestURLRequest("comment"))
            {
                request.SetCurrentUserNormal();
                request.RequestPageWithFullURL("http://local.bbc.co.uk:8081/dna/api/UsersService/UsersService.svc/V1/site/h2g2/users/callinguser");
            }
        }
    }
}
