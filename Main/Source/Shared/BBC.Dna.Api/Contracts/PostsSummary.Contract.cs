using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "posts")]
    public partial class PostsSummary
    {
        [DataMember(Name = "total", Order = 1)]
        public int Total
        {
            get;
            set;
        }

        [DataMember(Name = "mostRecent", Order = 2)]
        public DateTimeHelper MostRecent
        {
            get;
            set;
        }
    }
}
