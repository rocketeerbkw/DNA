using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Api;
using BBC.Dna.Users;
using System.Web.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching;


namespace BBC.Dna.Component
{
    /// <summary>
    /// CommentBoxForum - A derived DnaComponent object
    /// </summary>
    public class CommentBoxForumUsingAPI : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the CommentBoxForum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public CommentBoxForumUsingAPI(IInputContext context)
            : base(context)

        {
        }

		private const string _docUID = @"A unique ID for this set of comments. GUIDs are preferred but any string is acceptable as long as you can be sure it's unique for the page the comments are on";
        private const string _docHostPageUrl = @"The URL of the page in which the comment box is embedded.";
        private const string _docInitialTitle = @"An Initial title for the comment box, which might be displayed on a list of comment boxes";
        private const string _docDnaFrom = @"Zero-based index of the lowest numbered post in the comment list to be shown on the page";
        private const string _docDnaTo = @"Zero-based index of the highest-numered post in the comment list to be shown on the page";
        private const string _docModUserID = @"UserID of the user whose message has been premoderated. Passed in by the framework, internal use only.";
        private const string _docPostID = @"Post ID of the post which has been moderated. Internal use only.";
        private const string _docUserPreModerated = @"Flag indicating of the user is premoderated. Internal use only";
        private const string _docAutoSinBin = @"AutoSinBin indicates if the user is in the AutoSinBin and is having posts premoderated. Internal use only.";
        private const string _docPostPremod = @"Post Premod indicates that the post was premoderated. Internal use only.";
        private const string _docDnaErrorType = @"The type of error caused by the previous action. This parameter is used by the framework to pass errors back to the host page embedded comments so that a response can be displayed to the user. See also dnaerrormessage";
        private const string _docDnaErrorMessage = @"Error message passed in by the framework after a user action has failed in some way";
        private const string _docDnaShow = "The number of posts to show (in the absence of dnafrom and dnato parameters).";
        private const string _docDnaInitialModStatus = @"Desired initial moderation status of this comment box. 
Only use this parameter if you want to explicitly override the moderation status of a comment box at the point of creation. 
This paramter will not change the status of an existing comment box.
Possible values are 'reactive', 'postmod' and 'premod'";
        

        static private Regex _dnaHostPageUrlRegEx = new Regex(@"^http://[\w\.\-]+\.bbc\.co\.uk(:\d+)?/");

        XmlNode _commentBoxNode = null;
        private Comments comments;

        DnaCache _cache = new DnaCache();

        //parameters
        private string _url = String.Empty;
        private bool _createIfNotExist = true;
        private string _title = String.Empty;
        private int _fromPostIndex=0;
        private int _toPostIndex=0;
        private int _show=0;
        private ModerationStatus.ForumStatus _moderationStatus = ModerationStatus.ForumStatus.Unknown;
        private int _forumDuration = -1;
        private string _uid = string.Empty;
        private string _action = String.Empty;

