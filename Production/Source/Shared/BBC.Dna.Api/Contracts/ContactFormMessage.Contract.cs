using System;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ContactForm))]
    [Serializable]
    [DataContract(Name = "ContactFormMessage", Namespace = "BBC.Dna.Api")]
    public partial class ContactFormMessage : baseContract
    {
        public ContactFormMessage() { }

        [DataMember(Name = "subject")]
        public string Subject
        {
            get;
            set;
        }

        [DataMember(Name = "body")]
        public Dictionary<string,string> Body
        {
            get;
            set;
        }
    }
}