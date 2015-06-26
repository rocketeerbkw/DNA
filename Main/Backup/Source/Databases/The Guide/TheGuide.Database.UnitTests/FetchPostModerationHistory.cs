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
    public class FetchPostModerationHistory
    {
        public FetchPostModerationHistory()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

       private string _connectionDetails;

       [TestMethod]
       public void FetchPostModerationHistory_PostUserInPostMod_ReturnsPostUserInPostMod()
        {
            using (new TransactionScope())
            {
                int modId, postId, userId, siteId;
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select top 1 * from threadmod");
                    Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                    Assert.IsTrue(reader.Read());
                    
                
                    modId = reader.GetInt32NullAsZero("ModID");
                    postId = reader.GetInt32NullAsZero("postId");
                    siteId = reader.GetInt32NullAsZero("siteId");
                }
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select u.* from users u inner join threadentries te on te.userid = u.userid where entryid=" + postId.ToString());
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());
                    userId = reader.GetInt32NullAsZero("userid");
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("exec fetchpostmoderationhistory @postid=" + postId);
                    Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                    while (reader.Read())
                    {
                        Assert.AreEqual(0, reader.GetInt32NullAsZero("AuthorStatus"));
                    }

                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("update preferences set prefstatus=2 where siteid={0} and userid={1}", siteId, userId));
                }
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("exec fetchpostmoderationhistory @postid=" + postId);
                    Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(2, reader.GetInt32NullAsZero("AuthorStatus"));
 
                }
            }
        }

       [TestMethod]
       public void FetchPostModerationHistory_ComplaintantUserInPostMod_ReturnsComplaintUserInPostMod()
       {
           using (new TransactionScope())
           {
               int modId, postId, userId, siteId;
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY("select top 1 * from threadmod where complainantid is not null");
                   Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                   Assert.IsTrue(reader.Read());


                   modId = reader.GetInt32NullAsZero("ModID");
                   postId = reader.GetInt32NullAsZero("postId");
                   siteId = reader.GetInt32NullAsZero("siteId");
                   userId = reader.GetInt32NullAsZero("complainantid");
               }
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY("exec fetchpostmoderationhistory @postid=" + postId);
                   Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                   while (reader.Read())
                   {
                       if (!reader.IsDBNull("ComplainantUserId"))
                       {
                           Assert.AreEqual(0, reader.GetInt32NullAsZero("Complainantstatus"));
                       }
                   }

               }
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY(string.Format("update preferences set prefstatus=2 where siteid={0} and userid={1}", siteId, userId));
               }
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY("exec fetchpostmoderationhistory @postid=" + postId);
                   Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                   while (reader.Read())
                   {
                       if (!reader.IsDBNull("ComplainantUserId"))
                       {
                           Assert.AreEqual(2, reader.GetInt32NullAsZero("Complainantstatus"));
                       }
                   }

               }
           }
       }
    }
}
