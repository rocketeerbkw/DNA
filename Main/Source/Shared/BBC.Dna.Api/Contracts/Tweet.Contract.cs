﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;
using System.ServiceModel.Syndication;

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