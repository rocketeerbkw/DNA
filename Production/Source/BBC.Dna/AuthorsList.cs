using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// The authors list class
    /// </summary>
    public class AuthorsList : DnaInputComponent
    {
        /// <summary>
        /// Enumeration for the different types of articles
        /// </summary>
        public enum ArticleType
        {
            /// <summary>
            /// Basic article type
            /// </summary>
            ARTICLE,
            /// <summary>
            /// Edit form article
            /// </summary>
            ARTICLE_EDITFORM
        };

        private ArticleType _articleType;
        private int _h2g2ID;
        private int _editorID;

        /// <summary>
        /// Default constructor
        /// </summary>
        public AuthorsList(IInputContext context, ArticleType articleType, int h2g2ID, int editorID) : base(context)
        {
            _articleType = articleType;
            _h2g2ID = h2g2ID;
            _editorID = editorID;
        }

        /// <summary>
        /// This method creates the list of authors for the given article
        /// </summary>
        public void CreateListForArticle()
        {
            // Create the base node
            XmlNode researchesNode = AddElementTag(RootElement, "RESEARCHERS");

            // Create the datareader to get the authors
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getauthorsfromh2g2id"))
            {
                reader.AddParameter("h2g2ID", _h2g2ID);
                reader.Execute();

                // Now go through all the results in turn
                int lastUserID = 0;
                while (reader.Read())
                {
                    // Get the current researcher
                    int researcherID = reader.GetInt32("UserID");
                    if (researcherID != lastUserID)
                    {
                        XmlNode researcherNode = researchesNode;

                        // Check to see if we've just got the editors results
                        if (researcherID == _editorID)
                        {
                            researcherNode = AddElementTag(RootElement, "EDITOR");
                        }

                        User articleEditor = new User(InputContext);
                        articleEditor.AddUserXMLBlock(reader, reader.GetInt32("UserID"), researcherNode);

                        lastUserID = researcherID;
                    }
                }
            }
        }
    }
}
