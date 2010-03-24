using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Net;
using BBC.Dna.Users;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Utils;

namespace BBC.Dna.Api
{
    public class Contributions
    {
        public static PostsData GetCommentsData(string userid, string siteid)
        {
            int itemsPerPage;
            int startIndex;
            SignInSystem signInType;
            int summaryLength;
            GetQueryParameters(out itemsPerPage, out startIndex, out signInType, out summaryLength);
            int signinUserId = int.Parse(userid);
/*
            CallingUser user = new CallingUser(signInType);
            if (user.Authenticated)
            {
                signinUserId = user.SignInUserID;
            }
*/            
            int dnaUserID;
            string userName;
            GetDnaUserFromSignInID(signInType, signinUserId, out dnaUserID, out userName);

            int pages = 0;
            
            PostsData postsData = new PostsData();
            postsData.User = new User();
            postsData.User.DisplayName = userName;
            postsData.User.UserId = signinUserId;
            postsData.ItemsPerPage = itemsPerPage;
            postsData.StartIndex = startIndex;
            postsData.Posts = new Posts();

            using (ContributionsEntities context = new ContributionsEntities())
            {
                try
                {
                    var posts = context.GetUsersComments(dnaUserID, siteid, startIndex, itemsPerPage);
                    foreach (var p in posts)
                    {
                        PostInfo pi = new PostInfo();
                        pi.Summary = StringUtils.GenerateSummaryFromText(p.Summary, summaryLength);
                        pi.Title = p.Title;
                        pi.uri = "http://www.bbc.co.uk" + p.Uri;
                        pi.Id = p.Id;

                        pi.Created = new DateTimeHelper(p.Created);
                        
                        pi.Host = new Host();
                        pi.Host.Id = p.HostId;
                        pi.Host.IsDna = true;
                        pi.Host.Uri = "http://www.bbc.co.uk" + p.HostUri;
                        pi.Host.UrlName = p.HostUrlName;
                        pi.Host.ShortName = p.HostShortName;
                        pi.Host.Description = p.HostDescription;

                        postsData.Posts.Add(pi);

                        pages = (int)Math.Ceiling((double)p.TotalResults / (double)itemsPerPage);
                        postsData.TotalResults = p.TotalResults;
                    }
                }
                catch (Exception ex)
                {
                    DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(HttpStatusCode.InternalServerError, ex.Message, ex);
                }

                postsData.Pages = pages;
            }

            return postsData;
        }

        public static ArticlesData GetArticlesData(string userid, string siteid)
        {
            int itemsPerPage;
            int startIndex;
            SignInSystem signInType;
            int summaryLength;
            GetQueryParameters(out itemsPerPage, out startIndex, out signInType, out summaryLength);

            int signinUserId = int.Parse(userid);
            int dnaUserID;
            string userName;
            GetDnaUserFromSignInID(signInType, signinUserId, out dnaUserID, out userName);

            int pages = 0;

            ArticlesData articlesData = new ArticlesData();
            articlesData.User = new User();
            articlesData.User.DisplayName = userName;
            articlesData.User.UserId = signinUserId;
            articlesData.ItemsPerPage = itemsPerPage;
            articlesData.StartIndex = startIndex;
            articlesData.Articles = new Articles();

            using (ContributionsEntities context = new ContributionsEntities())
            {
                try
                {
                    var articles = context.GetUserArticles(dnaUserID, siteid, startIndex, itemsPerPage);
                    foreach (var a in articles)
                    {
                        ArticleInfo ai = new ArticleInfo();
                        ai.Summary = StringUtils.GenerateSummaryFromText(a.Summary, summaryLength);
                        ai.Title = a.Title;
                        ai.uri = "http://www.bbc.co.uk" + a.Uri;
                        ai.Id = a.Id;

                        ai.Created = new DateTimeHelper(a.Created);
                        
                        ai.Updated = new DateTimeHelper(a.Created);
                       
                        ai.Posts = new PostsSummary();
                        ai.Posts.Total = a.PostsTotal;
                        ai.Posts.MostRecent = new DateTimeHelper(a.Created);
                        
                        ai.Host = new Host();
                        ai.Host.Id = a.HostId;
                        ai.Host.IsDna = true;
                        ai.Host.Uri = "http://www.bbc.co.uk" + a.HostUri;
                        ai.Host.UrlName = a.HostUrlName;
                        ai.Host.ShortName = a.HostShortName;
                        ai.Host.Description = a.HostDescription;

                        articlesData.Articles.Add(ai);

                        pages = (int)Math.Ceiling((double)a.TotalResults / (double)itemsPerPage);
                        articlesData.TotalResults = a.TotalResults;
                    }
                }
                catch (Exception ex)
                {
                    DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(HttpStatusCode.InternalServerError, ex.Message, ex);
                }

                articlesData.Pages = pages;
            }

            return articlesData;
        }   

