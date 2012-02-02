using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Diagnostics;
using BBC.Dna.Api;
using BBC.Dna.SocialAPI;

namespace BBC.Dna.Users
{
    public class CallingTwitterUser : User, ICallingUser
    {
        public CallingTwitterUser(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching)
        {
        }

        public bool CreateUserFromTwitterUser(int siteID, TweetUser tweetUser)
        {
            if (tweetUser.id == null || tweetUser.id.Length == 0)
                throw new ArgumentException("Invalid twitterUserId parameter");

            if (siteID == 0)
                throw new ArgumentException("Invalid siteID parameter");

            TwitterUserID = tweetUser.id;
            if (base.CreateUserFromTwitterUserID(siteID, tweetUser))
            {
                //method for retrieving the twitter user groups
                GetUsersGroupsForSite();
                return true;
            }

            return false;
        }

        #region ICallingUser Members

        public bool IsUserSignedIn(string cookie, string policy, int siteID, string identityUserName, string ipAddress, Guid BBCUid)
        {
            throw new NotImplementedException();
        }

        public bool IsUserSignedInSecure(string cookie, string secureCookie, string policy, int siteID, string ipAddress, Guid BBCUid)
        {
            throw new NotImplementedException();
        }

        public bool IsSecureRequest
        {
            // BODGE ALERT!!!!!
            // We are assuming that tweets will be coming from a secure source, AKA Buzz API
            get { return true; }
        }

        #endregion
    }
}
