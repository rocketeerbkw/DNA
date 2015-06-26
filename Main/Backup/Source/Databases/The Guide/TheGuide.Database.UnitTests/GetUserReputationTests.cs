using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using TestUtils;
using BBC.Dna.Data;
using System.Configuration;
using BBC.DNA.Moderation.Utils;
using BBC.Dna.Moderation.Utils;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for FetchGroupsAndMembersTests
    /// </summary>
    [TestClass]
    public class GetUserReputationTests
    {
        public GetUserReputationTests()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;
        private int _userid = 1090558354;
        private int _modClassId = 1;
        

        [TestMethod]
        public void GetUserReputation_WithStandardScore_ReturnsStandardUser()
        {
            using (new TransactionScope())
            {
                short score = 1;
                int existingModStatus = (int)ModerationStatus.UserStatus.Premoderated;
                int expectedReputationStatus = (int)ModerationStatus.UserStatus.Standard;
                AddReputationScore(score, existingModStatus);

                DoGetUserReputation(score, existingModStatus, expectedReputationStatus);
            }
        }

        [TestMethod]
        public void GetUserReputation_WithPostModScore_ReturnsPostModUser()
        {
            using (new TransactionScope())
            {
                short score = -1;
                int existingModStatus = (int)ModerationStatus.UserStatus.Standard;
                int expectedReputationStatus = (int)ModerationStatus.UserStatus.Postmoderated;
                AddReputationScore(score, existingModStatus);

                DoGetUserReputation(score, existingModStatus, expectedReputationStatus);
            }
        }

        [TestMethod]
        public void GetUserReputation_WithPreModScore_ReturnsPreModUser()
        {
            using (new TransactionScope())
            {
                short score = -6;
                int existingModStatus = (int)ModerationStatus.UserStatus.Standard;
                int expectedReputationStatus = (int)ModerationStatus.UserStatus.Premoderated;
                AddReputationScore(score, existingModStatus);

                DoGetUserReputation(score, existingModStatus, expectedReputationStatus);
            }
        }


        [TestMethod]
        public void GetUserReputation_WithBannedScore_ReturnsBannedUser()
        {
            using (new TransactionScope())
            {
                short score = -11;
                int existingModStatus = (int)ModerationStatus.UserStatus.Standard;
                int expectedReputationStatus = (int)ModerationStatus.UserStatus.Restricted;
                AddReputationScore(score, existingModStatus);

                DoGetUserReputation(score, existingModStatus, expectedReputationStatus);
            }
        }

        private void DoGetUserReputation(short score, int existingModStatus, int reputationDeterminedStatus)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("getuserreputation", _connectionDetails))
            {
                reader.AddParameter("@userid", _userid);
                reader.AddParameter("@modclassid", _modClassId);
                reader.AddIntOutputParameter("@currentStatus");
                reader.AddIntOutputParameter("@reputationDeterminedStatus");
                reader.Execute();

                Assert.IsTrue(reader.Read());
                Assert.AreEqual(score, reader.GetInt16("accumulativescore"));
                Assert.AreEqual(reputationDeterminedStatus, reader.GetInt32NullAsZero("reputationDeterminedStatus"));
                Assert.AreEqual(existingModStatus, reader.GetInt32NullAsZero("currentstatus"));
            }
        }

        private void AddReputationScore(short score, int existingModStatus)
       {
           using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
           {
               reader.ExecuteDEBUGONLY(string.Format("update preferences set prefstatus={2} where userid={0}", _userid, _modClassId, existingModStatus));
               reader.ExecuteDEBUGONLY(string.Format("delete from userreputationscore where userid={0} and modclassid={1}", _userid, _modClassId));
               reader.ExecuteDEBUGONLY(string.Format("insert into userreputationscore (userid, modclassid, accumulativescore) values ({0},{1},{2})", _userid, _modClassId, score));
               reader.ExecuteDEBUGONLY(string.Format("delete from userreputationthreshold where modclassid={0}", _modClassId));
               reader.ExecuteDEBUGONLY(string.Format("insert into dbo.userreputationthreshold select {0}, 11, 5,0,0,-5,-10", _modClassId));
           }
       }
      
    }
}
