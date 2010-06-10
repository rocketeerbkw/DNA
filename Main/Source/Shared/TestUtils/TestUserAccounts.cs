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
            get { return new UserAccount("ProfileAPITest", "APITest", "6041996|ProfileAPITest|ProfileAPITest|1273497769580|0|35006c522418c48a9a3470cea341b5cd9c9c8a9d28c1", "22f58fef9cd74c0f515b94bfaaa6adf60e395c6f", 1090498911, true); }
        }

        /// <summary>
        /// Creates the user account details for the normal user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalUserAccount
        {
            get { return new UserAccount("DotNetNormalUser", "789456123", "	6042002|DotNetNormalUser|DotNetNormalUser|1276178977695|0|a3fcc9fb3f250cb4d89005823c5594c2d5e2569aafb5", "528df52cdc33cf1db82cfd19f76319a48585db40", 1090501859, true); }
        }

        /// <summary>
        /// Creates the user account details for the banned user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetBannedUserAccount
        {
            get { return new UserAccount("DotNetUserBanned", "asdfasdf", "6042004|DotNetUserBanned|DotNetUserBanned|1276179047641|0|1c103d7b9428f20ae8c9fc7bff3ea66fc7822f510328%3A1", "f5f5df1f91fa4e99bb2821b4da1743922aa0d5c7", 1165333426, true); }
        }

        /// <summary>
        /// Creates the user account details for the editor
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetEditorUserAccount
        {
            get { return new UserAccount("DotNetEditor", "789456123", "6042008|DotNetEditor|DotNetEditor|1276179099788|0|5cbbf354cc7da089a9c559866fa04180356e37d23415%3A1", "48f975301829256f96a17b3f00690ce7556f569f", 1090558353, true); }
        }

        /// <summary>
        /// Creates the user account details for the super user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetSuperUserAccount
        {
            get { return new UserAccount("DotNetSuperUser", "789456123", "6042010|DotNetSuperUser|DotNetSuperUser|1276179150977|0|238d4cac69478d3af9f13da9ef09cc298a4abde31506", "d03bf5f07015a6df869b1ecc1fb68d864d2263e2", 1090558354, true); }
        }

        /// <summary>
        /// Creates the user account details for the moderator
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetModeratorAccount
        {
            get { return new UserAccount("DotNetModerator", "789456123", "6042012|DotNetModerator|DotNetModerator|1276179194056|0|2213c99777475fd0fc61685e6e15b4e634bcbc06ca8d", "23dda7c3984f4c982c5fc9dd28266bc0a86e60c7", 1090564231, true); }
        }

        /// <summary>
        /// Creates the user account details for the Pre moderated user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetPreModeratedUserAccount
        {
            get { return new UserAccount("DotNetPreModUser", "789456123", "6042014|DotNetPreModUser|DotNetPreModUser|1276179232442|0|b67d417ebd125946b4dc1f6badafdf60d2a97fddc924", "5d154b3f9a4ad510258ac33931f264a0c098ec4e", 1090565871, true); }
        }

        /// <summary>
        /// Creates the user account details for the Notable user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNotableUserAccount
        {
            get { return new UserAccount("DotNetNotableUser", "789456123", "6042020|DotNetNotableUser|DotNetNotableUser|1276179286146|0|a38d2e4e33d7ecd802b1c2c595393779961bccb28402", "7c3918e3f67e82c66290476cd24a8e530c2b2af4", 1165233424, true); }
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
            get { return new UserAccount("tester633518075951276859", "123456789", "6042026|tester633518075951276859|tester633518075951276859|1276179330727|0|b7ec6bd9ab8225b3ccbd1c29e7a9b82e9214769cb6f1", "9d4fdacc46e76d353585a720efed6506fa3ec38c", 3405375, true); }
        }
    }
}
