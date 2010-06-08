using System.Xml;
using BBC.Dna.Utils;
using System;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;


namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "POST")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "POST")]
    [DataContract(Name="threadPost")]
    public partial class ThreadPost
    {
        #region Properties
        /// <remarks/>
        private string _subject = String.Empty;
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get {
                return _subject;
                    
                }
            set {
                if (_hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration || _hidden == CommentStatus.Hidden.Hidden_AwaitingReferral) // 3 means premoderated! - hidden!
                {
                    _subject =  "Hidden";
                }
                else if (_hidden != CommentStatus.Hidden.NotHidden)
                {
                    _subject =  "Removed";
                }
                else
                {
                    _subject =  StringUtils.EscapeAllXml(value);
                }
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "DATEPOSTED")]
        [DataMember(Name = "datePosted")]
        public DateElement DatePosted
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "LASTUPDATED")]
        public DateElement LastUpdated
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "USER")]
        [DataMember(Name = "user")]
        public User User
        {
            get;
            set;
        }

        /// <remarks/>
        private bool _formattedText = false;
        private string _text="";
        [XmlIgnore]
        [DataMember(Name = ("text"))]
        public string Text
        {
            get
            {
                return _text;
            }
            set
            {
                _text = value;
            }
        }

        [System.Xml.Serialization.XmlAnyElement(Order = 4)]
        public XmlElement TextElement
        {
            get
            {
                XmlDocument doc = new XmlDocument();
                try
                {
                    doc.LoadXml("<TEXT>" + _text + "</TEXT>");
                }
                catch
                {
                    doc.LoadXml("<TEXT/>");
                    doc.DocumentElement.InnerText = _text;
                }
                return doc.DocumentElement;
            }
            set { }
        }

        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "HOSTPAGEURL")]
        public string HostPageUrl
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "COMMENTFORUMTITLE")]
        public string CommentForumTitle
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "POSTID")]
        [DataMember(Name = "postId")]
        public int PostId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREAD")]
        [DataMember(Name = "threadId")]
        public int ThreadId
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool ThreadIdSpecified { get { return this.ThreadId != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "INDEX")]
        [DataMember(Name = "index")]
        public byte Index
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FIRSTCHILD")]
        [DataMember(Name = "firstChild")]
        public int FirstChild
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool FirstChildSpecified { get { return this.FirstChild != 0; } }

        /// <remarks/>
        private CommentStatus.Hidden _hidden = CommentStatus.Hidden.NotHidden;
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "HIDDEN")]
        [DataMember(Name = "status")]
        public byte Hidden
        {
            get {return (byte)_hidden; }
            set { _hidden = (CommentStatus.Hidden)value; }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "EDITABLE")]
        public byte Editable
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "NEXTINDEX")]
        [DataMember(Name = "nextIndex")]
        public int NextIndex
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool NextIndexSpecified { get { return this.NextIndex != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "INREPLYTO")]
        [DataMember(Name = "inReplyTo")]
        public int InReplyTo
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool InReplyToSpecified { get { return this.InReplyTo != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "INREPLYTOINDEX")]
        [DataMember(Name = "inReplyToIndex")]
        public int InReplyToIndex
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool InReplyToIndexSpecified { get { return this.InReplyTo != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "NEXTSIBLING")]
        [DataMember(Name = "nextSibling")]
        public int NextSibling
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool NextSiblingSpecified { get { return this.NextSibling != 0; } }


        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "PREVINDEX")]
        [DataMember(Name = "prevIndex")]
        public int PrevIndex
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool PrevIndexSpecified { get { return this.PrevIndex != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "PREVSIBLING")]
        [DataMember(Name = "prevSibling")]
        public int PrevSibling
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool PrevSiblingSpecified { get { return this.PrevSibling != 0; } }


        /// <summary>
        /// The post style 
        ///     unknown=0,
        ///     richtext = 1,
        ///     plaintext = 2,
        /// </summary>
        [System.Xml.Serialization.XmlIgnore]
        [DataMember(Name = "style")]
        public PostStyle.Style Style
        {
            get;
            set;
        }
        
        #endregion

        /// <summary>
        /// Formats the post
        /// </summary>
        /// <param name="inputText"></param>
        /// <returns></returns>
        static public string FormatPost(string inputText, CommentStatus.Hidden hidden)
        {
            if (hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration || hidden == CommentStatus.Hidden.Hidden_AwaitingReferral) // 3 means premoderated! - hidden!
            {
                return "This post has been hidden.";
            }
            else if (hidden != CommentStatus.Hidden.NotHidden)
            {
                return "This post has been removed.";
            }

            inputText = Translator.TranslateText(inputText);
            inputText = HtmlUtils.ReplaceCRsWithBRs(inputText);

            return inputText;

        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="postId"></param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromDatabase(IDnaDataReaderCreator readerCreator, int postId)
        {
            using(IDnaDataReader reader = readerCreator.CreateDnaDataReader("getpostsinthread"))
            {
                reader.AddParameter("postid", postId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    return ThreadPost.CreateThreadPostFromReader(reader, postId);
                }
                else
                {
                    throw new Exception("Invalid post id");
                }
            }
        }


        /// <summary>
        /// Creates a threadpost from a given reader
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromReader(IDnaDataReader reader, int postId)
        {
            return ThreadPost.CreateThreadPostFromReader(reader, String.Empty, postId);
        }

        /// <summary>
        /// Creates a threadpost from a given reader
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="prefix">The data base name prefix</param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromReader(IDnaDataReader reader, string prefix, int postId)
        {
            ThreadPost post = new ThreadPost() { PostId = postId };
            if (reader.DoesFieldExist(prefix +"threadid"))
            {
                post.ThreadId = reader.GetInt32NullAsZero(prefix +"threadid");
            }
            if (reader.DoesFieldExist(prefix +"parent"))
            {
                post.InReplyTo = reader.GetInt32NullAsZero(prefix +"parent");
            }

            if (reader.DoesFieldExist(prefix +"replypostindex"))
            {
                post.InReplyToIndex = reader.GetInt32NullAsZero(prefix + "replypostindex");
            }

            
            if (reader.DoesFieldExist(prefix +"prevSibling"))
            {
                post.PrevSibling = reader.GetInt32NullAsZero(prefix +"prevSibling");
            }
            if (reader.DoesFieldExist(prefix +"nextSibling"))
            {
                post.NextSibling = reader.GetInt32NullAsZero(prefix +"nextSibling");
            }
            if (reader.DoesFieldExist(prefix +"firstChild"))
            {
                post.FirstChild = reader.GetInt32NullAsZero(prefix +"firstChild");
            }
            if (reader.DoesFieldExist(prefix +"hidden"))
            {
                post.Hidden = (byte)(reader.GetInt32NullAsZero(prefix +"hidden") == 1?1:0);
            }
            if (reader.DoesFieldExist(prefix +"subject"))
            {
                post.Subject = reader["subject"] as string;
            }
            if (reader.DoesFieldExist(prefix + "datePosted") && reader[prefix + "datePosted"] != DBNull.Value)
            {
                post.DatePosted = new DateElement(reader.GetDateTime(prefix + "datePosted".ToString()));
            }
            if (reader.DoesFieldExist(prefix +"postStyle"))
            {
                post.Style = (PostStyle.Style)reader.GetByteNullAsZero(prefix + "postStyle");
            }
            if (reader.DoesFieldExist(prefix +"text"))
            {
                post.Text = ThreadPost.FormatPost(reader.GetStringNullAsEmpty(prefix + "text"), (CommentStatus.Hidden)post.Hidden);
            }
            if (reader.DoesFieldExist(prefix +"hostpageurl"))
            {
                post.HostPageUrl = reader.GetStringNullAsEmpty(prefix + "hostpageurl");
            }
            if (reader.DoesFieldExist(prefix +"commentforumtitle"))
            {
                post.CommentForumTitle = reader.GetStringNullAsEmpty(prefix + "commentforumtitle");
            }

            post.User = BBC.Dna.Objects.User.CreateUserFromReader(reader);

            #region Depreciated code
            /*
             * This code has been depreciated from forum.cpp ln 1066 as the functionality is no longer in use.
             // Add the event date if it has one!
		        bOk = bOk && AddDBXMLDateTag("eventdate",NULL,false,true);

		        // Get the Type of post we're looking at
		        bOk = bOk && AddDBXMLTag("type",NULL,false,true,&sPostType);

		        // Now see if we are an event or notice, if so put the taginfo in for the post
		        if (sPostType.CompareText("Notice") || sPostType.CompareText("Event"))
		        {
			        // We've got a notice or event! Get all the tag info
			        CTagItem TagItem(m_InputContext);
			        if (TagItem.InitialiseFromThreadId(ThreadID,m_SiteID,pViewer) && TagItem.GetAllNodesTaggedForItem())
			        {
				        TagItem.GetAsString(sPosts);
			        }
		        }
             */
            
            #endregion

            return post;
        }

    }
}
