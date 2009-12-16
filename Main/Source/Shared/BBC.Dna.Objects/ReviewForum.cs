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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "REVIEWFORUM")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "REVIEWFORUM")]
    public partial class ReviewForum
    {
        #region Properties

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "FORUMNAME")]
        public string ForumName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "URLFRIENDLYNAME")]
        public string UrlFriendlyName { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "RECOMMENDABLE")]
        public byte Recommendable { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "H2G2ID")]
        public int H2g2Id { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "SITEID")]
        public int SiteId { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "INCUBATETIME")]
        public int IncubateTime { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        public int Id { get; set; }
        
        #endregion

        static public ReviewForum CreateFromDatabase(IDnaDataReaderCreator readerCreator, int id, bool isReviewForumID)
        {
            ReviewForum forum = new ReviewForum()
            {
                Id = id
            };

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchreviewforumdetails"))
            {
                if (isReviewForumID)
                {
                    reader.AddParameter("reviewforumid", id);
                }
                else
                {
                    reader.AddParameter("h2g2id", id);
                }

                reader.Execute();
                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    forum.Id = reader.GetInt32NullAsZero("ReviewForumID");
                    forum.ForumName = reader.GetStringNullAsEmpty("forumname");
                    forum.UrlFriendlyName = reader.GetStringNullAsEmpty("urlfriendlyname");
                    forum.H2g2Id = reader.GetInt32NullAsZero("h2g2id");
                    forum.SiteId = reader.GetInt32NullAsZero("siteid");
                    forum.IncubateTime = reader.GetInt32NullAsZero("IncubateTime");
                    forum.Recommendable= reader.GetByteNullAsZero("recommend");
                }

            }

            return forum;
        }

    }
}
