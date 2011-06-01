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
    public class updatetrackedmemberlistTests
    {
        public updatetrackedmemberlistTests()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;
        private int _userid = 1090558354;
        private int _entryId = 62;
        private string _ipaddress="192.168.0.1";
        private Guid _bbcUid = Guid.NewGuid();


        [TestMethod]
        public void updatetrackedmemberlist_BanUser_UserBannedWithIpAddress()
        {
            using (new TransactionScope())
            {
                AddIpAddress();

                using (IDnaDataReader reader = StoredProcedureReader.Create("updatetrackedmemberlist", _connectionDetails))
                {
                    reader.AddParameter("@userids", _userid);
                    reader.AddParameter("@siteids", 1);
                    reader.AddParameter("@prefstatus", 4);//banned
                    reader.AddParameter("@prefstatusduration", 0);
                    reader.AddParameter("@reason", "test");
                    reader.AddParameter("@viewinguser", 6);
                    reader.Execute();
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("select * from BannedIPAddress where userid={0}",_userid));

                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(_ipaddress, reader.GetStringNullAsEmpty("ipaddress"));
                    Assert.AreEqual(_bbcUid, reader.GetGuid("bbcuid"));
                }
                //remove ban
                using (IDnaDataReader reader = StoredProcedureReader.Create("updatetrackedmemberlist", _connectionDetails))
                {
                    reader.AddParameter("@userids", _userid);
                    reader.AddParameter("@siteids", 1);
                    reader.AddParameter("@prefstatus", 0);//banned
                    reader.AddParameter("@prefstatusduration", 0);
                    reader.AddParameter("@reason", "test");
                    reader.AddParameter("@viewinguser", 6);
                    reader.Execute();
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("select * from BannedIPAddress where userid={0}", _userid));

                    Assert.IsFalse(reader.HasRows);
                }
                
            }
        }

        private void AddIpAddress()
       {
           using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
           {
               reader.ExecuteDEBUGONLY(string.Format("insert into ThreadEntriesIPAddress (entryid, ipaddress, bbcuid) values ({0},'{1}','{2}')", _entryId, _ipaddress, _bbcUid));
           }
       }
      
    }
}
