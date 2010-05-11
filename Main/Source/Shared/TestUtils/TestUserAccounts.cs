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
            get { return new UserAccount("DotNetNormalUser", "789456123", "6042002|DotNetNormalUser|DotNetNormalUser|1273497514775|0|bf78fdd57a1f70faee630c07ba31674eab181a3f6c6f", "1eda650cb28e56156217427336049d0b8e164765", 1090501859, true); }
        }

        /// <summary>
        /// Creates the user account details for the banned user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetBannedUserAccount
        {
            get { return new UserAccount("DotNetUserBanned", "asdfasdf", "6042004|DotNetUserBanned|DotNetUserBanned|1273497847257|0|9d9ee980c4b831e419915b452b050f327862bba748ff", "a684c1a5736f052c4acc1b35908f8dbad2e2ea0b", 1166868343, true); }
        }

        /// <summary>
        /// Creates the user account details for the editor
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetEditorUserAccount
        {
            get { return new UserAccount("DotNetEditor", "789456123", "6042008|DotNetEditor|DotNetEditor|1273497906539|0|15a03d81d14abc2192aa62781a933f9a5a610fdd8ed2", "911ebe989e3856bfa15fea9198db182c742edb56", 1090558353, true); }
        }

        /// <summary>
        /// Creates the user account details for the super user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetSuperUserAccount
        {
            get { return new UserAccount("DotNetSuperUser", "789456123", "6042010|DotNetSuperUser|DotNetSuperUser|1273498316242|0|794f88d288072423ec646e60e4fc85934f843d84c60a", "e791eb7e4f6df35d9401ccdc9401aaaea939fecd", 1090558354, true); }
        }

        /// <summary>
        /// Creates the user account details for the moderator
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetModeratorAccount
        {
            get { return new UserAccount("DotNetModerator", "789456123", "6042012|DotNetModerator|DotNetModerator|1273498400655|0|5285c1191c687edd59454e53aae1853b32f959d0b0ef", "7c665ae2f596ea3966fc3aff9a237f038e6e262e", 1090564231, true); }
        }

        /// <summary>
        /// Creates the user account details for the Pre moderated user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetPreModeratedUserAccount
        {
            get { return new UserAccount("DotNetPreModUser", "789456123", "6042014|DotNetPreModUser|DotNetPreModUser|1273498451514|0|c3fc0e4160f8e9d4d06225bcd7bbabbc9d105319ed37", "8dddf64ebe1ee4ff8c6f2b328a145c66dcc3ccf1", 1090565871, true); }
        }

        /// <summary>
        /// Creates the user account details for the Notable user
        /// </summary>
        /// <returns>The user account details for the user</returns>
        public static UserAccount GetNotableUserAccount
        {
            get { return new UserAccount("DotNetNotableUser", "789456123", "6042020|DotNetNotableUser|DotNetNotableUser|1273498519048|0|efb2184843a54e628b6e08dd6144fa450809f38df204", "f20234251c89cf2d686b954050092857a7d6b59d", 1165233424, true); }
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
            get { return new UserAccount("tester633518075951276859", "123456789", "6042026|tester633518075951276859|tester633518075951276859|1273498567629|0|07d3831992314f01d1a5909de1d922dcf5bba5f91ce8", "d6736d7457cc61bc2a18726fb6028fe69338ca6e", 3405375, true); }
        }
    }
}
