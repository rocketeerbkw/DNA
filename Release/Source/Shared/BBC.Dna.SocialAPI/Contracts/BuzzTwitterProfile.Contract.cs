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
        private bool? _isProfileCountEnabled;
        private bool? _isProfileKeywordCountEnabled;
        private bool? _isModerationEnabled;
        private bool? _isTrustedUsersEnabled;

        [DataMember(Name = ("type"))]
        public string SiteURL { get; set; }

        [DataMember (Name = ("users"))]
        public List<string> Users { get; set; }

        [DataMember (Name = ("profileId"))]
        public string ProfileId { get; set; }

        [DataMember(Name = ("keywords"))]
        public List<string> SearchKeywords { get; set; }

        [DataMember(Name = ("profileCountEnabled"))]
        public bool? ProfileCountEnabled 
        { 
            get
            {
                if (false == _isProfileCountEnabled.HasValue)
                {
                    return false;
                }
                else
                {
                    return _isProfileCountEnabled.Value;
                }
            }
            set
            {
                _isProfileCountEnabled = value;
            }
        }

        [DataMember (Name = ("profileKeywordCountEnabled"))]
        public bool? ProfileKeywordCountEnabled 
        { 
            get
            {
                if (false == _isProfileKeywordCountEnabled.HasValue)
                {
                    return false;
                }
                else
                {
                    return _isProfileKeywordCountEnabled.Value;
                }
            }
            set
            {
                _isProfileKeywordCountEnabled = value;
            }
        }

        [DataMember (Name = ("moderationEnabled"))]
        public bool? ModerationEnabled 
        {
            get
            {
                if (false == _isModerationEnabled.HasValue)
                {
                    return false;
                }
                else
                {
                    return _isModerationEnabled.Value;
                }
            }
            set
            {
                _isModerationEnabled = value;
            }
        }

        [DataMember (Name = ("trustedUsersEnabled"))]
        public bool? TrustedUsersEnabled 
        {
            get
            {
                if (false == _isTrustedUsersEnabled.HasValue)
                {
                    return false;
                }
                else
                {
                    return _isTrustedUsersEnabled.Value;
                }
            }
            set
            {
                _isTrustedUsersEnabled = value;
            }
        }

        /*[DataMember (Name = ("active"))]
        public bool? Active { get; set; }

        [DataMember (Name = ("id"))]
        public string Id { get; set; }

        [DataMember (Name = ("version"))]
        public int version { get; set; }*/
    }
}
