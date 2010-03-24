using BBC.Dna.Data;
using System.Xml;
namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="ARTICLEINFO")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="ARTICLEINFO")]
    public partial class ArticleInfo
    {

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "STATUS")]
        public ArticleStatus Status
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "H2G2ID")]
        public int H2g2Id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        /// TODO: remove this element - its such a waste
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "SITE")]
        public ArticleInfoSite Site
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "SITEID")]
        public int SiteId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "MODERATIONSTATUS")]
        public ModerationStatus ModerationStatus
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "PAGEAUTHOR")]
        public ArticleInfoPageAuthor PageAuthor
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 7, ElementName = "DATECREATED")]
        public DateElement DateCreated
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 8, ElementName = "LASTUPDATED")]
        public DateElement LastUpdated
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 9, ElementName = "RELATEDMEMBERS")]
        public ArticleInfoRelatedMembers RelatedMembers
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 10, ElementName = "PREPROCESSED")]
        public int PreProcessed
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 11, ElementName = "CRUMBTRAILS")]
        public CrumbTrails CrumbTrails
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 12, ElementName = "REFERENCES")]
        public ArticleInfoReferences References
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 13, ElementName = "SUBMITTABLE")]
        public ArticleInfoSubmittable Submittable
        {
            get;
            set;
        }


        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="guideNode"></param>
        public void GetReferences(IDnaDataReaderCreator readerCreator, XmlNode guideNode)
        {
            References = ArticleInfoReferences.CreateArticleInfoReferences(readerCreator, guideNode);
        }

        /// <summary>
        /// This method reads in the entry form the database and sets up all the member fields
        /// </summary>
        /// <param name="safeToCache">A flag to state whether or not this entry is safe to cache. Usually set to false whhen an error occures.</param>
        /// <param name="failingGracefully">A flag that states whether or not this method is failing gracefully.</param>
        static public ArticleInfo GetEntryFromDataBase(int entryId, IDnaDataReader reader, IDnaDataReaderCreator readerCreator)
        {
            ArticleInfo articleInfo = null;
            // fetch all the lovely intellectual property from the database
            // Make sure we got something back
            if (reader.HasRows)
            {
                // Go though the results untill we get the main article
                do
                {
                    if (reader.GetInt32("IsMainArticle") == 1)
                    {
                        articleInfo = new ArticleInfo();
                        // Now start reading in all the values for the entry
                        articleInfo.H2g2Id = reader.GetInt32("h2g2ID");
                        articleInfo.ForumId = reader.GetInt32("ForumID");
                        articleInfo.ModerationStatus = new ModerationStatus()
                        {
                            Id = articleInfo.H2g2Id,
                            Value = reader.GetByteNullAsZero("ModerationStatus").ToString()
                        };

                        articleInfo.Status = ArticleStatus.GetStatus(reader.GetInt32("Status"));
                        articleInfo.DateCreated = new DateElement(reader.GetDateTime("DateCreated"));
                        articleInfo.LastUpdated = new DateElement(reader.GetDateTime("LastUpdated"));
                        articleInfo.PreProcessed = reader.GetInt32("PreProcessed");
                        articleInfo.SiteId = reader.GetInt32("SiteID");
                        articleInfo.Site = new ArticleInfoSite() { Id = articleInfo.SiteId };

                        //create children objects
                        articleInfo.PageAuthor = ArticleInfoPageAuthor.CreateListForArticle(articleInfo.H2g2Id, reader.GetInt32("Editor"), readerCreator);
                        articleInfo.RelatedMembers = ArticleInfoRelatedMembers.GetRelatedMembers(articleInfo.H2g2Id, readerCreator);
                        articleInfo.CrumbTrails = CrumbTrails.CreateArticleCrumbtrail(articleInfo.H2g2Id, readerCreator);
                        if (articleInfo.Status.Type == 3)
                        {//create Submittable if status = 3...
                            bool isSubmittable = (reader.GetTinyIntAsInt("Submittable")==1);
                            articleInfo.Submittable = ArticleInfoSubmittable.CreateSubmittable(readerCreator, articleInfo.H2g2Id, isSubmittable);
                        }
                        
                    }
                    if (articleInfo != null)
                    {
                        break;//got the info so run
                    }
                }
                while (reader.Read());
            }
            return articleInfo;
        }
    }

}
