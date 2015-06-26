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
    /// Tests for SP AutoMod_UserHasPosted
    /// </summary>
    [TestClass]
    public class AutoMod_UserHasPosted
    {
        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_updatesitethresholds"))
            {
                reader.AddParameter("siteid", "1");
                reader.AddParameter("bannedthresholdvalue", "-5");
                reader.AddParameter("premodthresholdvalue", "-2");
                reader.AddParameter("postmodthresholdvalue", "0");
                reader.AddParameter("reactivethresholdvalue", "2");
                reader.AddParameter("maxtrustvalue", "5");
                reader.AddParameter("numpostspertrustpoint", "2");
                reader.AddParameter("maxintopremodcount", "2");
                reader.AddParameter("seedusertrustusingpreviousbehaviour", "1");
                reader.AddParameter("initialtrustpoints", "0");
                reader.Execute();
            }
        }

        /// <summary>
        /// Post
        /// </summary>
        [TestMethod]
        public void AutoMod_UserHasPosted_Post()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPointPosts = 0, TrustPoints = 0, ModStatus = 0, IntoPreModCount = 0 WHERE UserID = 1090501859");
            }
            
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_userhasposted"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPremod is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, TrustPointPosts, TrustPoints FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID = 1");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID")); 
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int trustPointPosts = reader.GetTinyIntAsInt("TrustPointPosts");
                    int trustPoints = reader.GetTinyIntAsInt("TrustPoints");
                    Assert.IsTrue(modStatus == 0, "The user has not kept their mod status on site " + siteId);
                    Assert.IsTrue(trustPointPosts == 1, "User TrustPointPosts count should be 1 on site " + siteId);
                    Assert.IsTrue(trustPoints == 0, "The user TrustPoints score should be 0 on site " + siteId);
                }
            } 
        }

        /// <summary>
        /// Post when in post mod about to go into reactive
        /// </summary>
        [TestMethod]
        public void AutoMod_UserHasPosted_PostWhenAlmostInReactive()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPointPosts = 1, TrustPoints = 1, ModStatus = 2, IntoPreModCount = 0 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_userhasposted"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPremod is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, TrustPointPosts, TrustPoints FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID = 1");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int trustPointPosts = reader.GetTinyIntAsInt("TrustPointPosts");
                    int trustPoints = reader.GetTinyIntAsInt("TrustPoints");
                    Assert.IsTrue(modStatus == 0, "The user has not been set to reactive on site " + siteId);
                    Assert.IsTrue(trustPointPosts == 0, "User TrustPointPosts count should be reset to 0 on site " + siteId);
                    Assert.IsTrue(trustPoints == 2, "The user TrustPoints score should be 0 on site " + siteId);
                }
            }
        }

        /// <summary>
        /// Post when in premod about to go into postmod
        /// </summary>
        [TestMethod]
        public void AutoMod_UserHasPosted_PostWhenAlmostInPostMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPointPosts = 1, TrustPoints = -1, ModStatus = 1, IntoPreModCount = 1 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_userhasposted"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from AutoMod_SyncPremod is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, TrustPointPosts, TrustPoints FROM dbo.Preferences WHERE UserID = 1090501859 AND SiteID = 1");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int trustPointPosts = reader.GetTinyIntAsInt("TrustPointPosts");
                    int trustPoints = reader.GetTinyIntAsInt("TrustPoints");
                    Assert.IsTrue(modStatus == 2, "The user has not been put into reactive on site " + siteId);
                    Assert.IsTrue(trustPointPosts == 0, "User TrustPointPosts count should be reset to 0 on site " + siteId);
                    Assert.IsTrue(trustPoints == 0, "The user TrustPoints score should be 0 on site " + siteId);
                }
            }
        }
    }
}
