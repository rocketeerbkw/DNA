using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for SP AutoMod_SyncPostmodAcrossSites.
    /// </summary>
    [TestClass]
    public class AutoMod_SyncPostmodAcrossSites
    {
        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in postmod.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPostmodAcrossSites_UsersMembershipsInPostMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 2 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("AutoMod_SyncPostmodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPostmodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID IN (54, 72);");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 2, "The user has not been left in postmod on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in premod.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPostmodAcrossSites_UsersMembershipsInPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("AutoMod_SyncPostmodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPostmodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID IN (54, 72);");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 2, "The user has not been left in premod on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in banned.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPostmodAcrossSites_UsersMembershipsInBanned()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 4 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("AutoMod_SyncPostmodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPostmodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID IN (54, 72);");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 4, "The user has not been left in banned on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in reactive.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPostmodAcrossSites_UsersMembershipsInReactive()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0, TrustPoints = 5 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("AutoMod_SyncPostmodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPostmodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID IN (54, 72);");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 0, "The user has not been left in reactive on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in reactive.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPostmodAcrossSites_UsersMembershipsInBannedAndPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 4 WHERE UserID = 1090501859 AND SiteID = 54");
            }
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID = 72");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("AutoMod_SyncPostmodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPostmodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID IN (54, 72);");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    if (siteId == 54)
                    {
                        Assert.IsTrue(modStatus == 4, "The user has not been left in banned on site " + siteId);
                    }

                    if (siteId == 72)
                    {
                        Assert.IsTrue(modStatus == 2, "The user has not been placed in postmod on site " + siteId);
                    }
                }
            }
        }
    }
}