        /// <summary>
        /// Parses the input parameters and updates private members
        /// </summary>
        /// <returns>true if ok otherwise error occurred</returns>
        private bool ParseParameters()
        {


            InputContext.TryGetParamString("dnauid", ref _uid, _docUID);
            

            if (InputContext.DoesParamExist("dnahostpageurl", _docHostPageUrl))
            {
                InputContext.TryGetParamString("dnahostpageurl", ref _url, _docHostPageUrl);
                if (_url != String.Empty)
                {
                    // If we are running on a development server, don't check the URL
                    if (!InputContext.IsRunningOnDevServer)
                    {
                        Match m = _dnaHostPageUrlRegEx.Match(_url);
                        if (!m.Success)
                        {
                            AddErrorXml("invalidparameters", "Not a http://*.bbc.co.uk host page url address", null);
                            return false;
                        }
                    }
                }
                else
                {
                    // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                    _createIfNotExist = false;
                }
            }
            else
            {
                // If we don't have a host url, then we cannot create the forum if it does not exist as it is a manditory field
                _createIfNotExist = false;
            }

            if (InputContext.DoesParamExist("dnainitialtitle", _docInitialTitle))
            {
                InputContext.TryGetParamString("dnainitialtitle", ref _title, _docInitialTitle);
                if (_title != String.Empty)
                {
                    //TODO: Checking of title user entered value
                }
                else
                {
                    // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                    _createIfNotExist = false;
                }
            }
            else
            {
                // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                _createIfNotExist = false;
            }

            _fromPostIndex = InputContext.GetParamIntOrZero("dnafrom", _docDnaFrom);
            if (_fromPostIndex < 0)
            {
                _fromPostIndex = 0;
            }

            _toPostIndex = InputContext.GetParamIntOrZero("dnato", _docDnaTo);
            if (_toPostIndex < 0)
            {
                _toPostIndex = 0;
            }

            _show = InputContext.GetParamIntOrZero("dnashow", _docDnaShow);
            if (_show > 500)
            {
                //cap the maximum number of records to show per page
                _show = 500;
            }
            else if (_show < 1)
            {
                //if an erroneous, minus value or missing show value then set to the default
                _show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
            }

            bool moderationStatusExists = InputContext.DoesParamExist("dnainitialmodstatus", _docDnaInitialModStatus);
            if (moderationStatusExists)
            {
                string dnaModStatus = InputContext.GetParamStringOrEmpty("dnainitialmodstatus", _docDnaInitialModStatus);
                if (dnaModStatus == "reactive")
                {
                    _moderationStatus = ModerationStatus.ForumStatus.Reactive;
                }
                else if (dnaModStatus == "postmod")
                {
                    _moderationStatus = ModerationStatus.ForumStatus.PostMod;
                }
                else if (dnaModStatus == "premod")
                {
                    _moderationStatus = ModerationStatus.ForumStatus.PreMod;
                }
                else
                {
                    AddErrorXml("invalidparameters", "Illegal Initial Moderation Status setting (" + dnaModStatus + ")", null);
                    return false;
                }
            }

            // Check to see if we've been given a date to close by
            bool ForumCloseDateExists = InputContext.DoesParamExist("dnaforumclosedate", @"The date that the forum should close");
            bool ForumCloseDurationExists = InputContext.DoesParamExist("dnaforumduration", @"The number of days starting from now that the forum will be open for");
            if (ForumCloseDateExists || ForumCloseDurationExists)
            {
                // Work out the date and pass this to the GetCommentForum function
                string durationValue = String.Empty;
                bool gotForumCloseDate = InputContext.TryGetParamString("dnaforumclosedate", ref durationValue, @"The date that the forum should close");
                if (gotForumCloseDate)
                {
                    // Try to parse the date
                    try
                    {
                        // Set the closing date from the value - The format of the date is YYYYMMDD.
                        TimeSpan closeDate = new DateTime(Convert.ToInt32(durationValue.Substring(0, 4)), Convert.ToInt32(durationValue.Substring(4, 2).TrimStart('0')), Convert.ToInt32(durationValue.Substring(6, 2).TrimStart('0'))).Subtract(DateTime.Today);
                        _forumDuration = closeDate.Days;
                    }
                    // TODO: Only catch explicit exception
                    catch (Exception ex)
                    {
                        return AddErrorXml("invalidparameters", "Invalid date format given for forumclosedate. " + ex.Message, null);
                    }
                }
                else if (InputContext.TryGetParamString("dnaforumduration", ref durationValue, "The number of days starting from now that the forum will be open for"))
                {
                    // Set the closing date from the value
                    _forumDuration = Convert.ToInt32(durationValue);
                }
            }

            
            if (!InputContext.TryGetParamString("dnaaction", ref _action, "Action to take on this request. 'add' is the only action currently recognised"))
            {
                _action = String.Empty;
            }


            return true;
        }
        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            // Add in comment box element
            _commentBoxNode = AddElementTag(RootElement, "COMMENTBOX");

            if (!ParseParameters())
                return;//an error occurred

