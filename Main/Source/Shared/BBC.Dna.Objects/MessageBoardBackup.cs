using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;
using BBC.Dna.Sites;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "MESSAGEBOARDBACKUP")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "MESSAGEBOARDBACKUP")]
    public class MessageBoardBackup
    {
        public MessageBoardBackup()
        {
            TopicPage = new TopicPage();
            SiteConfig = new SiteConfig();
            Date = DateTime.Now;
        }

        /// <remarks/>
        [XmlElement(ElementName = "DATE")]
        public DateTime Date { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "TOPICPAGE")]
        public TopicPage TopicPage { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "SITECONFIG")]
        public SiteConfig SiteConfig { get; set; }
    }
}