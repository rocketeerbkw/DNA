using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using TestUtils;
using BBC.Dna.Users;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Groups project
    /// </summary>
    [TestClass]
    public class BBCDnaGroupTests
    {
        private FullInputContext _context = new FullInputContext("");
        private int _userID = TestUserAccounts.GetNormalUserAccount.UserID;
        private int _editorID = TestUserAccounts.GetEditorUserAccount.UserID;
        private UserGroups g;

        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            
            SnapshotInitialisation.ForceRestore();

            ICacheManager groupsCache = new StaticCacheManager();
            g = new UserGroups(DnaMockery.CreateDatabaseReaderCreator(), _context.dnaDiagnostics, groupsCache, null, null);
        }

        /// <summary>
        /// Test that we get the correct groups for a given user
        /// </summary>
        [TestMethod]
        public void Test01GetGroupsForUser()
        {

            // Get the groups for the given user on the given site
            List<UserGroup> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.IsFalse(details.Count > 0, "The normal user should not belong to any groups!");
        }

        /// <summary>
        /// Test that we get the correct groups for a given user
        /// </summary>
        [TestMethod]
        public void Test04GetGroupsForEditor()
        {
            
           // Get the groups for the given user on the given site
            List<UserGroup> details = g.GetUsersGroupsForSite(_editorID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for editor " + _editorID.ToString() + " for site 1");
            int itemCount = details.Count;

            /* cache no longer works like this...
            // Check to make sure that the groups info is in the cache
            details = (List<string>)groupsCache["BBC.Dna.UserGroups-" + _editorID.ToString() + "-1"];
            Assert.IsNotNull(details, "Failed to get the group details for editor " + _editorID.ToString() + " for site 1 The second time round");
            Assert.AreEqual(itemCount, details.Count, "The cache contains different info");
             */

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
            
            // Get the groups for the given user on the given site
            List<UserGroup> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            int itemCount = details.Count;

            // Now add the user to another group
            Assert.IsTrue(g.PutUserIntoGroup(_userID, "bestnewbie", 1), "Failed to add the user to the scouts group");

            // Check to make sure that the user was added correctly
            details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.AreEqual(itemCount+1,details.Count,"There should be one more group in the list for the user");
            Assert.IsTrue(details.Exists(x => x.Name == "bestnewbie"), "The list does not contain the Mentor group");
        }

        /// <summary>
        /// Test we can remove a user from a group
        /// </summary>
        [TestMethod]
        public void Test03RemoveUserFromGroup()
        {
            
            ICacheManager groupsCache = new StaticCacheManager();
            

            // Get the groups for the given user on the given site
            List<UserGroup> details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            int itemCount = details.Count;

            // Now remove the user from the aces group
            g.DeleteUserFromGroup(_userID, "bestnewbie", 1);

            // Check to make sure that the user was added correctly
            details = g.GetUsersGroupsForSite(_userID, 1);
            Assert.IsNotNull(details, "Failed to get the group details for user " + _userID.ToString() + " for site 1");
            Assert.AreEqual(itemCount - 1, details.Count, "There should be one less group in the list for the user");
            Assert.IsFalse(details.Exists(x => x.Name =="bestnewbie"), "The list contains the Mentor group");
        }
    }
}
