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
using BBC.Dna.Users;
using BBC.Dna.Utils;
using BBC.Dna.Api;
using System.Xml;
using BBC.Dna.Moderation.Utils;
using BBC.DNA.Moderation.Utils;
using System.Collections.Generic;
using BBC.Dna.Data;
using System.Linq;
using BBC.Dna.Common;


namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ArticleService : baseService
    {

        public ArticleService(): base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
        }


        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/create.htm")]
        [WebHelp(Comment = "Creates an article from Html form")]
        [OperationContract]
        public Article CreateArticleHtml(string siteName, NameValueCollection formsData)
        {
            try
            {
                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                int hiddenStatusAsInt = 0;
                if (!String.IsNullOrEmpty(formsData["hidden"])) { hiddenStatusAsInt = Convert.ToInt32(formsData["hidden"]); }

                Article article = BuildNewArticleObject(site.SiteID,
                    callingUser.UserID,
                    (GuideEntryStyle)Enum.Parse(typeof(GuideEntryStyle), formsData["style"]),
                    formsData["subject"],
                    formsData["guideML"],
                    formsData["submittable"],
                    hiddenStatusAsInt);

                return SaveArticle(site, callingUser, article, siteName, true, 0);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{siteName}/articles/create.htm/{h2g2id}")]
        [WebHelp(Comment = "Updates an article")]
        [OperationContract]
        public Article UpdateArticleHtml(string siteName, string h2g2id, NameValueCollection formsData)
        {
            try
            {
                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                // check H2g2Id is well formed
                int h2g2idAsInt = Convert.ToInt32(h2g2id);
                if (!Article.ValidateH2G2ID(h2g2idAsInt))
                {
                    throw ApiException.GetError(ErrorType.InvalidH2G2Id);
                }

                // load the original article
                Article article = Article.CreateArticle(cacheManager, readerCreator, callingUser, h2g2idAsInt, false);

                // assign the supplied parmss
                article = SetWritableArticleProperties(article,
                    (GuideEntryStyle)Enum.Parse(typeof(GuideEntryStyle),
                    formsData["style"]),
                    formsData["subject"],
                    formsData["guideML"],
                    formsData["researcherUserIds"]);

                if (formsData["hidden"] == "1" || formsData["hidden"] == "true")
                {
                    article.HiddenStatus = 1;
                }

                if (formsData["hidden"] == "0" || formsData["hidden"] == "false")
                {
                    article.HiddenStatus = 0;
                }

                if (article.ArticleInfo.Submittable != null && !String.IsNullOrEmpty(formsData["submittable"])  )
                {
                    if (formsData["submittable"].ToLower() == "yes" || formsData["submittable"] == "1")
                    {
                        article.ArticleInfo.Submittable.Type = "YES";
                    }
                    else
                    {
                        article.ArticleInfo.Submittable.Type = "NO";
                    }
                }

                return SaveArticle(site, callingUser, article, siteName, false, h2g2idAsInt);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles")]
        [WebHelp(Comment = "Creates an article")]
        [OperationContract]
        public Article CreateArticle(string siteName, Article inputArticle)
        {         
            try
            {
                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                // create the default article object graph
                Article article = BuildNewArticleObject(site.SiteID, 
                    callingUser.UserID,
                    inputArticle.Style,
                    inputArticle.Subject,
                    inputArticle.GuideMLAsString,
                    inputArticle.ArticleInfo.Submittable.Type,
                    inputArticle.HiddenStatus);    
            
                return SaveArticle(site, callingUser, article, siteName, true, 0);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/preview")]
        [WebHelp(Comment = "Previews an article")]
        [OperationContract]
        public Stream PreviewArticle(string siteName, Article inputArticle)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", true);

            try
            {
                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                // create the default article object graph
                Article article = BuildNewArticleObject(site.SiteID,
                    callingUser.UserID,
                    inputArticle.Style,
                    inputArticle.Subject,
                    inputArticle.GuideMLAsString,
                    inputArticle.ArticleInfo.Submittable.Type,
                    inputArticle.HiddenStatus);

                article.ApplySkinOnGuideML = applySkin;

                return GetOutputStream(article);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/preview/create.htm")]
        [WebHelp(Comment = "Previews an article from Html form")]
        [OperationContract]
        public Article PreviewArticleHtml(string siteName, NameValueCollection formsData)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", true);

            try
            {
                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                int hiddenStatusAsInt = 0;
                if (!String.IsNullOrEmpty(formsData["hidden"])) { hiddenStatusAsInt = Convert.ToInt32(formsData["hidden"]); }

                string guideML = formsData["guideML"];

                Article article = BuildNewArticleObject(site.SiteID,
                    callingUser.UserID,
                    (GuideEntryStyle)Enum.Parse(typeof(GuideEntryStyle), formsData["style"]),
                    formsData["subject"],
                    guideML,
                    formsData["submittable"],
                    hiddenStatusAsInt);

                article.ApplySkinOnGuideML = applySkin;

                string matchingProfanity = String.Empty;
                List<Term> terms = null;
                int forumID = 0;
                ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, article.Subject + " " + article.GuideMLAsString, out matchingProfanity, out terms, forumID);
                if (state == ProfanityFilter.FilterState.FailBlock)
                {
                    article.ProfanityTriggered = 1;
                    article.XmlError = "This message/Entry has been blocked as it contains a word which other users may find offensive. Please edit your message/Entry and post again.";
                }

                return article;
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/preview/create.htm/json")]
        [WebHelp(Comment = "Previews an article from Html form returns JSON")]
        [OperationContract]
        public Stream PreviewArticleHtmlReturnJSON(string siteName, NameValueCollection formsData)
        {
            return StringUtils.SerializeToJson(PreviewArticleHtml(siteName, formsData));
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{siteName}/articles/{h2g2id}")]
        [WebHelp(Comment = "Updates an article")]
        [OperationContract]
        public Article UpdateArticle(string siteName, string h2g2id, Article inputArticle)
        {
            try
            {

                ISite site = GetSite(siteName);

                CallingUser callingUser = GetCallingUser(site);

                // check H2g2Id is well formed
                int h2g2idAsInt = Convert.ToInt32(h2g2id);
                if (!Article.ValidateH2G2ID(h2g2idAsInt))
                {
                    throw ApiException.GetError(ErrorType.InvalidH2G2Id);
                }

                // load the original article
                Article article = Article.CreateArticle(cacheManager, readerCreator, callingUser, h2g2idAsInt, false);
  
                inputArticle = SetWritableArticleProperties(article,
                     inputArticle.Style,
                     inputArticle.Subject,
                     inputArticle.GuideMLAsString,
                     TryGetResearchersFrom(inputArticle));

                return SaveArticle(site, callingUser, article, siteName, false, h2g2idAsInt);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        private int[] TryGetResearchersFrom(Article theArticle)
        {
            int[] researchIds = new int[0];


            if (theArticle == null) { return null; }
            if (theArticle.ArticleInfo == null) { return null; }
            if (theArticle.ArticleInfo.PageAuthor == null) { return null; }
            if (theArticle.ArticleInfo.PageAuthor.Researchers == null) { return null; }
  
            researchIds = (from r in theArticle.ArticleInfo.PageAuthor.Researchers select r.UserId).ToArray<int>();

            return researchIds;
        }

        private Article BuildNewArticleObject(int siteId, int userid, GuideEntryStyle style, string subject, string guideML, string submittable, int hidden)
        {
            // validate the inputs. Has the required fields been supplied?
            if (String.IsNullOrEmpty(subject)) {  throw ApiException.GetError(ErrorType.MissingSubject); }
            if (String.IsNullOrEmpty(guideML)) {  throw ApiException.GetError(ErrorType.MissingGuideML); }
            
            // default submittable if it's not supplied
            if (String.IsNullOrEmpty(submittable))  { submittable = "YES";}

            Article article = new Article();
            article.ArticleInfo = new BBC.Dna.Objects.ArticleInfo();
            article.ArticleInfo.CatgoriesList = new List<CrumbTrail>();
            article.ArticleInfo.CrumbTrails = new CrumbTrails();
            article.ArticleInfo.CrumbTrails.CrumbTrail = new List<CrumbTrail>();
            article.ArticleInfo.DateCreated = new DateElement(DateTime.Now);
            article.ArticleInfo.ModerationStatus = BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus.Undefined;
            article.ArticleInfo.PageAuthor = new ArticleInfoPageAuthor();
            article.ArticleInfo.PageAuthor.Editor = new UserElement();
            article.ArticleInfo.PageAuthor.Editor.user = new BBC.Dna.Objects.User();
            article.ArticleInfo.RelatedMembers = new ArticleInfoRelatedMembers();
            article.ArticleInfo.Site = new ArticleInfoSite();
            article.ArticleInfo.Status = new ArticleStatus();
            article.ArticleInfo.Status.Value = "User entry, public";
            article.ArticleInfo.Status.Type = 3;
            article.Type = Article.ArticleType.Article;

            article.Style = style;
            article.Subject = subject;
            article.GuideMLAsString = guideML;

            article.ArticleInfo.CrumbTrails = new CrumbTrails();
            article.ArticleInfo.CrumbTrails.CrumbTrail = new List<CrumbTrail>();

            article.ArticleInfo.Site.Id = siteId;
            article.ArticleInfo.SiteId = siteId;
            article.ArticleInfo.PageAuthor.Editor.user.UserId = userid;
            article.ArticleInfo.Submittable = new ArticleInfoSubmittable();
            article.ArticleInfo.Submittable.Type = submittable;

            article.CanRead = 1;
            article.DefaultCanRead = 1;
            article.CanWrite = 0;
            article.DefaultCanWrite = 0;
            article.CanChangePermissions = 0;
            article.DefaultCanChangePermissions = 0;

            article.HiddenStatus = hidden;

            return article;
        }

        private Article SetWritableArticleProperties(Article article, GuideEntryStyle style, string subject, string guideML, string researcherUserIdsAsCSV)
        {
            int[] researchIds = new int[0];
            if (researcherUserIdsAsCSV != null)
            {
                // convert comma seperate string into array of ints
                researchIds = new List<string>(researcherUserIdsAsCSV.Split(',')).ConvertAll<int>(x => Convert.ToInt32(x)).ToArray<int>();
            }
            return SetWritableArticleProperties(article, style, subject, guideML,  researchIds);
        }

        private Article SetWritableArticleProperties(Article article, GuideEntryStyle style, string subject, string guideML,  List<BBC.Dna.Objects.User> researchersIdsAsCSV)
        {
            int[] researchIds = new int[0];
            if (researchersIdsAsCSV != null)
            {
                researchIds = (from r in researchersIdsAsCSV select r.UserId).ToArray<int>();
            }
            return SetWritableArticleProperties(article, style, subject, guideML,  researchIds);
        }

        private Article SetWritableArticleProperties(Article article, GuideEntryStyle style, string subject, string guideML,  int[] researcherUserIds)
        {
            //Need to set this before processing the guideML
            article.Style = style;

            // populate the writable parts of the object graph with the input article
            if (guideML != String.Empty)
            {
                article.GuideMLAsString = guideML;
                article.ArticleInfo.GetReferences(readerCreator, article.OriginalGuideMLAsXmlElement);
                
                if (!article.IsGuideMLWellFormed) 
                { 
                    article.XmlError = "GuideML is badly formed2";
                    throw new Exception("GuideML is badly formed"); 
                }
            }


            if (subject != String.Empty)
            {
                article.Subject = subject;
            }
            
            if (researcherUserIds != null)
            {
                article.ArticleInfo.PageAuthor.Researchers.Clear();
                foreach (int researcherId in researcherUserIds)
                {
                    BBC.Dna.Objects.User user = new BBC.Dna.Objects.User();
                    user.UserId = researcherId;
                    article.ArticleInfo.PageAuthor.Researchers.Add(user);
                }
            }

            return article;
        }


        private Article SaveArticle(ISite site, CallingUser callingUser, Article article, string siteName, bool isNewArticle, int h2g2Id)
        {
            // Check: does user have edit permission
            if ((!isNewArticle) && !article.HasEditPermission(callingUser))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.UserDoesNotHavePermissionToEditArticle));
            }

            // Check: profanities
            bool moderateProfanities = false;
            string matchingProfanity;
            List<Term> terms = null;
            CheckForProfanities(site, article.Subject + " " + article.GuideMLAsString, out moderateProfanities, out matchingProfanity, out terms);

            // Check: url filter
            if ((siteList.GetSiteOptionValueBool(site.SiteID, "General", "IsURLFiltered")) && !((callingUser.IsUserA(UserTypes.Editor) || callingUser.IsUserA(UserTypes.Notable))))
            {
                List<string> nonAllowedMatches = new List<string>();
                UrlFilter urlFilter = new UrlFilter();

                UrlFilter.FilterState result = urlFilter.CheckForURLs(article.Subject + " " + article.GuideMLAsString, nonAllowedMatches, site.SiteID, readerCreator);

                if (result == UrlFilter.FilterState.Fail)
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ArticleContainsURLs));
                }
            }

            // Check: email filter
            if ((siteList.GetSiteOptionValueBool(site.SiteID, "Forum", "EmailAddressFilter")) && !((callingUser.IsUserA(UserTypes.Editor) || callingUser.IsUserA(UserTypes.Notable))))
            {
                if (EmailAddressFilter.CheckForEmailAddresses(article.Subject + " " + article.GuideMLAsString))
                {
                    throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ArticleContainsEmailAddress));
                }
            }

            if (isNewArticle)
            {
                article.CreateNewArticle(cacheManager, readerCreator, callingUser.UserID, site.SiteID);

                //Users subscribed to this author should have their subscribed content updated.
                callingUser.UpdateUserSubscriptions(readerCreator, article.H2g2Id);

            }
            else // existing article
            {
                //Don't overwrite the existing editor of the article 
                int editorId = 0;
                try
                {
                     editorId = article.ArticleInfo.PageAuthor.Editor.user.UserId;
                    if (editorId == 0)
                    {
                        editorId = callingUser.UserID;
                    }
                }
                catch
                {
                    editorId = callingUser.UserID;
                }
                article.UpdateArticle(cacheManager, readerCreator, editorId);
            }

            // set the archive status
            if (callingUser.IsUserA(UserTypes.Editor))
            {
                article.SetArticleForumArchiveStatus(readerCreator, false);
            }


            // moderate isUserImmuneFromModeration needed
            bool isSiteModerated = !(site.ModerationStatus == BBC.Dna.Moderation.Utils.ModerationStatus.SiteStatus.UnMod);
            bool isUserModerated = (callingUser.IsPreModerated || callingUser.IsPostModerated);
            bool isArticleModerated = ((article.ArticleInfo.ModerationStatus == BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus.PreMod) || article.ArticleInfo.ModerationStatus == BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus.PostMod);
            bool isArticleInModeration = article.IsArticleIsInModeration(readerCreator);
            bool isUserInSinbin = (callingUser.IsAutoSinBin == 1);
            bool isUserImmuneFromModeration = callingUser.HasSpecialEditPermissions(article.H2g2Id);

            // Queue, update moderation status and hide the guide entry.
            int modID = 0;
            if (!isUserImmuneFromModeration)
            {
                if (isSiteModerated || isUserModerated || isArticleModerated || isArticleInModeration || moderateProfanities || isUserInSinbin)
                {
                    if (!String.IsNullOrEmpty(matchingProfanity)) { matchingProfanity = "Profanities: " + matchingProfanity; }

                    article.QueueForModeration(readerCreator, matchingProfanity, ref modID);

                }
            }


            if (article.HiddenStatus == (int)BBC.Dna.Moderation.Utils.CommentStatus.Hidden.NotHidden)
            {
                //visible
                article.UnhideArticle(readerCreator, 0, 0, callingUser.UserID);
            }
            else
            {
                // hidden
                article.HideArticle(readerCreator, 0, 0, callingUser.UserID);
            }

            
            article.UpdateResearchers(readerCreator);

            return article;
        }

        /// <summary>
        /// Updates all users who are subscribed to the current user
        /// </summary>
        /// <param name="h2g2ID">The h2g2ID of the article you want to check against</param>
        public void UpdateUserSubscriptions(IDnaDataReaderCreator readerCreator, int h2g2ID, ISite site)
        {         
            // Check to see if the current user accepts subscriptions
            if (GetCallingUser(site).AcceptSubscriptions)
            {
                // Update users subscriptions witht his new article
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addarticlesubscription"))
                {
                    reader.AddParameter("h2g2id", h2g2ID);
                    reader.Execute();
                }
            }
        }

        public void CheckForProfanities(ISite site, string text, out bool moderateProfanities, out string matchingProfanity, out List<Term> terms)
        {            
            moderateProfanities = false;
            int forumID = 0;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, text, out matchingProfanity, out terms, forumID);
            if (state == ProfanityFilter.FilterState.FailBlock)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.ProfanityFoundInText));
            }
            if (state == ProfanityFilter.FilterState.FailRefer)
            {
                moderateProfanities = true;
            }
        }


        [WebGet(UriTemplate = "V1/site/{siteName}/articles/{articleId}")]
        [WebHelp(Comment = "Get the given article for a given site")]
        [OperationContract]
        public Stream GetArticle(string siteName, string articleId)
        {
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", true);
            bool ignoreCache = QueryStringHelper.GetQueryParameterAsBool("ignorecache", false);

            ISite site = GetSite(siteName);

            CallingUser callingUser = null;
            try
            {
                callingUser = GetCallingUser(site);
            }
            catch (DnaWebProtocolException)
            {
                callingUser = null;
            }

            Article article;
            int actualId = 0;



            try
            {
                //if it's an int assume it's an articleId and get the article based on that
                if (Int32.TryParse(articleId, out actualId))
                {
                    article = Article.CreateArticle(cacheManager, readerCreator, callingUser, actualId, ignoreCache, applySkin);
                }
                else
                {
                    //if it's a string assume it's a named article and try to get the article by that
                    article = Article.CreateNamedArticle(cacheManager, readerCreator, callingUser, site.SiteID, articleId, ignoreCache, applySkin);
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(article);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/comingup")]
        [WebHelp(Comment = "Get the comingup article recommendations for a given site")]
        [OperationContract]
        public Stream GetComingUp(string siteName)
        {
            Recommendations recommendations = null;
            try
            {
                recommendations = Recommendations.CreateRecommendations(cacheManager, readerCreator);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(recommendations);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/random")]
        [WebHelp(Comment = "Gets a random article for a given site")]
        [OperationContract]
        public Stream GetRandomArticle(string siteName)
        {
            ISite site = GetSite(siteName);

            CallingUser callingUser = null;
            try
            {
                callingUser = GetCallingUser(site);
            }
            catch (DnaWebProtocolException)
            {
                callingUser = null;
            }

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

            var randomArticle = Article.CreateRandomArticle(cacheManager, readerCreator, callingUser, 
                                                            site.SiteID, status1, status2, status3, status4, status5, true);

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

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/solo")]
        [WebHelp(Comment = "Get the list of users with their number of solo guide entries for a given site")]
        [OperationContract]
        public Stream GetSoloGuideEntries(string siteName)
        {
            ISite site = GetSite(siteName);
            SoloGuideEntries solo = null;

            try
            {
                solo = SoloGuideEntries.CreateSoloGuideEntries(cacheManager, 
                                                                readerCreator, 
                                                                site.SiteID,
                                                                startIndex,
                                                                itemsPerPage,
                                                                false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(solo);
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles")]
        [WebHelp(Comment = "Search the articles in a given site")]
        [OperationContract]
        public Stream GetSearch(string siteName)
        {
            ISite site = Global.siteList.GetSite(siteName);
            var search = new Search();
            var querystring = QueryStringHelper.GetQueryParameterAsString("querystring", string.Empty);
            var showApproved = QueryStringHelper.GetQueryParameterAsInt("showapproved", 1);
            var showNormal = QueryStringHelper.GetQueryParameterAsInt("shownormal", 0);
            var showSubmitted = QueryStringHelper.GetQueryParameterAsInt("showsubmitted", 0);

            bool useFastSearch = false;
            if (siteList.GetSiteOptionValueBool(site.SiteID, "ArticleSearch", "FastFreetextSearch"))
            {
                useFastSearch = true;
            }

            if (querystring != string.Empty)
            {
                try
                {
                    search = Search.CreateSearch(cacheManager, 
                                                    readerCreator, 
                                                    site.SiteID, 
                                                    querystring, 
                                                    "ARTICLE", 
                                                    showApproved == 1 ? true : false,
                                                    showNormal == 1 ? true : false,
                                                    showSubmitted == 1 ? true : false,
                                                    startIndex,
                                                    itemsPerPage,
                                                    useFastSearch);
                }
                catch (ApiException ex)
                {
                    throw new DnaWebProtocolException(ex);
                }
            }
            return GetOutputStream(search);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/{articleId}/clip/")]
        [WebHelp(Comment = "Clips (Creates Link/Bookmark) the given article for a given site to your personal space")]
        [OperationContract]
        public void ClipArticle(string siteName, string articleId)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);


            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);            
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var article = Article.CreateArticle(cacheManager, readerCreator, callingUser, Int32.Parse(articleId), false, false);

            var isPrivate = QueryStringHelper.GetQueryParameterAsBool("private", false);

            try
            {
                Link.ClipPageToUserPage(cacheManager,
                                        readerCreator,
                                        callingUser,
                                        site.SiteID,
                                        "article",
                                        Int32.Parse(articleId),
                                        article.Subject,
                                        String.Empty,
                                        isPrivate);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }            
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/name/{articlename}")]
        [WebHelp(Comment = "Get the given article by articlename for a given site")]
        [OperationContract]
        public Stream GetNamedArticle(string siteName, string articlename)
        {          
            bool applySkin = QueryStringHelper.GetQueryParameterAsBool("applyskin", true);
            ISite site = GetSite(siteName);

            CallingUser callingUser = null;
            try
            {
                callingUser = GetCallingUser(site);
            }
            catch (DnaWebProtocolException)
            {
                callingUser = null;
            }


            Article article;
            try
            {
                article = Article.CreateNamedArticle(cacheManager, readerCreator, callingUser, site.SiteID, articlename, false, applySkin);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(article);
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/{articleId}/submitforreview/create.htm")]
        [WebHelp(Comment = "Submits the given article for a given site for review")]
        [OperationContract]
        public void SubmitArticleForReview(string siteName, string articleId, NameValueCollection formsData)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            if (callingUser == null || callingUser.UserID == 0)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }

            var article = Article.CreateArticle(cacheManager, readerCreator, callingUser, Int32.Parse(articleId), false, false);

            //Assume Peer Review reviewforumid 1
            int reviewForumId = 1;
            if (!String.IsNullOrEmpty(formsData["reviewforumid"])) 
            { 
                reviewForumId = Convert.ToInt32(formsData["reviewforumid"]); 
            }

            string comments = formsData["comments"];

            if (String.IsNullOrEmpty(comments))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.EmptyText));
            }

            if (article.ArticleInfo.Submittable.Type != "YES" && !callingUser.IsUserA(UserTypes.Editor))
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotForReview));
            }

            try
            {
                ReviewSubmission.SubmitArticle(readerCreator,
                                        callingUser.UserID,
                                        callingUser.UserName,
                                        site,
                                        Int32.Parse(articleId),
                                        article.Subject,
                                        article.ArticleInfo.PageAuthor.Editor.user.UserId,
                                        article.ArticleInfo.PageAuthor.Editor.user.UserName,
                                        reviewForumId,
                                        comments);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/articles/scoutrecommendations")]
        [WebHelp(Comment = "Get the scout recommendations of articles for a given site")]
        [OperationContract]
        public Stream GetScoutRecommendations(string siteName)
        {
            ISite site = GetSite(siteName);
            ScoutRecommendations scoutRecommendations = null;

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);
            //Only allow Scouts
            ScoutsOnly(callingUser);

            try
            {
                scoutRecommendations = ScoutRecommendations.CreateScoutRecommendations(cacheManager, 
                                                                                        readerCreator,
                                                                                        site.SiteID,
                                                                                        startIndex,
                                                                                        itemsPerPage,
                                                                                        false);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(scoutRecommendations);
        }
        
        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/{articleId}/scoutrecommends/create.htm")]
        [WebHelp(Comment = "Scout only function to recommend an article to the editors")]
        [OperationContract]
        public void ScoutRecommendsArticle(string siteName, string articleId, NameValueCollection formsData)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);
            string comments = formsData["comments"];

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);

            //Only allow Scouts
            ScoutsOnly(callingUser);

            try
            {                
                ScoutRecommendations.RecommendArticle(readerCreator,
                                        site,
                                        callingUser.UserID,
                                        callingUser.IsUserA(UserTypes.Editor),
                                        Int32.Parse(articleId),                                       
                                        comments);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/articles/{articleId}/submitsubbed/create.htm")]
        [WebHelp(Comment = "Sub Editor only function to return an article to the editors")]
        [OperationContract]
        public void SubmitSubbedArticle(string siteName, string articleId, NameValueCollection formsData)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);
            string comments = formsData["comments"];

            // Check 2) get the calling user             
            CallingUser callingUser = GetCallingUser(site);

            //Only allow SubEditors
            SubsOnly(callingUser);

            try
            {
                SubmitSubbedEntry.ReturnArticle(readerCreator,
                                        site,
                                        callingUser.UserID,
                                        callingUser.IsUserA(UserTypes.Editor),
                                        Int32.Parse(articleId),
                                        comments);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        private static void ScoutsOnly(CallingUser callingUser)
        {
            bool authorised = callingUser.IsUserA(UserTypes.Scout) || callingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || callingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser);

            if (!authorised)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }
        }

        private static void SubsOnly(CallingUser callingUser)
        {
            bool authorised = callingUser.IsUserA(UserTypes.SubEditor) || callingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || callingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser);

            if (!authorised)
            {
                throw new DnaWebProtocolException(ApiException.GetError(ErrorType.NotAuthorized));
            }
        }

        [WebGet(UriTemplate = "V1/site/{siteName}/info")]
        [WebHelp(Comment = "Gets statistics about the articles")]
        [OperationContract]
        public Stream GetSiteStatistics(string siteName)
        {
            // Check 1) get the site and check if it exists
            ISite site = GetSite(siteName);
            
            SiteStatistics stats = null;
            try
            {
               stats =  SiteStatistics.CreateSiteStatistics(readerCreator, site.SiteID);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }

            return GetOutputStream(stats);
        }

    }
}
