using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;
using System.Runtime.Serialization;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "CATEGORY")]
    [DataContract(Name = "category")]
    public class Category : CachableBase<Category>
    {
        #region Properties
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName="DISPLAYNAME")]
        [DataMember (Name="displayName")]
        public string DisplayName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "DESCRIPTION")]
        [DataMember(Name = "description")]
        public string Description { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "SYNONYMS")]
        [DataMember(Name = "synonyms")]
        public string Synonyms { get; set; }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "H2G2ID")]
        [DataMember(Name = "h2g2id")]
        public int H2g2id { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 4, ElementName = "ANCESTRY")]
        [System.Xml.Serialization.XmlArrayItemAttribute("CATEGORYSUMMARY", IsNullable = false)]
        [DataMember(Name = "ancestry")]
        public System.Collections.Generic.List<CategorySummary> Ancestry { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "CHILDREN")]
        [DataMember(Name = "children")]
        public CategoryChildren Children { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "ARTICLE")]
        [DataMember(Name = "article")]
        public Article Article { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("NODEID")]
        [DataMember(Name = "nodeId")]
        public int NodeId { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("ISROOT")]
        [DataMember(Name = "isRoot")]
        public bool IsRoot { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("USERADD")]
        [DataMember(Name = "userAdd")]
        public int UserAdd { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("TYPE")]
        [DataMember(Name = "type")]
        public int Type { get; set; }

        /// <remarks/>        
        [System.Xml.Serialization.XmlIgnore()]
        public DateTime? LastUpdated { get; set; }

        public virtual bool ShouldSerializeAncestry()
        {
            return true;
        }

        #endregion

        /// <summary>
        /// Gets category from cache or db if not found in cache.
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="entryId"></param>
        /// <returns></returns>
        public static Category CreateCategory(ISite site, ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                             int nodeid, bool ignoreCache)
        {
            Category category = new Category();
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

            if (category == null)
            {
                throw ApiException.GetError(ErrorType.CategoryNotFound);
            }

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
                
                if (!reader.HasRows || !reader.Read())
                {
                }
                else
                {                    
                    category = new Category();
                    category.DisplayName = reader.GetStringNullAsEmpty("DisplayName");
                    category.Description = reader.GetStringNullAsEmpty("Description");
                    category.LastUpdated = reader.GetDateTime("LastUpdated");
                    category.Synonyms = reader.GetStringNullAsEmpty("synonyms");
                    category.H2g2id = reader.GetInt32NullAsZero("h2g2ID");
                    category.UserAdd = reader.GetTinyIntAsInt("userAdd");
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

                    category.Article = Article.CreateArticle(cache, readerCreator, viewingUser, category.H2g2id);
                    category.Ancestry = CategorySummary.GetCategoryAncestry(readerCreator, category.NodeId);
                    category.Children = new CategoryChildren();
                    category.Children.SubCategories = CategorySummary.GetChildCategories(readerCreator, category.NodeId);
                    category.Children.Articles = ArticleSummary.GetChildArticles(readerCreator, category.NodeId, site.SiteID);
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
