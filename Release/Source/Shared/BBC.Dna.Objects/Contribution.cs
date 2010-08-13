using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Configuration;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Site;

namespace BBC.Dna.Objects
{

    [DataContract(Name = "contribution")]    
    public class Contribution
    {
        private SiteType _siteType;
        private CommentStatus.Hidden _moderationStatus;


        /// <summary>
        /// DNA's id for where the post came from 
        /// </summary>
        [DataMember(Name="site")]
        public string SiteName {get; set; }
        
        /// <summary>
        /// Whether it came from a blog, messageboard etc. 
        /// </summary>
        [DataMember(Name = "siteType")]
        public string SiteTypeAsString
        {
            get
            {
                return _siteType.ToString();
            }
            set
            {
                _siteType = (SiteType)Enum.Parse(typeof(SiteType), value);                 
            }
        }

        /// <summary>
        /// Unknown sites are undefined.
        /// </summary>
        public SiteType SiteType 
        {
            get { return _siteType; }
            set { _siteType = value; } 
        }

        /// <summary>
        /// A flag to show if it was removed by moderators 
        /// </summary>
        [DataMember(Name = "moderationStatus")]
        public string ModerationStatusAsString
        {
            get
            {
                return Enum.GetName(typeof(CommentStatus.Hidden), _moderationStatus);
            }
            set
            {
                _moderationStatus = (CommentStatus.Hidden)Enum.Parse(typeof(CommentStatus.Hidden), value);                 
            }
        }

        public CommentStatus.Hidden ModerationStatus { get; set; }
        
        /// <summary>
        /// The date when the entry was posted    
        /// </summary>
        [DataMember(Name = "timestamp")]
        public DateTime Timestamp { get; set; }

        /// <summary>
        /// The content of the actual post in _rich text_ format 
        /// </summary>
        [DataMember(Name = "body")]
        public string Body { get; set; }

        /// <summary>
        /// The human-readable toplevel site name (e.g. "The Archers Messageboard" or "BBC Internet Blog")  
        /// </summary>
        [DataMember(Name = "sourceTitle")]
        public string FirstSubject { get; set; }

        /// <summary>
        /// Title of the page or blog post (e.g. "Going Social with the iPlayer Beta" from http://www.bbc.co.uk/blogs/bbcinternet/2010/06/going_social_with_bbc_iplayer.html, or "Discuss the Archers" from http://www.bbc.co.uk/dna/mbarchers/F2693940 
        /// </summary>
        [DataMember(Name = "title")]
        public string Title { get; set; }

        /// <summary>
        /// Title of the messageboard thread (e.g. "Am I The Only One??" on http://www.bbc.co.uk/dna/mbarchers/F2693940?thread=7557282) 
        /// </summary>
        [DataMember(Name = "subTitle")]
        public string Subject { get; set; }

        /// <summary>
        /// To indicate if this is the first post in the thread
        /// </summary>
        [DataMember(Name = "postIndex")]
        public int PostIndex { get; set; }

        [DataMember(Name = "siteDescription")]
        public string SiteDescription { get; set; }

        [DataMember(Name = "siteUrl")]
        public string SiteUrl { get; set; }

        [DataMember(Name = "forumTitle")]
        public string ForumTitle { get; set; }

        [DataMember(Name = "threadEntryID")]
        public int ThreadEntryID { get; set; }

        [DataMember(Name = "commentForumUrl")]
        public string CommentForumUrl { get; set; }

        [DataMember(Name = "guideEntrySubject")]
        public string GuideEntrySubject { get; set; }


        public static Contribution CreateContribution(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int h2g2Id, bool ignoreCache)
        {
            Contribution contribution = new Contribution();
            

            return contribution;
        }

    }
}
