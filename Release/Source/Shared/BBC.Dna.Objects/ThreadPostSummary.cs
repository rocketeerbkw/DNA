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
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "POST")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "POST")]
    [DataContract(Name = "threadPostSummary")]
    public partial class ThreadPostSummary
    {
        #region Properties
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "DATE")]
        [DataMember(Name = ("date"))]
        public Date Date
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "USER")]
        [DataMember(Name = ("user"))]
        public User User
        {
            get;
            set;
        }

        /// <remarks/>
        private string _text = String.Empty;

        [XmlIgnore]
        public string Text
        {
            get
            {
                return _text;
            }
            set { _text = value; }
        }

        [System.Xml.Serialization.XmlAnyElement(Order = 4)]
        public XmlElement TextElement
        {
            get
            {
               

                XmlDocument doc = new XmlDocument();
                try
                {
                    doc.LoadXml("<TEXT>" + Text + "</TEXT>");
                }
                catch
                {
                    doc.LoadXml("<TEXT/>");
                    doc.DocumentElement.InnerText = Text;
                }
                return doc.DocumentElement;
            }
            set { _text = value.InnerXml; }
        }

        [XmlIgnore]
        [DataMember(Name = ("text"))]
        public string TextContract
        {
            get
            {
                var textElement = TextElement;
                if (textElement != null)
                {
                    return textElement.InnerXml;
                }
                return string.Empty;
            }
            set { }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "POSTID")]
        [DataMember(Name = ("postId"))]
        public int PostId
        {
            get;
            set;
        }

        
        /// <remarks/>
        private CommentStatus.Hidden _hidden = CommentStatus.Hidden.NotHidden;
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "HIDDEN")]
        [DataMember(Name = ("status"))]
        public byte Hidden
        {
            get {return (byte)_hidden; }
            set { _hidden = (CommentStatus.Hidden)value; }
        }

        
        
        #endregion


        /// <summary>
        /// Creates a threadpost from a given reader
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="prefix">The data base name prefix</param>
        /// <returns></returns>
        static public ThreadPostSummary CreateThreadPostFromReader(IDnaDataReader reader, string prefix, int postId)
        {
            ThreadPostSummary post = new ThreadPostSummary() { PostId = postId };
            
            if (reader.DoesFieldExist(prefix +"hidden"))
            {
                post.Hidden = (byte)(reader.GetInt32NullAsZero(prefix +"hidden") == 1?1:0);
            }
            if (reader.DoesFieldExist("firstposting") && reader["firstposting"] != DBNull.Value)
            {
                post.Date = new Date(reader.GetDateTime("firstposting"));
            }
            if (reader.DoesFieldExist(prefix +"text"))
            {
                post.Text = ThreadPost.FormatPost(reader.GetStringNullAsEmpty(prefix + "text"), (CommentStatus.Hidden)post.Hidden);
            }

            post.User = BBC.Dna.Objects.User.CreateUserFromReader(reader, prefix);


            return post;
        }

    }
}
