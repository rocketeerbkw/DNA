using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using ISite = BBC.Dna.Sites.ISite;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "THREAD")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "THREAD")]
    [DataContract(Name="threadSummary")]
    public class ThreadSummary
    {
        #region Properties

        private int _threadId;

        [XmlElement(Order = 0, ElementName = "THREADID")]
        [DataMember(Name = ("threadId"))]
        public int ThreadId
        {
            get { return _threadId; }
            set { _threadId = value; }
        }

        [XmlAttribute(AttributeName = "THREADID")]
        public int ThreadId1
        {
            get { return _threadId; }
            set { _threadId = value; }
        }

        /// <remarks/>
        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "SUBJECT")]
        [DataMember(Name = ("subject"))]
        public string Subject { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "DATEPOSTED")]
        [DataMember(Name = ("dateLastPosted"))]
        public DateElement DateLastPosted { get; set; }

        /// <remarks/>
        [XmlElement(Order = 3, ElementName = "TOTALPOSTS")]
        [DataMember(Name = ("totalPosts"))]
        public int TotalPosts { get; set; }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "TYPE")]
        [DataMember(Name = ("type"))]
        public string Type { get; set; }

        /// <remarks/>
        [XmlElement(Order = 5, ElementName = "FIRSTPOST")]
        [DataMember(Name = ("firstPost"))]
        public ThreadPostSummary FirstPost { get; set; }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "LASTPOST")]
        [DataMember(Name = ("lastPost"))]
        public ThreadPostSummary LastPost { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "FORUMID")]
        public int ForumId { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "INDEX")]
        public int Index { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANREAD")]
        public byte CanRead { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canRead"))]
        public bool CanReadBool
        {
            get { return CanRead == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canWrite"))]
        public bool CanWriteBool
        {
            get { return CanWrite == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "ISSTICKY")]
        [DataMember(Name = ("isSticky"))]
        public bool IsSticky { get; set; }

        #endregion

        /// <summary>
        /// Apply any user settings required. 
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        /// <param name="user">The viewing user</param>
        /// <param name="site">The current site</param>
        public void ApplyUserSettings(IUser user, ISite site)
        {
            if (user.IsEditor || user.IsSuperUser)
            {
                return;
            }
            //check site is open
            if (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now))
            {
                CanWrite = 0;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="forumId"></param>
        /// <param name="index"></param>
        /// <returns></returns>
        public static ThreadSummary CreateThreadSummaryFromReader(IDnaDataReader reader, int forumId, int index)
        {
            var thread = new ThreadSummary();
            thread.ForumId = forumId;
            thread.Index = index;
            thread.Type = string.Empty; //TODO: remove as this is a legacy ripley element
            thread.CanRead = (byte) (reader.GetBoolean("ThisCanRead") ? 1 : 0);
            thread.CanWrite = (byte) (reader.GetBoolean("ThisCanWrite") ? 1 : 0);
            thread.ThreadId = reader.GetInt32NullAsZero("ThreadID");
            thread.Subject = StringUtils.EscapeAllXml(reader.GetString("FirstSubject"));
            thread.DateLastPosted = new DateElement(reader.GetDateTime("LastPosted"));
            thread.TotalPosts = reader.GetInt32NullAsZero("cnt");
            thread.FirstPost = ThreadPostSummary.CreateThreadPostFromReader(reader, "FirstPost",
                                                                            reader.GetInt32NullAsZero("firstpostentryid"));
            thread.LastPost = ThreadPostSummary.CreateThreadPostFromReader(reader, "LastPost",
                                                                           reader.GetInt32NullAsZero("lastpostentryid"));
            if(reader.DoesFieldExist("IsSticky"))
            {//conditionally check if field exists..
                thread.IsSticky = (reader.GetInt32NullAsZero("IsSticky")==1);
            }
            return thread;
        }
    }
}