using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using DnaIdentityWebServiceProxy;

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

        /// <summary>
        /// The get/set property for the identity user name
        /// </summary>
        public string IdentityId
        {
            get
            {
                return Cookie.Substring(0, Cookie.IndexOf("|"));
            }
        }
    }
    
    /// <summary>
    /// Helper class that creates the account details for all the different test users we have
    /// </summary>
    public class TestUserAccounts
    {
        private static UserAccount testProfileAPIAccount = null;
        private static UserAccount testNormalUserAccount = null;
        private static UserAccount testBannedUserAccount = null;
        private static UserAccount testEditorUserAccount = null;
        private static UserAccount testSuperUserAccount = null;
        private static UserAccount testModeratorAccount = null;
        private static UserAccount testPreModeratedUserAccount = null;
        private static UserAccount testNotableUserAccount = null;
        private static UserAccount testTrustedUserAccount = null;

        /// <summary>
        /// Creates the user account details for the profile api user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetProfileAPITestUserAccount
        {
            get
            {
                if (testProfileAPIAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("ProfileAPITest", "789456123", out cookie, out secureCookie);
                    testProfileAPIAccount = new UserAccount("ProfileAPITest", "789456123", cookie, secureCookie, 1090498911, true);
                }
                return testProfileAPIAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the normal user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNormalUserAccount
        {
            get
            {
                if (testNormalUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetNormalUser", "789456123", out cookie, out secureCookie);
                    testNormalUserAccount = new UserAccount("DotNetNormalUser", "789456123", cookie, secureCookie, 1090501859, true);
                }
                return testNormalUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the banned user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetBannedUserAccount
        {
            get
            {
                if (testBannedUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetUserBanned", "789456123", out cookie, out secureCookie);
                    testBannedUserAccount = new UserAccount("DotNetUserBanned", "789456123", cookie, secureCookie, 1165333426, true);
                }
                return testBannedUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the editor
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetEditorUserAccount
        {
            get
            {
                if (testEditorUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetEditor", "789456123", out cookie, out secureCookie);
                    testEditorUserAccount = new UserAccount("DotNetEditor", "789456123", cookie, secureCookie, 1090558353, true); 
                }
                return testEditorUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the super user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetSuperUserAccount
        {
            get
            {
                if (testSuperUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetSuperUser", "789456123", out cookie, out secureCookie);
                    testSuperUserAccount = new UserAccount("DotNetSuperUser", "789456123", cookie, secureCookie, 1090558354, true); 
                }
                return testSuperUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the moderator
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetModeratorAccount
        {
            get
            {
                if (testModeratorAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetModerator", "789456123", out cookie, out secureCookie);
                    testModeratorAccount = new UserAccount("DotNetModerator", "789456123", cookie, secureCookie, 1090564231, true); 
                }
                return testModeratorAccount;
            }
       }

        /// <summary>
        /// Creates the user account details for the Pre moderated user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetPreModeratedUserAccount
        {
            get
            {
                if (testPreModeratedUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetPreModUser", "789456123", out cookie, out secureCookie);
                    testPreModeratedUserAccount = new UserAccount("DotNetPreModUser", "789456123", cookie, secureCookie, 1090565871, true); 
                }
                return testPreModeratedUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the Notable user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNotableUserAccount
        {
            get
            {
                if (testNotableUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("DotNetNotableUser", "789456123", out cookie, out secureCookie);
                    testNotableUserAccount = new UserAccount("DotNetNotableUser", "789456123", cookie, secureCookie, 1165233424, true); 
                }
                return testNotableUserAccount;
            }
        }

        /// <summary>
        /// Creates the user account details for the trusted user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetTrustedUserAccount
        {
            get
            {
                if (testTrustedUserAccount == null)
                {
                    string cookie, secureCookie;
                    GetUserCookies("test_trusted", "789456123", out cookie, out secureCookie);
                    testTrustedUserAccount = new UserAccount("test_trusted", "789456123", cookie, secureCookie, 1165333429, true); 
                }
                return testTrustedUserAccount;
            }
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

        public static void GetUserCookies(string userName, string password, out string cookie, out string secureCookie)
        {
            IDnaIdentityWebServiceProxy proxy = new IdentityRestSignIn();
            proxy.Initialise("https://api.test.bbc.co.uk/opensso/identityservices/IdentityServices;dna;http://www-cache.reith.bbc.co.uk:80;logging", "");
            proxy.TrySetUserViaUserNamePassword(userName, password);
            cookie = proxy.GetCookieValue;
            secureCookie = proxy.GetSecureCookieValue;
        }
    }
}
