using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(TweetUser))]
    [Serializable]
    [DataContract(Name = "user", Namespace = "BBC.Dna.Api")]
    public class TweetUser
    {
        [DataMember(Name = ("name"))]
        public string Name;

        [DataMember(Name = ("screen_name"))]
        public string ScreenName;

        [DataMember(Name = ("profile_image_url"))]
        public string ProfileImageUrl;

        [DataMember(Name = ("id"))]
        public string id;
    }
}
