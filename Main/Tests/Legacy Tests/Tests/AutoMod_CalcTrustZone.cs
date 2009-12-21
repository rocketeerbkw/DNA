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
    /// Tests for SP AutoMod_CalcTrustZone.
    /// </summary>
    [TestClass]
    public class AutoMod_CalcTrustZone
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
        /// Are we in the banned zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcTrustZone_BannedZone()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-5");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue(); 
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Banned
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-6");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Banned
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-100");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 1); // Banned
            }
        }

        /// <summary>
        /// Are we in the premod zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcTrustZone_PremodZone()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-4");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 2); // Banned
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 2); // Banned
            }
        }

        /// <summary>
        /// Are we in the BetweenPremodAndPostmod zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcTrustZone_BetweenPremodAndPostmodZone()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "-1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 3); // BetweenPremodAndPostmod
            }
        }

        /// <summary>
        /// Are we in the BetweenPostmodAndReactive zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcTrustZone_BetweenPostmodAndReactiveZone()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "0");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 4); // BetweenPostmodAndReactive
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "1");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 4); // BetweenPostmodAndReactive
            }
        }

        /// <summary>
        /// Are we in the BetweenPostmodAndReactive zone.
        /// </summary>
        [TestMethod]
        public void AutoMod_CalcTrustZone_ReactiveZone()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "2");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 5); // Reactive
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "5");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 5); // Reactive
            }

            using (IDnaDataReader reader = context.CreateDnaDataReader("automod_calctrustzone"))
            {
                reader.AddParameter("trustpoints", "10");
                reader.AddParameter("siteid", "1");
                reader.AddIntReturnValue();
                reader.Execute();

                int returnValue;
                reader.TryGetIntReturnValue(out returnValue);

                Assert.IsTrue(returnValue == 5); // Reactive
            }
        }
    }
}