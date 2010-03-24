using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(RatingsSummary))]
    [Serializable] [DataContract(Name = "ratingsSummary", Namespace = "BBC.Dna.Api")]
    public partial class RatingsSummary : CommentsSummary
    {
        public RatingsSummary() { }

        [DataMember(Name = "average", Order = 2)]
        public int Average
        {
            get;
            set;
        }

        

    }
}
