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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "GENERICSTATUS")]
    [DataContract(Name = "articleStatus")]
    public partial class ArticleStatus
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type")]
        public int Type
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(Name = "value")]
        public string Value
        {
            get;
            set;
        }

        /// <summary>
        /// returns the status objects for a given status code
        /// </summary>
        /// <param name="status"></param>
        /// <returns></returns>
        public static ArticleStatus GetStatus(int status)
        {
            string statusType = "";
            switch (status)
            {
                case 0: statusType = "No Status"; break;
                case 1: statusType = "Edited"; break;
                case 2: statusType = "User Entry, Private"; break;
                case 3: statusType = "User Entry, Public"; break;
                case 4: statusType = "Recommended"; break;
                case 5: statusType = "Locked by Editor"; break;
                case 6: statusType = "Awaiting Editing"; break;
                case 7: statusType = "Cancelled"; break;
                case 8: statusType = "User Entry, Staff-locked"; break;
                case 9: statusType = "Key Entry"; break;
                case 10: statusType = "General Page"; break;
                case 11: statusType = "Awaiting Rejection"; break;
                case 12: statusType = "Awaiting Decision"; break;
                case 13: statusType = "Awaiting Approval"; break;
                default: statusType = "Unknown"; break;
            }

            return new ArticleStatus() { Type = status, Value = statusType};
        }
    }
}
