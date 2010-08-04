using System;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;



namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for UserTest and is intended
    ///to contain all UserTest Unit Tests
    ///</summary>
    [TestClass()]
    public class UserTest
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


        

        public static User CreateTestUser()
        {
            IUser target = new User(null, null, null)
            {
                UserId = 1,
                IdentityUserId = "90680774725696464",
                UserMode = 1,
                UnReadPrivateMessageCount = 0,
                UnReadPublicMessageCount = 1,
                AcceptSubscriptions = 1,
                Active = true,
                Allocations = 5,
                Area = "area",
                DateJoined = new DateElement(DateTime.Now.AddDays(-5)),
                DateLastNotified = new DateElement(DateTime.Now.AddDays(-2)),
                Email = "m@b.com",
                FirstNames = "marcus",
                LastName = "parnwell",
                ForumId = 56,
                ForumPostedTo = 4,
                HideLocation = 1,
                HideUsername = 1,
                Journal = 1,
                MastHead = 3423,
                PostCode = "w14",
                PrefUserMode = false,
                PromptSetUsername = true,
                Region = "london",
                Score = 0.0,
                SinBin = 1,
                SiteSuffix = "h2g2",
                Status = (int)UserStatus.Active,
                SubQuota = 1,
                TaxonomyNode = 1,
                TeamId = 0,
                Title = "mr",
                UserName = "marcusparnwell"

            };
            return (User)target;
        }




        /// <summary>
        ///A test for CreateIUserFromReader
        ///</summary>
        [TestMethod()]
        public void CreateUserFromReader_ValidDataSet_ReturnsValidUser()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetInt32NullAsZero("userID")).Return(1);
            reader.Stub(x => x.Exists("")).Return(true).Constraints(Is.Anything());
            mocks.ReplayAll();

            User actual;
            actual = User.CreateUserFromReader(reader);
            Assert.AreEqual(actual.UserId, 1);
        }

        /// <summary>
        ///A test for CreateIUserFromReader
        ///</summary>
        [TestMethod()]
        public void CreateUserFromReader_WithPrefix_ReturnsValidUser()
        {
            string prefix = "prefix";
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetInt32NullAsZero(prefix + "userID")).Return(1);
            reader.Stub(x => x.Exists("")).Return(true).Constraints(Is.Anything());
            mocks.ReplayAll();

            User actual;
            actual = User.CreateUserFromReader(reader, prefix);
            Assert.AreEqual(actual.UserId, 1);
        }
    }
}
