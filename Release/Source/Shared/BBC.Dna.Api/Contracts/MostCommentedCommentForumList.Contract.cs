using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;
using System;

namespace BBC.Dna.Api
{
    [Serializable]
    [DataContract(Name = "mostCommentedCommentForumList", Namespace = "BBC.Dna.Api")]
    public partial class MostCommentedCommentForumList
    {
        [DataMember(Name = "mostCommentedCommentForum", Order = 1)]
        public List<MostCommentedCommentForum> MostCommentedCommentForums
        {
            get;
            set;
        }

        public MostCommentedCommentForumList()
        {
        }
    }
}
