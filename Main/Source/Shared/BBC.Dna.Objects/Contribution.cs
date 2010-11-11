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
using BBC.Dna.Sites;
using BBC.Dna.Api;

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
        public DateTimeHelper Timestamp { get; set; }

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
        public long PostIndex { get; set; }

        [DataMember(Name = "siteDescription")]
        public string SiteDescription { get; set; }

        [DataMember(Name = "siteUrl")]
        public string SiteUrl { get; set; }

        [DataMember(Name = "threadEntryID")]
        public int ThreadEntryID { get; set; }

        [DataMember(Name = "commentForumUrl")]
        public string CommentForumUrl { get; set; }

        [DataMember(Name = "guideEntrySubject")]
        public string GuideEntrySubject { get; set; }

        [DataMember(Name = "totalPostsOnForum")]
        public int TotalPostsOnForum { get; set; }

        [DataMember(Name = "authorUserId")]
        public int AuthorUserId { get; set; }

        [DataMember(Name = "authorUsername")]
        public string AuthorUsername { get; set; }

        [DataMember(Name = "authorIdentityUsername")]
        public string AuthorIdentityUsername { get; set; }

        [DataMember(Name = ("isClosed"))]
        public bool isClosed
        {
            get;
            set;
        }

        [DataMember(Name = ("forumCloseDate"))]
        public DateTimeHelper ForumCloseDate
        {
            get;
            set;
        }

        public static Contribution CreateContribution(IDnaDataReaderCreator readerCreator, int threadEntryId)
        {
            Contribution contribution = new Contribution();

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getcontribution"))
            {
                // Add the entry id and execute
                reader.AddParameter("threadentryid", threadEntryId);
                reader.Execute();

                contribution = CreateContributionInternal(reader);
            }

            return contribution;
        }

        private static Contribution CreateContributionInternal(IDnaDataReader reader)
        {
            Contribution contribution = new Contribution();

            // Make sure we got something back
            if (reader.HasRows && reader.Read()) 
            {
                contribution.Body = reader.GetStringNullAsEmpty("Body");
                contribution.PostIndex = reader.GetLongNullAsZero("PostIndex");
                contribution.SiteName = reader.GetStringNullAsEmpty("SiteName");
                contribution.SiteType = (SiteType)Enum.Parse(typeof(SiteType), reader.GetStringNullAsEmpty("SiteType"));
                contribution.SiteDescription = reader.GetStringNullAsEmpty("SiteDescription");
                contribution.SiteUrl = reader.GetStringNullAsEmpty("UrlName");
                contribution.FirstSubject = reader.GetStringNullAsEmpty("FirstSubject");
                contribution.Subject = reader.GetStringNullAsEmpty("Subject");
                contribution.Timestamp = new DateTimeHelper(reader.GetDateTime("TimeStamp"));
                contribution.Title = reader.GetStringNullAsEmpty("ForumTitle");
                contribution.ThreadEntryID = reader.GetInt32("ThreadEntryID");
                contribution.CommentForumUrl = reader.GetStringNullAsEmpty("CommentForumUrl");
                contribution.GuideEntrySubject = reader.GetStringNullAsEmpty("GuideEntrySubject");

                contribution.TotalPostsOnForum = reader.GetInt32NullAsZero("TotalPostsOnForum");
                contribution.AuthorUserId = reader.GetInt32NullAsZero("AuthorUserId");
                contribution.AuthorUsername = reader.GetStringNullAsEmpty("AuthorUsername");
                contribution.AuthorIdentityUsername = reader.GetStringNullAsEmpty("AuthorIdentityUsername");

                bool forumCanWrite = reader.GetByteNullAsZero("ForumCanWrite") == 1;
                bool isEmergencyClosed = reader.GetInt32NullAsZero("SiteEmergencyClosed") == 1;
                //bool isSiteScheduledClosed = reader2.GetByteNullAsZero("SiteScheduledClosed") == 1;

                DateTime closingDate = DateTime.MaxValue;
                if (reader.DoesFieldExist("forumclosedate") && !reader.IsDBNull("forumclosedate"))
                {
                    closingDate = reader.GetDateTime("forumclosedate");
                    contribution.ForumCloseDate = new DateTimeHelper(closingDate);
                }
                contribution.isClosed = (!forumCanWrite || isEmergencyClosed || (closingDate != null && DateTime.Now > closingDate));
            }
            else
            {
                throw ApiException.GetError(ErrorType.ThreadPostNotFound);
            }

            return contribution;
        }

    }
}
