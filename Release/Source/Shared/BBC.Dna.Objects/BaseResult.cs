using System;
using System.Xml.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [Serializable]
    public class BaseResult
    {
        public BaseResult()
        {
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TYPE")]
        public string Type { get; set; }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "EXTRAINFO")]
        public string ExtraInfo { get; set; }
    }
}