        public static PostsData GetPostsData(string userid, string siteid)
        {
            int itemsPerPage;
            int startIndex;
            SignInSystem signInType;
            int summaryLength;
            GetQueryParameters(out itemsPerPage, out startIndex, out signInType, out summaryLength);

            int pages = 0;            

            int signinUserId = int.Parse(userid);
            int dnaUserID;
            string userName;
            GetDnaUserFromSignInID(signInType, signinUserId, out dnaUserID, out userName);

            PostsData postsData = new PostsData();
            postsData.User = new User();
            postsData.User.DisplayName = userName;
            postsData.User.UserId = signinUserId;
            postsData.ItemsPerPage = itemsPerPage;
            postsData.StartIndex = startIndex;
            postsData.Posts = new Posts();

            using (ContributionsEntities context = new ContributionsEntities())
            {
                try
                {
                    var posts = context.GetUsersPosts(dnaUserID, siteid, startIndex, itemsPerPage);
                    foreach (var p in posts)
                    {
                        postsData.TotalResults = p.TotalResults;
                        
                        if (p.Id == 0) 
                        {
                            break; 
                        }

                        PostInfo pi = new PostInfo();
                        pi.Created = new DateTimeHelper(p.Created);
                        pi.Host = new Host();

                        pi.Summary = StringUtils.GenerateSummaryFromText(p.Summary, summaryLength);
                        pi.Title = p.Title;
                        pi.uri = "http://www.bbc.co.uk" + p.Uri;
                        pi.Id = p.Id;
                                                                       
                        pi.Host.Id = p.HostId;
                        pi.Host.IsDna = true;
                        pi.Host.Uri = "http://www.bbc.co.uk" + p.HostUri;
                        pi.Host.UrlName = p.HostUrlName;
                        pi.Host.ShortName = p.HostShortName;
                        pi.Host.Description = p.HostDescription;

                        postsData.Posts.Add(pi);

                        pages = (int)Math.Ceiling((double)p.TotalResults / (double)itemsPerPage);
                        
                    }
                }
                catch (Exception ex)
                {
                    DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(HttpStatusCode.InternalServerError, ex.Message, ex);
                }

                postsData.Pages = pages;
            }

            return postsData;
        }

        /// <summary>
        /// Gets the dna userid from a given signin userid. Signin ID is either SSO or Identity
        /// </summary>
        /// <param name="signInType">The signin system used</param>
        /// <param name="signinUserId">The signin system user id</param>
        /// <param name="dnaUserID">The DNA UserID associated with the signin system user id</param>
        /// <param name="userName">The user name for the user</param>
        private static void GetDnaUserFromSignInID(SignInSystem signOnType, int signinUserId, out int dnaUserID, out string userName)
        {
            dnaUserID = 0;
            userName = "";
            using (ContributionsEntities context = new ContributionsEntities())
            {
                try
                {
                    if (signOnType == SignInSystem.Identity)
                    {
                        var user = context.getuserfromidentityid(signinUserId);
                        var u = user.First();
                        dnaUserID = u.Id;
                        userName = u.Name;
                    }
                    else
                    {
                        var user = context.getuserfromssouserid(signinUserId);
                        var u = user.First();
                        dnaUserID = u.Id;
                        userName = u.Name;
                    }
                }
                catch (Exception ex)
                {
                    DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(HttpStatusCode.InternalServerError, ex.Message, ex);
                    }
                }
            }

        /// <summary>
        /// Gets the query params for the given request
        /// </summary>
        /// <param name="itemsPerPage">Number of items the request wants to display</param>
        /// <param name="startIndex">The starting index to start looking from</param>
        /// <param name="signInType">The signin type. Identity or SSO</param>
        /// <param name="summaryLength">The length in chars that the request wants the summary to be</param>
        private static void GetQueryParameters(out int itemsPerPage, out int startIndex, out SignInSystem signOnType, out int summaryLength)
        {
            itemsPerPage = QueryStringHelper.GetQueryParameterAsInt("itemsPerPage", 20);
            startIndex = QueryStringHelper.GetQueryParameterAsInt("startIndex", 0);
            if (QueryStringHelper.GetQueryParameterAsString("signInType", "identity").CompareTo("identity") == 0)
            {
                signOnType = SignInSystem.Identity;
            }
            else
            {
                signOnType = SignInSystem.SSO;
            }
            summaryLength = QueryStringHelper.GetQueryParameterAsInt("summaryLength", 256);
        }
    }
}

