﻿using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Xml.Serialization;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DebuggerStepThrough]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "TOPIC_PAGETOPICLISTTOPICCREATEDBY")]
    public class TopicCreatedDate
    {
        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "USERNAME")]
        public string Username { get; set; }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "USERID")]
        public int Userid { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "CREATEDDATE")]
        public DateElement CreatedDate { get; set; }
    }
}