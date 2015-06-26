using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using System.Collections.Generic;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using System.Xml;
using BBC.Dna.Common;
using System;
using System.Collections;

namespace BBC.Dna.Moderation.Utils.Tests
{
    /// <summary>
    /// Summary description for ProfanityFilterTests
    /// </summary>
    [TestClass]
    public class ModerationStatusTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        [TestInitialize]
        public void Setup()
        {
        }

        [TestMethod]
        public void UpdateModerationStatuses_SingleUserSite_CorrectlyExecutesCall()
        {
            List<int> userIDList = new List<int>() { 1 };
            List<int> siteList = new List<int>() { 1 };
            
            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute());

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updatetrackedmemberlist")).Return(reader);
            _mocks.ReplayAll();

            ModerationStatus.UpdateModerationStatuses(creator, userIDList, siteList, 0,0,"",0);

            reader.AssertWasCalled(x => x.AddParameter("userIDs", "1"));
            reader.AssertWasCalled(x => x.AddParameter("siteIDs", "1"));
        }

        [TestMethod]
        public void UpdateModerationStatuses_MultipleUserSite_CorrectlyExecutesCall()
        {
            List<int> userIDList = new List<int>() { 1,2 };
            List<int> siteList = new List<int>() { 1,3 };

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute());

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("updatetrackedmemberlist")).Return(reader);
            _mocks.ReplayAll();

            ModerationStatus.UpdateModerationStatuses(creator, userIDList, siteList, 0, 0, "", 0);

            reader.AssertWasCalled(x => x.AddParameter("userIDs", "1|2"));
            reader.AssertWasCalled(x => x.AddParameter("siteIDs", "1|3"));
        }

        [TestMethod]
        public void DeactivateAccount_MultipleUsers_CorrectlyExecutesCall()
        {
            List<int> userIDList = new List<int>() { 1, 2 };

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute());

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("deactivateaccount")).Return(reader);
            _mocks.ReplayAll();

            ModerationStatus.DeactivateAccount(creator, userIDList, false, "", 0);

            reader.AssertWasCalled(x => x.AddParameter("userid", 1));
            reader.AssertWasCalled(x => x.AddParameter("userid", 2));

        }

        [TestMethod]
        public void ReactivateAccount_MultipleUsers_CorrectlyExecutesCall()
        {
            List<int> userIDList = new List<int>() { 1, 2 };

            var reader = _mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.Execute());

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("reactivateaccount")).Return(reader);
            _mocks.ReplayAll();

            ModerationStatus.ReactivateAccount(creator, userIDList,"", 0);

            reader.AssertWasCalled(x => x.AddParameter("userid", 1));
            reader.AssertWasCalled(x => x.AddParameter("userid", 2));

        }

      
    }
}