using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{    
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
