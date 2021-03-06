﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Api.Contracts
{
    [Serializable]
    [DataContract(Name = "commentForum", Namespace = "BBC.Dna.Api")]
    public class CommentForumActivity
    {
        [DataMember(Name = "totalPosts", Order = 1)]
        public int TotalPosts
        {
            get;
            set;
        }

        [DataMember(Name = "count", Order = 2)]
        public int Count
        {
            get;
            set;
        }

        [DataMember(Name = "url", Order = 3)]
        public string URL
        {
            get;
            set;
        }

        [DataMember(Name = "title", Order = 4)]
        public string Title
        {
            get;
            set;
        }

        [DataMember(Name = "siteId", Order = 5)]
        public int SiteId
        {
            get;
            set;
        }

        [DataMember(Name = "siteName", Order = 6)]
        public string SiteName
        {
            get;
            set;
        }

        [DataMember(Name = "closingdate", Order = 7)]
        public DateTimeHelper ClosingDate
        {
            get;
            set;
        }

        [DataMember(Name = "lastPostedDate", Order = 8)]
        public DateTimeHelper LastPostedDate
        {
            get;
            set;
        }
    }
}
