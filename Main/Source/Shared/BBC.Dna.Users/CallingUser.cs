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
        private bool _isSecureRequest = false;
        private int _debugUserID = 0;
        private ISiteList _siteList = null;

        /// <summary>
        /// Returns the sign in status
        /// </summary>
        public SigninStatus GetSigninStatus
        {
            get { return _signedInStatus; }
        }

        /// <summary>
        /// Returns the whether the user was signed in with a secure cookie
        /// </summary>
        public bool IsSecureRequest
        {
            get { return _isSecureRequest; }
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
            return IsUserSignedInSecure(cookie, "", policy, siteID);
        }
        /// <summary>
        /// Tries to sign the user in using their cookie.
        /// </summary>
        /// <param name="cookie">The users cookie to try and sign in with</param>
        /// <param name="secureCookie">The users secure cookie to try and sign in with</param>
        /// <param name="policy">This is either the poilicy to use when using identity OR the service name to use with SSO</param>
        /// <param name="siteID">The id of the site you want to sign them into</param>
        /// <returns>True if they are signed in, false if not</returns>
        public bool IsUserSignedInSecure(string cookie, string secureCookie, string policy, int siteID)
        {
            _isSecureRequest = false;
            if (_debugUserID > 0)
            {
                if (CreateUserFromDnaUserID(_debugUserID, siteID))
                {
                    _signedInStatus = SigninStatus.SignedInLoggedIn;
                    _isSecureRequest = true;
                    return true;
                }
            }
            else
            {
                using (AuthenticateUser authenticatedUser = new AuthenticateUser(_signInSystem))
                {
                    if (authenticatedUser.AuthenticateUserFromCookies(cookie, secureCookie, policy))
                    {
                        _isSecureRequest = authenticatedUser.IsSecureRequest;

                        // Check to see if the email is in the banned emails list
                        BannedEmails.BannedEmails emails = new BannedEmails.BannedEmails(_dnaDataReaderCreator, _dnaDiagnostics, _cachingObject);
                        string emailToCheck = authenticatedUser.Email;
                        if (emailToCheck.Length == 0 || !emails.IsEmailInBannedFromSignInList(emailToCheck))
                        {
                            // The users email is not in the banned list, get the rest of the details from the database
                            if (CreateUserFromSignInUserID(authenticatedUser.SignInUserID, authenticatedUser.LegacyUserID, _signInSystem, siteID, authenticatedUser.LoginName, authenticatedUser.Email, authenticatedUser.UserName))
                            {
                                _signedInStatus = SigninStatus.SignedInLoggedIn;

                                // Check to see if we need to sync with the signin system details
                                if (authenticatedUser.LastUpdatedDate > LastSynchronisedDate)
                                {
                                    SynchronizeUserSigninDetails(authenticatedUser.UserName, authenticatedUser.Email, authenticatedUser.LoginName);
                                    if (_siteList.GetSiteOptionValueString(siteID, "User", "AutoGeneratedNames").Length > 0)
                                    {
                                        string siteSuffix = authenticatedUser.GetAutoGenNameFromSignInSystem(_siteList.GetSiteOptionValueBool(siteID, "General", "IsKidsSite"));
                                        SynchroniseSiteSuffix(siteSuffix);
                                    }
                                }

                                return true;
                            }
                        }
                    }

                    // Check to see if the user was signed in, but not logged in
                    if (authenticatedUser.IsSignedIn && !authenticatedUser.IsLoggedIn)
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
