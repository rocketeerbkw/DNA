using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Xml.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using BBC.Dna.Objects;

namespace BBC.Dna.Moderation
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "MODERATORHOMEMODERATIONQUEUESUMMARY")]
    public partial class ModQueueStat
    {
        public ModQueueStat()
        {
        }

        public ModQueueStat(string state, string objectType,
                DateTime minDateQueued, bool fastMod,
                int modClassId, int timeLeft, int total)
        {
            State = state;
            ObjectType = objectType;
            MinDateQueued = new Date(minDateQueued);
            FastMod = (byte)(fastMod ? 1 : 0);
            ClassId = modClassId;
            TimeLeft = timeLeft;
            Total = total;
        }

        public ModQueueStat(string state, string objectType,
                bool fastMod, int modClassId)
        {
            State = state;
            ObjectType = objectType;
            MinDateQueued = new Date(DateTime.MinValue);
            FastMod = (byte)(fastMod ? 1 : 0);
            ClassId = modClassId;
            TimeLeft = 0;
            Total = 0;
        }

        /// <remarks/>
        [XmlElementAttribute("OBJECTTYPE", Order = 0)]
        public string ObjectType
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 1, ElementName = "STATE")]
        public string State
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 2, ElementName = "DATE")]
        public Date MinDateQueued
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "FASTMOD")]
        public byte FastMod
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "CLASSID")]
        public int ClassId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "TIMELEFT")]
        public int TimeLeft
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "TOTAL")]
        public int Total
        {
            get;
            set;
        }
    }
}
