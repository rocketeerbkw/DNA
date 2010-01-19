using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEINFORELATEDMEMBERS")]
    public partial class ArticleInfoRelatedMembers
    {
        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "RELATEDCLUBS")]
        public RelatedClubs RelatedClubs
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 1, ElementName = "RELATEDARTICLES")]
        [System.Xml.Serialization.XmlArrayItemAttribute("ARTICLEMEMBER", IsNullable = false)]
        public System.Collections.Generic.List<RelatedArticle> RelatedArticles
        {
            get;
            set;
        } 
        #endregion

        static public ArticleInfoRelatedMembers GetRelatedMembers(int h2g2Id, IDnaDataReaderCreator readerCreator)
        {
            ArticleInfoRelatedMembers members = new ArticleInfoRelatedMembers();
            members.RelatedArticles = RelatedArticle.GetRelatedArticles(h2g2Id, readerCreator);
            members.RelatedClubs = RelatedClubs.GetRelatedClubs(h2g2Id, readerCreator);
            return members;
        }
    }
}
