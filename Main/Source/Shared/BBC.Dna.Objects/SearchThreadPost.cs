using System.Xml;
using BBC.Dna.Utils;
using System;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Api;
using System.Linq;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("SEARCHTHREADPOST")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SEARCHTHREADPOST")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "SEARCHTHREADPOST")]
    [DataContract(Name="searchThreadPost")]
    public class SearchThreadPost : ThreadPost
    {
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "RANK")]
        [DataMember(Name = "rank")]
        public int Rank
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "FORUMID")]
        [DataMember(Name = "forumId")]
        public int ForumId
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public SearchThreadPost() :base()
        {
        }

        /// <summary>
        /// Returns filled object from reader
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="prefix"></param>
        /// <returns></returns>
        static public SearchThreadPost CreatePostFromReader(IDnaDataReader reader, int postId, string[] searchTerms)
        {

            SearchThreadPost searchPost = new SearchThreadPost() { PostId = postId };
            ThreadPost.CreateThreadPostFromReader(reader, string.Empty, postId, (SearchThreadPost)searchPost);
            if (reader.DoesFieldExist("rank"))
            {
                searchPost.Rank = reader.GetInt32NullAsZero("rank");
            }
            searchPost.Rank = (searchPost.Rank * 100) / 200;//normalise to out of 100

            if (reader.DoesFieldExist("forumid"))
            {
                searchPost.ForumId = reader.GetInt32NullAsZero("forumid");
            }
            searchPost.Text = HtmlUtils.RemoveAllHtmlTags(searchPost.Text);
            searchPost.Text = FormatSearchPost(searchPost.Text, searchTerms);
            
            
            return searchPost;
        }

        /// <summary>
        /// formats the post as a search post
        /// </summary>
        /// <param name="post"></param>
        /// <param name="searchTerms"></param>
        /// <returns></returns>
        static public string FormatSearchPost(string post, string[] searchTerms)
        {
            post = ThreadPost.FormatPost(post, CommentStatus.Hidden.NotHidden, true);
            post = HtmlUtils.RemoveAllHtmlTags(post);
            int pos=0;
            foreach(var term in searchTerms)
            {
                var thisPos = post.IndexOf(term);
                if(thisPos >0 && (pos == 0 || thisPos < pos))
                {
                    pos = thisPos;
                }
            }
            //cut to first instance
            if(pos >100)
            {
                post = "..." + post.Substring(pos, post.Length-pos);
            }
            if (post.Length > 200)
            {
                if (post.LastIndexOf(" ", 200) > 0 && post.Length > post.LastIndexOf(" ", 200))
                {
                    post = post.Substring(0, post.LastIndexOf(" ", 200)) + "...";
                }
                else
                {
                    post = post.Substring(0, 200) + "...";
                }
            }

            foreach (var term in searchTerms)
            {//not great hardcoded tags in c#...
                post = post.ReplaceCaseInsensitive(term, "<SEARCHRESULT>" + term + "</SEARCHRESULT>", StringComparison.CurrentCultureIgnoreCase);
            }
            return post;
        }
    }
}
