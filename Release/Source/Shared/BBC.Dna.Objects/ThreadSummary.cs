using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using ISite = BBC.Dna.Sites.ISite;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "THREAD")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "THREAD")]
    public class ThreadSummary
    {
        #region Properties

        private int _threadId;

        [XmlElement(Order = 0, ElementName = "THREADID")]
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
        public string Subject { get; set; }

        /// <remarks/>
        [XmlElement(Order = 2, ElementName = "DATEPOSTED")]
        public DateElement DateLastPosted { get; set; }

        /// <remarks/>
        [XmlElement(Order = 3, ElementName = "TOTALPOSTS")]
        public int TotalPosts { get; set; }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "TYPE")]
        public string Type { get; set; }

        /// <remarks/>
        [XmlElement(Order = 5, ElementName = "FIRSTPOST")]
        public ThreadPostSummary FirstPost { get; set; }

        /// <remarks/>
        [XmlElement(Order = 6, ElementName = "LASTPOST")]
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

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "ISSTICKY")]
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
            var isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {
//default as editor or super user
                CanRead = 1;
                CanWrite = 1;
                isEditor = true;
            }
            //check site is open
            if (isEditor || CanWrite != 1) return;
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