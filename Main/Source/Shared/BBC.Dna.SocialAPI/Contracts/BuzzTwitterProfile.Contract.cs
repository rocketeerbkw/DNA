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
        public string[] Users { get; set; }

        [DataMember (Name = ("profileId"))]
        public string ProfileId { get; set; }

        [DataMember(Name = ("keywords"))]
        public string[] SearchKeywords { get; set; }

        [DataMember(Name = ("profileCountEnabled"))]
        public string ProfileCountEnabled { get; set; }

        [DataMember (Name = ("profileKeywordCountEnabled"))]
        public string ProfileKeywordCountEnabled { get; set; }

        [DataMember (Name = ("moderationEnabled"))]
        public string ModerationEnabled { get; set; }

        [DataMember (Name = ("truestedUsersEnabled"))]
        public string TrustedUsersEnabled { get; set; }

        [DataMember (Name = ("active"))]
        public string Active { get; set; }

        /*[DataMember (Name = ("id"))]
        public string Id { get; set; }

        [DataMember (Name = ("version"))]
        public int version { get; set; }*/
    }
}
