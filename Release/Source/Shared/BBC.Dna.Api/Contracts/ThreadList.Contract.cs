using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ThreadList))]
    [Serializable] [DataContract(Name = "threadList", Namespace = "BBC.Dna.Api")]
    public partial class ThreadList : PagedList
    {
        public ThreadList() { }

        [DataMember(Name = ("ratingsSummary"), Order = 1)]
        public RatingsSummary ratingsSummary
        {
            get;
            set;
        }


        [DataMember(Name = ("threads"), Order = 2)]
        public List<ThreadInfo> threads
        {
            get;
            set;
        }

        /// <summary>
        /// Last update used for caching
        /// </summary>
        public DateTime LastUpdate;
    }
}
