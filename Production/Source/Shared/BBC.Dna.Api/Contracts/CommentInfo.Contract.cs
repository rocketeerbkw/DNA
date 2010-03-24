using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using System.Xml.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentInfo))]
    [Serializable] [DataContract(Name = "comment", Namespace = "BBC.Dna.Api")]
    public partial class CommentInfo : baseContract
    {
        public CommentInfo() { }

        [DataMember(Name = ("uri"), Order = 1)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = ("text"), Order = 2)]
        [System.Xml.Serialization.XmlText]
        public string text
        {
            get;
            set;
        }

        [DataMember(Name = ("created"), Order = 3)]
        public DateTimeHelper Created
        {
            get;
            set;
        }

        [DataMember(Name = ("user"), Order = 4)]
        public User User
        {
            get;
            set;
        }

        [DataMember(Name = ("id"), Order = 5)]
        public int ID
        {
            get;
            set;
        }


        [DataMember(Name = ("poststyle"), Order = 6)]
        public PostStyle.Style PostStyle
        {
            get;
            set;
        }

        [DataMember(Name = ("complaintUri"), Order = 7)]
        public string ComplaintUri
        {
            get;
            set;
        }


        [DataMember(Name = ("forumUri"), Order = 8)]
        public string ForumUri
        {
            get;
            set;
        }

        /// <summary>
        /// The hidden status of the comment
        /// </summary>
        [DataMember(Name = ("status"), Order = 9)]
        public CommentStatus.Hidden hidden = CommentStatus.Hidden.NotHidden;


        /// <summary>
        /// Is the comment premod
        /// </summary>
        public bool IsPreModerated = false;

        /// <summary>
        /// The comment in the premod table
        /// </summary>
        public bool IsPreModPosting = false;


    }
}
