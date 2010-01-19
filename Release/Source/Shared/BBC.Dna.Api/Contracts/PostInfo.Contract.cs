using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "post")]
    public partial class PostInfo
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

        [DataMember(Name = "summary", Order = 3)]
        public string Summary
        {
            get;
            set;
        }

        [DataMember(Name = "uri", Order = 4)]
        public string uri
        {
            get;
            set;
        }

        [DataMember(Name = "created", Order = 5)]
        public DateTimeHelper Created
        {
            get;
            set;
        }

        [DataMember(Name = "host", Order = 6)]
        public Host Host
        {
            get;
            set;
        }
    }
}
