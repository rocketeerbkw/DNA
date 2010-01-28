using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Sites;
using System;
using Rhino.Mocks.Constraints;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ForumHelperTest and is intended
    ///to contain all ForumHelperTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ForumHelperTest
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

        public MockRepository mocks = new MockRepository();

        /// <summary>
        ///A test for MarkThreadRead
        ///</summary>
        [TestMethod()]
        public void MarkThreadRead_ValidDbCall_ReturnsNoExceptions()
        {
            
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("markthreadread")).Return(reader);
            mocks.ReplayAll();

            int userId = 0; 
            int threadId = 0; 
            int postId = 0; 
            bool force = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.MarkThreadRead(userId, threadId, postId, force);
            helper.MarkThreadRead(userId, threadId, postId, true);
            
        }

        /// <summary>
        ///A test for GetThreadPermissions
        ///</summary>
        [TestMethod()]
        public void GetThreadPermissions_ValidDataSet_ReturnsExpectedResults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(true);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            mocks.ReplayAll();

            int userId = 0; 
            int threadId = 0; 
            bool canRead = false; 
            bool canReadExpected = true; 
            bool canWrite = false; 
            bool canWriteExpected = true;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetThreadPermissions(userId, threadId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetThreadPermissions
        ///</summary>
        [TestMethod()]
        public void GetThreadPermissions_NoData_ReturnsUnchangedDefaults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetBoolean("CanRead")).Return(false);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(false);
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            mocks.ReplayAll();

            int userId = 0;
            int threadId = 0;
            bool canRead = false;
            bool canReadExpected = false;
            bool canWrite = false;
            bool canWriteExpected = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetThreadPermissions(userId, threadId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetForumPermissions
        ///</summary>
        [TestMethod()]
        public void GetForumPermissions_ValidDataSet_ReturnsExpectedResults()
        {
            int canReadOut = 0;
            int canWriteOut = 0;
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(1);
            reader.Stub(x => x.TryGetIntOutputParameter("CanWrite", out canWriteOut)).Return(true).OutRef(1);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            mocks.ReplayAll();
 

            int userId = 0; 
            int forumId = 0; 
            bool canRead = false; 
            bool canReadExpected = true; 
            bool canWrite = false; 
            bool canWriteExpected = true;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetForumPermissions(userId, forumId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for GetForumPermissions
        ///</summary>
        [TestMethod()]
        public void GetForumPermissionsTest_NoData_ReturnsUnchangedDefaults()
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
            mocks.ReplayAll();


            int userId = 0;
            int forumId = 0;
            bool canRead = false;
            bool canReadExpected = false;
            bool canWrite = false;
            bool canWriteExpected = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetForumPermissions(userId, forumId, ref canRead, ref canWrite);
            Assert.AreEqual(canReadExpected, canRead);
            Assert.AreEqual(canWriteExpected, canWrite);
        }

        /// <summary>
        ///A test for CloseThread
        ///</summary>
        [TestMethod()]
        public void CloseThread_AsEditor_CallsSp()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(true);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("closethread")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();
            
            ForumHelper target = new ForumHelper(creator, viewingUser, null); 
            target.CloseThread(0,0,0);
            
        }

        /// <summary>
        ///A test for CloseThread
        ///</summary>
        [TestMethod()]
        public void CloseThread_AsSuperUser_CallsSp()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("closethread")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, null);
            target.CloseThread(0, 0, 0);

        }

        /// <summary>
        ///A test for CloseThread
        ///</summary>
        [TestMethod()]
        public void CloseThread_AsAuthorWithSiteOption_CallsSp()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueBool(0, "Forum", "ArticleAuthorCanCloseThreads")).Return(true);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("closethread")).Return(reader).Repeat.AtLeastOnce();
            creator.Stub(x => x.CreateDnaDataReader("isuserinauthormembersofarticle")).Return(reader);
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.CloseThread(0, 0, 0);

        }

        /// <summary>
        ///A test for CloseThread
        ///</summary>
        [TestMethod()]
        public void CloseThread_AsAuthorWithoutSiteOption_CallsSp()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueBool(0, "Forum", "ArticleAuthorCanCloseThreads")).Return(false);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("closethread")).Throw(new Exception("closethread should not have been called"));
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.CloseThread(0, 0, 0);

            Assert.AreEqual("CloseThread", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to close threads", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for CloseThread
        ///</summary>
        [TestMethod()]
        public void CloseThread_NotAuthorWithSiteOption_CallsSp()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueBool(0, "Forum", "ArticleAuthorCanCloseThreads")).Return(true);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("closethread")).Throw(new Exception("closethread should not have been called"));
            creator.Stub(x => x.CreateDnaDataReader("isuserinauthormembersofarticle")).Return(reader);
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.CloseThread(0, 0, 0);

            Assert.AreEqual("CloseThread", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to close threads", target.LastError.ErrorMessage);


        }

        

        /// <summary>
        ///A test for HideThread
        ///</summary>
        [TestMethod()]
        public void HideThread_NotSuperUser_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueBool(0, "Forum", "ArticleAuthorCanCloseThreads")).Return(true);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Throw(new Exception("SetThreadVisibletoUsers should not have been called"));
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList); 
            target.HideThread(0,0);

            Assert.AreEqual("HideThread", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to hide threads", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for HideThread
        ///</summary>
        [TestMethod()]
        public void HideThread_ThreadNotInForum_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(0);
            

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.Once();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.HideThread(0, 0);

            Assert.AreEqual("HideThread", target.LastError.Type);
            Assert.AreEqual("Unable to hide thread", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for HideThread
        ///</summary>
        [TestMethod()]
        public void HideThread_NotRead_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(0);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.Once();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.HideThread(0, 0);

            Assert.AreEqual("HideThread", target.LastError.Type);
            Assert.AreEqual("Unable to hide thread", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for HideThread
        ///</summary>
        [TestMethod()]
        public void HideThread_IsInForum_ReturnsSuccess()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.HideThread(0, 0);

            Assert.IsNull(target.LastError);

        }

        /// <summary>
        ///A test for UpdateAlertInstantly
        ///</summary>
        [TestMethod()]
        public void UpdateAlertInstantly_NotAllowed_ReturnsError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateForumAlertInstantly")).Return(reader).Throw(new Exception("UpdateForumAlertInstantly should not be called"));
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateAlertInstantly(0, 0);

            Assert.AreEqual("UpdateAlertInstantly", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to update AlertInstantly flag", target.LastError.ErrorMessage);
        }

        /// <summary>
        ///A test for UpdateAlertInstantly
        ///</summary>
        [TestMethod()]
        public void UpdateAlertInstantly_AsEditor_ReturnsNoError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(true);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateForumAlertInstantly")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateAlertInstantly(0, 0);

            Assert.IsNull(target.LastError);
        }

        /// <summary>
        ///A test for UpdateAlertInstantly
        ///</summary>
        [TestMethod()]
        public void UpdateAlertInstantly_AsSuperUser_ReturnsNoError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("UpdateForumAlertInstantly")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();

            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateAlertInstantly(0, 1);

            Assert.IsNull(target.LastError);
        }

        /// <summary>
        ///A test for IsUserAuthorForArticle
        ///</summary>
        [TestMethod()]
        [DeploymentItem("BBC.Dna.Objects.dll")]
        public void IsUserAuthorForArticle_NoRows_ReturnsFalse()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("isuserinauthormembersofarticle")).Return(reader);
            mocks.ReplayAll();
            ForumHelper_Accessor target = new ForumHelper_Accessor(creator, viewingUser, null); 
            Assert.IsFalse(target.IsUserAuthorForArticle(0));

        }

        /// <summary>
        ///A test for IsUserAuthorForArticle
        ///</summary>
        [TestMethod()]
        [DeploymentItem("BBC.Dna.Objects.dll")]
        public void IsUserAuthorForArticle_NoRead_ReturnsFalse()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("isuserinauthormembersofarticle")).Return(reader);
            mocks.ReplayAll();
            ForumHelper_Accessor target = new ForumHelper_Accessor(creator, viewingUser, null);
            Assert.IsFalse(target.IsUserAuthorForArticle(0));

        }


        /// <summary>
        ///A test for IsUserAuthorForArticle
        ///</summary>
        [TestMethod()]
        [DeploymentItem("BBC.Dna.Objects.dll")]
        public void IsUserAuthorForArticle_ValidResults_ReturnsTrue()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("isuserinauthormembersofarticle")).Return(reader);
            mocks.ReplayAll();
            ForumHelper_Accessor target = new ForumHelper_Accessor(creator, viewingUser, null);
            Assert.IsTrue(target.IsUserAuthorForArticle(0));

        }


        /// <summary>
        ///A test for ReOpenThread
        ///</summary>
        [TestMethod()]
        public void ReOpenThread_NotSuperUser_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("ThreadBelongsToForum")).Throw(new Exception("ThreadBelongsToForum should not have been called"));
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.ReOpenThread(0, 0);

            Assert.AreEqual("UnHideThread", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to reopen threads", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for ReOpenThread
        ///</summary>
        [TestMethod()]
        public void ReOpenThread_ThreadNotInForum_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.AddParameter("", "")).Constraints(Is.Anything(), Is.Anything());
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(0);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.ReOpenThread(0, 0);

            Assert.AreEqual("UnHideThread", target.LastError.Type);
            Assert.AreEqual("Unable to open thread", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for ReOpenThread
        ///</summary>
        [TestMethod()]
        public void ReOpenThread_NotRead_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(true);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(0);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.ReOpenThread(0, 0);

            Assert.AreEqual("UnHideThread", target.LastError.Type);
            Assert.AreEqual("Unable to open thread", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for ReOpenThread
        ///</summary>
        [TestMethod()]
        public void ReOpenThread_IsInForum_ReturnsSuccess()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("ThreadBelongsToForum")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("SetThreadVisibletoUsers")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.ReOpenThread(0, 0);

            Assert.IsNull(target.LastError);

        }

        /// <summary>
        ///A test for UpdateForumPermissions
        ///</summary>
        [TestMethod()]
        public void UpdateForumPermissions_NotAllow_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforumpermissions")).Return(reader).Throw(new Exception("updateforumpermissions should not be called"));
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);

            target.UpdateForumPermissions(0,0,0,0,0);
            Assert.AreEqual("UpdateForumPermissions", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to update forum permissions", target.LastError.ErrorMessage);
            
        }

        /// <summary>
        ///A test for UpdateForumPermissions
        ///</summary>
        [TestMethod()]
        public void UpdateForumPermissions_AsEditor_ReturnsNoError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(true);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforumpermissions")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);

            target.UpdateForumPermissions(0, 0, 0, 0, 0);
            Assert.IsNull(target.LastError);

        }

        /// <summary>
        ///A test for UpdateForumPermissions
        ///</summary>
        [TestMethod()]
        public void UpdateForumPermissions_AsSuperUser_ReturnsNoError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforumpermissions")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);

            target.UpdateForumPermissions(0, 0, 0, 0, 0);
            Assert.IsNull(target.LastError);

        }


        /// <summary>
        ///A test for UpdateForumModerationStatus
        ///</summary>
        [TestMethod()]
        public void UpdateForumModerationStatus_NotSuperUser_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforummoderationstatus")).Throw(new Exception("updateforummoderationstatus should not have been called"));
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateForumModerationStatus(0, 0);

            Assert.AreEqual("UpdateForumModerationStatus", target.LastError.Type);
            Assert.AreEqual("Logged in user is not authorised to update status", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for UpdateForumModerationStatus
        ///</summary>
        [TestMethod()]
        public void UpdateForumModerationStatus_NotSuccessInRecordset_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Success")).Return(0);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforummoderationstatus")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateForumModerationStatus(0, 0);

            Assert.AreEqual("FORUM-MOD-STATUS-UPDATE", target.LastError.Type);
            Assert.AreEqual("Failed to update the moderation status of the forum!", target.LastError.ErrorMessage);

        }

        /// <summary>
        ///A test for UpdateForumModerationStatus
        ///</summary>
        [TestMethod()]
        public void UpdateForumModerationStatus_NotRead_ReturnsValidError()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(true);
            viewingUser.Stub(x => x.IsSuperUser).Return(false);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            reader.Stub(x => x.GetInt32NullAsZero("Success")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforummoderationstatus")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateForumModerationStatus(0, 0);

            Assert.AreEqual("FORUM-MOD-STATUS-UPDATE", target.LastError.Type);
            Assert.AreEqual("Failed to update the moderation status of the forum!", target.LastError.ErrorMessage);


        }

        /// <summary>
        ///A test for UpdateForumModerationStatus
        ///</summary>
        [TestMethod()]
        public void UpdateForumModerationStatus_WithSuccessReturned_ReturnsSuccess()
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsEditor).Return(false);
            viewingUser.Stub(x => x.IsSuperUser).Return(true);

            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Success")).Return(1);


            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updateforummoderationstatus")).Return(reader).Repeat.AtLeastOnce();
            mocks.ReplayAll();


            ForumHelper target = new ForumHelper(creator, viewingUser, siteList);
            target.UpdateForumModerationStatus(0, 0);

            Assert.IsNull(target.LastError);

        }
    }
}
