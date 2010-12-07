using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "Submittable")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "SUBMITTABLE")]
    [DataContract(Name = "articleInfoSubmittable")]
    public partial class ArticleInfoSubmittable
    {
        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "REVIEWFORUM")]
        [DataMember(Name = "reviewForum")]
        public ReviewForum ReviewForum { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "FORUM")]
        [DataMember(Name = "forum")]
        public SubmittableForum Forum { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "THREAD")]
        [DataMember(Name = "thread")]
        public SubmittableThread Thread { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "POST")]
        [DataMember(Name = "post")]
        public SubmittablePost Post { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type")]
        public string Type { get; set; } 
        #endregion

        static public ArticleInfoSubmittable CreateSubmittable(IDnaDataReaderCreator readerCreator, int h2g2Id, bool isSubmittable)
        {
            ArticleInfoSubmittable submittable = new ArticleInfoSubmittable();
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchreviewforummemberdetails"))
            {
                reader.AddParameter("h2g2id", h2g2Id);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    
                    submittable.Forum = new SubmittableForum(){Id=reader.GetInt32("ForumID")};
                    submittable.Thread = new SubmittableThread() { Id = reader.GetInt32("ThreadID") };
                    submittable.Post = new SubmittablePost() { Id = reader.GetInt32("PostID") };
                    submittable.Type = "IN";
                    submittable.ReviewForum = ReviewForum.CreateFromDatabase(readerCreator, reader.GetInt32("ReviewForumID"), true);
                }
                else if (isSubmittable)
                {
                    submittable.Type = "YES";
                }
                else
                {
                    submittable.Type = "NO";
                }
            }
            return submittable;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "SubmittableFORUM")]
    [DataContract(Name = "submittableForum")]
    public partial class SubmittableForum
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        [DataMember(Name = "id")]
        public int Id { get; set; }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "SubmittableTHREAD")]
    [DataContract(Name = "submittableThread")]
    public partial class SubmittableThread
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        [DataMember(Name = "id")]
        public int Id { get; set; }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "SubmittablePOST")]
    [DataContract(Name = "submittablePost")]
    public partial class SubmittablePost
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        [DataMember(Name = "id")]
        public int Id
        {
            get;
            set;
        }
    }
}