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
    public class GetModerationExLinks
    {
        public GetModerationExLinks()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        private string _connectionDetails;

        [TestMethod]
        public void GetModerationExLinks_NoItemsLocked_LocksItemsUnderUser()
        {
            using (new TransactionScope())
            {
                var userId = TestUserAccounts.GetModeratorAccount.UserID;
                var siteId = 1;
                int modId = 0;

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from sites where siteid=" + siteId);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());


                    modId = reader.GetInt32NullAsZero("ModClassID");
                }

                AddExUrl(siteId);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("select * from ExLinkMod"));
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        Assert.IsTrue(reader.IsDBNull("lockedby"));
                    }
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=0, @userid={1}", modId, userId));
                    Assert.IsTrue(reader.HasRows);
                    while (reader.Read())
                    {
                        Assert.AreEqual(userId, reader.GetInt32NullAsZero("lockedby"));
                    }
                }


            }
        }

        [TestMethod]
        public void GetModerationExLinks_ItemsAlreadyLocked_NoLockedItemsUnderUser()
        {
            using (new TransactionScope())
            {
                var userId = TestUserAccounts.GetModeratorAccount.UserID;
                var siteId = 1;
                int modId = 0;

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from sites where siteid=" + siteId);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());

                    modId = reader.GetInt32NullAsZero("ModClassID");
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("INSERT INTO ExLinkMod ( uri, callbackuri,  status, siteid, lockedby, DateQueued, complainttext, notes) " +
                        "VALUES ( 'http://www.bbc.co.uk', 'http://www.bbc.co.uk', 0, {0}, {1}, getdate(), '', '')", siteId, userId));
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=0, @userid={1}", modId, userId));
                    Assert.IsTrue(reader.HasRows);
                }

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=0, @userid={1}", modId, TestUserAccounts.GetNormalUserAccount.UserID));
                    Assert.IsFalse(reader.HasRows);
                }
            }
        }

        [TestMethod]
        public void GetModerationExLinks_GetAlreadyLockedItems_ReturnsOnlyLockedItems()
        {
            using (new TransactionScope())
            {
                var userId = TestUserAccounts.GetModeratorAccount.UserID;
                var siteId = 1;
                int modId = 0;

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select * from sites where siteid=" + siteId);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());


                    modId = reader.GetInt32NullAsZero("ModClassID");
                }
                AddExUrl(siteId);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=0, @userid={1}", modId, userId));
                    Assert.IsTrue(reader.HasRows);
                }

                //add another item
                AddExUrl(siteId);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=1, @userid={1}", modId, userId));
                    Assert.IsTrue(reader.HasRows);
                    int count = 0;
                    while (reader.Read())
                    {
                        count++;
                        Assert.AreEqual(userId, reader.GetInt32NullAsZero("LockedBy"));
                    }
                    Assert.AreEqual(1, count, "Should only have one item");
                }


            }
        }

        [TestMethod]
        public void GetModerationExLinks_ItemsInDifferentModClasses_ReturnsOnlyLockedItemsForModClass()
        {
            using (new TransactionScope())
            {
                var userId = TestUserAccounts.GetModeratorAccount.UserID;
                var siteId = 1;
                int modId = 3;
                int altModId = 0;
                int altSiteId = 0;

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY("select top 1 * from sites where ModClassID <> " + modId);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());

                    altSiteId = reader.GetInt32NullAsZero("siteid");
                    altModId = reader.GetInt32NullAsZero("ModClassID");
                }
                AddExUrl(siteId);
                AddExUrl(altSiteId);

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    reader.ExecuteDEBUGONLY(string.Format("exec getmoderationexlinks @modclassid={0}, @referrals=0, @alerts=1, @locked=0, @userid={1}", modId, userId));
                    Assert.IsTrue(reader.HasRows);
                    int count = 0;
                    while (reader.Read())
                    {
                        count++;
                        Assert.AreEqual(userId, reader.GetInt32NullAsZero("LockedBy"));
                        Assert.AreEqual(siteId, reader.GetInt32NullAsZero("SiteId"));

                    }
                    Assert.AreEqual(1, count, "Should only have one item");
                }
            }
        }


        private void AddExUrl(int siteId)
        {
            using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
            {
                reader.ExecuteDEBUGONLY(string.Format("INSERT INTO ExLinkMod ( uri, callbackuri,  status, siteid, DateQueued, complainttext, notes) " +
                    "VALUES ( 'http://www.bbc.co.uk', 'http://www.bbc.co.uk', 0, {0}, getdate(), '', '')", siteId));
            }
        }

    }
}
