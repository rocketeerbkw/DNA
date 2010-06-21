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


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class CategoryService : baseService
    {

        public CategoryService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/categories/{categoryId}", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the given category in JSON format for a given site")]
        [OperationContract]
        public Category GetCategory(string siteName, string categoryId)
        {
            ISite site = Global.siteList.GetSite(siteName);
            var category = Category.CreateCategory(site, cacheManager, readerCreator, null, Int32.Parse(categoryId), false);
            return category;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/categories/{categoryId}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the given article in XML format for a given site")]
        [OperationContract]
        public Category GetCategoryXml(string siteName, string categoryId)
        {
            var category = GetCategory(siteName, categoryId);
            return category;
        }
    }
}