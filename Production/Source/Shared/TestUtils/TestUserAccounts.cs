﻿using System;
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
        /// <param name="secureCookie">The secure cookie used for this account</param>
        /// <param name="userID">The dna userid for this account</param>
        /// <param name="usesIdentity">A flag that states whether this account uses sso or identity login</param>
        public UserAccount(string userName, string password, string cookie, string secureCookie, int userID, bool usesIdentity)
        {
            UserName = userName;
            Password = password;
            Cookie = cookie;
            SecureCookie = secureCookie;
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
        /// The get/set property for the secure cookie
        /// </summary>
        public string SecureCookie
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
            get { return new UserAccount("ProfileAPITest", "APITest", "6041996|ProfileAPITest|ProfileAPITest|1278931860545|0|2015a6fdc466524a1558fef420cc72bb91318f2ada03", "06424f6d9ea694a15a78fa403e71b458de7ee2ab", 1090498911, true); }
        }

        /// <summary>
        /// Creates the user account details for the normal user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalUserAccount
        {
            get { return new UserAccount("DotNetNormalUser", "789456123", "6042002|DotNetNormalUser|DotNetNormalUser|1278931997492|0|7c94ac3c9aa5711bbbf3f3f8e52b8ab953d76c0492c9", "24adcca95b98a359958e5e38b9921996a7efcc4d", 1090501859, true); }
        }

        /// <summary>
        /// Creates the user account details for the banned user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetBannedUserAccount
        {
            get { return new UserAccount("DotNetUserBanned", "asdfasdf", "6042004|DotNetUserBanned|DotNetUserBanned|1278932355700|0|286f856fcffe2f8464de1221ec745602955b4f529a9f", "28a9ad0e37b02b97ab7dd49dabf0c1212f07030f", 1165333426, true); }
        }

        /// <summary>
        /// Creates the user account details for the editor
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetEditorUserAccount
        {
            get { return new UserAccount("DotNetEditor", "789456123", "6042008|DotNetEditor|DotNetEditor|1278932076599|0|283da2e47ac55c5d41d8c79e8252dba938df6ebf6799", "32ba4f5c31478f5246bfe8bf83b0c07d6268d7d9", 1090558353, true); }
        }

        /// <summary>
        /// Creates the user account details for the super user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetSuperUserAccount
        {
            get { return new UserAccount("DotNetSuperUser", "789456123", "6042010|DotNetSuperUser|DotNetSuperUser|1278932113907|0|1a8c6a7fa6c7988539a9dbd009947bd91275181adf24", "ab87139454d8c26a08e83426565b02d42ce6ec04", 1090558354, true); }
        }

        /// <summary>
        /// Creates the user account details for the moderator
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetModeratorAccount
        {
            get { return new UserAccount("DotNetModerator", "789456123", "6042012|DotNetModerator|DotNetModerator|1278932154747|0|011028ab133a54235e7014cfdf18fe4dab220cef0a41", "a0a73b26623fbdf7305b750a97a422b0bf130505", 1090564231, true); }
        }

        /// <summary>
        /// Creates the user account details for the Pre moderated user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetPreModeratedUserAccount
        {
            get { return new UserAccount("DotNetPreModUser", "789456123", "6042014|DotNetPreModUser|DotNetPreModUser|1278932191622|0|2182db9680b1288a2c9b858ab2370c12bd6762428e34", "38e54c7ed1b5b08b3678e52be3d7f9a6bf6cb3ef", 1090565871, true); }
        }

        /// <summary>
        /// Creates the user account details for the Notable user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNotableUserAccount
        {
            get { return new UserAccount("DotNetNotableUser", "789456123", "6042020|DotNetNotableUser|DotNetNotableUser|1278932260628|0|a815ee222d1cabee1209b3dcba5f324daabea7579747", "2e331bab30933c96fea83276ef383b17b5d85a43", 1165233424, true); }
        }

        /// <summary>
        /// Creates the user account details for a user that's not logged in
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNonLoggedInUserAccount
        {
            get { return new UserAccount("", "", "", "", 0, false); }
        }

        /// <summary>
        /// Creates the user account details for the normal Identity user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalIdentityUserAccount
        {
            get { return new UserAccount("tester633518075951276859", "123456789", "6042026|tester633518075951276859|tester633518075951276859|1278932303472|0|ada0a782d45e069a1a789ff23336fedf671732ecf2ea", "0c6fc5d0555458cba17b3d568e84c7c9df024faa", 3405375, true); }
        }
    }
}
