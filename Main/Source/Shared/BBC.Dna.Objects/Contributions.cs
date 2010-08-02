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
using BBC.Dna.Site;

namespace BBC.Dna.Objects
{
    /// <summary>
    /// Represents a cachable, sorted, paged list of Contribution instances.
    /// A contribution is a record in the ThreadEntries table, and is manifested as 
    /// a blog comment, embedded comment or message board post - depending on the type of site 
    /// it it was posted on.
    /// </summary>
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "")]
    [Serializable]    
    [DataContract(Name = "contributions")]
    public class Contributions : CachableBase<Contribution>
    {
        /// <summary>
        /// Identity Userid of user who made the contribution. 
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        public string IdentityUserID {get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        public int ItemsPerPage {get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        public int StartIndex {get; set; }

        /// <summary>
        /// Items are always by post date - this field only defines the direction.
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        public SortDirection SortDirection {get; set; }

        /// <summary>
        /// Site type, originally obtained by the SiteOption table where the name is 'SiteType'.
        /// Each Site MUST have this site option. 
        /// The values of the SiteType enum will correspond with the values in the table.
        /// If the site type is unknown, then the enum value will be Undefined (0).        
        /// If the value is null, then all items will be returned.
        /// </summary>
        public SiteType? SiteType {get; set; }

        /// <summary>
        /// siteName
        /// </summary>        
        public string SiteName { get; set; }


        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>        
        public DateTime InstanceCreatedDateTime { get; set; }

        /// <summary>
        /// This is used for as an identifier for caching purposes.
        /// </summary>
        [DataMember(Name = "contributionItems")]
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
            int itemsPerPage, int startIndex, SortDirection SortDirection, SiteType? filterBySiteType, bool ignoreCache)
        {
            Contributions contributions = new Contributions()
            {
                IdentityUserID = userid,
                ItemsPerPage = itemsPerPage,
                StartIndex = startIndex,
                SortDirection = SortDirection,
                SiteType = filterBySiteType,
                SiteName = siteName,
                InstanceCreatedDateTime = DateTime.Now                
            };

            contributions = CreateContributionFromDatabase(cache, contributions, readerCreator, ignoreCache);
            return contributions;
        }

        /// <summary>
        /// Checks the user has made a new post since the object was originally created.
        /// </summary>        
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {

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
                return GetCacheKey(IdentityUserID, SiteType, SiteName, SortDirection.ToString(), ItemsPerPage, StartIndex);
            }
        }

        /// <summary>
        /// Fills the contributions list (if not obtainable from cache) with the return of getusercontributions
        /// </summary>
        private static Contributions CreateContributionFromDatabase(ICacheManager cache, Contributions contributionsFromCache, IDnaDataReaderCreator readerCreator, bool ignoreCache)
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
                reader2.Execute();

                int returnValue = 0;
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
                        contribution.Body = reader2.GetStringNullAsEmpty("Body");                        
                        contribution.PostIndex = reader2.GetInt32("PostIndex");
                        contribution.SiteName = reader2.GetStringNullAsEmpty("SiteName");
                        contribution.SiteType = (SiteType)Enum.Parse(typeof(SiteType), reader2.GetStringNullAsEmpty("SiteType"));
                        contribution.SiteDescription = reader2.GetStringNullAsEmpty("SiteDescription");
                        contribution.SiteUrl = reader2.GetStringNullAsEmpty("UrlName");
                        contribution.FirstSubject = reader2.GetStringNullAsEmpty("FirstSubject");
                        contribution.Subject = reader2.GetStringNullAsEmpty("Subject"); 
                        contribution.Timestamp = reader2.GetDateTime("TimeStamp");
                        contribution.Title = reader2.GetStringNullAsEmpty("ForumTitle");
                        contribution.ThreadEntryID = reader2.GetInt32("ThreadEntryID");
                        contribution.CommentForumUrl = reader2.GetStringNullAsEmpty("CommentForumUrl");
                        contribution.GuideEntrySubject = reader2.GetStringNullAsEmpty("GuideEntrySubject");
                        returnedContributions.ContributionItems.Add(contribution);
                    }
                }
            }

            // wasn't in cache before, so add to cache now
            cache.Add(returnedContributions.ContributionsCacheKey, returnedContributions);
            return returnedContributions;
        }
    }
}
