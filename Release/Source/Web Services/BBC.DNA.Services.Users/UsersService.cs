using System;
using System.Collections.Specialized;
using System.Configuration;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Api;
using System.Xml;
using BBC.Dna.Users;
using System.Runtime.Serialization;


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class UsersService : baseService
    {

        public UsersService() : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguser/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public CallingUser GetCallingUserInfoXML(string sitename)
        {
            return GetCallingUserInfo(sitename);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguser/json", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public CallingUser GetCallingUserInfoJSON(string sitename)
        {
            return GetCallingUserInfo(sitename);
        }

        private CallingUser GetCallingUserInfo(string sitename)
        {
            ISite site = GetSite(sitename);
            BBC.Dna.Users.CallingUser user;
            try
            {
                user = GetCallingUser(site);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return user;
        }


        //json
    }
}