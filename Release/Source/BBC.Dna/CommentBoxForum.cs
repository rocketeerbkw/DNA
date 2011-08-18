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
using BBC.DNA.Moderation.Utils;


namespace BBC.Dna.Component
{
    /// <summary>
    /// CommentBoxForum - A derived DnaComponent object
    /// </summary>
    public class CommentBoxForum : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the CommentBoxForum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public CommentBoxForum(IInputContext context)
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

       /// <summary>
        /// Gets the dnaguid parameter
        /// </summary>
        /// <returns></returns>
        private string GetUID()
        {
            string uid = string.Empty;
            if (!InputContext.TryGetParamString("dnauid", ref uid, _docUID))
            {
                //FUDGE A UID IF WE DONT HAVE ONE FOR NOW
                return Guid.NewGuid().ToString();
            }
            return uid;
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

            string uid = GetUID();
            if (InputContext.ViewingUser.UserLoggedIn)
            {
                AddComment(uid);
            }
			
            ProcessIncomingError();
            ProcessModerationInfo();
            
            TryGetCommentForum(uid);

            //TODO Add Filter permissions stuff 
        }

        /// <summary>
        /// Method called to try and get the comment forum. This function will create a new comment forum
        /// if one doesn't exist, given a unique identifier
        /// </summary>
        /// <param name="uid">The UID for the forum in question</param>
        private bool TryGetCommentForum(string uid)
        {
            bool createIfNotExist = true;
            int fromPostIndex = 0;
            int toPostIndex = 0;
            int show = InputContext.GetSiteOptionValueInt("CommentForum","DefaultShow");
            int moderationStatus = 0;

            bool dnaUidExists = InputContext.DoesParamExist("dnauid", _docUID);
            if (!dnaUidExists)
            {
                return AddErrorXml("invalidparameters", "No unique id provided", null);
            }
            
            //Create a new comment forum from the uid url title and siteid
            string url = String.Empty;

            bool urlExists = InputContext.DoesParamExist("dnahostpageurl", _docHostPageUrl);
            if (urlExists)
            {
                InputContext.TryGetParamString("dnahostpageurl", ref url, _docHostPageUrl);
                if (url != String.Empty)
                {
                    // If we are running on a development server, don't check the URL
                    if (!InputContext.IsRunningOnDevServer)
                    {
                        Match m = _dnaHostPageUrlRegEx.Match(url);
                        if (!m.Success)
                        {
                            return AddErrorXml("invalidparameters", "Not a http://*.bbc.co.uk host page url address", null);
                        }
                    }
                }
                else
                {
                    // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                    createIfNotExist = false;
                }
            }
            else
            {
                // If we don't have a host url, then we cannot create the forum if it does not exist as it is a manditory field
                createIfNotExist = false;
            }

            string title = String.Empty;
            bool titleExists = InputContext.DoesParamExist("dnainitialtitle", _docInitialTitle);
            if (titleExists)
            {
                InputContext.TryGetParamString("dnainitialtitle", ref title, _docInitialTitle);
                if (title != String.Empty)
                {
                    //TODO: Checking of title user entered value
                }
                else
                {
                    // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                    createIfNotExist = false;
                }
            }
            else
            {
                // If we don't have a title, then we cannot create the forum if it does not exist as it is a manditory field
                createIfNotExist = false;
            }
            show = InputContext.GetParamIntOrZero("dnashow", _docDnaShow);
            if (show > 500)
            {
                //cap the maximum number of records to show per page
                show = 500;
            }
            else if (show < 1)
            {
                //if an erroneous, minus value or missing show value then set to the default
                show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
            }

            fromPostIndex = InputContext.GetParamIntOrZero("dnafrom", _docDnaFrom);
            if (fromPostIndex < 0)
            {
                fromPostIndex = 0;
            }

            toPostIndex = InputContext.GetParamIntOrZero("dnato", _docDnaTo);
            if (toPostIndex <= 0)
            {//HACK: if posttoindex is not set then must default to 0 so that order of comments returned is reversed
                //this is ajax required.
                toPostIndex = 0;
            }

            

            bool moderationStatusExists = InputContext.DoesParamExist("dnainitialmodstatus", _docDnaInitialModStatus);
            if (moderationStatusExists)
            {
                string dnaModStatus = InputContext.GetParamStringOrEmpty("dnainitialmodstatus", _docDnaInitialModStatus);
				if (dnaModStatus == "reactive")
				{
					moderationStatus = 1;
				}
				else if (dnaModStatus == "postmod")
                {
					moderationStatus = 2;
				}
				else if (dnaModStatus == "premod")
                {
					moderationStatus = 3;
                }
				else
				{
					return AddErrorXml("invalidparameters", "Illegal Initial Moderation Status setting (" + dnaModStatus + ")", null);
				}
            }

            // Check to see if we've been given a date to close by
            int forumDuration = -1;
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
                        forumDuration = closeDate.Days;
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
                    forumDuration = Convert.ToInt32(durationValue);
                }
            }

            GetCommentForum(uid, url, title, InputContext.CurrentSite.SiteID, fromPostIndex, toPostIndex, show, moderationStatus, createIfNotExist, forumDuration);
          
            //CommentForumList Recent Comments 
            if ( InputContext.DoesParamExist("dnacommentforumlistprefix","Comment Forum List Prefix") )
                GetRelatedCommentForumList();

            //RecentComments.
            if ( InputContext.DoesParamExist("dnarecentcommentsprefix","Prefix for recent comments") )
                GetRecentRelatedCommentForumPosts();

            return true;
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
        /// Calls the DB to get the Comment CommentBoxForum if one does not exist then it creates a new one
        /// Gets the CommentBoxForum posts in the guestbook style with DB skip and show
        /// </summary>
        /// <param name="uid">The unique identifier for the Comment CommentBoxForum</param>
        /// <param name="url">The URL of the page so to go back to</param>
        /// <param name="title">Title of the Comment CommentBoxForum </param>
        /// <param name="siteID">Site which the comment forum belongs to</param>
        /// <param name="fromPostIndex">Start Post Index</param>
        /// <param name="toPostIndex">Finish Post Index</param>
        /// <param name="show">If no to and from parameters we need the number of comments to show</param>
        /// <param name="moderationStatus">Moderation status to set the forum to</param>
        /// <param name="createIfNotExist">This is a flag to state that if the forum does not exist, then create it.</param>
        /// <param name="forumDuration">Optional param that lets you specify the duration for the forum that will override the default site option.
        /// Set to -1 if you want to use the default siteoption OR set 0 if you want it to be open forever</param>
        private void GetCommentForum(string uid, string url, string title, int siteID, int fromPostIndex, int toPostIndex, int show, int moderationStatus, bool createIfNotExist, int forumDuration)
        {
            string getCommentForum = "getcommentforum";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForum))
            {
                dataReader.AddParameter("@uid", uid)
                    .AddParameter("@url", url)
                    .AddParameter("@title", title)
                    .AddParameter("@siteid", siteID)
                    .AddParameter("@frompostindex", fromPostIndex)
                    .AddParameter("@topostindex", toPostIndex)
                    .AddParameter("@show", show)
                    .AddParameter("@createifnotexists",createIfNotExist)
                    .AddParameter("@duration", forumDuration);

                if (moderationStatus > 0)
                {
                    dataReader.AddParameter("@moderationstatus", moderationStatus);
                }
                else
                {
                    dataReader.AddParameter("@moderationstatus", DBNull.Value);
                }

                dataReader.Execute();

                // Check to make sure that we've got some data to play with
                if (!dataReader.HasRows)
                {
                    AddErrorXml("forumnotfound", "The forum you requested could not be found.", null);
                    return;
                }

                // Now generate the xml for the posts
                GenerateForumThreadPostsXML(uid, fromPostIndex, toPostIndex, show, dataReader, title, url);
            }
        }

        /// <summary>
        /// Function to try and add a comment with the 
        /// parameters passed in, assumes the comment box has already been created and exists
        /// </summary>
        /// <exception cref="DnaException">if there is an Invalid CommentBoxForum ID</exception>
        private void AddComment(string uid)
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

            bool forceModeration = false;
            string action = String.Empty;
            if (InputContext.TryGetParamString("dnaaction", ref action, "Action to take on this request. 'add' is the only action currently recognised"))
            {
                if (action == "add")
                {
                    string comment = String.Empty;
                    if (!InputContext.TryGetParamString("dnacomment", ref comment, "Text of the submitted comment.") || comment == String.Empty)
                    {
						errortype = "invalidcomment";
						errormessage = @"No comment was supplied.";
						noError = false;
                    }

                    // Insert the comment into the page as escaped text
                    AddTextTag(_commentBoxNode, "ORIGINALPOSTTEXT", InputContext.UrlEscape(comment));

                    // Check to see if we need to check for valid XML
                    int postStyle = InputContext.GetParamIntOrZero("dnapoststyle","Get the style of post we're trying to submit");
                    if (postStyle == 0)
                    {
                        postStyle = 2;
                    }

                    comment = StringUtils.StripInvalidXmlChars(comment);

                    // Check to see if we're doing guideml
                    if (postStyle == 1)
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
                        List<Term> terms = null;
                        ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, comment, out matchingProfanity, out terms);
						if (ProfanityFilter.FilterState.FailBlock == state)
						{
							noError = false;
							errortype = "profanityblocked";
							errormessage = matchingProfanity;
						}
						else if (ProfanityFilter.FilterState.FailRefer == state)
						{
							forceModeration = true;
						}
					}

					int viewingUserId = InputContext.ViewingUser.UserID;
                    bool isNotable = InputContext.ViewingUser.IsNotable;
                    bool isPreModerated = false;
                    bool isPreModProcessed = false;
                    bool canRead = false;
                    bool canWrite = false;
                    int newPostId = 0;
                    string hostpageurl = string.Empty;
					Guid bbcuid = InputContext.BBCUid;
					string ipAddress = InputContext.IpAddress;
                    int contentSiteId = 0;

                    bool commentPostedOK = false;

					if (noError)
					{
                        commentPostedOK = CreateComment(uid, viewingUserId, comment, ref hostpageurl, forceModeration, ignoreModeration, isNotable, postStyle, ipAddress, bbcuid, out newPostId, out isPreModerated, out isPreModProcessed, out canRead, out canWrite, out contentSiteId);
                        if (!commentPostedOK)
						{
							noError = false;
							errortype = "commentfailed";
							errormessage = @"We were unable to process your comment at this time.";
						}
                        else if (newPostId == 0 && contentSiteId != InputContext.CurrentSite.SiteID)
                        {
                            //Content relates to a different site .
                            noError = false;
                            errortype = "commentfailed-invalidsite";
                            errormessage = @"The Comment Forum you are trying to post to belongs to a different site.";
 
                        }
                        else if (newPostId == 0 && canWrite == false)
                        {
                            noError = false;
                            errortype = "commentfailed-forumclosed";
                            errormessage = @"The Comment Forum you are trying to post to is closed.";
                        }
					}

                    // Finally, check to see if we're a redirect request
                    if (1 == InputContext.GetParamIntOrZero("dnaur", "Use Redirect. 1 means do a redirect, 0 means don't redirect. Typically, an Ajax style request would pass dnaur=0 while a traditional HTTP POST request would pass dnaur=1 so that the framework redirects back to the host page"))
                    {
                        // Get the host url if we don't already have it
                        if (hostpageurl == string.Empty)
                        {
                            int ForumID = 0;
                            if (!GetCommentForumDetails(uid, ref ForumID, ref hostpageurl))
                            {
                                throw new Exception("Failed to read comment details when returning error");
                            }
                        }

                        // Now create the redirect string
                        StringBuilder redirecturl = new StringBuilder(hostpageurl);

                        // Add any moderation feedback
                        if (isPreModerated)
                        {
                            if (hostpageurl.Contains("?"))
                            {
                                redirecturl.Append("&");
                            }
                            else
                            {
                                redirecturl.Append("?");
                            }

                            // Now add all the moderation info
                            redirecturl.Append("moduserid=" + Convert.ToString(uid));
                            redirecturl.Append("&pid=" + Convert.ToString(newPostId));
                            redirecturl.Append("&upm=" + Convert.ToString(InputContext.ViewingUser.IsPreModerated));
                            redirecturl.Append("&asb=" + Convert.ToString(InputContext.ViewingUser.IsAutoSinBin));
                            redirecturl.Append("&pmp=" + Convert.ToString(isPreModProcessed));
                        }
#if DEBUG
                        // For debug testing, we need to be able to pass the purexml param into the redirect.
                        if (InputContext.CurrentDnaRequest.GetParamStringOrEmpty("skin", "") == "purexml")
                        {
                            if (hostpageurl.Contains("?"))
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

                            int couk = hostpageurl.LastIndexOf("bbc.co.uk");
                            string cookiePath = hostpageurl.Substring(hostpageurl.IndexOf("/", couk));
                            AddResponseKeyValueDataCookie("DNACOMMENTERROR", error, cookiePath);
                        }

                        // Add the redirect to the page
                        XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                        AddAttribute(redirect, "URL", redirecturl.ToString());
                    }
                    else
                    {
                        //Indicate Post was premoderated.
                        if ( isPreModerated )
                        {
                            XmlNode premodxml = CreateElementNode("POSTPREMODERATED");
                            AddAttribute(premodxml, "UID", uid);
                            AddAttribute(premodxml, "POST", Convert.ToString(newPostId));
                            AddAttribute(premodxml, "USERPREMODERATED", Convert.ToString(InputContext.ViewingUser.IsPreModerated).ToLower()); // must be lower case to validate against xs:boolean type in schema
                            AddAttribute(premodxml, "AUTOSINBIN", Convert.ToString(InputContext.ViewingUser.IsAutoSinBin).ToLower()); // must be lower case to validate against xs:boolean type in schema
                            AddAttribute(premodxml, "ISPREMODPOSTING", Convert.ToString(isPreModProcessed).ToLower()); // must be lower case to validate against xs:boolean type in schema
                            RootElement.SelectSingleNode("COMMENTBOX").AppendChild(premodxml);
                        }

                        // Not a redirect request, put any errors into the page
                        if (noError == false)
                        {
                            AddErrorXml(errortype, errormessage, null);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Generates/fills the full forum thread posts xml document
        /// </summary>
        /// <param name="uid">The unique identifier for the Comment CommentBoxForum</param>
        /// <param name="fromPostIndex">Start Post Index</param>
        /// <param name="toPostIndex">Finish Post Index</param>
        /// <param name="show">If no to and from parameters we need the number of comments to show</param>
        /// <param name="dataReader">Dna Data Reader object</param>
        /// <param name="title">Passed in title of the comment</param>
        /// <param name="url">the passed in host page url</param>
        private void GenerateForumThreadPostsXML(string uid, int fromPostIndex, int toPostIndex, int show, IDnaDataReader dataReader, string title, string url)
        {
            int forumPostCount;
            int returnedPostCount;

            ExtractPostCount(dataReader, out forumPostCount);

            // Put the forum closing date into the xml
            XmlNode commentBox = RootElement.SelectSingleNode("COMMENTBOX");
            if (commentBox == null)
            {
                // Create this node
                commentBox = AddElementTag(RootElement, "COMMENTBOX");
            }

            // Add the closing date time to the xml, if we have one
            bool forumClosed = false;
            bool isForumCloseDateNull = dataReader.IsDBNull("ForumCloseDate");

			string existingtitle = dataReader.GetStringNullAsEmpty("commentforumtitle");
            string existingurl = dataReader.GetStringNullAsEmpty("URL");
            existingurl = StringUtils.EscapeAllXml(existingurl);
            url = StringUtils.EscapeAllXml(url);

			int forumID = dataReader.GetInt32NullAsZero("forumID");

            if (!isForumCloseDateNull)
            {
                DateTime closeDate = dataReader.GetDateTime("ForumCloseDate");
                //TODO: Write DnaComponent.AddDateElement method to encapsulate this
                XmlNode endDate = AddElementTag(commentBox, "ENDDATE");
                endDate.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, closeDate));
                forumClosed = closeDate < DateTime.Now;
            }

            returnedPostCount = CreateForumThreadPosts(uid, fromPostIndex, toPostIndex, dataReader, show, forumPostCount, commentBox);

            AddMoreAttribute(dataReader, forumPostCount, toPostIndex, returnedPostCount);

            // Modify the CanWrite flag depending on the user or if either the site or forum are closed
            UpdateCanWriteStatus(forumClosed);

            //Update the comment forum title if the passed in value is changed
            if (title != String.Empty && title != existingtitle)
            {
                UpdateCommentForumTitle(forumID, title);
                XmlNodeList commentForumTitleNodes = RootElement.SelectNodes("COMMENTBOX/FORUMTHREADPOSTS/POST/COMMENTFORUMTITLE");
                foreach (XmlNode commentForumTitle in commentForumTitleNodes)
                {
                    commentForumTitle.InnerText = title;
                }
            }

            if (url != string.Empty && url != existingurl)
            {
                UpdateCommentForumURL(forumID, url);
                XmlNode commentForumUrlNode = RootElement.SelectSingleNode("COMMENTBOX/FORUMTHREADPOSTS");
                if (commentForumUrlNode.Attributes["HOSTPAGEURL"] != null)
                {
                    commentForumUrlNode.Attributes["HOSTPAGEURL"].InnerText = url;
                }
            }

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
        /// Updates the comment forum host page url to the new one passed in
        /// </summary>
        /// <param name="forumID">The forumID</param>
        /// <param name="url">The new host page url</param>
        private void UpdateCommentForumURL(int forumID, string url)
        {
            string setForumTitle = "setforumhosturl";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(setForumTitle))
            {
                dataReader.AddParameter("@forumid", forumID)
                    .AddParameter("@url", url);

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
        /// Minor function to extract the parameter from the stored procedure for the forum post count
        /// </summary>
        /// <param name="dataReader">Dna Data Reader object</param>
        /// <param name="forumPostCount"></param>
        private void ExtractPostCount(IDnaDataReader dataReader, out int forumPostCount)
        {
            forumPostCount = 0;
            if (dataReader.Read())
            {
                forumPostCount = dataReader.GetInt32NullAsZero("forumPostCount");
            }
        }

        /// <summary>
        /// Adds the more attribute to the Top level element
        /// </summary>
        /// <param name="dataReader">the Stored Procedure object</param>
        /// <param name="forumPostCount">Total number of Posts</param>
        /// <param name="toPostIndex">Finish Post Index</param>
        /// <param name="returnedPostCount">Number of actual rows to returned</param>
        /// <returns>success true/false</returns>
        private bool AddMoreAttribute(IDnaDataReader dataReader, int forumPostCount, int toPostIndex, int returnedPostCount)
        {
            bool success = false;

            XmlNode forumThreadsNode = RootElement.SelectSingleNode("FORUMTHREADPOSTS");

            if (forumThreadsNode != null)
            {
                // If we've picked a page not at the end
                if (forumPostCount > 0 && toPostIndex < forumPostCount)
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
        /// <param name="uid">The unique identifier for the Comment CommentBoxForum</param>
        /// <param name="fromPostIndex">Start Post Index</param>
        /// <param name="toPostIndex">Finish Post Index</param>
        /// <param name="dataReader">Dna Data Reader object</param>
        /// <param name="show">Number of Posts requested</param>
        /// <param name="forumPostCount">Total number of Posts</param>
        /// <param name="parent">Parent node of FORUMTHREADPOSTS element.</param>
        /// <returns>Actual number of posts returned</returns>
        private int CreateForumThreadPosts(string uid, int fromPostIndex, int toPostIndex, IDnaDataReader dataReader, int show, int forumPostCount, XmlNode parent)
        {
            XmlNode forumPosts = CreateElementNode("FORUMTHREADPOSTS");
            AddAttribute(forumPosts, "GUESTBOOK", "1");
            AddAttribute(forumPosts, "FORUMID", dataReader.GetInt32NullAsZero("forumID").ToString());
            AddAttribute(forumPosts, "ALERTINSTANTLY", dataReader.GetInt32NullAsZero("alertInstantly").ToString());

            int returnedFrom = dataReader.GetInt32NullAsZero("from");
            if (returnedFrom < 0)
            {
                returnedFrom = 0;
            }
            int returnedTo = dataReader.GetInt32NullAsZero("to");

            AddAttribute(forumPosts, "FROM", returnedFrom.ToString());
            AddAttribute(forumPosts, "TO", returnedTo.ToString());
            AddAttribute(forumPosts, "SHOW", show.ToString());

            AddAttribute(forumPosts, "FORUMPOSTCOUNT", forumPostCount.ToString());
            AddAttribute(forumPosts, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
            AddAttribute(forumPosts, "SITEID", dataReader.GetInt32NullAsZero("siteID").ToString());

            AddAttribute(forumPosts, "CANREAD", dataReader.GetByteNullAsZero("ForumCanRead").ToString());
            AddAttribute(forumPosts, "CANWRITE", dataReader.GetByteNullAsZero("ForumCanWrite").ToString());
			AddAttribute(forumPosts, "DEFAULTCANREAD", dataReader.GetByteNullAsZero("ForumCanRead").ToString());
			AddAttribute(forumPosts, "DEFAULTCANWRITE", dataReader.GetByteNullAsZero("ForumCanWrite").ToString());
			AddAttribute(forumPosts, "UID", uid);

            string hostpageurl = dataReader.GetStringNullAsEmpty("URL");
            hostpageurl = StringUtils.EscapeAllXml(hostpageurl);

            AddAttribute(forumPosts, "HOSTPAGEURL", hostpageurl);

            byte moderationStatus = dataReader.GetByteNullAsZero("moderationStatus");
            AddAttribute(forumPosts, "MODERATIONSTATUS", moderationStatus.ToString());

            //Worked out the number of posts from the returned to and from
            int returnedCount = (returnedTo - returnedFrom) + 1;

            int actualPostCount = 0;
            if (forumPostCount > 0)
            {
                do
                {
                    ForumPost.AddPostXml(dataReader, this, forumPosts, InputContext);
                    actualPostCount++;
                    returnedCount--;
                } while (returnedCount > 0 && dataReader.Read());
            }

            parent.AppendChild(forumPosts);
            return actualPostCount;
        }

        /// <summary>
        /// Function to actually add a comment to a given forum.
        /// </summary>
        /// <param name="uid">Unique ID for comment box. Specified/Generated on creation of forum</param>
        /// <param name="userID">UserXMLObject ID of the user posting the comment.</param>
        /// <param name="comment">The actual comment.</param>
        /// <param name="hostPageUrl">url.</param>
        /// <param name="forceModeration">Triggered due to suspicious content profanities , urls etc.</param>
        /// <param name="ignoreModeration">Editors and superusers can avoid moderation.</param>
        /// <param name="newPostId">Editors and superusers can avoid moderation.</param>
        /// <param name="isPreModerated">Editors and superusers can avoid moderation.</param>
        /// <param name="isPreModProcessed">Indicates a premod processing is in effect </param>
        /// <param name="isNotable">Indicates that the author hs notable status</param>
        /// <param name="postStyle">The post style of the comment</param>
		/// <param name="ipAddress">IP address of incoming request</param>
		/// <param name="bbcuid">Guid extracted from BBC-UID cookie</param>
        /// <param name="canRead">Editors and superusers can avoid moderation.</param>
        /// <param name="canWrite">Editors and superusers can avoid moderation.</param>
        /// <param name="contentSiteId">Returns siteId of comment box forum.</param>
        /// <returns>success true/false</returns>
        public bool CreateComment(string uid, int userID, string comment,  ref string hostPageUrl, bool forceModeration, bool ignoreModeration, bool isNotable, int postStyle, string ipAddress, Guid bbcuid, out int newPostId, out bool isPreModerated,out bool isPreModProcessed, out bool canRead, out bool canWrite, out int contentSiteId)
        {
            Guid guid = DnaHasher.GenerateCommentHashValue(comment, uid, userID);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("createcomment"))
            {
                dataReader.AddParameter("@uniqueid", uid)
                .AddParameter("@userid", userID)
                .AddParameter("@siteid", InputContext.CurrentSite.SiteID)
                .AddParameter("@content", comment)
                .AddParameter("@hash", guid)
                .AddParameter("@forcemoderation", forceModeration)
                .AddParameter("@ignoremoderation", ignoreModeration)
                .AddParameter("@isnotable", isNotable)
                .AddParameter("@poststyle", postStyle)
				.AddParameter("@ipaddress",ipAddress)
				.AddParameter("@bbcuid",bbcuid)
               .Execute();
          
                if (dataReader.Read() && dataReader.HasRows)
                {
                    newPostId = dataReader.GetInt32("postid");
                    hostPageUrl = dataReader.GetStringNullAsEmpty("hostpageurl");
                    isPreModerated = dataReader.GetBoolean("ispremoderated");
                    isPreModProcessed = dataReader.GetBoolean("ispremodposting");
                    canRead = dataReader.GetBoolean("canRead");
                    canWrite = dataReader.GetBoolean("canWrite");
                    contentSiteId = dataReader.GetInt32("contentsiteid");
                    return true;
                }
            }
            newPostId = 0;
            isPreModerated = false;
            isPreModProcessed = false;
            canRead = false;
            canWrite = false;
            contentSiteId = 0;

            return false;
        }

		/// <summary>
		/// Gets the forumID and host URL for a given Unique ID
		/// </summary>
		/// <param name="uid">nique ID for the forum</param>
		/// <param name="forumID">ForumID from the database</param>
		/// <param name="url">Host URL of the page containing the comment forum</param>
		/// <returns>true if found, false if not</returns>
		public bool GetCommentForumDetails(string uid, ref int forumID, ref string url)
		{
			using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcommentdetails"))
			{
				reader.AddParameter("@uniqueid", uid);
				reader.Execute();

				if (reader.Read())
				{
					forumID = reader.GetInt32("ForumID");
					url = reader.GetString("Url");
					return true;
				}
			}
			return false;
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
