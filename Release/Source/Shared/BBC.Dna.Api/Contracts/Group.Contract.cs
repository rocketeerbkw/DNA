using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "group")]
    public partial class Group
    {
        [DataMember(Name = "id", Order = 1)]
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = ("title"), Order = 2)]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = ("badgeUri"), Order = 3)]
        public string BadgeUri
        {
            get;
            set;
        }
    }
}
