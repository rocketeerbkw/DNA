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
        private string _errorLinkParameter = string.Empty;

        public Error()
        {
        }

        public Error(string type, string message)
        {
            Type = type;
            ErrorMessage = message;
        }

        /// <summary>
        /// Overloaded constructor to include any links within the error message
        /// </summary>
        /// <param name="type"></param>
        /// <param name="message"></param>
        /// <param name="link"></param>
        public Error(string type, string message, string link)
        {
            Type = type;
            ErrorMessage = message;
            ErrorLinkParameter = link;
        }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "ERRORMESSAGE")]
        public string ErrorMessage { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "ERRORLINKPARAMETER")]
        public string ErrorLinkParameter
        {
            get
            {
                if (string.IsNullOrEmpty(_errorLinkParameter))
                    return string.Empty;
                else
                    return _errorLinkParameter;
            }
            set
            {
                _errorLinkParameter = value;
            }
        }

        public override bool IsError() { return true; }
    }
}