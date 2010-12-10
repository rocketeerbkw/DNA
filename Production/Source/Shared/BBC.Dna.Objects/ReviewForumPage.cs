using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using System.Runtime.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "REVIEWFORUMPAGE")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "REVIEWFORUMPAGE")]
    [DataContract(Name = "reviewForumPage")]
    public class ReviewForumPage : CachableBase<ReviewForumPage>
    {
        #region Properties

        [DataMember(Name = "reviewForum", Order = 1)]
        public ReviewForum ReviewForum { get; set; }

        [DataMember(Name = "reviewForumArticle", Order = 2)]
        public Article ReviewForumArticle { get; set; }

        [DataMember(Name = "reviewForumThreads", Order = 3)]
        public ForumThreads ReviewForumThreads { get; set; }

        #endregion


        /// <summary>
        /// Creates the review forum page from the cache or db
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        /// <param name="includeArticle"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ReviewForumPage CreateReviewForumPage(ICacheManager cache,
                                                    IDnaDataReaderCreator creator,
                                                    ISiteList siteList,
                                                    User viewingUser,
                                                    int reviewForumId,
                                                    int siteId,
                                                    bool includeArticle,
                                                    int itemsPerPage,
                                                    int startIndex,
                                                    ThreadOrder threadOrder,
                                                    bool ignoreCache,
                                                    bool applySkin)
        {
            var reviewForumPage = new ReviewForumPage();
            string key = reviewForumPage.GetCacheKey(reviewForumId, siteId, itemsPerPage, startIndex, threadOrder, applySkin);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                reviewForumPage = (ReviewForumPage)cache.GetData(key);
                if (reviewForumPage != null)
                {
                    //add article back to object
                    reviewForumPage.ReviewForumArticle = Article.CreateArticle(cache, creator, viewingUser, reviewForumPage.ReviewForum.H2g2Id, ignoreCache, applySkin);
                    reviewForumPage.ReviewForumThreads = ForumThreads.CreateForumThreads(cache, creator, siteList, reviewForumPage.ReviewForumArticle.ArticleInfo.ForumId, itemsPerPage, startIndex, 0, false, threadOrder, viewingUser, ignoreCache, applySkin);
                    return reviewForumPage;
                }
            }

            //create from db
            reviewForumPage.ReviewForum = ReviewForum.CreateFromDatabase(creator, reviewForumId, true);

            if (reviewForumPage != null)
            {
                //add to cache, first strip article as it is cached on its own
                var reviewForumPageCopy = (ReviewForumPage)reviewForumPage.Clone();
                reviewForumPageCopy.ReviewForumArticle = null;
                reviewForumPageCopy.ReviewForumThreads = null;
                cache.Add(key, reviewForumPageCopy, CacheItemPriority.Low, null, new SlidingTime(TimeSpan.FromMinutes(reviewForumPageCopy.CacheSlidingWindow())));
                reviewForumPage.ReviewForumArticle = Article.CreateArticle(cache, creator, viewingUser, reviewForumPage.ReviewForum.H2g2Id, ignoreCache, applySkin);
                reviewForumPage.ReviewForumThreads = ForumThreads.CreateForumThreads(cache, creator, siteList, reviewForumPage.ReviewForumArticle.ArticleInfo.ForumId, itemsPerPage, startIndex, 0, false, threadOrder, viewingUser, ignoreCache, applySkin);
            }

            return reviewForumPage;
        }
        /// <summary>
        /// Checks if the cache is up to date
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return false;
        }
    }
}
