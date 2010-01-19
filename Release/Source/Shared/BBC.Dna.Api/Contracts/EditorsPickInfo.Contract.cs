using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(EditorsPickInfo))]
    [Serializable] [DataContract(Name = "EditorsPickInfo", Namespace = "BBC.Dna.Api")]
    public partial class EditorsPickInfo : baseContract
    {
        public EditorsPickInfo() { }

        [DataMember(Name = "response", Order = 1)]
        public bool Response
        {
            get;
            set;
        }
    }
}
