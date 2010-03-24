using System;
using System.Collections.Generic;
using System.Text;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// Container class to hold the current user info
    /// </summary>
    public class SSOUser
    {
        private string _userCoookie;
        private string _ssoUserName;
        private int _userId;
        private string _cudId;
        private bool _isUserSignedIn;
        private bool _isUserLoggedIn;
        private bool _hasUserAgreedTermsForService;
        private bool _hasUserAgreedGlobalTerms;
        private bool _isUsersAccountValid;
        private bool _isUserBanned;
        private bool _doesUserNeedToChangePassword;

        /// <summary>
        /// Users cookie property
        /// </summary>
        public string Usercookie
        {
            get { return _userCoookie; }
            set { _userCoookie = value; }
        }

        /// <summary>
        /// SSOUser name property
        /// </summary>
        public string SSOUserName
        {
            get { return _ssoUserName; }
            set { _ssoUserName = value; }
        }

        /// <summary>
        /// UserID property
        /// </summary>
        public int UserID
        {
            get { return _userId; }
            set { _userId = value; }
        }

        /// <summary>
        /// CudID property
        /// </summary>
        public string CudID
        {
            get { return _cudId; }
            set { _cudId = value; }
        }

        /// <summary>
        /// Is user logged in property
        /// </summary>
        public bool IsUserLoggedIn
        {
            get { return _isUserLoggedIn; }
            set { _isUserLoggedIn = value; }
        }

        /// <summary>
        /// Is user signed in property
        /// </summary>
        public bool IsUsersignedIn
        {
            get { return _isUserSignedIn; }
            set { _isUserSignedIn = value; }
        }

        /// <summary>
        /// Has user agreed terms for service property
        /// </summary>
        public bool HasUserAgreedTermsForService
        {
            get { return _hasUserAgreedTermsForService; }
            set { _hasUserAgreedTermsForService = value; }
        }

        /// <summary>
        /// Has user agreed global terms property
        /// </summary>
        public bool HasUserAgreedGlobalTerms
        {
            get { return _hasUserAgreedGlobalTerms; }
            set { _hasUserAgreedGlobalTerms = value; }
        }

        /// <summary>
        /// Is users account valid property
        /// </summary>
        public bool IsUsersAccountValid
        {
            get { return _isUsersAccountValid; }
            set { _isUsersAccountValid = value; }
        }

        /// <summary>
        /// Is user banned property
        /// </summary>
        public bool IsUserBanned
        {
            get { return _isUserBanned; }
            set { _isUserBanned = value; }
        }

        /// <summary>
        /// Does user need to change their password property
        /// </summary>
        public bool DoesUserNeedToChangepassword
        {
            get { return _doesUserNeedToChangePassword; }
            set { _doesUserNeedToChangePassword = value; }
        }

        /// <summary>
        /// Userd to reset all the user details back to initialised state
        /// </summary>
        public void ResetLoggedInDetails()
        {
            _ssoUserName = String.Empty;
            _isUserLoggedIn = false;
            _hasUserAgreedTermsForService = false;
            _hasUserAgreedGlobalTerms = false;
            _isUsersAccountValid = false;
        }

        /// <summary>
        /// Userd to reset all the user details back to initialised state
        /// </summary>
        public void ResetSignedInDetails()
        {
            _userCoookie = String.Empty;
            _cudId = String.Empty; ;
            _isUserSignedIn = false;
            _userId = 0;
        }

        /// <summary>
        /// Resets all the details for the user
        /// </summary>
        public void ResetAllDetails()
        {
            ResetSignedInDetails();
            ResetLoggedInDetails();
            _isUserBanned = false;
            _doesUserNeedToChangePassword = false;
        }
    }
}
