using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.SocialAPI
{
    //[KnownType(typeof(BuzzTwitterProfile))]
    //[Serializable]
    [DataContract(Name = "profile", Namespace = "BBC.Dna.SocialAPI")]
    public class BuzzTwitterProfile
    {
        [DataMember(Name = ("type"))]
        public string SiteURL { get; set; }

        [DataMember (Name = ("users"))]
        public List<string> Users { get; set; }

        [DataMember (Name = ("profileId"))]
        public string ProfileId { get; set; }

        [DataMember(Name = ("keywords"))]
        public List<string> SearchKeywords { get; set; }

        [DataMember(Name = ("profileCountEnabled"))]
        public bool? ProfileCountEnabled { get; set; }

        [DataMember (Name = ("profileKeywordCountEnabled"))]
        public bool? ProfileKeywordCountEnabled { get; set; }

        [DataMember (Name = ("moderationEnabled"))]
        public bool? ModerationEnabled { get; set; }

        [DataMember (Name = ("trustedUsersEnabled"))]
        public bool? TrustedUsersEnabled { get; set; }

        /*[DataMember (Name = ("active"))]
        public bool? Active { get; set; }

        [DataMember (Name = ("id"))]
        public string Id { get; set; }

        [DataMember (Name = ("version"))]
        public int version { get; set; }*/
    }
}
