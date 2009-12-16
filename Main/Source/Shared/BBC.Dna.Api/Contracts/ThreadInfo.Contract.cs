using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ThreadInfo))]
    [Serializable] [DataContract(Name = "thread", Namespace = "BBC.Dna.Api")]
    public partial class ThreadInfo : baseContract
    {
        public ThreadInfo() { }

        [DataMember(Name = ("id"), Order = 1, IsRequired = true)]
        public int id
        {
            get;
            set;
        }

        [DataMember(Name = ("count"), Order = 2, IsRequired = true)]
        public int count
        {
            get;
            set;
        }

        [DataMember(Name = ("rating"), Order = 3, IsRequired = true)]
        public RatingInfo rating
        {
            get;
            set;
        }

    }
}
