using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [DataContract(Name="subnode")]
    public class CategorySummarySubnode
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("ID")]
        [DataMember(Name = "id")]
        public int ID {get; set;} 

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("TYPE")]
        [DataMember(Name = "type")]
        public int Type { get; set; } 

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(Name = "value")]
        public string Value { get; set; }

    }
}
