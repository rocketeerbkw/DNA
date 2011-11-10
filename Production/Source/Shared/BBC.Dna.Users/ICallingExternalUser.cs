using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    /// <summary>
    /// Generic interface for external users, eg., twitter, facebook
    /// </summary>
    public interface ICallingExternalUser
    {
        string ExternalUserID { get; }
        ExternalUserTypes externalUserType { get; }

        string LoginName { get; }
        string DisplayName { get; }
        string SiteSuffix { get; }
        int Status { get; }
        bool IsExternalUser(UserTypes type);

        bool CreateExternalUserFromSignInUserID(string externalUserID, ExternalUserTypes externalUserType, int siteID, string loginName, string displayName);

    }
}
