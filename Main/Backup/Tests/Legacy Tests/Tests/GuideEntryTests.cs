using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Tests for the guide entry object
    /// </summary>
    [TestClass]
    public class GuideEntryTests
    {
        /// <summary>
        /// Test to make sure that an invalid h2g2id will fail to create an entry
        /// </summary>
        [TestMethod]
        public void EnsureInvalidH2G2IDFailsToCreate()
        {
            // Create a mockery of the input context
            Mockery mockery = new Mockery();
            IInputContext mockedContext = mockery.NewMock<IInputContext>();

            // Now create the setup object and create the guideentry
            GuideEntrySetup setup = new GuideEntrySetup(123456789);
            GuideEntry testEntry = new GuideEntry(mockedContext, setup);

            // Test the initialisation code.
            Assert.IsFalse(testEntry.Initialise(), "Invalid h2g2id should return false!");
        }

        /// <summary>
        /// Test to make sure that an valid h2g2id will succeed to create an entry
        /// </summary>
        [Ignore]
        public void EnsureValidH2G2IDSucceedsToCreate()
        {
            // Create a mockery of the input context
            Mockery mockery = new Mockery();
            IInputContext mockedContext = mockery.NewMock<IInputContext>();

            IDnaDataReader mockedReader = mockery.NewMock<IDnaDataReader>();
            Stub.On(mockedReader).Method("AddParameter").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).GetProperty("HasRows").Will(Return.Value(true));
            Stub.On(mockedReader).Method("Read").Will(Return.Value(true));
            
            // Set the expiry date to be 1 minute from now
            Stub.On(mockedReader).Method("GetInt32").With("seconds").Will(Return.Value(60));
            Stub.On(mockedReader).Method("Dispose").Will(Return.Value(null));

            Stub.On(mockedContext).Method("CreateDnaDataReader").With("cachegetarticleinfo").Will(Return.Value(mockedReader));

            // Return false for now as it's bloody inpossible to test methods that use ref params!!!
            Stub.On(mockedContext).Method("FileCacheGetItem").Will(Return.Value(false));

            // Now create the setup object and create the guideentry
            GuideEntrySetup setup = new GuideEntrySetup(388217);
            GuideEntry testEntry = new GuideEntry(mockedContext, setup);

            // Test the initialisation code.
            Assert.IsTrue(testEntry.Initialise(), "Valid h2g2id should return true!");
        }
    }
}
