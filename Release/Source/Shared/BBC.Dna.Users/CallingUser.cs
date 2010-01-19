using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using BBC.Dna.BannedEmails;
using BBC.Dna.Utils;
using DnaIdentityWebServiceProxy;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.Users
{
    public class CallingUser : User
    {
        SignInSystem _signInSystem = SignInSystem.Identity;

        public enum SigninStatus
        {
            SignedInLoggedIn,
            SignedInNotLoggedIn,
            NotSignedinNotLoggedIn
        }

        private SigninStatus _signedInStatus = SigninStatus.NotSignedinNotLoggedIn;

        /// <summary>
        /// Returns the last error message
        /// </summary>
        public SigninStatus GetSigninStatus
        {
            get { return _signedInStatus; }
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="signInSystem">The sign in system to use</param>
        /// <param name="databaseConnectionDetails">The connection details to connecting to the database. Leave this null if you want
        /// to use the default connection strings</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public CallingUser(SignInSystem signInSystem, string databaseConnectionDetails, ICacheManager caching)
            : base(databaseConnectionDetails, caching)
        {
            _signInSystem = signInSystem;
        }

        /// <summary>
        /// Tries to sign the user in using their cookie.
        /// </summary>
        /// <param name="cookie">The users cookie to try and sign in with</param>
        /// <param name="policy">This is either the poilicy to use when using identity OR the service name to use with SSO</param>
        /// <param name="siteID">The id of the site you want to sign them into</param>
        /// <param name="identityUserName">The identity username if in identity mode. Found in the IDENTITY-NAME cookie</param>
        /// <returns>True if they are signed in, false if not</returns>
        public bool IsUserSignedIn(string cookie, string policy, int siteID, string identityUserName)
        {
            using (AuthenticateUser authernticatedUser = new AuthenticateUser(_signInSystem))
            {
                if (authernticatedUser.AuthenticateUserFromCookie(cookie, policy, identityUserName))
                {
                    // Check to see if the email is in the banned emails list
                    BannedEmails.BannedEmails emails = new BannedEmails.BannedEmails(_databaseConnectionDetails, _cachingObject);
                    string emailToCheck = authernticatedUser.Email;
                    if (emailToCheck.Length == 0 || !emails.IsEmailInBannedFromSignInList(emailToCheck))
                    {
                        // The users email is not in the banned list, get the rest of the details from the database
                        if (CreateUserFromSignInUserID(authernticatedUser.SignInUserID, authernticatedUser.LegacyUserID, _signInSystem, siteID, authernticatedUser.LoginName, authernticatedUser.Email, authernticatedUser.FirstName, authernticatedUser.LastNames, authernticatedUser.UserName))
                        {
                            _signedInStatus = SigninStatus.SignedInLoggedIn;
                            return true;
                        }
                    }
                }

                // Check to see if the user was signed in, but not logged in
                if (authernticatedUser.IsSignedIn && !authernticatedUser.IsLoggedIn)
                {
                    _signedInStatus = SigninStatus.SignedInNotLoggedIn;
                }
            }

            return false;
        }

        /// <summary>
        /// Synchronizes the users signin details with the database
        /// </summary>
        /// <returns>True if it synch'd, false if not</returns>
        public bool SynchronizeUserSigninDetails()
        {
            return true;
        }
    }
}