            //create api object
            comments = new Comments(InputContext.Diagnostics, AppContext.ReaderCreator, CacheFactory.GetCacheManager(), AppContext.TheAppContext.TheSiteList)
            {
                BbcUid = InputContext.BBCUid,
                IpAddress = InputContext.IpAddress,
            };
            //try and get the forum or create
            CommentForum forum = null;
            if(!String.IsNullOrEmpty(_uid))
            {
                if (TryGetCommentForum(_uid, ref forum))
                {
                    if (_action.ToUpper() == "ADD")
                    {
                        AddComment(forum);
                        
                    }
                }
            }
            ProcessIncomingError();
            ProcessModerationInfo();
        }

        /// <summary>
        /// gets or creates the comment forum
        /// </summary>
        /// <param name="uid"></param>
        /// <param name="commentForum">the commentforum referenced</param>
        /// <returns></returns>
        private bool TryGetCommentForum(string uid, ref CommentForum commentForum)
        {

            //set paging options
            comments.StartIndex = _fromPostIndex;
            // use the larger of show or toPostIndex - fromPostIndex
            comments.ItemsPerPage = (_show > (_toPostIndex - _fromPostIndex)) ? _show : (_toPostIndex - _fromPostIndex);

            //try and get the existing forum
            commentForum = null;
            try
            {
                commentForum = comments.GetCommentForumByUid(uid, InputContext.CurrentSite);
            }
            catch (DnaException ex)
            {
                AddErrorXml("internal", "An internal error occurred. " + ex.Message, null);
                return false;
            }

            if (commentForum == null)
            {// comment forum doesn't exist
                if (_createIfNotExist)
                {//so create it
                    commentForum = new CommentForum()
                    {
                        Id = uid,
                        Title = _title,
                        ParentUri = _url,
                        ModerationServiceGroup = _moderationStatus
                    };
                    if (_forumDuration != -1)
                    {//add close date
                        if (_forumDuration == 0)
                        {//for some reason a duration  of 0 actually means 1 day...
                            commentForum.CloseDate = DateTime.Now.AddDays(1);
                        }
                        else
                        {
                            commentForum.CloseDate = DateTime.Now.AddDays(_forumDuration);
                        }
                    }
                    try
                    {
                        commentForum = comments.CreateCommentForum(commentForum, InputContext.CurrentSite);
                    }
                    catch (DnaException ex)
                    {
                        AddErrorXml("internal", "An internal error occurred. " + ex.Message, null);
                        return false;
                    }
                }
                else
                {//return forum not found error
                    AddErrorXml("forumnotfound", "The forum you requested could not be found.", null);
                    return false;
                }
            }
            else
            {//check if an update is required
                try
                {
                    CheckUpdateForum(ref commentForum);
                }
                catch (DnaException ex)
                {
                    AddErrorXml("internal", "An internal error occurred. " + ex.Message, null);
                    return false;
                }
            }
            

            // Now generate the xml for the posts
            GenerateForumThreadPostsXML(commentForum);

            //CommentForumList Recent Comments 
            if (InputContext.DoesParamExist("dnacommentforumlistprefix", "Comment Forum List Prefix"))
                GetRelatedCommentForumList();

            //RecentComments.
            if (InputContext.DoesParamExist("dnarecentcommentsprefix", "Prefix for recent comments"))
                GetRecentRelatedCommentForumPosts();

            return true;
        }

        private void CheckUpdateForum(ref CommentForum commentForum)
        {
            bool doUpdate = false;
            //Update the comment forum title if the passed in value is changed
            if (_title != String.Empty && _title != commentForum.Title)
            {
                doUpdate = true;
                commentForum.Title = _title;
                XmlNodeList commentForumTitleNodes = RootElement.SelectNodes("COMMENTBOX/FORUMTHREADPOSTS/POST/COMMENTFORUMTITLE");
                foreach (XmlNode commentForumTitle in commentForumTitleNodes)
                {
                    commentForumTitle.InnerText = _title;
                }
            }

            //update the HostPageUrl if different to that already set
            if (!String.IsNullOrEmpty(_url) && _url != commentForum.ParentUri)
            {
                doUpdate = true;
                commentForum.ParentUri = _url;
            }
            if (doUpdate)
            {//update the forum in the api.
                comments.UpdateForum(commentForum, InputContext.CurrentSite);
            }
        }

        private void GetRelatedCommentForumList()
        {
            CommentForumListBuilder commentForumListBuilder = new CommentForumListBuilder(InputContext);
            commentForumListBuilder.GetCommentListsFromUidPrefix();
			//commentForumListBuilder.SkipUrlProcessing = true;
            AddInside(RootElement, commentForumListBuilder);
        }

        private void GetRecentRelatedCommentForumPosts()
        {
            RecentCommentForumPostsBuilder recentComments = new RecentCommentForumPostsBuilder(InputContext);
            recentComments.TryGetRecentCommentForumPosts();
            AddInside(RootElement, recentComments);
        }

        /// <summary>
        /// Function to try and add a comment with the 
        /// parameters passed in, assumes the comment box has already been created and exists
        /// </summary>
        /// <exception cref="DnaException">if there is an Invalid CommentBoxForum ID</exception>
        private void AddComment(CommentForum forum)
        {
            // Maintain errortype and errormessage
            // errortype is a simple name for the type of error.
            // errormessage gives a detailed error message
            bool noError = true;
            string errortype = string.Empty;
            string errormessage = string.Empty;
            bool ignoreModeration = InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser;

            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn || InputContext.ViewingUser.IsBanned)
            {
                //Need to produce relevant XML.
                //throw new DnaException("User has invalid permissions to add comment.");
                noError = false;
                errortype = "userpermissions";
                errormessage = @"User has insufficient privilidges to add comment.";
            }
            if ( !ignoreModeration && (InputContext.CurrentSite.IsEmergencyClosed || InputContext.CurrentSite.IsSiteScheduledClosed(DateTime.Now)) )
            {
                //throw new DnaException("AddComment failed - Site is closed.");
                noError = false;
                errortype = "siteclosed";
                errormessage = @"site is currently closed.";
            }
            if (noError)
            {
                //set up calling user
                if (String.IsNullOrEmpty(InputContext.CurrentSite.IdentityPolicy))
                {
                    comments.CallingUser = new CallingUser(SignInSystem.SSO, AppContext.ReaderCreator, InputContext.Diagnostics, AppContext.DnaCacheManager, AppContext.TheAppContext.TheSiteList);
                    comments.CallingUser.IsUserSignedIn(InputContext.GetCookie("SSO2-UID").Value, InputContext.CurrentSite.SSOService, InputContext.CurrentSite.SiteID,"");
                }
                else
                {
                    comments.CallingUser = new CallingUser(SignInSystem.Identity, AppContext.ReaderCreator, InputContext.Diagnostics, AppContext.DnaCacheManager, AppContext.TheAppContext.TheSiteList);
                    //comments.CallingUser.IsUserSignedIn(InputContext.GetCookie("IDENTITY").Value, InputContext.CurrentSite.IdentityPolicy, InputContext.CurrentSite.SiteID, "");
                    string secureCookie = String.Empty;
                    if (InputContext.GetCookie("IDENTITY-HTTPS") != null)
                    {
                        secureCookie = InputContext.GetCookie("IDENTITY-HTTPS").Value;
                    }
                    comments.CallingUser.IsUserSignedInSecure(InputContext.GetCookie("IDENTITY").Value, secureCookie, InputContext.CurrentSite.IdentityPolicy, InputContext.CurrentSite.SiteID);
                }
            }
                string comment = String.Empty;
                if (!InputContext.TryGetParamString("dnacomment", ref comment, "Text of the submitted comment.") || comment == String.Empty)
                {
					errortype = "invalidcomment";
					errormessage = @"No comment was supplied.";
					noError = false;
                }

                //create comment obbject - default to text
                CommentInfo newComment = new CommentInfo() { text = comment, PostStyle = PostStyle.Style.plaintext };
                // Insert the comment into the page as escaped text
                _commentBoxNode.RemoveAll();
                AddTextTag(_commentBoxNode, "ORIGINALPOSTTEXT", InputContext.UrlEscape(comment));

                // Check to see if we need to check for valid XML
                if (InputContext.GetParamIntOrZero("dnapoststyle", "Get the style of post we're trying to submit") != 0)
                {
                    newComment.PostStyle = (PostStyle.Style)InputContext.GetParamIntOrZero("dnapoststyle", "Get the style of post we're trying to submit");
                }

                // Check to see if we're doing guideml
                if (newComment.PostStyle == PostStyle.Style.richtext)
                {
                    // Check to make sure that the comment is made of valid XML
                    if (!HtmlUtils.ParseToValidGuideML(comment, ref errormessage))
                    {
                        noError = false;
                        errortype = "XmlParseError";
                        InputContext.Diagnostics.WriteWarningToLog("Comment box post failed xml parse.", errormessage);
                    }
                }
                if (noError)
                {
                    string matchingProfanity;
                    ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, comment, out matchingProfanity);
                    if (ProfanityFilter.FilterState.FailBlock == state)
                    {
                        noError = false;
                        errortype = "profanityblocked";
                        errormessage = matchingProfanity;
                    }
                }


				if (noError)
				{
                    try
                    {
                        newComment = comments.CreateComment(forum, newComment);
                    }
                    catch (DnaException ex)
                    {
                        errortype = "commentfailed";
                        errormessage = ex.Message;
                        noError = false;
                    }
				}

                // Finally, check to see if we're a redirect request
                if (1 == InputContext.GetParamIntOrZero("dnaur", "Use Redirect. 1 means do a redirect, 0 means don't redirect. Typically, an Ajax style request would pass dnaur=0 while a traditional HTTP POST request would pass dnaur=1 so that the framework redirects back to the host page"))
                {
                    // Now create the redirect string
                    StringBuilder redirecturl = new StringBuilder(forum.ParentUri);

                    // Add any moderation feedback
                    if (newComment.IsPreModerated)
                    {
                        if (forum.ParentUri.Contains("?"))
                        {
                            redirecturl.Append("&");
                        }
                        else
                        {
                            redirecturl.Append("?");
                        }

                        // Now add all the moderation info
                        redirecturl.Append("moduserid=" + Convert.ToString(forum.Id));
                        redirecturl.Append("&pid=" + Convert.ToString(newComment.ID));
                        redirecturl.Append("&upm=" + Convert.ToString(InputContext.ViewingUser.IsPreModerated));
                        redirecturl.Append("&asb=" + Convert.ToString(InputContext.ViewingUser.IsAutoSinBin));
                        redirecturl.Append("&pmp=" + Convert.ToString(true));//not used in the skins so just defaulting to true
                    }
#if DEBUG
                    // For debug testing, we need to be able to pass the purexml param into the redirect.
                    if (InputContext.CurrentDnaRequest.GetParamStringOrEmpty("skin", "") == "purexml")
                    {
                        if (forum.ParentUri.Contains("?"))
                        {
                            redirecturl.Append("&skin=purexml");
                        }
                        else
                        {
                            redirecturl.Append("?skin=purexml");
                        }
                    }
#endif
                    //TODO replace with a generic method
                    redirecturl.Append("#dnaacs");

                    // Add any errors to the redirect
                    if (noError == false)
                    {
                        // Create the error and insert it into the KeyValueData table ready for the
                        // next request to pick up
                        XmlNode error = CreateElementNode("ERROR");
                        AddAttribute(error, "TYPE", errortype);
                        AddTextTag(error, "ERRORMESSAGE", errormessage);
                        AddTextTag(error, "EXTRAINFO", comment);

                        int couk = forum.ParentUri.LastIndexOf("bbc.co.uk");
                        string cookiePath = forum.ParentUri.Substring(forum.ParentUri.IndexOf("/", couk));
                        AddResponseKeyValueDataCookie("DNACOMMENTERROR", error, cookiePath);
                    }

                    // Add the redirect to the page
                    XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                    AddAttribute(redirect, "URL", redirecturl.ToString());
                }
                else
                {
                    
                    //Indicate Post was premoderated.
                    if (newComment.IsPreModerated)
                    {
                        XmlNode premodxml = CreateElementNode("POSTPREMODERATED");
                        AddAttribute(premodxml, "UID", forum.Id);
                        AddAttribute(premodxml, "POST", Convert.ToString(newComment.ID));
                        AddAttribute(premodxml, "USERPREMODERATED", Convert.ToString(InputContext.ViewingUser.IsPreModerated).ToLower()); // must be lower case to validate against xs:boolean type in schema
                        AddAttribute(premodxml, "AUTOSINBIN", Convert.ToString(InputContext.ViewingUser.IsAutoSinBin).ToLower()); // must be lower case to validate against xs:boolean type in schema
                        //not used in the skins so just defaulting to true
                        AddAttribute(premodxml, "ISPREMODPOSTING", Convert.ToString(newComment.IsPreModPosting).ToLower()); // must be lower case to validate against xs:boolean type in schema
                        RootElement.SelectSingleNode("COMMENTBOX").AppendChild(premodxml);
                    }
                    //rerequest new forum
                    TryGetCommentForum(_uid, ref forum);

                    // Not a redirect request, put any errors into the page
                    if (noError == false)
                    {
                        AddErrorXml(errortype, errormessage, null);
                    }
                }
            }
        

        /// <summary>
        /// Generates/fills the full forum thread posts xml document
        /// </summary>
        /// <param name="commentForum">Comment Forum</param>
        private void GenerateForumThreadPostsXML(CommentForum commentForum)
        {
            // Put the forum closing date into the xml
            XmlNode commentBox = RootElement.SelectSingleNode("COMMENTBOX");
            if (commentBox == null)
            {
                // Create this node
                commentBox = AddElementTag(RootElement, "COMMENTBOX");
            }

            XmlNode endDate = AddElementTag(commentBox, "ENDDATE");
            endDate.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, commentForum.CloseDate));

            CreateForumThreadPosts(commentForum, commentBox);

            AddMoreAttribute(commentForum);

            // Modify the CanWrite flag depending on the user or if either the site or forum are closed
            UpdateCanWriteStatus(commentForum.isClosed);
        }

        /// <summary>
        /// Updates the comment forum title to the new one passed in
        /// </summary>
        /// <param name="forumID">The forumID</param>
        /// <param name="title"></param>
        private void UpdateCommentForumTitle(int forumID, string title)
        {
            string setForumTitle = "setforumtitle";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(setForumTitle))
            {
                dataReader.AddParameter("@forumid", forumID)
                    .AddParameter("@title", title);

                dataReader.Execute();
            }

        }

        /// <summary>
        /// Updates the forums can write flag depending on the site's or forum open status 
        /// </summary>
        /// <param name="forumClosed">A flag that states whether or not that the forum is closed</param>
        private void UpdateCanWriteStatus(bool forumClosed)
        {
            // Check to see if we're a editor or super user. Also check to make sure that the can write status is set
			// Actually, because we cache the output, we can't look at the current user for anything, so editors don't get special privileges
            if (/*InputContext.ViewingUser.IsEditor || */ RootElement.SelectSingleNode("COMMENTBOX/FORUMTHREADPOSTS").Attributes["CANWRITE"].Value == "0")
            {
                // Nothing to update, just return
                return;
            }

            // Now check to see if the site is closed or that the forum has closed
            if (InputContext.CurrentSite.IsEmergencyClosed || InputContext.CurrentSite.IsSiteScheduledClosed(DateTime.Now) || forumClosed)
            {
                // We need to update the flag!
                RootElement.SelectSingleNode("COMMENTBOX/FORUMTHREADPOSTS").Attributes["CANWRITE"].Value = "0";
            }
        }

        /// <summary>
        /// Adds the more attribute to the Top level element
        /// </summary>
        /// <param name="forum">the comment forum</param>
        /// <returns>success true/false</returns>
        private bool AddMoreAttribute(CommentForum forum)
        {
            bool success = false;

            XmlNode forumThreadsNode = RootElement.SelectSingleNode("FORUMTHREADPOSTS");

            if (forumThreadsNode != null)
            {
                // If we've picked a page not at the end
                if (forum.commentList.StartIndex + forum.commentList.ItemsPerPage < forum.commentList.TotalCount)
                {
                    // Get the element and add a MORE attribute
                    AddAttribute(forumThreadsNode, "MORE", "1");
                }
                success = true;
            }
            return success;
        }

        /// <summary>
        /// Creates the XML fragment for the CommentBoxForum Thread Posts
        /// </summary>
        /// <param name="forum">The CommentBoxForum</param>
        /// <param name="parent">Parent node of FORUMTHREADPOSTS element.</param>
        /// <returns>Actual number of posts returned</returns>
        private int CreateForumThreadPosts(CommentForum forum, XmlNode parent)
        {
            XmlNode forumPosts = CreateElementNode("FORUMTHREADPOSTS");
            AddAttribute(forumPosts, "GUESTBOOK", "1");
            AddAttribute(forumPosts, "FORUMID", forum.ForumID);

            //threading related so default to 0
            AddAttribute(forumPosts, "ALERTINSTANTLY", 0);

            AddAttribute(forumPosts, "FROM", forum.commentList.StartIndex);
            AddAttribute(forumPosts, "TO", forum.commentList.StartIndex + forum.commentList.comments.Count);
            AddAttribute(forumPosts, "SHOW", forum.commentList.comments.Count);

            AddAttribute(forumPosts, "FORUMPOSTCOUNT", forum.commentList.TotalCount);
            AddAttribute(forumPosts, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
            AddAttribute(forumPosts, "SITEID", InputContext.CurrentSite.SiteID);

            AddAttribute(forumPosts, "CANREAD", forum.CanRead?1:0);
            AddAttribute(forumPosts, "CANWRITE", forum.CanWrite ? 1 : 0);
            AddAttribute(forumPosts, "DEFAULTCANREAD", forum.CanRead ? 1 : 0);
            AddAttribute(forumPosts, "DEFAULTCANWRITE", forum.CanWrite ? 1 : 0);
			AddAttribute(forumPosts, "UID", forum.Id);

            string hostpageurl = forum.ParentUri;
            hostpageurl = StringUtils.EscapeAllXml(hostpageurl);

            AddAttribute(forumPosts, "HOSTPAGEURL", hostpageurl);

            byte moderationStatus = (byte)forum.ModerationServiceGroup;
            AddAttribute(forumPosts, "MODERATIONSTATUS", moderationStatus.ToString());

            //Worked out the number of posts from the returned to and from
            int returnedCount = forum.commentList.comments.Count;

            for (int i = 0; i < forum.commentList.comments.Count; i++)
            {
                ForumPost.AddCommentXml(forum, forum.commentList.comments[i], this, forumPosts, InputContext, forum.commentList.StartIndex+i);
            }

            parent.AppendChild(forumPosts);
            return returnedCount;
        }

        /// <summary>
        /// Checks for an incoming error in the url and puts it into the xml
        /// </summary>
		private void ProcessIncomingError()
		{
            // Check to see if we have a DNACOMMENTERROR cookie.
            DnaCookie dnaMessage = InputContext.GetCookie("DNACOMMENTERROR");
            if (dnaMessage != null && dnaMessage.Value.Length > 0)
            {
                // Get the data from the database for the given key value
                XmlDocument commentError = GetKeyValueData(dnaMessage.Value);
                ImportAndAppend(commentError.FirstChild, "");
            }
        }

        /// <summary>
        /// Adds moderation info Xml to the document if present
        /// </summary>
        private void ProcessModerationInfo()
        {
            // Check to see if we've been given premoderation params. If so, get the details from the URL
            if (InputContext.DoesParamExist("moduserid", _docModUserID) && InputContext.DoesParamExist("pid", _docPostID)
                && InputContext.DoesParamExist("upm", _docUserPreModerated) && InputContext.DoesParamExist("asb", _docAutoSinBin)
                && InputContext.DoesParamExist("pmp", _docPostPremod))
            {
                // Create and add the PostPremoderated XML Block
                XmlNode premodxml = CreateElementNode("POSTPREMODERATED");
				AddAttribute(premodxml, "UID", InputContext.GetParamStringOrEmpty("moduserid", _docModUserID));
                AddAttribute(premodxml, "POST", InputContext.GetParamStringOrEmpty("pid", _docPostID));
                AddAttribute(premodxml, "USERPREMODERATED", InputContext.GetParamStringOrEmpty("upm", _docUserPreModerated).ToLower()); // must be lower case to validate against xs:boolean type in schema
                AddAttribute(premodxml, "AUTOSINBIN", InputContext.GetParamStringOrEmpty("asb", _docAutoSinBin).ToLower()); // must be lower case to validate against xs:boolean type in schema
                AddAttribute(premodxml, "ISPREMODPOSTING", InputContext.GetParamStringOrEmpty("pmp", _docPostPremod).ToLower()); // must be lower case to validate against xs:boolean type in schema
                RootElement.SelectSingleNode("COMMENTBOX").AppendChild(premodxml);
            }
		}
    }
}
