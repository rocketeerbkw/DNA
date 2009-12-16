using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace TestUtils
{
    /// <summary>
    /// Test User Account details class. Used to get the username, password, cookie and userid for testing perposes
    /// </summary>
    public class UserAccount
    {
        /// <summary>
        /// Creates the new class with the given details
        /// </summary>
        /// <param name="userName">The username for the account</param>
        /// <param name="password">The password for the account</param>
        /// <param name="cookie">The cookie used for this account</param>
        /// <param name="userID">The dna userid for this account</param>
        /// <param name="usesIdentity">A flag that states whether this account uses sso or identity login</param>
        public UserAccount(string userName, string password, string cookie, int userID, bool usesIdentity)
        {
            UserName = userName;
            Password = password;
            Cookie = cookie;
            UserID = userID;
            UsesIdentity = usesIdentity;
            IdentityUserName = userName;
        }

        /// <summary>
        /// The get/Set property for the username
        /// </summary>
        public string UserName
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the password
        /// </summary>
        public string Password
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the cookie
        /// </summary>
        public string Cookie
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the userid
        /// </summary>
        public int UserID
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the uses identity flag
        /// </summary>
        public bool UsesIdentity
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the identity user name
        /// </summary>
        public string IdentityUserName
        {
            get;
            set;
        }
    }
    
    /// <summary>
    /// Helper class that creates the account details for all the different test users we have
    /// </summary>
    public class TestUserAccounts
    {
        /// <summary>
        /// Creates the user account details for the profile api user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetProfileAPITestUserAccount
        {
            get { return new UserAccount("ProfileAPITest", "APITest", "44c5a3037b5a65b37bbef0f591cdf10e1d9e59903823a0cb01270e7da41e8e3b00", 1090498911, false); }
        }

        /// <summary>
        /// Creates the user account details for the normal user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalUserAccount
        {
            get { return new UserAccount("DotNetNormalUser", "789456123", "0465e40bc638441a2e9b6381816653cf1a1348ec78c360cba1871e0d8345ef4800", 1090501859, false); }
        }

        /// <summary>
        /// Creates the user account details for the banned user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetBannedUserAccount
        {
            get { return new UserAccount("DotNetUserBanned", "asdfasdf", "542926f3b88d86c2b085062a01251fbbcfe1206a58b330fba197aeed9672415b00", 1166868343, false); }
        }

        /// <summary>
        /// Creates the user account details for the editor
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetEditorUserAccount
        {
            get { return new UserAccount("DotNetEditor", "789456123", "c4f5f57424cad2a942aa372761895fdae360410098c3e0ab31a71e7dd7d10e5b00", 1090558353, false); }
        }

        /// <summary>
        /// Creates the user account details for the super user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetSuperUserAccount
        {
            get { return new UserAccount("DotNetSuperUser", "789456123", "44f575d494ab0bb18384c0f961240c09fe4043606893d04b6107fe6df7411e2a00", 1090558354, false); }
        }

        /// <summary>
        /// Creates the user account details for the moderator
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetModeratorAccount
        {
            get { return new UserAccount("DotNetModerator", "789456123", "5455c5ac05fd028981f5da2891c1d4567f73249c384310eb11c79e8d540142ca00", 1090564231, false); }
        }

        /// <summary>
        /// Creates the user account details for the Pre moderated user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetPreModeratedUserAccount
        {
            get { return new UserAccount("DotNetPreModUser", "789456123", "0495f53dda7c633e7a527c2751ae8aab77a953cde823f0bb01a77e7d533fbd8c00", 1090565871, false); }
        }

        /// <summary>
        /// Creates the user account details for the Notable user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNotableUserAccount
        {
            get { return new UserAccount("DotNetNotableUser", "789456123", "147587fd39a67dca6c0b23ffb18e2925bf1d0bd60813506be1076e7d155b4f9700", 1165233424, false); }
        }

        /// <summary>
        /// Creates the user account details for a user that's not logged in
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNonLoggedInUserAccount
        {
            get { return new UserAccount("", "", "", 0, false); }
        }

        /// <summary>
        /// Creates the user account details for the normal Identity user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalIdentityUserAccount
        {
            get { return new UserAccount("tester633518075951276859", "123456789", HttpUtility.UrlEncode("AQICySfvBLGfchTj5H8n4BV3oMunIzG4/bvFsiq+zOzU1eTUptTbH0/zNgT1hWeoHvv3JZEdZdNGXqzObiMiDaDFHIb7/pOIBKMc5qk8NxiW6yBUY/Zh/wenRhBhHB+8jK/z4X+uyoNDwSE="), 3405375, true); }
        }
    }
}
