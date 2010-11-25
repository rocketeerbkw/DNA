using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace Dna.ExModerationProcessor
{
    [KnownType(typeof(ModerationDecisionItem))]
    [DataContract(Name = "moderationitem", Namespace = "BBC.Dna.Moderation")]
    public partial class ModerationDecisionItem
    {
        public ModerationDecisionItem() { }

        [DataMember(Name = ("id"), Order = 1)]
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = ("status"), Order = 2)]
        public String Status
        {
            get;
            set;
        }

        [DataMember(Name = ("uri"), Order = 3)]
        public String Uri
        {
            get;
            set;
        }

        [DataMember(Name = ("notes"), Order = 4)]
        public String Notes
        {
            get;
            set;
        }

        [DataMember(Name = ("datecompleted"), Order = 5)]
        public String DateCompleted
        {
            get;
            set;
        }

    }

    public enum ModDecisionEnum
    {
        passed = 3,
        failed = 4
    }
}

