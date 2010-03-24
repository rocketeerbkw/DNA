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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "MODERATIONSTATUS")]
    public partial class ModerationStatus
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ID")]
        public int Id
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        public string Value
        {
            get;
            set;
        }
    }
}
