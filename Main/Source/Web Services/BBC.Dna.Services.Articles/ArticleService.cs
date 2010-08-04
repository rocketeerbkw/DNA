
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
    public class ArticleService : baseService
    {

        public ArticleService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/{articleId}")]
        [WebHelp(Comment = "Get the given article for a given site")]
        [OperationContract]
        public Stream GetArticle(string siteName, string articleId)
        {
            var article = Article.CreateArticle(cacheManager, readerCreator, null, Int32.Parse(articleId));

            return GetOutputStream(article);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/comingup")]
        [WebHelp(Comment = "Get the comingup article recommendations for a given site")]
        [OperationContract]
        public Stream GetComingUp(string siteName)
        {
            var recommendations = Recommendations.CreateRecommendations(cacheManager, readerCreator);

            return GetOutputStream(recommendations);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/random")]
        [WebHelp(Comment = "Gets a random article for a given site")]
        [OperationContract]
        public Stream GetRandomArticle(string siteName)
        {
            ISite site = GetSite(siteName);
            var randomType = QueryStringHelper.GetQueryParameterAsString("type", string.Empty);
            int status1 = 1;
            int status2 = -1;
            int status3 = -1;
            int status4 = -1;
            int status5 = -1;

            // create a random entry selection depending on the type specified in the request
			if (randomType == "Edited")
			{
				status1 = 1;
			}
			else if (randomType == "Recommended")
			{
				status1 = 4;
			}
			else if (randomType == "Any")
			{
                status1 = 1;
                status2 = 3;
                status3 = 4;				
			}
			else
			{
				status1 = 3;
			}

            var randomArticle = Article.CreateRandomArticle(cacheManager, readerCreator, null, 
                                                            site.SiteID, status1, status2, status3, status4, status5);

            return GetOutputStream(randomArticle);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/month")]
        [WebHelp(Comment = "Get the month summary of articles for a given site")]
        [OperationContract]
        public Stream GetMonthSummary(string siteName)
        {
            ISite site = GetSite(siteName);
            MonthSummary monthSummary = null;

            try
            {
                monthSummary = MonthSummary.CreateMonthSummary(cacheManager, readerCreator, site.SiteID);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }            

            return GetOutputStream(monthSummary);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles")]
        [WebHelp(Comment = "Search the articles in a given site")]
        [OperationContract]
        public Stream GetSearch(string siteName)
        {
            ISite site = Global.siteList.GetSite(siteName);
            var search = new Search();
            var querystring = QueryStringHelper.GetQueryParameterAsString("querystring", string.Empty);
            var searchType = QueryStringHelper.GetQueryParameterAsString("type", string.Empty);
            var showApproved = QueryStringHelper.GetQueryParameterAsInt("showapproved", 1);
            var showNormal = QueryStringHelper.GetQueryParameterAsInt("shownormal", 0);
            var showSubmitted = QueryStringHelper.GetQueryParameterAsInt("showsubmitted", 0);
            if (querystring != string.Empty)
            {
                search = Search.CreateSearch(cacheManager, 
                                                readerCreator, 
                                                site.SiteID, 
                                                querystring, 
                                                searchType, 
                                                showApproved == 1 ? true : false,
                                                showNormal == 1 ? true : false,
                                                showSubmitted == 1 ? true : false);
            }
            return GetOutputStream(search);
        }
    }
}