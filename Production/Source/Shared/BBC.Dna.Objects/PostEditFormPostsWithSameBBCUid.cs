using System.CodeDom.Compiler;
using System;
using System.Diagnostics;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Objects;

namespace BBC.Dna.Objects
{

    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "POSTEDITFORMPOSTSWITHSAMEBBCUIDPOST")]
    public partial class PostEditFormPostsWithSameBBCUidPost
    {
        /// <remarks/>
        [XmlElementAttribute(Order = 0, ElementName = "USERID")]
        public int UserId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 1, ElementName = "USERNAME")]
        public string UserName
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 2, ElementName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 3, ElementName = "THREADID")]
        public int ThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 4, ElementName = "ENTRYID")]
        public int EntryId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 5, ElementName = "POSTINDEX")]
        public int PostIndex
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 6, ElementName = "DATEPOSTED")]
        public DateElement DatePosted
        {
            get;
            set;
        }
    }
}
