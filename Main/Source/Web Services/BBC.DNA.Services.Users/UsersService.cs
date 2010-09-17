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



        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}")]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public Stream GetUserInfo(string sitename, string identityusername)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty).ToUpper();
            ISite site = GetSite(sitename);
            BBC.Dna.Users.User userInfo = new BBC.Dna.Users.User(readerCreator, dnaDiagnostic, cacheManager);
            bool foundUser = false;
            try
            {
                if (userNameType == "DNAUSERID")
                {
                    int dnaUserID = Convert.ToInt32(identityusername);
                    foundUser = userInfo.CreateUserFromDnaUserID(dnaUserID, site.SiteID);
                }
                else if (userNameType == "IDENTITYUSERID")
                {
                    foundUser = userInfo.CreateUserFromIdentityUserID(identityusername, site.SiteID);
                }
                else //identityusername
                {
                    foundUser = userInfo.CreateUserFromIdentityUserName(identityusername, site.SiteID);
                }

                if (!foundUser)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(userInfo);
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

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}/links")]
        [WebHelp(Comment = "Get a user's links")]
        [OperationContract]
        public Stream GetUsersLinks(string sitename, string identityusername)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            var showPrivate = QueryStringHelper.GetQueryParameterAsInt("showPrivate", 0);
            ISite site = GetSite(sitename);

            LinksList links;
            try
            {
                links = LinksList.CreateLinksList(cacheManager, 
                    readerCreator, 
                    null, 
                    identityusername, 
                    site.SiteID, 
                    startIndex, 
                    itemsPerPage,
                    showPrivate == 1 ? true : false, 
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(links);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/usersubscriptions")]
        [WebHelp(Comment = "Get a user's user subscriptions")]
        [OperationContract]
        public Stream GetUsersUserSubscriptions(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            UserSubscriptionsList userSubscriptionsList;
            try
            {
                userSubscriptionsList = UserSubscriptionsList.CreateUserSubscriptionsList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(userSubscriptionsList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/blockedusers")]
        [WebHelp(Comment = "Get a user's blocked users list")]
        [OperationContract]
        public Stream GetUsersBlockedUserSubscriptions(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            BlockedUserSubscriptionsList blockedUserSubscriptionsList;
            try
            {
                blockedUserSubscriptionsList = BlockedUserSubscriptionsList.CreateBlockedUserSubscriptionsList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(blockedUserSubscriptionsList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/subscribingusers")]
        [WebHelp(Comment = "Get a user's scribing users list")]
        [OperationContract]
        public Stream GetUsersSubscribingUsers(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            SubscribingUsersList subscribingUsersList;
            try
            {
                subscribingUsersList = SubscribingUsersList.CreateSubscribingUsersList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(subscribingUsersList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/articlesubscriptions")]
        [WebHelp(Comment = "Get a user's article subscriptions")]
        [OperationContract]
        public Stream GetUsersArticleSubscriptions(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            ArticleSubscriptionsList articleSubscriptionsList;
            try
            {
                articleSubscriptionsList = ArticleSubscriptionsList.CreateArticleSubscriptionsList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(articleSubscriptionsList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/linksubscriptions")]
        [WebHelp(Comment = "Get a user's article subscriptions")]
        [OperationContract]
        public Stream GetUsersLinkSubscriptions(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            var showPrivate = QueryStringHelper.GetQueryParameterAsBool("showprivate", false);

            ISite site = GetSite(sitename);

            LinkSubscriptionsList linkSubscriptionsList;
            try
            {
                linkSubscriptionsList = LinkSubscriptionsList.CreateLinkSubscriptionsList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    showPrivate,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(linkSubscriptionsList);
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}")]
        [WebHelp(Comment = "Get the given user's contributions in the format requested")]
        [OperationContract]
        public Stream GetUserContributions(string identityuserid)
        {
            return GetOutputStream(GetContributions(identityuserid, null, null));
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/type/{type}")]
        [WebHelp(Comment = "Get the given user's contributions for the specified type in the format requested")]
        [OperationContract]
        public Stream GetUserContributionsByType(string identityuserid, string type)
        {
            return GetOutputStream(GetContributions(identityuserid, null, type));
        }


        [WebGet(UriTemplate = "V1/recentcontributions/type/{type}")]
        [WebHelp(Comment = "Get the given user's contributions for the specified type in the format requested")]
        [OperationContract]
        public Stream GetRecentContributionsByType(string type)
        {
            return GetOutputStream(GetContributions(null, null, type));
        }

        [WebGet(UriTemplate = "V1/usercontributions/{identityuserid}/site/{site}")]
        [WebHelp(Comment = "Get the given user's contributions for the specified site in the format requested")]
        [OperationContract]
        public Stream GetUserContributionsBySite(string identityuserid, string site)
        {
            return GetOutputStream(GetContributions(identityuserid, site, null));
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/users")]
        [WebHelp(Comment = "Search the users in a given site")]
        [OperationContract]
        public Stream GetSearch(string siteName)
        {
            ISite site = Global.siteList.GetSite(siteName);
            var search = new Search();
            var querystring = QueryStringHelper.GetQueryParameterAsString("querystring", string.Empty);
            var showApproved = QueryStringHelper.GetQueryParameterAsInt("showapproved", 1);
            var showNormal = QueryStringHelper.GetQueryParameterAsInt("shownormal", 0);
            var showSubmitted = QueryStringHelper.GetQueryParameterAsInt("showsubmitted", 0);
            if (querystring != string.Empty)
            {
                search = Search.CreateSearch(cacheManager,
                                                readerCreator,
                                                site.SiteID,
                                                querystring,
                                                "USER",
                                                showApproved == 1 ? true : false,
                                                showNormal == 1 ? true : false,
                                                showSubmitted == 1 ? true : false);
            }
            return GetOutputStream(search);
        }






        private Contributions GetContributions(string identityuserid, string siteName, string siteType)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", "identityuserid").ToLower();

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
                userNameType,
                false);
        }

    }
}
