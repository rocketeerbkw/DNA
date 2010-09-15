using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using System.Collections.ObjectModel;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// The Email Inserts class
    /// </summary>
    [Serializable]
    [XmlType("EMAIL-INSERTS")]
    public class EmailInserts
    {
        /// <summary>
        /// The default constructor
        /// </summary>
        public EmailInserts() { }

        /// <summary>
        /// This metho gets all the Email Inserts for a given site or mod class
        /// </summary>
        /// <param name="readerCreator">A data reader creator to create procedure calls</param>
        /// <param name="insertType">The type of inserts to get, modclass or site</param>
        /// <param name="typeID">The ID of the modclass or site to get</param>
        /// <returns>An EmailInserts object that holds a list of all the email inserts for the requested object</returns>
        public static EmailInserts GetEmailInserts(IDnaDataReaderCreator readerCreator, EmailTemplateTypes insertType, int typeID)
        {
            // Create a new EmailInserts object and initialise the collection
            EmailInserts emailInserts = new EmailInserts();
            emailInserts.EmailInsertList = new Collection<EmailInsert>();

            // Work out which type of inserts we're trying to get
            string procName = "getemailinsertsbyclass";
            string paramName = "ModClassID";
            if (insertType == EmailTemplateTypes.SiteTemplates)
            {
                procName = "getemailinsertsbysite2";
                paramName = "siteid";
            }
            else if (insertType == EmailTemplateTypes.AllTemplates)
            {
                typeID = -1;
            }

            // Go through all the results creating the inserts and adding them to the list
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader(procName))
            {
                reader.AddParameter(paramName, typeID);
                reader.Execute();
                
                while (reader.HasRows && reader.Read())
                {
                    EmailInsert insert = new EmailInsert();
                    insert.ID = reader.GetInt32("EmailInsertID");
                    insert.Name = reader.GetString("InsertName");
                    insert.DisplayName = reader.GetString("DisplayName");
                    insert.Group = reader.GetString("InsertGroup");
                    if (!reader.IsDBNull("SiteID"))
                    {
                        insert.SiteID = reader.GetInt32("SiteID");
                    }
                    insert.DefaultText = reader.GetString("DefaultText");
                    insert.InsertText = reader.GetString("InsertText");
                    insert.ClassID = reader.GetInt32("ModClassID");

                    emailInserts.EmailInsertList.Add(insert);
                }
            }

            // Return the new object
            return emailInserts;
        }

        /// <summary>
        /// Creates a site's email insert
        /// </summary>
        /// <param name="readerCreator">Reader creator to create the procedure</param>
        /// <param name="modclassid">The mod class id for the insert</param>
        /// <param name="insertName">The name of the insert</param>
        /// <param name="insertGroupName">The groupname the insert belongs to</param>
        /// <param name="text">The text for the insert</param>
        /// <param name="description">The description of the insert</param>
        public static void CreateModClassEmailInsert(IDnaDataReaderCreator readerCreator, int modClassID, string insertName, string insertGroupName, string text, string description)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addmodclassemailinsert"))
            {
                reader.AddParameter("ModClassID", modClassID);
                reader.AddParameter("Name", insertName);
                reader.AddParameter("Group", insertGroupName);
                reader.AddParameter("Text", text);
                reader.AddParameter("ReasonDescription", description);
                reader.Execute();
            }
        }

        /// <summary>
        /// Creates a site's email insert
        /// </summary>
        /// <param name="readerCreator">Reader creator to create the procedure</param>
        /// <param name="siteID">The siteid for the insert</param>
        /// <param name="insertName">The name of the insert</param>
        /// <param name="insertGroupName">The groupname the insert belongs to</param>
        /// <param name="text">The text for the insert</param>
        /// <param name="description">The description of the insert</param>
        public static void CreateSiteEmailInsert(IDnaDataReaderCreator readerCreator, int siteID, string insertName, string insertGroupName, string text, string description)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addsiteemailinsert"))
            {
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("Name", insertName);
                reader.AddParameter("Group", insertGroupName);
                reader.AddParameter("Text", text);
                reader.AddParameter("ReasonDescription", description);
                reader.Execute();
            }
        }

        /// <summary>
        /// Updates a mod class email insert
        /// </summary>
        /// <param name="readerCreator">Reader creator to create the procedure</param>
        /// <param name="ModClassID">The mod class id for the insert</param>
        /// <param name="insertName">The name of the insert</param>
        /// <param name="insertGroupName">The groupname the insert belongs to</param>
        /// <param name="text">The text for the insert</param>
        /// <param name="description">The description of the insert</param>
        public static void UpdateModClassEmailInsert(IDnaDataReaderCreator readerCreator, int modClassID, string insertName, string insertGroupName, string text, string description)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("updatemodclassemailinsert"))
            {
                reader.AddParameter("ModClassID", modClassID);
                reader.AddParameter("Name", insertName);
                reader.AddParameter("Group", insertGroupName);
                reader.AddParameter("Text", text);
                reader.AddParameter("ReasonDescription", description);
                reader.Execute();
            }
        }

        /// <summary>
        /// Updates a site's email insert
        /// </summary>
        /// <param name="readerCreator">Reader creator to create the procedure</param>
        /// <param name="siteID">The siteid for the insert</param>
        /// <param name="insertName">The name of the insert</param>
        /// <param name="insertGroupName">The groupname the insert belongs to</param>
        /// <param name="text">The text for the insert</param>
        /// <param name="description">The description of the insert</param>
        public static void UpdateSiteEmailInsert(IDnaDataReaderCreator readerCreator, int siteID, string insertName, string insertGroupName, string text, string description)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("updatesiteemailinsert"))
            {
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("Name", insertName);
                reader.AddParameter("Group", insertGroupName);
                reader.AddParameter("Text", text);
                reader.AddParameter("ReasonDescription", description);
                reader.Execute();
            }
        }

        /// <summary>
        /// Static method for removing an email insert for a given mod class
        /// </summary>
        /// <param name="readerCreator">The reader creator to create the datareader</param>
        /// <param name="modClassID">The mod class id the insert belongs to</param>
        /// <param name="insertName">The name of the insert to remove</param>
        public static void RemoveModClassEmailInsert(IDnaDataReaderCreator readerCreator, int modClassID, string insertName)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("removemodclassemailinsert"))
            {
                reader.AddParameter("ModClassID", modClassID);
                reader.AddParameter("Name", insertName);
                reader.Execute();
            }
        }

        /// <summary>
        /// Static method for removing an email insert for a given site
        /// </summary>
        /// <param name="readerCreator">The reader creator to create the datareader</param>
        /// <param name="siteID">The site id the insert belongs to</param>
        /// <param name="insertName">The name of the insert to remove</param>
        public static void RemoveSiteEmailInsert(IDnaDataReaderCreator readerCreator, int siteID, string insertName)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("removesiteemailinsert"))
            {
                reader.AddParameter("SiteID", siteID);
                reader.AddParameter("Name", insertName);
                reader.Execute();
            }
        }

        [XmlElement("EMAIL-INSERT")]
        public Collection<EmailInsert> EmailInsertList { get; set; }
    }

    /// <summary>
    /// The Email Insert class
    /// </summary>
    [Serializable]
    [XmlType("EMAIL-INSERT")]
    public class EmailInsert
    {
        public EmailInsert() { }

        [XmlAttribute("ID")]
        public int ID { get; set; }

        [XmlAttribute("SITEID")]
        public int SiteID { get; set; }

        [XmlElement("NAME")]
        public string Name { get; set; }

        [XmlElement("DISPLAYNAME")]
        public string DisplayName { get; set; }

        [XmlElement("GROUP")]
        public string Group { get; set; }

        [XmlElement("CLASSID")]
        public int ClassID { get; set; }

        [XmlElement("DEFAULTTEXT")]
        public string DefaultText { get; set; }

        [XmlElement("TEXT")]
        public string InsertText { get; set; }
    }
}
