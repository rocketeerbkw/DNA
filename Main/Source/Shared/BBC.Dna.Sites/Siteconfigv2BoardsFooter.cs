using System;
using System.CodeDom.Compiler;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Schema;
using System.Xml.Serialization;

namespace BBC.Dna.Sites
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "SITECONFIGV2_BOARDSFOOTER")]
    public class SiteConfigV2BoardsFooter
    {

        public SiteConfigV2BoardsFooter()
        {
            Links = new StringCollection();
        }


        /// <remarks/>
        [XmlElement(Form = XmlSchemaForm.Unqualified, Order = 0, ElementName = "COLOUR")]
        public string Colour { get; set; }

        /// <remarks/>
        [XmlArray(Form = XmlSchemaForm.Unqualified, Order = 1, ElementName = "LINKS"),
         XmlArrayItem("LINK", Form = XmlSchemaForm.Unqualified, IsNullable = false)]
        public StringCollection Links { get; set; }
    }
}