using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml;
using TestUtils;
using Rhino.Mocks;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;

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
            reader.Stub(x => x.GetInt32NullAsZero("accumulativescore")).Return(1);

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

    }
}
