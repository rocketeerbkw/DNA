using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using BBC.Dna.Data;
using System.Xml.Linq;

namespace BBC.Dna.Moderation.Utils
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TERM")]
    public class Term
    {
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "ID")]
        public int Id { get; set; }


        /// <summary>
        /// 
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "ACTION")]
        public TermAction Action { get; set; }

        [XmlIgnore]
        private string _value;
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "TERM")]
        public string Value
        {
            get { return CleanString(_value); }
            set { _value = CleanString(value); }
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "ModClassID")]
        public int ModClassID { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "ForumID")]
        public int ForumID { get; set; }

        /// <summary>
        /// Calls the db and updates the term and action for a given modclassid
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <param name="historyId"></param>
        public bool UpdateTermForModClassId(IDnaDataReaderCreator readerCreator, int modClassId, int historyId)
        {
            if (string.IsNullOrEmpty(Value))
            {//if empty then throw exception
                throw new Exception("Term value cannot be empty.");
            }
            if (historyId == 0)
            {//if empty then throw exception
                throw new Exception("HistoryId cannot be 0.");
            }
            if (modClassId == 0)
            {//if empty then throw exception
                throw new Exception("ModClassId cannot be 0.");
            }

            bool termUpdated = true;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addtermsfilterterm"))
            {
                reader.AddParameter("term", Value);
                reader.AddParameter("actionId", (byte)Action);
                reader.AddParameter("modClassId", modClassId);
                reader.AddParameter("historyId", historyId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    termUpdated = reader.GetBoolean("termupdated");
                }
            }

            return termUpdated;
        }

        /// <summary>
        /// Calls the db and updates the term and action for a given forumId
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <param name="historyId"></param>
        public void UpdateTermForForumId(IDnaDataReaderCreator readerCreator, int forumId, int historyId)
        {
            if (string.IsNullOrEmpty(Value))
            {//if empty then throw exception
                throw new Exception("Term value cannot be empty.");
            }
            if (historyId == 0)
            {//if empty then throw exception
                throw new Exception("HistoryId cannot be 0.");
            }
            if (forumId == 0)
            {//if empty then throw exception
                throw new Exception("ForumId cannot be 0.");
            }

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addforumfilterterm"))
            {
                reader.AddParameter("term", Value);
                reader.AddParameter("actionId", (byte)Action);
                reader.AddParameter("forumId", forumId);
                reader.AddParameter("historyId", historyId);
                reader.Execute();
            }
        }

        /// <summary>
        /// cleans up the term string
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        private string CleanString(string text)
        {
            if (text == null)
            {
                return text;
            }
            text = text.Replace("\r", "");
            text = text.Replace("\n", "");
            text = text.Replace("\t", "");
            text = text.ToLower();
            text = text.Trim();
            return text;
        }

        /// <summary>
        /// Creates the profanity xml by using the list of terms 
        /// </summary>
        /// <param name="terms"></param>
        /// <returns></returns>
        public string GetProfanityXML(List<Term> terms)
        {

            XElement xml = new XElement("Profanities",
                                new XElement("Terms",
                                    from c in terms
                                    select new XElement("TermDetails", new XElement("ModClassID", c.ModClassID.ToString()), 
                                        new XElement("ForumID", c.ForumID.ToString()), new XElement("TermID", c.Id.ToString()))));

            return xml.ToString();

        }
    }

    public enum TermAction
    {
        /// <summary>
        /// No action required
        /// </summary>
        NoAction = 0,
        /// <summary>
        /// Action to moderation
        /// </summary>
        Refer = 1,
        /// <summary>
        /// Ask user to reedit
        /// </summary>
        ReEdit = 2
    }
}
