using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(TypeName = "ARTICLESUMMARY")]
    public class ArticleSummary
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "H2G2ID")]
        public int H2G2ID { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        public string Name { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "STRIPPEDNAME")]
        public string StrippedName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "EDITOR")]
        public UserElement Editor { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "STATUS")]
        public ArticleStatus Status { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "EXTRAINFO")]
        public XmlElement ExtraInfo { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "DATECREATED")]
        public DateElement DateCreated { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 7, ElementName = "LASTUPDATED")]
        public DateElement LastUpdated { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 8, ElementName = "REDIRECTNODEID")]
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
                        childArticle.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("DisplayName")); ;
                        childArticle.ExtraInfo = ExtraInfoCreator.CreateExtraInfo(reader.GetStringNullAsEmpty("extrainfo"));
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

    }
}
