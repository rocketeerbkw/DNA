using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;

namespace BBC.Dna.Api
{
    [KnownType(typeof(RatingInfo))]
    [Serializable] [DataContract(Name = "rating", Namespace = "BBC.Dna.Api")]
    public partial class RatingInfo : CommentInfo
    {
        public RatingInfo() { }


        [DataMember(Name = ("rating"), Order = 13, IsRequired = true)]
        public byte rating
        {
            get;
            set;
        }




    }
}
