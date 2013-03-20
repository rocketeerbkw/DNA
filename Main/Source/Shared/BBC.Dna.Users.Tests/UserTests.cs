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
using TestUtils;
using BBC.Dna.Moderation;
using DnaIdentityWebServiceProxy;

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


        [Ignore,TestMethod]
        public void UserHasPrimarySiteHavingVisitedMultipleSites()
        {
            UserGroup g = new UserGroup();
            int primarySiteId = 60;
            var cache = _mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.Contains("")).Constraints(Is.Anything()).Return(false);

            var readerMembers = _mocks.DynamicMock<IDnaDataReader>();
            readerMembers.Stub(x => x.Read()).Return(true);
            readerMembers.Stub(x => x.HasRows).Return(true);
            readerMembers.Stub(x => x.GetInt32NullAsZero("PrimarySiteId")).Return(60);

            var creator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("finduserfromid")).Return(readerMembers);

            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();

            var user = new User(creator, diag, cache, null);
            user.CreateUserFromDnaUserID(1090501859, 60);

            

            Assert.AreEqual(primarySiteId, user.PrimarySiteId);
        }

        [TestMethod]
        public void UserGetsUDNGNameSetFromDisplayNameForKidsSiteUsingIDv4()
        {
            string cookie = "debugcookie";
            string policy = "u16comments";
            int siteID = 1;
            string identityUserName = TestUserAccounts.GetNormalUserAccount.UserName;
            string dnaUserName = "ThisIsDNASpecific";
            string originalSiteSuffix = "OriginalSiteSuffix";
            IdentityDebugSigninComponent i = new IdentityDebugSigninComponent(TestUserAccounts.GetKidUserAccount.UserName);
            string iDv3UDNG = i.GetAppNameSpacedAttribute(cookie, "CBBC", "cbbc_displayname");
            string ipAddress = "0.0.0.0";
            Guid BBCUid = new Guid();
            bool isKidsSite = true;
            bool useIdV4 = true;
            string useUDNG = "http://UDNG.bbc.co.uk";

            ICacheManager mockedCacheManager;
            IDnaDiagnostics mockedDiagnostics;
            ISiteList mockedSiteList;
            IDnaDataReaderCreator mockedCreator;
            SetupCallingUserSenario(siteID, dnaUserName, originalSiteSuffix, isKidsSite, useIdV4, useUDNG, out mockedCacheManager, out mockedDiagnostics, out mockedSiteList, out mockedCreator);

            _mocks.ReplayAll();

            var bannedEmails = new BannedEmails(mockedCreator, mockedDiagnostics, mockedCacheManager, new List<string>(), new List<string>());

            CallingUser callingUser = new CallingUser(SignInSystem.DebugIdentity, mockedCreator, mockedDiagnostics, null, identityUserName, mockedSiteList);

            Assert.IsTrue(callingUser.IsUserSignedIn(cookie, policy, siteID, identityUserName, ipAddress, BBCUid));
            Assert.AreNotEqual(originalSiteSuffix, callingUser.SiteSuffix);
            Assert.AreEqual(identityUserName, callingUser.SiteSuffix);
            Assert.AreNotEqual(iDv3UDNG, callingUser.SiteSuffix);
        }

        [TestMethod]
        public void UserGetsUDNGNameSetFromIdentityUNDGForKidsSiteUsingIDv3()
        {
            string cookie = "debugcookie";
            string policy = "u16comments";
            int siteID = 1;
            string identityUserName = TestUserAccounts.GetKidUserAccount.UserName;
            string dnaUserName = "ThisIsDNASpecific";
            string originalSiteSuffix = "OriginalSiteSuffix";
            IdentityDebugSigninComponent i = new IdentityDebugSigninComponent(TestUserAccounts.GetKidUserAccount.UserName);
            string iDv3UDNG = i.GetAppNameSpacedAttribute(cookie, "CBBC", "cbbc_displayname");
            string ipAddress = "0.0.0.0";
            Guid BBCUid = new Guid();
            bool isKidsSite = true;
            bool useIdV4 = false;
            string useUDNG = "http://UDNG.bbc.co.uk";

            ICacheManager mockedCacheManager;
            IDnaDiagnostics mockedDiagnostics;
            ISiteList mockedSiteList;
            IDnaDataReaderCreator mockedCreator;
            SetupCallingUserSenario(siteID, dnaUserName, originalSiteSuffix, isKidsSite, useIdV4, useUDNG, out mockedCacheManager, out mockedDiagnostics, out mockedSiteList, out mockedCreator);

            _mocks.ReplayAll();

            var bannedEmails = new BannedEmails(mockedCreator, mockedDiagnostics, mockedCacheManager, new List<string>(), new List<string>());

            CallingUser callingUser = new CallingUser(SignInSystem.DebugIdentity, mockedCreator, mockedDiagnostics, null, identityUserName, mockedSiteList);

            Assert.IsTrue(callingUser.IsUserSignedIn(cookie, policy, siteID, identityUserName, ipAddress, BBCUid));
            Assert.AreNotEqual(originalSiteSuffix, callingUser.SiteSuffix);
            Assert.AreNotEqual(identityUserName, callingUser.SiteSuffix);
            Assert.AreEqual(iDv3UDNG, callingUser.SiteSuffix);
        }

        [TestMethod]
        public void UserDoesNotGetsUDNGNameSetFromDisplayNameForNonKidsSiteUsingIDv4()
        {
            string cookie = "debugcookie";
            string policy = "u16comments";
            int siteID = 1;
            string identityUserName = TestUserAccounts.GetNormalUserAccount.UserName;
            string dnaUserName = "ThisIsDNASpecific";
            string originalSiteSuffix = "OriginalSiteSuffix";
            string ipAddress = "0.0.0.0";
            Guid BBCUid = new Guid();
            bool isKidsSite = false;
            bool useIdV4 = true;
            string useUDNG = "http://UDNG.bbc.co.uk";

            ICacheManager mockedCacheManager;
            IDnaDiagnostics mockedDiagnostics;
            ISiteList mockedSiteList;
            IDnaDataReaderCreator mockedCreator;
            SetupCallingUserSenario(siteID, dnaUserName, originalSiteSuffix, isKidsSite, useIdV4, useUDNG, out mockedCacheManager, out mockedDiagnostics, out mockedSiteList, out mockedCreator);

            _mocks.ReplayAll();

            var bannedEmails = new BannedEmails(mockedCreator, mockedDiagnostics, mockedCacheManager, new List<string>(), new List<string>());

            CallingUser callingUser = new CallingUser(SignInSystem.DebugIdentity, mockedCreator, mockedDiagnostics, null, identityUserName, mockedSiteList);

            Assert.IsTrue(callingUser.IsUserSignedIn(cookie, policy, siteID, identityUserName, ipAddress, BBCUid));
            Assert.AreNotEqual(originalSiteSuffix, callingUser.SiteSuffix);
            Assert.AreNotEqual(identityUserName, callingUser.SiteSuffix);
        }

        private void SetupCallingUserSenario(int siteID, string dnaUserName, string siteSuffix, bool isKidsSite, bool useIdV4, string useUDNG, out ICacheManager mockedCacheManager, out IDnaDiagnostics mockedDiagnostics, out ISiteList mockedSiteList, out IDnaDataReaderCreator mockedCreator)
        {
            mockedCacheManager = _mocks.DynamicMock<ICacheManager>();
            mockedDiagnostics = _mocks.DynamicMock<IDnaDiagnostics>();

            mockedSiteList = _mocks.DynamicMock<ISiteList>();
            mockedSiteList.Stub(x => x.GetSiteOptionValueBool(siteID, "General", "IsKidsSite")).Return(isKidsSite);
            mockedSiteList.Stub(x => x.GetSiteOptionValueBool(siteID, "Comments", "UseIDv4")).Return(useIdV4);
            mockedSiteList.Stub(x => x.GetSiteOptionValueString(siteID, "User", "AutoGeneratedNames")).Return(useUDNG);

            mockedCreator = _mocks.DynamicMock<IDnaDataReaderCreator>();
            var mockedReader = _mocks.DynamicMock<IDnaDataReader>();
            var mockedUserReader = _mocks.DynamicMock<IDnaDataReader>();
            var mockedProfileReader = _mocks.DynamicMock<IDnaDataReader>();

            var mockedUpdateReader = _mocks.DynamicMock<IDnaDataReader>();
            mockedCreator.Stub(x => x.CreateDnaDataReader("updateuser2")).Return(mockedUpdateReader);
            mockedUserReader.Stub(x => x.GetInt32("userid")).Return(TestUserAccounts.GetNormalUserAccount.UserID);
            mockedUserReader.Stub(x => x.GetString("username")).Return(dnaUserName);
            mockedUserReader.Stub(x => x.GetStringNullAsEmpty("SiteSuffix")).Return(siteSuffix);
            mockedUserReader.Stub(x => x.Read()).Return(true);
            mockedUserReader.Stub(x => x.HasRows).Return(true);

            mockedCreator.Stub(x => x.CreateDnaDataReader("getbannedemails")).Return(mockedReader);
            mockedCreator.Stub(x => x.CreateDnaDataReader("createnewuserfromidentityid")).Return(mockedUserReader);
            mockedCreator.Stub(x => x.CreateDnaDataReader("synchroniseuserwithprofile")).Return(mockedProfileReader);
        }
    }
}
