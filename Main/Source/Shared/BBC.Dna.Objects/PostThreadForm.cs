using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true, TypeName="POSTTHREADFORM")]
    [XmlRootAttribute(Namespace="", IsNullable=false, ElementName="POSTTHREADFORM")]
    public class PostThreadForm
    {
        public PostThreadForm()
        {
            Subject = string.Empty;
            Body = string.Empty;
            Style = 2;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 0, ElementName = "SUBJECT")]
        public string Subject
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute(Order=1, ElementName="BODY")]
        public string Body
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAnyElement(Order=2)]
        public XmlElement PreviewBody
        {
            get
            {
                if (string.IsNullOrEmpty(Body))
                {
                    return null;
                }
                XmlDocument doc = new XmlDocument();
                try
                {
                    doc.LoadXml("<PREVIEWBODY>" + ThreadPost.FormatPost(Body, CommentStatus.Hidden.NotHidden, true, false) + "</PREVIEWBODY>");
                }
                catch
                {
                    doc.LoadXml("<PREVIEWBODY />");
                    doc.DocumentElement.InnerText = Body;
                }
                return doc.DocumentElement;
            }
            set { Body = value.InnerXml; }
        }
        
        /// <remarks/>
        [XmlElementAttribute(Order=3, ElementName="INREPLYTO")]
        public PostThreadFormInReplyTo InReplyTo
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="THREADID")]
        public int ThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "QUOTEINCLUDED")]
        public int QuoteIncluded
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute("INREPLYTO")]
        public int InReplyToId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="POSTINDEX")]
        public int PostIndex
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="PROFANITYTRIGGERED")]
        public byte ProfanityTriggered
        {
            get;
            set;
        }

        [XmlIgnore]
        public bool ProfanityTriggeredSpecified
        {
            get
            {
                return ProfanityTriggered > 0;
            }
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="NONALLOWEDURLSTRIGGERED")]
        public byte NonAllowedUrlsTriggered
        {
            get;
            set;
        }

        [XmlIgnore]
        public bool NonAllowedUrlsTriggeredSpecified
        {
            get
            {
                return NonAllowedUrlsTriggered > 0;
            }
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="CANWRITE")]
        public byte CanWrite
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName="STYLE")]
        public int Style
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "POSTEDBEFOREREPOSTTIMEELAPSED")]
        public int PostedBeforeReportTimeElapsed
        {
            get;
            set;
        }

        [XmlIgnore]
        public bool PostedBeforeReportTimeElapsedSpecified
        {
            get
            {
                return PostedBeforeReportTimeElapsed > 0;
            }
        }

        /// <remarks/>
        [XmlElementAttribute(ElementName = "SECONDSBEFOREPOST", Order=4)]
        public int SecondsBeforePost
        {
            get;
            set;
        }

        [XmlIgnore]
        public bool SecondsBeforePostSpecified
        {
            get
            {
                return SecondsBeforePost > 0;
            }
        }

         

        /// <summary>
        /// Returns the post form filled with the reply to information
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="inReplyToId"></param>
        /// <returns></returns>
        public static PostThreadForm GetPostThreadFormWithReplyTo(IDnaDataReaderCreator creator, IUser viewingUser, int inReplyToId)
        {
            var postThreadForm = new PostThreadForm();
            using(IDnaDataReader reader = creator.CreateDnaDataReader("getthreadpostcontents"))
            {
                reader.AddParameter("postid", inReplyToId);
                reader.AddParameter("userid", viewingUser.UserId);
                reader.Execute();

                if (reader.Read())
                {
                    postThreadForm.InReplyToId = inReplyToId;
                    postThreadForm.ForumId = reader.GetInt32NullAsZero("forumID");
                    postThreadForm.ThreadId = reader.GetInt32NullAsZero("ThreadID");
                    postThreadForm.PostIndex = reader.GetInt32NullAsZero("PostIndex");
                    postThreadForm.CanWrite = (byte)(reader.GetInt32NullAsZero("CanWrite") == 1? 1:0);
                    postThreadForm.Style = reader.GetByte("PostStyle");
                    
                    postThreadForm.Subject = reader.GetStringNullAsEmpty("Subject");

                    postThreadForm.InReplyTo = new PostThreadFormInReplyTo();
                    postThreadForm.InReplyTo.UserId = reader.GetInt32NullAsZero("UserID");
                    
                    if (!reader.IsDBNull("SiteSuffix"))
                    {
                        postThreadForm.InReplyTo.Username = reader.GetStringNullAsEmpty("SiteSuffix");
                    }
                    else
                    {
                        postThreadForm.InReplyTo.Username = reader.GetStringNullAsEmpty("UserName");
                    }
                    postThreadForm.InReplyTo.RawBody = reader.GetStringNullAsEmpty("text");
                }

             }
            return postThreadForm;
        }

        /// <summary>
        /// Returns the post form filled with the reply to information
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="inReplyToId"></param>
        /// <returns></returns>
        public static PostThreadForm GetPostThreadFormWithForum(IDnaDataReaderCreator creator, IUser viewingUser, int forumId)
        {
            var postThreadForm = new PostThreadForm();
            
            postThreadForm.InReplyToId = 0;
            postThreadForm.ForumId = forumId;
            postThreadForm.CanWrite = 1;
            
            return postThreadForm;
        }

        /// <summary>
        /// Add the new post to the object - with a quote if relevant
        /// </summary>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="addQuote"></param>
        public void AddPost(string subject, string body, QuoteEnum addQuote)
        {
            string quoteStr = string.Empty;
            if (addQuote != QuoteEnum.None && InReplyTo != null)
            {
                QuoteIncluded = 1;
                switch (addQuote)
                {
                    case QuoteEnum.QuoteId:
                        quoteStr = string.Format("<quote postid='{0}'>{1}</quote>", InReplyToId, InReplyTo.RawBody);
                        break;

                    case QuoteEnum.QuoteUser:
                        quoteStr = string.Format("<quote postid='{0}' user='{2}' userid='{1}'>{3}</quote>", InReplyToId, InReplyTo.UserId, InReplyTo.Username, InReplyTo.RawBody);
                        break;
                }
            }
            if (!string.IsNullOrEmpty(subject))
            {
                Subject = ThreadPost.FormatSubject(subject, CommentStatus.Hidden.NotHidden);
            }
            if (body.IndexOf(string.Format("<quote postid='{0}'", InReplyToId)) >= 0)
            {
                Body = body;
            }
            else
            {
                
                Body = quoteStr + body;
            }

        }
    }
    
    /// <remarks/>
    
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true, TypeName="POSTTHREADFORMINREPLYTO")]
    public partial class PostThreadFormInReplyTo
    {

        /// <remarks/>
        [XmlElementAttribute(Order=0, ElementName="USERNAME")]
        public string Username
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute(Order=1, ElementName="USERID")]
        public int UserId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlAnyElement(Order = 2)]
        public XmlElement Body
        {
            get
            {
                XmlDocument doc = new XmlDocument();
                try
                {
                    doc.LoadXml("<BODY>" + ThreadPost.FormatPost(RawBody, CommentStatus.Hidden.NotHidden, true, false) + "</BODY>");
                }
                catch 
                {
                    doc.LoadXml("<BODY />");
                    doc.DocumentElement.InnerText = RawBody;
                }
                return doc.DocumentElement;
            }
            set { RawBody = value.InnerXml; }
        }
        
        /// <remarks/>
        [XmlElementAttribute(Order=3, ElementName="RAWBODY")]
        public string RawBody
        {
            get;
            set;
        }
    }

    public enum QuoteEnum
    {
        None,
        QuoteId,
        QuoteUser
    }
}
