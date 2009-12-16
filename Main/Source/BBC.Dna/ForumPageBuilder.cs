using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Objects;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class ForumPageBuilder : DnaInputComponent
    {
        private int _forumId = 0;
        private int _threadId = 0;
        private int _skip = 0;
        private int _show = 0;
        private int _postId = 0;
        private int _showLatest = 0;
        private DateTime _dateFrom = DateTime.MinValue;
        private string _cmd = String.Empty;
        private string _framePart = String.Empty;
        private IDnaDataReaderCreator _creator;
        private ICacheManager _cache;
        private bool _orderByDatePostedDesc = true;
        private ForumHelper _forumHelper;
        private BBC.Dna.Objects.User _viewingUser;
        
        


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public ForumPageBuilder(IInputContext context)
            : base(context)
        {
            _creator = new DnaDataReaderCreator(AppContext.TheAppContext.Config.ConnectionString, 
                AppContext.TheAppContext.Diagnostics);

            _cache = CacheFactory.GetCacheManager();
            //this is a clutch until we unify user objects
            _viewingUser = InputContext.ViewingUser.ConvertUser();

            _forumHelper = new ForumHelper(_creator, _viewingUser, InputContext.TheSiteList);
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            
            //get the parameters from the querystring
            GetQueryParameters();
            //Process any commands sent through querystring
            ProcessCommand();

            //Assemble page parts.

            //add forumsource
            ForumSource forumSource = ForumSource.CreateForumSource(_cache, _creator, _viewingUser, _forumId, _threadId, InputContext.CurrentSite.SiteID,
                true, false);
            if (forumSource.Type == ForumSourceType.Redirect)
            {//do redirect now
                AddDnaRedirect(((ForumSourceRedirect)forumSource).Url);
                return;
            }
            SerialiseAndAppend(forumSource, String.Empty);

            //check for article ForumStyle - if 1 then dont include threads
            if (forumSource.Article != null && forumSource.Article.ForumStyle != 1)
            {//dont add threads for forumstyle=1
                ForumThreads threads = ForumThreads.CreateForumThreads(_cache, _creator, InputContext.TheSiteList, _forumId,
                    _show, _skip, _threadId, false, ThreadOrder.LatestPost, _viewingUser, false);
                SerialiseAndAppend(threads, String.Empty);
            }

            //get subscriptions
            SubscribeState subscribeState = SubscribeState.GetSubscriptionState(_creator, InputContext.ViewingUser.UserID, _threadId, _forumId);
            if (subscribeState != null)
            {
                SerialiseAndAppend(subscribeState, String.Empty);
            }

            //add threadposts if required
            if (_threadId > 0 || (forumSource.Article != null && forumSource.Article.ForumStyle == 1))
            {//get the thread
                ProcessThreadPosts(subscribeState);
                //add online users
                OnlineUsers users = OnlineUsers.GetOnlineUsers(_creator, _cache, OnlineUsersOrderBy.None, InputContext.CurrentSite.SiteID, true, false);
                SerialiseAndAppend(users, String.Empty);
            }

            //add page ui to xml
            PageUi pageUi = PageUi.GetPageUi(_creator, forumSource.Article, _viewingUser);
            SerialiseAndAppend(pageUi, String.Empty);
            
        }
        /*

        /// <summary>
        /// This is legacy ripley code which is not supported in this version of forums
        /// </summary>
        private void ProcessTypeParameter()
        {
            //ProcessCommand base on type
            switch (_framePart.ToUpper())
            {
                case "FUP":
                    UpdatePageType("TOPFRAME");
                    break;

                case "TEST":

                    break;

                case "FLFT":
                    UpdatePageType("SIDEFRAME");
                    break;

                case "FSRC":
                    break;

                case "FTH":
                    UpdatePageType("FRAMETHREADS");
                    break;

                case "FMSG":
                    UpdatePageType("MESSAGEFRAME");
                    break;

                case "HEAD":
                    UpdatePageType("THREADPAGE");
                    //TODO check out forumpage element?
                    break;

                case "FTHR":
                    break;

                case "BIGP":
                    break;

                case "SUBS":
                    break;

                default:
                    if (_threadId > 0)
                    {
                        UpdatePageType("MULTIPOSTS");
                    }
                    break;
            }
        }
         */

        /// <summary>
        /// Processes the thread posts
        /// </summary>
        private void ProcessThreadPosts(SubscribeState subscribeState)
        {
            ForumThreadPosts thread = ForumThreadPosts.CreateThreadPosts(_creator, _cache, _viewingUser, 
                InputContext.TheSiteList, InputContext.CurrentSite.SiteID, _forumId, _threadId, _show, _skip, _postId, 
                _orderByDatePostedDesc, false);
            //process subscription information
            SerialiseAndAppend(thread, String.Empty);

            
            if (subscribeState != null && subscribeState.Thread != 0 && thread != null && thread.Post.Count > 0)
            {//update the last read post if the user is subscribed
                _forumHelper.MarkThreadRead(InputContext.ViewingUser.UserID, _threadId, thread.Post[thread.Post.Count - 1].PostId, true);
            }
            
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private void ProcessCommand()
        {
            SubscribeResult result = null;
            switch (_cmd.ToUpper())
            {
                case "CLOSETHREAD":
                    _forumHelper.CloseThread(InputContext.CurrentSite.SiteID, _forumId, _threadId);
                    break;

                case "REOPENTHREAD":
                    _forumHelper.ReOpenThread(_forumId, _threadId);
                    break;

                case "FORUMPERM":
                    int? read = null;
                    if (InputContext.DoesParamExist("read", "canread flag"))
                    {
                        read = InputContext.GetParamIntOrZero("read", "canread flag");
                    }
                    int? write = null;
                    if (InputContext.DoesParamExist("write", "canwrite flag"))
                    {
                        write = InputContext.GetParamIntOrZero("write", "canwrite flag");
                    }
                    int? threadread = null;
                    if (InputContext.DoesParamExist("threadread", "threadread flag"))
                    {
                        threadread = InputContext.GetParamIntOrZero("threadread", "threadread flag");
                    }
                    int? threadwrite = null;
                    if (InputContext.DoesParamExist("threadwrite", "threadwrite flag"))
                    {
                        threadwrite = InputContext.GetParamIntOrZero("threadwrite", "threadwrite flag");
                    }
                    _forumHelper.UpdateForumPermissions(_forumId, read, write, threadread, threadwrite);
                    break;

                case "UPDATEFORUMMODERATIONSTATUS":
                    if (InputContext.DoesParamExist("status", "moderationstatus"))
                    {
                        _forumHelper.UpdateForumModerationStatus(_forumId, InputContext.GetParamIntOrZero("status", "moderationstatus"));
                    }
                    break;

                case "HIDETHREAD":
                    _forumHelper.HideThread(_forumId, _threadId);
                    break;

                case "ALERTINSTANTLY":
                    if (InputContext.DoesParamExist("AlertInstantly", "AlertInstantly flag"))
                    {
                        _forumHelper.UpdateAlertInstantly(_forumId, InputContext.GetParamIntOrZero("AlertInstantly", "AlertInstantly flag"));
                    }
                    break;

                case "SUBSCRIBETHREAD":
                    result = SubscribeResult.SubscribeToThread(_creator, InputContext.ViewingUser.UserID, _threadId,
                        _forumId, false);
                    SerialiseAndAppend(result, String.Empty);
                    break;

                case "UNSUBSCRIBETHREAD":
                    result = SubscribeResult.SubscribeToThread(_creator, InputContext.ViewingUser.UserID, _threadId,
                        _forumId, true);
                    SerialiseAndAppend(result, String.Empty);
                    break;

                case "SUBSCRIBEFORUM":
                    result = SubscribeResult.SubscribeToForum(_creator, InputContext.ViewingUser.UserID, _forumId, false);
                    SerialiseAndAppend(result, String.Empty);
                    break;

                case "UNSUBSCRIBEFORUM":
                    result = SubscribeResult.SubscribeToForum(_creator, InputContext.ViewingUser.UserID, _forumId, true);
                    SerialiseAndAppend(result, String.Empty);
                    break;

            }

            if (_forumHelper.LastError != null)
            {//an error occurred so add to xml
                SerialiseAndAppend(_forumHelper.LastError, "");
            }
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {

            _forumId = InputContext.GetParamIntOrZero("ID", "Forum ID");
            if (_forumId == 0)
            {
                _forumId = InputContext.GetParamIntOrZero("forum", "Forum ID");
            }

            _threadId = InputContext.GetParamIntOrZero("thread", "Forum thread ID"); 
            _skip = InputContext.GetParamIntOrZero("skip", "Number of items to skip to") ;
            _show = InputContext.GetParamIntOrZero("show", "Number of items to show");
            if (_show == 0)
            {//default to 20
                _show = 20;
            }

            _postId = InputContext.GetParamIntOrZero("post", "A post Id with the above forum");
            _showLatest = InputContext.GetParamIntOrZero("thread", "Whether to show the latest");
            
            string _date = InputContext.GetParamStringOrEmpty("date", "To show from this date");
            if(_date != String.Empty)
            {
                _dateFrom = DateTime.Parse(_date);
            }
            _cmd = InputContext.GetParamStringOrEmpty("cmd", "Which command to execute.");
            _framePart = InputContext.GetParamStringOrEmpty("type", "Which type of page to build.");
            _orderByDatePostedDesc = InputContext.GetParamIntOrZero("reverseorder", "Whether to reverse the order of posts or not") == 1;
            
        }
    }
}


