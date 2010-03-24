using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// ArticleHistory - A derived DnaComponent object
    /// </summary>
    public class ArticleHistory : DnaInputComponent
    {
        private const string _docDnaEntryID = @"Entry ID to search for.";

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the ArticleHistory component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ArticleHistory(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();

            TryGetArticleHistory();
        }
        /// <summary>
        /// Method called to try and create Article History, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        private void TryGetArticleHistory()
        {
            int entryID = 0;

            TryGetPageParams(ref entryID);

            GenerateArticleHistoryXml(entryID);
        }

        /// <summary>
        /// Function to get the XML representation of the Article History results
        /// </summary>
        /// <param name="entryID">entryID to search for.</param>
        public void GetArticleHistoryXml(int entryID)
        {
            GenerateArticleHistoryXml(entryID);
        }

        /// <summary>
        /// Try to gets the params for the page
        /// </summary>
        /// <param name="entryID">entry ID to search for.</param>
        private void TryGetPageParams(ref int entryID)
        {
            entryID = InputContext.GetParamIntOrZero("entryid", _docDnaEntryID);
        }

        /// <summary>
        /// Calls the correct stored procedure given the inputs selected
        /// </summary>
        /// <param name="entryID">entry ID to search for.</param>
        private void GenerateArticleHistoryXml(int entryID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchedithistory"))
            {
                dataReader.AddParameter("entryid", entryID);
                dataReader.Execute();

                GenerateArticleHistoryXml(dataReader, entryID);
            }
        }

        /// <summary>
        /// With the returned data set generate the XML for the Article History page
        /// </summary>
        /// <param name="dataReader">Data set to turn into XML</param>
        /// <param name="entryID">Article to get the history of </param>
        private void GenerateArticleHistoryXml(IDnaDataReader dataReader, int entryID)
        {
            int count = 0;

            XmlElement articleHistory = AddElementTag(RootElement, "ARTICLEHISTORY");

            AddAttribute(articleHistory, "EntryID", entryID);

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    XmlElement items = AddElementTag(articleHistory, "ITEMS");

                    do
                    {
                        XmlElement item = AddElementTag(items, "ITEM");

                        AddIntElement(item, "USERID", dataReader.GetInt32NullAsZero("userid"));
                        AddIntElement(item, "ACTION", dataReader.GetInt32NullAsZero("action"));

                        AddTextTag(item, "COMMENT", dataReader.GetStringNullAsEmpty("comment"));

                        if (!dataReader.IsDBNull("dateperformed"))
                        {
                            AddDateXml(dataReader, item, "dateperformed", "DATEPERFORMED");
                        }
                        else
                        {
                            AddTextTag(item, "DATEPERFORMED", "");
                        }

                        count++;

                    } while (dataReader.Read());
                }
            }

            AddAttribute(articleHistory, "COUNT", count);
        }
    }
}
