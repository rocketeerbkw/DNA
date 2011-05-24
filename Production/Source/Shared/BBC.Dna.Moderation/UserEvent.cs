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
    [XmlTypeAttribute(AnonymousType = true, TypeName = "USEREVENT")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "USEREVENT")]
    public class UserEvent 
    {
        public UserEvent()
        {
            ActivityData = new XElement("ACTIVITYDATA");
        }

        [XmlElement(Order = 1, ElementName = "TYPE")]
        public SiteActivityType Type { get; set; }

        [XmlAnyElement(Order = 2)]
        public XElement ActivityData { get; set; }

        [XmlElement(Order = 3, ElementName = "DATE")]
        public Date Date { get; set; }

        [XmlElement(Order = 4, ElementName = "MODERATIONCLASSID")]
        public int ModClassId { get; set; }

        [XmlIgnore]
        public int UserId { get; set; }

        [XmlElement(Order = 5, ElementName = "SCORE")]
        public int Score { get; set; }

        [XmlElement(Order = 6, ElementName = "ACCUMMULATIVESCORE")]
        public int AccummulativeScore { get; set; }
    }
}
