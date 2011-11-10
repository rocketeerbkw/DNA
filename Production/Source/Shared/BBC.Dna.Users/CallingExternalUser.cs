using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using DnaIdentityWebServiceProxy;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using System.Runtime.Serialization;
using BBC.Dna.Moderation;
using System.Diagnostics;

namespace BBC.Dna.Users
{
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "")]
    [Serializable]
    [DataContract(Name = "externaluser")]
    public class CallingExternalUser : User, ICallingExternalUser
    {
        SignInSystem _signInSystem = SignInSystem.Identity;

        public enum SigninStatus
        {
            SignedInLoggedIn,
            SignedInNotLoggedIn,
            NotSignedinNotLoggedIn
        }

        private SigninStatus _signedInStatus = SigninStatus.NotSignedinNotLoggedIn;
        private ISiteList _siteList = null;
        private string _debugUserID = "";
        private string _twitterUserID = string.Empty;

        /// <summary>
        /// Returns the sign in status
        /// </summary>
        public SigninStatus GetSigninStatus
        {
            get { return _signedInStatus; }
        }

        public CallingExternalUser(SignInSystem signInSystem, IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, string debugUserID, ISiteList siteList)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching)
        {
            _signInSystem = signInSystem;
            _debugUserID = debugUserID;
            _siteList = siteList;
        }


        #region ICallingExternalUser Members


        public string LoginName
        {
            get { throw new NotImplementedException(); }
        }

        public string DisplayName
        {
            get { throw new NotImplementedException(); }
        }

        public bool IsExternalUser(UserTypes type)
        {
            throw new NotImplementedException();
        }


        public string ExternalUserID
        {
            get { throw new NotImplementedException(); }
        }

        public ExternalUserTypes externalUserType
        {
            get { throw new NotImplementedException(); }
        }

        public bool CreateExternalUserFromSignInUserID(string externalUserID, ExternalUserTypes externalUserType, int siteID, string loginName, string displayName)
        {
            bool userCreated = false;

            TwitterUserID = externalUserID;
            Trace.WriteLine("CreateExternalUserFromSignInUserID() - Using externalUserID");
            if (siteID != 0 && (false == string.IsNullOrEmpty(TwitterUserID)) && TwitterUserID.Length > 0)
            {
                if (externalUserType == ExternalUserTypes.TwitterUser)
                {
                    userCreated = base.CreateTweetUserFromSignInTwitterUserID(siteID, TwitterUserID, loginName, displayName);
                }
            }

            if (userCreated)
            {
                //method for retrieving the twitter user groups
                GetUsersGroupsForSite();
            }

            return userCreated;
        }


      

        #endregion

    }
}
