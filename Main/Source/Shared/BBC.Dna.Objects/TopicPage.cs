using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DebuggerStepThrough]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TOPIC_PAGE")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "TOPIC_PAGE")]
    public class TopicPage
    {
        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "TOPICLIST")]
        public TopicElementList TopicElementList { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "PAGE")]
        public string Page { get; set; }
    }
}