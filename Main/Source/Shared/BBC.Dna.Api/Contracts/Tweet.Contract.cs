using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Runtime.Serialization;
using BBC.Dna.Moderation;
using System.ServiceModel.Syndication;
using BBC.Dna.SocialAPI;

namespace BBC.Dna.Api
{
    [KnownType(typeof(Tweet))]
    [Serializable]
    [DataContract(Name = "tweet", Namespace = "BBC.Dna.Api")]
    public class Tweet
    {
        [DataMember(Name = ("id"))]
        public long id;

        [DataMember(Name = ("created_at"))]
        public string createdStr;

        [DataMember(Name = ("user"))]
        public TweetUser user;

        [DataMember(Name = ("text"))]
        public string Text;

        [DataMember(Name = ("profile_image_url"))]
        public string profileImageUrl;

        [DataMember(Name = ("retweeted_status"))]
        public Tweet RetweetedStatus;

        // have to store retweet_count as string, because if the count > 100, twitter return "100+"
        [DataMember(Name = ("retweet_count"))]
        public string RetweetCountString = "0";

        public short RetweetCount()
        {
            int retweetCount;
            if (!int.TryParse(RetweetCountString, out retweetCount))
            {
                // The assumption that the only time it won't parse is when twitter return "100+" as a retweet count
                return 101;
            }
            else
            {
                if (retweetCount > short.MaxValue)
                    return short.MaxValue;
                else
                    return (short)retweetCount;
            }
        }

        public bool IsRetweet { get { return RetweetedStatus != null; } }

        public CommentInfo CreateCommentInfo()
        {
            return new CommentInfo()
            {
                text = Text,
                PostStyle = PostStyle.Style.tweet,
                ApplyProcessPremodExpiryTime = true // We want moderated tweets to be queued and to expire if they're queued for too long
            };
        }
    }
}