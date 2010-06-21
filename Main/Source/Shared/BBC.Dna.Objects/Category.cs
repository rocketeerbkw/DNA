using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "CATEGORY")]
    public class Category : CachableBase<Category>
    {
        #region Properties
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName="DISPLAYNAME")]
        public string DisplayName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "DESCRIPTION")]
        public string Description { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "SYNONYMS")]
        public string Synonyms { get; set; }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "H2G2ID")]
        public int H2g2id { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 4, ElementName = "ANCESTRY")]
        [System.Xml.Serialization.XmlArrayItemAttribute("CATEGORYSUMMARY", IsNullable = false)]
        public System.Collections.Generic.List<CategorySummary> Ancestry { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "CHILDREN")]
        public CategoryChildren Children { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "ARTICLE")]
        public Article Article { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("NODEID")]
        public int NodeId { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("ISROOT")]
        public bool IsRoot { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("USERADD")]
        public int UserAdd { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("TYPE")]
        public int Type { get; set; }

        /// <remarks/>        
        public DateTime? LastUpdated { get; set; }

        public virtual bool ShouldSerializeAncestry()
        {
            return true;
        }

        #endregion

        /// <summary>
        /// Gets category from cache or db if not found in cache.
        /// All child instances such as CategorySummary, Article and ArticleSummary are cached as part of the Category object.
        /// Eg an existing version of an Article may already exist in the Article cache, but a seperate instance will always be used for Category.Article.
        /// The reason for this is to reduce the complexity involved with invalidating isntances acrosss objects.
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="entryId"></param>
        /// <returns></returns>
        public static Category CreateCategory(ISite site, ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                             int nodeid, bool ignoreCache)
        {
            var category = new Category();

            string key = category.GetCacheKey(nodeid);

            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                category = (Category)cache.GetData(key);
                if (category != null)
                {
                    //check if still valid with db...
                    if (category.IsUpToDate(readerCreator))
                    {
                        //all good
                        return category;
                    }
                }
            }

            //create from db
            category = CreateCategoryFromDatabase(site, cache, readerCreator, viewingUser, nodeid);

            //add to cache
            cache.Add(key, category);

            return category;
        }

        /// <summary>
        /// Creates the category from db using the given nodeid.
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="entryId"></param>
        /// <returns></returns>
        public static Category CreateCategoryFromDatabase(ISite site, ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser, int nodeid)
        {
            Category category = null;

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("gethierarchynodedetails2"))
            {
                // Add the entry id and execute
                reader.AddParameter("nodeid", nodeid);
                reader.Execute();
                
                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw new Exception("Category not found");
                }
                else
                {                    
                    category = new Category();
                    category.DisplayName = reader.GetStringNullAsEmpty("DisplayName");
                    category.Description = reader.GetStringNullAsEmpty("Description");
                    category.LastUpdated = reader.GetDateTime("LastUpdated");
                    category.Synonyms = reader.GetStringNullAsEmpty("synonyms");
                    category.H2g2id = reader.GetInt32NullAsZero("h2g2ID");
                    category.UserAdd = reader.GetInt32NullAsZero("userAdd");
                    category.Type = reader.GetInt32NullAsZero("type");
                    category.NodeId = reader.GetInt32NullAsZero("nodeID");
                    if (reader.GetInt32NullAsZero("ParentID") == 0)
                    {
                        category.IsRoot = true;
                    }
                    else
                    {
                        category.IsRoot = false;
                    }

                    //DO NOT reuse the article cache or any other cache for child properties
                    category.Article = Article.CreateArticle(cache, readerCreator, viewingUser, category.H2g2id);
                    category.Ancestry = CategorySummary.GetCategoryAncestry(readerCreator, category.NodeId);
                    category.Children = new CategoryChildren();
                    category.Children.SubCategories = CategorySummary.GetChildCategories(readerCreator, category.NodeId);
                    category.Children.Articles = ArticleSummary.GetChildArticles(readerCreator, category.NodeId, site.SiteID);
                }

                //not created so scream
                if (category == null)
                {
                    throw new Exception("Category not found");
                }
            }
            return category;
        }

        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            DateTime lastUpdateInDB = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetcategory"))
            {
                reader.AddParameter("nodeid", NodeId);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    lastUpdateInDB = reader.GetDateTime("LastUpdated");
                }
            }

            // true if the DB date is same or older than the object date
            return (lastUpdateInDB <= LastUpdated);
        }

    }
}
