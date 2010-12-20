using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using BBC.Dna.Api;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class PostToForumBuilder : DnaInputComponent
    {
        private readonly ICacheManager _cache;
        private readonly IDnaDataReaderCreator _creator;
        private readonly ForumHelper _forumHelper;
        private readonly Objects.User _viewingUser;
        private string _subject = String.Empty;
        private string _text = String.Empty;
        private int _forumId;
        private int _inReplyTo;
        private int _postStyle;
        private int _threadId;
        private bool _preview   = false;
        private bool _post      = false;
        private QuoteEnum _addQuote = QuoteEnum.None;
        private const int THREADSTOSHOW = 25;
        private const int POSTSTOSHOW = 50;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public PostToForumBuilder(IInputContext context)
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

            //create post to thread form
            PostThreadForm postToForumBuilder = null;
            if (_inReplyTo > 0)
            {
                postToForumBuilder = PostThreadForm.GetPostThreadFormWithReplyTo(_creator, _viewingUser, _inReplyTo);
            }
            else
            {
                postToForumBuilder = PostThreadForm.GetPostThreadFormWithForum(_creator, _viewingUser, _forumId);
            }

            //add post if relevant
            postToForumBuilder.AddPost(_subject, _text, _addQuote);
            
            //add forumsource
            ForumSource forumSource = ForumSource.CreateForumSource(_cache, _creator, _viewingUser, postToForumBuilder.ForumId, postToForumBuilder.ThreadId,
                                                                    InputContext.CurrentSite.SiteID,
                                                                    true, false, false);

            if (forumSource == null)
            {
                AddErrorXml("ForumOrThreadNotFound", "Unable to find the requested forum or thread.", null);
                return;
            }
            SerialiseAndAppend(forumSource, String.Empty);

            if (_post)
            {//do posting
                ThreadPost post = new ThreadPost();
                post.Text = postToForumBuilder.Body;
                post.Subject = postToForumBuilder.Subject;
                post.Style = (BBC.Dna.Objects.PostStyle.Style)postToForumBuilder.Style;
                post.ThreadId = postToForumBuilder.ThreadId;
                post.InReplyTo = postToForumBuilder.InReplyToId;

                try
                {
                    post.PostToForum(_cache, AppContext.ReaderCreator, InputContext.CurrentSite, _viewingUser, InputContext.TheSiteList,
                        InputContext.IpAddress, InputContext.BBCUid,_forumId);
                }
                catch (ApiException e)
                {
                    if (e.type != ErrorType.ProfanityFoundInText)
                    {
                        AddErrorXml(e.type.ToString(), e.Message, null);
                        return;
                    }
                    else
                    {
                        postToForumBuilder.ProfanityTriggered = 1;
                    }
                }

                if (postToForumBuilder.ProfanityTriggered != 1)
                {
                    if (post.IsPreModPosting)
                    {//show premodposting
                        XmlElement postMod = AddElementTag(RootElement, "POSTPREMODERATED");
                        AddAttribute(postMod, "FORUM", _forumId.ToString());
                        AddAttribute(postMod, "THREAD", post.ThreadId.ToString());
                        if (post.ThreadId == 0)
                        {
                            AddAttribute(postMod, "NEWCONVERSATION", "1");
                        }
                        if (InputContext.ViewingUser.IsPreModerated && InputContext.CurrentSite.ModerationStatus != BBC.Dna.Moderation.Utils.ModerationStatus.SiteStatus.PreMod)
                        {
                            AddAttribute(postMod, "USERPREMODERATED", "1");
                        }
                        if (InputContext.ViewingUser.IsAutoSinBin)
                        {
                            AddAttribute(postMod, "AUTOSINBIN", "1");
                        }
                        AddAttribute(postMod, "ISPREMODPOSTING", "1");
                    }
                    else
                    {
                        var redirectUrl = string.Format("NF{0}?thread={1}&post={2}#p{2}", _forumId, post.ThreadId, post.PostId);

                        RootElement.RemoveAll();
                        XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                        AddAttribute(redirect, "URL", redirectUrl);
                    }
                }
            }
            SerialiseAndAppend(postToForumBuilder, String.Empty);
            

            //add page ui to xml
            PageUi pageUi = PageUi.GetPageUi(_creator, forumSource.Article, _viewingUser);
            SerialiseAndAppend(pageUi, String.Empty);
            
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _forumId    = InputContext.GetParamIntOrZero("forum", "Forum ID");
            _threadId   = InputContext.GetParamIntOrZero("threadid", "Forum thread ID");
            _inReplyTo  = InputContext.GetParamIntOrZero("inreplyto", "post to reply to");
            _postStyle = InputContext.GetParamIntOrZero("poststyle", "styel of post");
            if (_postStyle < 1 || _postStyle > 2)
            {
                _postStyle = 2;
            }

            _preview = InputContext.DoesParamExist("preview", "is a preview");
            _post = InputContext.DoesParamExist("post", "Is A Post");
            if (InputContext.DoesParamExist("AddQuoteID", "Add a quote"))
            {
                _addQuote = QuoteEnum.QuoteId;
            }
            if (InputContext.DoesParamExist("AddQuoteUser", "Add a quote"))
            {
                _addQuote = QuoteEnum.QuoteUser;
            }

            //do we need this anymore?
            //m_InputContext.GetParamString("AlertOnReply",sAlertOnRelpy);
            _text = InputContext.GetParamStringOrEmpty("body", "body!");
            _subject = InputContext.GetParamStringOrEmpty("subject", "subject");
        }
    }
}