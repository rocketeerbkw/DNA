using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The move thread object. Used for moving threads between forums.
    /// </summary>
    public class MoveThread : DnaInputComponent
    {
        private int _threadModID = 0;
        private int _threadID = 0;
        private string _threadSubject = "";
        private int _oldForumID = 0;
        private string _oldForumTitle = "";
        private int _currentForumID = 0;
        private string _currentForumTitle = "";
        private bool _hadErrors = false;
        private XmlNode _moveThreadNode = null;

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The context that the object will be created for</param>
        public MoveThread(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Get property for the threads subject.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public string ThreadSubject
        {
            get { return _threadSubject; }
        }

        /// <summary>
        /// Get property for the threads ID we're being asked to move
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public int ThreadID
        {
            get { return _threadID; }
        }

        /// <summary>
        /// Get property for the threads ModID we're being asked to move.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public int ThreadModID
        {
            get { return _threadModID; }
        }

        /// <summary>
        /// Get property for the old forum id the thread belonged to.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public int OldForumID
        {
            get { return _oldForumID; }
        }

        /// <summary>
        /// Get property for the old forum title the thread belonged to.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public string OldForumTitle
        {
            get { return _oldForumTitle; }
        }

        /// <summary>
        /// Get property for the current forum id the thread belongs to.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public int CurrentForumID
        {
            get { return _currentForumID; }
        }

        /// <summary>
        /// Get property for the current forum title the thread belongs to.
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public string CurrentForumTitle
        {
            get { return _currentForumTitle; }
        }

        /// <summary>
        /// Get property That states if we had errors when we processed the request
        /// Only available after ProcessRequest() has been called
        /// </summary>
        public bool HadErrors
        {
            get { return _hadErrors; }
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            // Check to make sure that the user is an editor
            if (!InputContext.ViewingUser.IsEditor && !InputContext.ViewingUser.IsModerator)
            {
                // Only editors, Moderators and above can use this page!
                AddErrorXml("MoveThread", "User Not Authorised", _moveThreadNode);
                _hadErrors = true;
                return;
            }

            // Get the thread modid from the URL. If it does not exist, try to see if we've been given a threadid
            _threadModID = InputContext.GetParamIntOrZero("ThreadModID", "Get the ThreadModID");
            if (_threadModID == 0)
            {
                _threadID = InputContext.GetParamIntOrZero("ThreadID", "Get the thread to move");
            }

            // Create the XML for the page
            _moveThreadNode = AddElementTag(RootElement, "Move-Thread-Form");
            if (_threadModID > 0)
            {
                AddIntElement(_moveThreadNode, "ModThread-ID", _threadModID);
            }
            else if (_threadID > 0)
            {
                AddIntElement(_moveThreadNode, "Thread-ID", _threadID);
            }

            // Check to make sure we're got something to work with
            if (_threadID == 0 && _threadModID == 0)
            {
                AddErrorXml("MoveThread", "No thread given", _moveThreadNode);
                _hadErrors = true;
                return;
            }

            // Check to see what  we are being asked to do
            if (CheckForMoveActionExists())
            {
                // Get the forum we are moving the thread to
                int forumID = TryGetMoveToForumID();

                // Check to make sure that we've got somewhere to move to
                if (forumID == 0)
                {
                    AddErrorXml("MoveThread", "Invalid forum id given", _moveThreadNode);
                    _hadErrors = true;
                    AddMoveThreadDetails();
                    return;
                }

                // Move the thread to the given forum
                MoveThreadToForum(forumID);
            }
            else if (InputContext.GetParamCountOrZero("Undo", "Do we have a undo move param") > 0)
            {
                // Get the forum we just moved from as we need to put the thread back
                int forumID = InputContext.GetParamIntOrZero("OldForumID", "Get the move to forum id");
                if (forumID == 0)
                {
                    AddErrorXml("MoveThread", "Invalid forum id given", _moveThreadNode);
                    _hadErrors = true;
                    AddMoveThreadDetails();
                    return;
                }
                // Move the thread to the given forum
                MoveThreadToForum(forumID);
            }
            else
            {
                // Just add the threadmod details
                AddMoveThreadDetails();
            }

            // Add the sites topic list
            RootElement.AppendChild(ImportNode(InputContext.CurrentSite.GetTopicListXml()));
        }

        /// <summary>
        /// Helper method that tries to find the forum id to move to. This method copes with the old skins.
        /// New code should look for 'MoveToForumID' and the old system uses 'DestinationID'.
        /// The DestinationID comes through with a 'F' on the front, so we trim that.
        /// </summary>
        /// <returns>The forumID if we find it. 0 otherwise</returns>
        private int TryGetMoveToForumID()
        {
            int forumID = InputContext.GetParamIntOrZero("MoveToForumID", "Get the move to forum id");
            if (forumID == 0)
            {
                // See if we're using the old skins?
                string stringForumID = InputContext.GetParamStringOrEmpty("DestinationID", "Do we have a destination for the thread");
                if (stringForumID.Length > 1)
                {
                    // Strip the F off the front of the id before parsing to an int
                    Int32.TryParse(stringForumID.Substring(1), out forumID);
                }
            }
            return forumID;
        }

        /// <summary>
        /// Helper method that checks to see if we've been given the action to move a thread.
        /// This method is designed to cope with the old skins/system
        /// </summary>
        /// <returns>True if it was found, false if not</returns>
        private bool CheckForMoveActionExists()
        {
            // Check for the new system param
            if (InputContext.GetParamCountOrZero("Move", "Do we have a move param") > 0)
            {
                return true;
            }

            // Check to old system style
            string cmd = InputContext.GetParamStringOrEmpty("cmd", "Have we been given a command?");
            return (cmd.ToLower().CompareTo("move") == 0);
        }

        /// <summary>
        /// Gets and adds the thread mod details to the XML
        /// </summary>
        private void AddMoveThreadDetails()
        {
            // Check to see which version of the get details we are needed to use
            string spName = "";
            if (_threadModID > 0)
            {
                spName = "getthreadmoddetailsfrommodid";
            }
            else if(_threadID > 0)
            {
                spName = "fetchthreadmovedetails";
            }
            else
            {
                return;
            }

            // Get the thread details via the modid
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader(spName))
            {
                if (_threadModID > 0)
                {
                    reader.AddParameter("ModID", _threadModID);
                }
                else
                {
                    reader.AddParameter("ThreadID", _threadID);
                    reader.AddParameter("ForumID", 0);
                }
                reader.Execute();

                // Check to make sure we got something back
                if (reader.HasRows && reader.Read())
                {
                    // Add the details to the XML
                    AddTextTag(_moveThreadNode, "ACTION", "THREAD-DETAILS");
                    _threadSubject = reader.GetString("ThreadSubject");
                    AddTextTag(_moveThreadNode, "THREAD-SUBJECT", _threadSubject);
                    if (_threadModID > 0)
                    {
                        _threadID = reader.GetInt32("ThreadID");
                        AddIntElement(_moveThreadNode, "THREAD-ID", _threadID);
                        _currentForumTitle = reader.GetString("ForumTitle");
                        _currentForumID = reader.GetInt32("ForumID");
                    }
                    else
                    {
                        _currentForumTitle = reader.GetString("OldForumTitle");
                        _currentForumID = reader.GetInt32("OldForumID");
                    }
                    AddTextTag(_moveThreadNode, "OLD-FORUM-TITLE", _currentForumTitle);
                    AddIntElement(_moveThreadNode, "OLD-FORUM-ID", _currentForumID);
                    int isPreModPosting = 0;
                    if (reader.DoesFieldExist("IsPremodPosting"))
                    {
                        isPreModPosting = reader.GetTinyIntAsInt("IsPremodPosting");
                    }
                    AddIntElement(_moveThreadNode, "ISPREMODPOSTING", isPreModPosting);
                    if (reader.DoesFieldExist("PostID"))
                    {
                        AddIntElement(_moveThreadNode, "POSTID", reader.GetInt32("PostID"));
                    }
                }
            }

            // Set the functions
            SetAvailableFunctions(true, false);
        }

        /// <summary>
        /// Moves the given thread to the requested forum
        /// </summary>
        /// <param name="forumID">The id of the forum you want to move the thread to</param>
        private void MoveThreadToForum(int forumID)
        {
            // Check to see which version of the get details we are needed to use
            string spName = "";
            if (_threadModID > 0)
            {
                spName = "movemoderationthreadviamodid";
            }
            else if (_threadID > 0)
            {
                spName = "movethread2";
            }
            else
            {
                return;
            }

            // Now try to move the thread
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader(spName))
            {
                if (_threadModID > 0)
                {
                    reader.AddParameter("ThreadModID", _threadModID);
                }
                else
                {
                    reader.AddParameter("ThreadID", _threadID);
                }
                reader.AddParameter("ForumID", forumID);
                reader.AddIntReturnValue();
                reader.Execute();
                reader.Read();
                
                // Check to see if actually managed to move the thread
                if (!reader.HasRows)
                {
                    // Check to see if we had any errors
                    int returnValue = 0;

                    reader.TryGetIntReturnValue(out returnValue);

                    // Check for known errors
                    if (returnValue == -1)
                    {
                        AddErrorXml("MoveThread", "Failed to find current forum", _moveThreadNode);
                        _hadErrors = true;
                    }
                    else if (returnValue == -2)
                    {
                        AddErrorXml("MoveThread", "Move to forum is same as current forum", _moveThreadNode);
                        _hadErrors = true;
                    }
                    else if (returnValue == -3)
                    {
                        AddErrorXml("MoveThread", "Could not find move to forum", _moveThreadNode);
                        _hadErrors = true;
                    }
                    else
                    {
                        AddErrorXml("MoveThread", "Failed to move thread", _moveThreadNode);
                        _hadErrors = true;
                    }

                    // Add the default thread mod details
                    AddMoveThreadDetails();
                    return;
                }

                // Put the result into the XML
                AddTextTag(_moveThreadNode, "ACTION", "THREAD-MOVED");
                _threadSubject = reader.GetString("ThreadSubject");
                AddTextTag(_moveThreadNode, "THREAD-SUBJECT", _threadSubject);
                if (_threadModID > 0)
                {
                    _threadID = reader.GetInt32("ThreadID");
                }
                AddIntElement(_moveThreadNode, "THREAD-ID", _threadID);

                _oldForumID = reader.GetInt32("OldForumID");
                _oldForumTitle = reader.GetString("OldForumTitle");
                _currentForumID = reader.GetInt32("NewForumID");
                _currentForumTitle = reader.GetString("NewForumTitle");
                
                AddTextTag(_moveThreadNode, "NEW-FORUM-TITLE", _currentForumTitle);
                AddIntElement(_moveThreadNode, "NEW-FORUM-ID", _currentForumID);
                AddTextTag(_moveThreadNode, "OLD-FORUM-TITLE", _oldForumTitle);
                AddIntElement(_moveThreadNode, "OLD-FORUM-ID", _oldForumID);
                int isPreModPosting = 0;
                if (reader.DoesFieldExist("IsPremodPosting"))
                {
                    isPreModPosting = reader.GetTinyIntAsInt("IsPremodPosting");
                }
                AddIntElement(_moveThreadNode, "ISPREMODPOSTING", isPreModPosting);
            }

            // Now post to the end of the thread stating that we've just moved it
            // Only do this if we're moving from or to a NON trash forum.
            if (_currentForumID > 1 && _oldForumID > 1)
            {
                PostToEndOfThread();
            }

            // Set the functions
            SetAvailableFunctions(false, true);
        }

        /// <summary>
        /// Posts to the end of the thread saying that the thread has been move.
        /// Has optional moderators comment if PostContent URL param is used.
        /// </summary>
        private void PostToEndOfThread()
        {
            // Create the message to post
            string subject = "Thread Moved";
            string body = "Editorial Note: This conversation has been moved from '";
            body += _oldForumTitle + "' to '" + _currentForumTitle + "'.";
            if (InputContext.DoesParamExist("PostContent", "Do we have post content"))
            {
                body += "\n\n" + InputContext.GetParamStringOrEmpty("PostContent", "Get the post content");
            }

            int userID = InputContext.CurrentSite.AutoMessageUserID;
            string hashString = subject + "<:>" + body + "<:>" + userID.ToString() + "<:>0<:>" + _threadID + "<:>0";

            // Now post to the thread
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("PostToEndOfThread"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("ThreadID", _threadID);
                reader.AddParameter("Subject", subject);
                reader.AddParameter("Content", body);
                reader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));
                reader.AddParameter("KeyWords", DBNull.Value);
                reader.Execute();
            }
        }

        /// <summary>
        /// Adds the available functions to the xml. This is a backwards compatability
        /// function so that when we're rendering using xslt, we can use the existing skins
        /// </summary>
        /// <param name="move">A flag to state that the move function is available</param>
        /// <param name="undo">A flag to state that the undo function is available</param>
        private void SetAvailableFunctions(bool move, bool undo)
        {
            // Add the function node
            XmlNode functionNode = AddElementTag(_moveThreadNode, "FUNCTIONS");

            // Now add the functions
            if (move)
            {
                AddElementTag(functionNode, "MOVE");
            }
            if (undo)
            {
                AddElementTag(functionNode, "UNDO");
            }
        }
    }
}
