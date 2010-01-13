using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;



namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ArticleTest and is intended
    ///to contain all ArticleTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ArticleTest
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
        ///A test for ValidateH2G2ID
        ///</summary>
        [TestMethod()]
        public void ValidateH2G2ID_EmptyID_ReturnsFalse()
        {
            int h2g2ID = 0;
            bool expected = false;
            bool actual;
            actual = Article.ValidateH2G2ID(h2g2ID);
            Assert.AreEqual(expected, actual);


        }

        /// <summary>
        ///A test for ValidateH2G2ID
        ///</summary>
        [TestMethod()]
        public void ValidateH2G2ID_ValidID_ReturnsTrue()
        {
            int h2g2ID = 0;
            bool expected = false;
            bool actual;
            h2g2ID = 108;
            expected = true;
            actual = Article.ValidateH2G2ID(h2g2ID);
            Assert.AreEqual(expected, actual);


        }

        /// <summary>
        ///A test for GetBookmarkCount
        ///</summary>
        [TestMethod()]
        public void GetBookmarkCount_WithSingleRow_ReturnsSingleBookmark()
        {
            Article target = new Article();
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("BookmarkCount")).Return(1);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetBookmarkCount")).Return(reader);
            mocks.ReplayAll();

            target.GetBookmarkCount(creator);
            Assert.AreEqual(target.BookmarkCount, 1);
        }

        /// <summary>
        ///A test for UpdatePermissionsForViewingIUser
        ///</summary>
        [TestMethod()]
        public void UpdatePermissionsForViewingUser_StandardUser_ReturnsModifiedCanRead()
        {
            Article target = new Article() { CanRead = 1 };
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            IUser viewingIUser;
            UpdatePermissionsForViewingUserTestSetup(out mocks, out reader, out creator, out viewingIUser);

            target.UpdatePermissionsForViewingUser(viewingIUser, creator);
            Assert.AreEqual(0, target.CanRead);

            //has rows is false
            target = new Article() { CanRead = 1 };
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);
            
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetArticlePermissionsForUser")).Return(reader);
            
            mocks.ReplayAll();
            target.UpdatePermissionsForViewingUser(viewingIUser, creator);
            Assert.AreEqual(1, target.CanRead);
            
            //has x.Read() is false
            target = new Article() { CanRead = 1 };
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);
            
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetArticlePermissionsForUser")).Return(reader);
            
            mocks.ReplayAll();
            target.UpdatePermissionsForViewingUser(viewingIUser, creator);
            Assert.AreEqual(1, target.CanRead);

        }

        /// <summary>
        ///A test for UpdatePermissionsForViewingIUser
        ///</summary>
        [TestMethod()]
        public void UpdatePermissionsForViewingUser_HasRowsFalse_ReturnsSameCanRead()
        {
            Article target = new Article() { CanRead = 1 };
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            IUser viewingIUser;
            UpdatePermissionsForViewingUserTestSetup(out mocks, out reader, out creator, out viewingIUser);

            
            //has rows is false
            target = new Article() { CanRead = 1 };
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(true);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetArticlePermissionsForUser")).Return(reader);

            mocks.ReplayAll();
            target.UpdatePermissionsForViewingUser(viewingIUser, creator);
            Assert.AreEqual(1, target.CanRead);

        }

        /// <summary>
        ///A test for UpdatePermissionsForViewingIUser
        ///</summary>
        [TestMethod()]
        public void UpdatePermissionsForViewingUser_CanReadFalse_ReturnsSameCanRead()
        {
            Article target = new Article() { CanRead = 1 };
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            IUser viewingIUser;
            UpdatePermissionsForViewingUserTestSetup(out mocks, out reader, out creator, out viewingIUser);


            //has x.Read() is false
            target = new Article() { CanRead = 1 };
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(false);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetArticlePermissionsForUser")).Return(reader);

            mocks.ReplayAll();
            target.UpdatePermissionsForViewingUser(viewingIUser, creator);
            Assert.AreEqual(1, target.CanRead);

        }

        private static void UpdatePermissionsForViewingUserTestSetup(out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator, out IUser viewingIUser)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("CanRead")).Return(0);
            reader.Stub(x => x.GetInt32NullAsZero("CanWrite")).Return(0);
            reader.Stub(x => x.GetInt32NullAsZero("CanChangePermissions")).Return(0);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("GetArticlePermissionsForUser")).Return(reader);

            viewingIUser = mocks.DynamicMock<IUser>();
            viewingIUser.Stub(x => x.UserLoggedIn).Return(true);
            mocks.ReplayAll();
        }

        /// <summary>
        ///A test for UpdatePermissionsForViewingIUser
        ///</summary>
        [TestMethod()]
        public void UpdatePermissionsForViewingUserTest_AsEditorSuperIUser()
        {
            Article target = new Article();
            MockRepository mocks = new MockRepository();
            IUser viewingIUser = mocks.DynamicMock<IUser>();
            viewingIUser.Stub(x => x.UserLoggedIn).Return(true);
            viewingIUser.Stub(x => x.IsEditor).Return(true);
            viewingIUser.Stub(x => x.IsSuperUser).Return(false);
            mocks.ReplayAll();

            target.UpdatePermissionsForViewingUser(viewingIUser, null);
            Assert.AreEqual(1, target.CanRead);
            Assert.AreEqual(1, target.CanWrite);
            Assert.AreEqual(1, target.CanChangePermissions);

            //now as super
            target = new Article();
            viewingIUser = mocks.DynamicMock<IUser>();
            viewingIUser.Stub(x => x.UserLoggedIn).Return(true);
            viewingIUser.Stub(x => x.IsEditor).Return(false);
            viewingIUser.Stub(x => x.IsSuperUser).Return(true);
            mocks.ReplayAll();

            target.UpdatePermissionsForViewingUser(viewingIUser, null);
            Assert.AreEqual(1, target.CanRead);
            Assert.AreEqual(1, target.CanWrite);
            Assert.AreEqual(1, target.CanChangePermissions);

        }

        /// <summary>
        ///A test for UpdatePermissionsForViewingIUser
        ///</summary>
        [TestMethod()]
        public void UpdatePermissionsForViewingUserTest_AsNotLoggedIn()
        {
            Article target = new Article();
            MockRepository mocks = new MockRepository();
            IUser viewingIUser = mocks.DynamicMock<IUser>();
            viewingIUser.Stub(x => x.UserLoggedIn).Return(false);
            mocks.ReplayAll();

            target.UpdatePermissionsForViewingUser(viewingIUser, null);
            Assert.AreEqual(0, target.CanRead);
            Assert.AreEqual(0, target.CanWrite);
            Assert.AreEqual(0, target.CanChangePermissions);
        }


        /// <summary>
        ///A test for CreateArticleFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateArticleFromDatabase_ValidResultSet_ReturnsValidObject()
        {
            int entryId = 1; 
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            reader.Stub(x => x.GetInt32("EntryID")).Return(entryId);
            reader.Stub(x => x.GetTinyIntAsInt("style")).Return(1);
            reader.Stub(x => x.GetString("text")).Return("<GUIDE><BODY>this is an article</BODY></GUIDE>");

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("")).Return(reader).Constraints(Is.Anything());
            mocks.ReplayAll();
            
            Article actual;
            actual = Article.CreateArticleFromDatabase(creator, entryId);
            Assert.AreEqual(entryId, actual.EntryId);
            
            
        }

        [TestMethod()]
        public void CreateArticleFromDatabase_NoResults_ThrowsException()
        {
            int entryId = 1;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("")).Return(reader).Constraints(Is.Anything());
            mocks.ReplayAll();

            try
            {

                Article actual;
                actual = Article.CreateArticleFromDatabase(creator, entryId);
            }
            catch (Exception e)
            {
                Assert.AreEqual("Article not found", e.Message);
            }


        }

        /// <summary>
        ///A test for CreateArticleFromDatabase
        ///</summary>
        [TestMethod()]
        public void MakeEdittable_ValidObject_ReturnsEdittableObject()
        {
            int entryId = 1;
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            reader.Stub(x => x.GetInt32("EntryID")).Return(entryId);
            reader.Stub(x => x.GetTinyIntAsInt("style")).Return(1);
            reader.Stub(x => x.GetInt32("PreProcessed")).Return(10);
            reader.Stub(x => x.GetString("text")).Return("<GUIDE><BODY>this is an<BR /> article</BODY></GUIDE>");

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("")).Return(reader).Constraints(Is.Anything());
            mocks.ReplayAll();



            Article actual;
            actual = Article.CreateArticleFromDatabase(creator, entryId);
            Assert.AreEqual(entryId, actual.EntryId);

            actual.MakeEdittable();
            Assert.AreEqual("this is an\r\n article", actual.GuideElement.InnerText);


        }

        /// <summary>
        ///A test for UpdateProfanityUrlTriggerCount
        ///</summary>
        [TestMethod()]
        public void UpdateProfanityUrlTriggerCount_ValidCounts_ReturnsModifiedCounts()
        {
            Article target = new Article(); 
            bool profanityTriggered = true; 
            bool nonAllowedURLsTriggered = true; 
            target.UpdateProfanityUrlTriggerCount(profanityTriggered, nonAllowedURLsTriggered);
            Assert.AreEqual(1, target.ProfanityTriggered);
            Assert.AreEqual(1, target.NonAllowedUrlsTriggered);
        }

        

        static public Article CreateArticle()
        {
            return new Article()
            {
                ArticleInfo = ArticleInfoTest.CreateArticleInfo(),
                Subject = String.Empty,
                ExtraInfo = "<EXTRAINFO><TEXT>test text</TEXT></EXTRAINFO>",
                Guide =  GuideEntryTest.CreateBlankEntry()
            };
        }
    }
}
