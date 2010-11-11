using System;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

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

                int canReadAsNum;
                int canWriteAsNum;
                reader.TryGetIntOutputParameter("CanRead", out canReadAsNum);
                reader.TryGetIntOutputParameter("CanWrite", out canWriteAsNum);
                canRead = canReadAsNum > 0;
                canWrite = canWriteAsNum > 0;
            }
        }

        /// <summary>
        /// Returns the thread permission for a given user
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
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
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="postIndex"></param>
        /// <param name="force"></param>
        public void MarkThreadRead(int userId, int threadId, int postIndex, bool force)
        {
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("markthreadread"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("threadid", threadId);
                reader.AddParameter("postindex", postIndex);
                reader.AddParameter("force", force?1:0);
                reader.Execute();
            }
        }

        /// <summary>
        /// Closes a thread
        /// </summary>
        /// <param name="currentSiteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        public void CloseThread(int currentSiteId, int forumId, int threadId)
        {
            bool authorised = (_viewingUser.IsEditor || _viewingUser.IsSuperUser);

            if (!authorised && _siteList.GetSiteOptionValueBool(currentSiteId, "Forum", "ArticleAuthorCanCloseThreads"))
            {//check if author can  modify forum thread.
                authorised = IsUserAuthorForArticle(forumId);
            }
            if (authorised)
            {//do work
                CallCloseThreadSP(threadId);
            }
            else
            {
                LastError = new Error {Type = "CloseThread", ErrorMessage="Logged in user is not authorised to close threads"};
            }

        }

        /// <summary>
        /// Closes a thread with a CallingUser IsSuperUser check
        /// </summary>
        /// <param name="currentSiteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        public void CloseThreadWithCallingUser(int currentSiteId, int forumId, int threadId, BBC.Dna.Users.ICallingUser user, ISiteList siteList)
        {
            bool authorised = (user.IsUserA(BBC.Dna.Users.UserTypes.Editor) || user.IsUserA(BBC.Dna.Users.UserTypes.SuperUser));

            if (!authorised && siteList.GetSiteOptionValueBool(currentSiteId, "Forum", "ArticleAuthorCanCloseThreads"))
            {//check if author can  modify forum thread.
                authorised = IsUserAuthorForArticle(forumId);
            }
            if (authorised)
            {//do work
                CallCloseThreadSP(threadId);
            }
            else
            {
                throw new BBC.Dna.Api.ApiException("Unable to close thread", BBC.Dna.Api.ErrorType.NotAuthorized);
            }

        }

        private void CallCloseThreadSP(int threadId)
        {
            using (IDnaDataReader reader = _creator.CreateDnaDataReader("closethread"))
            {
                reader.AddParameter("threadid", threadId);
                reader.AddParameter("hidethread", false);
                reader.Execute();
            }
        }

        /// <summary>
        /// Reopens a thread - superuser only for editoral reasons
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
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
                            LastError = new Error { Type = "UnHideThread", ErrorMessage = "Unable to open thread" };
                        }
                    }
                    else
                    {
                        LastError = new Error { Type = "UnHideThread", ErrorMessage = "Unable to open thread" };
                    }

                }
            }
            else
            {
                LastError = new Error("UnHideThread", "Logged in user is not authorised to reopen threads");
            }

        }

        /// <summary>
        /// Reopens a thread with a CallingUser IsEditor | IsSuperUser check
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        public void ReOpenThreadWithCallingUser(int forumId, int threadId, BBC.Dna.Users.ICallingUser user)
        {
            if (user.IsUserA(BBC.Dna.Users.UserTypes.Editor) || user.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
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
                            throw new BBC.Dna.Api.ApiException("Unable to unhide thread, doesn't belong to the Forum.", BBC.Dna.Api.ErrorType.UnableToHideUnHideThread);
                        }
                    }
                    else
                    {
                        throw new BBC.Dna.Api.ApiException("Unable to unhide thread", BBC.Dna.Api.ErrorType.UnableToHideUnHideThread);
                    }

                }
            }
            else
            {
                throw new BBC.Dna.Api.ApiException("Unable to unhide thread", BBC.Dna.Api.ErrorType.NotAuthorized);
            }
        }

        /// <summary>
        /// Hides a thread
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
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
                    else
                    {
                        LastError = new Error("HideThread", "Unable to hide thread");
                    }
                }
            }
            else
            {
                LastError = new Error("HideThread", "Logged in user is not authorised to hide threads");
            }

        }

        /// <summary>
        /// Hides a thread with a CallingUser IsSuperUser check
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="user">Calling User</param>
        public void HideThreadWithCallingUser(int forumId, int threadId, BBC.Dna.Users.ICallingUser user)
        {
            if (user.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
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
                            throw new BBC.Dna.Api.ApiException("Unable to hide thread, doesn't belong to the Forum.", BBC.Dna.Api.ErrorType.UnableToHideUnHideThread);
                        }
                    }
                    else
                    {
                        throw new BBC.Dna.Api.ApiException("Unable to hide thread", BBC.Dna.Api.ErrorType.UnableToHideUnHideThread);
                    }
                }
            }
            else
            {
                throw new BBC.Dna.Api.ApiException("Unable to hide thread", BBC.Dna.Api.ErrorType.NotAuthorized);
            }
        }

        /// <summary>
        /// Updates alertinstantly flag
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="alertInstantly"></param>
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

        /// <summary>
        /// Updates forum permissions
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="read"></param>
        /// <param name="write"></param>
        /// <param name="threadRead"></param>
        /// <param name="threadwrite"></param>
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

        /// <summary>
        /// Updates forum moderation status
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="status"></param>
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
                    else
                    {
                        LastError = new Error("FORUM-MOD-STATUS-UPDATE", "Failed to update the moderation status of the forum!");
                    }
                }
                
            }
            else
            {
                LastError = new Error("UpdateForumModerationStatus", "Logged in user is not authorised to update status");
            }

        }

        /// <summary>
        /// checks if viewing user is author
        /// </summary>
        /// <param name="forumId"></param>
        /// <returns></returns>
        public bool IsUserAuthorForArticle(int forumId)
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

        /// <summary>
        /// adds thread to sticky list, based on user permissions and site option
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        public void AddThreadToStickyList(int forumId, int threadId, int siteId)
        {
            //check site option
            if(_siteList.GetSiteOptionValueBool(siteId, "Forum", "EnableStickyThreads") == false)
            {
                LastError = new Error("AddThreadToStickyList", "'EnableStickyThreads' site option is false.");
                return;
            }
            //check viewing user permissions
            if(_viewingUser.IsEditor == false && _viewingUser.IsSuperUser == false)
            {
                LastError = new Error("AddThreadToStickyList", "Viewing user unauthorised.");
                return;
            }

            try
            {
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("addthreadtostickylist"))
                {
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("userid", _viewingUser.UserId);
                    reader.Execute();
                }
            }
            catch (Exception)
            {
                LastError = new Error("AddThreadToStickyList", "Unable to update database.");
            }
        }

        /// <summary>
        /// removes thread from sticky list, based on user permissions and site option
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        public void RemoveThreadFromStickyList(int forumId, int threadId, int siteId)
        {
            //check site option
            if (_siteList.GetSiteOptionValueBool(siteId, "Forum", "EnableStickyThreads") == false)
            {
                LastError = new Error("RemoveThreadFromStickyList", "'EnableStickyThreads' site option is false.");
                return;
            }
            //check viewing user permissions
            if (_viewingUser.IsEditor == false && _viewingUser.IsSuperUser == false)
            {
                LastError = new Error("RemoveThreadFromStickyList", "Viewing user unauthorised.");
                return;
            }

            try
            {
                using (IDnaDataReader reader = _creator.CreateDnaDataReader("removethreadfromstickylist"))
                {
                    reader.AddParameter("forumid", forumId);
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("userid", _viewingUser.UserId);
                    reader.Execute();
                }
            }
            catch (Exception)
            {
                LastError = new Error("RemoveThreadFromStickyList", "Unable to update database.");
            }
        }


    }
}
