using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;
using System;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentForumList))]
    [Serializable] [DataContract(Name = "commentForumList", Namespace = "BBC.Dna.Api")]
    public class CommentForumList : PagedList
    {
        [DataMember(Name = "commentForums", Order = 1)]
        public List<CommentForum> CommentForums
        {
            get;
            set;
        }

        public CommentForumList()
        {
        }


        

    }
}
