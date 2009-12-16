using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "host")]
    public partial class Host
    {
        [DataMember(Name = "isDna", Order = 1)]
        public bool IsDna
        {
            get;
            set;
        }

        [DataMember(Name = "id", Order = 2)]
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = "uri", Order = 3)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = "urlName", Order = 4)]
        public string UrlName
        {
            get;
            set;
        }

        [DataMember(Name = "shortName", Order = 5)]
        public string ShortName
        {
            get;
            set;
        }

        [DataMember(Name = "description", Order = 6)]
        public string Description
        {
            get;
            set;
        }
    }
}
