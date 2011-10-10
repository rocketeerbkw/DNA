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
        public DateElement UpdatedDate { get; set; }
       
        /// <summary>
        /// Gets the id of the user who last updated
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "USERID")]
        public int UserID { get; set; }

        /// <summary>
        /// Required to display the reason of the term filtered according to this flag
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "FromModClass")]
        public bool FromModClass { get; set; }

        /// <summary>
        /// Gets the user who changes the reason
        /// </summary>
        [XmlElement(ElementName = "USERNAME")]
        public string UserName { get; set; }

    }
}
