using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api.Contracts
{
    [Serializable]
    [DataContract(Name = "CommentForumsActivityList", Namespace = "BBC.Dna.Api")]
    public class CommentForumsActivityList
    {
        [DataMember(Name = ("startDate"), Order = 1)]
        public DateTimeHelper StartDate
        {
            get;
            set;
        }

        [DataMember(Name = ("minutes"), Order = 2)]
        public int Minutes
        {
            get;
            set;
        }

        [DataMember(Name = ("dateChecked"), Order = 3)]
        public DateTimeHelper DateChecked
        {
            get;
            set;
        }

        [DataMember(Name = "activeCommentForums", Order = 4)]
        public List<CommentForumActivity> CommentForumsActivity
        {
            get;
            set;
        }
    }

    [Serializable]
    [DataContract(Name = "CommentForumsRatingActivityList", Namespace = "BBC.Dna.Api")]
    public class CommentForumsRatingActivityList
    {
        [DataMember(Name = ("startDate"), Order = 1)]
        public DateTimeHelper StartDate
        {
            get;
            set;
        }

        [DataMember(Name = ("minutes"), Order = 2)]
        public int Minutes
        {
            get;
            set;
        }

        [DataMember(Name = ("dateChecked"), Order = 3)]
        public DateTimeHelper DateChecked
        {
            get;
            set;
        }

        [DataMember(Name = "activeCommentForums", Order = 4)]
        public List<CommentForumRatingActivity> CommentForumsRatingActivity
        {
            get;
            set;
        }
    }
}
