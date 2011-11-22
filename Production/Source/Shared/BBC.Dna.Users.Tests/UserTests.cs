using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Rhino.Mocks.Constraints;
using BBC.Dna.Utils;
using BBC.Dna.Users;
using BBC.Dna.Sites;
using System.Collections.Specialized;

namespace BBC.Dna.Users.Tests
{
    /// <summary>
    /// Summary description for UserTests
    /// </summary>
    [TestClass]
    public class UserTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        public UserTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private User CreateUser(int siteId, string twitterUserID, string loginName, string displayName, bool hasRows)
        {
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true);
            readerMembers.Stub(x => x.HasRows).Return(hasRows);
            readerMembers.Stub(x => x.GetString("username")).Return(loginName);
            readerMembers.Stub(x => x.GetString("displayname")).Return(displayName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(siteId);
            readerMembers.Stub(x => x.GetString("twitteruserid")).Return(twitterUserID);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewuserfromtwitteruserid")).Return(readerMembers);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var obj = new User(creator, diag, cache);
            return obj;
        }

        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_ValidInput_ReturnsTrue()
        {
            bool _userCreated = false;
            var siteId = 1;
            var twitterUserID = "1";
            var loginName = "Sachin";
            var displayName = "Sachin";

            var obj = CreateUser(siteId, twitterUserID, loginName, displayName, true);

            _userCreated = obj.CreateUserFromTwitterUserID(siteId, twitterUserID, loginName, displayName);
            Assert.IsTrue(_userCreated);
        }


        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_NoSiteID_ReturnsFalse()
        {
            bool _userCreated = false;
            var siteId = 0;
            var twitterUserID = "1";
            var loginName = "Sachin";
            var displayName = "Sachin";

            var obj = CreateUser(siteId, twitterUserID, loginName, displayName, true);

            try
            {
                _userCreated = obj.CreateUserFromTwitterUserID(siteId, twitterUserID, loginName, displayName);
            }
            catch (ArgumentException ex)
            {
                // Expecting an ArgumentException that mentions the twitterUserID id
                Assert.IsTrue(ex.Message.ToLower().Contains("siteid"));
                return;
            }
            Assert.Fail("Shouldn't get this far");
        }

        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_NoRows_ReturnsFalse()
        {
            bool userCreated = false;
            var siteId = 1;
            var twitterUserID = "1";
            var loginName = "Sachin";
            var displayName = "Sachin";

            var obj = CreateUser(siteId, twitterUserID, loginName, displayName, false);

            userCreated = obj.CreateUserFromTwitterUserID(siteId, twitterUserID, loginName, displayName);
            Assert.IsFalse(userCreated);
        }

        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_EmptyTwitterUserID_ReturnsFalse()
        {
            bool _userCreated = false;
            var siteId = 1;
            var twitterUserID = string.Empty;
            var loginName = "Sachin";
            var displayName = "Sachin";

            var obj = CreateUser(siteId, twitterUserID, loginName, displayName, true);

            try
            {
                _userCreated = obj.CreateUserFromTwitterUserID(siteId, twitterUserID, loginName, displayName);
            }
            catch (ArgumentException ex)
            {
                // Expecting an ArgumentException that mentions the twitterUserID id
                Assert.IsTrue(ex.Message.ToLower().Contains("twitteruserid"));
                return;
            }

            Assert.Fail("Shouldn't get this far");
        }
    }
}
