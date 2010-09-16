using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Collections.ObjectModel;
using System.Xml.Serialization;
using BBC.Dna.Data;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// The Email Insert Group class
    /// </summary>
    [Serializable]
    [XmlType("EMAIL-INSERT-GROUPS")]
    public class EmailInsertGroups
    {
        /// <summary>
        /// The default constructor
        /// </summary>
        public EmailInsertGroups() { }

        /// <summary>
        /// This method gets a list of all the Email Insert Groups
        /// </summary>
        /// <param name="readerCreator">The data reader creator for calling procedures</param>
        /// <returns>A new EmailInsertGRoups object with a collection of all the email insert groups</returns>
        public static EmailInsertGroups GetEmailInsertGroups(IDnaDataReaderCreator readerCreator)
        {
            EmailInsertGroups insertGroups = new EmailInsertGroups();
            insertGroups.EmailInsertGroupsList = new Collection<EmailInsertGroup>();

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getemailinsertgroups"))
            {
                reader.Execute();
                while (reader.HasRows && reader.Read())
                {
                    insertGroups.EmailInsertGroupsList.Add(new EmailInsertGroup() { Group = reader.GetStringNullAsEmpty("InsertGroup") });
                }
            }

            return insertGroups;
        }

        [XmlElement("GROUP")]
        public Collection<EmailInsertGroup> EmailInsertGroupsList { get; set; }
    }

    /// <summary>
    /// The Email Insert Group class
    /// </summary>
    [Serializable]
    [XmlType("GROUP")]
    public class EmailInsertGroup
    {
        public EmailInsertGroup() { }

        [XmlText()]
        public string Group { get; set; }
    }
}
