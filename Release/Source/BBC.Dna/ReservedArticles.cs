using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ReservedArticles Page object
    /// </summary>
    public class ReservedArticles : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the ReservedArticles component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ReservedArticles(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            TryCreateReservedArticlesXML();
        }

        /// <summary>
        /// Functions generates the Try Create Reserved Articles XML
        /// </summary>
        public void TryCreateReservedArticlesXML()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            if (!InputContext.ViewingUser.UserLoggedIn || InputContext.ViewingUser.UserID > 0)
            {
                AddErrorXml("1", "notregistered", RootElement);
                return;
            }

            int recordsCount = 20;

            XmlElement reservedArticles = AddElementTag(RootElement, "RESERVED-ARTICLES");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getreservedarticles"))
            {
                dataReader.AddParameter("userID", InputContext.ViewingUser.UserID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    do
                    {
                        XmlElement reservedArticle = AddElementTag(reservedArticles, "RESERVED-ARTICLE");
                        AddIntElement(reservedArticle, "H2G2ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                        AddTextTag(reservedArticle, "SUBJECT", dataReader.GetStringNullAsEmpty("Subject"));
                        recordsCount--;
                    } while (dataReader.Read() && recordsCount > 0);
                }
            }
        }
    }
}
