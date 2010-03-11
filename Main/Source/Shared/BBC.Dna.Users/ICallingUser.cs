using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    public interface ICallingUser
    {
        int UserID { get; }
        string UserName { get; }
        int Status { get; }
        bool IsUserA(UserTypes type);

        int IdentityUserID{ get;}

        bool IsUserSignedIn(string cookie, string policy, int siteID, string identityUserName);
        bool CreateUserFromDnaUserID(int userID, int siteID);
    }
}
