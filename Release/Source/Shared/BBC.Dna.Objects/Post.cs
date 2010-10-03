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

        [XmlAttribute(AttributeName = "EDITABLE")]
        [DataMember(Name = "editable", Order = 2)]
        public long Editable { get; set; }

        [XmlAttribute(AttributeName = "PRIVATE")]
        [DataMember(Name = "private", Order = 3)]
        public int Private { get; set; }

        [XmlElement(Order = 1, ElementName = "SITEID")]
        [DataMember(Name = "siteId", Order = 4)]
        public int SiteId { get; set; }

        [XmlElement(Order = 2, ElementName = "HAS-REPLY")]
        [DataMember(Name = "hasReply", Order = 5)]
        public int HasReply { get; set; }

        [XmlElement(Order = 3, ElementName = "THREAD")]
        [DataMember(Name = "thread", Order = 6)]
        public PostThreadInfo Thread { get; set; }

        [XmlElement(Order = 4, ElementName = "FIRSTPOSTER")]
        [DataMember(Name = "firstPoster", Order = 7)]
        public UserElement FirstPoster { get; set; }

        [XmlElement(Order = 5, ElementName = "YOURLASTPOST")]
        [DataMember(Name = "yourLastPost", Order = 8)]
        public int YourLastPost { get; set; }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "MOSTRECENT")]
        [DataMember(Name = "mostRecent", Order = 9)]
        public DateElement MostRecent { get; set; }

        /// <remarks/>
        [XmlElement(Order = 7, ElementName = "LASTREPLY")]
        [DataMember(Name = "lastReply", Order = 10)]
        public DateElement LastReply { get; set; }

        #endregion

        public static Post CreatePostFromReader(IDnaDataReader reader)
        {
            Post post = new Post();
            post.YourLastPost = reader.GetInt32NullAsZero("YourLastPost");
            post.CountPosts = reader.GetInt32NullAsZero("CountPosts");

            post.Thread = PostThreadInfo.CreatePostThreadInfoFromReader(reader);

            post.MostRecent = new DateElement(reader.GetDateTime("MostRecent"));

            post.LastReply = new DateElement(reader.GetDateTime("LastReply"));

            post.SiteId = reader.GetInt32NullAsZero("SiteId");

            post.Private = reader.GetInt32NullAsZero("Private");
            post.HasReply = reader.GetInt32NullAsZero("Replies");

            post.FirstPoster = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "FirstPoster") };
            return post;
        }
    }
}