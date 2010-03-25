using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using BBC.Dna.BannedEmails;
using BBC.Dna.Utils;
using DnaIdentityWebServiceProxy;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Sites;

namespace BBC.Dna.Users
{
    public class CallingUser : User, ICallingUser
    {
        SignInSystem _signInSystem = SignInSystem.Identity;

        public enum SigninStatus
        {
            SignedInLoggedIn,
            SignedInNotLoggedIn,
            NotSignedinNotLoggedIn
        }

        private SigninStatus _signedInStatus = SigninStatus.NotSignedinNotLoggedIn;
        private int _debugUserID = 0;
        private ISiteList _siteList = null;

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
        /// <param name="dnaDataReaderCreator">A DnaDataReaderCreator object for creating the procedure this class needs.
        /// If NULL, it uses the connection stringsfrom the configuration manager</param>
        /// <param name="dnaDiagnostics">A DnaDiagnostics object for logging purposes</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        /// <param name="siteList">A SiteList object for getting siteoption values</param>
        public CallingUser(SignInSystem signInSystem, IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, ISiteList siteList)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching)
        {
            _signInSystem = signInSystem;
            _siteList = siteList;
        }

        /// <summary>
        /// Debug constructor
        /// </summary>
        /// <param name="signInSystem">The sign in system to use</param>
        /// <param name="dnaDataReaderCreator">A DnaDataReaderCreator object for creating the procedure this class needs.
        /// If NULL, it uses the connection stringsfrom the configuration manager</param>
        /// <param name="dnaDiagnostics">A DnaDiagnostics object for logging purposes</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        /// <param name="debugUserID">A userid for debugging/testing purposes</param>
        /// <param name="siteList">A SiteList object for getting siteoption values</param>
        public CallingUser(SignInSystem signInSystem, IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, int debugUserID, ISiteList siteList)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching)
        {
            _signInSystem = signInSystem;
            _debugUserID = debugUserID;
            _siteList = siteList;
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
            if (_debugUserID > 0)
            {
                if (CreateUserFromDnaUserID(_debugUserID, siteID))
                {
                    _signedInStatus = SigninStatus.SignedInLoggedIn;
                    return true;
                }
            }
            else
            {
                using (AuthenticateUser authernticatedUser = new AuthenticateUser(_signInSystem))
                {
                    if (authernticatedUser.AuthenticateUserFromCookie(cookie, policy, identityUserName))
                    {
                        // Check to see if the email is in the banned emails list
                        BannedEmails.BannedEmails emails = new BannedEmails.BannedEmails(_dnaDataReaderCreator, _dnaDiagnostics, _cachingObject);
                        string emailToCheck = authernticatedUser.Email;
                        if (emailToCheck.Length == 0 || !emails.IsEmailInBannedFromSignInList(emailToCheck))
                        {
                            // The users email is not in the banned list, get the rest of the details from the database
                            if (CreateUserFromSignInUserID(authernticatedUser.SignInUserID, authernticatedUser.LegacyUserID, _signInSystem, siteID, authernticatedUser.LoginName, authernticatedUser.Email, authernticatedUser.UserName))
                            {
                                _signedInStatus = SigninStatus.SignedInLoggedIn;

                                // Check to see if we need to sync with the signin system details
                                if (authernticatedUser.LastUpdatedDate > LastSynchronisedDate)
                                {
                                    SynchronizeUserSigninDetails(authernticatedUser.UserName, authernticatedUser.Email, authernticatedUser.LoginName);
                                    if (_siteList.GetSiteOptionValueString(siteID, "User", "AutoGeneratedNames").Length > 0)
                                    {
                                        string siteSuffix = authernticatedUser.GetAutoGenNameFromSignInSystem(_siteList.GetSiteOptionValueBool(siteID, "General", "IsKidsSite"));
                                        SynchroniseSiteSuffix(siteSuffix);
                                    }
                                }

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

        public override int IdentityUserID
        {
            get { return base.IdentityUserID; }
        }
    }
}
