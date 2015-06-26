using BBC.Dna.Moderation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks;
using System.Xml;
using TestUtils;
using System;
using System.Collections.Generic;

namespace BBC.Dna.Moderation.Tests
{
    
    
    /// <summary>
    ///This is a test class for TermAdminTest and is intended
    ///to contain all TermAdminTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ModerationPostsTests
    {

        public MockRepository Mocks = new MockRepository();

        [TestMethod()]
        public void EditPost_ValidDatabase_ReturnsNothing()
        {
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("updatepostdetails")).Return(reader);
            Mocks.ReplayAll();

            ModerationPosts.EditPost(readerCreator, 0, 0, "", "", false, false);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("updatepostdetails"));
        }

        [TestMethod()]
        public void RegisterComplaint_ValidDatabaseWithVerification_ReturnsVerificationCode()
        {

            var guid = Guid.NewGuid();
            var returnedGuid = Guid.Empty;
            int returnedInt = 0;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("verificationUid")).Return(true);
            reader.Stub(x => x.GetGuid("verificationUid")).Return(guid);
                
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            Mocks.ReplayAll();

            ModerationPosts.RegisterComplaint(readerCreator, 0, "", "", 0, "", Guid.Empty, out returnedGuid, out returnedInt);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));

            Assert.AreEqual(guid, returnedGuid);
        }

        [TestMethod()]
        public void RegisterComplaint_ValidDatabaseWithModId_ReturnsModId()
        {

            var modId =1;
            var returnedGuid = Guid.Empty;
            int returnedInt = 0;

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.DoesFieldExist("modId")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("modId")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("registerpostingcomplaint")).Return(reader);
            Mocks.ReplayAll();

            ModerationPosts.RegisterComplaint(readerCreator, 0, "", "", 0, "", Guid.Empty, out returnedGuid, out returnedInt);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("registerpostingcomplaint"));

            Assert.AreEqual(returnedInt, modId);
        }

        [TestMethod()]
        public void ApplyModerationDecision_ValidDatabaseReply_ReturnsData()
        {
            var modId = 1;
            var threadId = 1;
            var postId = 2;
            var authorId = 3;
            var modUserId = 4;
            var returnedGuid = Guid.Empty;
            Queue<String> complainantEmails;
            Queue<int> complainantIds;
            Queue<int> modIds;
            string authorEmail ="";

            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Read()).Return(true).Repeat.Once();
            reader.Stub(x => x.GetInt32NullAsZero("modid")).Return(modId);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader("moderatepost")).Return(reader);
            Mocks.ReplayAll();

            ModerationPosts.ApplyModerationDecision(readerCreator, 0, ref threadId, ref postId, 0, 
                ModerationItemStatus.Failed, "", 0, 0, "", out complainantEmails, out complainantIds, 
                out modIds, out authorEmail, out authorId, modUserId);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("moderatepost"));

            Assert.AreEqual(1, modIds.Count);
            Assert.AreEqual(modId, modIds.Dequeue());
        }

    }
}
