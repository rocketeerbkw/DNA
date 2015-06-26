using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.SocialAPI
{
    [DataContract(Name = "user", Namespace = "")]
    public class TweetUser
    {
        [DataMember(Name = ("name"))]
        public string Name { get; set; }

        [DataMember(Name = ("screen_name"))]
        public string ScreenName { get; set; }

        [DataMember(Name = ("profile_image_url"))]
        public string ProfileImageUrl { get; set; }

        [DataMember(Name = ("id"))]
        public string id { get; set; }

        [DataMember(Name = ("location"))]
        public string Location { get; set; }

        [DataMember(Name = ("description"))]
        public string Description { get; set; }
    }
}
