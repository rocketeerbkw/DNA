using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ThreadTest and is intended
    ///to contain all ThreadTest Unit Tests
    ///</summary>
    [TestClass()]
    public class PostThreadFormTests
    {

        [TestMethod]
        public void PostThreadForm_GetPostThreadFormWithReplyTo_ReturnsValidObj()
        {
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            IDnaDataReader reader;
            User viewingUser;
            CreateMocks(out mocks, out readerCreator, out reader, out viewingUser);

            reader.Stub(x => x.GetInt32NullAsZero("CanWrite")).Return(1);
            reader.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpostcontents")).Return(reader);
            mocks.ReplayAll();


            var form = PostThreadForm.GetPostThreadFormWithReplyTo(readerCreator, viewingUser, 0);
            Assert.IsNotNull(form);
        }

        [TestMethod]
        public void GetPostThreadFormWithReplyTo_CanWrite0AndSuperUser_ReturnsWrite1()
        {
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            IDnaDataReader reader;
            User viewingUser;
            CreateMocks(out mocks, out readerCreator, out reader, out viewingUser);

            viewingUser.Status = 2;
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("CanWrite")).Return(0);
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpostcontents")).Return(reader);
            mocks.ReplayAll();


            var form = PostThreadForm.GetPostThreadFormWithReplyTo(readerCreator, viewingUser, 0);
            Assert.IsNotNull(form);
            Assert.AreEqual(1, form.CanWrite);
        }

        [TestMethod]
        public void GetPostThreadFormWithReplyTo_CanWrite0AndEditorUser_ReturnsWrite1()
        {
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            IDnaDataReader reader;
            User viewingUser;
            CreateMocks(out mocks, out readerCreator, out reader, out viewingUser);

            viewingUser.Groups.Add(new Group("Editor"));
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("CanWrite")).Return(0);
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpostcontents")).Return(reader);
            mocks.ReplayAll();


            var form = PostThreadForm.GetPostThreadFormWithReplyTo(readerCreator, viewingUser, 0);
            Assert.IsNotNull(form);
            Assert.AreEqual(1, form.CanWrite);
        }

        [TestMethod]
        public void GetPostThreadFormWithReplyTo_CanWrite0AndNormalUser_ReturnsValidObj()
        {
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            IDnaDataReader reader;
            User viewingUser;
            CreateMocks(out mocks, out readerCreator, out reader, out viewingUser);

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("CanWrite")).Return(0);
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpostcontents")).Return(reader);
            mocks.ReplayAll();


            var form = PostThreadForm.GetPostThreadFormWithReplyTo(readerCreator, viewingUser, 0);
            Assert.IsNotNull(form);
            Assert.AreEqual(0, form.CanWrite);
        }

        [TestMethod]
        public void GetPostThreadFormWithReplyTo_WithUsername_ReturnsValidObj()
        {
            MockRepository mocks;
            IDnaDataReaderCreator readerCreator;
            IDnaDataReader reader;
            User viewingUser;
            CreateMocks(out mocks, out readerCreator, out reader, out viewingUser);

            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.IsDBNull("SiteSuffix")).Return(true);
            reader.Stub(x => x.GetStringNullAsEmpty("UserName")).Return("username");
            
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpostcontents")).Return(reader);
            mocks.ReplayAll();


            var form = PostThreadForm.GetPostThreadFormWithReplyTo(readerCreator, viewingUser, 0);
            Assert.IsNotNull(form);
            Assert.AreEqual("username", form.InReplyTo.Username);
        }

        [TestMethod]
        public void GetPostThreadFormWithForum_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            Assert.AreEqual(10, forum.ForumId);
            Assert.AreEqual(1, forum.CanWrite);
        }

        [TestMethod]
        public void AddPost_EmptySubject_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            forum.AddPost(null, "body", QuoteEnum.None);
            Assert.AreEqual("", forum.Subject);
            forum.AddPost("subject", "body", QuoteEnum.None);
            Assert.AreEqual("subject", forum.Subject);
        }

        [TestMethod]
        public void AddPost_EmptyBody_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            forum.AddPost("subject", null, QuoteEnum.None);
            Assert.AreEqual("", forum.Body);
            forum.AddPost("subject", "body", QuoteEnum.None);
            Assert.AreEqual("body", forum.Body);
        }

        [TestMethod]
        public void AddPost_WithQuote_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            forum.InReplyTo = new PostThreadFormInReplyTo();
            forum.AddPost("subject", "body", QuoteEnum.QuoteId);

            Assert.IsTrue(forum.Body.IndexOf("<quote postid='0'>") >= 0);
        }

        [TestMethod]
        public void AddPost_WithQuoteAlreadyAdded_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            forum.InReplyTo = new PostThreadFormInReplyTo() { RawBody = "<quote postid='0'>" };
            forum.AddPost("subject", "<quote postid='0'></quote>body", QuoteEnum.QuoteId);

            Assert.AreEqual("<quote postid='0'></quote>body" ,forum.Body);
        }

        [TestMethod]
        public void AddPost_WithUserQuote_ReturnsObject()
        {
            var forum = PostThreadForm.GetPostThreadFormWithForum(null, null, 10);
            forum.InReplyTo = new PostThreadFormInReplyTo();
            forum.AddPost("subject", "body", QuoteEnum.QuoteUser);

            Assert.IsTrue(forum.Body.IndexOf("<quote postid='0' user='' userid='0'>") >= 0);
        }


        

        private static void CreateMocks(out MockRepository mocks, out IDnaDataReaderCreator readerCreator, out IDnaDataReader reader, out User viewingUser)
        {
            mocks = new MockRepository();
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            reader = mocks.DynamicMock<IDnaDataReader>();
            viewingUser = UserTest.CreateTestUser();
        }

    }
}
