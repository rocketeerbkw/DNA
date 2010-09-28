using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEMEMBER")]
    [DataContract (Name="articleMember")]
    public partial class RelatedArticle
    {
        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "H2G2ID")]
        [DataMember (Name="entryId")]
        public int H2g2Id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        [DataMember(Name = "name")]
        public string Name
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "STRIPPEDNAME")]
        [DataMember(Name = "strippedName")]
        public string StrippedName
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "EDITOR")]
        [DataMember(Name = "editor")]
        public UserElement Editor
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "STATUS")]
        public ArticleStatus Status
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "TYPE")]
        [DataMember(Name = "type")]
        public Article.ArticleType Type
        {
            get;
            set;
        }  

        [XmlIgnore]
        [DataMember(Name = "status")]
        public string StatusValue
        {
            get { return Status.Value; }
            set { }
        }


      


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "DATECREATED")]
        [DataMember (Name="dateCreated")]
        public DateElement DateCreated
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 7, ElementName = "LASTUPDATED")]
        [DataMember (Name="lastUpdated")]
        public DateElement LastUpdated
        {
            get;
            set;
        } 
        #endregion

        /// <summary>
        /// This method gets all the related articles for a given article h2g2ID
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related articles for</param>
        static public List<RelatedArticle> GetRelatedArticles(int h2g2ID, IDnaDataReaderCreator readerCreator)
        {
            List<RelatedArticle> articles = new List<RelatedArticle>();
            // Create the datareader to get the articles
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getrelatedarticles"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.AddParameter("CurrentSiteID", 0);
                reader.Execute();

                // Add each article in turn
                while (reader.Read())
                {
                    RelatedArticle article = new RelatedArticle();
                    article.H2g2Id = h2g2ID;
                    article.Name = reader.GetString("Subject") ?? "";
                    article.StrippedName = StringUtils.StrippedName(article.Name);
                    article.Editor = new UserElement() { user = User.CreateUserFromReader(reader) };
                    article.Status = ArticleStatus.GetStatus(reader.GetInt32("Status"));
                    article.Type = Article.GetArticleTypeFromInt(reader.GetInt32NullAsZero("Type"));                    
                    ///TODO: work out what the hell is going on here...
                    //int articleType = reader.GetInt32("Type");
                    //int articleHidden = 0;
                    //if (reader.Exists("Hidden") && !reader.IsDBNull("Hidden"))
                    //{
                    //    articleHidden = reader.GetInt32("Hidden");
                    //}

                    if (reader.Exists("DateCreated"))
                    {
                        article.DateCreated = new DateElement(reader.GetDateTime("DateCreated"));
                    }
                    if (reader.Exists("Lastupdated"))
                    {
                        article.LastUpdated = new DateElement(reader.GetDateTime("Lastupdated"));
                    }

                    articles.Add(article);
                }
                return articles;
            }
        }

        /// <summary>
        /// This method gets the description for a given status value
        /// </summary>
        /// <param name="status">The status value you want to get the description for</param>
        /// <returns>The description for the given status value</returns>
        public static string GetDescriptionForStatusValue(int status)
        {
            // Get the description for the given status value
            string statusType = "";
            switch (status)
            {
                case 0: statusType = "No Status"; break;
                case 1: statusType = "Edited"; break;
                case 2: statusType = "User Entry, Private"; break;
                case 3: statusType = "User Entry, Public"; break;
                case 4: statusType = "Recommended"; break;
                case 5: statusType = "Locked by Editor"; break;
                case 6: statusType = "Awaiting Editing"; break;
                case 7: statusType = "Cancelled"; break;
                case 8: statusType = "User Entry, Staff-locked"; break;
                case 9: statusType = "Key Entry"; break;
                case 10: statusType = "General Page"; break;
                case 11: statusType = "Awaiting Rejection"; break;
                case 12: statusType = "Awaiting Decision"; break;
                case 13: statusType = "Awaiting Approval"; break;
                default: statusType = "Unknown"; break;
            }
            return statusType;
        }
    }
}
