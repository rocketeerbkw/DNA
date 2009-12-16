using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data.SqlClient;
using System.Data.Common;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Base class to perform core poll functions. Derive from this class to create new poll type and customize behaviour of poll. 
    /// </summary>
    public abstract class Poll : DnaComponent
    {
        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="context">The app context the poll was created in</param>
        /// <param name="viewingUser">The current viewing user</param>
        public Poll(IAppContext context, IUser viewingUser)
        {
            _results = new PollResults();
            _appContext = context;
            _viewingUser = viewingUser;
        }

        /// <summary>
        /// The app context that the poll was created in. Used to create data readers
        /// </summary>
        protected IAppContext _appContext;

        /// <summary>
        /// The viewing user for the request
        /// </summary>
        protected IUser _viewingUser;

        /// <summary>
        /// Poll Types
        /// </summary>
        public enum PollType
        {
            /// <summary>
            /// Unkown
            /// </summary>
            POLLTYPE_UNKNOWN = 0,

            /// <summary>
            /// Club
            /// </summary>
            POLLTYPE_CLUB = 1,

            /// <summary>
            /// notice
            /// </summary>
            POLLTYPE_NOTICE = 2,

            /// <summary>
            /// Content rating
            /// </summary>
            POLLTYPE_CONTENTRATING = 3
        }

        /// <summary>
        /// User status types
        /// </summary>
        public enum UserStatus
        {
            /// <summary>
            /// Unknown state
            /// </summary>
            USERSTATUS_UNKNOWN = 0,

            /// <summary>
            /// User was logged in when he voted
            /// </summary>
            USERSTATUS_LOGGEDIN = 1,

            /// <summary>
            /// User wishes his vote to remain hidden
            /// </summary>
            USERSTATUS_HIDDEN = 2,
        }

        /// <summary>
        /// Item Types
        /// </summary>
        public enum ItemType
        {
            /// <summary>
            /// Beware of the unknown
            /// </summary>
            ITEMTYPE_UNKNOWN = 0,

            /// <summary>
            /// Article
            /// </summary>
            ITEMTYPE_ARTICLE = 1,

            /// <summary>
            /// Club
            /// </summary>
            ITEMTYPE_CLUB = 2,

            /// <summary>
            /// Notice (a thread of a noticeboard)
            /// </summary>
            ITEMTYPE_NOTICE = 3
        }

        /// <summary>
        /// Error Codes
        /// </summary>
        public enum ErrorCode
        {
            /// <summary>
            /// No Error
            /// </summary>
            ERRORCODE_NOERROR = -1,

            /// <summary>
            /// Unknown/Unspecified error
            /// </summary>
            ERRORCODE_UNSPECIFIED = 0,

            /// <summary>
            /// Unknown cmd param
            /// </summary>
            ERRORCODE_UNKNOWNCMD = 1,

            /// <summary>
            /// Invalid parameters (e.g. missing cmd/s_redirectto param)
            /// </summary>
            ERRORCODE_BADPARAMS = 2,

            /// <summary>
            /// Invalid poll id
            /// </summary>
            ERRORCODE_BADPOLLID = 3,

            /// <summary>
            /// User required for operation (User not logged in)
            /// </summary>
            ERRORCODE_NEEDUSER = 4,

            /// <summary>
            /// Access denied/operation not allowed
            /// </summary>
            ERRORCODE_ACCESSDENIED = 5,

            /// <summary>
            /// Page author cannot vote
            /// </summary>
            ERRORCODE_AUTHORCANNOTVOTE = 6,
        }

        /// <summary>
        /// The command that was parsed from the request URL
        /// </summary>
        public enum PollCommand
        {
            /// <summary>
            /// Failed to find a command
            /// </summary>
            UNKNOWN,
            /// <summary>
            /// Add a vote
            /// </summary>
            ADDVOTE,
            /// <summary>
            /// Hide a poll
            /// </summary>
            HIDE,
            /// <summary>
            /// Unhide a poll
            /// </summary>
            UNHIDE,
            /// <summary>
            /// Remove a poll
            /// </summary>
            REMOVE,
            /// <summary>
            /// Add a link
            /// </summary>
            ADDLINK
        }

        /// <summary>
        /// Do we allow anonymous voting
        /// </summary>
        private bool _allowAnonymousVoting = false;

        /// <summary>
        /// Allow anonymous voting property
        /// </summary>
        public bool AllowAnonymousVoting
        {
            get { return _allowAnonymousVoting; }
            set { _allowAnonymousVoting = value; }
        }

        /// <summary>
        /// Poll Id
        /// </summary>
        private int _pollID = -1;

        /// <summary>
        /// PollID property
        /// </summary>
        /// <remarks>Can return -1 if poll is not yet created</remarks>
        public int PollID
        {
            get { return _pollID; }
            set { _pollID = value; }
        }

        /// <summary>
        /// Max response
        /// </summary>
        private int _responseMax = -1;

        /// <summary>
        /// ResponseMax property:- maximum value of a response in poll.
        /// </summary>
        protected int ResponseMax
        {
            get { return _responseMax; }
            set { _responseMax = value; }
        }

        /// <summary>
        /// Min response
        /// </summary>
	    private int _responseMin = -1;

        /// <summary>
        /// ResponseMin property:- the minimum value of a response in poll.
        /// </summary>
        protected int ResponseMin
        {
            get { return _responseMin; }
            set { _responseMin = value; }
        }

        /// <summary>
        /// Results of poll voting
        /// </summary>
		private PollResults _results;

        /// <summary>
        /// PollResults property
        /// </summary>
        protected PollResults Results
        {
            get { return _results; }
        }

        /// <summary>
        /// Poll stats 
        /// </summary>
        private Dictionary<string, string> _stats = new Dictionary<string,string>();

        /// <summary>
        /// Current user vote
        /// </summary>
		private int	_currentUserVote;

        /// <summary>
        /// CurrentUserVote property
        /// </summary>
        protected int CurrentUserVote
        {
            get { return _currentUserVote; }
            set { _currentUserVote = value ; }
        }

        /// <summary>
        /// Hidden flag
        /// </summary>
		private bool _hidden;

        /// <summary>
        /// Hidden property
        /// </summary>
        public bool Hidden
        {
            get { return _hidden; } 
            set { _hidden = value; }
        }

        /// <summary>
        /// Type of poll
        /// </summary>
        private PollType _type; 

        /// <summary>
        /// Poll type property
        /// </summary>
        protected PollType Type
        {
            get { return _type; }
            set { _type = value; }
        }

        /// <summary>
        /// Last error code field
        /// </summary>
        private Poll.ErrorCode _lastErrorCode = ErrorCode.ERRORCODE_NOERROR;

        /// <summary>
        /// Last Error Code Property
        /// </summary>
        public Poll.ErrorCode LastErrorCode
        {
            get { return _lastErrorCode; }
        }

        // strings for logging
        private const string _docSPollErrorCode = @"Poll error code.";
        private const string _docSPollHideParam = @"Hide/Unhide bool param";
        private const string _docSCmdParam = @"Poll's cmd param";

        /// <summary>
        /// Returns name of xml root element
        /// </summary>
        /// <returns>Root element's name</returns>
        protected virtual string GetRootElementName()
        {
            return "VOTING-PAGE";
        }

        /// <summary>
        /// Set Response Range
        /// </summary>
        /// <param name="responseMin">Min response</param>
        /// <param name="responseMax">Max response</param>
        public void SetResponseMinMax(int responseMin, int responseMax)
        {
            ResponseMin = responseMin;
            ResponseMax = responseMax;
        }

        /// <summary>
        /// Creates a poll
        /// </summary>
        /// <returns>True if successfull, false if not</returns>
        public bool CreatePoll()
        {
            // Check to see if this poll object has been initialised from a poll before we try to create it
            if (PollID != -1)
            {
                // Already initialised from pollID
                _appContext.Diagnostics.WriteWarningToLog("Poll", "CreatePoll - Already initilised from poll ID!");
                return false;
            }

            // Now create the poll from the given data
            using (IDnaDataReader reader = _appContext.CreateDnaDataReader("CreateNewVote"))
            {
                reader.AddParameter("itype", Enum.Format(typeof(PollType), Type, "d"));
                reader.AddParameter("dclosedate",DBNull.Value);
                reader.AddParameter("iyesno", 0);
                reader.AddParameter("iownerid", 0);
                
                if (ResponseMin != -1)
                    reader.AddParameter("iresponsemin", ResponseMin);
                if (ResponseMax != -1)
                    reader.AddParameter("iresponsemax", ResponseMax);

                reader.AddParameter("allowanonymousrating", AllowAnonymousVoting ? 1 : 0);
                reader.Execute();

                // Now get the new poll id form the result
                if (!reader.HasRows || !reader.Read())
                {
                    _appContext.Diagnostics.WriteWarningToLog("Poll", "CreatePoll - Failed to create new poll!!!");
                    return false;
                }

                // Get the pollID
                _pollID = reader.GetInt32("VoteID");
            }

            // Everything went ok, so return.
            return true;
        }

        /// <summary>
        /// Register a Vote  
        /// </summary>
        /// <param name="response">The response value to the vote</param>
        /// <returns>True if successful else false</returns>
        /// <remarks>Must be implemented</remarks>
        public abstract bool Vote(int response);

        /// <summary>
        /// Remove a vote
        /// </summary>
        /// <returns>True if successful else false</returns>
        public abstract bool RemoveVote();

        /// <summary>
        /// Link a poll with an item (e.g. article, club etc...)
        /// </summary>
        /// <param name="itemID">Id of item</param>
        /// <param name="itemType">Type of item</param>
        /// <returns>Success</returns>
        public bool LinkPollWithItem(int itemID, Poll.ItemType itemType)
        {
            // Poll must be created
            if (PollID == -1)
            {
                return false;
            }

            if (!LinkPoll(itemID, itemType))
            {
                return AddErrorXml("Link Poll", "Can not link poll with item.", null);

            }
            return true;
        }

        /// <summary>
        /// Create link entity in database
        /// </summary>
        /// <param name="itemID">ID of item poll is to be linked to</param>
        /// <param name="itemType">Item type</param>
        /// <returns>Success</returns>
        protected virtual bool LinkPoll(int itemID, ItemType itemType)
        {
            using (IDnaDataReader dataReader = _appContext.CreateDnaDataReader("LinkPollWithItem"))
            {
                dataReader.AddParameter("@pollid", PollID);
                dataReader.AddParameter("@itemid", itemID);
                dataReader.AddParameter("@itemtype", itemType);
                dataReader.Execute();

                // TODO - no results sets - return OUTPUT in SP or process @@ERROR??
                //return AddErrorXml("Hide poll", "Can not hide/unhide poll.", null);

                return true;
            }
        }

        /// <summary>
        /// Hides / Unhides poll
        /// </summary>
        /// <param name="hide">Hide boolean: True = hide, False = unhide</param>
        /// <returns>Success</returns>
        /// <remarks>The poll will be hidden for all items that it is attached to</remarks>
        public virtual bool HidePoll(bool hide)
        {
            return HidePoll(hide, 0, ItemType.ITEMTYPE_UNKNOWN);
        }

        /// <summary>
        /// Hides / Unhides poll
        /// </summary>
        /// <param name="hide">Hide boolean: True = hide, False = unhide</param>
        /// <param name="itemID">ID of item this poll is attached to</param>
        /// <param name="itemType">Type of item this poll is attached to</param>
        /// <returns>Success</returns>
        /// <remarks>If both itemID and itemType are 0 the poll will be hidden for all items that it is attached to</remarks>
        protected virtual bool HidePoll(bool hide, int itemID, ItemType itemType)
        {
            using (IDnaDataReader dataReader = _appContext.CreateDnaDataReader("HidePoll"))
            {
                dataReader.AddParameter("@hide", hide);
                dataReader.AddParameter("@pollid", PollID);
                dataReader.AddParameter("@itemid", itemID);
                dataReader.AddParameter("@itemtype", itemType);
                dataReader.Execute();

                // TODO - no results sets - return OUTPUT in SP or process @@ERROR??
                //return AddErrorXml( "Hide poll", "Can not hide/unhide poll.", null); 

                return true;
            }
        }

        /// <summary>
        /// Make XML for poll
        /// </summary>
        /// <param name="includePollResults">Include results of poll flag</param>
	    public XmlNode MakePollXML(bool includePollResults)
        {
            if (includePollResults)
	        {
                // TODO - implement

                if (!LoadPollResults())
                {
                    AddErrorXml("Poll MakePollXML", "Failed to load poll results", null); 
                    return null;
                }
	        }

	        // Finally, make poll xml
            return MakePoll(); 
        }

        /// <summary>
        /// Adds, changes or removes statistics.
        /// </summary>
        /// <param name="name">statistic name</param>
        /// <param name="value">statistic value (set to null to remove statistic)</param>
        /// <remarks>Poll statistics are put in the &lt;STATISTICS&gt; tag inside the poll xml</remarks>
        public void SetPollStatistic(string name, string value)
        {
            if (name == null || name.Length == 0)
            {
                // No name, no game
                _appContext.Diagnostics.WriteWarningToLog("Poll", "SetPollStatistic has null name param.");
                AddErrorXml(Enum.Format(typeof(ErrorCode), ErrorCode.ERRORCODE_BADPARAMS, "d"), "SetPollStatistic has null name param.", null);
                return;
            }

            // Set, Clear or Add to statistics map
            if (value == null || value.Length == 0)
            {
                // Clear if value is null
                _stats.Remove(name);
            }
            else
            {
                // set or add
                _stats[name] = value;
            }
        }

        /// <summary>
        /// Load results of a single poll 
        /// </summary>
        /// <returns></returns>
        protected virtual bool LoadPollResults()
        {
            // Get the results for the current poll
            using (IDnaDataReader dataReader = _appContext.CreateDnaDataReader("GetPollResults"))
            {
                dataReader.AddParameter("@pollid", PollID)
                .Execute();

                while (dataReader.Read())
                {
                    UserStatus userStatus = (UserStatus) dataReader.GetInt32("Visible");
                    int response = dataReader.GetInt32("Response");
                    string count = dataReader.GetString("count");
                    this.Results.Add(userStatus, response, "count", count);
                }
            }

            // Get User Vote. Doing this inside the GetPollResults stored procedure would be more
	        // efficient.
	        if(!LoadCurrentUserVote())
	        {
                _appContext.Diagnostics.WriteWarningToLog("Poll", "LoadPollResults - Failed to load user votes!");
	        }
            return true;
        }
        
        /// <summary>
        /// Gets user's vote
        /// </summary>
        /// <returns>True if user has voted, false if not</returns>
        protected virtual bool LoadCurrentUserVote()
        {
            // TODO - rename to GetCurrentUserVote?
            // TODO - C++ Poll.LoadCurrentUserVote assumes there is only 1 user vote. This is not the case (see GetUserVotes.sql). Correct this assumption.
            if (!_viewingUser.UserLoggedIn || _viewingUser.UserID == 0 )
            {
                // User not logged in
                _currentUserVote = -1;
		        return false;
            }

            // Get the users vote for this poll
            using (IDnaDataReader dataReader = _appContext.CreateDnaDataReader("GetUserVotes"))
            {
                dataReader.AddParameter("@pollid", PollID)
                    .AddParameter("@userid", _viewingUser.UserID); 
                dataReader.Execute();

                // Check to make sure that we've got some data to play with
                if (!dataReader.HasRows)
                {
                    _currentUserVote = -1;
                    return false;
                }

                if (dataReader.Read())
                {
                    _currentUserVote = dataReader.GetInt32("Response");
                }
                return true; 
            }            
        }

        /// <summary>
        /// Make XML for single poll
        /// </summary>
        /// <returns>Success</returns>
        protected virtual XmlNode MakePoll()
        { 
            // Poll attributes
            XmlElement pollXml = AddElementTag(RootElement, "POLL");
            AddAttribute(pollXml, "POLLID", PollID); 
            AddAttribute(pollXml, "POLLTYPE", Convert.ToInt32(Type));
            if (ResponseMin > 0)
            {
                AddAttribute(pollXml, "MINRESPONSE", ResponseMin); 
            }
            if (ResponseMax > 0)
            {
                AddAttribute(pollXml, "MINRESPONSE", ResponseMax); 
            }
            AddAttribute(pollXml, "HIDDEN", Convert.ToInt32(Hidden)); 

            // Poll results
            XmlElement pollResults = Results.GetXml(); 
            if (!pollResults.IsEmpty)
	        {
                AddElement(pollXml, "OPTION-LIST", pollResults); // TODO - get rid of duplicate OPTION-LIST element.
	        }

            // Current users voting record
            if (LoadCurrentUserVote())
	        {
                XmlElement userVoteXml = AddElementTag(pollXml, "USER-VOTE");
                AddAttribute(userVoteXml, "CHOICE", CurrentUserVote); 
	        }
        	
	        // Add statistics if we have any

            if (_stats.Count > 0)
            {
                // Open STATISTICS tag
                XmlElement statisticsXml = AddElementTag(pollXml, "STATISTICS");

                foreach (string key in _stats.Keys)
                {
                    string value;
                    _stats.TryGetValue(key, out value);
                    AddAttribute(statisticsXml, key, value);
                }
            }

            //// Put error element if an error was passed on url
            //if (_lastErrorCode != ErrorCode.ERRORCODE_NOERROR)
            //{
            //    string errorMsg = GetErrorDescription(_lastErrorCode); 
            //    AddErrorXml("Poll", errorMsg, pollXml); 
            //}

	        return pollXml;
        }

        ///// <summary>
        ///// Gets description of error
        ///// </summary>
        ///// <param name="error">ErrorCode</param>
        ///// <returns>Error description</returns>
        //private string GetErrorDescription(ErrorCode error)
        //{
        //    string errorDescription; 
        //    switch (error)
        //    {
        //        case ErrorCode.ERRORCODE_UNSPECIFIED: errorDescription = "Unknown/Unspecified error"; break;
        //        case ErrorCode.ERRORCODE_UNKNOWNCMD: errorDescription ="Unknown cmd param"; break;
        //        case ErrorCode.ERRORCODE_BADPARAMS: errorDescription = "Invalid parameters (e.g. missing cmd/s_redirectto param)"; break;
        //        case ErrorCode.ERRORCODE_BADPOLLID: errorDescription = "Invalid poll id"; break;
        //        case ErrorCode.ERRORCODE_NEEDUSER: errorDescription = "User required for operation (User not logged in)"; break;
        //        case ErrorCode.ERRORCODE_ACCESSDENIED: errorDescription = "Access denied/operation not allowed"; break;
        //        case ErrorCode.ERRORCODE_AUTHORCANNOTVOTE: errorDescription = "Page author cannot vote"; break;
        //        default: errorDescription = "Unknown/Unspecified error"; break;
        //    }

        //    return errorDescription;
        //}

        /// <summary>
        /// Tries to parse the request url to see what command has been sent through
        /// </summary>
        /// <param name="request">The request object</param>
        /// <returns>True if command found, false if not OR something went wrong</returns>
        public virtual bool ParseRequestURLForCommand(IRequest request)
        {
            // Get the command from the request
            string command = request.GetParamStringOrEmpty("cmd", "Get the command for the poll");
            if (command.Length > 0)
            {
                // See if we're adding a vote
                if (command == "vote")
                {
                    // Now get the response to the poll vote
                    int response = request.TryGetParamIntOrKnownValueOnError("response", ResponseMin - 1, "Try to get the response for the poll vote");
                    return Vote(response);
                }
                else if (command == "removevote")
                {
                    // We're wanting to remove a vote
                    return RemoveVote();
                }
                else if (command == "config")
                {
                    // Config command is meant to configure poll. For now
                    // we only have hide/unhide config feature. In the 
                    // future we may have more. When this happens it would
                    // be wise to refactor code below making it more extendible.
                    // E.g, throw it in a virtual Config() function.

                    // See if we want to hide/unhide
                    if (request.DoesParamExist("hide", _docSPollHideParam))
                    {
                        // Now see if we're trying to hide or unhide
                        bool hide;
                        if (request.GetParamIntOrZero("hide", _docSPollHideParam) > 0)
                        {
                            hide = true;
                        }
                        else
                        {
                            hide = false;
                        }

                        // Return the result form the hide
                        return HidePoll(hide);
                    }
                }
                else if (command == "hidepoll")
                {
                    // We're trying to hide a poll
                    return HidePoll(true);
                }
                else if (command == "unhidepoll")
                {
                    // We're trying to unhide a poll
                    return HidePoll(false);
                }
            }

            // Did not match the command given, or not given!
            return UnhandledCommand(command); 
        }

        /// <summary>
        /// Called when DispatchCommand does not recognise sAction. Adds Error XML into page. 
        /// </summary>
        /// <param name="cmd">The unhandled command</param>
        protected virtual bool UnhandledCommand(string cmd)
        {
            return AddErrorXml(ErrorCode.ERRORCODE_UNKNOWNCMD.ToString(), "Did not recognise" + cmd + " command", null);
        }
    }
}