using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable]
    [DataContract(Name = "commentForum", Namespace = "BBC.Dna.Api")]
    public partial class MostCommentedCommentForum
    {
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = ("commentforumuid"), Order = 1)]
        public string UID
        {
            get;
            set;
        }

        [DataMember(Name = ("sitename"), Order = 2)]
        public string SiteName
        {
            get;
            set;
        }

        public int ForumId
        {
            get;
            set;
        }

        [DataMember(Name = ("title"), Order = 3)]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = ("parenturl"), Order = 4)]
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

        [DataMember(Name = ("forumpostcount"), Order = 5)]
        public int ForumPostCount
        {
            get;
            set;
        }

        [DataMember(Name = ("datecreated"), Order = 6)]
        public DateTime DateCreated
        {
            get;
            set;
        }

        [DataMember(Name = ("forumclosedate"), Order = 7)]
        public DateTime ForumCloseDate
        {
            get;
            set;
        }

        [DataMember(Name = ("commentforumnlistcount"), Order = 8)]
        public int CommentForumListCount
        {
            get;
            set;
        }

        [DataMember(Name = ("lastupdateddatetime"), Order = 9) ]
        public DateTime LastPosted
        {
            get;
            set;
        }
    }
}
