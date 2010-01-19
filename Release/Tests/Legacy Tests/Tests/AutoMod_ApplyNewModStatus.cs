using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using DnaIdentityWebServiceProxy;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for SP AutoMod_ApplyNewModStatus.
    /// </summary>
    [TestClass]
    public class AutoMod_ApplyNewModStatus
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
        /// Apply Premod status when IntoPreModCount is zero.
        /// </summary>
        [TestMethod]
        public void AutoMod_ApplyNewModStatus_PremodWhenIntoPreModCountIsZero()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPoints = 0, ModStatus = 0, IntoPreModCount = 0 WHERE UserID = 1090501859");
            }
            
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_applynewmodstatus"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("newmodstatus", 1); //premod
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_applynewmodstatus is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, IntoPreModCount FROM dbo.Preferences WHERE UserID = 1090501859");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID")); 
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int intoPreModCount = reader.GetTinyIntAsInt("IntoPreModCount");
                    Assert.IsTrue(modStatus == 1, "The user has not been placed in premod on site " + siteId); 
                    if (siteId == 1)
                    {
                        Assert.IsTrue(intoPreModCount == 1, "IntoPreModCount has not been incremented properly on Site " + siteId); 
                    }
                    else 
                    {
                        Assert.IsTrue(intoPreModCount == 0, "IntoPreModCount has not been left with expected value on site " + siteId); 
                    }
                }
            } 
        }

        /// <summary>
        /// Apply Premod status when IntoPreModCount is zero.
        /// </summary>
        [TestMethod]
        public void AutoMod_ApplyNewModStatus_PremodWhenIntoPreModCountIsOneBelowThreshold()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPoints = 0, ModStatus = 0, IntoPreModCount = 1 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_applynewmodstatus"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("newmodstatus", 1); //premod
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_applynewmodstatus is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, IntoPreModCount FROM dbo.Preferences WHERE UserID = 1090501859");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int intoPreModCount = reader.GetTinyIntAsInt("IntoPreModCount");
                    
                    if (siteId == 1)
                    {
                        Assert.IsTrue(intoPreModCount == 2, "IntoPreModCount has not been incremented properly on Site " + siteId);
                        Assert.IsTrue(modStatus == 4, "The user has not been banned as a result of going into premod too many times.");
                    }
                    else
                    {
                        Assert.IsTrue(modStatus == 1, "The user has not been placed in premod on site " + siteId);
                        Assert.IsTrue(intoPreModCount == 1, "IntoPreModCount has not been left with expected value on site " + siteId);
                    }
                }
            }
        }

        /// <summary>
        /// Apply banned status.
        /// </summary>
        [TestMethod]
        public void AutoMod_ApplyNewModStatus_Banned()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPoints = 0, ModStatus = 0, IntoPreModCount = 0 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_applynewmodstatus"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("newmodstatus", 4); //banned
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_applynewmodstatus is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, IntoPreModCount FROM dbo.Preferences WHERE UserID = 1090501859");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int intoPreModCount = reader.GetTinyIntAsInt("IntoPreModCount");

                    if (siteId == 1)
                    {
                        Assert.IsTrue(modStatus == 4, "The user has not been banned.");
                        Assert.IsTrue(intoPreModCount == 0, "IntoPreModCount has not been left with expected value on site " + siteId);
                    }
                    else
                    {
                        Assert.IsTrue(modStatus == 1, "The user has not been placed in premod on site " + siteId);
                        Assert.IsTrue(intoPreModCount == 0, "IntoPreModCount has not been left with expected value on site " + siteId);
                    }
                }
            }
        }

        /// <summary>
        /// Apply postmod status.
        /// </summary>
        [TestMethod]
        public void AutoMod_ApplyNewModStatus_PostModWhenUserInPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPoints = -2, ModStatus = 1, IntoPreModCount = 1 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_applynewmodstatus"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("newmodstatus", 2); //postmod
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_applynewmodstatus is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, IntoPreModCount, TrustPoints FROM dbo.Preferences WHERE UserID = 1090501859");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int intoPreModCount = reader.GetTinyIntAsInt("IntoPreModCount");
                    int trustPoints = reader.GetTinyIntAsInt("TrustPoints");

                    Assert.IsTrue(modStatus == 2, "The user has not been banned.");
                    Assert.IsTrue(intoPreModCount == 1, "IntoPreModCount has not been left with expected value on site " + siteId);
                    if (siteId == 1)
                    {
                        Assert.IsTrue(trustPoints == -2, "Trust points should remain same because update to score happens at an earlier point in the automod system.");
                    }
                    else
                    {
                        Assert.IsTrue(trustPoints == 0, "The user has not been synced with the correct trust points.");
                    }
                }
            }
        }

        /// <summary>
        /// Apply reactive status.
        /// </summary>
        [TestMethod]
        public void AutoMod_ApplyNewModStatus_ReactiveWhenUserInPreMod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET TrustPoints = -2, ModStatus = 1, IntoPreModCount = 1 WHERE UserID = 1090501859");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_applynewmodstatus"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("newmodstatus", 0); //reactive
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0, "@@ERROR from automod_applynewmodstatus is not 0.");
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT SiteID, ModStatus, IntoPreModCount, TrustPoints FROM dbo.Preferences WHERE UserID = 1090501859");

                Assert.IsTrue(reader.HasRows, "Query failed.");
                while (reader.Read())
                {
                    int siteId = reader.GetInt32(reader.GetOrdinal("SiteID"));
                    int modStatus = reader.GetTinyIntAsInt("ModStatus");
                    int intoPreModCount = reader.GetTinyIntAsInt("IntoPreModCount");
                    int trustPoints = reader.GetTinyIntAsInt("TrustPoints");

                    Assert.IsTrue(trustPoints == -2, "User does not have the correct trust points");
                    if (siteId == 1)
                    {
                        Assert.IsTrue(modStatus == 0, "User is not reactive when they should be.");
                    }
                    else
                    {
                        Assert.IsTrue(modStatus == 1, "User's mod status has not been left as expect on site " + siteId);
                    }
                }
            }
        }
    }
}