using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Groups;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Groups project
    /// </summary>
    [TestClass]
    public class BBCDnaGroupTests
    {
        private FullInputContext _context = new FullInputContext(false);
        private int _userID = TestUserAccounts.GetNormalUserAccount.UserID;
        private int _editorID = TestUserAccounts.GetEditorUserAccount.UserID;

        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();
        }

        /// <summary>
        /// Test that we get the correct groups for a given user
        /// </summary>
        [TestMethod]
        public void Test01GetGroupsForUser()
        {
            // Setup the groups object and give it a caching object
            ICacheManager groupsCache = CacheFactory.GetCacheManager();
            UserGroups g = new UserGroups(null, null, groupsCache);

            // Get the groups for the given user on the given site
            List<string> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.IsFalse(details.Count > 0, "The normal user should not belong to any groups!");
        }

        /// <summary>
        /// Test that we get the correct groups for a given user
        /// </summary>
        [TestMethod]
        public void Test04GetGroupsForEditor()
        {
            // Setup the groups object and give it a caching object
            ICacheManager groupsCache = CacheFactory.GetCacheManager();
            UserGroups g = new UserGroups(null, null, groupsCache);

            // Get the groups for the given user on the given site
            List<string> details = g.GetUsersGroupsForSite(_editorID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for editor " + _editorID.ToString() + " for site 1");
            int itemCount = details.Count;

            // Check to make sure that the groups info is in the cache
            details = (List<string>)groupsCache["BBC.Dna.UserGroups-" + _editorID.ToString() + "-1"];
            Assert.IsNotNull(details, "Failed to get the group details for editor " + _editorID.ToString() + " for site 1 The second time round");
            Assert.AreEqual(itemCount, details.Count, "The cache contains different info");

            // Get them again, they should be cached now
            details = g.GetUsersGroupsForSite(_editorID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for editor " + _editorID.ToString() + " for site 1 The second time round");
        }

        /// <summary>
        /// Test that we can add a user to a group
        /// </summary>
        [TestMethod]
        public void Test02AddUserToGroup()
        {
            // Setup the groups object and give it a caching object
            ICacheManager groupsCache = CacheFactory.GetCacheManager();
            UserGroups g = new UserGroups(null, null, groupsCache);

            // Get the groups for the given user on the given site
            List<string> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            int itemCount = details.Count;

            // Now add the user to another group
            Assert.IsTrue(g.PutUserIntoGroup(_userID, "mentor", 1), "Failed to add the user to the mentor group");

            // Check to make sure that the user was added correctly
            details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.AreEqual(itemCount+1,details.Count,"There should be one more group in the list for the user");
            Assert.IsTrue(details.Contains("mentor"), "The list does not contain the Mentor group");
        }

        /// <summary>
        /// Test we can remove a user from a group
        /// </summary>
        [TestMethod]
        public void Test03RemoveUserFromGroup()
        {
            // Setup the groups object and give it a caching object
            ICacheManager groupsCache = CacheFactory.GetCacheManager();
            UserGroups g = new UserGroups(null, null, groupsCache);

            // Get the groups for the given user on the given site
            List<string> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            int itemCount = details.Count;

            // Now remove the user from the aces group
            g.DeleteUserFromGroup(_userID, "mentor", 1);

            // Check to make sure that the user was added correctly
            details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.AreEqual(itemCount - 1, details.Count, "There should be one less group in the list for the user");
            Assert.IsFalse(details.Contains("mentor"), "The list contains the Mentor group");
        }
    }
}
