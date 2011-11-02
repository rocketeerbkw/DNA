using System;
using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using BBC.DNA.Moderation.Utils;
using System.Xml.Linq;
using System.Linq;


namespace BBC.Dna.Api
{
    public class Comments : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="dataReaderCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="siteList"></param>
        public Comments(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager, siteList)
        {
        }

        /// <summary>
        /// Reads all comment forum by sitename
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList GetCommentForumListBySite(ISite site)
        {
            return GetCommentForumListBySite(site, "");
        }

        /// <summary>
        /// Reads all comment forum by sitename and uid prefix
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <param name="prefix">The prefix of the site to return</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList GetCommentForumListBySite(ISite site, string prefix)
        {
            var commentForumList = new CommentForumList
            {
                CommentForums = new List<CommentForum>(),
                SortBy = SortBy,
                SortDirection = SortDirection,
                FilterBy = FilterBy
            };
            if (site == null)
            {
                return null;
            }
            var spName = "commentforumsreadbysitename";
            if(!String.IsNullOrEmpty(prefix))
            {
                spName += "prefix";
            }
            commentForumList.CommentForums = new List<CommentForum>();
            try
            {
                using (var reader = CreateReader(spName))
                {
                    reader.AddParameter("siteurlname", site.SiteName);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("prefix", prefix + "%");
                    reader.AddParameter("SortBy", SortBy.ToString());
                    reader.AddParameter("SortDirection", SortDirection.ToString());
                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            CommentForum commentForum = CommentForumCreateFromReader(reader);
                            commentForum.identityPolicy = site.IdentityPolicy;
                            commentForumList.CommentForums.Add(commentForum);

                            commentForumList.ItemsPerPage = reader.GetInt32NullAsZero("itemsperpage");
                            commentForumList.StartIndex = reader.GetInt32NullAsZero("startindex");
                            commentForumList.TotalCount = reader.GetInt32NullAsZero("totalResults");
                            commentForumList.SortBy = SortBy;
                            commentForumList.SortDirection = SortDirection;
                            commentForumList.FilterBy = FilterBy;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
                //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }

            return commentForumList;
        }

        /// <summary>
        /// Reads all comment forum by sitename which have been posted to with a certain period
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <param name="timeFrame">Length of time in hours</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList GetCommentForumListBySiteWithinTimeFrame(ISite site, int timeFrame)
        {
            return GetCommentForumListBySiteWithinTimeFrame(site, "", timeFrame);
        }

        /// <summary>
        /// Reads all comment forum by sitename which have been posted to with a certain period
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <param name="prefix">The uid prefix</param>
        /// <param name="timeFrame">Length of time in hours</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList GetCommentForumListBySiteWithinTimeFrame(ISite site, string prefix, int timeFrame)
        {
            if (site == null)
            {
                return null;
            }
            //currently only post count supported
            SortBy = SortBy.PostCount;
            var commentForumList = new CommentForumList
                                       {
                                           CommentForums = new List<CommentForum>(),
                                           SortBy = SortBy,
                                           SortDirection = SortDirection,
                                           FilterBy = FilterBy
                                       };
            var spName = "commentforumsreadbysitenamewithintimeframe";
            if (!String.IsNullOrEmpty(prefix))
            {
                spName = "commentforumsreadbysitenameprefixwithintimeframe";
            }
            try
            {
                using (var reader = CreateReader(spName))
                {
                    reader.AddParameter("siteurlname", site.SiteName);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("prefix", prefix + "%");
                    reader.AddParameter("SortBy", SortBy.ToString());
                    reader.AddParameter("SortDirection", SortDirection.ToString());
                    reader.AddParameter("hours", timeFrame);

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            var commentForum = CommentForumCreateFromReader(reader);
                            commentForum.identityPolicy = site.IdentityPolicy;
                            commentForum.commentSummary.Total = reader.GetInt32NullAsZero("postsintimeframe");
                            commentForumList.CommentForums.Add(commentForum);

                            commentForumList.ItemsPerPage = reader.GetInt32NullAsZero("itemsperpage");
                            commentForumList.StartIndex = reader.GetInt32NullAsZero("startindex");
                            commentForumList.TotalCount = reader.GetInt32NullAsZero("totalResults");
                            
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
                //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }

            return commentForumList;
        }

        /// <summary>
        /// Reads a specific forum by the UID
        /// </summary>
        /// <param name="uid">The specific form uid</param>
        /// <param name="site"></param>
        /// <returns>The specified forum including comment data</returns>
        public CommentForum GetCommentForumByUid(string uid, ISite site)
        {
            CommentForum commentForum = null;

            if (GetCommentForumByUidFromCache(uid, site, ref commentForum))
            {
                return commentForum;
            }

            using (IDnaDataReader reader = CreateReader("commentforumreadbyuid"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteurlname", site.SiteName);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        commentForum = CommentForumCreateFromReader(reader);
                        commentForum.commentList = GetCommentsListByForumId(commentForum.ForumID, site);
                        commentForum.identityPolicy = site.IdentityPolicy;
                        AddCommentForumToCache(commentForum, site);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return commentForum;
        }

        /// <summary>
        /// Reads a specific forum comments by the ID and siteid
        /// </summary>
        /// <param name="forumid">The forums internal id</param>
        /// <param name="site"></param>
        /// <returns>The list of comments</returns>
        public CommentsList GetCommentsListByForumId(int forumid, ISite site)
        {
            var commentList = new CommentsList();

            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = SortBy;
            commentList.SortDirection = SortDirection;
            commentList.FilterBy = FilterBy;

            String spName = "commentsreadbyforumid";
            if (FilterBy == FilterBy.EditorPicks)
            {
                spName = "commentsreadbyforumideditorpicksfilter";
            }

            using (IDnaDataReader reader = CreateReader(spName))
            {
                try
                {
                    reader.AddParameter("forumid", forumid);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("SortBy", SortBy.ToString());
                    reader.AddParameter("SortDirection", SortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            commentList.comments.Add(CommentCreateFromReader(reader, site));
                            commentList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return commentList;
        }

        /// <summary>
        /// Reads a specific forum comments by the site
        /// The Results may be filtered on Editors Picks. The xml should be identicial in either case.
        /// </summary>
        /// <param name="site">The site object</param>
        /// <returns>The list of comments</returns>
        public CommentsList GetCommentsListBySite(ISite site)
        {
            return GetCommentsListBySite(site, String.Empty);
        }

        /// <summary>
        /// Return Comments for Site and Prefix.
        /// </summary>
        /// <param name="site">The site object</param>
        /// <param name="prefix">The commentforum prefix</param>
        /// <returns>The list of comments</returns>
        public CommentsList GetCommentsListBySite(ISite site, string prefix)
        {

            var spName = "commentsreadbysitename";
            if (!String.IsNullOrEmpty(prefix))
            {
                spName += "prefix";
            }
            switch (FilterBy)
            {
                case FilterBy.EditorPicks:
                    spName += "editorpicksfilter";
                    break;
            }

            CommentsList commentList = null;
            if (GetCommentListBySiteFromCache(site, prefix, ref commentList))
            {
                return commentList;
            }
            commentList = new CommentsList();
            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = SortBy;
            commentList.SortDirection = SortDirection;
            commentList.FilterBy = FilterBy;


            using (IDnaDataReader reader = CreateReader(spName))
            {
                try
                {
                    reader.AddParameter("siteid", site.SiteID);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    if (!String.IsNullOrEmpty(prefix))
                    {
                        reader.AddParameter("prefix", prefix + "%");
                    }
                    reader.AddParameter("SortBy", SortBy.ToString());
                    reader.AddParameter("SortDirection", SortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            commentList.comments.Add(CommentCreateFromReader(reader, site));
                            commentList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                            commentList.LastUpdate = reader.GetDateTime("lastupdate");
                        }
                        AddCommentListToCache(commentList, site, prefix);
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return commentList;
        }


        /// <summary>
        /// Reads a specific comments by the Thread ID and siteid
        /// </summary>
        /// <param name="threadid">The threads internal id</param>
        /// <param name="site"></param>
        /// <returns>The list of comments</returns>
        public CommentsList GetCommentsListByThreadId(int threadid, ISite site)
        {
            var commentList = new CommentsList();

            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = SortBy;
            commentList.SortDirection = SortDirection;

            using (IDnaDataReader reader = CreateReader("commentsreadbythreadid"))
            {
                try
                {
                    reader.AddParameter("threadid", threadid);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("SortBy", SortBy.ToString());
                    reader.AddParameter("SortDirection", SortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        //all good - read comments
                        while (reader.Read())
                        {
                            commentList.comments.Add(CommentCreateFromReader(reader, site));
                            commentList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
            return commentList;
        }

        /// <summary>
        /// Creates a new comment forum for a specificed site. If the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="site"></param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public CommentForum CreateCommentForum(Forum commentForum, ISite site)
        {
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            var tmpCommentForum = GetCommentForumByUid(commentForum.Id, site);
            if (tmpCommentForum == null)
            {
                CreateForum(commentForum, site);
                //return comment forum data
                tmpCommentForum = GetCommentForumByUid(commentForum.Id, site);
            }
            return tmpCommentForum;
        }

        /// <summary>
        /// performs update as well as creation
        /// </summary>
        /// <param name="commentForum"></param>
        /// <param name="site"></param>
        /// <returns></returns>
        public CommentForum CreateAndUpdateCommentForum(Forum commentForum, ISite site)
        {
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            var tmpCommentForum = GetCommentForumByUid(commentForum.Id, site);
            if (tmpCommentForum == null)
            {
                CreateForum(commentForum, site);
            }
            else 
            {
                UpdateForum(commentForum, site);
            }
            //return comment forum data
            tmpCommentForum = GetCommentForumByUid(commentForum.Id, site);
            return tmpCommentForum;
        }

        /// <summary>
        /// Creates a comment for the given comment forum id
        /// </summary>
        /// <param name="commentForum"></param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public CommentInfo CreateComment(Forum commentForum, CommentInfo comment)
        {
            ISite site = SiteList.GetSite(commentForum.SiteName);
            bool ignoreModeration;
            bool forceModeration;
            var notes = string.Empty;
            string profanityxml = string.Empty;
            
            List<Term> terms = null;

            ValidateComment(commentForum, comment, site, out ignoreModeration, out forceModeration, out notes, out terms);

            if (terms != null && terms.Count > 0)
            {
                profanityxml = new Term().GetProfanityXML(terms);
            }

            //create unique comment hash
            Guid guid = DnaHasher.GenerateCommentHashValue(comment.text, commentForum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (IDnaDataReader reader = CreateReader("commentcreate"))
                {
                    reader.AddParameter("commentforumid", commentForum.Id);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", comment.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));

                    if (CallingUser.UserID != commentForum.NotSignedInUserId)
                    {//dont include as this is data protection
                        reader.AddParameter("ipaddress", IpAddress);
                        reader.AddParameter("bbcuid", BbcUid);
                    }

                    if (CallingUser.UserID == commentForum.NotSignedInUserId && comment.User != null && !String.IsNullOrEmpty(comment.User.DisplayName))
                    {//add display name for not signed in comment
                        reader.AddParameter("nickname", comment.User.DisplayName);
                    }
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int) comment.PostStyle);
                    if (!String.IsNullOrEmpty(notes))
                    {
                        reader.AddParameter("modnotes", notes);
                    }

                    if (false == string.IsNullOrEmpty(profanityxml))
                    {
                        reader.AddParameter("profanityxml", profanityxml);
                    }

                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
//all good - create comment
                        comment.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        comment.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        comment.hidden = (comment.IsPreModerated
                                              ? CommentStatus.Hidden.Hidden_AwaitingPreModeration
                                              : CommentStatus.Hidden.NotHidden);
                        comment.text = CommentInfo.FormatComment(comment.text, comment.PostStyle, comment.hidden, CallingUser.IsUserA(UserTypes.Editor));
                        var displayName = CallingUser.UserName;
                        if (CallingUser.UserID == commentForum.NotSignedInUserId && comment.User != null && !String.IsNullOrEmpty(comment.User.DisplayName))
                        {//add display name for not signed in comment
                            displayName = comment.User.DisplayName;
                        }
                        comment.User = UserReadByCallingUser(site);
                        comment.User.DisplayName = displayName;
                        comment.Created = new DateTimeHelper(DateTime.Now);

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {
// no id as it is may be pre moderated
                            comment.ID = reader.GetInt32NullAsZero("postid");
                            var replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", comment.ID.ToString());
                            comment.ComplaintUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                            SiteList.GetSiteOptionValueString(site.SiteID, "General", "ComplaintUrl")
                                                                                            , replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", commentForum.Id);
                            replacement.Add("sitename", site.SiteName);
                            comment.ForumUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                        UriDiscoverability.UriType.
                                                                                            CommentForumById,
                                                                                        replacement);
                        }
                        else
                        {
                            comment.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue;
                        reader.TryGetIntReturnValue(out returnValue);
                        ParseCreateCommentSpError(returnValue);
                    }
                }
            }
            catch (ApiException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
            }
            //return new comment complete with id etc
            return comment;
        }

        /// <summary>
        /// Creates a comment for the given comment forum id
        /// </summary>
        /// <param name="commentForum"></param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public int CreateCommentRating(Forum commentForum, ISite site, int entryId, int userId, int value)
        {
            if (userId == 0 && (BbcUid == Guid.Empty || string.IsNullOrEmpty(IpAddress)))
            {
                throw ApiException.GetError(ErrorType.MissingUserAttributes);
            }

            var updatedValue = 0;
            //create unique comment hash
            Guid userHash = Guid.Empty;
            if (userId == 0)
            {
                userHash = DnaHasher.GenerateHash(BbcUid + "|" + IpAddress);
            }
            //add comment to db
            try
            {
                using (IDnaDataReader reader = CreateReader("commentratingcreate"))
                {
                    reader.AddParameter("postid", entryId);
                    reader.AddParameter("forumid", commentForum.ForumID);
                    reader.AddParameter("siteid", site.SiteID);
                    
                    reader.AddParameter("userid", userId);
                    reader.AddParameter("userhash", userHash);
                    reader.AddParameter("value", value);
                    
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        updatedValue = reader.GetInt32NullAsZero("value");
                    }
                }
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
            }
            //return new comment complete with id etc
            return updatedValue;
        }

        /// <summary>
        /// Completes all checks on the data before creating it
        /// </summary>
        /// <param name="commentForum"></param>
        /// <param name="comment"></param>
        /// <param name="site"></param>
        /// <param name="ignoreModeration"></param>
        /// <param name="forceModeration"></param>
        public void ValidateComment(Forum commentForum, CommentInfo comment, ISite site, 
            out bool ignoreModeration, out bool forceModeration, out string notes, out List<Term> terms)
        {
            if (CallingUser == null || CallingUser.UserID == 0)
            {
                throw ApiException.GetError(ErrorType.MissingUserCredentials);
            }

            //check if the posting is secure
            try
            {
                int requireSecurePost = SiteList.GetSiteOptionValueInt(site.SiteID, "CommentForum",
                                                                  "EnforceSecurePosting");
                if (!CallingUser.IsSecureRequest && requireSecurePost == 1)
                {
                    throw ApiException.GetError(ErrorType.NotSecure);
                }
            }
            catch (SiteOptionNotFoundException e)
            {
                DnaDiagnostics.WriteExceptionToLog(e);
            }

            ignoreModeration = CallingUser.IsUserA(UserTypes.Editor) || CallingUser.IsUserA(UserTypes.SuperUser);
            if (CallingUser.IsUserA(UserTypes.BannedUser))
            {
                throw ApiException.GetError(ErrorType.UserIsBanned);
            }

            //check if site is open
            if (!ignoreModeration && (site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now)))
            {
                throw ApiException.GetError(ErrorType.SiteIsClosed);
            }
            //is comment forum closed
            if (String.IsNullOrEmpty(comment.text))
            {
                throw ApiException.GetError(ErrorType.EmptyText);
            }
            try
            {
//check for option - if not set then it throws exception
                int maxCharCount = SiteList.GetSiteOptionValueInt(site.SiteID, "CommentForum",
                                                                  "MaxCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(comment.text);
                if (maxCharCount != 0 && tmpText.Length > maxCharCount)
                {
                    throw ApiException.GetError(ErrorType.ExceededTextLimit);
                }
            }
            catch (SiteOptionNotFoundException)
            {
            }

            try
            {
//check for option - if not set then it throws exception
                int minCharCount = SiteList.GetSiteOptionValueInt(site.SiteID, "CommentForum",
                                                                  "MinCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(comment.text);
                if (minCharCount != 0 && tmpText.Length < minCharCount)
                {
                    throw ApiException.GetError(ErrorType.MinCharLimitNotReached);
                }
            }
            catch (SiteOptionNotFoundException)
            {
            }

            //strip out invalid chars
            comment.text = StringUtils.StripInvalidXmlChars(comment.text);

            // Check to see if we're doing richtext and check if its valid xml
            if (comment.PostStyle == PostStyle.Style.unknown)
            {
//default to plain text...
                comment.PostStyle = PostStyle.Style.richtext;
            }
            if (comment.PostStyle == PostStyle.Style.richtext)
            {
                string errormessage = string.Empty;
                // Check to make sure that the comment is made of valid XML
                if (!HtmlUtils.ParseToValidGuideML(comment.text, ref errormessage))
                {
                    DnaDiagnostics.WriteWarningToLog("Comment box post failed xml parse.", errormessage);
                    throw ApiException.GetError(ErrorType.XmlFailedParse);
                }
            }
            //run against profanity filter
            notes = string.Empty;
            CheckForProfanities(site, comment.text, out forceModeration, out notes, out terms, commentForum.ForumID);
            forceModeration = forceModeration ||
                              (commentForum.ModerationServiceGroup > ModerationStatus.ForumStatus.Reactive);
                //force moderation if anything greater than reactive
        }

        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <returns></returns>
        public DateTime CommentListGetLastUpdate(params object[] args)
        {
            var siteId = (int) args[0];
            var prefix = (string) args[1];
            DateTime lastUpdate = DateTime.MinValue;

            using (IDnaDataReader reader = CreateReader("commentsgetlastupdatebysite"))
            {
                try
                {
                    reader.AddParameter("siteid", siteId);
                    if (!String.IsNullOrEmpty(prefix))
                    {
                        reader.AddParameter("prefix", prefix + "%");
                    }
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns last update for given thread
        /// </summary>
        /// <param name="threadid"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public DateTime CommentListGetLastUpdate(int threadid, int siteId)
        {
            DateTime lastUpdate = DateTime.MinValue;

            using (IDnaDataReader reader = CreateReader("commentsgetlastupdatebythreadid"))
            {
                try
                {
                    reader.AddParameter("threadid", threadid);
                    reader.AddParameter("siteid", siteId);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public DateTime CommentForumGetLastUpdate(params object[] args)
        {
            var uid = (string) args[0];
            var siteId = (int) args[1];
            DateTime lastUpdate = DateTime.MinValue;

            using (IDnaDataReader reader = CreateReader("CommentforumGetLastUpdate"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", siteId);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns cache key for comment forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        public string CommentForumCacheKey(string uid, int siteId)
        {
            return string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}", uid, siteId, StartIndex, ItemsPerPage, SortDirection,
                                 SortBy, FilterBy);
        }

        /// <summary>
        /// Returns cache key for comment forum
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="prefix"></param>
        /// <returns></returns>
        public string CommentListCacheKey(int siteId, string prefix)
        {
            return string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}", siteId, StartIndex, ItemsPerPage, SortDirection, SortBy,
                                 FilterBy, prefix);
        }


        /// <summary>
        /// Creates a Reply comment to the given comment thread id
        /// </summary>
        /// <param name="commentForum">The forum containing the comment to post the reply to</param>
        /// <param name="threadId">The thread to post to</param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public CommentInfo CommentReplyCreate(Forum commentForum, int threadId, CommentInfo comment)
        {
            var site = SiteList.GetSite(commentForum.SiteName);
            bool ignoreModeration;
            bool forceModeration;
            var notes = string.Empty;
            string profanityxml = string.Empty;

            List<Term> terms = null;

            ValidateComment(commentForum, comment, site, out ignoreModeration, out forceModeration, out notes, out terms);

            if (terms != null && terms.Count > 0)
            {
                profanityxml = new Term().GetProfanityXML(terms);
            }

            //create unique comment hash
            var guid = DnaHasher.GenerateCommentHashValue(comment.text, commentForum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (IDnaDataReader reader = CreateReader("commentreplycreate"))
                {
                    reader.AddParameter("commentforumid", commentForum.Id);
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", comment.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));
                    reader.AddParameter("ipaddress", IpAddress);
                    reader.AddParameter("bbcuid", BbcUid);
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int) comment.PostStyle);
                    if (!String.IsNullOrEmpty(notes))
                    {
                        reader.AddParameter("modnotes", notes);
                    }

                    if (false == string.IsNullOrEmpty(profanityxml))
                    {
                        reader.AddParameter("profanityxml", profanityxml);
                    }

                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        //all good - create comment
                        comment.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        comment.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        comment.hidden = (comment.IsPreModerated
                                              ? CommentStatus.Hidden.Hidden_AwaitingPreModeration
                                              : CommentStatus.Hidden.NotHidden);
                        comment.User = UserReadByCallingUser(site);
                        comment.Created = new DateTimeHelper(DateTime.Now);

                        //count = reader.GetInt32NullAsZero("ThreadPostCount");

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {
                            // no id as it is may be pre moderated
                            comment.ID = reader.GetInt32NullAsZero("postid");
                            var replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", comment.ID.ToString());
                            comment.ComplaintUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                            SiteList.GetSiteOptionValueString(site.SiteID, "General", "ComplaintUrl")
                                                                                            , replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", commentForum.Id);
                            replacement.Add("sitename", site.SiteName);
                            comment.ForumUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                        UriDiscoverability.UriType.
                                                                                            CommentForumById,
                                                                                        replacement);

                            comment.text = CommentInfo.FormatComment(comment.text, comment.PostStyle, comment.hidden, comment.User.Editor);
                        }
                        else
                        {
                            comment.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue;
                        reader.TryGetIntReturnValue(out returnValue);
                        ParseCreateCommentSpError(returnValue);
                    }
                }
            }
            catch (ApiException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
            }
            //return new comment complete with id etc
            return comment;
        }

        /// <summary>
        /// Gets a comment from it's post id
        /// </summary>
        /// <param name="postid">Post Id of the comment</param>
        /// <param name="site">Site Information</param>
        /// <returns>The comment Info</returns>
        public CommentInfo CommentReadByPostId(string postid, ISite site)
        {
            CommentInfo comment;
            using (IDnaDataReader reader = CreateReader("getcomment"))
            {
                try
                {
                    reader.AddParameter("postid", postid);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        comment = CommentCreateFromReader(reader, site);
                    }
                    else
                    {
                        ApiException exception = ApiException.GetError(ErrorType.CommentNotFound);
                        throw exception;
                    }
                }
                catch (ApiException)
                {
                    throw;
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }
            return comment;
        }

        /// <summary>
        /// Gets a comment from it's post id
        /// </summary>
        /// <param name="postid">Post Id of the comment</param>
        /// <param name="site">Site Information</param>
        /// <returns>The comment Info</returns>
        public int GetStartIndexForPostId(int postid)
        {
            int startIndex=0;
            using (IDnaDataReader reader = CreateReader("getindexofcomment"))
            {
                
                reader.AddParameter("postid", postid);
                reader.AddParameter("sortby", SortBy.ToString());
                reader.AddParameter("sortdirection", SortDirection.ToString());
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    
                    var index = reader.GetInt32NullAsZero("startIndex");
                    startIndex = (index / ItemsPerPage) * ItemsPerPage;

                }
                else
                {
                    throw ApiException.GetError(ErrorType.CommentNotFound);
                    
                }
                
            }
            return startIndex;
        }

        #region Private Functions

        /// <summary>
        /// Creates the commentforumdata from a given reader
        /// </summary>
        /// <param name="reader">The database reaser</param>
        /// <returns>A Filled comment forum object</returns>
        private CommentForum CommentForumCreateFromReader(IDnaDataReader reader)
        {
            var closingDate = reader.GetDateTime("forumclosedate");
            //if (closingDate == null)
            //{
            //    closingDate = DateTime.MaxValue;
            //}
            var site = SiteList.GetSite(reader.GetStringNullAsEmpty("sitename"));

            var commentForum = new CommentForum();

            commentForum.Title = reader.GetStringNullAsEmpty("Title");
            commentForum.Id = reader.GetStringNullAsEmpty("UID");
            commentForum.CanRead = reader.GetByteNullAsZero("canRead") == 1;
            commentForum.CanWrite = reader.GetByteNullAsZero("canWrite") == 1;
            commentForum.ParentUri = reader.GetStringNullAsEmpty("Url");
            commentForum.SiteName = reader.GetStringNullAsEmpty("sitename");
            commentForum.CloseDate = closingDate;
            commentForum.LastUpdate = reader.GetDateTime("LastUpdated");
            if (reader.GetDateTime("lastposted") > commentForum.LastUpdate)
            {
//use last posted as it is newer
                commentForum.LastUpdate = reader.GetDateTime("lastposted");
            }
            commentForum.Updated = new DateTimeHelper(commentForum.LastUpdate);
            commentForum.Created = new DateTimeHelper(reader.GetDateTime("DateCreated"));
            commentForum.commentSummary = new CommentsSummary
                                              {
                                                  Total = reader.GetInt32NullAsZero("ForumPostCount"),
                                                  EditorPicksTotal = reader.GetInt32NullAsZero("editorpickcount")
                                              };
            commentForum.ForumID = reader.GetInt32NullAsZero("forumid");
            commentForum.isClosed = !commentForum.CanWrite || site.IsEmergencyClosed ||
                                    site.IsSiteScheduledClosed(DateTime.Now) ||
                                    (DateTime.Now > closingDate);
            //MaxCharacterCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "'MaxCommentCharacterLength")
            var replacements = new Dictionary<string, string>();
            replacements.Add("commentforumid", reader.GetStringNullAsEmpty("uid"));
            replacements.Add("sitename", site.SiteName);
            commentForum.Uri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                        UriDiscoverability.UriType.CommentForumById,
                                                                        replacements);
            commentForum.commentSummary.Uri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                       UriDiscoverability.UriType.
                                                                                           CommentsByCommentForumId,
                                                                                       replacements);

            //get moderation status
            commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Unknown;
            if (!reader.IsDBNull("moderationstatus"))
            {
//if it is set for the specific forum
                commentForum.ModerationServiceGroup =
                    (ModerationStatus.ForumStatus) (reader.GetTinyIntAsInt("moderationstatus"));
            }
            if (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.Unknown)
            {
//else fall back to site moderation status
                switch (site.ModerationStatus)
                {
                    case ModerationStatus.SiteStatus.UnMod:
                        commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive;
                        break;
                    case ModerationStatus.SiteStatus.PreMod:
                        commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod;
                        break;
                    case ModerationStatus.SiteStatus.PostMod:
                        commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod;
                        break;
                    default:
                        commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive;
                        break;
                }
            }

            commentForum.NotSignedInUserId = reader.GetInt32NullAsZero("NotSignedInUserId");
            commentForum.allowNotSignedInCommenting = commentForum.NotSignedInUserId != 0;
            return commentForum;
        }

        /// <summary>
        /// Creates a commentinfo object
        /// </summary>
        /// <param name="reader">A reader with all information</param>
        /// <param name="site">site information</param>
        /// <returns>Comment info object</returns>
        private CommentInfo CommentCreateFromReader(IDnaDataReader reader, ISite site)
        {
            var commentInfo = new CommentInfo
                                  {
                                      Created =
                                          new DateTimeHelper(DateTime.Parse(reader.GetDateTime("Created").ToString())),
                                      User = UserReadById(reader, site),
                                      ID = reader.GetInt32NullAsZero("id")
                                  };

            commentInfo.hidden = (CommentStatus.Hidden) reader.GetInt32NullAsZero("hidden");
            if (reader.IsDBNull("poststyle"))
            {
                commentInfo.PostStyle = PostStyle.Style.richtext;
            }
            else
            {
                commentInfo.PostStyle = (PostStyle.Style) reader.GetTinyIntAsInt("poststyle");
            }

            commentInfo.IsEditorPick = reader.GetBoolean("IsEditorPick");
            commentInfo.Index = reader.GetInt32NullAsZero("PostIndex");

            //get complainant
            var replacement = new Dictionary<string, string>();
            replacement.Add("sitename", site.SiteName);
            replacement.Add("postid", commentInfo.ID.ToString());
            commentInfo.ComplaintUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                                SiteList.GetSiteOptionValueString(site.SiteID, "General", "ComplaintUrl"),
                                                                                replacement);

            replacement = new Dictionary<string, string>();
            replacement.Add("commentforumid", reader.GetString("forumuid"));
            replacement.Add("sitename", site.SiteName);
            commentInfo.ForumUri = UriDiscoverability.GetUriWithReplacments(BasePath,
                                                                            UriDiscoverability.UriType.CommentForumById,
                                                                            replacement);

            replacement = new Dictionary<string, string>();
            replacement.Add("parentUri", reader.GetString("parentUri"));
            replacement.Add("postid", commentInfo.ID.ToString());
            commentInfo.Uri = UriDiscoverability.GetUriWithReplacments(BasePath, UriDiscoverability.UriType.Comment,
                                                                       replacement);

            if(reader.DoesFieldExist("nerovalue"))
            {
                commentInfo.NeroRatingValue = reader.GetInt32NullAsZero("nerovalue");
            }

            commentInfo.text = CommentInfo.FormatComment(reader.GetString("text"), commentInfo.PostStyle, commentInfo.hidden, commentInfo.User.Editor);
            return commentInfo;
        }

        


        /// <summary>
        /// Preforms the profanity check and returns whether to force moderation
        /// </summary>
        /// <param name="site">the current site</param>
        /// <param name="textToCheck">The text to check</param>
        /// <param name="forceModeration">Whether to force moderation or not</param>
        private static void CheckForProfanities(ISite site, string textToCheck, out bool forceModeration, out string matchingProfanity, out List<Term> terms, int forumId)
        {
            matchingProfanity = string.Empty;
            forceModeration = false;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, textToCheck,
                                                                                    out matchingProfanity, out terms, forumId);

            if (false == string.IsNullOrEmpty(matchingProfanity))
            {
                matchingProfanity = "Filtered terms: " + matchingProfanity; // Adding an extra bit of information for clarity
            }

            if (ProfanityFilter.FilterState.FailBlock == state)
            {
                throw ApiException.GetError(ErrorType.ProfanityFoundInText);
            }
            if (ProfanityFilter.FilterState.FailRefer == state)
            {
                forceModeration = true;
            }
        }

        /// <summary>
        /// Converts SQL error int to plain english error message
        /// </summary>
        /// <param name="errorCode">The error code from the sp</param>
        public static void ParseCreateCommentSpError(int errorCode)
        {
            var exception = new ApiException("Unknown internal error has occurred");
            switch (errorCode)
            {
                case 1:
                    exception = ApiException.GetError(ErrorType.ForumUnknown);
                    break;

                case 2:
                    exception = ApiException.GetError(ErrorType.ForumClosed);
                    break;

                case 3:
                    exception = ApiException.GetError(ErrorType.ForumReadOnly);
                    break;
            }

            throw exception;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool GetCommentForumByUidFromCache(string uid, ISite site, ref CommentForum forum)
        {
            string cacheKey = CommentForumCacheKey(uid, site.SiteID);
            object tempLastUpdated = CacheManager.GetData(cacheKey + CacheLastupdated);

            if (tempLastUpdated == null)
            {
//not found
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            var lastUpdated = (DateTime) tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, CommentForumGetLastUpdate(uid, site.SiteID)) != 0)
            {
//cache out of date so delete
                DeleteCommentForumFromCache(uid, site);
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            forum = (CommentForum) CacheManager.GetData(cacheKey);
            if (forum == null)
            {
//cache out of date so delete
                DeleteCommentForumFromCache(uid, site);
                Statistics.AddCacheMiss();
                return false;
            }
            //apply site variables
            forum = ApplySiteVariables(forum, site);
            Statistics.AddCacheHit();

            //readd to cache to add sliding window affect
            AddCommentForumToCache(forum, site);
            return true;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void AddCommentForumToCache(CommentForum forum, ISite site)
        {
            string cacheKey = CommentForumCacheKey(forum.Id, site.SiteID);
            //ICacheItemExpiration expiry = SlidingTime.
            CacheManager.Add(cacheKey + CacheLastupdated, forum.LastUpdate, CacheItemPriority.Normal,
                             null, new SlidingTime(TimeSpan.FromMinutes(Cacheexpiryminutes)));

            CacheManager.Add(cacheKey, forum, CacheItemPriority.Normal,
                             null, new SlidingTime(TimeSpan.FromMinutes(Cacheexpiryminutes)));
        }

        /// <summary>
        /// Removes forum from cache
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="site"></param>
        private void DeleteCommentForumFromCache(string uid, ISite site)
        {
            string cacheKey = CommentForumCacheKey(uid, site.SiteID);
            CacheManager.Remove(cacheKey + CacheLastupdated);
            CacheManager.Remove(cacheKey);
        }

        /// <summary>
        /// applies the site specific items
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="site"></param>
        /// <returns></returns>
        private static CommentForum ApplySiteVariables(CommentForum forum, ISite site)
        {
            forum.isClosed = forum.isClosed || site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now) ||
                             (DateTime.Now > forum.CloseDate);
            return forum;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="site">the site of the forum</param>
        /// <param name="prefix"></param>
        /// <param name="list"></param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool GetCommentListBySiteFromCache(ISite site, string prefix, ref CommentsList list)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);
            object tempLastUpdated = CacheManager.GetData(cacheKey + CacheLastupdated);

            if (tempLastUpdated == null)
            {
//not found
                list = null;
                Statistics.AddCacheMiss();
                return false;
            }
            var lastUpdated = (DateTime) tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, CommentListGetLastUpdate(site.SiteID, prefix)) != 0)
            {
//cache out of date so delete
                DeleteCommentListFromCache(site, prefix);
                list = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            list = (CommentsList) CacheManager.GetData(cacheKey);
            if (list == null)
            {
//cache out of date so delete
                DeleteCommentListFromCache(site, prefix);
                Statistics.AddCacheMiss();
                return false;
            }
            Statistics.AddCacheHit();

            //readd to cache to add sliding window affect
            AddCommentListToCache(list, site, prefix);
            return true;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="list"></param>
        /// <param name="site">the site of the forum</param>
        /// <param name="prefix"></param>
        /// <returns>true if found in cache otherwise false</returns>
        private void AddCommentListToCache(CommentsList list, ISite site, string prefix)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);

            //ICacheItemExpiration expiry = SlidingTime.
            CacheManager.Add(cacheKey + CacheLastupdated, list.LastUpdate, CacheItemPriority.Normal,
                             null, new SlidingTime(TimeSpan.FromMinutes(Cacheexpiryminutes)));

            CacheManager.Add(cacheKey, list, CacheItemPriority.Normal,
                             null, new SlidingTime(TimeSpan.FromMinutes(Cacheexpiryminutes)));
        }

        /// <summary>
        /// Removes forum from cache
        /// </summary>
        /// <param name="site"></param>
        /// <param name="prefix"></param>
        private void DeleteCommentListFromCache(ISite site, string prefix)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);
            CacheManager.Remove(cacheKey + CacheLastupdated);
            CacheManager.Remove(cacheKey);
        }


        #endregion
    }
}