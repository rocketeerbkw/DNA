using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Xml.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// Class for Moderator Info
    /// </summary>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "MODERATORACTIONITEM")]
    public class ModeratorActionItem
    {
        public ModeratorActionItem()
        {

        }

        [XmlElementAttribute("TYPE", Order = 0)]
        public SiteType Type { get; set; }

        [XmlElementAttribute("TYPEINT", Order = 1)]
        public int TypeInt {
            get { return (int)Type; }
            set { Type = (SiteType)value;}
        }

        [XmlElementAttribute("TOTAL", Order = 2)]
        public int Total { get; set; }

    }
}
