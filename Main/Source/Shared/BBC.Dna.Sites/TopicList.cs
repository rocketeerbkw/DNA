using System.Collections.Generic;
using System.Xml.Serialization;
using BBC.Dna.Data;

namespace BBC.Dna.Sites
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType=true, TypeName="TOPICLIST")]
    [XmlRootAttribute(Namespace="", IsNullable=false, ElementName="TOPICLIST")]
    public class TopicList
    {
        

        public TopicList()
        {
            Topics = new List<Topic>();
        }

        /// <remarks/>
        [XmlElementAttribute("TOPIC", Order=0)]
        public List<Topic> Topics { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="STATUS")]
        public string Status { get; set; }
    }
}
