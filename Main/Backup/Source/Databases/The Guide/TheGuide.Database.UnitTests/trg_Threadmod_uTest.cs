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
    public class trg_Threadmod_uTest
    {

        private int _siteId = 70;//mbiplayer
        private int _postId = 61;
        private int _forumId = 7325075;
        private int _threadId = 34;

        public trg_Threadmod_uTest()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;

        [TestMethod]
        public void trg_Threadmod_uTest_10ItemsMaxLessItems_NoChangeToFastMod()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddForumToFastMod(_forumId);
                List<int> modIds = new List<int>();
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());

                SetMaxItemOption(10);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    foreach (int modId in modIds)
                    {
                        reader.ExecuteDEBUGONLY("update threadmod set datecompleted=getdate() where modid=" + modId.ToString());
                    }
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from fastmodforums where forumid=" + _forumId.ToString());
                    Assert.IsTrue(reader.HasRows);
                }
            }
        }

        [TestMethod]
        public void trg_Threadmod_uTest_1ItemMaxMoreItems_ForumRemovedFromFastMod()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddForumToFastMod(_forumId);
                List<int> modIds = new List<int>();
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());

                SetMaxItemOption(1);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    foreach (int modId in modIds)
                    {
                        reader.ExecuteDEBUGONLY("update threadmod set datecompleted=getdate() where modid=" + modId.ToString());
                    }
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from fastmodforums where forumid=" + _forumId.ToString());
                    Assert.IsFalse(reader.HasRows);
                }
            }
        }

        [TestMethod]
        public void trg_Threadmod_uTest_NoOptionSet_ForumStaysInFastMod()
        {
            using (new TransactionScope())
            {
                ClearQueue();
                AddForumToFastMod(_forumId);
                List<int> modIds = new List<int>();
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());
                modIds.Add(AddItem());

                //SetMaxItemOption(1);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    foreach (int modId in modIds)
                    {
                        reader.ExecuteDEBUGONLY("update threadmod set datecompleted=getdate() where modid=" + modId.ToString());
                    }
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from fastmodforums where forumid=" + _forumId.ToString());
                    Assert.IsTrue(reader.HasRows);
                }
            }
        }

        


        private void AddForumToFastMod(int forumId)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY("insert into fastmodforums (forumid) values (" + forumId.ToString() + ")");
            }
        }

        private int AddItem()
        {
           return AddItemToQueue(_forumId, _threadId, _postId, "", _siteId,null, 0, "");
        }

        private int AddItemToQueue(int forumId, int threadId, int postId, string notes, int siteId, 
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

               reader.ExecuteDEBUGONLY("select max(modid) as modid from threadmod");
               if (!reader.Read())
               {
                   throw new Exception("No item created");
               }
               return reader.GetInt32NullAsZero("modid");
           }
        }

        private void SetMaxItemOption(int max)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY(
                    string.Format("INSERT INTO SiteOptions (siteid, Section, [Name], [Value], [Type], Description) values  ({0}, 'Moderation', 'MaxItemsInPriorityModeration', '{1}',0, 'The maximum number of moderated items before forum removed from priority moderation - 0 means never.')",
                    _siteId, max));
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
