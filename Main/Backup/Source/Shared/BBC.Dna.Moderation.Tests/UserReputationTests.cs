using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml;
using TestUtils;
using Rhino.Mocks;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using System;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for ModerationClassTest and is intended
    ///to contain all ModerationClassTest Unit Tests
    ///</summary>
    [TestClass()]
    public class UserReputationTest
    {
        public MockRepository Mocks = new MockRepository();

        /// <summary>
        ///A test for ModerationClass Constructor
        ///</summary>
        [TestMethod()]
        public void GetUserReputation_ValidDB_ReturnsValidObj()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("currentstatus")).Return((int)ModerationStatus.UserStatus.Premoderated);
            reader.Stub(x => x.GetInt32NullAsZero("ReputationDeterminedStatus")).Return((int)ModerationStatus.UserStatus.Postmoderated);
            reader.Stub(x => x.GetInt16("accumulativescore")).Return(1);

            creator.Stub(x => x.CreateDnaDataReader("getuserreputation")).Return(reader);
            Mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { };

            var userRep = UserReputation.GetUserReputation(creator, modClass, 0);

            Assert.AreEqual(ModerationStatus.UserStatus.Premoderated, userRep.CurrentStatus);
            Assert.AreEqual(ModerationStatus.UserStatus.Postmoderated, userRep.ReputationDeterminedStatus);
            Assert.AreEqual(1, userRep.ReputationScore);
        }

        [TestMethod()]
        public void GetUserReputation_InValidDB_ReturnsValidObj()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(false).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("getuserreputation")).Return(reader);
            Mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { };

            var userRep = UserReputation.GetUserReputation(creator, modClass, 0);

            
            Assert.AreEqual(0, userRep.ReputationScore);
        }

        [TestMethod()]
        public void ApplyModerationStatus_ValidDB_NoErrors()
        {
            var bannedEmailsTests = new BannedEmailsTests();
            bannedEmailsTests.InitializebannedEmails_EmptyCacheValidRecordSet_ReturnsValidObject();


            var notes = "somenotes";
            var duration = 5;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("updatetrackedmemberformodclass")).Return(reader);
            Mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { };

            var userRep = new UserReputation
            {
                UserId = 1,
                ModClass = new ModerationClass() { ClassId = 1 },
                ReputationDeterminedStatus = BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Premoderated,
            };

            userRep.ApplyModerationStatus(creator, false, duration, notes, 1);

            reader.AssertWasCalled(x => x.AddParameter("userid", userRep.UserId));
            reader.AssertWasCalled(x => x.AddParameter("viewinguser", 1));
            reader.AssertWasCalled(x => x.AddParameter("reason", notes));
            reader.AssertWasCalled(x => x.AddParameter("prefstatusduration", duration));
            reader.AssertWasCalled(x => x.AddParameter("modclassid", userRep.ModClass.ClassId));
            reader.AssertWasCalled(x => x.AddParameter("prefstatus", (int)userRep.ReputationDeterminedStatus));
        }

        [TestMethod()]
        public void ApplyModerationStatus_ApplyToAllSites_NoErrors()
        {

            var bannedEmailsTests  = new BannedEmailsTests();
            bannedEmailsTests.InitializebannedEmails_EmptyCacheValidRecordSet_ReturnsValidObject();

            var notes = "";
            var duration = 5;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("updatetrackedmemberformodclass")).Return(reader);
            Mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { };

            var userRep = new UserReputation
            {
                UserId = 1,
                ModClass = new ModerationClass() { ClassId = 1 },
                ReputationDeterminedStatus = BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus.Premoderated,
            };

            userRep.ApplyModerationStatus(creator, true, duration, notes, 1);

            reader.AssertWasCalled(x => x.AddParameter("userid", userRep.UserId));
            reader.AssertWasCalled(x => x.AddParameter("modclassid", 0));
            reader.AssertWasCalled(x => x.AddParameter("prefstatus", (int)userRep.ReputationDeterminedStatus));
            reader.AssertWasCalled(x => x.AddParameter("reason","User Reputation Determined"));
            reader.AssertWasCalled(x => x.AddParameter("prefstatusduration", duration));
        }

        [TestMethod()]
        public void ApplyModerationStatus_NotInitalised_ThrowsError()
        {
            var notes = "";
            var duration = 5;
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            var creator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            creator.Stub(x => x.CreateDnaDataReader("updatetrackedmemberformodclass")).Return(reader);
            Mocks.ReplayAll();

            ModerationClass modClass = new ModerationClass() { };

            var userRep = new UserReputation();
            try
            {
                userRep.ApplyModerationStatus(creator, true, duration, notes, 1);
                throw new Exception("no exception thrown");
            }
            catch (Exception e)
            {
                Assert.AreEqual("UserId cannot be zero", e.Message);
            }

            reader.AssertWasNotCalled(x => x.Execute());
            
        }

    }
}
