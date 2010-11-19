using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Objects;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class ArticleBuilder : DnaInputComponent
    {
        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public ArticleBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            IDnaDataReaderCreator creator = new DnaDataReaderCreator(AppContext.TheAppContext.Config.ConnectionString, 
                AppContext.TheAppContext.Diagnostics);

            ICacheManager cache = CacheFactory.GetCacheManager();
            int entryId = InputContext.GetParamIntOrZero("h2g2id", "Get the id of the article we want to view");

            //this is a clutch until we unify user objects
            BBC.Dna.Objects.User viewingUser = InputContext.ViewingUser.ConvertUser();

            //create article
            Article article = Article.CreateArticle(cache, creator, viewingUser, entryId, false, true);
            PageUi pageUi = PageUi.GetPageUi(creator, article, viewingUser); 

            // Check to see if the guideentry is deleted before adding the forum to the page
            if (!article.IsDeleted)
            {
                ArticleForum articleForum = new ArticleForum();
                if (article.ForumStyle == 1)
                {
                    // Get the posts for the forum
                    articleForum.ForumThreadPosts = ForumThreadPosts.CreateThreadPosts(creator, cache, viewingUser,
                        InputContext.TheSiteList, article.ArticleInfo.SiteId,article.ArticleInfo.ForumId, 0, 10, 0, 0, 
                        true,false, false);
                }
                else
                {
                    //get the threads for the article
                    articleForum.ForumThreads = ForumThreads.CreateForumThreads(cache, creator, InputContext.TheSiteList,
                        article.ArticleInfo.ForumId, 10, 0, 0, false, ThreadOrder.CreateDate, viewingUser, false);
                }
                if (articleForum != null)
                {
                    SerialiseAndAppend(articleForum, String.Empty);
                }
            }
            // Now add the guide to the article
            SerialiseAndAppend(pageUi, String.Empty);
            SerialiseAndAppend(article, String.Empty);
        }
    }
}

