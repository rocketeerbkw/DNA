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
using BBC.Dna.SocialAPI;

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

        private User CreateTwitterUser(int siteId, string twitterUserID, string twitterScreenName, bool hasRows)
        {
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true);
            readerMembers.Stub(x => x.HasRows).Return(hasRows);
            readerMembers.Stub(x => x.GetString("twitterscreenname")).Return(twitterScreenName);
            readerMembers.Stub(x => x.GetInt32("siteid")).Return(siteId);
            readerMembers.Stub(x => x.GetString("twitteruserid")).Return(twitterUserID);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("createnewuserfromtwitteruserid")).Return(readerMembers);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var user = new User(creator, diag, cache);
            return user;
        }

        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_ValidInput_ReturnsTrue()
        {
            bool _userCreated = false;
            var siteId = 1;
            var tweetUser = new TweetUser() { ScreenName = "Sachin", id = "1" };

            var user = CreateTwitterUser(siteId, tweetUser.id, tweetUser.ScreenName, true);

            _userCreated = user.CreateUserFromTwitterUserID(siteId, tweetUser);
            Assert.IsTrue(_userCreated);
        }


        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_NoSiteID_ReturnsFalse()
        {
            bool _userCreated = false;
            var siteId = 0;
            var tweetUser = new TweetUser() { ScreenName = "Sachin", id = "1" };

            var user = CreateTwitterUser(siteId, tweetUser.id, tweetUser.ScreenName, true);

            try
            {
                _userCreated = user.CreateUserFromTwitterUserID(siteId, tweetUser);
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
            var tweetUser = new TweetUser() { ScreenName = "Sachin", id = "1" };

            var user = CreateTwitterUser(siteId, tweetUser.id, tweetUser.ScreenName, false);

            userCreated = user.CreateUserFromTwitterUserID(siteId, tweetUser);
            Assert.IsFalse(userCreated);
        }

        [TestMethod]
        public void CreateTweetUserFromSignInTwitterUserID_EmptyTwitterUserID_ReturnsFalse()
        {
            bool _userCreated = false;
            var siteId = 1;
            var tweetUser = new TweetUser() { ScreenName = "Sachin", id = string.Empty };

            var user = CreateTwitterUser(siteId, tweetUser.id, tweetUser.ScreenName, true);

            try
            {
                _userCreated = user.CreateUserFromTwitterUserID(siteId, tweetUser);
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
