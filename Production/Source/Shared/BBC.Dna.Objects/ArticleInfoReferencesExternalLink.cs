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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEINFOREFERENCESEXTERNALLINK")]
    [DataContract(Name = "referencesExternalLink")]
    public partial class ArticleInfoReferencesExternalLink
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "OFFSITE")]
        [DataMember (Name="offSite")]
        public string OffSite
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "TITLE")]
        [DataMember(Name = "title")]
        public string Title
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "UINDEX")]
        [DataMember(Name = "index")]
        public int Index
        {
            get;
            set;
        }
    }
}
