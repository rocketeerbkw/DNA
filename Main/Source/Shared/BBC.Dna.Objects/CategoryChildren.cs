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
    public class CategoryChildren
    {
        /// <remarks/>
        // [System.Xml.Serialization.XmlElementAttribute("SubCategories", Order = 0)]
        [System.Xml.Serialization.XmlArrayAttribute("SUBCATEGORIES", Order = 0)] 
        public System.Collections.Generic.List<CategorySummary> SubCategories { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute("ARTICLES", Order = 1)]
        public System.Collections.Generic.List<ArticleSummary> Articles { get; set; }

    }
}
