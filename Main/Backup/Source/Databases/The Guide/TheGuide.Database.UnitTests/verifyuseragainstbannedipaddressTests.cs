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
    public class verifyuseragainstbannedipaddressTests
    {
        public verifyuseragainstbannedipaddressTests()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;
        private int _userid = 1090558354;
        private string _ipaddress="192.168.0.1";
        private Guid _bbcUid = Guid.NewGuid();
        private int _siteId = 1;


        [TestMethod]
        public void verifyuseragainstbannedipaddress_UserWithBannedIpAddress_BanUser()
        {
            using (new TransactionScope())
            {
                AddIpAddress();

                using (IDnaDataReader reader = StoredProcedureReader.Create("verifyuseragainstbannedipaddress", _connectionDetails))
                {
                    reader.AddParameter("@userid", _userid);
                    reader.AddParameter("@siteid", 1);
                    reader.AddParameter("@ipaddress", _ipaddress);
                    reader.AddParameter("@bbcuid", _bbcUid);
                    reader.Execute();
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("select * from preferences where userid={0} and siteid={1}", _userid, _siteId));

                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(4, reader.GetInt32NullAsZero("prefstatus"));
                }
            }
        }

        [TestMethod]
        public void verifyuseragainstbannedipaddress_UserWithNormalIpAddress_NotBannedUser()
        {
            using (new TransactionScope())
            {
                AddIpAddress();

                using (IDnaDataReader reader = StoredProcedureReader.Create("verifyuseragainstbannedipaddress", _connectionDetails))
                {
                    reader.AddParameter("@userid", _userid);
                    reader.AddParameter("@siteid", 1);
                    reader.AddParameter("@ipaddress", _ipaddress);
                    reader.AddParameter("@bbcuid", Guid.NewGuid());
                    reader.Execute();
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("select * from preferences where userid={0} and siteid={1}", _userid, _siteId));

                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(0, reader.GetInt32NullAsZero("prefstatus"));
                }
            }
        }

        private void AddIpAddress()
       {
           using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
           {
               reader.ExecuteDEBUGONLY(string.Format("insert into bannedIPAddress (userid, ipaddress, bbcuid) values ({0},'{1}','{2}')", 1, _ipaddress, _bbcUid));
           }
       }
      
    }
}
