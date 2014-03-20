using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api.Contracts
{
    [KnownType(typeof(NeroRatingInfo))]
    [Serializable]
    [DataContract(Name = "NeroRatingInfo", Namespace = "BBC.Dna.Api")]
    public partial class NeroRatingInfo
    {
        public NeroRatingInfo() { }

        [DataMember(Name = ("neroRatingValue"), Order = 1, IsRequired = true)]
        public int neroValue
        {
            get;
            set;
        }

        [DataMember(Name = ("neroPositiveRatingValue"), Order = 2, IsRequired = true)]
        public int positiveNeroValue
        {
            get;
            set;
        }

        [DataMember(Name = ("neroNegativeRatingValue"), Order = 3, IsRequired = true)]
        public int negativeNeroValue
        {
            get;
            set;
        }
    }
}
