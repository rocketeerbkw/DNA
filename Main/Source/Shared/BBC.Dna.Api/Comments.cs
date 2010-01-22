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
    public class Comments : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Comments(IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        {}

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public Comments()
        { }

        /// <summary>
        /// Reads all comment forum by sitename
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList CommentForumsRead(string sitename)
        {
            CommentForumList commentForumList = new CommentForumList();
            
            commentForumList.CommentForums = new List<CommentForum>();
            int i = 0;

            try
            {
                   
                using (StoredProcedureReader reader = CreateReader("commentforumsreadbysitename"))
                {
                    reader.AddParameter("siteurlname", sitename);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());
                    
                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while(reader.Read())
                        {
                            CommentForum commentForum = CommentForumCreateFromReader(reader);
                            commentForumList.CommentForums.Add(commentForum);
                            
                            i++;
                            commentForumList.ItemsPerPage = reader.GetInt32NullAsZero("itemsperpage");
                            commentForumList.StartIndex = reader.GetInt32NullAsZero("startindex");
                            commentForumList.TotalCount = reader.GetInt32NullAsZero("totalResults");
                            commentForumList.SortBy = _sortBy;
                            commentForumList.SortDirection = _sortDirection;
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
        /// Reads all comment forum by sitename and uid prefix
        /// </summary>
        /// <param name="sitename">The shortname of the site</param>
        /// <param name="prefix">The prefix of the site to return</param>
        /// <returns>A list of commentforums</returns>
        public CommentForumList CommentForumsRead(string sitename, string prefix)
        {
            CommentForumList commentForumList = new CommentForumList();

            commentForumList.CommentForums = new List<CommentForum>();
            int i = 0;

            try
            {

                using (StoredProcedureReader reader = CreateReader("commentforumsreadbysitenameprefix"))
                {
                    reader.AddParameter("siteurlname", sitename);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("prefix", prefix+"%");
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());
                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            CommentForum commentForum = CommentForumCreateFromReader(reader);
                            commentForumList.CommentForums.Add(commentForum);

                            i++;
                            commentForumList.ItemsPerPage = reader.GetInt32NullAsZero("itemsperpage");
                            commentForumList.StartIndex = reader.GetInt32NullAsZero("startindex");
                            commentForumList.TotalCount = reader.GetInt32NullAsZero("totalResults");
                            commentForumList.SortBy = _sortBy;
                            commentForumList.SortDirection = _sortDirection;
                            commentForumList.FilterBy = _filterBy;
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
        /// <returns>The specified forum including comment data</returns>
        public CommentForum CommentForumReadByUID(string uid, ISite site)
        {
            CommentForum commentForum = null;

            if(CommentForumReadByUIDFromCache(uid, site, ref commentForum))
            {
                return commentForum;
            }

            using (StoredProcedureReader reader = CreateReader("commentforumreadbyuid"))
            {

                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteurlname", site.SiteName);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        commentForum = CommentForumCreateFromReader(reader);
                        commentForum.commentList = CommentsReadByForumID(commentForum.ForumID, site);
                        CommentForumAddToCache(commentForum, site);
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
        /// <param name="siteid">The sites internal id</param>
        /// <returns>The list of comments</returns>
        public CommentsList CommentsReadByForumID(int forumid, ISite site)
        {
            CommentsList commentList = new CommentsList();

            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = _sortBy;
            commentList.SortDirection = _sortDirection;
            commentList.FilterBy = _filterBy;

            String spName = "commentsreadbyforumid";
            if ( _filterBy == FilterBy.EditorPicks )
            {
                spName = "commentsreadbyforumideditorpicksfilter";
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
        public CommentsList CommentsReadBySite(ISite site)
        {
            CommentsList commentList = null;
            if (CommentListReadBySiteFromCache(site, null, ref commentList))
            {
                return commentList;
            }
            commentList = new CommentsList();
            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = _sortBy;
            commentList.SortDirection = _sortDirection;
            commentList.FilterBy = _filterBy;

            // Filter on Editors Picks if specified.
            String spName = "commentsreadbysitename";
            if (_filterBy == FilterBy.EditorPicks)
            {
                spName = "commentsreadbysitenameeditorpicksfilter";
            }

            using (StoredProcedureReader reader = CreateReader(spName))
            {
                try
                {
                    reader.AddParameter("siteid", site.SiteID);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            commentList.LastUpdate = reader.GetDateTime("lastupdate");
                            commentList.comments.Add(CommentCreateFromReader(reader, site));
                            commentList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                        }
                        //add to cache
                        CommentListAddToCache(commentList, site, null);
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
        /// <param name="siteid">The sites internal id</param>
        /// <returns>The list of comments</returns>
        public CommentsList CommentsReadByThreadID(int threadid, ISite site)
        {
            CommentsList commentList = new CommentsList();

            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = _sortBy;
            commentList.SortDirection = _sortDirection;

            using (StoredProcedureReader reader = CreateReader("commentsreadbythreadid"))
            {
                try
                {
                    reader.AddParameter("threadid", threadid);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {//all good - read comments
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
        /// Return Comments for Site and Prefix.
        /// </summary>
        /// <param name="site">The site object</param>
        /// <param name="prefix">The commentforum prefix</param>
        /// <returns>The list of comments</returns>
        public CommentsList CommentsReadBySite(ISite site, string prefix)
        {
            CommentsList commentList = null;
            if (CommentListReadBySiteFromCache(site, prefix, ref commentList))
            {
                return commentList;
            }
            commentList = new CommentsList();
            commentList.comments = new List<CommentInfo>();
            commentList.TotalCount = 0;
            commentList.ItemsPerPage = ItemsPerPage;
            commentList.StartIndex = StartIndex;
            commentList.SortBy = _sortBy;
            commentList.SortDirection = _sortDirection;
            commentList.FilterBy = _filterBy;

            // Filter on Editors Picks if specified.
            String spName = "commentsreadbysitenameprefix";
            if (_filterBy == FilterBy.EditorPicks)
            {
                spName = "commentsreadbysitenameprefixeditorpicksfilter";
            }

            using (StoredProcedureReader reader = CreateReader(spName))
            {
                try
                {
                    reader.AddParameter("siteid", site.SiteID);
                    reader.AddParameter("startindex", StartIndex);
                    reader.AddParameter("itemsperpage", ItemsPerPage);
                    reader.AddParameter("prefix", prefix+"%");
                    reader.AddParameter("sortby", _sortBy.ToString());
                    reader.AddParameter("sortdirection", _sortDirection.ToString());

                    reader.Execute();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            commentList.comments.Add(CommentCreateFromReader(reader, site));
                            commentList.TotalCount = reader.GetInt32NullAsZero("totalresults");
                            commentList.LastUpdate = reader.GetDateTime("lastupdated");
                        }
                        CommentListAddToCache(commentList,site, prefix);
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
        /// Creates a new comment forum for a specificed site. Note if the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="siteName">The site shortname</param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public CommentForum CommentForumCreate(Forum commentForum, ISite site)
        {
            ForumCreate(commentForum, site);
            //return comment forum data
            return CommentForumReadByUID(commentForum.Id, site);
        }

        /// <summary>
        /// Creates a comment for the given comment forum id
        /// </summary>
        /// <param name="commentForumID">The forum to post to</param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public CommentInfo CommentCreate(Forum commentForum, CommentInfo comment)
        {
            ISite site = siteList.GetSite(commentForum.SiteName);
            bool ignoreModeration;
            bool forceModeration;

            ValidateCommentCreate(commentForum, comment, site, out ignoreModeration, out forceModeration);

            //create unique comment hash
            Guid guid = DnaHasher.GenerateCommentHashValue(comment.text, commentForum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (StoredProcedureReader reader = CreateReader("commentcreate"))
                {
                    reader.AddParameter("commentforumid", commentForum.Id);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", comment.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));
                    reader.AddParameter("ipaddress", IPAddress);
                    if (!String.IsNullOrEmpty(BBCUid))
                    {
                        reader.AddParameter("bbcuid", BBCUid);
                    }
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int)comment.PostStyle);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {//all good - create comment
                        comment.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        comment.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        comment.hidden = (comment.IsPreModerated ? CommentStatus.Hidden.Hidden_AwaitingPreModeration : CommentStatus.Hidden.NotHidden);
                        comment.text = FormatCommentText(comment.text, comment.hidden, comment.PostStyle);
                        comment.User = UserReadByCallingUser();
                        comment.Created = new DateTimeHelper(DateTime.Now);

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {// no id as it is may be pre moderated
                            comment.ID = reader.GetInt32NullAsZero("postid");
                            Dictionary<string, string> replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", comment.ID.ToString());
                            comment.ComplaintUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Complaint, replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", commentForum.Id);
                            replacement.Add("sitename", site.SiteName);
                            comment.ForumUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentForumByID, replacement);
                        }
                        else
                        {
                            comment.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue = 0;
                        reader.TryGetIntReturnValue(out returnValue);
                        ParseCreateCommentSPError(returnValue);
                    }

                }
            }
            catch (ApiException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw new ApiException(ex.Message, ex.InnerException);
            }
            //return new comment complete with id etc
            return comment;
        }

        public void ValidateCommentCreate(Forum commentForum, CommentInfo comment, ISite site, out bool ignoreModeration, out bool forceModeration)
        {
            if (CallingUser == null || CallingUser.UserID == 0)
            {
                throw ApiException.GetError(ErrorType.MissingUserCredentials); 
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
            {//check for option - if not set then it throws exception
                int maxCharCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "MaxCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(comment.text);
                if (maxCharCount != 0 && tmpText.Length > maxCharCount)
                {
                    throw ApiException.GetError(ErrorType.ExceededTextLimit);
                }
            }
            catch (SiteOptionNotFoundException) { }

            try
            {//check for option - if not set then it throws exception
                int minCharCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "MinCommentCharacterLength");
                string tmpText = StringUtils.StripFormattingFromText(comment.text);
                if (minCharCount != 0 && tmpText.Length < minCharCount)
                {
                    throw ApiException.GetError(ErrorType.MinCharLimitNotReached);
                }
            }
            catch (SiteOptionNotFoundException) { }

            //strip out invalid chars
            comment.text = StringUtils.StripInvalidXmlChars(comment.text);

            // Check to see if we're doing richtext and check if its valid xml
            if (comment.PostStyle == PostStyle.Style.unknown)
            {//default to plain text...
                comment.PostStyle = PostStyle.Style.richtext;
            }
            if (comment.PostStyle == PostStyle.Style.richtext)
            {
                string errormessage = string.Empty;
                // Check to make sure that the comment is made of valid XML
                if (!HtmlUtils.ParseToValidGuideML(comment.text, ref errormessage))
                {
                    dnaDiagnostics.WriteWarningToLog("Comment box post failed xml parse.", errormessage);
                    throw ApiException.GetError(ErrorType.XmlFailedParse);
                }
            }
            //run against profanity filter
            forceModeration = false;
            CheckForProfanities(site, comment.text, out forceModeration);
            forceModeration = forceModeration || (commentForum.ModerationServiceGroup > ModerationStatus.ForumStatus.Reactive);//force moderation if anything greater than reactive
        }

        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime CommentListGetLastUpdate(params object[] args)
        {
            int siteID = (int)args[0];
            string prefix = (string)args[1];
            DateTime lastUpdate = DateTime.MinValue;

            using (StoredProcedureReader reader = CreateReader("commentsgetlastupdatebysite"))
            {
                try
                {
                    reader.AddParameter("siteid", siteID);
                    reader.AddParameter("prefix", prefix + "%");
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch
                {
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns last update for given thread
        /// </summary>
        /// <param name="threadid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime CommentListGetLastUpdate(int threadid, int siteID)
        {
            DateTime lastUpdate = DateTime.MinValue;

            using (StoredProcedureReader reader = CreateReader("commentsgetlastupdatebythreadid"))
            {
                try
                {
                    reader.AddParameter("threadid", threadid);
                    reader.AddParameter("siteid", siteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch
                {
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns last update for given forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public DateTime CommentForumGetLastUpdate(params object[] args)
        {
            string uid = (string)args[0];
            int siteID = (int)args[1];
            DateTime lastUpdate = DateTime.MinValue;

            using (StoredProcedureReader reader = CreateReader("CommentforumGetLastUpdate"))
            {
                try
                {
                    reader.AddParameter("uid", uid);
                    reader.AddParameter("siteid", siteID);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {//all good - read comments
                        lastUpdate = reader.GetDateTime("lastupdated");
                    }
                }
                catch
                {
                }
            }

            return lastUpdate;
        }

        /// <summary>
        /// Returns cache key for comment forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public string CommentForumCacheKey(string uid, int siteID)
        {
            return string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}", uid, siteID, StartIndex, ItemsPerPage, SortDirection, SortBy, FilterBy);
        }

        /// <summary>
        /// Returns cache key for comment forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public string CommentListCacheKey(int siteID, string prefix)
        {
            return string.Format("{0}|{1}|{2}|{3}|{4}|{5}|{6}", siteID, StartIndex, ItemsPerPage, SortDirection, SortBy, FilterBy, prefix);
        }


        /// <summary>
        /// Creates a Reply comment to the given comment thread id
        /// </summary>
        /// <param name="commentForum">The forum containing the comment to post the reply to</param>
        /// <param name="threadID">The thread to post to</param>
        /// <param name="comment">The comment to add</param>
        /// <returns>The created comment object</returns>
        public CommentInfo CommentReplyCreate(Forum commentForum, int threadID, CommentInfo comment)
        {
            ISite site = siteList.GetSite(commentForum.SiteName);
            bool ignoreModeration;
            bool forceModeration;

            ValidateCommentCreate(commentForum, comment, site, out ignoreModeration, out forceModeration);

            //create unique comment hash
            Guid guid = DnaHasher.GenerateCommentHashValue(comment.text, commentForum.Id, CallingUser.UserID);
            //add comment to db
            try
            {
                using (StoredProcedureReader reader = CreateReader("commentreplycreate"))
                {
                    reader.AddParameter("commentforumid", commentForum.Id);
                    reader.AddParameter("threadid", threadID);
                    reader.AddParameter("userid", CallingUser.UserID);
                    reader.AddParameter("content", comment.text);
                    reader.AddParameter("hash", guid);
                    reader.AddParameter("forcemoderation", forceModeration);
                    //reader.AddParameter("forcepremoderation", (commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.PreMod?1:0));
                    reader.AddParameter("ignoremoderation", ignoreModeration);
                    reader.AddParameter("isnotable", CallingUser.IsUserA(UserTypes.Notable));
                    reader.AddParameter("ipaddress", IPAddress);
                    if (!String.IsNullOrEmpty(BBCUid))
                    {
                        Guid BBCUIDGUID = new Guid();
                        if (ApiCookies.CheckGUIDCookie(BBCUid, ref BBCUIDGUID))
                        {
                            reader.AddParameter("bbcuid", BBCUIDGUID);
                        }
                    }
                    reader.AddIntReturnValue();
                    reader.AddParameter("poststyle", (int)comment.PostStyle);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        //all good - create comment
                        comment.IsPreModPosting = reader.GetInt32NullAsZero("IsPreModPosting") == 1;
                        comment.IsPreModerated = (reader.GetInt32NullAsZero("IsPreModerated") == 1);
                        comment.hidden = (comment.IsPreModerated ? CommentStatus.Hidden.Hidden_AwaitingPreModeration : CommentStatus.Hidden.NotHidden);
                        comment.text = FormatCommentText(comment.text, comment.hidden, comment.PostStyle);
                        comment.User = UserReadByCallingUser();
                        comment.Created = new DateTimeHelper(DateTime.Now);

                        //count = reader.GetInt32NullAsZero("ThreadPostCount");

                        if (reader.GetInt32NullAsZero("postid") != 0)
                        {
                            // no id as it is may be pre moderated
                            comment.ID = reader.GetInt32NullAsZero("postid");
                            Dictionary<string, string> replacement = new Dictionary<string, string>();
                            replacement.Add("sitename", site.SiteName);
                            replacement.Add("postid", comment.ID.ToString());
                            comment.ComplaintUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Complaint, replacement);

                            replacement = new Dictionary<string, string>();
                            replacement.Add("commentforumid", commentForum.Id);
                            replacement.Add("sitename", site.SiteName);
                            comment.ForumUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentForumByID, replacement);
                        }
                        else
                        {
                            comment.ID = 0;
                        }
                    }
                    else
                    {
                        int returnValue = 0;
                        reader.TryGetIntReturnValue(out returnValue);
                        ParseCreateCommentSPError(returnValue);
                    }

                }
            }
            catch (ApiException ex)
            {
                throw ex;
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
        public CommentInfo CommentReadByPostID(string postid, ISite site)
        {
            CommentInfo comment = null;
            using (StoredProcedureReader reader = CreateReader("getcomment"))
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
                        ApiException exception = new ApiException("Unknown internal error has occurred");
                        exception = ApiException.GetError(ErrorType.CommentNotFound);
                        throw exception;
                    }
                }
                catch (ApiException ex)
                {
                    throw ex;
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }
            return comment;
        }

        #region Private Functions

        /// <summary>
        /// Creates the commentforumdata from a given reader
        /// </summary>
        /// <param name="reader">The database reaser</param>
        /// <returns>A Filled comment forum object</returns>
        private CommentForum CommentForumCreateFromReader(StoredProcedureReader reader)
        {
            DateTime closingDate = reader.GetDateTime("forumclosedate");
            //if (closingDate == null)
            //{
            //    closingDate = DateTime.MaxValue;
            //}
            ISite site = siteList.GetSite(reader.GetStringNullAsEmpty("sitename"));
            
            CommentForum commentForum = new CommentForum();
            
            commentForum.Title = reader.GetStringNullAsEmpty("Title");
            commentForum.Id = reader.GetStringNullAsEmpty("UID");
            commentForum.CanRead = reader.GetByteNullAsZero("canRead")==1;
            commentForum.CanWrite = reader.GetByteNullAsZero("canWrite") == 1;
            commentForum.ParentUri = reader.GetStringNullAsEmpty("Url");
            commentForum.SiteName = reader.GetStringNullAsEmpty("sitename");
            commentForum.CloseDate = closingDate;
            commentForum.LastUpdate = (DateTime)reader.GetDateTime("LastUpdated");
            if ((DateTime)reader.GetDateTime("lastposted") > commentForum.LastUpdate)
            {//use last posted as it is newer
                commentForum.LastUpdate = (DateTime)reader.GetDateTime("lastposted");
            }
            commentForum.Updated = new DateTimeHelper(commentForum.LastUpdate);
            commentForum.Created = new DateTimeHelper((DateTime)reader.GetDateTime("DateCreated"));
            commentForum.commentSummary = new CommentsSummary
            {
                Total = reader.GetInt32NullAsZero("ForumPostCount")
            };
            commentForum.ForumID = reader.GetInt32NullAsZero("forumid");
            commentForum.isClosed = !commentForum.CanWrite || site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now) || (closingDate != null && DateTime.Now > closingDate);
            //MaxCharacterCount = siteList.GetSiteOptionValueInt(site.SiteID, "CommentForum", "'MaxCommentCharacterLength")


            
            Dictionary<string, string> replacements = new Dictionary<string, string>();
            replacements.Add("commentforumid", reader.GetStringNullAsEmpty("uid"));
            replacements.Add("sitename", site.SiteName);
            commentForum.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentForumByID, replacements);
            commentForum.commentSummary.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentsByCommentForumID, replacements);
            
            //get moderation status
            commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Unknown;
            if (!reader.IsDBNull("moderationstatus"))
            {//if it is set for the specific forum
                commentForum.ModerationServiceGroup = (ModerationStatus.ForumStatus)(reader.GetTinyIntAsInt("moderationstatus"));
            }
            if(commentForum.ModerationServiceGroup == ModerationStatus.ForumStatus.Unknown)
            {//else fall back to site moderation status
                switch(site.ModerationStatus)
            {
                    case ModerationStatus.SiteStatus.UnMod: commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive; break;
                    case ModerationStatus.SiteStatus.PreMod: commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PreMod; break;
                    case ModerationStatus.SiteStatus.PostMod: commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod; break;
                    default: commentForum.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive; break;
            }
            }
            return commentForum;
        }

        /// <summary>
        /// Creates a commentinfo object
        /// </summary>
        /// <param name="reader">A reader with all information</param>
        /// <param name="site">site information</param>
        /// <returns>Comment info object</returns>
        private CommentInfo CommentCreateFromReader(StoredProcedureReader reader, ISite site)
        {
            CommentInfo commentInfo = new CommentInfo
            {
                text = reader.GetString("text"),
                Created = new DateTimeHelper(DateTime.Parse(reader.GetDateTime("Created").ToString())),
                User = UserReadByID(reader),
                ID = reader.GetInt32NullAsZero("id")
                
            };

            commentInfo.hidden = (CommentStatus.Hidden)reader.GetInt32NullAsZero("hidden");
            if (reader.IsDBNull("poststyle"))
            {
                commentInfo.PostStyle = PostStyle.Style.richtext;
            }
            else
            {
                commentInfo.PostStyle = (PostStyle.Style)reader.GetTinyIntAsInt("poststyle");
            }
            commentInfo.text = FormatCommentText(commentInfo.text, commentInfo.hidden, commentInfo.PostStyle);
            
            //get complainant
            Dictionary<string, string> replacement = new Dictionary<string, string>();
            replacement.Add("sitename", site.SiteName);
            replacement.Add("postid", commentInfo.ID.ToString());
            commentInfo.ComplaintUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Complaint, replacement);
            
            replacement = new Dictionary<string, string>();
            replacement.Add("commentforumid", reader.GetString("forumuid"));
            replacement.Add("sitename", site.SiteName);
            commentInfo.ForumUri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.CommentForumByID, replacement);
            
            replacement = new Dictionary<string, string>();
            replacement.Add("parentUri", reader.GetString("parentUri"));
            replacement.Add("postid", commentInfo.ID.ToString());
            commentInfo.Uri = URIDiscoverability.GetUriWithReplacments(BasePath, URIDiscoverability.uriType.Comment, replacement);

            return commentInfo;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        public User UserReadByID(StoredProcedureReader reader)
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
        public User UserReadByCallingUser()
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
        /// Preforms the profanity check and returns whether to force moderation
        /// </summary>
        /// <param name="site">the current site</param>
        /// <param name="textToCheck">The text to check</param>
        /// <param name="forceModeration">Whether to force moderation or not</param>
        private void CheckForProfanities(ISite site, string textToCheck, out bool forceModeration)
        {
            string matchingProfanity;
            forceModeration = false;
            ProfanityFilter.InitialiseProfanitiesIfEmpty(Connection, dnaDiagnostics);
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, textToCheck, out matchingProfanity);
            if (ProfanityFilter.FilterState.FailBlock == state)
            {
                throw ApiException.GetError(ErrorType.ProfanityFoundInText);
            }
            else if (ProfanityFilter.FilterState.FailRefer == state)
            {
                forceModeration = true;
            }
        }

        /// <summary>
        /// Converts SQL error int to plain english error message
        /// </summary>
        /// <param name="errorCode">The error code from the sp</param>
        public static void ParseCreateCommentSPError(int errorCode)
        {
            ApiException exception = new ApiException("Unknown internal error has occurred");
            switch (errorCode)
            {
                case 1:
                    exception = ApiException.GetError(ErrorType.ForumUnknown); break;

                case 2:
                    exception = ApiException.GetError(ErrorType.ForumClosed); break;

                case 3:
                    exception = ApiException.GetError(ErrorType.ForumReadOnly); break;

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
        private bool CommentForumReadByUIDFromCache(string uid, ISite site, ref CommentForum forum)
        {
            string cacheKey = CommentForumCacheKey(uid, site.SiteID);
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);
            
            if (tempLastUpdated == null)
            {//not found
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, CommentForumGetLastUpdate(uid, site.SiteID)) != 0 )
            {//cache out of date so delete
                DeleteCommentForumFromCache(uid, site);
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            forum = (CommentForum)_cacheManager.GetData(cacheKey);
            if (forum == null)
            {//cache out of date so delete
                DeleteCommentForumFromCache(uid, site);
                forum = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //apply site variables
            forum = ApplySiteVariables(forum, site);
            Statistics.AddCacheHit();

            //readd to cache to add sliding window affect
            CommentForumAddToCache(forum, site);
            return true;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void CommentForumAddToCache(CommentForum forum, ISite site)
        {
            string cacheKey = CommentForumCacheKey(forum.Id, site.SiteID);
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
        private void DeleteCommentForumFromCache(string uid, ISite site)
        {
            string cacheKey = CommentForumCacheKey(uid, site.SiteID);
            _cacheManager.Remove(cacheKey + CACHE_LASTUPDATED);
            _cacheManager.Remove(cacheKey);
        }

        /// <summary>
        /// applies the site specific items
        /// </summary>
        /// <param name="comments"></param>
        /// <returns></returns>
        private CommentForum ApplySiteVariables(CommentForum forum, ISite site)
        {
            forum.isClosed = forum.isClosed || site.IsEmergencyClosed || site.IsSiteScheduledClosed(DateTime.Now) || (forum.CloseDate != null && DateTime.Now > forum.CloseDate);
            return forum;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private bool CommentListReadBySiteFromCache(ISite site, string prefix, ref CommentsList list)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);
            object tempLastUpdated = _cacheManager.GetData(cacheKey + CACHE_LASTUPDATED);

            if (tempLastUpdated == null)
            {//not found
                list = null;
                Statistics.AddCacheMiss();
                return false;
            }
            DateTime lastUpdated = (DateTime)tempLastUpdated;
            //check if cache is up to date
            if (DateTime.Compare(lastUpdated, CommentListGetLastUpdate(site.SiteID, prefix)) != 0)
            {//cache out of date so delete
                DeleteCommentListFromCache(site, prefix);
                list = null;
                Statistics.AddCacheMiss();
                return false;
            }
            //get actual cached object
            list = (CommentsList)_cacheManager.GetData(cacheKey);
            if (list == null)
            {//cache out of date so delete
                DeleteCommentListFromCache(site, prefix);
                list = null;
                Statistics.AddCacheMiss();
                return false;
            }
            Statistics.AddCacheHit();

            //readd to cache to add sliding window affect
            CommentListAddToCache(list, site, prefix);
            return true;
        }

        /// <summary>
        /// Returns the comment forum uid from cache
        /// </summary>
        /// <param name="uid">The uid of the forum</param>
        /// <param name="site">the site of the forum</param>
        /// <param name="forum">The return forum</param>
        /// <returns>true if found in cache otherwise false</returns>
        private void CommentListAddToCache(CommentsList list, ISite site, string prefix)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);

            //ICacheItemExpiration expiry = SlidingTime.
            _cacheManager.Add(cacheKey + CACHE_LASTUPDATED, list.LastUpdate, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));

            _cacheManager.Add(cacheKey, list, CacheItemPriority.Normal,
                null, new SlidingTime(TimeSpan.FromMinutes(CACHEEXPIRYMINUTES)));
        }

        /// <summary>
        /// Removes forum from cache
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="site"></param>
        private void DeleteCommentListFromCache(ISite site, string prefix)
        {
            string cacheKey = CommentListCacheKey(site.SiteID, prefix);
            _cacheManager.Remove(cacheKey + CACHE_LASTUPDATED);
            _cacheManager.Remove(cacheKey);
        }

        #endregion

    }
}
