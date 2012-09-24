using System;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ContactForm))]
    [Serializable]
    [DataContract(Name = "ContactForm", Namespace = "BBC.Dna.Api")]
    public partial class ContactForm : Forum
    {
        public ContactForm() { }

        [DataMember(Name = "contactemail")]
        public string ContactEmail
        {
            get;
            set;
        }

        [DataMember(Name = ("contactDetailsList"), Order = 11, EmitDefaultValue = true)]
        public ContactDetailsList contactDetailsList
        {
            get;
            set;
        }
    }
}
