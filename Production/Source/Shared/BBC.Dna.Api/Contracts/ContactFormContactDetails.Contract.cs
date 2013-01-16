using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api.Contracts
{
    [KnownType(typeof(ContactDetails))]
    [Serializable]
    [DataContract(Name = "contact", Namespace = "BBC.Dna.Api")]
    public partial class ContactDetails : CommentInfo
    {
        public ContactDetails()
        {
            User = new User();
        }
    }
}
