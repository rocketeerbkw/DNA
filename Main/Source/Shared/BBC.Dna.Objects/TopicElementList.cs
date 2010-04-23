using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using System.Linq;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TOPICLIST")]
    public class TopicElementList
    {
        /// <summary>
        /// Gets the topics for a given site and status from the db.
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        static public TopicElementList GetTopicListFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, TopicStatus status, bool includeArchived)
        {
            var topicList = new TopicElementList{Status = status};
            using (var reader = readerCreator.CreateDnaDataReader("gettopicsforsiteid2"))
            {
                reader.AddParameter("isiteid", siteId);
                reader.AddParameter("itopicstatus", (int)status);
                reader.AddParameter("includearchived", includeArchived ? 1 : 0);
                
                reader.Execute();
                while(reader.Read())
                {
                    topicList.Topics.Add(TopicElement.GetTopicFromReader(reader));
                }
            }

            return topicList;
        }

        public TopicElementList()
        {
            Topics = new List<TopicElement>();
        }

        /// <remarks/>
        [XmlElement("TOPIC", Order = 0)]
        public List<TopicElement> Topics
        {
            get; set;
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "STATUS")]
        public TopicStatus Status { get; set; }

        /// <summary>
        /// Gets the topic which matches the topic Id
        /// </summary>
        /// <param name="topicId"></param>
        /// <returns></returns>
        public TopicElement GetTopicElementById(int topicId)
        {
            var item = Topics.Where(x => x.TopicId == topicId);
            if (item.Count() > 0)
            {
                return item.First(); 
            }
            return null;
        }
    }
}