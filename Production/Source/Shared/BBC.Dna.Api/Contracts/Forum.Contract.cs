using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(Forum))]
    [Serializable] [DataContract(Name = "forum", Namespace = "BBC.Dna.Api")]
    public partial class Forum : baseContract
    {
        public Forum() { }
        [DataMember(Name = "id", Order = 0)]
        public string Id
        {
            get;
            set;
        }

        [DataMember(Name = ("title"), Order = 1)]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = ("uri"), Order = 2)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = ("sitename"), Order = 3)]
        public string SiteName
        {
            get;
            set;
        }

        [DataMember(Name = ("parentUri"), Order = 4)]
        public string ParentUri
        {
            get;
            set;
        }

        [DataMember(Name = ("closeDate"), Order = 5)]
        public DateTime CloseDate
        {
            get;
            set;
        }

        [DataMember(Name = ("moderationServiceGroup"), Order = 6)]
        public ModerationStatus.ForumStatus ModerationServiceGroup
        {
            get;
            set;
        }

        [DataMember(Name = ("updated"), Order = 7)]
        public DateTimeHelper Updated
        {
            get;
            set;
        }

        [DataMember(Name = ("created"), Order = 8)]
        public DateTimeHelper Created
        {
            get;
            set;
        }

        [DataMember(Name = ("isClosed"), Order = 9)]
        public bool isClosed
        {
            get;
            set;
        }


        [DataMember(Name = ("identityPolicy"), Order = 12)]
        public string identityPolicy
        {
            get;
            set;
        }

        [DataMember(Name = ("allowNotSignedInCommenting"), Order = 13)]
        public bool allowNotSignedInCommenting
        {
            get;
            set;
        }

        public int NotSignedInUserId = 0;

        /// <summary>
        ///  can read the forum
        /// </summary>
        public bool CanRead = true;

        /// <summary>
        /// can write to the forum
        /// </summary>
        public bool CanWrite = true;

        /// <summary>
        /// the forum internal ID
        /// </summary>
        [DataMember(Name = ("forumId"), Order = 14)]
        public int ForumID = 0;

        /// <summary>
        /// This is the last update of the forum
        /// </summary>
        public DateTime LastUpdate;

    }
}
