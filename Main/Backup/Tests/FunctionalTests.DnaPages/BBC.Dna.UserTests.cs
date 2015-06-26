using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


using TestUtils;
using BBC.Dna.Moderation;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class BBCDnaUserTests
    {
        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();

            ICacheManager groupsCache = new StaticCacheManager();
            var g = new UserGroups(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, groupsCache,null, null);
            var b = new BannedEmails(DnaMockery.CreateDatabaseReaderCreator(), DnaDiagnostics.Default, groupsCache, null, null);
        }

        /// <summary>
        /// Test to see if we can create a user with the new users service
        /// </summary>
        [TestMethod]
        public void Test01CreateAUserFromDNAUserID()
        {
            FullInputContext context = new FullInputContext("");
            User user = new User(null, null, null);
            Assert.IsTrue(user.CreateUserFromDnaUserID(TestUserAccounts.GetModeratorAccount.UserID, 1));
            Assert.IsTrue(user.IsUserA(UserTypes.Moderator));
            Assert.IsFalse(user.IsUserA(UserTypes.Editor));
        }

        /// <summary>
        /// Test to see if we can create a user with the new users service
        /// </summary>
        [TestMethod]
        public void Test02SignUserInViaIdentityCookie()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetModeratorAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetModeratorAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.Moderator));
            Assert.IsFalse(user.IsUserA(UserTypes.Editor));
        }

        /// <summary>
        /// Check to make sure we can sign a user in and then add them to a group
        /// </summary>
        [TestMethod]
        public void Test03SignUserInAndAddThemToAcesGroup()
        {
            FullInputContext context = new FullInputContext("dotnetmoderator");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, context.ReaderCreator, null, null, TestUserAccounts.GetModeratorAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetModeratorAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, TestUserAccounts.GetModeratorAccount.UserName, null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.Moderator));
            Assert.IsFalse(user.GetUsersGroupsForSite().Exists(x => x.Name == "aces"));
            Assert.IsTrue(user.AddUserToGroup("Aces"));
            Assert.IsTrue(user.GetUsersGroupsForSite().Exists(x => x.Name.ToLower() == "aces"));
        }

        /// <summary>
        /// Check to make sure that the normal user account has the correct permissions
        /// </summary>
        [TestMethod]
        public void Test04CheckSignedInNormalUserBelongsToTheCorrectGroups()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetNormalUserAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetNormalUserAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.NormalUser), "User should be a normal user");
            Assert.IsFalse(user.IsUserA(UserTypes.SuperUser), "User should not be a super user");
            Assert.IsFalse(user.IsUserA(UserTypes.Moderator), "User should not be a moderator");
            Assert.IsFalse(user.IsUserA(UserTypes.Editor), "User should not be a editor");
            Assert.IsFalse(user.IsUserA(UserTypes.Notable), "User should not be a notable");
        }

        /// <summary>
        /// Check to make sure that the editor account has the correct permissions
        /// </summary>
        [TestMethod]
        public void Test05CheckSignedInEditorBelongsToTheCorrectGroups()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetEditorUserAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetEditorUserAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.NormalUser), "User should be a normal user");
            Assert.IsFalse(user.IsUserA(UserTypes.SuperUser), "User should not be a super user");
            Assert.IsFalse(user.IsUserA(UserTypes.Moderator), "User should not be a moderator");
            Assert.IsTrue(user.IsUserA(UserTypes.Editor), "User should be a editor");
            Assert.IsFalse(user.IsUserA(UserTypes.Notable), "User should not be a notable");
        }

        /// <summary>
        /// Check to make sure that the super user account has the correct permissions
        /// </summary>
        [TestMethod]
        public void Test06CheckSignedInSuperUserBelongsToTheCorrectGroups()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetSuperUserAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetSuperUserAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsFalse(user.IsUserA(UserTypes.NormalUser), "User should not be a normal user");
            Assert.IsTrue(user.IsUserA(UserTypes.SuperUser), "User should be a super user");
            Assert.IsFalse(user.IsUserA(UserTypes.Moderator), "User should not be a moderator");
            Assert.IsTrue(user.IsUserA(UserTypes.Editor), "User should be a editor");
            Assert.IsFalse(user.IsUserA(UserTypes.Notable), "User should not be a notable");
        }

        /// <summary>
        /// Check to make sure that the moderator account has the correct permissions
        /// </summary>
        [TestMethod]
        public void Test07CheckSignedInModeratorBelongsToTheCorrectGroups()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetModeratorAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetModeratorAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.NormalUser), "User should be a normal user");
            Assert.IsFalse(user.IsUserA(UserTypes.SuperUser), "User should not be a super user");
            Assert.IsTrue(user.IsUserA(UserTypes.Moderator), "User should be a moderator");
            Assert.IsFalse(user.IsUserA(UserTypes.Editor), "User should not be a editor");
            Assert.IsFalse(user.IsUserA(UserTypes.Notable), "User should not be a notable");
        }

        /// <summary>
        /// Check to make sure that the notable account has the correct permissions
        /// </summary>
        [TestMethod]
        public void Test08CheckSignedInNotableBelongsToTheCorrectGroups()
        {
            FullInputContext context = new FullInputContext("");
            SignInSystem signInType = SignInSystem.Identity;
            CallingUser user = new CallingUser(signInType, null, null, null, TestUserAccounts.GetNotableUserAccount.UserName, context.SiteList);
            string cookie = TestUserAccounts.GetNotableUserAccount.Cookie;
            string policy = "comment";
            int siteID = 1;
            Assert.IsTrue(user.IsUserSignedIn(cookie, policy, siteID, "", null, Guid.Empty));
            Assert.IsTrue(user.IsUserA(UserTypes.NormalUser), "User should be a normal user");
            Assert.IsFalse(user.IsUserA(UserTypes.SuperUser), "User should not be a super user");
            Assert.IsFalse(user.IsUserA(UserTypes.Moderator), "User should not be a moderator");
            Assert.IsFalse(user.IsUserA(UserTypes.Editor), "User should not be a editor");
            Assert.IsTrue(user.IsUserA(UserTypes.Notable), "User should be a notable");
        }
    }
}
