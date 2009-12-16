using System;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation.Utils;
using System.Xml;

namespace BBC.Dna.Api
{
    public class Context
    {
        protected IDnaDiagnostics _dnaDiagnostics=null;
        public IDnaDiagnostics dnaDiagnostics
        {
            get { return _dnaDiagnostics; }
            set { _dnaDiagnostics = value; }
        }

        protected string _connection;
        public string Connection
        {
            get { return _connection; }
        }

        protected ICacheManager _cacheManager = null;

        protected const string CACHE_LASTUPDATED = "|LASTUPDATED";
        protected const int CACHEEXPIRYMINUTES = 60;

        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Context(IDnaDiagnostics dnaDiagnostics, string connection)
        {
            _dnaDiagnostics = dnaDiagnostics;
            _connection = connection;

            if(_dnaDiagnostics == null)
            {
                _dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            }

            _cacheManager = CacheFactory.GetCacheManager();
            
        }

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public Context()
        {
            //create one for this request only if not passed.
            _dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);

            _cacheManager = CacheFactory.GetCacheManager();
        }


        /// <summary>
        /// Returns a data reader for database interactivity
        /// </summary>
        /// <param name="name">The sp name</param>
        /// <returns>A valid data reader</returns>
        public StoredProcedureReader CreateReader(string name)
        {
            if (String.IsNullOrEmpty(_connection))
                return StoredProcedureReader.Create(name, dnaDiagnostics);
            else
                return StoredProcedureReader.Create(name, _connection, dnaDiagnostics);
        }

        /// <summary>
        /// The number of items per page
        /// </summary>
        protected int _itemsPerPage = 20;
        public int ItemsPerPage
        {
            get
            {
                return _itemsPerPage;
            }
            set{ _itemsPerPage = value;}
        }

        /// <summary>
        /// The number of page index
        /// </summary>
        protected int _startIndex = 0;
        public int StartIndex
        {
            get
            {
                return _startIndex;
            }
            set{ _startIndex = value;}
        }

        /// <summary>
        /// The identity sign on type
        /// </summary>
        private string _signOnType = String.Empty;
        public string SignOnType
        {
            get
            {
                return _signOnType;
            }
            set{ _signOnType = value;}
        }

        /// <summary>
        /// The sort by string
        /// </summary>
        protected SortBy _sortBy = SortBy.Created;
        public SortBy SortBy
        {
            get
            {
                
                return _sortBy;
            }
            set { _sortBy = value; }
        }

        /// <summary>
        /// The sort direction
        /// </summary>
        protected SortDirection _sortDirection = SortDirection.Ascending;
        public SortDirection SortDirection
        {
            get
            {

                return _sortDirection;
            }
            set { _sortDirection = value; }
        }

        /// <summary>
        /// The filter criteria
        /// </summary>
        protected FilterBy _filterBy = FilterBy.None;
        public FilterBy FilterBy
        {
            get
            {

                return _filterBy;
            }
            set { _filterBy = value; }
        }

        /// <summary>
        /// The length of the summary to return
        /// </summary>
        private int _summaryLength = 256;
        public int SummaryLength
        {
            get
            {
                
                return _summaryLength;
            }
            set{ _summaryLength = value;}
        }

        /// <summary>
        /// Returns the current sitelist
        /// </summary>
        private ISiteList _siteList;
        public ISiteList siteList
        {
            get { return _siteList; }
            set { _siteList = value; }
        }

        /// <summary>
        /// The BBC UID of the user or taken from the cookie.
        /// </summary>
        private string _bbcUid=String.Empty;
        public string BBCUid
        {
            get
            {

                return _bbcUid;
            }
            set { _bbcUid = value; }
        }

        /// <summary>
        /// The users IPAddress
        /// </summary>
        private string _ipAddress = string.Empty;
        public string IPAddress
        {
            get
            {

                return _ipAddress;
            }
            set { _ipAddress = value; }
        }

        private CallingUser _user;
        public CallingUser CallingUser
        {
            get { return _user; }
            set { _user = value; }
        }

        private string _basePath = String.Empty;
        public string BasePath
        {
            get { return _basePath; }
            set { _basePath = value; }
        }


