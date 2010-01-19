using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Objects
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEFORUM")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "ARTICLEFORUM")]
    public class ArticleForum
    {
        [System.Xml.Serialization.XmlElementAttribute(ElementName = "FORUMTHREADS")]
        public ForumThreads ForumThreads
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlElementAttribute(ElementName = "FORUMTHREADPOSTS")]
        public ForumThreadPosts ForumThreadPosts
        {
            get;
            set;
        }
    }
}
