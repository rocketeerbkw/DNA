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
    [XmlType(AnonymousType = true, TypeName = "SITECONFIGV2_BOARDSMODULES")]
    public class SiteConfigV2BoardsModules
    {

        public SiteConfigV2BoardsModules()
        {
            Links = new StringCollection();
        }

        /// <remarks/>
        [XmlArray(Form = XmlSchemaForm.Unqualified, Order = 0, ElementName = "LINKS"),
         XmlArrayItem("LINK", Form = XmlSchemaForm.Unqualified, IsNullable = false)]
        public StringCollection Links { get; set; }
    }
}