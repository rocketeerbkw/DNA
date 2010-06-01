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
    [XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEINFOPAGEAUTHOR")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "PAGEAUTHOR")]
    [DataContract (Name="pageAuthors")]
    public partial class ArticleInfoPageAuthor
    {
        public ArticleInfoPageAuthor()
        {
            Researchers = new List<User>();
        }

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 0, ElementName = "RESEARCHERS")]
        [System.Xml.Serialization.XmlArrayItemAttribute("USER", IsNullable = false)]
        [DataMember(Name = "researchers")]
        public System.Collections.Generic.List<User> Researchers
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "EDITOR")]
        [DataMember(Name = "editor")]
        public UserElement Editor
        {
            get;
            set;
        }
        #endregion

        static public ArticleInfoPageAuthor CreateListForArticle(int h2g2Id, int editorId, IDnaDataReaderCreator readerCreator)
        {

            ArticleInfoPageAuthor author = new ArticleInfoPageAuthor();
            
            // Create the datareader to get the authors
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getauthorsfromh2g2id"))
            {
                reader.AddParameter("h2g2ID", h2g2Id);
                reader.Execute();

                // Now go through all the results in turn
                int lastUserID = 0;
                while (reader.Read())
                {
                    // Get the current researcher
                    int researcherID = reader.GetInt32("UserID");
                    if (researcherID != lastUserID)
                    {
                        // Check to see if we've just got the editors results
                        User researcher = User.CreateUserFromReader(reader);
                        author.Researchers.Add(researcher);
                        if (researcherID == editorId)
                        {
                            author.Editor = new UserElement() { user = researcher };
                        }
                        lastUserID = researcherID;
                    }
                }
            }
            return author;
        }
    }
}
