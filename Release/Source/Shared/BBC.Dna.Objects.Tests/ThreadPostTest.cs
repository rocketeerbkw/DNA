using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ThreadPostTest and is intended
    ///to contain all ThreadPostTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ThreadPostTest
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
        ///A test for text
        ///</summary>
        [TestMethod()]
        public void textTestWithStatus_DefaultStatus_ReturnsUnchangedText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            string actual;
            target.Text = expected;
            actual = target.Text;
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void textTestWithStatus_HiddenAwaitingPreModeration_ReturnsHiddenText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            string actual;

            //set hidden to premoderated
            target.Hidden = (byte)CommentStatus.Hidden.Hidden_AwaitingPreModeration;
            expected = "This post has been hidden.";
            actual = target.Text;
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void textTestWithStatus_HiddenAwaitingReferral_ReturnsHiddenText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This post has been hidden.";
            string actual;

            target.Hidden = (byte)CommentStatus.Hidden.Hidden_AwaitingReferral;
            actual = target.Text;
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void textTestWithStatus_RemovedEditorComplaintTakedown_ReturnsRemovedText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string actual;

            string expected = "This post has been removed.";
            target.Hidden = (byte)CommentStatus.Hidden.Removed_EditorComplaintTakedown;
            actual = target.Text;
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void textTestWithStatus_RemovedEditorFailedModeration_ReturnsRemovedText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string actual;
            string expected = "This post has been removed.";

            target.Hidden = (byte)CommentStatus.Hidden.Removed_FailedModeration;
            actual = target.Text;
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void textTestWithStatus_RemovedForumRemoved_ReturnsRemovedText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string actual;
            string expected = "This post has been removed.";

            target.Hidden = (byte)CommentStatus.Hidden.Removed_ForumRemoved;
            actual = target.Text;
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void textTestWithStatus_RemovedUserDeleted_ReturnsRemovedText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string actual;
            string expected = "This post has been removed.";

            target.Hidden = (byte)CommentStatus.Hidden.Removed_UserDeleted;
            actual = target.Text;
            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        ///A test for text with style applied
        ///</summary>
        [TestMethod()]
        public void textTestWithStyle_AsPlainText_ReturnsOriginalText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            string actual;
            target.Text = expected;
            actual = target.Text;
            Assert.AreEqual(expected, actual);
           

        }

        [TestMethod()]
        public void textTestWithStyle_AsRichtext_ReturnsOriginalText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            string actual;
            //set style to richtext
            target.Style = PostStyle.Style.richtext;
            expected = "This is the default comment.";
            target.Text = expected;
            actual = target.Text;
            Assert.AreEqual(expected, actual);



        }

        [TestMethod()]
        public void textTestWithStyle_AsUnknown_ReturnsOriginalText()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            string actual;

            //set style to unknown (which is richpost)
            target.Style = PostStyle.Style.unknown;
            expected = "This is the default comment.";
            target.Text = expected;
            actual = target.Text;
            Assert.AreEqual(expected, actual);


        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_DefaultStatus_ReturnsOriginalSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;
            target.Subject = expected;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);

        }


        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_HiddenAwaitingPreModeration_ReturnsHiddenSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            //set hidden to premoderated
            target.Hidden = (byte)CommentStatus.Hidden.Hidden_AwaitingPreModeration;
            expected = "Hidden";
            actual = target.Subject;
            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_HiddenAwaitingReferral_ReturnsHiddenSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            expected = "Hidden";
            target.Hidden = (byte)CommentStatus.Hidden.Hidden_AwaitingReferral;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_RemovedEditorComplaintTakedown_ReturnsRemovedSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            //set hidden to hidden
            expected = "Removed";
            target.Hidden = (byte)CommentStatus.Hidden.Removed_EditorComplaintTakedown;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_RemovedFailedModeration_ReturnsRemovedSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            //set hidden to hidden
            expected = "Removed";
            target.Hidden = (byte)CommentStatus.Hidden.Removed_FailedModeration;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_RemovedForumRemoved_ReturnsRemovedSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            //set hidden to hidden
            expected = "Removed";
            target.Hidden = (byte)CommentStatus.Hidden.Removed_ForumRemoved;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void subjectTestWithStatus_RemovedUserDeleted_ReturnsRemovedSubject()
        {
            ThreadPost target = new ThreadPost();
            string expected = "This is the default subject.";
            string actual;

            //set hidden to hidden
            expected = "Removed";
            target.Hidden = (byte)CommentStatus.Hidden.Removed_UserDeleted;
            actual = target.Subject;
            Assert.AreEqual(expected, actual);
        }

        

        public static ThreadPost CreateThreadPost()
        {
            return new ThreadPost()
            {
                DatePosted = new DateElement(DateTime.Now),
                Hidden = 0,
                Index = 0,
                InReplyTo = 0,
                LastUpdated = new DateElement(DateTime.Now),
                Style = PostStyle.Style.plaintext,
                FirstChild = 0,
                PrevSibling = 0,
                Subject = "temp",
                NextIndex = 0,
                NextSibling = 0,
                PostId = 0,
                PrevIndex = 0,
                Text = "test text",
                Editable = 0,
                User = UserTest.CreateTestUser()
            };
            
        }


        /// <summary>
        ///A test for CreateThreadPostFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromDatabase_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(1);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getpostsinthread")).Return(reader);
            mocks.ReplayAll();


            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromDatabase(creator, 1);
            Assert.AreEqual(actual.ThreadId, 1);
        }

        [TestMethod()]
        public void CreateThreadPostFromDatabaseTest_EmptyDataSet_ReturnsException()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getpostsinthread")).Return(reader);
            mocks.ReplayAll();

            try
            {
                ThreadPost.CreateThreadPostFromDatabase(creator, 1);
            }
            catch(Exception e) 
            {
                Assert.AreEqual(e.Message, "Invalid post id");
            }

            
        }

        /// <summary>
        ///A test for CreateThreadPostFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromReader_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(1);

            mocks.ReplayAll();

            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromReader(reader, 0);
            Assert.AreEqual(actual.ThreadId, 1);
        }

        /// <summary>
        ///A test for CreateThreadPostFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromReader_WithPrefix_ReturnsValidObject()
        {
            string prefix = "prefix";
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist(prefix+"threadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero(prefix + "threadid")).Return(1);

            mocks.ReplayAll();

            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromReader(reader, prefix, 0);
            Assert.AreEqual(actual.ThreadId, 1);
        }
    }
}
