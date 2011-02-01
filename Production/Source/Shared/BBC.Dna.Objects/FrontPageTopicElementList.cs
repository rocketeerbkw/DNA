using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "FRONTPAGETOPICELEMENTLIST")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "FRONTPAGETOPICELEMENTLIST")]
    public class FrontPageTopicElementList : CachableBase<FrontPageTopicElementList>
    {
        /// <summary>
        /// Gets the topics for a given site and status from the db.
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        static public FrontPageTopicElementList GetFrontPageElementListFromCache(IDnaDataReaderCreator readerCreator, TopicStatus status, bool includeArchived,
            ICacheManager cache, DateTime siteListLastUpdate, bool ignoreCache, int siteId)
        {
            var source = new FrontPageTopicElementList();
            string key = source.GetCacheKey(siteId, status);
            //check for item in the cache first
            if (!ignoreCache && status == TopicStatus.Live)
            {//not ignoring and only cache live calls
                source = (FrontPageTopicElementList)cache.GetData(key);
                if (source != null && source.IsUpToDateWithSite(siteListLastUpdate))
                {
                    return source;
                }
            }
            source = new FrontPageTopicElementList() { Status = status };
            var topicList = TopicElementList.GetTopicListFromDatabase(readerCreator, siteId, status, includeArchived);
            foreach (TopicElement topic in topicList.Topics)
            {
                source.Topics.Add(topic.FrontPageElement);
            }
            source.LastUpdated = siteListLastUpdate;

            if (status == TopicStatus.Live)
            {
                cache.Add(key, source, CacheItemPriority.Low, null, new SlidingTime(TimeSpan.FromMinutes(source.CacheSlidingWindow())));
            }
            

            return source;
            
        }

        public FrontPageTopicElementList()
        {
            Topics = new List<FrontPageElement>();
        }

        /// <remarks/>
        [XmlArray(ElementName="TOPICELEMENTLIST")]
        [XmlArrayItem("TOPICELEMENT")]
        public List<FrontPageElement> Topics
        {
            get; set;
        }

        [XmlIgnore]
        public DateTime LastUpdated
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "STATUS")]
        public TopicStatus Status { get; set; }

        /// <summary>
        /// Not implemented - required for interface - use IsUpToDateWithSite method
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Compares the lastupdated with the sites last updated
        /// </summary>
        /// <param name="site"></param>
        /// <returns></returns>
        public bool IsUpToDateWithSite(DateTime siteListLastUpdate)
        {
            return LastUpdated == siteListLastUpdate;
        }
    }
}