using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentForum))]
    [Serializable] [DataContract(Name = "commentForum", Namespace="BBC.Dna.Api")]
    public partial class CommentForum : Forum
    {
        public CommentForum() { }
        
        [DataMember(Name = ("commentsSummary"), Order = 10, EmitDefaultValue=true)]
        public CommentsSummary commentSummary
        {
            get;
            set;
        }

        
        [DataMember(Name = ("commentsList"), Order = 11, EmitDefaultValue=true)]
        public CommentsList commentList
        {
            get;
            set;
        }

        /// <summary>
        /// Create the feed 
        /// </summary>
        /// <returns>The created feed</returns>
        public override SyndicationFeed ToFeed()
        {
            SyndicationFeed feed = new SyndicationFeed(Title, Title, new Uri(Uri), Id, DateTime.Parse(Updated.At));
            //feed.Authors.Add(new SyndicationPerson("someone@microsoft.com"));
            feed.Categories.Add(new SyndicationCategory(Title));
            feed.Description = new TextSyndicationContent(Title);

            List<SyndicationItem> items = new List<SyndicationItem>();
            if (commentList != null && commentList.comments != null)
            {
                for (int i = 0; i < commentList.comments.Count; i++)
                {
                    SyndicationItem item = new SyndicationItem(
                    "",
                    commentList.comments[i].text,
                    new Uri(commentList.comments[i].Uri),
                    commentList.comments[i].ID.ToString(),
                    DateTime.Parse(commentList.comments[i].Created.At));
                    items.Add(item);
                }

            }
            feed.Items = items;
            return feed;


        }

    }
}
