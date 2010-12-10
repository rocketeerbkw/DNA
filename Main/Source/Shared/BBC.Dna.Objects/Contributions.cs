using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Api;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using System.Runtime.Serialization;
using BBC.Dna.Common;
using BBC.Dna.Sites;
using System.Xml;
using System.Xml.Serialization;

namespace BBC.Dna.Objects
{
    /// <summary>
    /// Represents a cachable, sorted, paged list of Contribution instances.
    /// A contribution is a record in the ThreadEntries table, and is manifested as 
    /// a blog comment, embedded comment or message board post - depending on the type of site 
    /// it it was posted on.
    /// </summary>
    [Serializable]    
    [DataContract(Name = "contributions")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "CONTRIBUTIONS")]
    public class Contributions : CachableBase<Contribution>
    {
        /// <summary>
        /// Identity Userid of user who made the contribution. 
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [System.Xml.Serialization.XmlAttribute(AttributeName = "USERID")]
        public string IdentityUserID {get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [System.Xml.Serialization.XmlAttribute(AttributeName = "ITEMSPERPAGE")]
        public int ItemsPerPage {get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [System.Xml.Serialization.XmlAttribute(AttributeName = "STARTINDEX")]
        public int StartIndex {get; set; }

        /// <summary>
        /// Items are always by post date - this field only defines the direction.
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [System.Xml.Serialization.XmlAttribute(AttributeName = "SORTDIRECTION")]
        public SortDirection SortDirection {get; set; }

        /// <summary>
        /// Site type, originally obtained by the SiteOption table where the name is 'SiteType'.
        /// Each Site MUST have this site option. 
        /// The values of the SiteType enum will correspond with the values in the table.
        /// If the site type is unknown, then the enum value will be Undefined (0).        
        /// If the value is null, then all items will be returned.
        /// </summary>
        [XmlIgnore]
        public SiteType? SiteType {get; set; }

        [XmlAttribute(AttributeName = "SITETYPE")]
        public string SiteTypeText {
            get
            {
                if (SiteType.HasValue)
                {
                    return SiteType.Value.ToString();
                }
                return "";
            }
        }

        /// <summary>
        /// siteName
        /// </summary>        
        [System.Xml.Serialization.XmlAttribute(AttributeName = "SITENAME")]
        public string SiteName { get; set; }

        /// <summary>
        /// Total contributions for this query in db (not just page size)
        /// </summary>
        [DataMember(Name = "totalContributions")]
        [System.Xml.Serialization.XmlAttribute(AttributeName = "TOTALCONTRIBUTIONS")]
        public int TotalContributions { get; set; }


        /// <summary>
        /// Whether we get via id or username.
        /// </summary>
        private string UserNameType { get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>        
        [XmlIgnore]
        public DateTime InstanceCreatedDateTime { get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [DataMember(Name = "contributionItems")]
        [System.Xml.Serialization.XmlArray(ElementName = "CONTRIBUTIONITEMS")]
        [System.Xml.Serialization.XmlArrayItem(ElementName = "CONTRIBUTIONITEM")]
        public List<Contribution> ContributionItems { get; set; }

        public Contributions()
        {
            ContributionItems = new List<Contribution>();
        }

        /// <summary>
        /// Gets all conributions for the user, given the parameters and using the cache if possible.
        /// </summary>
        /// <returns></returns>
        public static Contributions GetUserContributions(ICacheManager cache, IDnaDataReaderCreator readerCreator, string siteName, string userid,
            int itemsPerPage, int startIndex, SortDirection SortDirection, SiteType? filterBySiteType, string userNameType, bool IsEditor, bool ignoreCache, DateTime? startDate, bool applySkin)
        {
            Contributions contributions = new Contributions()
            {
                IdentityUserID = userid,
                ItemsPerPage = itemsPerPage,
                StartIndex = startIndex,
                SortDirection = SortDirection,
                SiteType = filterBySiteType,
                SiteName = siteName,
                UserNameType = userNameType,
                InstanceCreatedDateTime = DateTime.Now 
               
            };

            if (contributions.IdentityUserID == null)
            {
                contributions = CreateContributionFromDatabase(cache, contributions, readerCreator, ignoreCache, applySkin);
            }
            else
            {
                contributions = CreateUserContributionFromDatabase(cache, contributions, readerCreator, IsEditor, ignoreCache, startDate, applySkin);
            }

            
            return contributions;
        }

        /// <summary>
        /// Checks the user has made a new post since the object was originally created.
        /// </summary>        
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {

            if (this.IdentityUserID == null) { return false; }

            DateTime lastPostedDateTime = DateTime.MinValue;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetlastpostdate"))
            {
                reader.AddParameter("identityuserid", IdentityUserID);
                reader.Execute();
        
                if (reader.HasRows && reader.Read())
                {
                    lastPostedDateTime = reader.GetDateTime("LastPosted");
                }
            }

            return (InstanceCreatedDateTime >= lastPostedDateTime);
        }

        /// <summary>
        /// Cache key consists of UserID, SiteType, SortDirection, ItemsPerPage, StartIndex
        /// </summary>
        public string ContributionsCacheKey
        {
            get
            {
                return GetCacheKey(IdentityUserID, SiteType, SiteName, SortDirection.ToString(), ItemsPerPage, StartIndex, UserNameType);
            }
        }

        /// <summary>
        /// Fills the contributions list (if not obtainable from cache) with the return of getusercontributions
        /// </summary>
        private static Contributions CreateUserContributionFromDatabase(ICacheManager cache, 
                                                                    Contributions contributionsFromCache, 
                                                                    IDnaDataReaderCreator readerCreator, 
                                                                    bool IsEditor,
                                                                    bool ignoreCache,
                                                                    DateTime? startDate,
                                                                    bool applySkin
            )
        {
            // NOTE
            // contributionsFromCache is simply used to get the cache key
            // returnedContributions is the actual instance in cache

            Contributions returnedContributions = null;
            if (!ignoreCache)
            {
                returnedContributions = (Contributions)cache.GetData(contributionsFromCache.ContributionsCacheKey);
                if (returnedContributions != null && returnedContributions.IsUpToDate(readerCreator))
                {
                    return returnedContributions;
                }
            }

            returnedContributions = new Contributions()
            {
                IdentityUserID = contributionsFromCache.IdentityUserID,
                ItemsPerPage = contributionsFromCache.ItemsPerPage,
                StartIndex = contributionsFromCache.StartIndex,
                SortDirection = contributionsFromCache.SortDirection,
                SiteType = contributionsFromCache.SiteType,
                SiteName = contributionsFromCache.SiteName,
                UserNameType = contributionsFromCache.UserNameType,
                InstanceCreatedDateTime = DateTime.Now
            };

            using (IDnaDataReader reader2 = readerCreator.CreateDnaDataReader("getusercontributions"))
            {
                // Add the entry id and execute
                reader2.AddIntReturnValue();
                reader2.AddParameter("identityuserid", returnedContributions.IdentityUserID);
                reader2.AddParameter("itemsPerPage", returnedContributions.ItemsPerPage);
                reader2.AddParameter("startIndex", returnedContributions.StartIndex);
                reader2.AddParameter("sortDirection", returnedContributions.SortDirection.ToString().ToLower());
                reader2.AddParameter("siteType", returnedContributions.SiteType);
                reader2.AddParameter("siteName", returnedContributions.SiteName);
                reader2.AddParameter("userNameType", returnedContributions.UserNameType);
                if (startDate.HasValue)
                {
                    reader2.AddParameter("startDate", startDate);

                }
                reader2.AddIntOutputParameter("count"); 
                reader2.Execute();

                returnedContributions = CreateContributionInternal(returnedContributions, cache, reader2, IsEditor, applySkin);
            }

            return returnedContributions;
        }

        /// <summary>
        /// Fills the contributions list (if not obtainable from cache) with the return of getusercontributions
        /// </summary>
        private static Contributions CreateContributionFromDatabase(ICacheManager cache,
                                                                    Contributions contributionsFromCache,
                                                                    IDnaDataReaderCreator readerCreator,
                                                                    bool ignoreCache,
                                                                    bool applySkin)
        {
            // NOTE
            // contributionsFromCache is simply used to get the cache key
            // returnedContributions is the actual instance in cache

            Contributions returnedContributions = null;
            if (!ignoreCache)
            {
                returnedContributions = (Contributions)cache.GetData(contributionsFromCache.ContributionsCacheKey);
                if (returnedContributions != null && returnedContributions.IsUpToDate(readerCreator))
                {
                    return returnedContributions;
                }
            }

            returnedContributions = new Contributions()
            {
                IdentityUserID = contributionsFromCache.IdentityUserID,
                ItemsPerPage = contributionsFromCache.ItemsPerPage,
                StartIndex = contributionsFromCache.StartIndex,
                SortDirection = contributionsFromCache.SortDirection,
                SiteType = contributionsFromCache.SiteType,
                SiteName = contributionsFromCache.SiteName,
                UserNameType = contributionsFromCache.UserNameType,
                InstanceCreatedDateTime = DateTime.Now
            };

            using (IDnaDataReader reader2 = readerCreator.CreateDnaDataReader("getrecentcontributions"))
            {
                // Add the entry id and execute
                reader2.AddIntReturnValue();
                reader2.AddParameter("itemsPerPage", returnedContributions.ItemsPerPage);
                reader2.AddParameter("startIndex", returnedContributions.StartIndex);
                reader2.AddParameter("siteType", returnedContributions.SiteType);
                reader2.AddParameter("siteName", returnedContributions.SiteName);
                reader2.Execute();

                returnedContributions = CreateContributionInternal(returnedContributions, cache, reader2, false, applySkin);
            }

            return returnedContributions;
        }

        private static Contributions CreateContributionInternal(Contributions returnedContributions, ICacheManager cache, IDnaDataReader reader2, bool IsEditor, bool applySkin)
        {
            int returnValue = 0;
            int countReturnValue;
            reader2.TryGetIntReturnValueNullAsZero(out returnValue);                

            if (returnValue == 1)   // user wasn't found
            {
                throw ApiException.GetError(ErrorType.InvalidUserId);
            }

            // Make sure we got something back
            if (reader2.HasRows)
            {
                returnedContributions.ContributionItems.Clear();

                
                while (reader2.Read()) // Go though the results untill we get the main article
                {
                    Contribution contribution = new Contribution();
                    contribution.ModerationStatus = (CommentStatus.Hidden)reader2.GetInt32NullAsZero("Hidden");
                    int internalHidden = (int)contribution.ModerationStatus;
                    if (IsEditor)
                    {
                        internalHidden = 0;
                    }
                    try
                    {
                        contribution.SiteType = (SiteType)Enum.Parse(typeof(SiteType), reader2.GetStringNullAsEmpty("SiteType"));
                    }
                    catch 
                    {
                        contribution.SiteType = Sites.SiteType.Undefined;
                    }
                    contribution.Subject = reader2.GetStringNullAsEmpty("Subject");
                    switch ((BBC.Dna.Sites.SiteType)contribution.SiteType)
                    {
                        case BBC.Dna.Sites.SiteType.Blog:
                            goto case BBC.Dna.Sites.SiteType.EmbeddedComments;

                        case BBC.Dna.Sites.SiteType.EmbeddedComments:
                            contribution.Body = CommentInfo.FormatComment(reader2.GetStringNullAsEmpty("Body"),
                                BBC.Dna.Api.PostStyle.Style.plaintext, (CommentStatus.Hidden)internalHidden, false);
                            break;

                        default:
                            contribution.Body = ThreadPost.FormatPost(reader2.GetStringNullAsEmpty("Body"), 
                                (CommentStatus.Hidden)internalHidden, true, applySkin);
                            break;
                    }
                    contribution.PostIndex = reader2.GetLongNullAsZero("PostIndex");
                    contribution.SiteName = reader2.GetStringNullAsEmpty("SiteName");
                    
                    contribution.SiteDescription = reader2.GetStringNullAsEmpty("SiteDescription");
                    contribution.SiteUrl = reader2.GetStringNullAsEmpty("UrlName");
                    contribution.FirstSubject = reader2.GetStringNullAsEmpty("FirstSubject");
                    
                    contribution.Timestamp = new DateTimeHelper(reader2.GetDateTime("TimeStamp"));
                    contribution.Title = reader2.GetStringNullAsEmpty("ForumTitle");
                    contribution.ThreadEntryID = reader2.GetInt32("ThreadEntryID");
                    contribution.CommentForumUrl = reader2.GetStringNullAsEmpty("CommentForumUrl");
                    contribution.GuideEntrySubject = reader2.GetStringNullAsEmpty("GuideEntrySubject");

                    contribution.TotalPostsOnForum = reader2.GetInt32NullAsZero("TotalPostsOnForum");
                    contribution.AuthorUserId = reader2.GetInt32NullAsZero("AuthorUserId");
                    contribution.AuthorUsername = reader2.GetStringNullAsEmpty("AuthorUsername");
                    contribution.AuthorIdentityUsername = reader2.GetStringNullAsEmpty("AuthorIdentityUsername");
                    contribution.ForumID = reader2.GetInt32NullAsZero("forumid");
                    contribution.ThreadID = reader2.GetInt32NullAsZero("threadid");

                    bool forumCanWrite = reader2.GetByteNullAsZero("ForumCanWrite") == 1;
                    bool isEmergencyClosed = reader2.GetInt32NullAsZero("SiteEmergencyClosed") == 1;
                    //bool isSiteScheduledClosed = reader2.GetByteNullAsZero("SiteScheduledClosed") == 1;

                    DateTime closingDate = DateTime.MaxValue;
                    if (reader2.DoesFieldExist("forumclosedate") && !reader2.IsDBNull("forumclosedate"))
                    {
                        closingDate = reader2.GetDateTime("forumclosedate");
                        contribution.ForumCloseDate = new DateTimeHelper(closingDate);
                    }
                    contribution.isClosed = (!forumCanWrite || isEmergencyClosed || (closingDate != null && DateTime.Now > closingDate));
                    
                    
                    returnedContributions.ContributionItems.Add(contribution);

                    returnedContributions.StartIndex = reader2.GetInt32NullAsZero("startindex");
                }
            }

            if (returnedContributions.StartIndex == 1)
            {//sql pagination starts at item 1 - we want 0 based
                returnedContributions.StartIndex = 0;
            }

            reader2.NextResult();
            if (reader2.TryGetIntOutputParameter("count", out countReturnValue))
            {
                returnedContributions.TotalContributions = countReturnValue;
            }
            
            // wasn't in cache before, so add to cache now
            cache.Add(returnedContributions.ContributionsCacheKey, returnedContributions);            
            return returnedContributions;
        }


    }
}
