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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ONLINEUSER")]
    public partial class OnlineUser
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "USER")]
        public OnlineUserInfo User
        {
            get;
            set;
        }
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "DAYSSINCEJOINED")]
        public decimal DaysSinceJoined
        {
            get;
            set;
        }
    }
}
