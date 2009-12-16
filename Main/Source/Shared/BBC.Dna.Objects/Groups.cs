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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "GROUPS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "GROUPS")]
    public partial class Groups
    {
        public Groups()
        {
            Group = new List<Group>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("GROUP", Order = 0)]
        public System.Collections.Generic.List<Group> Group
        {
            get;
            set;
        }
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "GROUPS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "GROUP")]
    public partial class Group
    {
        public Group()
        {}

        public Group(string name)
        {
            this.Name = name;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElement("NAME")]
        public string Name
        {
            get;
            set;
        }
    }

}
