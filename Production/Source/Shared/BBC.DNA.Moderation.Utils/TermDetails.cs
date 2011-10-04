using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Objects;

namespace BBC.Dna.Moderation.Utils
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TERMDETAILS")]
    public class TermDetails : Term
    {
        /// <summary>
        /// Gets the reason for the profanity term
        /// </summary>
        [XmlElement(ElementName = "REASON")]
        public string Reason { get; set;}

        /// <summary>
        /// Gets the date 
        /// </summary>
        [XmlElement(ElementName = "UPDATEDDATE")]
        public Date UpdatedDate { get; set; }
       
        /// <summary>
        /// Gets the id of the user who last updated
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "USERID")]
        public int UserID { get; set; }
        
    }
}
