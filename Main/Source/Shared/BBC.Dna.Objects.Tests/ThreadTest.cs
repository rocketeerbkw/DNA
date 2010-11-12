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
    public class ThreadTest
    {


        

        static public ForumThreadPosts CreateThread()
        {
            ForumThreadPosts thread = new ForumThreadPosts()
            {
                Post = new System.Collections.Generic.List<ThreadPost>(),
                FirstPostSubject = String.Empty,

            };

            thread.Post.Add(ThreadPostTest.CreateThreadPost());
            return thread;
        }

        /// <summary>
        ///A test for ApplySiteOptions
        ///</summary>
        [TestMethod()]
        public void ApplySiteOptions_ValidSiteOption_ReturnsCorrectObject()
        {
            int siteId=1;
            MockRepository mocks = new MockRepository();
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false).Constraints(Is.Anything());
            
            
            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "Forum", "PostLimit")).Return(10);
            siteList.Stub(x => x.GetSite(siteId)).Return(site);


            IUser user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);
            user.Stub(x => x.IsEditor).Return(true);
            mocks.ReplayAll();

            ForumThreadPosts target = new ForumThreadPosts() { SiteId = siteId };
            target.ApplySiteOptions(user, siteList);
            Assert.AreEqual(target.ForumPostLimit, 10);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_AsEditor_ReturnsReadWriteObject()
        {
            int siteId = 1;
            MockRepository mocks = new MockRepository();
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            IUser user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);
            user.Stub(x => x.IsEditor).Return(true);
            

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);
            mocks.ReplayAll();

            ForumThreadPosts target = new ForumThreadPosts();
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 1);

            //test as superuser
            user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);
            user.Stub(x => x.IsSuperUser).Return(true);
            mocks.ReplayAll();

            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 1);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_AsSuperUser_ReturnsReadWriteObject()
        {
            int siteId = 1;
            MockRepository mocks = new MockRepository();
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            IUser user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);
            user.Stub(x => x.IsEditor).Return(true);


            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);
            mocks.ReplayAll();

            ForumThreadPosts target = new ForumThreadPosts();
            //test as superuser
            user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);
            user.Stub(x => x.IsSuperUser).Return(true);
            mocks.ReplayAll();

            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 1);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_StandardUserWithPermissions_ReturnsCorrectPermissions()
        {
            int siteId = 1;
            MockRepository mocks = new MockRepository();
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            IUser user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(false);
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);
            
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);//required for emailalertgroup stuff
            mocks.ReplayAll();

            ForumThreadPosts target = new ForumThreadPosts();
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 0);

            //try the reverse
            target.Post = new System.Collections.Generic.List<ThreadPost>();
            target.Post.Add(ThreadPostTest.CreateThreadPost());

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetBoolean("CanRead")).Return(false);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(true);
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);//required for emailalertgroup stuff
            mocks.ReplayAll();

            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 0);
            Assert.AreEqual(target.CanWrite, 1);
            Assert.AreEqual(target.Post.Count, 0);//can read is 0 so no posts please.
        }

        

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_SiteEmergencyClosed_ReturnsCorrectPermissions()
        {
            ISite site;
            IUser user;
            IDnaDataReaderCreator creator;
            ApplyUserSettingsTestSetup(out site, out user, out creator);

            ForumThreadPosts target = new ForumThreadPosts();
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 0);
        }


        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_SiteScheduledClosed_ReturnsCorrectPermissions()
        {
            ISite site;
            IUser user;
            IDnaDataReaderCreator creator;
            ApplyUserSettingsTestSetup(out site, out user, out creator);
            ForumThreadPosts target = new ForumThreadPosts();

            //try scheduled closed
            site.Stub(x => x.IsEmergencyClosed).Return(false);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(true);
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 0);
        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_SiteClosedAndEditor_ReturnsCorrectPermissions()
        {
            ISite site;
            IUser user;
            IDnaDataReaderCreator creator;
            ApplyUserSettingsTestSetup(out site, out user, out creator);

            ForumThreadPosts target = new ForumThreadPosts();

            //with editor/superuser
            target = new ForumThreadPosts() { CanWrite = 0, CanRead = 0 };
            user.Stub(x => x.IsEditor).Return(true);
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 1);

        }

        /// <summary>
        ///A test for ApplyUserSettings
        ///</summary>
        [TestMethod()]
        public void ApplyUserSettings_SiteClosedAndSuperUser_ReturnsCorrectPermissions()
        {
            ISite site;
            IUser user;
            IDnaDataReaderCreator creator;
            ApplyUserSettingsTestSetup(out site, out user, out creator);

            ForumThreadPosts target = new ForumThreadPosts();
            //with editor/superuser

            target = new ForumThreadPosts() { CanWrite = 0, CanRead = 0 };
            user.Stub(x => x.IsSuperUser).Return(true);
            target.ApplyUserSettings(user, creator);
            Assert.AreEqual(target.CanRead, 1);
            Assert.AreEqual(target.CanWrite, 1);


        }

        private static void ApplyUserSettingsTestSetup(out ISite site, out IUser user, out IDnaDataReaderCreator creator)
        {
            int siteId = 1;
            MockRepository mocks = new MockRepository();
            site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.IsEmergencyClosed).Return(true);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Return(false);

            user = mocks.DynamicMock<IUser>();
            user.Stub(x => x.UserId).Return(1);

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(false);
            reader.Stub(x => x.GetBoolean("CanRead")).Return(true);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getthreadgroupalertid")).Return(reader);//required for emailalertgroup stuff
            mocks.ReplayAll();
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadFromDatabase_AsAsc_ReturnsValidList()
        {
            MockRepository mocks;
            int siteId;
            int forumId;
            int threadId;
            int itemsPerPage;
            int startIndex;
            int postId;
            int entryId;
            bool orderByDatePostedDesc;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            CreateThreadFromDatabaseTestSetup(out mocks, out siteId, out forumId, out threadId, out itemsPerPage, out startIndex, out postId, out entryId, out orderByDatePostedDesc, out reader, out creator);


            mocks.ReplayAll();

            ForumThreadPosts actual;
            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId, 
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, itemsPerPage);
            Assert.AreEqual(actual.More, 1);

            //try desc
            orderByDatePostedDesc = true;

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(itemsPerPage + 2);
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(entryId);
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(itemsPerPage * 2 + 1);//more should = 1

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2_desc")).Return(reader);
            mocks.ReplayAll();

            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId,
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, itemsPerPage);
            Assert.AreEqual(actual.More, 1);
            Assert.AreEqual(actual.Post[actual.Post.Count - 1].NextIndex, entryId);
            
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadFromDatabase_AsDesc_ReturnsValidList()
        {
            MockRepository mocks;
            int siteId;
            int forumId;
            int threadId;
            int itemsPerPage;
            int startIndex;
            int postId;
            int entryId;
            bool orderByDatePostedDesc;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            CreateThreadFromDatabaseTestSetup(out mocks, out siteId, out forumId, out threadId, out itemsPerPage, out startIndex, out postId, out entryId, out orderByDatePostedDesc, out reader, out creator);

            ForumThreadPosts actual;
           //try desc
            orderByDatePostedDesc = true;

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(itemsPerPage + 2);
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(entryId);
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(itemsPerPage*2 + 1);//more should = 1
            

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2_desc")).Return(reader);
            mocks.ReplayAll();

            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId,
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, itemsPerPage);
            Assert.AreEqual(1, actual.More);
            Assert.AreEqual(actual.Post[actual.Post.Count - 1].NextIndex, entryId);

        }

        private static void CreateThreadFromDatabaseTestSetup(out MockRepository mocks, out int siteId, out int forumId, out int threadId, out int itemsPerPage, out int startIndex, out int postId, out int entryId, out bool orderByDatePostedDesc, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            siteId = 1;
            forumId = 1;
            threadId = 1;
            itemsPerPage = 10;
            startIndex = 0;
            postId = 0;
            entryId = 22;
            orderByDatePostedDesc = false;

            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(itemsPerPage + 2);
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(entryId);
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(itemsPerPage * 2 + 1);//more should = 1

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2")).Return(reader);
            mocks.ReplayAll();
        }



        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadFromDatabase_OverSizedItemsPerPage_ReturnsReducedCount()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 1;
            int itemsPerPage = 2000;
            int smallerItemsPerPage = 200;
            int startIndex = 0;
            int postId = 0;
            bool orderByDatePostedDesc = false;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(smallerItemsPerPage + 2);
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(itemsPerPage * 2 + 1);//more should = 1

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2")).Return(reader);
            mocks.ReplayAll();

            ForumThreadPosts actual;
            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId,
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, smallerItemsPerPage);
            Assert.AreEqual(1, actual.More);
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadFromDatabase_WithPostId_ReturnsValidList()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 1;
            int itemsPerPage = 20;
            int startIndex = 0;
            int postId = 5;
            bool orderByDatePostedDesc = false;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);//extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("Index")).Return(25);
            reader.Stub(x => x.GetInt32NullAsZero("Total")).Return(50);
            
            reader.Stub(x => x.NextResult()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofpost")).Return(reader);
            mocks.ReplayAll();

            ForumThreadPosts actual;
            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId,
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, itemsPerPage);
            Assert.AreEqual(1, actual.More);
        }

        /// <summary>
        ///A test for CreateThreadFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadFromDatabase_WithPartialRecordset_ReturnsValidMoreValue()
        {
            MockRepository mocks = new MockRepository();
            int siteId = 1;
            int forumId = 1;
            int threadId = 1;
            int itemsPerPage = 20;
            int totalItems = 5;
            int startIndex = 0;
            int postId = 0;
            bool orderByDatePostedDesc = false;

            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(totalItems);//extra time for getindex call
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("Index")).Return(25);
            reader.Stub(x => x.NextResult()).Return(true);

            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("threadlistposts2")).Return(reader);
            creator.Stub(x => x.CreateDnaDataReader("getindexofpost")).Return(reader);
            mocks.ReplayAll();

            ForumThreadPosts actual;
            actual = ForumThreadPosts.CreateThreadFromDatabase(creator, siteId, forumId, threadId, itemsPerPage, startIndex, postId,
                orderByDatePostedDesc, false);
            Assert.AreEqual(actual.Post.Count, totalItems);
            Assert.AreEqual(actual.More, 0);
        }

        /// <summary>
        ///A test for GetIndexOfPostInThread
        ///</summary>
        [TestMethod()]
        public void GetIndexOfPostInThread_ItemFound_ReturnsValidList()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetIndexOfPostInThreadTestSetup(out mocks, out reader, out creator);

            int threadId = 0; 
            int postId = 0; 
            int itemsPerPage = 10; 
            int expected = 20; 
            int actual;
            actual = ForumThreadPosts.GetIndexOfPostInThread(creator, threadId, postId, itemsPerPage);
            Assert.AreEqual(expected, actual);

            //if not found
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getindexofpost")).Return(reader);
            mocks.ReplayAll();

            expected = 0;
            actual = ForumThreadPosts.GetIndexOfPostInThread(creator, threadId, postId, itemsPerPage);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for GetIndexOfPostInThread
        ///</summary>
        [TestMethod()]
        public void GetIndexOfPostInThread_ItemNotFound_ReturnsEmptyList()
        {
            MockRepository mocks;
            IDnaDataReader reader;
            IDnaDataReaderCreator creator;
            GetIndexOfPostInThreadTestSetup(out mocks, out reader, out creator);

            int threadId = 0;
            int postId = 0;
            int itemsPerPage = 10;
            int expected = 20;
            int actual;
           //if not found
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getindexofpost")).Return(reader);
            mocks.ReplayAll();

            expected = 0;
            actual = ForumThreadPosts.GetIndexOfPostInThread(creator, threadId, postId, itemsPerPage);
            Assert.AreEqual(expected, actual);
        }

        private static void GetIndexOfPostInThreadTestSetup(out MockRepository mocks, out IDnaDataReader reader, out IDnaDataReaderCreator creator)
        {
            mocks = new MockRepository();
            reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("Index")).Return(25);

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getindexofpost")).Return(reader);
            mocks.ReplayAll();
        }
    }
}
