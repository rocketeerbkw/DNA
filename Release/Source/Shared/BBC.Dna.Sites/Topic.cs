using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;
using BBC.Dna.Utils;

namespace BBC.Dna.Sites
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TOPICLISTTOPIC")]
    public class Topic
    {
        public Topic()
        {

        }


        public Topic(int topicId, string title, int h2G2Id, int forumId, int status)
        {
            TopicId = topicId;
            Title = title;
            H2G2Id = h2G2Id;
            ForumId = forumId;
            TopicStatus = (TopicStatus)status;
        }


        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "TOPICID")]
        public int TopicId { get; set; }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "H2G2ID")]
        public int H2G2Id { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "SITEID")]
        public int SiteId { get; set; }

        [XmlIgnore]
        public TopicStatus TopicStatus { get; set; }
        /// <remarks/>
        [XmlElement(Order = 3, ElementName = "TOPICSTATUS")]
        public int TopicStatusElement
        {
            get { return (int)TopicStatus; }
            set { TopicStatus = (TopicStatus)value; }
        }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "TOPICLINKID")]
        public int TopicLinkId { get; set; }

        [XmlIgnore]
        private string _title;
        /// <remarks/>
        [XmlElement(Order = 5, ElementName = "TITLE")]
        public string Title{
            get { return HtmlUtils.RemoveAllHtmlTags(HtmlUtils.HtmlDecode(_title)); }
            set { _title = value; }
        }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "FORUMID")]
        public int ForumId { get; set; }

        /// <remarks/>
        [XmlElement(Order = 7, ElementName = "FORUMPOSTCOUNT")]
        public int ForumPostCount { get; set; }
    }

    public enum TopicStatus
    {
        Live = 0,
        Preview = 1,
        Deleted = 2,
        Archived = 3,
        ArchivedLive = 4
    }
}