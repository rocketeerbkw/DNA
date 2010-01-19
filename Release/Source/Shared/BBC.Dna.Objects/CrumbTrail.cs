using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "CRUMBTRAIL")]
    //[System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "CRUMBTRAIL")]
    public partial class CrumbTrail
    {
        public CrumbTrail()
        {
            Ancestor = new List<CrumbTrailAncestor>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElement(Order = 0, ElementName = "ANCESTOR")]
        public List<CrumbTrailAncestor> Ancestor
        {
            get;
            set;
        }

        

    }

}
