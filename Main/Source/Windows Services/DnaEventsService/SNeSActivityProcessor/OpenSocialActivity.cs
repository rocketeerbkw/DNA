using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace Dna.SnesIntegration.ActivityProcessor
{
    [DataContract]
    public class OpenSocialActivity
    {
        [DataMember(Name = "title")]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = "body")]
        public string Body
        {
            get;
            set;
        }

        [DataMember(Name = "url")]
        public string Url
        {
            get;
            set;
        }

        [DataMember(Name = "postedTime")]
        public long PostedTime
        {
            get;
            set;
        }

        [DataMember(Name = "type")]
        public string Type
        {
            get;
            set;
        }

        [DataMember(Name = "displayName")]
        public string DisplayName
        {
            get;
            set;
        }

        [DataMember(Name = "objectTitle")]
        public string ObjectTitle
        {
            get;
            set;
        }

        [DataMember(Name = "objectDescription")]
        public string ObjectDescription
        {
            get;
            set;
        }

        [DataMember(Name = "username")]
        public string Username
        {
            get;
            set;
        }

        [DataMember(Name = "objectUri")]
        public string ObjectUri
        {
            get;
            set;
        }

        [DataMember(Name = "id", IsRequired = false, EmitDefaultValue = false)]
        public string Id
        {
            get; set;
        }
    }

    [DataContract]
    public class OpenSocialActivities
    {
        [DataMember(Name = "startIndex")]
        public long StartIndex
        {
            get; set;
        }

        [DataMember(Name = "totalResults")]
        public long TotalResults
        {
            get; set;
        }

        [DataMember(Name = "itemsPerPage")]
        public long ItemsPerPage
        {
            get; set;
        }

        [DataMember(Name = "entry")]
        public Collection<OpenSocialActivity> Entries
        {
            get; set;
        }
    }
}
