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
    /// Tests for SP AutoMod_SyncPremodAcrossSites.
    /// </summary>
    [TestClass]
    public class AutoMod_SyncPremodAcrossSites
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
        public void AutoMod_SyncPremodAcrossSites_UsersMembershipsInPostMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 2 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_syncpremodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_syncpremodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID <> 1;");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 1, "The user has not been placed in premod on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in premod.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPremodAcrossSites_UsersMembershipsInPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_syncpremodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_syncpremodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID <> 1;");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 1, "The user has not been left in premod on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Syncing a ban when user's memberships elsewhere are in banned.
        /// </summary>
        [TestMethod]
        public void AutoMod_SyncPremodAcrossSites_UsersMembershipsInBanned()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 4 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_syncpremodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_syncpremodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID <> 1;");

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
        public void AutoMod_SyncPremodAcrossSites_UsersMembershipsInReactive()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0, TrustPoints = 5 WHERE UserID = 1090501859 AND SiteID IN (54, 72)");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_syncpremodacrosssites"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_syncpremodacrosssites is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID <> 1;");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    Assert.IsTrue(modStatus == 1, "The user has not been placed in premod on site " + siteId);
                }
            }
        }

    }
}