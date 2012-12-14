using System;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Net.Mail;
using System.IO;

namespace BBC.Dna.Api
{
    public class Context
    {
        protected const string CacheLastupdated = "|LASTUPDATED";
        protected const int Cacheexpiryminutes = 10;

        private readonly ICacheManager _cacheManager;
        private readonly IDnaDataReaderCreator _dnaDataReaderCreator;
        private readonly IDnaDiagnostics _dnaDiagnostics;
        private readonly ISiteList _siteList;

        public int ItemsPerPage { get; set; }

        public int StartIndex { get; set; }

        public string SignOnType { get; set; }

        public SortBy SortBy { get; set; }

        public SortDirection SortDirection { get; set; }

        public FilterBy FilterBy { get; set; }

        public int SummaryLength { get; set; }

        public Guid BbcUid { get; set; }

        public string IpAddress { get; set; }

        public ICallingUser CallingUser { get; set; }

        public string BasePath { get; set; }

        public string EmailServerAddress {get; set;}

        public string FileCacheFolder { get; set; }

#if DEBUG
        private string failedEmailFileName = "";
        public void SetFailedEmailFileName(string newFileName)
        {
            failedEmailFileName = newFileName;
        }
#endif

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="dataReaderCreator"></param>
        /// <param name="cacheManager"></param>
        /// <param name="siteList"></param>
        public Context(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
        {
            BasePath = String.Empty;
            IpAddress = string.Empty;
            SummaryLength = 256;
            FilterBy = FilterBy.None;
            SortDirection = SortDirection.Ascending;
            SortBy = SortBy.Created;
            SignOnType = String.Empty;
            ItemsPerPage = 20;
            _dnaDiagnostics = dnaDiagnostics;
            _dnaDataReaderCreator = dataReaderCreator;

            if (_dnaDiagnostics == null)
            {
                _dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            }

            _cacheManager = cacheManager;
            _siteList = siteList;
        }

        public IDnaDiagnostics DnaDiagnostics
        {
            get { return _dnaDiagnostics; }
        }

        public ICacheManager CacheManager
        {
            get { return _cacheManager; }
        }

        public IDnaDataReaderCreator DnaDataReaderCreator
        {
            get { return _dnaDataReaderCreator; }
        }

        public ISiteList SiteList
        {
            get { return _siteList; }
        }

        /// <summary>
        /// Returns a data reader for database interactivity
        /// </summary>
        /// <param name="name">The sp name</param>
        /// <returns>A valid data reader</returns>
        public IDnaDataReader CreateReader(string name)
        {
            return _dnaDataReaderCreator.CreateDnaDataReader(name);
        }

        /// <summary>
        /// Creates a new comment forum for a specificed site. if the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="site"></param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public void CreateForum(Forum commentForum, ISite site)
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
            var moderationStatus = (int) commentForum.ModerationServiceGroup;
            //get forum duration in days
            int duration = 0;
            if (commentForum.CloseDate != DateTime.MinValue)
            {
                duration = (commentForum.CloseDate.Subtract(DateTime.Today)).Days; //the plus one takes to midnight
            }
            
            using (IDnaDataReader reader = CreateReader("commentforumcreate"))
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
                    if (duration > 0)
                    {
                        reader.AddParameter("duration", duration);
                    }
                    reader.Execute();

                    if (reader.Read())
                    {
                        commentForum.ForumID = reader.GetInt32NullAsZero("forumid");
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                    //DnaApiWebProtocalException.ThrowDnaApiWebProtocalException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
                }
            }

            //set up not signed in commenting
            if (commentForum.allowNotSignedInCommenting)
            {
                if (SiteList.GetSiteOptionValueBool(site.SiteID, "CommentForum", "AllowNotSignedInCommenting"))
                {
                    var user = new Dna.Users.User(DnaDataReaderCreator, DnaDiagnostics, CacheManager);
                    user.CreateAnonymousUserForForum(site.SiteID, commentForum.ForumID, "");
                }
            }
        }

