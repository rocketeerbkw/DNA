using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Data.Objects;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Data;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;


namespace BBC.Dna.Api
{
    public class Reviews : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Reviews(IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        {}

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public Reviews()
        { }

        /// <summary>
        /// Reads a specific forum by the UID
        /// </summary>
        /// <param name="uid">The specific form uid</param>
        /// <returns>The specified forum including comment data</returns>
        public RatingForum RatingForumReadByUID(string uid, ISite site)
        {
            RatingForum RatingForum = null;

            if(RatingForumReadByUIDFromCache(uid, site, ref RatingForum))
            {
                return RatingForum;
            }
            using (StoredProcedureReader reader = CreateReader("RatingForumreadbyuid"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", site.SiteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        RatingForum = RatingForumCreateFromReader(reader);
                        RatingForum.ratingsList = RatingsReadByForumID(RatingForum.ForumID, site);
                        RatingForumAddToCache(RatingForum, site);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return RatingForum;
        }

        /// <summary>
        /// Reads a specific forum by the UID
        /// </summary>
        /// <param name="uid">The specific form uid</param>
        /// <returns>The specified forum including comment data</returns>
        public RatingForum RatingForumReadByUIDAndUserList(string uid, ISite site, int[] userIds)
        {
            RatingForum RatingForum = null;
            using (StoredProcedureReader reader = CreateReader("RatingForumreadbyuid"))
            {

                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", site.SiteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        RatingForum = RatingForumCreateFromReader(reader);
                        RatingForum = RatingsReadByUserIDs(RatingForum, site, userIds);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return RatingForum;
        }

        /// <summary>
        /// Reads a specific rating by the forum ID and **IDENTITY** user id list
        /// </summary>
        /// <param name="forumid">The forums internal id</param>
        /// <param name="site">The sites internal id</param>
        /// <param name="userids">The user ids - A LIST OF IDENTITY USER IDs</param>
        /// <returns>The list of comments</returns>
        private RatingForum RatingsReadByUserIDs(RatingForum ratingForum, ISite site, int[] userIds)
        {
            if (userIds == null || userIds.Length == 0)
            {// check if the user id list is valid
                throw new ApiException("No user ids passed in");
            }

            //set up paging items
            ratingForum.ratingsList = new RatingsList();
            ratingForum.ratingsList.ratings = new List<RatingInfo>();
            ratingForum.ratingsList.TotalCount = 0;
            ratingForum.ratingsList.ItemsPerPage = ItemsPerPage;
            ratingForum.ratingsList.StartIndex = StartIndex;
            ratingForum.ratingsList.SortBy = _sortBy;
            ratingForum.ratingsList.SortDirection = _sortDirection;
            ratingForum.ratingsList.FilterBy = _filterBy;

            string userList = String.Join("|", Array.ConvertAll<int, string>(userIds, delegate(int s) { return s.ToString(); }));
            using (StoredProcedureReader reader = CreateReader("RatingsReadByForumandUsers"))
            {
                reader.AddParameter("forumid", ratingForum.ForumID);
                reader.AddParameter("userlist", userList);
                reader.AddParameter("startindex", StartIndex);
                reader.AddParameter("itemsperpage", ItemsPerPage);
                reader.AddParameter("sortby", _sortBy.ToString());
                reader.AddParameter("sortdirection", _sortDirection.ToString());

                reader.Execute();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        //set the summary total and average
                        ratingForum.ratingsSummary.Total = reader.GetInt32NullAsZero("totalresults");
                        ratingForum.ratingsSummary.Average = reader.GetInt32NullAsZero("average");
                        ratingForum.ratingsList.ratings.Add(RatingCreateFromReader(reader, site));
                        ratingForum.ratingsList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                    }
                }
                else
                {
                    ratingForum.ratingsSummary.Total = 0;
                    ratingForum.ratingsSummary.Average = 0;
                }
            }
            //return null if no ratings
            return ratingForum;
        }

        /// <summary>
        /// Reads a specific forum comments by the ID and siteid
        /// </summary>
        /// <param name="forumid">The forums internal id</param>
        /// <param name="siteid">The sites internal id</param>
        /// <returns>The list of comments</returns>
        public RatingsList RatingsReadByForumID(int forumid, ISite site)
        {
            RatingsList ratingsList = new RatingsList();

            ratingsList.ratings = new List<RatingInfo>();
            ratingsList.TotalCount = 0;
            ratingsList.ItemsPerPage = ItemsPerPage;
            ratingsList.StartIndex = StartIndex;
            ratingsList.SortBy = _sortBy;
            ratingsList.SortDirection = _sortDirection;
            ratingsList.FilterBy = _filterBy;

            String spName = "ratingsreadbyforumid";
            if (_filterBy == FilterBy.EditorPicks)
            {
                spName = "ratingsreadbyforumideditorpicksfilter";
            }

            using (StoredProcedureReader reader = CreateReader(spName))
            {
                try
                {
                    reader.AddParameter("forumid", forumid);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());
                    
                    reader.Execute();

                    if (reader.HasRows)
                    {//all good - read comments
                        while (reader.Read())
                        {
                            ratingsList.ratings.Add(RatingCreateFromReader(reader, site));
                            ratingsList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return ratingsList;
        }

        /// <summary>
        /// Reads a specific rating by the forum ID and user id
        /// </summary>
        /// <param name="forumid">The forums internal id</param>
        /// <param name="site">The sites internal id</param>
        /// <param name="dnauserid">The user id</param>
        /// <returns>The list of comments</returns>
        public RatingInfo RatingsReadByDNAUserID(string uid, ISite site, int dnauserid)
        {
            RatingInfo rating = null;

            using (StoredProcedureReader reader = CreateReader("ratingsreadbyforumanduser"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("userid", dnauserid);
                reader.AddParameter("siteid", site.SiteID);

                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    rating = RatingCreateFromReader(reader, site);
                }
            }
            //return null if no ratings
            return rating;
        }

        /// <summary>
        /// Reads a specific rating by the forum ID and identity id
        /// </summary>
        /// <param name="forumid">The forums internal id</param>
        /// <param name="site">The sites internal id</param>
        /// <param name="identityid">The user id</param>
        /// <returns>The list of comments</returns>
        public RatingInfo RatingsReadByIdentityID(string uid, ISite site, int identityid)
        {
            RatingInfo rating = null;

            using (StoredProcedureReader reader = CreateReader("ratingsreadbyforumandidentityid"))
            {
                reader.AddParameter("uid", uid);
                reader.AddParameter("identityid", identityid);
                reader.AddParameter("siteid", site.SiteID);

                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    rating = RatingCreateFromReader(reader, site);
                }
            }
            //return null if no ratings
            return rating;
        }

        /// <summary>
        /// Creates a new comment forum for a specificed site. Note if the RatingForum id already exists, then nothing will be created
        /// </summary>
        /// <param name="RatingForum">The comment forum object</param>
        /// <param name="siteName">The site shortname</param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public RatingForum RatingForumCreate(RatingForum RatingForum, ISite site)
        {
            //create the forum...
            ForumCreate((Forum)RatingForum, site);
            return RatingForumReadByUID(RatingForum.Id, site);

        }

        /// <summary>
        /// Creates a rating for the given rating forum
        /// </summary>
        /// <param name="RatingForum">The forum to post to</param>
        /// <param name="rating">The rating to add</param>
        /// <returns>The created rating object</returns>
        public RatingInfo RatingCreate(RatingForum RatingForum, RatingInfo rating)
        {
            ISite site = siteList.GetSite(RatingForum.SiteName);
            //check for repeat posting
            ValidateRating(RatingForum, rating, site);

            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;


            //create the thread entry
            RatingInfo createdRating = (RatingInfo)commentsObj.CommentCreate((Forum)RatingForum, (CommentInfo)rating);
            using (StoredProcedureReader reader = CreateReader("ratingscreate"))
            {
                reader.AddParameter("entryid", createdRating.ID);
                reader.AddParameter("uid", RatingForum.Id);
                reader.AddParameter("rating", rating.rating);
                reader.AddParameter("userid", CallingUser.UserID);
                reader.AddParameter("siteid", site.SiteID);
                reader.Execute();
            }
            createdRating.rating = rating.rating;
            return createdRating;
        }

        private void ValidateRating(RatingForum RatingForum, RatingInfo rating, ISite site)
        {
            if (CallingUser == null || CallingUser.UserID == 0)
            {
                throw ApiException.GetError(ErrorType.MissingUserCredentials);
            }
            if (RatingsReadByDNAUserID(RatingForum.Id, site, CallingUser.UserID) != null)
            {
                throw ApiException.GetError(ErrorType.MultipleRatingByUser);
            }
            //check if processpremod option is set...
            if (RatingForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod && siteList.GetSiteOptionValueBool(site.SiteID, "Moderation", "ProcessPreMod"))
            {
                throw ApiException.GetError(ErrorType.InvalidProcessPreModState);
            }
            int max_rating = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "MaxForumRatingScore");
            if (rating.rating > max_rating)
            {
                throw ApiException.GetError(ErrorType.RatingExceedsMaximumAllowed);
            }
        }

        /// <summary>
        /// Creates a threaded rating for the given rating forum
        /// </summary>
        /// <param name="RatingForum">The forum to post to</param>
        /// <param name="rating">The rating to add</param>
        /// <returns>The created rating object</returns>
        public ThreadInfo RatingThreadCreate(RatingForum ratingForum, RatingInfo rating)
        {
            ISite site = siteList.GetSite(ratingForum.SiteName);

            //check for repeat posting
            ValidateRating(ratingForum, rating, site);

            Threads threadsObj = new Threads();
            threadsObj.CallingUser = CallingUser;
            threadsObj.BBCUid = BBCUid;
            threadsObj.IPAddress = IPAddress;
            threadsObj.siteList = siteList;

            //create the thread entry
            ThreadInfo createdThread = threadsObj.ThreadCreate((Forum)ratingForum, (RatingInfo)rating);

            using (StoredProcedureReader reader = CreateReader("ratingscreate"))
            {
                reader.AddParameter("entryid", createdThread.rating.ID);
                reader.AddParameter("uid", ratingForum.Id);
                reader.AddParameter("rating", rating.rating);
                reader.AddParameter("userid", CallingUser.UserID);
                reader.AddParameter("siteid", site.SiteID);
                reader.Execute();
            }
            createdThread.rating.rating = rating.rating;

            return createdThread;
        }

        /// <summary>
        /// Creates a comment on a rating for a particular rating forum
        /// </summary>
        /// <param name="RatingForum">The forum to post to</param>
        /// <param name="int">The thread to add the comment to</param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public CommentInfo RatingCommentCreate(RatingForum ratingForum, int threadID, CommentInfo comment)
        {
            ISite site = siteList.GetSite(ratingForum.SiteName);

            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;

            CommentInfo createdRatingComment = commentsObj.CommentReplyCreate((Forum)ratingForum, threadID, comment);

            return createdRatingComment;
        }

        /// <summary>
        /// Returns cache key for comment forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public string RatingForumCacheKey(string uid, int siteID)
        {
            return string.Format("Rating|{0}|{1}|{2}|{3}|{4}|{5}|{6}", uid, siteID, StartIndex, ItemsPerPage, SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime RatingForumGetLastUpdate(object[] args)
        {
            string uid = (string)args[0];
            int siteID = (int)args[1];
            Comments commentsObj = new Comments();
            commentsObj.CallingUser = CallingUser;
            commentsObj.BBCUid = BBCUid;
            commentsObj.IPAddress = IPAddress;
            commentsObj.siteList = siteList;
            return commentsObj.CommentForumGetLastUpdate(uid, siteID);
        }

        /// <summary>
        /// Gets a review from it's post id
        /// </summary>
        /// <param name="postid">Post Id of the comment</param>
        /// <param name="site">Site Information</param>
        /// <returns>The Rating Info</returns>
        public RatingInfo RatingReadByPostID(string postid, ISite site)
        {
            RatingInfo rating = null;
            using (StoredProcedureReader reader = CreateReader("getrating"))
            {
                try
                {
                    reader.AddParameter("postid", postid);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        rating = RatingCreateFromReader(reader, site);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }
            return rating;
        }

        #region Private Functions
        /// <summary>
        /// Creates the RatingForumdata from a given reader
        /// </summary>
        /// <param name="reader">The database reaser</param>
        /// <returns>A Filled comment forum object</returns>
        private RatingForum RatingForumCreateFromReader(StoredProcedureReader reader)
        {
            DateTime closingDate = reader.GetDateTime("forumclosedate");
            //if (closingDate == null)
            //{
            //    closingDate = DateTime.MaxValue;
            //}
            ISite site = siteList.GetSite(reader.GetStringNullAsEmpty("sitename"));
            
            RatingForum RatingForum = new RatingForum();
            
            RatingForum.Title = reader.GetStringNullAsEmpty("Title");
            RatingForum.Id = reader.GetStringNullAsEmpty("UID");
            RatingForum.CanRead = reader.GetByteNullAsZero("canRead")==1;
            RatingForum.CanWrite = reader.GetByteNullAsZero("canWrite") == 1;
            RatingForum.ParentUri = reader.GetStringNullAsEmpty("Url");
            RatingForum.SiteName = reader.GetStringNullAsEmpty("sitename");
            RatingForum.CloseDate = closingDate;
            RatingForum.LastUpdate = (DateTime)reader.GetDateTime("LastUpdated");
            if ((DateTime)reader.GetDateTime("lastposted") > RatingForum.LastUpdate)
            {//use last posted as it is newer
                RatingForum.LastUpdate = (DateTime)reader.GetDateTime("lastposted");
            }
            RatingForum.Updated = new DateTimeHelper(RatingForum.LastUpdate);
            RatingForum.Created = new DateTimeHelper((DateTime)reader.GetDateTime("DateCreated"));
            RatingForum.ratingsSummary = new RatingsSummary
            {
                Total = reader.GetInt32NullAsZero("ForumPostCount"),
                Average = reader.GetInt32NullAsZero("average")
            };
            RatingForum.ForumID = reader.GetInt32NullAsZero("forumid");
            RatingForum.isClosed = !RatingForum.CanWrite || site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now) || (closingDate != null && DateTime.Now > closingDate);
            //MaxCharacterCount = siteList.GetSiteOptionValueInt(site.SiteID, "RatingForum", "'MaxCommentCharacterLength")


            
            Dictionary<string, string> replacements = new Dictionary<string, string>();
            replacements.Add("uid", reader.GetStringNullAsEmpty("uid"));
            replacements.Add("sitename", site.SiteName);
            RatingForum.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.RatingForumByID, replacements);
            RatingForum.ratingsSummary.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.RatingsByRatingForumID, replacements);
            
            //get moderation status
            RatingForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Unknown;
            if (!reader.IsDBNull("moderationstatus"))
            {//if it is set for the specific forum
                RatingForum.ModerationServiceGroup = (ModerationStatus.ForumStatus)(reader.GetTinyIntAsInt("moderationstatus"));
            }
            if(RatingForum.ModerationServiceGroup == ModerationStatus.ForumStatus.Unknown)
            {//else fall back to site moderation status
                switch(site.ModerationStatus)
            {
                    case ModerationStatus.SiteStatus.UnMod: RatingForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive; break;
                    case ModerationStatus.SiteStatus.PreMod: RatingForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod; break;
                    case ModerationStatus.SiteStatus.PostMod: RatingForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod; break;
                    default: RatingForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive; break;
            }
            }
            return RatingForum;
        }

        /// <summary>
        /// Creates a ratinginfo object
        /// </summary>
        /// <param name="reader">A reader with all information</param>
        /// <returns>Rating Info object</returns>
        public RatingInfo RatingCreateFromReader(StoredProcedureReader reader, ISite site)
        {
            RatingInfo ratingInfo = new RatingInfo
            {
                text = reader.GetString("text"),
                Created = new DateTimeHelper(DateTime.Parse(reader.GetDateTime("Created").ToString())),
                User = UserReadByID(reader),
                ID = reader.GetInt32NullAsZero("id"),
                rating = reader.GetByte("rating")
            };

            ratingInfo.hidden = (CommentStatus.Hidden)reader.GetInt32NullAsZero("hidden");
            if (reader.IsDBNull("poststyle"))
            {
                ratingInfo.PostStyle = PostStyle.Style.richtext;
            }
            else
            {
                ratingInfo.PostStyle = (PostStyle.Style)reader.GetTinyIntAsInt("poststyle");
            }
            ratingInfo.text = FormatCommentText(ratingInfo.text, ratingInfo.hidden, ratingInfo.PostStyle);
            
            //get complainant
            Dictionary<string, string> replacement = new Dictionary<string, string>();
            replacement.Add("sitename", site.SiteName);
            replacement.Add("postid", ratingInfo.ID.ToString());
            ratingInfo.ComplaintUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Complaint, replacement);
            
            replacement = new Dictionary<string, string>();
            replacement.Add("RatingForumid", reader.GetString("forumuid"));
            replacement.Add("sitename", site.SiteName);
            ratingInfo.ForumUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.RatingsByRatingForumID, replacement);
            
            replacement = new Dictionary<string, string>();
            replacement.Add("parentUri", reader.GetString("parentUri"));
            replacement.Add("postid", ratingInfo.ID.ToString());
            ratingInfo.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Comment, replacement);
            
            //Get Editors Pick ( this should be expanded to include any kind of poll )
            /*EditorsPick editorsPick = new EditorsPick(_dnaDiagnostics, _connection, _caching);
            if (editorsPick.LoadPollResultsForItem(commentInfo.ID) && editorsPick.Id > 0)
            {
                commentInfo.EditorsPick = new EditorsPickInfo
                {
                    Id = editorsPick.Id,
                    Response = editorsPick.Result
                };
            }*/

            return ratingInfo;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        private User UserReadByID(StoredProcedureReader reader)
        {
            User user = new User()
            {
                UserId = reader.GetInt32NullAsZero("UserID"),
                DisplayName = reader.GetStringNullAsEmpty("UserName"),
                Editor = (reader.GetInt32NullAsZero("userIsEditor") == 1),
                Journal = reader.GetInt32NullAsZero("userJournal"),
                Status = reader.GetInt32NullAsZero("userstatus"),
                
            };
            return user;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private User UserReadByCallingUser()
        {
            User user = new User()
            {
                DisplayName = CallingUser.UserName,
                UserId = CallingUser.UserID,
                Editor = CallingUser.IsUserA(UserTypes.Editor),
                Status = CallingUser.Status,
                Journal = 0
            };
            return user;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool RatingForumReadByUIDFromCache(string uid, ISite site, ref RatingForum forum)
        {
            string cacheKey = RatingForumCacheKey(uid, site.SiteID);
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);
            
            if (tempLastUpdated == null)
            {//not found
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, RatingForumGetLastUpdate(new object[2]{uid, site.SiteID})) != 0 )
            {//cache out of date so delete
                DeleteRatingForumFromCache(uid, site);
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            forum = (RatingForum)_cacheManager.GetData(cacheKey);
            if (forum == null)
            {//cache out of date so delete
                DeleteRatingForumFromCache(uid, site);
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //apply site variables
            forum = ApplySiteVariables(forum, site);
            Statistics.AddCacheHit();

            //readd to cache to add sliding window affect
            RatingForumAddToCache(forum, site);
            return true;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void RatingForumAddToCache(RatingForum forum, ISite site)
        {
            string cacheKey = RatingForumCacheKey(forum.Id, site.SiteID);
            //ICacheItemExpiration expiry = SlidingTime.
            _cacheManager.Add(cacheKey + CACHE_LASTUPDATED, forum.LastUpdate, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));

            _cacheManager.Add(cacheKey, forum, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));
        }

        /// <summary>
        /// Removes forum from cache
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="site"></param>
        private void DeleteRatingForumFromCache(string uid, ISite site)
        {
            string cacheKey = RatingForumCacheKey(uid, site.SiteID);
            _cacheManager.Remove(cacheKey + CACHE_LASTUPDATED);
            _cacheManager.Remove(cacheKey);
        }

        /// <summary>
        /// applies the site specific items
        /// </summary>
        /// <param name="comments"></param>
        /// <returns></returns>
        private RatingForum ApplySiteVariables(RatingForum forum, ISite site)
        {
            forum.isClosed = site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now) || (forum.CloseDate != null && DateTime.Now > forum.CloseDate);
            return forum;
        }


        #endregion

        /// <summary>
        /// Returns the Threads in a rating forum by the UID
        /// </summary>
        /// <param name="reviewForumId"></param>
        /// <param name="site"></param>
        /// <returns></returns>
        public ThreadList RatingForumThreadsReadByUID(string reviewForumId, ISite site)
        {
            Threads threadsObj = new Threads();
            threadsObj.CallingUser = CallingUser;
            threadsObj.BBCUid = BBCUid;
            threadsObj.IPAddress = IPAddress;
            threadsObj.siteList = siteList;

            return threadsObj.ThreadsReadByUID(reviewForumId, site);
        }

        /// <summary>
        /// Returns the Comments of a Thread in a rating forum by the threadid
        /// </summary>
        /// <param name="threadID"></param>
        /// <param name="site"></param>
        /// <returns>List of Comments</returns>
        public CommentsList RatingForumThreadCommentReadByID(string threadID, ISite site)
        {
            Threads threadsObj = new Threads();
            threadsObj.CallingUser = CallingUser;
            threadsObj.BBCUid = BBCUid;
            threadsObj.IPAddress = IPAddress;
            threadsObj.siteList = siteList;
            int id = 0;
            Int32.TryParse(threadID, out id);

            return threadsObj.ThreadCommentsReadByID(id, site);
        }

    }
}
