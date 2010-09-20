using System;
using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType=true, TypeName="ARTICLEINFO")]
    [XmlRootAttribute(Namespace="", IsNullable=false, ElementName="ARTICLEINFO")]
    [DataContract(Name = "articleInfo")]
    public class ArticleInfo
    {

        private BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus _moderationStatus;

        #region Properties
        /// <remarks/>
        [XmlElementAttribute(Order = 0, ElementName = "STATUS")]
        public ArticleStatus Status
        {
            get;
            set;
        }

        [XmlIgnore]
        [DataMember(Name = "status")]
        public string StatusValue
        {
            get 
            { 
                if (Status == null) { Status = new ArticleStatus(); }
                return Status.Value; 
            }
            set 
            {
                if (Status == null) { Status = new ArticleStatus(); }
                Status.Value = value;
            }
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 1, ElementName = "H2G2ID")]
        [DataMember(Name = "entryId")]
        public int H2g2Id
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 2, ElementName = "FORUMID")]
        [DataMember(Name = "forumId")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        /// TODO: remove this element - its such a waste
        [XmlElementAttribute(Order = 3, ElementName = "SITE")]
        public ArticleInfoSite Site
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 4, ElementName = "SITEID")]
        [DataMember(Name = "siteId")]
        public int SiteId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 5, ElementName = "MODERATIONSTATUS")]
        public string ModerationStatusAsString
        {
            get
            {
                return Enum.GetName(typeof(BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus), _moderationStatus);
            }
            set
            {
                _moderationStatus = (BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus)Enum.Parse(typeof(BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus), value);
            }
        }

        [XmlIgnore()]
        [DataMember(Name = "moderationStatus")]
        public BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus ModerationStatus
        {
            get { return _moderationStatus; }
            set { _moderationStatus = value; }
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 6, ElementName = "PAGEAUTHOR")]
        [DataMember(Name = "pageAuthor")]
        public ArticleInfoPageAuthor PageAuthor
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 7, ElementName = "DATECREATED")]
        [DataMember(Name = "dateCreated")]
        public DateElement DateCreated
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 8, ElementName = "LASTUPDATED")]
        [DataMember(Name = "lastUpdated")]
        public DateElement LastUpdated
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 9, ElementName = "RELATEDMEMBERS")]
        [DataMember(Name = "relatedMembers")]
        public ArticleInfoRelatedMembers RelatedMembers
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 10, ElementName = "PREPROCESSED")]
        [DataMember(Name = "preProcessed")]
        public int PreProcessed
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 11, ElementName = "CRUMBTRAILS")]
        public CrumbTrails CrumbTrails
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlIgnore]
        [DataMember(Name = "crumbTrails")]
        public List<CrumbTrail> CatgoriesList
        {
            get { return CrumbTrails.CrumbTrail; }
            set { }
        }
        

        /// <remarks/>
        [XmlElementAttribute(Order = 12, ElementName = "REFERENCES")]
        [DataMember(Name = "references")]
        public ArticleInfoReferences References
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 13, ElementName = "SUBMITTABLE")]
        [DataMember(Name = "submittable")]
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
                    if (reader.GetInt32("IsMainArticle") == 1 ) 
                    {
                        articleInfo = new ArticleInfo();
                        // Now start reading in all the values for the entry
                        articleInfo.H2g2Id = reader.GetInt32("h2g2ID");
                        articleInfo.ForumId = reader.GetInt32("ForumID");
                        articleInfo.ModerationStatus = (BBC.Dna.Moderation.Utils.ModerationStatus.ArticleStatus)reader.GetInt32NullAsZero("ModerationStatus");

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
