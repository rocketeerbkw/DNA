using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
using System;
using System.Collections.Generic;
using Rhino.Mocks;
using TestUtils.Mocks.Extentions;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using TestUtils;
using BBC.Dna.Sites;
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    ///This is a test class for SubscribingUsersListTest and is intended
    ///to contain all SubscribingUsersListTest Unit Tests
    ///</summary>
    [TestClass]
    public class SubscribingUsersListTest
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
        ///A test for SubscribingUsersList Constructor
        ///</summary>
        [TestMethod]
        public void SubscribingUsersListXmlTest()
        {
            SubscribingUsersList subscribingUsers = new SubscribingUsersList();
            XmlDocument xml = Serializer.SerializeToXml(subscribingUsers);

            Assert.IsNotNull(xml.SelectSingleNode("SUBSCRIBINGUSERSLIST"));

        }

        /// <summary>
        ///A test for SubscribingUsersListTest
        ///</summary>
        [TestMethod]
        public void CreateSubscribingUsersListTest()
        {
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupSubscribingUsersListMocks(out mocks, out creator, out reader, out reader2, 2);

            SubscribingUsersList subscribingUsers;

            subscribingUsers = SubscribingUsersList.CreateSubscribingUsersListFromDatabase(creator, identityusername, siteId, 0, 20, false);
            Assert.AreNotEqual(null, subscribingUsers);

            XmlDocument xml = Serializer.SerializeToXml(subscribingUsers);
        }

        /// <summary>
        /// Tests if SubscribingUsersList returns an empty list when there aren't any subscribingUsers.
        /// </summary>
        [TestMethod]
        public void GetSubscribingUsersList_ReturnsEmptyList()
        {
            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";

            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupSubscribingUsersListMocks(out mocks, out creator, out reader, out reader2, 0);

            SubscribingUsersList subscribingUsers;

            // EXECUTE THE TEST
            subscribingUsers = SubscribingUsersList.CreateSubscribingUsersListFromDatabase(creator, identityusername, siteId, 0, 20, false);

            Assert.IsTrue(subscribingUsers.Users.Count == 0, "Users found - should be empty");
        }

        /// <summary>
        /// Tests if CreateSubscribingUsersList actually ignores the cache when IgnoreCache = true
        /// </summary>
        [TestMethod]
        public void CreateSubscribingUsersList_IgnoreCache_CacheIsIgnored()
        {
            bool ignoreCache = true;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupSubscribingUsersListMocks(out mocks, out creator, out reader, out reader2, 2);

            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null).Throw(new Exception("GetData should not be called"));
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            SubscribingUsersList actual = SubscribingUsersList.CreateSubscribingUsersList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        /// Tests if CreateSubscribingUsersList bypasses the cache when DoNotIgnoreCache = true but uptodate is false
        /// </summary>
        [TestMethod]
        public void CreateSubscribingUsersList_WithDontIgnoreCache_NotUpToDate_ReturnsValidObject()
        {
            bool ignoreCache = false;

            // PREPARE THE TEST
            // setup the default mocks
            int siteId = 1;
            string identityusername = "DotNetNormalUser";
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReader reader2;
            IDnaDataReaderCreator creator;

            SetupSubscribingUsersListMocks(out mocks, out creator, out reader, out reader2, 2);

            var subscribingUsers = mocks.DynamicMock<SubscribingUsersList>();
            subscribingUsers.Stub(x => x.IsUpToDate(null)).Constraints(Is.Anything()).Return(false);


            var cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(subscribingUsers);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            mocks.ReplayAll();

            SubscribingUsersList actual = SubscribingUsersList.CreateSubscribingUsersList(cache, creator, null, identityusername, siteId, 0, 20, false, ignoreCache);
            Assert.IsNotNull(actual);
            Assert.IsNotNull(actual);
        }

        /// <summary>
        ///A test for IsUpToDate
        ///</summary>
        [TestMethod]
        public void IsUpToDate_SubscribingUsersListOutOfDate_ReturnsCorrect()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks = new MockRepository();

            var target = new SubscribingUsersList()
            {
                Users = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
            };

            var reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            var creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            mocks.ReplayAll();

            Assert.AreEqual(false, target.IsUpToDate(creator));
        }

        /// <summary>
        ///A test for GetCacheKey
        ///</summary>
        [TestMethod]
        public void GetCacheKeyTest()
        {
            var subscribingUsers = new SubscribingUsersList();
            string expected = string.Format("{0}|0|0|0|0|True|0|", typeof(SubscribingUsersList).AssemblyQualifiedName);
            string actual = subscribingUsers.GetCacheKey(0, 0, 0, 0, true, 0);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// Returns a test SubscribingUsersList
        /// </summary>
        /// <returns></returns>
        public static SubscribingUsersList CreateTestSubscribingUsersList()
        {
            var subscribingUsers = new SubscribingUsersList()
            {
                Users = new List<UserElement> { new UserElement() { user = UserTest.CreateTestUser() } }
            };
            return subscribingUsers;
        }

        #region MockSetup

        /// <summary>
        /// Helper function to set up parameters for CreateSubscribingUsersList call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateSubscribingUsersList_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        private static void InitialiseMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();

            // mock the search response
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader2 = mocks.DynamicMock<IDnaDataReader>();
        }

        private void SetupSubscribingUsersListMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out IDnaDataReader reader2, int rowsToReturn)
        {
            InitialiseMocks(out mocks, out readerCreator, out reader, out reader2);

            if (rowsToReturn == 0)
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                //Return the user but no rows
                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true).Repeat.Once();
                reader2.Stub(x => x.Read()).Return(false).Repeat.Once();

                reader2.Stub(x => x.NextResult()).Return(false);

                AddSubscribingUsersListUserDatabaseRows(reader, "");
                AddSubscribingUsersListUserDatabaseRows(reader2, "SubscribedTo");
                reader.Stub(x => x.GetBoolean("SubscribedToAcceptSubscriptions")).Return(true).Repeat.Once();

            }
            else
            {
                reader.Stub(x => x.HasRows).Return(true);
                reader.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.HasRows).Return(true);
                reader2.Stub(x => x.Read()).Return(true);

                reader2.Stub(x => x.NextResult()).Return(true);

                AddSubscribingUsersListUserDatabaseRows(reader, "");

                AddSubscribingUsersListUserDatabaseRows(reader2, "SubscribedTo");
                AddSubscribingUsersListUserDatabaseRows(reader2, "");
                AddSubscribingUsersListUserDatabaseRows(reader2, "");

            }

            readerCreator.Stub(x => x.CreateDnaDataReader("getdnauseridfromidentityusername")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getsubscribingusers")).Return(reader2);

            mocks.ReplayAll();
        }

        private void AddSubscribingUsersListUserDatabaseRows(IDnaDataReader reader, string suffix)
        {
            reader.Stub(x => x.Exists(suffix + "userID")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "userID")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "userid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "userid")).Return(1090497224).Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "IdentityUserID")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "IdentityUserID")).Return("608234").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "LoginName")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "LoginName")).Return("Damnyoureyes").Repeat.Once();

            reader.Stub(x => x.Exists(suffix + "Name")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Name")).Return("name").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Area")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Area")).Return("Editor Area").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Status")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "Status")).Return(2).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "TaxonomyNode")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "TaxonomyNode")).Return(3).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Journal")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(suffix + "Journal")).Return(4).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Active")).Return(true);
            reader.Stub(x => x.GetBoolean(suffix + "Active")).Return(true).Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "SiteSuffix")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "SiteSuffix")).Return("suffix").Repeat.Once();
            reader.Stub(x => x.Exists(suffix + "Title")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty(suffix + "Title")).Return("title").Repeat.Once();

        }
        #endregion
    }
}
