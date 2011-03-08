using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using System.Xml;
using TestUtils;
using System;
using System.Collections.Generic;
using BBC.Dna.Api;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for TermAdminTest and is intended
    ///to contain all TermAdminTest Unit Tests
    ///</summary>
    [TestClass()]
    public class PostEditFormTests
    {

        public MockRepository Mocks = new MockRepository();

        [TestMethod()]
        public void GetPostEditFormFromPostId_ValidDatabase_ReturnsFilledObject()
        {
            var threadId =1;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(1);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("FetchPostDetails")).Return(reader);

            var user = Mocks.DynamicMock<IUser>();
            Mocks.ReplayAll();

            var postEdit = PostEditForm.GetPostEditFormFromPostId(readerCreator, user, false, 0);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("FetchPostDetails"));
            Assert.AreEqual(threadId, postEdit.ThreadId);
        }

        [TestMethod()]
        public void GetPostEditFormFromPostId_NoReadFromDatabase_ReturnsNull()
        {
            var threadId = 1;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(false).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(0);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("FetchPostDetails")).Return(reader);

            var user = Mocks.DynamicMock<IUser>();
            Mocks.ReplayAll();

            var postEdit = PostEditForm.GetPostEditFormFromPostId(readerCreator, user, false, 0);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("FetchPostDetails"));
            Assert.IsNull(postEdit);
        }

        [TestMethod()]
        public void GetPostEditFormFromPostId_WithPostsSameBBCUidSuperUserWithoutBBcUid_ReturnsEmptyListOfUsers()
        {
            var threadId = 1;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(1);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("FetchPostDetails")).Return(reader);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var postEdit = PostEditForm.GetPostEditFormFromPostId(readerCreator, user, true, 0);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("FetchPostDetails"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("getuserpostdetailsviabbcuid"));

            Assert.AreEqual(threadId, postEdit.ThreadId);
            Assert.IsNull(postEdit.PostsWithSameBBCUid);
        }

        [TestMethod()]
        public void GetPostEditFormFromPostId_WithPostsSameBBCUidSuperUser_ReturnsFilledObject()
        {
            Queue<int> returnedIds = new Queue<int>();
            returnedIds.Enqueue(1);
            returnedIds.Enqueue(2);

            var threadId = 1;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(0);
            reader.Stub(x => x.GetGuid("BBCUID")).Return(Guid.NewGuid());

            var readerUserPosts = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Twice();
            readerUserPosts.Stub(x => x.GetInt32NullAsZero("entryid")).Return(0).WhenCalled(x => x.ReturnValue = returnedIds.Dequeue());

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("FetchPostDetails")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("getuserpostdetailsviabbcuid")).Return(reader);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var postEdit = PostEditForm.GetPostEditFormFromPostId(readerCreator, user, true, 0);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("FetchPostDetails"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("getuserpostdetailsviabbcuid"));

            Assert.AreEqual(threadId, postEdit.ThreadId);
            Assert.IsNotNull(postEdit.PostsWithSameBBCUid);
            Assert.AreEqual(2, postEdit.PostsWithSameBBCUid.Count);
        }

        [TestMethod()]
        public void UnHidePost_ValidDatabase_ReturnsUnhidden()
        {
            var modId = 1;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 1 };
            editForm.UnHidePost(user, "");
             
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("moderatepost"));
            Assert.AreEqual(0, editForm.Hidden);
        }


        [TestMethod()]
        public void UnHidePost_NoModId_ThrowsException()
        {
            var modId = 0;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 1 };
            try
            {
                editForm.UnHidePost(user, "");
                Assert.Fail("Should have thrown exception");
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.Unknown, e.type);
            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("moderatepost"));
            Assert.AreEqual(1, editForm.Hidden);
        }

        [TestMethod()]
        public void HidePost_ValidDatabase_ReturnsHiddenPost()
        {
            var modId = 1;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 0 };
            editForm.HidePost(user, "", "");

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("moderatepost"));
            Assert.AreEqual(1, editForm.Hidden);
        }

        [TestMethod()]
        public void HidePost_NoModId_ThrowsException()
        {
            var modId = 0;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 0 };
            try
            {
                editForm.HidePost(user, "", "");
                Assert.Fail("Should have thrown exception");
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.Unknown, e.type);
            }


            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("moderatepost"));
            Assert.AreEqual(0, editForm.Hidden);
        }

        [TestMethod()]
        public void EditPost_ValidDatabase_Returns()
        {
            var modId = 1;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var readerEdit = Mocks.DynamicMock<IDnaDataReader>();
            readerEdit.Stub(x => x.Read()).Return(true).Repeat.Once();

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepostdetails")).Return(readerEdit);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 0 };
            editForm.EditPost(user, "", "", "");

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("moderatepost"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("updatepostdetails"));
        }

        [TestMethod()]
        public void EditPost_NoModId_ThrowsException()
        {
            var modId = 0;
            var readerModPost = Mocks.DynamicMock<IDnaDataReader>();
            readerModPost.Stub(x => x.Read()).Return(true).Repeat.Once();
            readerModPost.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var readerEdit = Mocks.DynamicMock<IDnaDataReader>();
            readerEdit.Stub(x => x.Read()).Return(true).Repeat.Once();

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(readerModPost);
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepostdetails")).Return(readerEdit);

            var user = Mocks.DynamicMock<IUser>();
            user.Stub(x => x.IsSuperUser).Return(true);
            Mocks.ReplayAll();

            var editForm = new PostEditForm(readerCreator) { Hidden = 0 };
            try
            {
                editForm.EditPost(user, "", "", "");
                Assert.Fail("Should have thrown exception");
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.Unknown, e.type);
            }

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("moderatepost"));
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("updatepostdetails"));
        }
        
    }
}
