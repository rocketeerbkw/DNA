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
    [XmlType(AnonymousType = true, TypeName = "THREAD")]
    [DataContract(Name = "postThreadInfo")]
    public partial class PostThreadInfo
    {
        #region Properties

        [XmlAttribute(AttributeName = "FORUMID")]
        [DataMember(Name = "forumId", Order = 1)]
        public int ForumId { get; set; }

        [XmlAttribute(AttributeName = "THREADID")]
        [DataMember(Name = "threadId", Order = 2)]
        public long ThreadId { get; set; }

        [XmlAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type", Order = 3)]
        public int Type { get; set; }

        [XmlAttribute(AttributeName = "FIRSTPOSTID")]
        [DataMember(Name = "firstPostId", Order = 4)]
        public int FirstPostId { get; set; }

        [XmlElement(Order = 1, ElementName = "DATEFIRSTPOSTED")]
        [DataMember(Name = "dateFirstPosted", Order = 5)]
        public DateElement DateFirstPosted { get; set; }

        [XmlElement(Order = 2, ElementName = "REPLYDATE")]
        [DataMember(Name = "replyDate", Order = 6)]
        public DateElement ReplyDate { get; set; }

        [XmlElement(Order = 3, ElementName = "SUBJECT")]
        [DataMember(Name = "subject", Order = 7)]
        public string Subject { get; set; }

        [XmlElement(Order = 4, ElementName = "FORUMTITLE")]
        [DataMember(Name = "forumTitle", Order = 8)]
        public string ForumTitle { get; set; }

        [XmlElement(Order = 5, ElementName = "JOURNAL")]
        [DataMember(Name = "journal", Order = 9)]
        public UserElement Journal { get; set; }

        #endregion

        public static PostThreadInfo CreatePostThreadInfoFromReader(IDnaDataReader reader)
        {
            PostThreadInfo postThreadInfo = new PostThreadInfo();
            postThreadInfo.ForumId = reader.GetInt32NullAsZero("ForumId");
            postThreadInfo.ThreadId = reader.GetInt32NullAsZero("ThreadId");
            string type = reader.GetStringNullAsEmpty("Type");
            if (type == "")
            {
                postThreadInfo.Type = 0;
            }
            else if (type == "Notice")
            {
                postThreadInfo.Type = 1;
            }
            else if (type == "Event")
            {
                postThreadInfo.Type = 2;
            }
            else 
            {
                postThreadInfo.Type = 3;
            }

            if (reader.DoesFieldExist("FirstPostId"))
            {
                postThreadInfo.FirstPostId = reader.GetInt32NullAsZero("FirstPostId");
            }
            if (reader["DateFirstPosted"] != DBNull.Value)
            {
                postThreadInfo.DateFirstPosted = new DateElement(reader.GetDateTime("DateFirstPosted"));
            }
            if (reader["LastReply"] != DBNull.Value)
            {
                postThreadInfo.ReplyDate = new DateElement(reader.GetDateTime("LastReply"));
            }

            postThreadInfo.Subject = reader.GetStringNullAsEmpty("FirstSubject");
            postThreadInfo.ForumTitle = reader.GetStringNullAsEmpty("ForumTitle");
            if (reader.DoesFieldExist("JournalUserID"))
            {
                postThreadInfo.Journal = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "Journal") };
            }
            return postThreadInfo;
        }
    }
}
