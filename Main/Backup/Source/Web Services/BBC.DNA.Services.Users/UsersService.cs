using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using BBC.Dna.Api;
using BBC.Dna.Common;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class UsersService : baseService
    {
        public UsersService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguserfull")]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public Stream GetCallingUserInfoFull(string sitename)
        {
            var user = GetCallingUserInfoInternalFull(sitename);

            if (!user.IsSecureRequest)
            {
                throw new DnaWebProtocolException(new ApiException("Not authorised.", ErrorType.NotAuthorized));
            }

            return GetOutputStream(user);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/callinguser")]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public Stream GetCallingUserInfo(string sitename)
        {
            return AddCallingUserToOutputStream(GetCallingUserInfoInternal(sitename));
        }

        private Stream AddCallingUserToOutputStream(CallingUser user)
        {
            if (!user.IsSecureRequest)
            {
                user.IdentityUserID = "";
                user.TeamID = 0;
                user.TwitterUserID = "";
                user.IdentityUserName = "";
                user.LastSynchronisedDate = DateTime.Now;
            }

            return GetOutputStream(user);
        }

        private CallingUser GetCallingUserInfoInternal(string sitename)
        {
            var user = GetCallingUserInfoInternalFull(sitename);

            var userWithLessDetail = new CallingUser(SignInSystem.Identity, null, null,null,null, null);

            userWithLessDetail.UserID = user.UserID;
            userWithLessDetail.UserName = user.UserName;
            userWithLessDetail.UsersListOfGroups = user.UsersListOfGroups;
            userWithLessDetail.Status = user.Status;
            userWithLessDetail.SiteSuffix = user.SiteSuffix;
            
            return userWithLessDetail;
        }

        private CallingUser GetCallingUserInfoInternalFull(string sitename)
        {
            ISite site = GetSite(sitename);
            CallingUser user;
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

        private CallingUser TryGetCallingUserInfoInternal(string sitename)
        {
            ISite site = GetSite(sitename);

            return TryGetCallingUser(site);
        }

        [WebGet(UriTemplate = "V1/user/{useridentifier}/publicprofile")]
        [WebHelp(Comment = "Get a user's piblic profile details")]
        [OperationContract]
        public Stream GetUsersPublicProfile(string useridentifier)
        {
            var userIdentifierType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty).ToLower();

            return null;
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identityusername}")]
        [WebHelp(Comment = "Get a user's info")]
        [OperationContract]
        public Stream GetUserInfo(string sitename, string identityusername)
        {
            ISite site = GetSite(sitename);
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || !callingUser.IsSecureRequest)
            {
                throw new DnaWebProtocolException(new ApiException("Not authorised.", ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty).ToUpper();
            BBC.Dna.Users.User userInfo = new BBC.Dna.Users.User(readerCreator, dnaDiagnostic, cacheManager);
            bool foundUser = false;
            try
            {
                if (userNameType == "DNAUSERID")
                {
                    int dnaUserId = 0;
                    try
                    {
                        dnaUserId = Convert.ToInt32(identityusername);
                    }
                    catch (Exception)
                    {
                        throw ApiException.GetError(ErrorType.UserNotFound);
                    }
                    foundUser = userInfo.CreateUserFromDnaUserID(dnaUserId, site.SiteID);
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
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

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
                                                            userNameType.ToUpper() == "DNAUSERID",
                                                            false,
                                                            applySkin);
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
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", false);

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
                                                                false,
                                                                applySkin);
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
        [WebHelp(Comment = "Get a user's link subscriptions")]
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

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/friends")]
        [WebHelp(Comment = "Get a user's friends")]
        [OperationContract]
        public Stream GetUsersFriends(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            FriendsList friendsList;
            try
            {
                friendsList = FriendsList.CreateFriendsList(cacheManager,
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

            return GetOutputStream(friendsList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/followers")]
        [WebHelp(Comment = "Get a user's followers")]
        [OperationContract]
        public Stream GetUsersFollowers(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);

            FollowersList followersList;
            try
            {
                followersList = FollowersList.CreateFollowersList(cacheManager,
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

            return GetOutputStream(followersList);
        }

        [WebGet(UriTemplate = "V1/contributions/{threadentryid}")]
        [WebHelp(Comment = "Get the given contribution in the format requested")]
        [OperationContract]
        public Stream GetContribution(string threadentryid)
        {
            Contribution contribution;
            try
            {
                int threadEntryId = 0;
                Int32.TryParse(threadentryid, out threadEntryId);

                contribution = Contribution.CreateContribution(readerCreator,
                                                                    threadEntryId);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(contribution);
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

        [WebGet(UriTemplate = "V1/recentcontributions/site/{site}")]
        [WebHelp(Comment = "Get the contributions for the specified site in the format requested")]
        [OperationContract]
        public Stream GetRecentContributionsBySite(string site)
        {
            return GetOutputStream(GetContributions(null, site, null));
        }

        [WebGet(UriTemplate = "V1/recentcontributions/type/{type}")]
        [WebHelp(Comment = "Get the contributions for the specified type in the format requested")]
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
                try
                {
                    search = Search.CreateSearch(cacheManager,
                                                    readerCreator,
                                                    site.SiteID,
                                                    querystring,
                                                    "USER",
                                                    showApproved == 1 ? true : false,
                                                    showNormal == 1 ? true : false,
                                                    showSubmitted == 1 ? true : false,
                                                    startIndex,
                                                    itemsPerPage,
                                                    false);
                }
                catch (ApiException ex)
                {
                    throw new DnaWebProtocolException(ex);
                }
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

            try
            {
                return Contributions.GetUserContributions(cacheManager,
                    readerCreator,
                    siteName,
                    identityuserid,
                    itemsPerPage,
                    startIndex,
                    sortDirection,
                    siteTypeAsEnum,
                    userNameType,
                    false,
                    false,
                    null,
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/articles")]
        [WebHelp(Comment = "Get a user's articles")]
        [OperationContract]
        public Stream GetUsersArticles(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);
            var type = QueryStringHelper.GetQueryParameterAsString("type", "NormalAndApproved");
            ArticleList.ArticleListType articleListType = ArticleList.ArticleListType.NormalAndApproved;

            switch (type)
            {
                case "1":
                    articleListType = ArticleList.ArticleListType.Normal;
                    break;
                case "2":
                    articleListType = ArticleList.ArticleListType.Approved;
                    break;
                case "3":
                    articleListType = ArticleList.ArticleListType.Cancelled;
                    break;
                case "4":
                    articleListType = ArticleList.ArticleListType.NormalAndApproved;
                    break;
                case "normal":
                    articleListType = ArticleList.ArticleListType.Normal;
                    break;
                case "approved":
                    articleListType = ArticleList.ArticleListType.Approved;
                    break;
                case "cancelled":
                    articleListType = ArticleList.ArticleListType.Cancelled;
                    break;
                case "normalandapproved":
                    articleListType = ArticleList.ArticleListType.NormalAndApproved;
                    break;
                default:
                    try
                    {
                        articleListType = (ArticleList.ArticleListType)Enum.Parse(typeof(ArticleList.ArticleListType), type);
                    }
                    catch (Exception)
                    {
                        articleListType = ArticleList.ArticleListType.NormalAndApproved;
                    }
                    break;
            }
            ISite site = GetSite(sitename);

            ArticleList articleList;
            try
            {
                articleList = ArticleList.CreateUsersArticleList(cacheManager,
                    readerCreator,
                    null,
                    identifier,
                    site.SiteID,
                    startIndex,
                    itemsPerPage,
                    articleListType,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(articleList);
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/users/{identifier}/conversations")]
        [WebHelp(Comment = "Get a user's conversations")]
        [OperationContract]
        public Stream GetUsersConversations(string sitename, string identifier)
        {
            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            ISite site = GetSite(sitename);
            CallingUser callingUser = null;
            try
            {
                callingUser = GetCallingUser(site);
            }
            catch (DnaWebProtocolException)
            {
                callingUser = null;
            }

            PostList postList;
            try
            {
                postList = PostList.CreateUsersConversationList(cacheManager,
                    readerCreator,
                    callingUser,
                    site,
                    identifier,
                    startIndex,
                    itemsPerPage,
                    userNameType.ToUpper() == "DNAUSERID",
                    false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(postList);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/callinguser/userdetails/create.htm")]
        [WebHelp(Comment = "Update user details SSDN")]
        [OperationContract]
        public void UpdateUserDetails(string siteName, NameValueCollection formsData)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || callingUser.IsUserA(UserTypes.BannedUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            try
            {
                string siteSuffix = formsData["siteSuffix"];
                if (siteSuffix != callingUser.SiteSuffix)
                {
                    // Check to make sure the site suffix doesn't contain a profanity
                    string matchingProfanity;
                    List<Term> terms = null;
                    int forumID = 0;
                    ProfanityFilter.FilterState siteSuffixProfanity = ProfanityFilter.FilterState.Pass;
                    siteSuffixProfanity = ProfanityFilter.CheckForProfanities(site.ModClassID, siteSuffix, out matchingProfanity, out terms, forumID);
                    if (siteSuffixProfanity == ProfanityFilter.FilterState.FailBlock)
                    {
                        throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ProfanityFoundInText));
                    }
                    siteSuffix = siteSuffix.Trim();
                    if (siteSuffix.Length > 255)
                    {
                        siteSuffix = siteSuffix.Substring(0, 255);
                    }
                    //All ok update the calling Users Site Suffix
                    callingUser.SynchroniseSiteSuffix(siteSuffix);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/friends/{friend}/add")]
        [WebHelp(Comment = "Add a users friend")]
        [OperationContract]
        public void AddFriend(string siteName, string identifier, string friend)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int friendId = 0;
                Int32.TryParse(friend, out friendId);

                if (friendId > 0)
                {
                    FriendsList.AddFriend(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        friendId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/friends/{friend}/delete")]
        [WebHelp(Comment = "Remove a users friend")]
        [OperationContract]
        public void DeleteFriend(string siteName, string identifier, string friend)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int friendId = 0;
                Int32.TryParse(friend, out friendId);

                if (friendId > 0)
                {
                    FriendsList.DeleteFriend(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        friendId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }



        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/links/{link}/delete")]
        [WebHelp(Comment = "Remove a users link/bookmark")]
        [OperationContract]
        public void DeleteLink(string siteName, string identifier, string link)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int linkId = 0;
                Int32.TryParse(link, out linkId);

                if (linkId > 0)
                {
                    Link.DeleteLink(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        linkId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/usersubscriptions/{user}/unsubscribe")]
        [WebHelp(Comment = "Unsubscribe from a user")]
        [OperationContract]
        public void UnsubscribeFromUser(string siteName, string identifier, string user)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int userId = 0;
                Int32.TryParse(user, out userId);

                if (userId > 0)
                {
                    UserSubscriptionsList.UnsubscribeFromUser(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        userId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/usersubscriptions/{user}/subscribe")]
        [WebHelp(Comment = "Subscribe to a user")]
        [OperationContract]
        public void SubscribeToUser(string siteName, string identifier, string user)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int userId = 0;
                Int32.TryParse(user, out userId);

                if (userId > 0)
                {
                    UserSubscriptionsList.SubscribeToUser(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        userId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/blockedusers/{user}/unblock")]
        [WebHelp(Comment = "Unblock a user")]
        [OperationContract]
        public void UnblockUser(string siteName, string identifier, string user)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int userId = 0;
                Int32.TryParse(user, out userId);

                if (userId > 0)
                {
                    BlockedUserSubscriptionsList.UnblockUser(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        userId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/{identifier}/blockedusers/{user}/block")]
        [WebHelp(Comment = "Block a user")]
        [OperationContract]
        public void BlockUser(string siteName, string identifier, string user)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var userNameType = QueryStringHelper.GetQueryParameterAsString("idtype", string.Empty);

            try
            {
                int userId = 0;
                Int32.TryParse(user, out userId);

                if (userId > 0)
                {
                    BlockedUserSubscriptionsList.BlockUser(readerCreator,
                        callingUser,
                        identifier,
                        site.SiteID,
                        userId,
                        userNameType.ToUpper() == "DNAUSERID");
                }
                else
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.InvalidUserId));
                }

            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/callinguser/acceptsubscriptions/remove")]
        [WebHelp(Comment = "Sets the calling users AcceptSubscriptions to false. blocks subscriptions")]
        [OperationContract]
        public void BlockSubscriptions(string siteName)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || callingUser.IsUserA(UserTypes.BannedUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }
            callingUser.SynchroniseAcceptSubscriptions(false);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/users/callinguser/acceptsubscriptions")]
        [WebHelp(Comment = "Sets the calling users AcceptSubscriptions to true. accepts subscriptions")]
        [OperationContract]
        public void AcceptSubscriptions(string siteName)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0 || callingUser.IsUserA(UserTypes.BannedUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }
            callingUser.SynchroniseAcceptSubscriptions(true);
        }

    }
}
