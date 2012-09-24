using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
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
    
    [KnownType(typeof(CommentsList))]
    [Serializable] [DataContract(Name = "commentsList", Namespace = "BBC.Dna.Api")]
    public partial class CommentsList : PagedList
    {
        public CommentsList() { }

        [DataMember(Name = ("comments"), Order = 1)]
        public List<CommentInfo> comments
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
