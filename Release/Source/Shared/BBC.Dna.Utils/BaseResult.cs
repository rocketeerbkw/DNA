using System;
using System.Xml.Serialization;

namespace BBC.Dna.Utils
{
    /// <remarks/>
    [Serializable]
    public abstract class BaseResult
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

        public abstract bool IsError();
    }
}