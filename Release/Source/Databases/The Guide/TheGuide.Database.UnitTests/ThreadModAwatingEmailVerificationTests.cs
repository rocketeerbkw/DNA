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
    /// Summary description for ThreadModAwatingEmailVerificationTests
    /// </summary>
    [TestClass]
    public class ThreadModAwatingEmailVerificationTests
    {
        public ThreadModAwatingEmailVerificationTests()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

       private string _connectionDetails;

       [TestMethod]
       public void GetComplaintText_InputwithSpecialCharsWithoutN_ReturnsError()
       {
           using (new TransactionScope())
           {
               var complaintText = "لشروط المشاركة لأنها تحتوي على تشهير  Hi";

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteWithinATransaction(string.Format(@"INSERT INTO ThreadModAwaitingEmailVerification ( ID, ForumID, ThreadID, PostID, DateQueued, ComplaintText, SiteID, notes) " +
                   "VALUES ( 'BA76D71B-2F06-4173-91FE-0013B050027B', 10, 100, 1000, getdate(), '{0}', 1, 'Checking for unicode characters')", complaintText));

                   reader.ExecuteWithinATransaction("select * from ThreadModAwaitingEmailVerification");

                   Assert.IsTrue(reader.HasRows);
                   Assert.IsTrue(reader.Read());

                   Assert.AreNotEqual(reader.GetStringNullAsEmpty("ComplaintText"), complaintText);

                   reader.Close();
               }

           }
       }

       [TestMethod]
       public void GetComplaintText_InputwithSpecialCharsWithN_ReturnsCorrectResult()
       {
           using (new TransactionScope())
           {
               var complaintText = "لشروط المشاركة لأنها تحتوي على تشهير  Hi";

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteWithinATransaction(string.Format(@"INSERT INTO ThreadModAwaitingEmailVerification ( ID, ForumID, ThreadID, PostID, DateQueued, ComplaintText, SiteID, notes) " +
                   "VALUES ( 'BA76D71B-2F06-4173-91FE-0013B050027B', 10, 100, 1000, getdate(), N'{0}', 1, 'Checking for unicode characters')", complaintText));

                   reader.ExecuteWithinATransaction("select * from ThreadModAwaitingEmailVerification");

                   Assert.IsTrue(reader.HasRows);
                   Assert.IsTrue(reader.Read());

                   Assert.AreEqual(reader.GetStringNullAsEmpty("ComplaintText"), complaintText);

                   reader.Close();
               }

           }
       }

       [TestMethod]
       public void GetComplaintText_InputwithSP_ReturnsCorrectResult()
       {
           using (new TransactionScope())
           {
               var complaintText = "لشروط المشاركة لأنها تحتوي على تشهير  Hello";
               var hash = Guid.NewGuid();
               int postId = 0;
               string verificationUID;

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteWithinATransaction("select top 1 EntryId from ThreadEntries order by EntryId Desc");
                   reader.Read();
                   postId = reader.GetInt32("EntryId");
               }

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteWithinATransaction(string.Format(@"exec registerpostingcomplaint @complainantid={0},@correspondenceemail={1},@postid={2},@complainttext={3},@hash={4}", 0, "'abc@abc.abc'", postId, "N'" + complaintText + "'", "'" + hash + "'"));
                   reader.Read();

                   Assert.IsTrue(reader.DoesFieldExist("verificationUid"));
                   verificationUID = reader.GetGuidAsStringOrEmpty("verificationUid");
                   Assert.IsTrue(verificationUID.Length > 0);
                   reader.Close();
               }

               using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
               {
                   reader.ExecuteWithinATransaction("select * from ThreadModAwaitingEmailVerification where ID='" + verificationUID + "'");
                   reader.Read();

                   Assert.AreEqual(reader.GetStringNullAsEmpty("ComplaintText"), complaintText);
                   reader.Close();
               }
           }
       }
    }
}
