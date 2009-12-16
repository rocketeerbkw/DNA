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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ANCESTOR")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "ANCESTOR")]
    public partial class CrumbTrailAncestor
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "NODEID")]
        public int NodeId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        public string Name
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "TREELEVEL")]
        public int TreeLevel
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "NODETYPE")]
        public int NodeType
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "REDIRECTNODE")]
        public CrumbTrialAncestorRedirect RedirectNode
        {
            get;
            set;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "CRUMBTRIALANCESTORREDIRECT")]
    public partial class CrumbTrialAncestorRedirect
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        public int id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        public string value
        {
            get;
            set;
        }
    }
}
