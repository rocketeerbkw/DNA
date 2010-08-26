﻿using System;
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

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguser")]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public Stream GetCallingUserInfo(string sitename)
        {
            return GetOutputStream(GetCallingUserInfoInternal(sitename));
        }

        private CallingUser GetCallingUserInfoInternal(string sitename)
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

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}/aboutme")]
        [WebHelp(Comment = "Get a user's aboutme article")]
        [OperationContract]
        public Stream GetUsersAboutMeArticle(string sitename, string identityusername)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            ISite site = GetSite(sitename);

            Article article;
            try
            {
                if (userNameType.ToUpper() == "DNAUSERID")
                {
                    article = Article.CreateAboutMeArticleByDNAUserId(cacheManager, readerCreator, null, site.SiteID, Convert.ToInt32(identityusername));
                }
                else
                {
                    article = Article.CreateAboutMeArticle(cacheManager, readerCreator, null, site.SiteID, identityusername);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(article);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}/journal")]
        [WebHelp(Comment = "Get a user's journal forum")]
        [OperationContract]
        public Stream GetUsersJournal(string sitename, string identityusername)
        {
            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            ISite site = GetSite(sitename);

            ForumThreads journal;
            try
            {
                journal = ForumThreads.CreateUsersJournal(cacheManager, 
                                                            readerCreator, 
                                                            Global.siteList, 
                                                            identityusername,
                                                            site.SiteID,
                                                            itemsPerPage, 
                                                            startIndex, 
                                                            0, 
                                                            true, 
                                                            threadOrder, 
                                                            null,
                                                            userNameType.ToUpper()=="DNAUSERID",
                                                            false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(journal);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}/messages")]
        [WebHelp(Comment = "Get a user's messages forum")]
        [OperationContract]
        public Stream GetUsersMessages(string sitename, string identityusername)
        {
            ThreadOrder threadOrder = ThreadOrder.CreateDate;
            if (sortBy == SortBy.LastPosted)
            {
                threadOrder = ThreadOrder.LatestPost;
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            ISite site = GetSite(sitename);

            ForumThreads messages;
            try
            {
                Article article;
                if (userNameType.ToUpper() == "DNAUSERID")
                {
                    article = Article.CreateAboutMeArticleByDNAUserId(cacheManager, readerCreator, null, site.SiteID, Convert.ToInt32(identityusername));
                }
                else
                {
                    article = Article.CreateAboutMeArticle(cacheManager, readerCreator, null, site.SiteID, identityusername);
                }
                messages = ForumThreads.CreateForumThreads(cacheManager,
                                                                readerCreator,
                                                                Global.siteList,
                                                                article.ArticleInfo.ForumId,
                                                                itemsPerPage,
                                                                startIndex,
                                                                0,
                                                                true,
                                                                threadOrder,
                                                                null,
                                                                false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(messages);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}")]
        [WebHelp(Comment = "Get the given user's contributions in the format requested")]
        [OperationContract]
        public Stream GetContributions(string identityuserid)
        {
            return GetOutputStream(GetContributions(identityuserid, null, null));
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/type/{type}")]
        [WebHelp(Comment = "Get the given user's contributions for the specified type in the format requested")]
        [OperationContract]
        public Stream GetContributionsByType(string identityuserid, string type)
        {
            return GetOutputStream(GetContributions(identityuserid, null, type));
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/site/{site}")]
        [WebHelp(Comment = "Get the given user's contributions for the specified site in the format requested")]
        [OperationContract]
        public Stream GetContributionsBySite(string identityuserid, string site)
        {
            return GetOutputStream(GetContributions(identityuserid, site, null));
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
                identityuserid,
                itemsPerPage,
                startIndex,
                sortDirection,
                siteTypeAsEnum,
                false);
        }

    }
}
