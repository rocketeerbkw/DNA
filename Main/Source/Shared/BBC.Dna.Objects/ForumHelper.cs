using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Sites;

namespace BBC.Dna.Objects
{
    public class ForumHelper
    {
        private IDnaDataReaderCreator _creator = null;
        private IUser _viewingUser = null;
        private ISiteList _siteList = null;

        public Error LastError 
        { get; set; }

        public ForumHelper(IDnaDataReaderCreator creator)
        {
            _creator = creator;
        }

        public ForumHelper(IDnaDataReaderCreator creator, IUser viewingUser, ISiteList siteList)
        {
            _creator = creator;
            _viewingUser = viewingUser;
            _siteList = siteList;
        }

        /// <summary>
        /// Returns forum read/write permissions for a user
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="forumId"></param>
        /// <param name="canRead"></param>
        /// <param name="canWrite"></param>
        public void GetForumPermissions(int userId, int forumId, ref bool canRead, ref bool canWrite)
        {
            canRead = false;
            canWrite = false;
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("getforumpermissions"))
            {
                reader.AddParameter("UserID", userId);
                reader.AddParameter("ForumID", forumId);
                reader.AddIntOutputParameter("CanRead");
                reader.AddIntOutputParameter("CanWrite");
                reader.Execute();

                int canReadAsNum = 0;
                int canWriteAsNum = 0;
                reader.TryGetIntOutputParameter("CanRead", out canReadAsNum);
                reader.TryGetIntOutputParameter("CanWrite", out canWriteAsNum);
                canRead = canReadAsNum > 0;
                canWrite = canWriteAsNum > 0;
            }
        }

        /// <summary>
        /// Returns thread read/write permissions for a user
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="forumId"></param>
        /// <param name="canRead"></param>
        /// <param name="canWrite"></param>
        public void GetThreadPermissions(int userId, int threadId, ref bool canRead, ref bool canWrite)
        {
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("getthreadpermissions"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("threadid", threadId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    canRead = reader.GetBoolean("CanRead");
                    canWrite = reader.GetBoolean("CanWrite");
                }
            }
        }

        /// <summary>
        /// Marks the current thread as read for subscription.
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="force"></param>
        public void MarkThreadRead(int userId, int threadId, int postId, bool force)
        {
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("markthreadread"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("threadid", threadId);
                reader.AddParameter("postid", postId);
                reader.AddParameter("force", force?1:0);
                reader.Execute();
            }
        }


        public void CloseThread(int currentSiteId, int forumId, int threadId)
        {
            bool authorised = false;
            authorised = (_viewingUser.IsEditor || _viewingUser.IsSuperUser);

            if (!authorised && _siteList.GetSiteOptionValueBool(currentSiteId, "Forum", "ArticleAuthorCanCloseThreads"))
            {//check if author can  modify forum thread.
                authorised = IsUserAuthorForArticle(forumId);
            }
            if (authorised)
            {//do work
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("closethread"))
                {
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("hidethread", false);
                    reader.Execute();
                }
            }
            else
            {
                LastError = new Error(){Type = "CloseThread", ErrorMessage="Logged in user is not authorised to close threads"};
            }

        }

        public void ReOpenThread(int forumId, int threadId)
        {
            if (_viewingUser.IsEditor || _viewingUser.IsSuperUser)
            {//do work
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("SetThreadVisibletoUsers"))
                {
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("Visible", true);
                    reader.Execute();

                    if (reader.Read())
                    {
                        if (reader.GetInt32NullAsZero("ThreadBelongsToForum") != 1)
                        {
                            LastError = new Error() { Type = "UnHideThread", ErrorMessage = "Unable to open thread" };
                        }
                    }
                }
            }
            else
            {
                LastError = new Error("UnHideThread", "Logged in user is not authorised to reopen threads");
            }

        }

        public void HideThread(int forumId, int threadId)
        {
            if (_viewingUser.IsSuperUser)
            {//do work
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("SetThreadVisibletoUsers"))
                {
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("Visible", false);
                    reader.Execute();

                    if (reader.Read())
                    {
                        if (reader.GetInt32NullAsZero("ThreadBelongsToForum") != 1)
                        {
                            LastError = new Error("HideThread", "Unable to hide thread");
                        }
                    }
                }
            }
            else
            {
                LastError = new Error("HideThread", "Logged in user is not authorised to hide threads");
            }

        }

        public void UpdateAlertInstantly(int forumId, int alertInstantly)
        {
            if (_viewingUser.IsEditor || _viewingUser.IsSuperUser)
            {//do work
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("UpdateForumAlertInstantly"))
                {
                    reader.AddParameter("alert", alertInstantly > 0 ? 1 : 0);
                    reader.AddParameter("forumid", forumId);
                    reader.Execute();
                }
            }
            else
            {
                LastError = new Error("UpdateAlertInstantly", "Logged in user is not authorised to update AlertInstantly flag");
            }

        }

        public void UpdateForumPermissions(int forumId, int? read, int? write, int? threadRead, int? threadwrite)
        {
            if (_viewingUser.IsEditor || _viewingUser.IsSuperUser)
            {
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("updateforumpermissions"))
                {
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("canread", read);
                    reader.AddParameter("canwrite", write);
                    reader.AddParameter("threadcanread", threadRead);
                    reader.AddParameter("threadcanwrite", threadwrite);
                    reader.Execute();
                }
            }
            else
            {
                LastError = new Error("UpdateForumPermissions", "Logged in user is not authorised to update forum permissions");
            }
        }

        public void UpdateForumModerationStatus(int forumId, int status)
        {
            if (_viewingUser.IsEditor || _viewingUser.IsSuperUser)
            {//do work
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("updateforummoderationstatus"))
                {
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("newstatus", status);
                    reader.Execute();

                    if (reader.Read())
                    {
                        if (reader.GetInt32NullAsZero("Success") != 1)
                        {
                            LastError = new Error("FORUM-MOD-STATUS-UPDATE", "Failed to update the moderation status of the forum!");
                        }
                    }
                }
                
            }
            else
            {
                LastError = new Error("UpdateForumModerationStatus", "Logged in user is not authorised to update status");
            }

        }

        private bool IsUserAuthorForArticle(int forumId)
        {
            bool authorised;
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("isuserinauthormembersofarticle"))
            {
                reader.AddParameter("userid", _viewingUser.UserId);
                reader.AddParameter("forumid", forumId);
                reader.Execute();

                authorised = (reader.HasRows && reader.Read());
            }
            return authorised;
        }
    }
}
