using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ERROR")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "ERROR")]
    public partial class Error
    {
        public Error()
        { }

        public Error(string type, string message)
        {
            Type = type;
            ErrorMessage = message;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "ERRORMESSAGE")]
        public string ErrorMessage
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "EXTRAINFO")]
        public string ExtraInfo { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TYPE")]
        public string Type
        {
            get;
            set;
        }
    }
}
