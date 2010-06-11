using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ANCESTOR")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "ANCESTOR")]
    [DataContract(Name = "crumbTrailAncestor")]
    public partial class CrumbTrailAncestor
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "NODEID")]
        [DataMember (Name="nodeId")]
        public int NodeId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        [DataMember(Name = "name")]
        public string Name
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "TREELEVEL")]
        [DataMember(Name = "treeLevel")]
        public int TreeLevel
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "NODETYPE")]
        [DataMember(Name = "nodeType")]
        public int NodeType
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "REDIRECTNODE")]
        [DataMember(Name = "redirectNode")]
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
    [DataContract (Name="crumbTrialAncestorRedirect")]
    public partial class CrumbTrialAncestorRedirect
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        [DataMember(Name = "id")]
        public int id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(Name = "value")]
        public string value
        {
            get;
            set;
        }
    }
}
