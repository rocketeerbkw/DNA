using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for OnlineUsersTest and is intended
    ///to contain all OnlineUsersTest Unit Tests
    ///</summary>
    [TestClass()]
    public class OnlineUsersTest
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
        ///A test for GetOnlineUsers
        ///</summary>
        [TestMethod()]
        public void GetOnlineUsers_FromDataBase_ReturnsCorrectList()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(4);
            reader.Stub(x => x.GetDateTime("DateJoined")).Return(DateTime.Now.AddDays(-4));
            reader.Stub(x => x.GetByte("Editor")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("currentusers")).Return(reader);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            mocks.ReplayAll();
            
            OnlineUsers actual = OnlineUsers.GetOnlineUsers(creator, cache, OnlineUsersOrderBy.None, 0, true, false);
            Assert.AreEqual(4, actual.OnlineUser.Count);
            Assert.AreEqual("Member 0", actual.OnlineUser[0].User.Username);
            
        }

        /// <summary>
        ///A test for GetOnlineUsers
        ///</summary>
        [TestMethod()]
        public void GetOnlineUsers_FromDataBaseEmpty_ReturnsCorrectFailObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("currentusers")).Return(reader);

            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Return(null).Constraints(Is.Anything());
            mocks.ReplayAll();

            OnlineUsers actual = OnlineUsers.GetOnlineUsers(creator, cache, OnlineUsersOrderBy.None, 0, true, false);
            Assert.AreEqual(null, actual.OnlineUser);
            Assert.AreEqual("Nobody is online! Nobody! Not even you!", actual.Weird);

        }

        /// <summary>
        ///A test for GetOnlineUsers
        ///</summary>
        [TestMethod()]
        public void GetOnlineUsers_FromCache_ReturnsCorrectList()
        {
            OnlineUsers expected = GetOnlineUsers();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            ICacheManager cache = mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Return(expected).Constraints(Is.Anything());
            mocks.ReplayAll();

            OnlineUsers actual = OnlineUsers.GetOnlineUsers(creator, cache, OnlineUsersOrderBy.None, 0, true, false);
            Assert.AreEqual(actual.OnlineUser.Count, actual.OnlineUser.Count);
            Assert.AreEqual(actual.OnlineUser[0].User.Username, actual.OnlineUser[0].User.Username);

        }

        

        /// <summary>
        /// Create a test online users object
        /// </summary>
        /// <returns></returns>
        static public OnlineUsers GetOnlineUsers()
        {
            OnlineUserInfo info = new OnlineUserInfo()
            {
                Username = string.Empty
            };
            OnlineUser user = new OnlineUser()
            {
                User = info,
            };
            OnlineUsers users = new OnlineUsers() { 
                OnlineUser = new System.Collections.Generic.List<OnlineUser>(),
                OrderBy = OnlineUsersOrderBy.None.ToString()
            };
            users.OnlineUser.Add(user);

            return users;

        }
    }
}
