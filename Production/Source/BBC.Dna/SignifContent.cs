using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Holds the SignifContent class
    /// </summary>
    public class SignifContent : DnaInputComponent
    {
        /// <summary>
        /// Default Constructor for the SignifContent object
        /// </summary>
        public SignifContent(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Gets site specic most significant content
        /// </summary>
        /// <param name="siteID">SiteID you want SignifContent for</param>
        /// <returns>Xml Element containing the most SIGNIFCONTENT</returns>
        public XmlElement GetMostSignifContent(int siteID)
        {
            RootElement.RemoveAll();

            XmlElement signifContent = AddElementTag(RootElement, "SIGNIFCONTENT");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmostsignifcontent"))
            {
                dataReader.AddParameter("siteID", siteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    XmlElement type = null;
                    XmlElement content = null;
                    int currentType = 0;
                    int previousType = 0;
                    do
                    {
                        currentType = dataReader.GetInt32NullAsZero("TYPE");
                        if (currentType != previousType)
                        {
                            if (previousType != 0)
                            {
                                signifContent.AppendChild(type);
                            }
                            type = CreateElement("TYPE");
                            AddAttribute(type, "ID", currentType);
                            previousType = currentType;
                        }

                        int contentID = dataReader.GetInt32NullAsZero("ContentID");
                        int forumID = dataReader.GetInt32NullAsZero("ForumID");
                        string title = dataReader.GetStringNullAsEmpty("ContentTitle");
                        double score = dataReader.GetDoubleNullAsZero("Score");

                        content = CreateElement("CONTENT");
                        AddIntElement(content, "ID", contentID);
                        AddTextTag(content, "TITLE", title);
                        if (forumID != 0)
                        {
                            AddIntElement(content, "FORUMID", forumID);
                        }
                        AddTextTag(content, "SCORE", score.ToString());

                        type.AppendChild(content);

                    } while (dataReader.Read());

                    //close last opened TYPE if any
                    if (previousType != 0)
                    {
                        signifContent.AppendChild(type);
                    }
                }
            }
            return signifContent;
        }

        /// <summary>
        /// Decrements site's ContentSignif tables.
        /// </summary>
        /// <param name="siteID">Site to use</param>
        public void DecrementContentSignif(int siteID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("ContentSignifSiteDecrement"))
            {
                dataReader.AddParameter("siteID", siteID);
                dataReader.Execute();
            }
        }
    }
}