using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;
using System.Data;
using System.Data.SqlClient;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "POST")]
    [DataContract(Name = "post")]
    public partial class Post
    {
        #region Properties

        [XmlAttribute(AttributeName = "COUNTPOSTS")]
        [DataMember(Name = "countPosts", Order = 1)]
        public int CountPosts { get; set; }

        [XmlAttribute(AttributeName = "LASTPOSTCOUNTREAD")]
        [DataMember(Name = "lastPostCountRead", Order = 2)]
        public int LastPostCountRead { get; set; }

        [XmlAttribute(AttributeName = "EDITABLE")]
        [DataMember(Name = "editable", Order = 3)]
        public long Editable { get; set; }

        [XmlAttribute(AttributeName = "PRIVATE")]
        [DataMember(Name = "private", Order = 4)]
        public int Private { get; set; }

        [XmlElement(Order = 1, ElementName = "SITEID")]
        [DataMember(Name = "siteId", Order = 5)]
        public int SiteId { get; set; }

        [XmlElement(Order = 2, ElementName = "HAS-REPLY")]
        [DataMember(Name = "hasReply", Order = 6)]
        public int HasReply { get; set; }

        [XmlElement(Order = 3, ElementName = "THREAD")]
        [DataMember(Name = "thread", Order = 7)]
        public PostThreadInfo Thread { get; set; }

        [XmlElement(Order = 4, ElementName = "FIRSTPOSTER")]
        [DataMember(Name = "firstPoster", Order = 8)]
        public UserElement FirstPoster { get; set; }

        [XmlElement(Order = 5, ElementName = "YOURLASTPOST")]
        [DataMember(Name = "yourLastPost", Order = 9)]
        public int YourLastPost { get; set; }

        [XmlElement(Order = 6, ElementName = "YOURLASTPOSTINDEX")]
        [DataMember(Name = "yourLastPostIndex", Order = 10)]
        public int YourLastPostIndex { get; set; }

        /// <remarks/>
        [XmlElement(Order = 7, ElementName = "MOSTRECENT")]
        [DataMember(Name = "mostRecent", Order = 11)]
        public DateElement MostRecent { get; set; }

        /// <remarks/>
        [XmlElement(Order = 8, ElementName = "LASTREPLY")]
        [DataMember(Name = "lastReply", Order = 12)]
        public DateElement LastReply { get; set; }

        #endregion

        public static Post CreatePostFromReader(IDnaDataReader reader)
        {
            Post post = new Post();
            post.YourLastPost = reader.GetInt32NullAsZero("YourLastPost");
            post.YourLastPostIndex = reader.GetInt32NullAsZero("YourLastPostIndex");
            post.CountPosts = reader.GetInt32NullAsZero("CountPosts");

            post.Thread = PostThreadInfo.CreatePostThreadInfoFromReader(reader);
            if (reader["LastReply"] != DBNull.Value)
            {
                post.LastReply = new DateElement(reader.GetDateTime("LastReply"));
            }
            if (post.YourLastPost > 0)
            {
                if (reader["MostRecent"] != DBNull.Value)
                {
                    post.MostRecent = new DateElement(reader.GetDateTime("MostRecent"));
                }
            }

            post.SiteId = reader.GetInt32NullAsZero("SiteId");

            post.Private = reader.GetInt32NullAsZero("Private");
            post.HasReply = reader.GetInt32NullAsZero("Replies");

            post.FirstPoster = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "FirstPoster") };
            return post;
        }
    }
}