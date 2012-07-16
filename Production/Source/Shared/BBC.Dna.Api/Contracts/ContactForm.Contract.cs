using System;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ContactForm))]
    [Serializable]
    [DataContract(Name = "ContactForm", Namespace = "BBC.Dna.Api")]
    public partial class ContactForm : CommentForum
    {
        public ContactForm() { }

        [DataMember(Name = "contactemail")]
        public string ContactEmail
        {
            get;
            set;
        }
    }
}
