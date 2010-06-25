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

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/{articleId}", ResponseFormat = WebMessageFormat.Json)]
        [WebHelp(Comment = "Get the given article in JSON format for a given site")]
        [OperationContract]
        public Article GetArticle(string siteName, string articleId)
        {
            var article = Article.CreateArticle(cacheManager, readerCreator, null, Int32.Parse(articleId));
            //article.Guide = "";
            return article;
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/{articleId}/xml", ResponseFormat = WebMessageFormat.Xml)]
        [WebHelp(Comment = "Get the given article in XML format for a given site")]
        [OperationContract]
        public Article GetArticleXml(string siteName, string articleId)
        {
            var article = GetArticle(siteName, articleId);

            //return GetOutputStream(article);
            return article;


            //XmlDocument xmlDoc = new XmlDocument();
            //return StringUtils.SerializeToXml(article);//.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            //xmlDoc.LoadXml("<?xml version=\"1.0\" encoding=\"utf-8\"?>" + Entities.GetEntities() + xml);

            //return xmlDoc.DocumentElement;

        }

        

    }
}