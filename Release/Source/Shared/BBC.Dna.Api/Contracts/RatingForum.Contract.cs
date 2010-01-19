using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(RatingForum))]
    [Serializable] [DataContract(Name = "ratingForum", Namespace="BBC.Dna.Api")]
    public partial class RatingForum : Forum
    {
        public RatingForum() { }

        [DataMember(Name = ("ratingsSummary"), Order = 10)]
        public RatingsSummary ratingsSummary
        {
            get;
            set;
        }

        

        [DataMember(Name = ("ratingsList"), Order = 11)]
        public RatingsList ratingsList
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
            if (ratingsList != null && ratingsList.ratings != null)
            {
                for (int i = 0; i < ratingsList.ratings.Count; i++)
                {
                    SyndicationItem item = new SyndicationItem(
                    "",
                    ratingsList.ratings[i].text,
                    new Uri(ratingsList.ratings[i].Uri),
                    ratingsList.ratings[i].ID.ToString(),
                    DateTime.Parse(ratingsList.ratings[i].Created.At));
                    items.Add(item);
                }

            }
            feed.Items = items;
            return feed;


        }

    }
}
