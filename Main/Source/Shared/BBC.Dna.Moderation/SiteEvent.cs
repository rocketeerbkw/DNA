using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using System.Xml.Serialization;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using System.Xml.Linq;

namespace BBC.Dna.Moderation
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SITEEVENT")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "SITEEVENT")]
    public class SiteEvent 
    {
        public SiteEvent()
        {
            ActivityData = new XElement("ACTIVITYDATA");
        }

        [XmlElement(Order = 1, ElementName = "TYPE")]
        public SiteActivityType Type { get; set; }

        [XmlAnyElement(Order=2)]
        public XElement ActivityData { get; set; }

        [XmlElement(Order = 3, ElementName = "DATE")]
        public Date Date { get; set; }

        [XmlElement(Order = 4, ElementName = "SITEID")]
        public int SiteId { get; set; }

        [XmlIgnore]
        public int UserId { get; set; }

        /// <summary>
        /// Stores the event in the db...
        /// </summary>
        /// <param name="creator"></param>
        public void SaveEvent(IDnaDataReaderCreator creator)
        {
            using (IDnaDataReader reader = creator.CreateDnaDataReader("insertsiteactivityitem"))
            {
                reader.AddParameter("type", (int)Type);
                reader.AddParameter("activitydata", ActivityData.ToString());
                reader.AddParameter("datetime", Date.DateTime);
                reader.AddParameter("siteid", SiteId);
                reader.AddParameter("userid", UserId);
                reader.Execute();
            }
        }

    }
}
