using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Xml.Serialization;

namespace BBC.Dna.Utils
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "ERROR")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "ERROR")]
    public class Error : BaseResult
    {
        public Error()
        {
        }

        public Error(string type, string message)
        {
            Type = type;
            ErrorMessage = message;
        }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "ERRORMESSAGE")]
        public string ErrorMessage { get; set; }
    }
}