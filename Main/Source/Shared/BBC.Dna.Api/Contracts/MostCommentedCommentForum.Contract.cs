using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable]
    [DataContract(Name = "mostCommentedCommentForum", Namespace = "BBC.Dna.Api")]
    public partial class MostCommentedCommentForum
    {
        [DataMember(Name = "id", Order = 1)]
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = ("uid"), Order = 2)]
        public string UID
        {
            get;
            set;
        }

        [DataMember(Name = ("siteid"), Order = 3)]
        public int SiteId
        {
            get;
            set;
        }

        [DataMember(Name = ("forumid"), Order = 4)]
        public int ForumId
        {
            get;
            set;
        }

        [DataMember(Name = ("title"), Order = 5)]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = ("url"), Order = 6)]
        public string Url
        {
            get;
            set;
        }

        
        public bool CanWrite
        {
            get;
            set;
        }

        [DataMember(Name = ("forumpostcount"), Order = 7)]
        public int ForumPostCount
        {
            get;
            set;
        }

        [DataMember(Name = ("datecreated"), Order = 8)]
        public DateTime DateCreated
        {
            get;
            set;
        }

        [DataMember(Name = ("forumclosedate"), Order = 9)]
        public DateTime ForumCloseDate
        {
            get;
            set;
        }

        [DataMember(Name = ("commentforumnlistcount"), Order = 10)]
        public int CommentForumListCount
        {
            get;
            set;
        }

        [DataMember(Name = ("lastposted"), Order = 11) ]
        public DateTime LastPosted
        {
            get;
            set;
        }
    }
}
