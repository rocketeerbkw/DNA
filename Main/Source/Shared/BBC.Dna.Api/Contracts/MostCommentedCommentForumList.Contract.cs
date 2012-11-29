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
        [DataMember(Name = ("siteName"), Order = 1)]
        public string SiteName
        {
            get;
            set;
        }

        [DataMember(Name = ("siteDescription"), Order = 2)]
        public string Description
        {
            get;
            set;
        }

        [DataMember(Name = ("commentForumUID"), Order = 3) ]
        public string CommentForumUID
        {
            get;
            set;
        }

        [DataMember(Name = "commentForums", Order = 4)]
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
