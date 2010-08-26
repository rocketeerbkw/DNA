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


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class CategoryService : baseService
    {

        public CategoryService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/categories/{categoryId}")]
        [WebHelp(Comment = "Get the given category for a given site")]
        [OperationContract]
        public Stream GetCategory(string siteName, string categoryId)
        {
            Category category = null;
            try
            {
                ISite site = GetSite(siteName);

                category = Category.CreateCategory(site, cacheManager, readerCreator, null, Int32.Parse(categoryId), false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }            
            return GetOutputStream(category);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/index")]
        [WebHelp(Comment = "Get the index for a given site")]
        [OperationContract]
        public Stream GetIndex(string siteName)
        {
            return GetIndexByLetter(siteName, "");
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/index/{letter}")]
        [WebHelp(Comment = "Get the index for a given site begining with the given letter")]
        [OperationContract]
        public Stream GetIndexByLetter(string siteName, string letter)
        {
            Index index = null;
            try
            {
                ISite site = GetSite(siteName);

                var showApproved = QueryStringHelper.GetQueryParameterAsInt("showApproved", 1);
                var showSubmitted = QueryStringHelper.GetQueryParameterAsInt("showSubmitted", 0);
                var showUnapproved = QueryStringHelper.GetQueryParameterAsInt("showUnapproved", 0);

                //	orderBy - A Variable to determine the ordering of the results.
                //	(Empty)		= Sort By Subject		= 0
                //	datecreated	= Sort by date created	= 1
                //	lastupdated	= Sort by last updated	= 2
                int orderBy = 0;
                string order = QueryStringHelper.GetQueryParameterAsString("orderby", "");
                if (order == "datecreated")
                {
                    orderBy = 1;
                }
                else if (order == "lastupdated")
                {
                    orderBy = 2;
                }
                index = Index.CreateIndex(cacheManager, 
                    readerCreator,
                    site.SiteID, 
                    letter,
                    showApproved == 1 ? true : false,
                    showSubmitted == 1 ? true : false,
                    showUnapproved == 1 ? true : false,
                    "",
                    orderBy,
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(index);
        }
    }
}