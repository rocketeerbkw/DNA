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
    public class FetchArticleModerationHistory
    {
        public FetchArticleModerationHistory()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

       private string _connectionDetails;

       [TestMethod]
       public void FetchArticleModerationHistory_PostUserInPostMod_ReturnsPostUserInPostMod()
        {
            using (new TransactionScope())
            {
                int modId, h2g2id, userId, siteId;
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select top 1 * from articlemod");
                    Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                    Assert.IsTrue(reader.Read());
                    
                
                    modId = reader.GetInt32NullAsZero("ModID");
                    h2g2id = reader.GetInt32NullAsZero("h2g2id");
                    siteId = reader.GetInt32NullAsZero("siteId");
                }
                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from guideentries where h2g2id=" + h2g2id.ToString());
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());
                    userId = reader.GetInt32NullAsZero("editor");
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("exec FetchArticleModerationHistory @h2g2id=" + h2g2id);
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
                    reader.ExecuteDEBUGONLY("exec FetchArticleModerationHistory @h2g2id=" + h2g2id);
                    Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(2, reader.GetInt32NullAsZero("AuthorStatus"));
 
                }
            }
        }

       [TestMethod]
       public void FetchArticleModerationHistory_ComplaintantUserInPostMod_ReturnsComplaintUserInPostMod()
       {
           using (new TransactionScope())
           {
               int modId, h2g2id, userId, siteId;
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY("select top 1 * from articlemod");
                   Assert.IsTrue(reader.HasRows, "Failed to get any mod items");
                   Assert.IsTrue(reader.Read());


                   modId = reader.GetInt32NullAsZero("ModID");
                   h2g2id = reader.GetInt32NullAsZero("h2g2id");
                   siteId = reader.GetInt32NullAsZero("siteId");
               }
               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   userId =TestUserAccounts.GetNormalUserAccount.UserID;
                   reader.ExecuteDEBUGONLY("update articlemod set complainantid=" + userId);
               }

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteDEBUGONLY("exec FetchArticleModerationHistory @h2g2id=" + h2g2id);
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
                   reader.ExecuteDEBUGONLY("exec FetchArticleModerationHistory @h2g2id=" + h2g2id);
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