        /// <summary>
        /// Creates a new comment forum for a specificed site. Note if the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="siteName">The site shortname</param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public void ForumCreate(Forum commentForum, ISite site)
        {
            //validate data
            if (string.IsNullOrEmpty(commentForum.Id) || commentForum.Id.Length > 255)
            {
                throw ApiException.GetError(ErrorType.InvalidForumUid);
            }
            if (string.IsNullOrEmpty(commentForum.ParentUri) || commentForum.ParentUri.IndexOf("bbc.co.uk") < 0)
            {
                throw ApiException.GetError(ErrorType.InvalidForumParentUri);
            }
            if (string.IsNullOrEmpty(commentForum.Title))
            {
                throw ApiException.GetError(ErrorType.InvalidForumTitle);
            }
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
           
            //get the inital moderation status...
            int moderationStatus = (int)commentForum.ModerationServiceGroup;
            //get forum duration in days
            int duration = -1;
            if (commentForum.CloseDate != null)
            {//get the days duration
                //commentForum.CloseDate = new DateTime(commentForum.CloseDate.Year, commentForum.CloseDate.Month, commentForum.CloseDate.Day);//force time to 12:00 so subtract works
                duration = (commentForum.CloseDate.Subtract(DateTime.Today)).Days;//the plus one takes to midnight
            }
            using (StoredProcedureReader reader = CreateReader("commentforumcreate"))
            {
                try
                {
                    reader.AddParameter("uid", commentForum.Id);
                    reader.AddParameter("url", commentForum.ParentUri);
                    reader.AddParameter("title", commentForum.Title);
                    reader.AddParameter("sitename", site.SiteName);
                    if (moderationStatus != 0)
                    {
                        reader.AddParameter("moderationstatus", moderationStatus);
                    }
                    if (duration >= 0)
                    {
                        reader.AddParameter("duration", duration);
                    }
                    reader.Execute();
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
        }


        /// <summary>
        /// Creates a new comment forum for a specificed site. Note if the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="siteName">The site shortname</param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public void ForumUpdate(Forum commentForum, ISite site)
        {
            //validate data
            if (string.IsNullOrEmpty(commentForum.Id) || commentForum.Id.Length > 255)
            {
                throw ApiException.GetError(ErrorType.InvalidForumUid);
            }
            if (string.IsNullOrEmpty(commentForum.ParentUri) || commentForum.ParentUri.IndexOf("bbc.co.uk") < 0)
            {
                throw ApiException.GetError(ErrorType.InvalidForumParentUri);
            }
            if (string.IsNullOrEmpty(commentForum.Title))
            {
                throw ApiException.GetError(ErrorType.InvalidForumTitle);
            }
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            if (commentForum.CloseDate == null)
            {//get the days duration
                throw ApiException.GetError(ErrorType.InvalidForumClosedDate);
            }
            using (StoredProcedureReader reader = CreateReader("commentforumupdate"))
            {
                try
                {
                    reader.AddParameter("uid", commentForum.Id);
                    reader.AddParameter("url", commentForum.ParentUri);
                    reader.AddParameter("title", commentForum.Title);
                    reader.AddParameter("sitename", site.SiteName);
                    reader.AddParameter("moderationstatus", (int)commentForum.ModerationServiceGroup);
                    reader.AddParameter("closeDate", commentForum.CloseDate);
                    reader.Execute();
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }
        }

        /// <summary>
        /// Formats the comment text based on whether its hidden/poststyle
        /// </summary>
        /// <param name="text">The original text</param>
        /// <param name="hidden">The hidden status</param>
        /// <param name="poststyle">the post style</param>
        /// <returns>The formatted comment text</returns>
        static public string FormatCommentText(string text, CommentStatus.Hidden hidden, PostStyle.Style postStyle)
        {
            if (hidden == CommentStatus.Hidden.Hidden_AwaitingPreModeration || hidden == CommentStatus.Hidden.Hidden_AwaitingReferral)
            {
                text = "This post is awaiting moderation.";
            }
            else if (hidden != CommentStatus.Hidden.NotHidden)
            {
                text = "This post has been removed.";
            }
            else
            {
                text = HtmlUtils.RemoveBadHtmlTags(text);
                if (postStyle != PostStyle.Style.plaintext)
                {//if not text then except html
                    string temp = "<RICHPOST>" + text.Replace("\r\n", "<BR />").Replace("\n", "<BR />") + "</RICHPOST>";
                    temp = HtmlUtils.TryParseToValidHtml(temp);
                    XmlDocument xDoc = new XmlDocument();
                    try
                    {
                        xDoc.LoadXml(temp);
                        text = xDoc.FirstChild.InnerXml;//remove the rich post stuff
                    }
                    catch
                    {

                    }

                }
                else
                {
                    text = StringUtils.ConvertPlainText(text);
                }
            }

            return text;
        }
    }
}
