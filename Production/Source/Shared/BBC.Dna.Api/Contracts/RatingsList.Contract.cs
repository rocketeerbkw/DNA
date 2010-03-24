using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(RatingsList))]
    [Serializable] [DataContract(Name = "ratingsList", Namespace = "BBC.Dna.Api")]
    public partial class RatingsList : PagedList
    {
        public RatingsList() { }

        [DataMember(Name = ("ratings"), Order = 1)]
        public List<RatingInfo> ratings
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
