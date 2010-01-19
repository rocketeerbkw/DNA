using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "THREAD")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "THREAD")]
    public partial class ThreadSummary
    {
        #region Properties

        private int threadId = 0;
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "THREADID")]
        public int ThreadId
        {
            get { return threadId; }
            set { threadId = value; }
        }

        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREADID")]
        public int ThreadId1
        {
            get { return threadId; }
            set { threadId = value; }
        }

        /// <remarks/>


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "SUBJECT")]
        public string Subject
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "DATEPOSTED")]
        public DateElement DateLastPosted
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "TOTALPOSTS")]
        public int TotalPosts
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "TYPE")]
        public string Type
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "FIRSTPOST")]
        public ThreadPostSummary FirstPost
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "LASTPOST")]
        public ThreadPostSummary LastPost
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "INDEX")]
        public int Index
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "CANREAD")]
        public byte CanRead
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "CANWRITE")]
        public byte CanWrite
        {
            get;
            set;
        }

        #endregion

        /// <summary>
        /// Apply any user settings required. 
        /// This should be called after object is filled with factory or retrieved from cache
        /// </summary>
        /// <param name="user">The viewing user</param>
        /// <param name="site">The current site</param>
        public void ApplyUserSettings(IUser user, ISite site)
        {
            bool isEditor = false;
            if (user.IsEditor || user.IsSuperUser)
            {//default as editor or super user
                CanRead = 1;
                CanWrite = 1;
                isEditor = true;
            }
            //check site is open
            if (!isEditor && CanWrite == 1)
            {
                if (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now))
                {
                    CanWrite = 0;
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        public static ThreadSummary CreateThreadSummaryFromReader(IDnaDataReader reader, int forumId, int index)
        {
            ThreadSummary thread= new ThreadSummary();
            thread.ForumId = forumId;
            thread.Index = index;
            thread.Type = string.Empty;//TODO: remove as this is a legacy ripley element
            thread.CanRead = (byte)(reader.GetBoolean("ThisCanRead") ? 1 : 0);
            thread.CanWrite = (byte)(reader.GetBoolean("ThisCanWrite") ? 1 : 0);
            thread.ThreadId = reader.GetInt32NullAsZero("ThreadID");
            thread.Subject = StringUtils.EscapeAllXml(reader.GetString("FirstSubject"));
            thread.DateLastPosted = new DateElement(reader.GetDateTime("LastPosted"));
            thread.TotalPosts = reader.GetInt32NullAsZero("cnt");
            thread.FirstPost = ThreadPostSummary.CreateThreadPostFromReader(reader, "FirstPost", reader.GetInt32NullAsZero("firstpostentryid"));
            thread.LastPost = ThreadPostSummary.CreateThreadPostFromReader(reader, "LastPost", reader.GetInt32NullAsZero("lastpostentryid"));
            return thread;
        }
    }
}
