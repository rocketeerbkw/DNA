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
    public class CategoryAncestor
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "NODEID")]
        public ushort NodeId { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "TYPE")]
        public byte Type { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "NAME")]
        public string Name  { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "TREELEVEL")]
        public byte TreeLevel  { get; set; }

    }
}
