using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Xml;
using BBC.Dna.Utils;
using BBC.Dna.Moderation;

namespace BBC.Dna
{
    /// <summary>
    /// 
    /// </summary>
    public class ContactFormListBuilder : DnaInputComponent
    {
        private int skip = 0;
        private int show = 20;
        private int requestedSiteID = 0;

        /// <summary>
        /// The class that is respoonsible for displaying the contact form lists
        /// </summary>
        /// <param name="inputContext">The current Input context</param>
        public ContactFormListBuilder(IInputContext inputContext) : base(inputContext)
        {
        }

        /// <summary>
        /// Gets and Creates the contact forms list
        /// </summary>
        public void GetContactForms()
        {
            ProcessInputParameters();
            RootElement.AppendChild(GetAllContactForms());
        }

        /// <summary>
        /// Gets and Creates the contact forms list a returns it as an xml node
        /// </summary>
        /// <returns>XmlNode representation of the contact forms</returns>
        public XmlNode GetContactFormsAsXml()
        {
            ProcessInputParameters();
            return GetAllContactForms();
        }

        private void ProcessInputParameters()
        {
            if (InputContext.DoesParamExist("skip", "Items to skip"))
            {
                skip = InputContext.GetParamIntOrZero("skip", "Items to skip");
            }

            if (InputContext.DoesParamExist("show", "Items to show"))
            {
                show = InputContext.GetParamIntOrZero("show", "Items to show");
            }

            requestedSiteID = InputContext.GetParamIntOrZero("dnasiteid", "The specified site");
        }

        private XmlNode GetAllContactForms()
        {
            XmlNode contactFormsXml = null;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcontactformslist"))
            {
                reader.AddParameter("@skip", skip);
                reader.AddParameter("@show", show);
                reader.Execute();
                contactFormsXml = GenerateXMLFromDataReader(reader);
            }
            return contactFormsXml;
        }

        private XmlNode GenerateXMLFromDataReader(IDnaDataReader reader)
        {
            //XmlNode contactFormsXml = CreateElementNode("CONTACTFORMS");
            XmlNode contactFormsXml = CreateElementNode("COMMENTFORUMLIST");
            AddAttribute(contactFormsXml, "skip", skip);
            AddAttribute(contactFormsXml, "show", show);
            AddAttribute(contactFormsXml, "REQUESTEDSITEID", requestedSiteID);

            // Check to make sure that we have a valid reader and we have soething to read
            if (reader == null || !reader.HasRows)
            {
                AddAttribute(contactFormsXml, "totalcount", 0);
            }
            else
            {
                bool haveData = reader.Read();
                
                AddAttribute(contactFormsXml, "COMMENTFORUMLISTCOUNT", reader.GetInt32("commentforumlistcount"));
                
                while (haveData)
                {
                    AddCommentForumListXML(reader, contactFormsXml);
                    haveData = reader.Read();
                }
            }

            return contactFormsXml;
        }

        private void AddCommentForumListXML(IDnaDataReader dataReader, XmlNode commentForumList)
        {
            // start creating the comment forum structure
            XmlNode commentForum = CreateElementNode("COMMENTFORUM");
            AddAttribute(commentForum, "UID", dataReader.GetStringNullAsEmpty("uid"));
            AddAttribute(commentForum, "FORUMID", dataReader.GetInt32NullAsZero("forumID").ToString());
            AddAttribute(commentForum, "FORUMPOSTCOUNT", dataReader.GetInt32NullAsZero("forumpostcount").ToString());
            AddAttribute(commentForum, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
            AddAttribute(commentForum, "CANWRITE", dataReader.GetByteNullAsZero("CanWrite").ToString());

            AddTextTag(commentForum, "HOSTPAGEURL", dataReader.GetStringNullAsEmpty("url"));
            AddTextTag(commentForum, "TITLE", dataReader.GetStringNullAsEmpty("title"));
            AddTextTag(commentForum, "MODSTATUS", dataReader.GetByteNullAsZero("ModerationStatus"));
            AddTextTag(commentForum, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
            AddTextTag(commentForum, "FASTMOD", dataReader.GetInt32NullAsZero("fastmod"));
            AddTextTag(commentForum, "CONTACTEMAIL", dataReader.GetStringNullAsEmpty("encryptedcontactemail"));

            if (dataReader.DoesFieldExist("DateCreated") && !dataReader.IsDBNull("DateCreated"))
            {
                DateTime dateCreated = dataReader.GetDateTime("DateCreated");
                AddElement(commentForum, "DATECREATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateCreated));
            }

            if (dataReader.DoesFieldExist("ForumCloseDate") && !dataReader.IsDBNull("ForumCloseDate"))
            {
                DateTime closeDate = dataReader.GetDateTime("ForumCloseDate");
                AddElement(commentForum, "CLOSEDATE", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, closeDate));
            }

            if (dataReader.DoesFieldExist("LastUpdated") && !dataReader.IsDBNull("LastUpdated"))
            {
                DateTime dateLastUpdated = dataReader.GetDateTime("LastUpdated");
                AddElement(commentForum, "LASTUPDATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateLastUpdated));
            }

            int forumId = dataReader.GetInt32NullAsZero("forumID");
 
            AddXmlTextTag(commentForum, "TERMS", "");

            commentForumList.AppendChild(commentForum);
        }
    }
}
