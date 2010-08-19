using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using System.Linq;
using System.Runtime.Serialization;
using BBC.Dna.Common;
using BBC.Dna.Users;


namespace BBC.Dna.Objects
{

    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "GROUPS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "GROUP")]
    [DataContract (Name = "group")]
    public class Group
    {
        public Group()
        {
        }

        public Group(string name)
        {
            Name = name;
        }

        /// <remarks/>
        [XmlElement("NAME")]
        [DataMember(Name = "name")]
        public string Name { get; set; }
    }
}