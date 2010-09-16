using System;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;
using System.Runtime.Serialization;
using System.Collections.ObjectModel;
using System.Xml.Serialization;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// The email template types enum
    /// </summary>
    public enum EmailTemplateTypes
    {
        ClassTemplates,
        SiteTemplates,
        AllTemplates
    }

    /// <summary>
    /// The EMailTemplates class
    /// </summary>
    [Serializable]
    [XmlType("EMAIL-TEMPLATES")]
    public class EmailTemplates
    {
        // Default constructor
        public EmailTemplates() { }

        /// <summary>
        /// This method gets all the Email Templates for a given type
        /// </summary>
        /// <param name="readerCreator">A data reader creator to create procedures</param>
        /// <param name="templateType">The type of templates to get</param>
        /// <param name="typeID">The ID of the template type</param>
        /// <returns>An Email Templates object that contains a collection of all the requested email templates</returns>
        public static EmailTemplates GetEmailTemplates(IDnaDataReaderCreator readerCreator, EmailTemplateTypes templateType, int typeID)
        {
            // Create a new email templates object and intialise the collection
            EmailTemplates emailTemplates = new EmailTemplates();
            emailTemplates.EmailTemplatesList = new Collection<EmailTemplate>();

            // Work out which procedure and params we need to call for the requested type
            string emailTemplateProc = "getemailtemplatesbymodclassid";
            string typeIDName = "modclassid";
            if (templateType == EmailTemplateTypes.SiteTemplates)
            {
                emailTemplateProc = "getemailtemplatesbysiteid";
                typeIDName = "siteid";
            }
            else if (templateType == EmailTemplateTypes.AllTemplates)
            {
                typeID = -1;
            }

            // Go through all the results creating and adding the templates to the list
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(emailTemplateProc))
            {
                reader.AddParameter(typeIDName, typeID);
                reader.Execute();
                while (reader.HasRows && reader.Read())
                {
                    EmailTemplate emailTemplate = new EmailTemplate()
                    {
                        ModClassID = reader.GetInt32("ModClassID"),
                        AutoFormat = reader.IsDBNull("AutoFormat") ? 0 : reader.GetBoolean("AutoFormat") ? 1 : 0,
                        EmailTemplateID = reader.GetInt32("EmailTemplateID"),
                        Name = reader.GetString("Name"),
                        Subject = reader.GetString("Subject"),
                        Body = reader.GetString("Body")
                    };

                    emailTemplates.EmailTemplatesList.Add(emailTemplate);
                }
            }

            // Return the new Email template object
            return emailTemplates;
        }

        [XmlElement("EMAIL-TEMPLATE")]
        public Collection<EmailTemplate> EmailTemplatesList { get; set; }


        /// <summary>
        /// FetchEmailText - Returns email template subject and body.
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="templateName">Name of template to serve.</param>
        /// <param name="subject">Returned subject</param>
        /// <param name="body">Returned template body.</param>
        public static void FetchEmailText(IDnaDataReaderCreator readerCreator, int siteId, string templateName, out string subject, out string body)
        {
            subject = string.Empty;
            body = string.Empty;
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("fetchemailtemplate"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("emailName", templateName);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    subject = dataReader.GetString("subject");
                    body = dataReader.GetString("body");
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="insertName"></param>
        /// <param name="insertText"></param>
        /// <returns></returns>
        public static bool FetchInsertText(IDnaDataReaderCreator readerCreator, int siteId, String insertName, out String insertText)
        {
            insertText = null;
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("getemailinsert"))
            {
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("insertname", insertName);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    insertText = dataReader.GetStringNullAsEmpty("inserttext");
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Removes the requested email template
        /// </summary>
        /// <param name="readerCreator">A reader creator to create the procedure</param>
        /// <param name="modClassID">The templates mod class id</param>
        /// <param name="templateName">The template name to remove</param>
        public static void RemoveTemplate(IDnaDataReaderCreator readerCreator, int modClassID, string templateName)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("deleteemailtemplate"))
            {
                reader.AddParameter("modclassid", modClassID);
                reader.AddParameter("templatename", templateName);
                reader.Execute();
            }
        }

        /// <summary>
        /// Creates a new template for the given mod class id
        /// </summary>
        /// <param name="readerCreator">The reader creator to create the procedure</param>
        /// <param name="modClassID">The mod class id the template belongs to</param>
        /// <param name="templateName">The name of the new template</param>
        /// <param name="subject">The template subject</param>
        /// <param name="body">The body of the template</param>
        public static void AddNewTemplate(IDnaDataReaderCreator readerCreator, int modClassID, string templateName, string subject, string body)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addnewemailtemplate"))
            {
                reader.AddParameter("ModClassID", modClassID);
                reader.AddParameter("Name", templateName);
                reader.AddParameter("Subject", subject);
                reader.AddParameter("Body", body);
                reader.Execute();
            }
        }

        /// <summary>
        /// Updates the template for the given mod class id
        /// </summary>
        /// <param name="readerCreator">The reader creator to create the procedure</param>
        /// <param name="modClassID">The mod class id the template belongs to</param>
        /// <param name="templateName">The name of the new template</param>
        /// <param name="subject">The template subject</param>
        /// <param name="body">The body of the template</param>
        public static void UpdateTemplate(IDnaDataReaderCreator readerCreator, int modClassID, string templateName, string subject, string body)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("updateemailtemplate"))
            {
                reader.AddParameter("ModClassID", modClassID);
                reader.AddParameter("Name", templateName);
                reader.AddParameter("Subject", subject);
                reader.AddParameter("Body", body);
                reader.Execute();
            }
        }
    }

    /// <summary>
    /// Class Provides Email Templates for use by Moderators and Editors.
    /// Templates are provided to cover emails sent to users as a result of common moderation and editorila decsisions.
    /// The users details are lated substituted into the generic email template.
    /// </summary>
    [Serializable]
    [XmlType("EMAIL-TEMPLATE")]
    public class EmailTemplate
    {
        public EmailTemplate() { }

        [XmlAttributeAttribute(AttributeName = "MODID", DataType = "int")]
        public int ModID { get { return ModClassID; } set { ModClassID = value; } }

        [XmlAttributeAttribute(AttributeName = "AUTOFORMAT", DataType = "int")]
        public int AutoFormat { get; set; }

        [XmlAttributeAttribute(AttributeName = "EMAILTEMPLATEID", DataType = "int")]
        public int EmailTemplateID { get; set; }

        /// <summary>
        /// The mod class the template belongs to
        /// </summary>
        [XmlElement(ElementName = "MODCLASSID", Order = 0, DataType="int")]
        public int ModClassID { get; set; }

        /// <summary>
        /// The name of the template
        /// </summary>
        [XmlElement(ElementName = "NAME", Order = 1)]
        public string Name { get; set; }

        /// <summary>
        /// The subject for the template
        /// </summary>
        [XmlElement(ElementName = "SUBJECT", Order = 2)]
        public string Subject { get; set; }

        /// <summary>
        /// The body of the eamil template
        /// </summary>
        [XmlElement(ElementName = "BODY", Order = 3)]
        public string Body { get; set; }
    }
}
