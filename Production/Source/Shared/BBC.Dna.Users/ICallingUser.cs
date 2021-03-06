﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    public interface ICallingUser
    {
        int UserID { get; }
        string UserName { get; }
        string SiteSuffix { get; }
        int Status { get; }
        bool IsUserA(UserTypes type);

        string IdentityUserID{ get;}

        bool IsUserSignedIn(string cookie, string policy, int siteID, string identityUserName, string ipAddress, Guid BBCUid);
        bool IsUserSignedInSecure(string cookie, string secureCookie, string policy, int siteID, string ipAddress, Guid BBCUid);
        bool CreateUserFromDnaUserID(int userID, int siteID);
        bool IsTrustedUser();
        /// <summary>
        /// Get property that states whether or not the request is secure or not
        /// </summary>
        bool IsSecureRequest { get; }
    }
}
