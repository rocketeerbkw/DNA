using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using System.Collections.Specialized;
using System.CodeDom.Compiler;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Common
{
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable()]
    [XmlType(AnonymousType = true, TypeName = "ARTICLE")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "SIGNALSTATUS")]
    public class SignalStatus
    {
        [XmlElement(ElementName = "SIGNALSTATUSMEMBER")]
        public List<SignalStatusMember> Members = new List<SignalStatusMember>();
    }


    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable()]
    [XmlType(AnonymousType = true, TypeName = "ARTICLE")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "SIGNALSTATUSMEMBER")]
    public class SignalStatusMember
    {
        public SignalStatusMember()
        {
            Values = new NameValueCollection();
        }

        [XmlElement(ElementName = "NAME")]
        public string Name { get; set; }

        [XmlIgnore]
        public NameValueCollection Values { get; set; }


        [XmlArray(ElementName = "VALUES")]
        [XmlArrayItem(ElementName="ITEM")]
        public List<KeyValueSerialisable> ValuesList
        {
            get{
                var list = new List<KeyValueSerialisable>();
                foreach (var key in Values.AllKeys)
                {
                    list.Add(new KeyValueSerialisable(){Key = key, Value= Values[key]});
                }
                return list;
            }

            set{}
        }
        

    }
    [Serializable()]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "VALUE")]
    public class KeyValueSerialisable
    {
        [XmlElement(ElementName = "KEY")]
        public string Key { get; set; }

        [XmlElement(ElementName = "VALUE")]
        public string Value { get; set; }
    }


}
