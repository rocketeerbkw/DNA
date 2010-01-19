using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// The category Interface
    /// </summary>
    public interface ICategory
    {
        /// <summary>
        /// The include stripped names property
        /// </summary>
        bool IncludeStrippedNames { set; }

        /// <summary>
        /// The CreateArticleCrumbtrail Method
        /// </summary>
        /// <param name="h2g2ID">The ID Of the article you want to get the crumbtrails for.</param>
        void CreateArticleCrumbtrail(int h2g2ID);

        /// <summary>
        /// This methos gets the list of related clubs for a given article
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related clubs for</param>
        void GetRelatedClubs(int h2g2ID);

        /// <summary>
        /// This method gets all the related articles for a given article h2g2ID
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related articles for</param>
        void GetRelatedArticles(int h2g2ID);
    }
}
