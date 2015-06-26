using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using TestUtils;
using BBC.Dna.Data;
using System.Configuration;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for FetchGroupsAndMembersTests
    /// </summary>
    [TestClass]
    public class GetModerationPosts
    {

        private int _siteId = 70;//mbiplayer
        private int _postId = 61;
        private int _forumId = 7325075;
        private int _threadId = 34;
        private int _modClassId = 4;
        private int _userId = TestUserAccounts.GetModeratorAccount.UserID;

        
        public GetModerationPosts()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;

        [TestMethod]
        public void GetModerationPosts_NoItemsLocked_LocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddItem();

                var reader = GetModerationPostsItems(_userId, null, null, null, null, null, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, _postId);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class
            }
        }

        [TestMethod]
        public void GetModerationPosts_AsSuperUser_LocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddItem();

                var reader = GetModerationPostsItems(TestUserAccounts.GetSuperUserAccount.UserID, null, null, null, null, true, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, TestUserAccounts.GetSuperUserAccount.UserID, 0, _postId);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class

            }
        }

        [TestMethod]
        public void GetModerationPosts_AsNonModerator_NoLocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddItem();

                var reader = GetModerationPostsItems(TestUserAccounts.GetNormalUserAccount.UserID, null, null, null, null, null, null, null, null, null);
                Assert.IsFalse(reader.HasRows);
            }
        }

        [TestMethod]
        public void GetModerationPosts_ByModerationId_LocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, null, 0, "");

                var reader = GetModerationPostsItems(_userId, null, null, null, null, null, _modClassId, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, _postId);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class

            }
        }

        [TestMethod]
        public void GetModerationPosts_ByPostId_ReturnsLockedItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, null, 0, "");

                var reader = GetModerationPostsItems(_userId, null, null, null, null, null, null, 58, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class

            }
        }

        [TestMethod]
        public void GetModerationPosts_ByLockedBy_ReturnsLockedItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, null, 0, "");

                var reader = GetModerationPostsItems(_userId, null, null, null, null, null, null, 58, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class


                reader = GetModerationPostsItems(_userId, null, null, 1, null, null, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class

            }
        }

        [TestMethod]
        public void GetModerationPosts_ByComplaints_ReturnsComplaintItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetEditorUserAccount.UserID, 0, "");

                var reader = GetModerationPostsItems(_userId, null, 1, null, null, null, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class
            }
        }

        [TestMethod]
        public void GetModerationPosts_ByStatus_ReturnsStatusItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, null, 2, "");

                var reader = GetModerationPostsItems(_userId, 2, null, null, null, null, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 2, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class
            }
        }

        [TestMethod]
        public void GetModerationPosts_ByFastMod_ReturnsFastModItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, null, 0, "");

                AddForumToFastMod(150);

                var reader = GetModerationPostsItems(_userId, null, null, null, 1, null, null, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    Assert.AreEqual(1, reader.GetInt32NullAsZero("priority"));
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class
            }
        }

        [TestMethod]
        public void GetModerationPosts_ByDuplicates_ReturnsDuplicateItemsOnly()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNormalUserAccount.UserID, 0, "");
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, "");


                var reader = GetModerationPostsItems(_userId, null, 1, null, null, null, null, null, true, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, 58);
                }
                Assert.AreEqual(2, items); //should only return one item as other one in other mod class
            }
        }

        [TestMethod]
        public void GetModerationPosts_WithShow_ShownLocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddItem();
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNormalUserAccount.UserID, 0, "");
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, "");


                var reader = GetModerationPostsItems(_userId, null, null, null, null, null, null, null, null, 1);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    VerifyModItem(modId, _userId, 0, _postId);
                }
                Assert.AreEqual(1, items); //should only return one item as other one in other mod class

            }
        }

        [TestMethod]
        public void GetModerationPosts_AddedOutOfOrder_LocksItemsInOrder()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNormalUserAccount.UserID, 0, DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                AddItemToQueue(150, 32, 59, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, DateTime.Now.AddDays(-61).ToString("yyyy-MM-dd"));
                AddItemToQueue(150, 32, 60, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, "");

                Queue<int> postIds = new Queue<int>();
                postIds.Enqueue(59); 
                postIds.Enqueue(58);
                postIds.Enqueue(60);

                var reader = GetModerationPostsItems(_userId, null, 1, null, null, null, 3, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    Assert.AreEqual(0, reader.GetInt32NullAsZero("priority"));
                    VerifyModItem(modId, _userId, 0, postIds.Dequeue());
                }
                Assert.AreEqual(3, items); //should only return one item as other one in other mod class
            }
        }


        [TestMethod]
        public void GetModerationPosts_AddedOutOfOrderWithFastMod_LocksItemsInOrder()
        {
            using (new TransactionScope())
            {
                ClearQueue();

                AddItemToQueue(7619338, 31, 57, "not same modclass", 1, TestUserAccounts.GetNormalUserAccount.UserID, 0, DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                AddItemToQueue(150, 32, 58, "not same modclass", 1, TestUserAccounts.GetNormalUserAccount.UserID, 0, DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                AddItemToQueue(150, 32, 59, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, DateTime.Now.AddDays(-61).ToString("yyyy-MM-dd"));
                AddItemToQueue(150, 32, 60, "not same modclass", 1, TestUserAccounts.GetNotableUserAccount.UserID, 0, "");

                AddForumToFastMod(7619338);

                Queue<int> postIds = new Queue<int>();
                postIds.Enqueue(59);
                postIds.Enqueue(58);
                postIds.Enqueue(60);

                var reader = GetModerationPostsItems(_userId, null, 1, null, null, null, 3, null, null, null);
                Assert.IsTrue(reader.HasRows);
                var items = 0;
                while (reader.Read())
                {
                    items++;
                    int modId = reader.GetInt32NullAsZero("modid");
                    Assert.AreNotEqual(0, modId);
                    Assert.AreEqual(0, reader.GetInt32NullAsZero("priority"));
                    VerifyModItem(modId, _userId, 0, postIds.Dequeue());
                }
                Assert.AreEqual(3, items); //should only return one item as other one in other mod class
            }
        }


        private void AddForumToFastMod(int forumId)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY("insert into fastmodforums (forumid) values (" + forumId.ToString() + ")");
            }
        }

        private void AddItem()
        {
           AddItemToQueue(_forumId, _threadId, _postId, "", _siteId,null, 0, "");
        }

        private void AddItemToQueue(int forumId, int threadId, int postId, string notes, int siteId, 
            int? complaintantId, int status, string date)
        {
            if (string.IsNullOrEmpty(date))
            {
                date = "GetDate()";
            }
            else
            {
                date = "'" + date + "'";
            }
           using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
           {
               var sql = "";
               var rowNames = "[ForumID],[ThreadID],[PostID],[DateQueued],[NewPost],[Notes],[SiteID], [Status]";
               var values = "{0}, {1}, {2},{3}, {4},'{5}',{6}, {7}";
               if (complaintantId.HasValue)
               {
                   rowNames += ", [ComplainantID]";
                   values += ", {8}";
               }
               

               sql = string.Format("INSERT INTO threadmod" +
                    "(" + rowNames + ")" +
                    "VALUES (" + values +")"
                    , forumId, threadId, postId, date, '1', notes, siteId, status, complaintantId);

               reader.ExecuteDEBUGONLY(sql);
           }
        }

        private IDnaDataReader GetModerationPostsItems(int userId, int? status, int? alerts, int? lockedItems,
            int? fastMod, bool? isSuperUser, int? modClassId, int? postId, bool? duplicatecomplaints, int? show)
        {
            //getmoderationposts @userid int, @status int = 0, @alerts int = 0,  @lockeditems int = 0, @fastmod int = 0, 
            //@issuperuser bit = 0, @modclassid int = NULL, @postid int = NULL, @duplicatecomplaints bit = 0, 
            //@show int = 10

            IDnaDataReader reader = StoredProcedureReader.Create("GetModerationPosts", _connectionDetails);

            reader.AddParameter("userid", userId);
            if (status.HasValue)reader.AddParameter("status", status);
            if (alerts.HasValue)reader.AddParameter("alerts", alerts);
            if (lockedItems.HasValue)reader.AddParameter("lockedItems", lockedItems);
            if (fastMod.HasValue)reader.AddParameter("fastmod", fastMod);
            if (isSuperUser.HasValue) reader.AddParameter("isSuperUser", isSuperUser);
            if (modClassId.HasValue) reader.AddParameter("modclassid", modClassId);
            if (postId.HasValue) reader.AddParameter("postid", postId);
            if (duplicatecomplaints.HasValue) reader.AddParameter("duplicatecomplaints", duplicatecomplaints);
            if (show.HasValue) reader.AddParameter("show", show);

            reader.Execute();

            return reader;
        }

        private void VerifyModItem(int modId, int lockedBy, int status, int postId)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY(string.Format("select * from threadmod where modid={0}", modId));

                Assert.IsTrue(reader.HasRows);
                Assert.IsTrue(reader.Read());
                Assert.AreEqual(status, reader.GetInt32NullAsZero("status"));
                Assert.AreEqual(postId, reader.GetInt32NullAsZero("postId"));
                Assert.AreEqual(lockedBy, reader.GetInt32NullAsZero("lockedBy"));

            }
        }

        private void ClearQueue()
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY("delete from threadmod");
            }
        }
    }
}
