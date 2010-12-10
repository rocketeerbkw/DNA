using System.Xml;
using BBC.Dna.Utils;
using System;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Api;
using BBC.Dna.Common;
using System.Configuration;

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
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get;
            set;
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
                return HtmlUtils.ParseHtmlToXmlElement(_text, "text");
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
        public int Index
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

        public ThreadPost()
        {
        }

        /// <summary>
        /// Formats the post
        /// </summary>
        /// <param name="inputText"></param>
        /// <param name="hidden"></param>
        /// <param name="cleanHTMLTags"></param>
        /// <param name="applySkin"></param>
        /// <returns></returns>
        static public string FormatPost(string inputText, CommentStatus.Hidden hidden, bool cleanHTMLTags, bool applySkin)
        {
            if (hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration || hidden == CommentStatus.Hidden.Hidden_AwaitingReferral) // 3 means premoderated! - hidden!
            {
                return "This post has been hidden.";
            }
            else if (hidden != CommentStatus.Hidden.NotHidden)
            {
                return "This post has been removed.";
            }

            //strip invalid xml chars
            inputText = StringUtils.StripInvalidXmlChars(inputText);

            //converts all tags to &gt; or &lt;
            inputText = StringUtils.EscapeAllXml(inputText);


            // Perform Smiley Translations
            inputText = SmileyTranslator.TranslateText(inputText);

            // Quote translator.
            inputText = QuoteTranslator.TranslateText(inputText);

            if (cleanHTMLTags)
            {
                //Remove bad html tags and events
                inputText = HtmlUtils.CleanHtmlTags(inputText, true, true);
            }

            // Expand Links 
            //Note this must happen after removal because <LINK>s will be removed in the CleanHtmlTags call 
            inputText = LinkTranslator.TranslateTextLinks(inputText);

            //convert BRs to CRs
            inputText = HtmlUtils.ReplaceCRsWithBRs(inputText);

            if (applySkin)
            {
                string apiGuideSkin = ConfigurationSettings.AppSettings["guideMLXSLTSkinPath"];
                string startH2G2Post = "<H2G2POST>";
                string endH2G2Post = "</H2G2POST>";

                int errorCount = 0;
                XmlDocument doc = new XmlDocument();
                doc.PreserveWhitespace = true;

                // reassign string and element after transformation     
                string textAsGuideML = startH2G2Post + inputText + endH2G2Post;
                doc.LoadXml(textAsGuideML);
                
                string transformedContent = XSLTransformer.TransformUsingXslt(apiGuideSkin, doc, ref errorCount);

                // strip out the xml header and namespaces
                transformedContent = transformedContent.Replace(@"<?xml version=""1.0"" encoding=""utf-16""?>", "");
                transformedContent = transformedContent.Replace(@"xmlns=""http://www.w3.org/1999/xhtml""", "");

                if (errorCount != 0)
                {
                    DnaDiagnostics.Default.WriteToLog("FailedTransform", transformedContent);
                    throw new ApiException("GuideML Transform Failed.", ErrorType.GuideMLTransformationFailed);
                }
                inputText = transformedContent;
            }

            return inputText;
        }


        /// <summary>
        /// Formats a subject based on hidden flags etc
        /// </summary>
        /// <param name="inputText"></param>
        /// <param name="hidden"></param>
        /// <returns></returns>
        static public string FormatSubject(string inputText, CommentStatus.Hidden hidden)
        {
            if (hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration || hidden == CommentStatus.Hidden.Hidden_AwaitingReferral) // 3 means premoderated! - hidden!
            {
                return "Hidden";
            }
            if (hidden != CommentStatus.Hidden.NotHidden)
            {
                return "Removed";
            }

            return HtmlUtils.HtmlDecode(HtmlUtils.RemoveAllHtmlTags(inputText));
            

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="postId"></param>
        /// <param name="applySkin"></param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromDatabase(IDnaDataReaderCreator readerCreator, int postId, bool applySkin)
        {
            using(IDnaDataReader reader = readerCreator.CreateDnaDataReader("getpostsinthread"))
            {
                reader.AddParameter("postid", postId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    return ThreadPost.CreateThreadPostFromReader(reader, postId, applySkin);
                }
                else
                {
                    throw new ApiException("Thread post not found.", ErrorType.ThreadPostNotFound);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="postId"></param>
        /// <param name="applySkin"></param>
        /// <returns></returns>
        static public ThreadPost FetchPostFromDatabase(IDnaDataReaderCreator readerCreator, int postId, bool applySkin)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchpostdetails"))
            {
                reader.AddParameter("postid", postId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    return ThreadPost.CreateThreadPostFromReader(reader, postId, applySkin);
                }
                else
                {
                    throw new ApiException("Thread post not found.", ErrorType.ThreadPostNotFound);
                }
            }
        }


        /// <summary>
        /// Creates a threadpost from a given reader
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="postId">postId to get</param>
        /// <param name="applySkin">Whether we need to process the text into html for output</param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromReader(IDnaDataReader reader, int postId, bool applySkin)
        {
            return ThreadPost.CreateThreadPostFromReader(reader, String.Empty, postId, null, applySkin);
        }

        /// <summary>
        /// Creates a threadpost from a given reader
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="prefix">The data base name prefix</param>
        /// <param name="postId">postId to get</param>
        /// <param name="post">The post in question to load with data</param>
        /// <param name="applySkin">Whether we need to process the text into html for output</param>
        /// <returns></returns>
        static public ThreadPost CreateThreadPostFromReader(IDnaDataReader reader, 
                                                            string prefix, 
                                                            int postId, 
                                                            ThreadPost post, 
                                                            bool applySkin)
        {
            if (post == null)
            {
                post = new ThreadPost() { PostId = postId };
            }
            
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

            if (reader.DoesFieldExist(prefix +"postindex"))
            {
                post.Index = reader.GetInt32NullAsZero(prefix + "postindex");
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
                post.Hidden = (byte)reader.GetInt32NullAsZero(prefix +"hidden");
            }
            if (reader.DoesFieldExist(prefix +"subject"))
            {
                post.Subject = FormatSubject(reader.GetStringNullAsEmpty("subject"), (CommentStatus.Hidden)post.Hidden);
            }
            if (reader.DoesFieldExist(prefix + "datePosted") && reader[prefix + "datePosted"] != DBNull.Value)
            {
                post.DatePosted = new DateElement(reader.GetDateTime(prefix + "datePosted".ToString()));
            }
            if (reader.DoesFieldExist(prefix +"postStyle"))
            {
                post.Style =  (PostStyle.Style)reader.GetByteNullAsZero(prefix + "postStyle");
            }
            if (reader.DoesFieldExist(prefix +"text"))
            {
                post.Text = ThreadPost.FormatPost(reader.GetStringNullAsEmpty(prefix + "text"), (CommentStatus.Hidden)post.Hidden, true, applySkin);
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

        /// <summary>
        /// Hides a Thread Post
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="postId"></param>
        /// <param name="hiddenStatus"></param>
        /// <returns></returns>
        static public void HideThreadPost(IDnaDataReaderCreator readerCreator, int postId, BBC.Dna.Moderation.Utils.CommentStatus.Hidden hiddenStatus)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("HidePost"))
            {
                reader.AddParameter("PostID", postId);
                reader.AddParameter("HiddenID", hiddenStatus);
                reader.Execute();
            }
        }

        /// <summary>
        /// Unhides a Thread Post
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="postId"></param>
        /// <returns></returns>
        static public void UnhideThreadPost(IDnaDataReaderCreator readerCreator, int postId)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("UnhidePost"))
            {
                reader.AddParameter("PostID", postId);
                reader.Execute();
            }
        }

        /// <summary>
        /// Prepares all the pre-requisites for a post.
        /// </summary>
        /// <param name="userId"> Post using the specified user.</param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="replyTo"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="postStyle">Th estyle of the post</param>
        /// <param name="ignoreModeration"> Allow automated posts.</param>
        /// <param name="postId"> New postId</param>
        /// <param name="isQueued"> Indicates whether post was Queued</param>
        /// <param name="isPreModPosting"></param>
        /// <param name="isPreModerated"></param>
        public void CreateForumPost(IDnaDataReaderCreator readerCreator, int userid, int forumId, bool ignoreModeration, bool isNotable, string ipAddress, Guid bbcUID, bool isComment, bool allowQueuing, bool forcePreModerate, bool forceModeration)
        {

            String source = this.Subject + "<:>" + this.Text + "<:>" + Convert.ToString(userid) + "<:>" + Convert.ToString(forumId) + "<:>" + Convert.ToString(ThreadId) + "<:>" + Convert.ToString(this.InReplyTo);
            Guid hash = DnaHasher.GenerateHash(source);

            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("posttoforum"))
            {
                dataReader.AddParameter("userid", userid);
                dataReader.AddParameter("forumid", forumId);
                if (this.InReplyTo == 0)
                {
                    dataReader.AddParameter("inreplyto", DBNull.Value);
                }
                else
                {
                    dataReader.AddParameter("inreplyto", this.InReplyTo);
                }                
                dataReader.AddParameter("threadid",  ThreadId);
                dataReader.AddParameter("subject", this.Subject);
                dataReader.AddParameter("content", this.Text);
                dataReader.AddParameter("poststyle", this.Style);
                dataReader.AddParameter("hash", hash);
                dataReader.AddParameter("forcemoderate", forceModeration);
                dataReader.AddParameter("forcepremoderation", forcePreModerate);
                dataReader.AddParameter("ignoremoderation", ignoreModeration);
                dataReader.AddParameter("ipaddress", ipAddress);
                dataReader.AddParameter("bbcuid", bbcUID);
                dataReader.AddParameter("allowqueuing", allowQueuing);
                dataReader.AddParameter("isnotable", isNotable);
                dataReader.AddParameter("iscomment", isComment);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    this.PostId = dataReader.GetInt32NullAsZero("postid");
                    this.ThreadId = dataReader.GetInt32NullAsZero("threadid");
                    // isPreModPosting = dataReader.GetBoolean("ispremodposting");                    
                    // isPreModerated = dataReader.GetBoolean("ispremoderated");
                    // isQueued = dataReader.GetBoolean("wasqueued");
                }
            }
        }
        /// <summary>
        /// Calls the DB to PostToAJournal.
        /// </summary>
        /// <param name="readerCreator">Datareader creator</param>
        /// <param name="userId"> Post using the specified user.</param>
        /// <param name="siteId"> siteId </param>
        /// <param name="journalId">journal id to add the post to</param>
        /// <param name="ignoreModeration"> Allow automated posts.</param>
        /// <param name="ipAddress">users ipaddress</param>
        /// <param name="bbcUid">users bbcuid</param>
        /// <param name="forceModeration"></param>
        public void CreateJournalPost(IDnaDataReaderCreator readerCreator, int siteId, int userId, string nickname, int journalId, bool ignoreModeration, string ipAddress, Guid bbcUID, bool forceModeration)
        {
            String source = this.Subject + "<:>" + this.Text + "<:>" + Convert.ToString(userId) + "<:>" + Convert.ToString(journalId) + "<:>" + Convert.ToString(this.Style) + "<:>ToJournal";
            Guid hash = DnaHasher.GenerateHash(source);

            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("posttojournal"))
            {

                dataReader.AddParameter("userID", userId);
                dataReader.AddParameter("journal", journalId);
                dataReader.AddParameter("subject", this.Subject);
                dataReader.AddParameter("nickname", nickname);
                dataReader.AddParameter("content", this.Text);
                dataReader.AddParameter("siteid", siteId);
                dataReader.AddParameter("poststyle", this.Style);
                dataReader.AddParameter("Hash", hash);
                dataReader.AddParameter("forcemoderation", forceModeration);
                dataReader.AddParameter("ignoremoderation", ignoreModeration);
                dataReader.AddParameter("ipaddress", ipAddress);
                dataReader.AddParameter("bbcuid", bbcUID);
                
                dataReader.Execute();

                if (dataReader.Read())
                {
                    this.PostId = dataReader.GetInt32NullAsZero("postid");
                    this.ThreadId = dataReader.GetInt32NullAsZero("threadid");
                    // isPreModPosting = dataReader.GetBoolean("ispremodposting");                    
                    // isPreModerated = dataReader.GetBoolean("ispremoderated");
                    // isQueued = dataReader.GetBoolean("wasqueued");
                }
            }
        }
    }
}
