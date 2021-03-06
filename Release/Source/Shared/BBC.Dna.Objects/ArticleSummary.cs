﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Runtime.Serialization;
using BBC.Dna.Objects;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(TypeName = "ARTICLESUMMARY")]
    [DataContract(Name = "articleSummary")]
    public class ArticleSummary
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "H2G2ID")]
        [DataMember(Name="h2g2id")]
        public int H2G2ID { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        [DataMember(Name = "name")]
        public string Name { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "STRIPPEDNAME")]
        [DataMember(Name = "strippedName")]
        public string StrippedName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "EDITOR")]
        [DataMember(Name = "editor")]
        public UserElement Editor { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "STATUS")]
        [DataMember(Name = "status")]
        public ArticleStatus Status { get; set; }


        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "TYPE")]
        [DataMember(Name = "type")]
        public Article.ArticleType Type
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "DATECREATED")]
        [DataMember(Name = "dateCreated")]
        public DateElement DateCreated { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 7, ElementName = "LASTUPDATED")]
        [DataMember(Name = "lastUpdated")]
        public DateElement LastUpdated { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 8, ElementName = "REDIRECTNODEID")]
        [DataMember(Name = "redirectNodeId")]
        public int RedirectNodeID { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("SORTORDER")]
        public int SortOrder { get; set; }




        public static List<ArticleSummary> GetChildArticles(IDnaDataReaderCreator readerCreator, int nodeID, int siteID)
        {
 
            List<ArticleSummary> childArticles = new List<ArticleSummary>();
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getarticlesinhierarchynode"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.AddParameter("currentsiteid", siteID);
                reader.Execute();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        ArticleSummary childArticle = new ArticleSummary();
                        childArticle.H2G2ID = reader.GetInt32NullAsZero("h2g2id");
                        childArticle.Name = reader.GetStringNullAsEmpty("subject");
                        childArticle.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("subject"));
                        childArticle.Type = Article.GetArticleTypeFromInt(reader.GetInt32NullAsZero("Type"));
                        childArticle.Editor = new UserElement() { user = User.CreateUserFromReader(reader, "editor")} ;
                        childArticle.DateCreated = new DateElement(reader.GetDateTime("datecreated"));
                        childArticle.LastUpdated = new DateElement(reader.GetDateTime("lastupdated")); ;
                        //childArticle.SortOrder = null;
                        childArticle.Status = ArticleStatus.GetStatus(reader.GetInt32NullAsZero("status"));
                        childArticles.Add(childArticle);
                    }
                }
            }
            return childArticles;
        }
        public static ArticleSummary CreateArticleSummaryFromReader(IDnaDataReader reader)
        {

            ArticleSummary articleSummary = new ArticleSummary();

            articleSummary.H2G2ID = reader.GetInt32NullAsZero("h2g2id");
            articleSummary.Name = reader.GetStringNullAsEmpty("subject");
            articleSummary.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("subject"));

            if (reader.DoesFieldExist("Type"))
            {
                articleSummary.Type = Article.GetArticleTypeFromInt(reader.GetInt32NullAsZero("Type"));
            }

            if (reader.DoesFieldExist("editor"))
            {
                articleSummary.Editor = new UserElement() { user = User.CreateUserFromReader(reader, "editor") };
            }
                        
            articleSummary.DateCreated = new DateElement(reader.GetDateTime("datecreated"));

            if (reader.DoesFieldExist("lastupdated"))
            {
                articleSummary.LastUpdated = new DateElement(reader.GetDateTime("lastupdated")); ;
            }

            articleSummary.Status = ArticleStatus.GetStatus(reader.GetInt32NullAsZero("status"));

            return articleSummary;
        }

    }
}
