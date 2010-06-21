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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public class CategorySummarySubnode
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("ID")]
        public int ID {get; set;} 

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("TYPE")]
        public int Type { get; set; } 

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        public string Value { get; set; }

    }
}
