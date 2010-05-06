using System;
using System.Xml.Serialization;
using BBC.Dna.Objects;
using BBC.Dna.Data;
namespace BBC.Dna.Moderation
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TERM")]
    public class Term
    {
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="ID")]
        public int Id { get; set; }


        /// <summary>
        /// 
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "ACTION")]
        public TermAction Action { get; set; }

        [XmlIgnore]
        private string _value;
        /// <remarks/>
        [XmlTextAttribute()]
        public string Value {
            get { return CleanString(_value); }
            set { _value = CleanString(value); }
        }

        /// <summary>
        /// Calls the db and updates the term and action for a given modclassid
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="modClassId"></param>
        /// <param name="historyId"></param>
        public void UpdateTermForModClassId(IDnaDataReaderCreator readerCreator, int modClassId, int historyId)
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

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addtermsfilterterm"))
            {
                reader.AddParameter("term", Value);
                reader.AddParameter("actionId", (byte)Action);
                reader.AddParameter("modClassId", modClassId);
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

    }

    public enum TermAction
    {
        /// <summary>
        /// No action required
        /// </summary>
        NoAction =0,
        /// <summary>
        /// Action to moderation
        /// </summary>
        Refer =1,
        /// <summary>
        /// Ask user to reedit
        /// </summary>
        ReEdit=2
    }
}
