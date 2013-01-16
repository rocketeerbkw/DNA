using System;
using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentInfo))]
    [Serializable] [DataContract(Name = "comment", Namespace = "BBC.Dna.Api")]
    public partial class CommentInfo : baseContract
    {
        public CommentInfo() 
        {
            User = new User();
        }

        [DataMember(Name = ("uri"), Order = 1)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = "text", Order = 2)]
        public string text
        {
            get; set;
        }

        [DataMember(Name = ("created"), Order = 3)]
        public DateTimeHelper Created
        {
            get;
            set;
        }

        [DataMember(Name = ("user"), Order = 4)]
        public User User
        {
            get;
            set;
        }

        [DataMember(Name = ("id"), Order = 5)]
        public int ID
        {
            get;
            set;
        }


        [DataMember(Name = ("poststyle"), Order = 6)]
        public PostStyle.Style PostStyle
        {
            get;
            set;
        }

        [DataMember(Name = ("complaintUri"), Order = 7)]
        public string ComplaintUri
        {
            get;
            set;
        }


        [DataMember(Name = ("forumUri"), Order = 8)]
        public string ForumUri
        {
            get;
            set;
        }

        /// <summary>
        /// The hidden status of the comment
        /// </summary>
        [DataMember(Name = ("status"), Order = 9)]
        public CommentStatus.Hidden hidden = CommentStatus.Hidden.NotHidden;

        [DataMember(Name = ("isEditorPick"), Order = 10)]
        public bool IsEditorPick
        {
            get;
            set;
        }

        [DataMember(Name = ("index"), Order = 11)]
        public int Index
        {
            get;
            set;
        }

        [DataMember(Name = ("neroRatingValue"), Order = 12)]
        public int NeroRatingValue
        {
            get;
            set;
        }

        [DataMember(Name = ("tweetId"), Order = 13)]
        public long TweetId
        {
            get;
            set;
        }

        [DataMember(Name = ("twitterscreenname"), Order = 14)]
        public string TwitterScreenName
        {
            get;
            set;
        }

        [DataMember(Name = ("retweetid"), Order = 15)]
        public long RetweetId
        {
            get;
            set;
        }

        [DataMember(Name = ("retweetedby"), Order = 16)]
        public string RetweetedBy
        {
            get;
            set;
        }
        [DataMember(Name = ("distressMessage"), Order = 17)]
        public CommentInfo DistressMessage
        {
            get;
            set;
        }


        /// <summary>
        /// When true, this comment should go into the premodpostings table (if it requires moderation)
        /// and if the configured time ellapses since it was queued before it's moderated, it is removed from the queue
        /// Used by tweets
        /// </summary>
        public bool ApplyProcessPremodExpiryTime
        {
            get;
            set;
        }

        /// <summary>
        /// Is the comment premod
        /// </summary>
        public bool IsPreModerated = false;

        /// <summary>
        /// This is the modid returned by the posting system if the post has gone straight
        /// into the PreModPostings table
        /// </summary>
        public int PreModPostingsModId { get; set; }

        /// <summary>
        /// The comment in the premod table
        /// </summary>
        public bool IsPreModPosting
        {
            get { return PreModPostingsModId > 0; }
        }


        /// <summary>
        /// Formats the comment string
        /// </summary>
        /// <param name="text"></param>
        /// <param name="style"></param>
        /// <param name="hidden"></param>
        /// <returns></returns>
        public static string FormatComment(string text, PostStyle.Style style, CommentStatus.Hidden hidden, bool isEditor)
        {
            if (hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration ||
                hidden == CommentStatus.Hidden.Hidden_AwaitingReferral)
            {
                return "This post is awaiting moderation.";
            }
            if (hidden != CommentStatus.Hidden.NotHidden)
            {
                return "This post has been removed.";
            }
            string _text = text;
            switch (style)
            {
                case Api.PostStyle.Style.plaintext:
                    if (!isEditor)
                    {
                        _text = HtmlUtils.RemoveAllHtmlTags(_text);
                    }
                    _text = HtmlUtils.ReplaceCRsWithBRs(_text);
                    _text = LinkTranslator.TranslateExLinksToHtml(_text);
                    break;

                case Api.PostStyle.Style.richtext:
                    if (!isEditor)
                    {
                        _text = HtmlUtils.CleanHtmlTags(_text, false, false);
                    }
                    _text = HtmlUtils.ReplaceCRsWithBRs(_text);
                    //<dodgey>
                    var temp = "<RICHPOST>" + _text + "</RICHPOST>";
                    temp = HtmlUtils.TryParseToValidHtml(temp);
                    _text = temp.Replace("<RICHPOST>", "").Replace("</RICHPOST>", "");
                    //</dodgey>

                    _text = LinkTranslator.TranslateExLinksToHtml(_text);
                    break;

                case Api.PostStyle.Style.rawtext:
                    //do nothing
                    break;

                case Api.PostStyle.Style.tweet:
                    if (!isEditor)
                    {
                        _text = HtmlUtils.RemoveAllHtmlTags(_text);
                    }
                    _text = LinkTranslator.TranslateExLinksToHtml(_text);
                    _text = LinkTranslator.TranslateTwitterTags(_text);
                    break;

                case Api.PostStyle.Style.unknown:
                    //do nothing
                    break;
            }
            return _text;
        }

    }
}
