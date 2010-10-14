using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class ForumPageBuilder : DnaInputComponent
    {
        private readonly ICacheManager _cache;
        private readonly IDnaDataReaderCreator _creator;
        private readonly ForumHelper _forumHelper;
        private readonly Objects.User _viewingUser;
        private string _cmd = String.Empty;
        private int _forumId;
        private bool _orderByDatePostedDesc = true;
        private int _postId;
        private int _skip;
        private int _threadId;
        private bool _ignoreCache = false;
        private bool _latest = false;

        private const int THREADSTOSHOW = 25;
        private const int POSTSTOSHOW = 50;


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
            //add topics
            if (InputContext.IsPreviewMode())
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetPreviewTopicsXml(_creator)));
            }
            else
            {
                RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
            }

            

            //add forumsource
            ForumSource forumSource = ForumSource.CreateForumSource(_cache, _creator, _viewingUser, _forumId, _threadId,
                                                                    InputContext.CurrentSite.SiteID,
                                                                    true, _ignoreCache, false);

            if (forumSource == null)
            {
                AddErrorXml("ForumOrThreadNotFound", "Unable to find the requested forum or thread.", null);
                return;
            }
            if (forumSource.Type == ForumSourceType.Redirect)
            {
//do redirect now
                AddDnaRedirect(((ForumSourceRedirect) forumSource).Url);
                return;
            }
            SerialiseAndAppend(forumSource, String.Empty);

            ForumThreads threads = new ForumThreads();
            //check for article ForumStyle - if 1 then dont include threads
            if (forumSource.Article != null && forumSource.Article.ForumStyle != 1)
            {
//dont add threads for forumstyle=1
                threads = ForumThreads.CreateForumThreads(_cache, _creator, InputContext.TheSiteList,
                                                                       _forumId,
                                                                       THREADSTOSHOW, _skip, _threadId, false,
                                                                       ThreadOrder.LatestPost, _viewingUser, _ignoreCache);
                SerialiseAndAppend(threads, String.Empty);
            }

            //get subscriptions
            SubscribeState subscribeState = SubscribeState.GetSubscriptionState(_creator,
                                                                                InputContext.ViewingUser.UserID,
                                                                                _threadId, _forumId);
            if (subscribeState != null)
            {
                SerialiseAndAppend(subscribeState, String.Empty);
            }

            if (_latest)
            {
                _skip = threads.GetLatestSkipValue(_threadId, POSTSTOSHOW);
            }

            //add threadposts if required
            if (_threadId > 0 || (forumSource.Article != null && forumSource.Article.ForumStyle == 1))
            {
//get the thread
                ProcessThreadPosts(subscribeState);
                //add online users
                OnlineUsers users = OnlineUsers.GetOnlineUsers(_creator, _cache, OnlineUsersOrderBy.None,
                                                               InputContext.CurrentSite.SiteID, true, _ignoreCache);
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
                                                                         InputContext.TheSiteList,
                                                                         InputContext.CurrentSite.SiteID, _forumId,
                                                                         _threadId, POSTSTOSHOW, _skip, _postId,
                                                                         _orderByDatePostedDesc, _ignoreCache);

            if (thread == null)
            {
                AddErrorXml("ThreadNotFound", "Unable to find the specified forum thread.", null);
                return;
            }

            //process subscription information
            SerialiseAndAppend(thread, String.Empty);


            if (subscribeState != null && subscribeState.Thread != 0 && thread != null && thread.Post.Count > 0)
            {
//update the last read post if the user is subscribed, increment by 1 because its a 0 based index
                _forumHelper.MarkThreadRead(InputContext.ViewingUser.UserID, _threadId,
                                            thread.Post[thread.Post.Count - 1].Index+1, true);
            }
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private void ProcessCommand()
        {
            SubscribeResult result;
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
                        _forumHelper.UpdateForumModerationStatus(_forumId,
                                                                 InputContext.GetParamIntOrZero("status",
                                                                                                "moderationstatus"));
                    }
                    break;

                case "HIDETHREAD":
                    _forumHelper.HideThread(_forumId, _threadId);
                    break;

                case "MAKETHREADSTICKY":
                    if (InputContext.DoesParamExist("stickythreadid", "stickythreadid"))
                    {
                        int stickyThreadId = InputContext.GetParamIntOrZero("stickythreadid", "stickythreadid");
                        _forumHelper.AddThreadToStickyList(_forumId, stickyThreadId, InputContext.CurrentSite.SiteID);
                        
                    }
                    
                    break;

                case "REMOVESTICKYTHREAD":
                    if (InputContext.DoesParamExist("stickythreadid", "stickythreadid"))
                    {
                        int stickyThreadId = InputContext.GetParamIntOrZero("stickythreadid", "stickythreadid");
                        _forumHelper.RemoveThreadFromStickyList(_forumId, stickyThreadId, InputContext.CurrentSite.SiteID);
                    }
                    break;

                case "ALERTINSTANTLY":
                    if (InputContext.DoesParamExist("AlertInstantly", "AlertInstantly flag"))
                    {
                        _forumHelper.UpdateAlertInstantly(_forumId,
                                                          InputContext.GetParamIntOrZero("AlertInstantly",
                                                                                         "AlertInstantly flag"));
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
            {
//an error occurred so add to xml
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
            _skip = InputContext.GetParamIntOrZero("skip", "Number of items to skip to");

            _postId = InputContext.GetParamIntOrZero("post", "A post Id with the above forum");
            InputContext.GetParamIntOrZero("thread", "Whether to show the latest");

            /*Not used
             * string date = InputContext.GetParamStringOrEmpty("date", "To show from this date");
            if (date != String.Empty)
            {
                DateTime.Parse(date);
            }*/
            _latest = (InputContext.GetParamIntOrZero("latest", "shows the latest page") == 1)
                        && _threadId > 0;
            _cmd = InputContext.GetParamStringOrEmpty("cmd", "Which command to execute.");
            InputContext.GetParamStringOrEmpty("type", "Which type of page to build.");
            _orderByDatePostedDesc = InputContext.GetParamIntOrZero("reverseorder", "Whether to reverse the order of posts or not") == 1;
#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }
    }
}