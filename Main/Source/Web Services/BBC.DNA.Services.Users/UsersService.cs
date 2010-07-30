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
using BBC.Dna.Site;


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
        [WebHelp(Comment = "Get the calling user's info in XML format")]
        [OperationContract]
        public CallingUser GetCallingUserInfoXML(string sitename)
        {
            return GetCallingUserInfo(sitename);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguser/json", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the calling user's info in JSON format")]
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

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/json", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the given user's contributions in JSON format")]
        [OperationContract]
        public Contributions GetContributionsJSON(string identityuserid)
        {
            return GetContributions(identityuserid, null, null);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the given user's contributions in XML format")]
        [OperationContract]
        public Contributions GetContributionsXML(string identityuserid)
        {
            return GetContributions(identityuserid, null, null);
        }


        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/type/{type}/json", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the given user's contributions for the specified type in JSON format")]
        [OperationContract]
        public Contributions GetContributionsByTypeJSON(string identityuserid, string type)
        {
            return GetContributions(identityuserid, null, type);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/type/{type}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the given user's contributions for the specified type in XML format")]
        [OperationContract]
        public Contributions GetContributionsByTypeXML(string identityuserid, string type)
        {
            return GetContributions(identityuserid, null, type);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/site/{site}/json", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the given user's contributions for the specified site in JSON format")]
        [OperationContract]
        public Contributions GetContributionsBySiteJSON(string identityuserid, string site)
        {
            return GetContributions(identityuserid, site, null);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/site/{site}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the given user's contributions for the specified site in XML format")]
        [OperationContract]
        public Contributions GetContributionsBySiteXML(string identityuserid, string site)
        {
            return GetContributions(identityuserid, site, null);
        }


        private Contributions GetContributions(string identityuserid, string siteName, string siteType)
        {
            SiteType? siteTypeAsEnum = null;
            if (!String.IsNullOrEmpty(siteType))
            {
                siteTypeAsEnum = (SiteType)Enum.Parse(typeof(SiteType), siteType);
            }

            return Contributions.GetUserContributions(cacheManager,
                readerCreator,
                siteName,
                Convert.ToInt32(identityuserid),
                itemsPerPage,
                startIndex,
                sortDirection,
                siteTypeAsEnum,
                false);
        }

    }
}