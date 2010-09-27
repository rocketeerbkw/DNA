using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using BBC.Dna.Utils;

namespace Dna.SnesIntegration.ActivityProcessor.Contracts
{
    [DataContract]
    public class OpenSocialActivity
    {
        private const int MaxChars = 511;

        [DataMember(Name = "title")]
        public string Title
        {
            get;
            set;
        }

        private string _body = string.Empty;
        [DataMember(Name = "body")]
        public string Body
        {
            get{ return _body;}
            set { _body = value.FormatBody(); }
        }

        [DataMember(Name = "url")]
        public Uri Url
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
        public string ActivityType
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

        private string _objectDescription = string.Empty;
        [DataMember(Name = "objectDescription")]
        public string ObjectDescription
        {
             get{ return _objectDescription;}
            set { _objectDescription = value.FormatBody(); }
        }

        [DataMember(Name = "username")]
        public string UserName
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
            get;
            set;
        }

        [DataMember(Name = "level")]
        public string Level
        {
            get{ return "PUBLIC";}
            set { }
        }

        public string ContentPermaUrl
        { get; set; }

        public string CustomActivityType
        { get; set; }
            
    }

    [DataContract]
    public class OpenSocialActivities
    {
        [DataMember(Name = "startIndex")]
        public long StartIndex
        {
            get;
            set;
        }

        [DataMember(Name = "totalResults")]
        public long TotalResults
        {
            get;
            set;
        }

        [DataMember(Name = "itemsPerPage")]
        public long ItemsPerPage
        {
            get;
            set;
        }

        [DataMember(Name = "entry")]
        public Collection<OpenSocialActivity> Entries
        {
            get;
            set;
        }
    }
}


