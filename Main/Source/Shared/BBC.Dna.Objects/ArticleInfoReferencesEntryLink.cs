using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEINFOREFERENCESENTRYLINK")]
    [DataContract(Name = "entryLink")]
    public partial class ArticleInfoReferencesEntryLink
    {
        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "H2G2ID")]
        [DataMember(Name = "entryId")]
        public int H2g2Id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "H2G2")]
        public string H2g2
        {
            get;
            set;
        } 
        #endregion


        static public List<ArticleInfoReferencesEntryLink> CreateArticleReferences(List<int> articleIDs, IDnaDataReaderCreator readerCreator)
        {
            List<ArticleInfoReferencesEntryLink> entryLinks = new List<ArticleInfoReferencesEntryLink>();
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetcharticles"))
            {
                // Now add all the user References
                for (int i = 1; i < 90 && articleIDs.Count > 0; i++)
                {
                    reader.AddParameter("id" + i.ToString(), articleIDs[0]);
                    articleIDs.RemoveAt(0);
                }
                reader.Execute();

                while (reader.Read())
                {
                    ArticleInfoReferencesEntryLink link = new ArticleInfoReferencesEntryLink();
                    link.H2g2Id = reader.GetInt32("h2g2ID");
                    link.H2g2 = "A" + link.H2g2Id.ToString();
                    link.Subject = reader.GetString("Subject");
                    entryLinks.Add(link);
                }
            }
            return entryLinks;
        }
    }
    
   
}
