using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "error", Namespace = "BBC.Dna.Api")]
    public class ErrorData
    {
        [DataMember(Name = "code", Order = 0)]
        public string Code { get; set; }

        [DataMember(Name = "detail", Order = 1)]
        public string Detail { get; set; }

        [DataMember(Name = "innerException", Order = 2)]
        public string InnerException { get; set; }
    }
}
