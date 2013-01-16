using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace BBC.Dna.Api.Contracts
{
    [KnownType(typeof(ContactDetailsList))]
    [Serializable]
    [DataContract(Name = "contactDetailsList", Namespace = "BBC.Dna.Api")]
    public partial class ContactDetailsList : PagedList
    {
        public ContactDetailsList() { }

        [DataMember(Name = ("contacts"), Order = 1)]
        public List<ContactDetails> contacts
        {
            get;
            set;
        }

        /// <summary>
        /// Last update used for caching
        /// </summary>
        public DateTime LastUpdate;
    }
}
