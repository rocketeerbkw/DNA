using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using System.Xml.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "ERROR")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "MESSAGEBOARDPUBLISHERROR")]
    public class MessageBoardPublishError : BaseResult
    {
        public MessageBoardPublishError()
        {
            AdminErrors = new List<string>();
            DesignErrors = new List<string>();
            ErrorMessage = "Error publishing message board.";
            Type = "MessageBoardPublishError";
            
        }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "ERRORMESSAGE")]
        public string ErrorMessage { get; set; }

        /// <remarks/>
        [XmlArrayAttribute(Order = 1, ElementName = "ADMIN")]
        [XmlArrayItemAttribute("ERROR", IsNullable = false)]
        public List<String> AdminErrors{ get; set; }

        /// <remarks/>
        [XmlArrayAttribute(Order = 2, ElementName = "DESIGN")]
        [XmlArrayItemAttribute("ERROR", IsNullable = false)]
        public List<String> DesignErrors{ get; set; }

        public override bool IsError() { return true; }
    }
}