        /// <summary>
        /// Creates a new comment forum for a specificed site. If the commentforum id already exists, then nothing will be created
        /// </summary>
        /// <param name="commentForum">The comment forum object</param>
        /// <param name="site"></param>
        /// <returns>The comment forum (either new or existing) which matches to the </returns>
        public void UpdateForum(Forum commentForum, ISite site, bool? isClosed )
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
            using (IDnaDataReader reader = CreateReader("commentforumupdate"))
            {
                try
                {
                    reader.AddParameter("uid", commentForum.Id);
                    reader.AddParameter("url", commentForum.ParentUri);
                    reader.AddParameter("title", commentForum.Title);
                    reader.AddParameter("sitename", site.SiteName);
                    reader.AddParameter("moderationstatus", (int) commentForum.ModerationServiceGroup);
                    if (commentForum.CloseDate != DateTime.MinValue)
                    {
                        reader.AddParameter("closeDate", commentForum.CloseDate);
                    }
                    
                    if (isClosed.HasValue)
                    {
                        reader.AddParameter("canwrite", !isClosed);
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
        /// 
        /// </summary>
        /// <param name="reader"></param>
        /// <returns></returns>
        public User UserReadById(IDnaDataReader reader, ISite site)
        {
            var user = new User
            {
                UserId = reader.GetInt32NullAsZero("UserID"),
                DisplayName = reader.GetStringNullAsEmpty("UserName"),
                Editor = (reader.GetInt32NullAsZero("userIsEditor") == 1),
                Journal = reader.GetInt32NullAsZero("userJournal"),
                Status = reader.GetInt32NullAsZero("userstatus"),
            };
            if (reader.DoesFieldExist("userIsNotable"))
            {
                user.Notable = (reader.GetInt32NullAsZero("userIsNotable") == 1);
            }
            if (reader.DoesFieldExist("identityUserId"))
            {
                user.BbcId = reader.GetStringNullAsEmpty("identityUserId");
            }
            if (reader.DoesFieldExist("TwitterScreenName"))
            {
                user.TwitterScreenName = reader.GetStringNullAsEmpty("TwitterScreenName");
            }

            user.SiteSpecificDisplayName = string.Empty;
            if (SiteList.GetSiteOptionValueBool(site.SiteID, "User", "UseSiteSuffix"))
            {
                if (reader.DoesFieldExist("SiteSpecificDisplayName"))
                {
                    user.SiteSpecificDisplayName = reader.GetStringNullAsEmpty("SiteSpecificDisplayName");
                }
            }
            //if there is an anonymous user name use it
            if(reader.DoesFieldExist("AnonymousUserName") && !String.IsNullOrEmpty(reader.GetStringNullAsEmpty("AnonymousUserName")))
            {
                user.DisplayName = reader.GetStringNullAsEmpty("AnonymousUserName");
            }

            
            return user;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public User UserReadByCallingUser(ISite site)
        {
            var user = new User
            {
                DisplayName = CallingUser.UserName,
                UserId = CallingUser.UserID,
                Editor = CallingUser.IsUserA(UserTypes.Editor),
                Notable = CallingUser.IsUserA(UserTypes.Notable),
                BbcId = CallingUser.IdentityUserID,
                Status = CallingUser.Status,
                SiteSpecificDisplayName = string.Empty,
                Journal = 0
            };
            if (SiteList.GetSiteOptionValueBool(site.SiteID, "User", "UseSiteSuffix"))
            {
                user.SiteSpecificDisplayName = CallingUser.SiteSuffix;
            }

            return user;
        }
        
        public bool SendEmailWithFailMessageOverride(string sender, string recipient, string subject, string body, string filenamePrefix, string failedBody)
        {
            bool sentOk = true;

            MailMessage message = new MailMessage();
            try
            {
                message.From = new MailAddress(sender);

                foreach (string toAddress in recipient.Split(';'))
                    message.To.Add(new MailAddress(toAddress));

                message.Subject = subject;
                message.Body = body;
                message.Priority = MailPriority.Normal;

                SmtpClient client = new SmtpClient(EmailServerAddress);
                client.Timeout = 5;

                //client.SendCompleted += new SendCompletedEventHandler(client_SendCompleted);

                this._dnaDiagnostics.WriteTimedEventToLog("Email", "BeforeSend");
                //client.SendAsync(message, new FailedEmail(sender, recipient, subject, body, filenamePrefix));
                client.Send(message);
                this._dnaDiagnostics.WriteTimedEventToLog("Email", "AfterSend");
            }
            catch (Exception e)
            {
                if (failedBody.Length > 0)
                {
                    body = failedBody;
                }
                WriteFailedEmailToFile(sender, recipient, subject, body + "\r\n" + e.Message, filenamePrefix);
                DnaDiagnostics.WriteExceptionToLog(e);
                sentOk = false;
                message.Dispose();
            }

            return sentOk;
        }

        public bool SendEmail(string sender, string recipient, string subject, string body, string filenamePrefix)
        {
            return SendEmailWithFailMessageOverride(sender, recipient, subject, body, filenamePrefix, "");
        }

        private void client_SendCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            FailedEmail failedMail = (FailedEmail)e.UserState;
            if (e.Error != null || e.Cancelled)
            {
                if (failedMail != null)
                {
                    WriteFailedEmailToFile(failedMail.To, failedMail.From, failedMail.Subject, failedMail.Body + "\n\n" + e.Error.Message + e.Error.InnerException.Message, failedMail.FilePreFix);
                }
                DnaDiagnostics.WriteExceptionToLog(e.Error);
            }
        }

        private void WriteFailedEmailToFile(string sender, string recipient, string subject, string body, string filenamePrefix)
        {
            string failedFrom = "From: " + sender + "\r\n";
            string failedRecipient = "Recipient: " + recipient + "\r\n";
            string failedEmail = failedFrom + failedRecipient + subject + "\r\n" + body;

            //Create filename out of date and random number.
            string fileName = "";
#if DEBUG
            fileName = failedEmailFileName;
#endif
            if (fileName.Length == 0)
            {
                fileName = filenamePrefix + "_" + subject + "_" + DateTime.Now.ToString("yyyy-MM-dd-h:mm:ssffff");
                Random random = new Random(body.Length);
                fileName += "_" + random.Next().ToString() + ".txt";
            }

            foreach (char badChar in Path.GetInvalidFileNameChars())
            {
                fileName = fileName.Replace(badChar,'-');
            }

            FileCaching.PutItem(DnaDiagnostics, FileCacheFolder, "failedmails", fileName, failedEmail);
        }
    }
}