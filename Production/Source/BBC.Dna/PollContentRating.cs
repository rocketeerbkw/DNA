using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The content rating poll classs
    /// </summary>
    public class PollContentRating : Poll
    {
        private const string _docSRedirectTo = @"The number of articles to show.";

        /// <summary>
        /// The content rating poll class
        /// </summary>
        /// <param name="context">The app context so the poll can access database</param>
        /// <param name="viewingUser">The current viewing user</param>
        public PollContentRating(IAppContext context, IUser viewingUser)
            : base(context,viewingUser)
        {
            Type = PollType.POLLTYPE_CONTENTRATING;
        }

        /// <summary>
        /// Redirect URL
        /// </summary>
        protected string _redirectURL = String.Empty;

        /// <summary>
        /// Redirect URL property.
        /// </summary>
        /// <remarks>Instruct builder to redirect URL after returning from ProcessParamsFromBuilder.</remarks>
        public string RedirectURL
        {
            get { return _redirectURL; }
            set { _redirectURL = value; }
        }

        /// <summary>
        /// Adds users vote to database
        /// </summary>
        /// <param name="response">The response value to the vote</param>
        /// <returns>true if ok, false if not</returns>
        public override bool Vote(int response)
        {
            // Check to make sure we've got a redirect param specified
            if (RedirectURL.Length == 0)
            {
                // Add an error to the xml and logs
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "'s_redirectto' parameter not found!");
                AddErrorXml(ErrorCode.ERRORCODE_BADPARAMS.ToString(), "'s_redirectto' not set by skin", null);
                return true;
            }

            // MAke sure we've been given a valid poll
            if (PollID < 1)
            {
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "Vote - Invalid PollID");
                AddPollErrorCodeToURL(ErrorCode.ERRORCODE_BADPOLLID);
                return false;
            }

            // Check to see if we let anonymous voting
            int userID = 0;
            string BBCUID = String.Empty;
            if (!AllowAnonymousVoting)
            {
                // User must be logged in
                if (!_viewingUser.UserLoggedIn)
                {
                    _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "Vote - UserNot logged in");
                    AddPollErrorCodeToURL(ErrorCode.ERRORCODE_NEEDUSER);
                    return true;
                }

                // Check to make sure we know their user id
                userID = _viewingUser.UserID;
                if (userID < 1)
                {
                    _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "Vote - Failed to get users ID");
                    AddPollErrorCodeToURL(ErrorCode.ERRORCODE_UNSPECIFIED);
                    return false;
                }
            }
            else
            {
                // See if the user is logged in, if so check to make sure that they have a userid
                if (_viewingUser.UserLoggedIn)
                {
                    // Check to make sure we know their user id
                    userID = _viewingUser.UserID;
                    if (userID < 1)
                    {
                        _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "Vote - Failed to get users ID");
                        AddPollErrorCodeToURL(ErrorCode.ERRORCODE_UNSPECIFIED);
                        return false;
                    }
                }

                // Get the users BBCUID
                BBCUID = _viewingUser.BbcUid;
            }

            // Get the article author that the poll is associated to
            int articleID = 0;
            using (IDnaDataReader reader = _appContext.CreateDnaDataReader("pollgetitemids"))
            {
                // Add the params and execute
                reader.AddParameter("pollid", PollID)
                    .AddParameter("itemtype", Enum.Format(typeof(ItemType),ItemType.ITEMTYPE_ARTICLE, "d"))
                    .Execute();

                // check to see if we got anything back
                if (reader.HasRows && reader.Read())
                {
                    // get the ID of the article
                    articleID = reader.GetInt32("itemid");

                    // Now make sure we've only got the one result
                    if (reader.Read())
                    {
                        // put a report in the logs for now
                        _appContext.Diagnostics.WriteWarningToLog("PollCotentRating","Vote - ContentRating poll is linked to more than one article. Using first one.");
                    }
                }
            }

            // If we got an article, check to make sure the person voting is not the editor
            if (articleID > 0)
            {
                // Get the author from the article
                using (IDnaDataReader reader = _appContext.CreateDnaDataReader("pollgetarticleauthorid"))
                {
                    // Add the param and execute
                    reader.AddParameter("h2g2id",articleID)
                        .Execute();

                    // Get the result
                    if (reader.HasRows && reader.Read())
                    {
                        int authorID = reader.GetInt32("userid");
                        if (authorID == userID)
                        {
                            _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "Vote - Page author cannot vote on his article");
                            AddPollErrorCodeToURL(ErrorCode.ERRORCODE_AUTHORCANNOTVOTE);
                            return true;
                        }
                    }
                }
            }

            // Check to make sure the response is in range
            bool isInRange = (ResponseMin >= 0 && response >= ResponseMin);
            isInRange &= (ResponseMax >= 0 && response <= ResponseMax);
            if (!isInRange)
            {
                AddPollErrorCodeToURL(ErrorCode.ERRORCODE_BADPARAMS);
                return true;
            }

            // Now add the vote depending on anonymous voting
            if (!AllowAnonymousVoting)
            {
                using (IDnaDataReader reader = _appContext.CreateDnaDataReader("pollcontentratingvote"))
                {
                    // Add the vote
                    reader.AddParameter("pollid", PollID)
                        .AddParameter("userid", userID)
                        .AddParameter("response", response)
                        .Execute();
                }
            }
            else
            {
                using (IDnaDataReader reader = _appContext.CreateDnaDataReader("pollanonymouscontentratingvote"))
                {
                    // Add the vote
                    reader.AddParameter("pollid", PollID)
                        .AddParameter("userid", userID)
                        .AddParameter("response", response)
                        .AddParameter("bbcuid", BBCUID)
                        .Execute();
                }
            }

            // Set the redirect value and return
            return true;
        }


        /// <summary>
        /// Helper function to add poll's error code parameter to a URL
        /// </summary>
        /// <param name="code">Error Code</param>
        /// <remarks>This will also add the error code to XML</remarks>
        private void AddPollErrorCodeToURL(ErrorCode code)
        {
            // Check to see if we're putting the param on the end or first?
            if (!_redirectURL.Contains("?"))
            {
                _redirectURL += "?";
            }
            else
            {
                _redirectURL += "&";
            }

            // Add the param to the url
            _redirectURL += "PollErrorCode=" + Enum.Format(typeof(ErrorCode), code, "d");

            // Add the error to the XML
            AddErrorXml(Enum.Format(typeof(ErrorCode), code, "d"), "", null);
        }

        /// <summary>
        /// Tries to parse the request url to see what command has been sent through
        /// </summary>
        /// <param name="request">The request object</param>
        /// <returns>True if command found, false if not OR something went wrong</returns>
        public override bool ParseRequestURLForCommand(IRequest request)
        {
            // Get the redirect from the url
            _redirectURL = request.GetParamStringOrEmpty("s_redirectto", "Check the redirect for the poll exists");
            if (RedirectURL.Length == 0)
            {
                // Add an error to the xml and logs
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "'s_redirectto' parameter not found!");
                return AddErrorXml(ErrorCode.ERRORCODE_BADPARAMS.ToString(), "'s_redirectto' not set by skin", null);
            }

            // Now let the base class do it's stuff
            return base.ParseRequestURLForCommand(request);
        }

        /// <summary>
        /// Called when DispatchCommand does not recognise sAction. Adds Error XML into page. 
        /// </summary>
        /// <param name="cmd">The unhandled command</param>
        protected override bool UnhandledCommand(string cmd)
        {
            // Check to see if we we're given a redirect
            if (RedirectURL.Length > 0)
            {
                AddPollErrorCodeToURL(ErrorCode.ERRORCODE_UNKNOWNCMD);
            }
            return false;
        }

        /// <summary>
        /// Remove a vote, not supported for this type of poll
        /// </summary>
        /// <returns>true always</returns>
        public override bool RemoveVote()
        {
            // Check to make sure we've got a redirect param specified
            if (RedirectURL.Length == 0)
            {
                // Add an error to the xml and logs
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "'s_redirectto' parameter not found!");
                AddErrorXml(ErrorCode.ERRORCODE_BADPARAMS.ToString(), "'s_redirectto' not set by skin", null);
            }

            _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "RemoveVote - function not supported for content rating polls");
            AddPollErrorCodeToURL(ErrorCode.ERRORCODE_BADPARAMS);
            return true;
        }

        /// <summary>
        /// Hides / Unhides poll
        /// </summary>
        /// <param name="hide">Hide boolean: True = hide, False = unhide</param>
        /// <param name="itemID">ID of item this poll is attached to</param>
        /// <param name="itemType">Type of item this poll is attached to</param>
        /// <returns>true if the poll was hidden / unhidden, false if not</returns>
        protected override bool HidePoll(bool hide, int itemID, ItemType itemType)
        {
            // Check to make sure we've got a redirect param specified
            if (RedirectURL.Length == 0)
            {
                // Add an error to the xml and logs
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "'s_redirectto' parameter not found!");
                AddErrorXml(ErrorCode.ERRORCODE_BADPARAMS.ToString(), "'s_redirectto' not set by skin", null);
                return true;
            }

            // Make sure the user is logged in and an editor
            if (!_viewingUser.UserLoggedIn || !_viewingUser.IsEditor)
            {
                _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "HodePoll - Must be editor");
                AddPollErrorCodeToURL(ErrorCode.ERRORCODE_ACCESSDENIED);
                return true;
            }

            // Now hide the poll
            if (!base.HidePoll(hide, itemID, itemType))
            {
                AddPollErrorCodeToURL(ErrorCode.ERRORCODE_UNSPECIFIED);
                return false;
            }

            // Set the redirect and return true
            return true;
        }

        /// <summary>
        /// Links the poll to a given type of content
        /// </summary>
        /// <param name="itemID">The id of the item you want to link to</param>
        /// <param name="itemType">the type of item you want to link to</param>
        /// <returns>true if ok, false if not</returns>
        protected override bool LinkPoll(int itemID, ItemType itemType)
        {
            using (IDnaDataReader dataReader = _appContext.CreateDnaDataReader("pollgetitemids"))
            {
                // Add the params and execute
                dataReader.AddParameter("pollid", PollID)
                    .AddParameter("itemtype", itemType)
                    .Execute();

                // Now check to make sure that we havn't got any results
                if (dataReader.HasRows)
                {
                    _appContext.Diagnostics.WriteWarningToLog("PollContentRating", "LinkPoll - A link for this poll already exists");
                    return false;
                }
            }

            // Now add the link
            return base.LinkPoll(itemID, itemType);
        }

        /// <summary>
        /// Updates the current statistics for the current poll
        /// </summary>
        /// <param name="voteCount">the vote count</param>
        /// <param name="averageRating">the average rating</param>
        public void SetContentRatingStatistics(int voteCount, double averageRating)
        {
            // Set the poll stats for the given values
            SetPollStatistic("votecount", voteCount.ToString());
            SetPollStatistic("averagerating", averageRating.ToString());
        }
    }
}
