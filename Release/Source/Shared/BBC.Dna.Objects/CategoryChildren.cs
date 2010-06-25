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
    [DataContract(Name="categoryChildren")]
    public class CategoryChildren
    {
        /// <remarks/>
        // [System.Xml.Serialization.XmlElementAttribute("SubCategories", Order = 0)]
        [System.Xml.Serialization.XmlArrayAttribute("SUBCATEGORIES", Order = 0)]
        [DataMember(Name = "subCategories")]
        public System.Collections.Generic.List<CategorySummary> SubCategories { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute("ARTICLES", Order = 1)]
        [DataMember(Name = "articles")]
        public System.Collections.Generic.List<ArticleSummary> Articles { get; set; }

    }
}
