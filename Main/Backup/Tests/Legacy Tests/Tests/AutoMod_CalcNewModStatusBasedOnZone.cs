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
    /// Tests for SP AutoMod_CalcNewModStatusBasedOnZone.
    /// </summary>
    [TestClass]
    public class AutoMod_CalcNewModStatusBasedOnZone
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
        /// Banned user.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcNewModStatusBasedOnZone_Banned()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("trustpoints", "-5");
                reader.AddIntReturnValue(); 
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 4); // Restricted (aka banned)
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("trustpoints", "-6");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 4); // Restricted (aka banned)
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("siteid", "1");
                reader.AddParameter("trustpoints", "-100");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 4); // Restricted (aka banned)
            }
        }

        /// <summary>
        /// Premod users.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcNewModStatusBasedOnZone_Premod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "-4");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Premoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "-2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Premoderated
            }
        }

        /// <summary>
        /// We in the BetweenPostmodAndReactive zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcNewModStatusBasedOnZone_BetweenPremodAndPostmod()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID = 1"); // premoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "-1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Premoderated
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 2 WHERE UserID = 1090501859 AND SiteID = 1"); // Postmoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "-1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 2); // Postmoderated
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0 WHERE UserID = 1090501859 AND SiteID = 1"); // standard
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "-1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // reactive
            }
        }

        /// <summary>
        /// We in the BetweenPostmodAndReactive zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcNewModStatusBasedOnZone_BetweenPostmodAndReactive()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID = 1"); // premoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "0");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 2); // Postmoderated
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID = 1"); // Postmoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 2); // postmod
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0 WHERE UserID = 1090501859 AND SiteID = 1"); // Postmoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "0");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // reactive
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0 WHERE UserID = 1090501859 AND SiteID = 1"); // standard
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // reactive
            }
        }

        /// <summary>
        /// We in the reactive zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcNewModStatusBasedOnZone_Reactive()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 1 WHERE UserID = 1090501859 AND SiteID = 1"); // premoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // reactive
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 2 WHERE UserID = 1090501859 AND SiteID = 1"); // Postmoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // reactive
            }

            // Put user in mod status
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("UPDATE dbo.Preferences SET ModStatus = 0 WHERE UserID = 1090501859 AND SiteID = 1"); // Postmoderated
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // standard
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "5");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // standard
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calcnewmodstatusbasedonzone"))
            {
                reader.AddParameter("userid", "1090501859");
                reader.AddParameter("trustpoints", "10");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 0); // standard
            }
        }
    }
}
