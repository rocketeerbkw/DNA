using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{

    /// <summary>
    /// Builds the sub-article details and builds them into the page XML
    /// </summary>
    public class SubbedArticleStatusBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubArticleStatusBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubbedArticleStatusBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //if not an editor then return an error
            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsEditor)
            {
                AddErrorXml("NOT-EDITOR", "You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.", RootElement);
                return;
            }

            //prepare XML Doc
            RootElement.RemoveAll();
            XmlElement subbedArticles = AddElementTag(RootElement, "SUBBED-ARTICLES");

            //get data from DB
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchsubbedarticledetails"))
            {
                dataReader.AddParameter("h2g2id", InputContext.GetParamIntOrZero("h2g2id", "Get the id of the article we want to view"));
                dataReader.Execute();

                //if nothing returned then error
                if (!dataReader.HasRows)
                {
                    AddErrorXml("NO-DETAILS", "No details were found for this article.", RootElement);
                    return;
                }
                else
                {
                    //recurse through all article notes
                    while(dataReader.Read())
                    {
                        XmlElement subArticle = CreateElement("ARTICLEDETAILS");
                        AddIntElement(subArticle, "RECOMMENDATIONID", dataReader.GetInt32NullAsZero("RecommendationID"));
                        AddIntElement(subArticle, "H2G2ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                        AddIntElement(subArticle, "ORIGINALH2G2ID", dataReader.GetInt32NullAsZero("Originalh2g2ID"));
                        AddTextElement(subArticle, "SUBJECT", dataReader.GetAmpersandEscapedStringNullAsEmpty("subject"));
                        AddIntElement(subArticle, "ORIGINALID", dataReader.GetInt32NullAsZero("Originalh2g2ID"));

                        //add sub editor as <SUBEDITOR><USERID></USERID><USERNAME></USERNAME></SUBEDITOR>
                        XmlElement subEditor = CreateElement("SUBEDITOR");
                        AddIntElement(subEditor, "USERID", dataReader.GetInt32NullAsZero("SubEditorID"));
                        AddTextElement(subEditor, "USERNAME", dataReader.GetAmpersandEscapedStringNullAsEmpty("SubEditorName"));
                        subArticle.AppendChild(subEditor);

                        XmlElement acceptorXML = CreateElement("ACCEPTOR");
                        AddIntElement(acceptorXML, "USERID", dataReader.GetInt32NullAsZero("AcceptorID"));
                        AddTextElement(acceptorXML, "USERNAME", dataReader.GetAmpersandEscapedStringNullAsEmpty("AcceptorName"));
                        subArticle.AppendChild(acceptorXML);

                        XmlElement allocatorXML = CreateElement("ALLOCATOR");
                        AddIntElement(allocatorXML, "USERID", dataReader.GetInt32NullAsZero("AllocatorID"));
                        AddTextElement(allocatorXML, "USERNAME", dataReader.GetAmpersandEscapedStringNullAsEmpty("AllocatorName"));
                        subArticle.AppendChild(allocatorXML);

                        if (!dataReader.IsDBNull("DateAllocated"))
                        {
                            XmlElement DateAllocated = CreateElement("DateAllocated");
                            DateAllocated.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("DateAllocated")));
                            subArticle.AppendChild(DateAllocated);
                        }

                        if (!dataReader.IsDBNull("DateReturned"))
                        {
                            XmlElement DateReturned = CreateElement("DateReturned");
                            DateReturned.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument,dataReader.GetDateTime("DateReturned")));
                            subArticle.AppendChild(DateReturned);
                        }

                        AddIntElement(subArticle, "NOTIFICATION", dataReader.GetTinyIntAsInt("NotificationSent"));
                        AddIntElement(subArticle, "STATUS", dataReader.GetTinyIntAsInt("Status"));
                        AddTextElement(subArticle, "COMMENTS", dataReader.GetAmpersandEscapedStringNullAsEmpty("Comments"));

                        //add to root element
                        subbedArticles.AppendChild(subArticle);

                    }
                }
            }
        }

    }
}
