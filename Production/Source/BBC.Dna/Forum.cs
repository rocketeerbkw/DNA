
using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;


namespace BBC.Dna
{
    ///TODO: Replace with BBC.Dna.Objects.ForumHelper
    /// <summary>
    /// The forum object
    /// </summary>
    public class Forum : DnaInputComponent
    {
        /// <summary>
        /// Default constructor. This is derived from the DnaInputComponent
        /// </summary>
        /// <param name="context">An object that impliments the IInputContext interface</param>
        public Forum(IInputContext context)
            : base(context)
        {
        }

        private string _cachedFileName;
        private int _forumID = 0;
        private int _siteID = 0;

        /// <summary>
        /// The get property for the forums id
        /// </summary>
        public int ForumID
        {
            get { return _forumID; }
        }

        /// <summary>
        /// The get property for the forums site id
        /// </summary>
        public int SiteID
        {
            get { return _siteID; }
        }

        /// <summary>
        /// Gets the style for a given forum
        /// </summary>
        /// <param name="forumID">The id of the forum you want to get the sytle for</param>
        /// <returns>The style of the given forum, OR 0 if it fails to find the forum</returns>
        public int GetForumStyle(int forumID)
        {
            // Get the forums style from the database
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getforumstyle"))
            {
                reader.AddParameter("ForumID", forumID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    return reader.GetOrdinal("ForumStyle");
                }
                return 0;
            }
        }

        /// <summary>
        /// Gets all the posts in a given forum and creates the XML tree.
        /// </summary>
        /// <param name="forumID">The id of the forum you want to get the posts for</param>
        /// <param name="skip">The number of posts to skip before displaying</param>
        /// <param name="show">The number of posts to display</param>
        public void GetPostsInForum(int forumID, int skip, int show)
        {
            // Make sure we don't get silly numbers!
            if (show > 200)
            {
                show = 200;
            }

            // Get the most recent thread date
            DateTime expiryDate = GetMostRecentThreadDate(forumID);

            // Check to see if the forum is cached
            _cachedFileName = "F" + forumID.ToString() + "-" + skip.ToString() + "-" + Convert.ToString(skip + show - 1) + ".txt";
            string cachedForum = "";
            if (InputContext.FileCacheGetItem("forumpostsguestbook", _cachedFileName, ref expiryDate, ref cachedForum) && cachedForum.Length > 0)
            {
                // Create the forum from the cache
                CreateAndInsertCachedXML(cachedForum, "FORUMTHREADS", true);
            }
            else
            {
                // Not cached! Have to get it from the database
            }
        }

        /// <summary>
        /// Get sthe most recent posts for a given forum id
        /// </summary>
        /// <param name="forumID">The id of the forum you want to get the posts for</param>
        public void GetMostRecent(int forumID)
        {
            // Check to make sure we get given a valid forum id
            if (forumID <= 0)
            {
                // Let the skins know and return
                AddElementTag(RootElement, "NOFORUMFOUND");
                return;
            }

            // Get the thread list for the given forum id
            GetThreadList(forumID, 10, 0, 0, false, 1);
        }

        /// <summary>
        /// Gets the thread list for a given forum
        /// </summary>
        /// <param name="forumID">The ID of the forum you want to get the list for</param>
        /// <param name="show">The number of threads you want to pull out</param>
        /// <param name="skip">The number of threads you want to skip</param>
        /// <param name="threadID">The threadid you want to start getting threads from. Alternative to skip</param>
        /// <param name="overflow">If true pulls back one thread before and after the set of shown threads</param>
        /// <param name="threadOrder">The order in which you want to get the post back.</param>
        private void GetThreadList(int forumID, int show, int skip, int threadID, bool overflow, int threadOrder)
        {
            // Check to make sure we've been given acceptable values
            if (show > 200)
            {
                show = 200;
            }

            // Check to see if we've been given a threadid to start fetching from
            if (threadID > 0)
            {
                // Update the skip value relative to the thread.
                int index = GetIndexForThreadInForum(forumID, threadID);
                skip = index / show;
                skip *= show;
            }

            // Get the site that the forum belongs to
            int siteID = GetSiteIDForForum(forumID);

            // Get the most recent thread date
            DateTime expiryDate = GetMostRecentThreadDate(forumID);

            // Check to see if the forum is cached
            _cachedFileName = "FT" + forumID.ToString() + "-" + skip.ToString() + "-" + Convert.ToString(skip + show - 1) + "-" + Convert.ToInt32(overflow).ToString() + "-" + threadOrder.ToString() + ".txt";
            string cachedForum = "";
            if (InputContext.FileCacheGetItem("forumthreads", _cachedFileName, ref expiryDate, ref cachedForum) && cachedForum.Length > 0)
            {
                // Create the forum from the cache
                CreateAndInsertCachedXML(cachedForum, "FORUMTHREADS", true);

                // Set the siteid form the tree
                if (RootElement.SelectSingleNode("//SITEID") != null)
                {
                    _siteID = Convert.ToInt32(RootElement.SelectSingleNode("//SITEID").Value);
                }

                // Set the forum field
                _forumID = forumID;

                // Update the users permissions
                FilterOnThreadPermissions(ForumID);

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return;
            }

            // Not cached. Get the threadlist from the database and cache it if it's valid
            // Work out how many to skip and show depending on the request
            int startIndex = skip;
            int lastIndex = show;
            if (overflow)
            {
                if (skip <= 0)
                {
                    startIndex = 0;
                }
                else
                {
                    startIndex -= 1;
                    lastIndex = skip + show;
                }
            }
            else
            {
                lastIndex = skip + show - 1;
            }

            // Now get the threads
            bool cacheResult = true;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("forumgetthreadlist"))
            {
                reader.AddParameter("ForumID", forumID);
                reader.AddParameter("FirstIndex", startIndex);
                reader.AddParameter("LastIndex", lastIndex);
                reader.AddParameter("ThreadOrder", threadOrder);
                reader.Execute();
                cacheResult = reader.HasRows;

                bool moreData = false;
                bool defaultCanRead = true;
                bool defaultCanWrite = true;
                bool threadCanRead = true;
                bool threadCanWrite = true;
                int moderationStatus = 0;
                int forumPostCount = 0;
                int alertInstantly = 0;
                int journalOwner = 0;
                int threadCount = 0;

                if (reader.Read())
                {
                    moreData = true;
                    if (reader.Exists("JournalOwner"))
                    {
                        journalOwner = reader.GetInt32NullAsZero("JournalOwner");
                    }
                    defaultCanRead = reader.GetBoolean("CanRead");
                    defaultCanWrite = reader.GetBoolean("CanWrite");
                    threadCanRead = reader.GetBoolean("ThreadCanRead");
                    threadCanWrite = reader.GetBoolean("ThreadCanWrite");
                    moderationStatus = reader.GetInt32NullAsZero("ModerationStatus");
                    _siteID = reader.GetInt32("SiteID");
                    if (reader.Exists("ForumPostCount"))
                    {
                        forumPostCount = reader.GetInt32("ForumPostCount");
                    }
                    alertInstantly = reader.GetInt32("AlertInstantly");
                    threadCount = reader.GetInt32("ThreadCount");
                }

                // Now create the xml tree
                XmlNode forumThreadsNode = AddElementTag(RootElement, "FORUMTHREADS");

                // Add all the attributes for the Forum Thread node
                AddAttribute(forumThreadsNode, "FORUMID", forumID);
                AddAttribute(forumThreadsNode, "SKIPTO", skip);
                AddAttribute(forumThreadsNode, "COUNT", show);
                if (journalOwner > 0)
                {
                    AddAttribute(forumThreadsNode, "JOURNALOWNER", journalOwner);
                }
                AddAttribute(forumThreadsNode, "THREADCOUNT", threadCount);
                AddAttribute(forumThreadsNode, "FORUMPOSTCOUNT", forumPostCount);
                AddAttribute(forumThreadsNode, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
                AddAttribute(forumThreadsNode, "SITEID", siteID);
                AddAttribute(forumThreadsNode, "CANREAD", Convert.ToInt32(defaultCanRead));
                AddAttribute(forumThreadsNode, "CANWRITE", Convert.ToInt32(defaultCanWrite));
                AddAttribute(forumThreadsNode, "THREADCANREAD", Convert.ToInt32(threadCanRead));
                AddAttribute(forumThreadsNode, "THREADCANWRITE", Convert.ToInt32(threadCanWrite));
                if (threadCount > (skip + show))
                {
                    AddAttribute(forumThreadsNode, "MORE", 1);
                }
                AddAttribute(forumThreadsNode, "ALERTINSTANTLY", alertInstantly);

                // Now add all the other info
                XmlNode moderationNode = AddIntElement(forumThreadsNode, "MODERATIONSTATUS", moderationStatus);
                AddAttribute(moderationNode, "ID", forumID);

                // Check to see if we are being asked to show more threads
                if (overflow)
                {
                    if (skip == 0)
                    {
                        show += 1;
                    }
                    else
                    {
                        show += 2;
                    }
                }

                // Now go through the threads adding them to the tree
                int index = 0;
                bool firstItem = true;
                int numberOfThreads = show;
                while (moreData && threadCount > 0 && numberOfThreads > 0)
                {
                    // Create the node for this thread
                    XmlNode threadNode = AddElementTag(forumThreadsNode, "THREAD");
                    AddAttribute(threadNode, "FORUMID", forumID);
                    int thisThreadID = reader.GetInt32("ThreadID");
                    AddAttribute(threadNode, "THREADID", thisThreadID);
                    AddAttribute(threadNode, "INDEX", index);

                    if (firstItem && overflow && (skip > 0))
                    {
                        AddAttribute(threadNode, "OVERFLOW", 1);
                    }
                    if (overflow && (show > 1))
                    {
                        AddAttribute(threadNode, "OVERFLOW", 2);
                    }

                    int canRead = reader.GetByte("ThisCanRead");
                    AddAttribute(threadNode, "CANREAD", canRead);
                    AddAttribute(threadNode, "CANWRITE", reader.GetByte("ThisCanWrite"));
                    AddIntElement(threadNode, "THREADID", thisThreadID);

                    string subject = reader.GetString("FirstSubject");
                    if (canRead == 0)
                    {
                        subject += " - Hidden";
                    }
                    AddTextElement((XmlElement)threadNode, "SUBJECT", subject);

                    XmlNode datePostedNode = AddElementTag(threadNode, "DATEPOSTED");
                    datePostedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("LastPosted"), true));

                    AddIntElement(threadNode, "TOTALPOSTS", reader.GetInt32("cnt"));

                    if (reader.Exists("TYPE"))
                    {
                        AddTextElement((XmlElement)threadNode, "TYPE", reader.GetStringNullAsEmpty("Type"));
                    }

                    if (reader.Exists("EVENTDATE") && !reader.IsDBNull("EVENTDATE"))
                    {
                        XmlNode eventDateNode = AddElementTag(threadNode, "EVENTDATE");
                        eventDateNode.AppendChild(DnaDateTime.GetDateTimeAsNode(reader.GetDateTime("EventDate")));
                    }

                    // Now add the first poster information
                    CreateFirstPoster(reader, threadNode);

                    // Create the last poster for the tread
                    CreateLastPoster(reader, threadNode);

                    // Now check to see if we've got more threads
                    moreData = reader.Read();
                    firstItem = false;
                    index++;
                    numberOfThreads--;
                }

                // Check to see if we're needed to cache the threadlist
                if (cacheResult)
                {
                }

                // Update the users permissions
                FilterOnThreadPermissions(ForumID);

                // Finally update the relative dates and return
                UpdateRelativeDates();
            }
        }

        /// <summary>
        /// Creates the first poster block for the thread lists
        /// </summary>
        /// <param name="reader">The DNADataReader that contains the post details</param>
        /// <param name="threadNode">The node that you want to add the poster block to</param>
        private void CreateFirstPoster(IDnaDataReader reader, XmlNode threadNode)
        {
            XmlNode firstPostNode = CreateThreadPostingXml(reader, threadNode, "First");
            firstPostNode.InsertBefore(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("FirstPosting"), true), firstPostNode.FirstChild);
        }

        /// <summary>
        /// Creates the last poster block for a thread
        /// </summary>
        /// <param name="reader">The DNADataReader that contains the post details</param>
        /// <param name="threadNode">The node that you want to add the poster to</param>
        private void CreateLastPoster(IDnaDataReader reader, XmlNode threadNode)
        {
            XmlNode lastPostNode = CreateThreadPostingXml(reader, threadNode, "Last");
            lastPostNode.InsertBefore(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("LastPosted"), true), lastPostNode.FirstChild);
        }

        /// <summary>
        /// Creates the XML block for a posting in a thread
        /// </summary>
        /// <param name="reader">The IDnaDataReader that contains the information about the posting</param>
        /// <param name="threadNode">The node to add the posting node to</param>
        /// <param name="usersPrefix">Pass in 'First' if the post is the first post in the thread, and 'last' if it's the last.</param>
        /// <returns>The new post node</returns>
        private XmlNode CreateThreadPostingXml(IDnaDataReader reader, XmlNode threadNode, string usersPrefix)
        {
            XmlNode postingNode = AddElementTag(threadNode, usersPrefix + "POST");
            AddAttribute(postingNode, "POSTID", reader.GetInt32(usersPrefix + "PostEntryID"));
            AddAttribute(postingNode, "HIDDEN", reader.GetInt32NullAsZero(usersPrefix + "PostHidden"));

            User postingUser = new User(InputContext);
            postingUser.AddPrefixedUserXMLBlock(reader, reader.GetInt32(usersPrefix + "PostUserID"), usersPrefix + "Post", postingNode);

            if (!reader.IsDBNull(usersPrefix + "PostHidden") && reader.GetInt32(usersPrefix + "PostHidden") > 0)
            {
                AddTextElement((XmlElement)postingNode, "TEXT", "Hidden");
            }
            else
            {
                string text = reader.GetString(usersPrefix + "PostText");

                // Do the translate to plain text here!

                XmlNode textNode = AddTextElement((XmlElement)postingNode, "TEXT", text);
            }

            return postingNode;
        }

        /// <summary>
        /// Gets the most recent thread date
        /// </summary>
        /// <param name="forumID">The forum you want to check against</param>
        /// <returns>The date of the most recent thread entry date for the forum</returns>
        private DateTime GetMostRecentThreadDate(int forumID)
        {
            // Get the date from the database
            DateTime expiryDate = DateTime.Now;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("cachegetmostrecentthreaddate"))
            {
                reader.AddParameter("ForumID", forumID);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    expiryDate = DateTime.Now.Subtract(new TimeSpan(0, 0, reader.GetInt32("MostRecent")));
                }
            }

            // Return the date
            return expiryDate;
        }

        /// <summary>
        /// Gets the index of a given thread in a given forum
        /// </summary>
        /// <param name="forumID">The forum the thread belongs to</param>
        /// <param name="threadID">The thread you want to get the index for</param>
        /// <returns>The index of the requested thread, or 0 if it was not found</returns>
        public int GetIndexForThreadInForum(int forumID, int threadID)
        {
            // Get the index for the thread form the database
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getindexofthread"))
            {
                reader.AddParameter("ThreadID", threadID);
                reader.AddParameter("ForumID", forumID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    return reader.GetInt32("Index");
                }
            }

            // Didn't find any results, return 0
            return 0;
        }

        /// <summary>
        /// Gets the site id for the site that the forum belongs to.
        /// </summary>
        /// <param name="forumID">The forum id you want to get the site id for</param>
        /// <returns>The id of the site that the forum belongs to</returns>
        public int GetSiteIDForForum(int forumID)
        {
            return GetSiteIDForForumOrThread(forumID, 0);
        }

        /// <summary>
        /// Gets the site id for the site that the thread belongs to.
        /// </summary>
        /// <param name="threadid">The id of the thread you want to get the site id for</param>
        /// <returns>The id of the site that the thread belongs to</returns>
        public int GetSiteIDForThread(int threadid)
        {
            return GetSiteIDForForumOrThread(0, threadid);
        }

        /// <summary>
        /// Gets the sites id that the forum was created in.
        /// </summary>
        /// <param name="forumID">The forum id that you want to get the siteid for. Set to 0 if you are using threadid</param>
        /// <param name="threadID">The Thread id that you want to get the siteid for. Set to 0 if you are using forumid</param>
        /// <returns>The id of the site that the forum or thread belongs to, 0 if it could not be found</returns>
        private int GetSiteIDForForumOrThread(int forumID, int threadID)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetForumSiteID"))
            {
                // Add the params and execute
                reader.AddParameter("forumid", forumID);
                reader.AddParameter("threadid", threadID);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    // Return the site id returned from the database
                    return reader.GetInt32("siteid");
                }

                // Failed to get the siteid, return 0
                return 0;
            }
        }

        /// <summary>
        /// This method updates all the THREADs CanRead/CanWrite permissions in the FORUMTHREADS block depending on the viewing user.
        /// </summary>
        /// <param name="forumID">The forumid of the forum you want to filter</param>
        private void FilterOnThreadPermissions(int forumID)
        {
            FilterOnPermissions(forumID, "FORUMTHREADS", "THREAD");
        }

        /// <summary>
        /// This method updates all the POSTs CanRead/CanWrite permissions in the FORUMTHREADPOSTS block depending on the viewing user.
        /// </summary>
        /// <param name="forumID">The forumid of the forum you want to filter</param>
        private void FilterOnPostPermissions(int forumID)
        {
            FilterOnPermissions(forumID, "FORUMTHREADPOSTS", "POST");
        }

        /// <summary>
        /// This method updates all the POSTs CanRead/CanWrite permissions in the JOURNALPOSTS block depending on the viewing user.
        /// </summary>
        /// <param name="forumID">The forumid of the forum you want to filter</param>
        private void FilterOnJournalPostPermissions(int forumID)
        {
            FilterOnPermissions(forumID, "JOURNALPOSTS", "POST");
        }

        /// <summary>
        /// Updates the Threads/Posts CanRead/CanWrite permissions for the viewing user.
        /// </summary>
        /// <param name="forumID">The forum you want to check the permissions against.</param>
        /// <param name="tagName">The name of the node that you want to update the children of.</param>
        /// <param name="childTagName">The name of the child nodes that will be updated.</param>
        /// <remarks>Do not call this method directly, instead use the FilterOnThreadPermissions(), FilterOnPostsPermissions() or FilterOnPostPermissions()</remarks>
        private void FilterOnPermissions(int forumID, string tagName, string childTagName)
        {
            bool canRead = true;
            bool canWrite = true;
            bool defaultCanRead = true;
            bool defaultCanWrite = true;

            // Check the default attributes if there are any
            XmlElement tagNode = (XmlElement)RootElement.SelectSingleNode("//" + tagName);
            if (tagNode != null && tagNode.Attributes["CANREAD"] != null)
            {
                canRead = Convert.ToInt32(tagNode.Attributes["CANREAD"].Value) > 0;
                defaultCanRead = canRead;
            }
            if (tagNode != null && tagNode.Attributes["CANWRITE"] != null)
            {
                canWrite = Convert.ToInt32(tagNode.Attributes["CANWRITE"].Value) > 0;
                defaultCanWrite = canWrite;
            }

            // Now check to see if we've got a user. If so get the permissions for them
            bool editor = false;
            if (InputContext.ViewingUser.UserID != 0 && InputContext.ViewingUser.UserLoggedIn)
            {
                // Are we a superuser or editor?
                if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser)
                {
                    canRead = true;
                    canWrite = true;
                    editor = true;
                }
                else
                {
                    // Check the database for the users permissions
                    using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getforumpermissions"))
                    {
                        reader.AddParameter("UserID", InputContext.ViewingUser.UserID);
                        reader.AddParameter("ForumID", forumID);
                        reader.AddIntOutputParameter("CanRead");
                        reader.AddIntOutputParameter("CanWrite");
                        reader.Execute();

                        if (reader.HasRows && reader.NextResult())
                        {
                            int canReadAsNum = 0;
                            int canWriteAsNum = 0;
                            reader.TryGetIntOutputParameter("CanRead", out canReadAsNum);
                            reader.TryGetIntOutputParameter("CanWrite", out canWriteAsNum);
                            canRead = canReadAsNum > 0;
                            canWrite = canWriteAsNum > 0;
                        }
                    }
                }
            }

            // Check to see if the site is closed and we're a normal user
            bool siteClosed = false;
            if (!editor && canWrite)
            {
                // If the site is closed, they cannot write!
                if (InputContext.CurrentSite.IsSiteScheduledClosed(DateTime.Now) || InputContext.CurrentSite.IsEmergencyClosed)
                {
                    canWrite = false;
                    siteClosed = true;
                }
            }

            // Now update the attributes of the tag
            tagNode.SetAttribute("CANREAD", Convert.ToInt32(canRead).ToString());
            tagNode.SetAttribute("CANWRITE", Convert.ToInt32(canWrite).ToString());
            if (tagNode.HasAttribute("DEFAULTCANREAD"))
            {
                tagNode.SetAttribute("DEFAULTCANREAD", Convert.ToInt32(defaultCanRead).ToString());
            }
            else
            {
                AddAttribute(tagNode, "DEFAULTCANREAD", Convert.ToInt32(defaultCanRead).ToString());
            }
            if (tagNode.HasAttribute("DEFAULTCANWRITE"))
            {
                tagNode.SetAttribute("DEFAULTCANWRITE", Convert.ToInt32(defaultCanWrite).ToString());
            }
            else
            {
                AddAttribute(tagNode, "DEFAULTCANWRITE", Convert.ToInt32(defaultCanWrite).ToString());
            }

            // Remove the contents of the item if we're given one and canread value is False
            if (!canRead)
            {
                XmlNodeList childNodes = tagNode.SelectNodes("//" + childTagName);
                foreach (XmlNode node in childNodes)
                {
                    // If we found the child, remove it
                    tagNode.RemoveChild(node);
                }
            }

            // If the site is closed, update all childrens canwrite flags
            if (siteClosed)
            {
                XmlNodeList childNodes = tagNode.SelectNodes("//" + childTagName);
                foreach (XmlNode node in childNodes)
                {
                    // Check to make sure that the child has the CANREAD attibute, if not create it first
                    if (node.Attributes["CANREAD"] == null)
                    {
                        XmlAttribute attr = RootElement.OwnerDocument.CreateAttribute("CANREAD");
                        node.Attributes.Append(attr);
                    }
                    node.Attributes["CANREAD"].Value = "0";
                }
            }
        }

        /// <summary>
        /// Given a user id and a date created time return whether or not a post would be editable by
        /// the viewing user on this site
        /// </summary>
        /// <param name="postEditorID">posts editor</param>
        /// <param name="dateCreated">Date post was created</param>
        /// <returns>0 if not editable or the number of minutes left until it is not</returns>
        public int GetPostEditableAttribute(int postEditorID, DateTime dateCreated)
        {
            int timeout = InputContext.CurrentSite.ThreadEditTimeLimit;

            if (timeout <= 0 || InputContext.ViewingUser.UserID != postEditorID)
            {
                return 0;
            }
            int editable = 0;

            DateTime currentTime = DateTime.Now;
            TimeSpan difference = currentTime - dateCreated;

            int minutesLeft = timeout - difference.Minutes;
            if (minutesLeft >= 0)
            {
                editable = minutesLeft;
            }
            return editable;
        }
        /// <summary>
        /// Gets the journal forum
        /// </summary>
        /// <param name="journalID">The ID of the journal you want to get the list for</param>
        /// <param name="show">The number of threads you want to pull out</param>
        /// <param name="skip">The number of threads you want to skip</param>
        /// <param name="showUserHidden">Whether to show user hidden</param>
        public void GetJournal(int journalID, int show, int skip, bool showUserHidden)
        {
            if (journalID == 0)
            {
                // Now create the xml tree
                XmlElement journalPosts = AddElementTag(RootElement, "JOURNALPOSTS");

                // Add all the attributes for the JournalPosts node
                AddAttribute(journalPosts, "FORUMID", journalID);
                AddAttribute(journalPosts, "SKIPTO", skip);
                AddAttribute(journalPosts, "COUNT", show);

                AddAttribute(journalPosts, "TOTALTHREADS", 0);
                AddAttribute(journalPosts, "CANREAD", 1);
                AddAttribute(journalPosts, "CANWRITE", 0);

                return;
            }
            // Check to make sure we've been given acceptable values
            if (show > 200)
            {
                show = 200;
            }

            // Get the site that the forum belongs to
            int siteID = GetSiteIDForForum(journalID);

            // Get the most recent thread date
            DateTime expiryDate = GetMostRecentThreadDate(journalID);

            // Check to see if the journal is cached
            _cachedFileName = "J" + journalID.ToString() + "-" + skip.ToString() + "-" + Convert.ToString(skip + show - 1) + "-" + showUserHidden.ToString() + ".txt";
            string cachedJournal = "";
            if (InputContext.FileCacheGetItem("journal", _cachedFileName, ref expiryDate, ref cachedJournal) && cachedJournal.Length > 0)
            {
                // Create the journal from the cache
                CreateAndInsertCachedXML(cachedJournal, "JOURNALPOSTS", true);

                // Set the siteid from the tree
                if (RootElement.SelectSingleNode("//SITEID") != null)
                {
                    _siteID = Convert.ToInt32(RootElement.SelectSingleNode("//SITEID").Value);
                }

                // Set the forum field
                _forumID = journalID;

                // Update the users permissions
                FilterOnJournalPostPermissions(ForumID);

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return;
            }

            // Not cached. Get the journal from the database and cache it if it's valid
            bool cacheResult = true;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("forumlistjournalthreadswithreplies"))
            {
                dataReader.AddParameter("ForumID", journalID);
                dataReader.Execute();
                cacheResult = dataReader.HasRows;

                bool moreData = false;
                bool defaultCanRead = true;
                bool defaultCanWrite = true;
                int moderationStatus = 0;
                int totalThreads = 0;

                if (dataReader.Read())
                {
                    moreData = true;
                    defaultCanRead = dataReader.GetBoolean("CanRead");
                    defaultCanWrite = dataReader.GetBoolean("CanWrite");
                    moderationStatus = dataReader.GetInt32NullAsZero("ModerationStatus");
                    totalThreads = dataReader.GetInt32("ThreadCount");
                }

                // Now create the xml tree
                XmlElement journalPosts = AddElementTag(RootElement, "JOURNALPOSTS");

                // Add all the attributes for the JournalPosts node
                AddAttribute(journalPosts, "FORUMID", journalID);
                AddAttribute(journalPosts, "SKIPTO", skip);
                AddAttribute(journalPosts, "COUNT", show);

                AddAttribute(journalPosts, "TOTALTHREADS", totalThreads);
                AddAttribute(journalPosts, "CANREAD", Convert.ToInt32(defaultCanRead));
                AddAttribute(journalPosts, "CANWRITE", Convert.ToInt32(defaultCanWrite));

                if (skip > 0)
                {
                    //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                    //the one required
                    for (int i = 0; i < skip; i++)
                    {
                        moreData = dataReader.Read();
                    }
                }

                // Now add all the other info
                //XmlNode moderationNode = AddIntElement(forumThreadsNode, "MODERATIONSTATUS", moderationStatus);
                //AddAttribute(moderationNode, "ID", forumID);

                int numberOfPosts = show;
                while (moreData && numberOfPosts > 0 && totalThreads > 0)
                {
                    int threadID = dataReader.GetInt32NullAsZero("ThreadID");
                    int postID = dataReader.GetInt32NullAsZero("EntryID");
                    int userID = dataReader.GetInt32NullAsZero("UserID");
                    int count = dataReader.GetInt32NullAsZero("Cnt");
                    int hidden = dataReader.GetInt32NullAsZero("Hidden");

                    string subject = "";
                    string text = "";

                    //Allow author to view their own user-hidden items.
                    bool showHidden = (hidden == 7 && showUserHidden && InputContext.ViewingUser.UserID == userID);
                    if (hidden > 0 && !showHidden)
                    {
                        subject = "Hidden";
                        text = "This post has been hidden";
                    }
                    else
                    {
                        subject = dataReader.GetStringNullAsEmpty("Subject");
                        text = dataReader.GetStringNullAsEmpty("text");
                    }

                    // Add the text, checking to see what style it is
                    int postStyle = 0;
                    if (!dataReader.IsDBNull("PostStyle"))
                    {
                        postStyle = dataReader.GetTinyIntAsInt("PostStyle");
                    }
                    if (postStyle != 1)
                    {
                        text = Translator.TranslateText(text);

                        //text = StringUtils.ConvertPlainText(text);
                    }
                    else
                    {
                        //TODO Do we need Rich Post stuff for the post style??
                        string temp = "<RICHPOST>" + text.Replace("\r\n", "<BR />").Replace("\n", "<BR />") + "</RICHPOST>";
                        //Regex regex = new Regex(@"(<[^<>]+)<BR \/>");
                        //while (regex.Match(temp).Success)
                        //{
                        //    temp = regex.Replace(temp, @"$1 ");
                        //}
                        //text = temp;
                        text = HtmlUtils.TryParseToValidHtml(temp);
                    }

                    XmlElement post = AddElementTag(journalPosts, "POST");
                    AddAttribute(post, "POSTID", postID);
                    AddAttribute(post, "THREADID", threadID);
                    AddAttribute(post, "HIDDEN", hidden);
                    AddTextTag(post, "SUBJECT", subject);

                    AddDateXml(dataReader, post, "DATEPOSTED", "DatePosted");

                    if (count > 0)
                    {
                        AddDateXml(dataReader, post, "LASTREPLY", "LastReply");
                        XmlElement lastReplyTag = (XmlElement)post.SelectSingleNode("LASTREPLY");
                        AddAttribute(lastReplyTag, "COUNT", count);
                    }

                    User tempUser = new User(InputContext);
                    tempUser.AddUserXMLBlock(dataReader, userID, post);

                    AddXmlTextTag(post, "TEXT", text);

                    // Now check to see if we've got more posts
                    moreData = dataReader.Read();
                    numberOfPosts--;
                }
                if ((totalThreads > (skip + show)) && moreData)
                {
                    AddAttribute(journalPosts, "MORE", 1);
                }

                // Check to see if we're needed to cache the journal
                if (cacheResult)
                {
                    InputContext.FileCachePutItem("journal", _cachedFileName, journalPosts.OuterXml);
                }

                FilterOnJournalPostPermissions(journalID);

                UpdateRelativeDates();
            }
        }

        /// <summary>
        /// Another method for the title where there extra params are not needed. See Get Title
        /// </summary>
        /// <param name="forumID">ID of forum</param>
        /// <param name="threadID">ID of forum thread</param>
        /// <param name="includeArticle">flag to include article data</param>
        public void GetTitle(int forumID, int threadID, bool includeArticle)
        {
            int type = 0;
            int ID = 0;
            string title = String.Empty;
            int siteID = 0;
            string url = String.Empty;

            GetTitle(forumID, threadID, includeArticle, ref type, ref ID, ref title, ref siteID, ref url);

        }


        /*		    <FORUMSOURCE>
                        <JOURNAL>
                            <USER>
                                <USERID>6</USERID>
                                <USERNAME>Jim Lynn</USERNAME>
                            </USER>
                        </JOURNAL>
                    </FORUMSOURCE>
    				
                    or

                    <FORUMSOURCE>
                        <ARTICLE>
                            <H2G2ID>12345</H2G2ID>
                            <SUBJECT>Hello there</SUBJECT>
                        </ARTICLE>
                    </FORUMSOURCE>

                    or

                    <FORUMSOURCE>
                        <USERPAGE>
                            <USER>
                                <USERID>6</USERID>
                                <USERNAME>Jim Lynn</USERNAME>
                            </USER>
                        </USERPAGE>
                    </FORUMSOURCE>

                    or 

                    <FORUMSOURCE>
                        <CLUB ID= '1'>
                            <NAME>Dharmesh Club</NAME>
                        </CLUB>
                    </FORUMSOURCE> 
         */
        /// <summary>
        /// Builds an XML representation of the forum source, vis:
        /// </summary>
        /// <param name="forumID">ID of forum</param>
        /// <param name="threadID">ID of forum thread</param>
        /// <param name="includeArticle">flag to include article data</param>
        /// <param name="type">Type of forum</param>
        /// <param name="ID">ID either H2G2ID or club ID</param>
        /// <param name="title">Title</param>
        /// <param name="siteID">Site ID</param>
        /// <param name="url">URL involved</param>
        public void GetTitle(int forumID, int threadID, bool includeArticle, ref int type, ref int ID, ref string title, ref int siteID, ref string url)
        {
            string subject = "";	// Subject based on type found
            int userID = 0;
            int reviewForumID = 0;
            int alertInstantly = 0;
            int hiddenStatus = 0;
            int articleStatus = 0;
            int realForumID = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getforumsource"))
            {
                dataReader.AddParameter("ForumID", forumID);
                dataReader.AddParameter("ThreadID", threadID);
                dataReader.AddParameter("CurrentSiteID", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                if (dataReader.HasRows && dataReader.Read())
                {
                    // Fill in return values
                    ID = dataReader.GetInt32NullAsZero("h2g2ID");
                    type = dataReader.GetInt32NullAsZero("Type");
                    hiddenStatus = dataReader.GetInt32NullAsZero("HiddenStatus");
                    articleStatus = dataReader.GetInt32NullAsZero("ArticleStatus");
                    alertInstantly = dataReader.GetInt32NullAsZero("AlertInstantly");
                    siteID = dataReader.GetInt32NullAsZero("SiteID");
                    realForumID = dataReader.GetInt32NullAsZero("ForumID");

                    reviewForumID = 0;
                    userID = 0;

                    if (dataReader.GetInt32NullAsZero("JournalOwner") > 0)
                    {
                        title = dataReader.GetStringNullAsEmpty("JournalUserName");
                        userID = dataReader.GetInt32NullAsZero("JournalOwner");
                    }
                    else if (dataReader.GetInt32NullAsZero("UserID") > 0)
                    {
                        title = dataReader.GetStringNullAsEmpty("UserName");
                        userID = dataReader.GetInt32NullAsZero("UserID");
                    }
                    else if (!dataReader.IsDBNull("ReviewForumID"))
                    {
                        title = dataReader.GetStringNullAsEmpty("ReviewForumName");
                        reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                    }
                    else if (!dataReader.IsDBNull("URL"))
                    {
                        url = dataReader.GetStringNullAsEmpty("URL");
                    }
                    else
                    {
                        title = dataReader.GetStringNullAsEmpty("Subject");
                    }

                    XmlElement forumSource = AddElementTag(RootElement, "FORUMSOURCE");

                    if (type == 0)
                    {
                        AddAttribute(forumSource, "TYPE", "journal");

                        User journalOwner = new User(InputContext);
                        journalOwner.AddPrefixedUserXMLBlock(dataReader, userID, "Journal", forumSource);
                    }
                    else if (type == 3)
                    {
                        // It's a review forum
                        AddAttribute(forumSource, "TYPE", "reviewforum");

                        XmlElement reviewForum = AddElementTag(forumSource, "REVIEWFORUM");
                        AddAttribute(reviewForum, "ID", reviewForumID);
                        AddTextTag(reviewForum, "REVIEWFORUMNAME", subject);
                        AddTextTag(reviewForum, "URLFRIENDLYNAME", "RF" + reviewForumID.ToString());
                    }
                    else if (type == 1)
                    {
                        AddAttribute(forumSource, "TYPE", "article");
                    }
                    /*else if (type == 5)
                    {
                        AddAttribute(forumSource, "TYPE", "club");

                        XmlElement club = AddElementTag(forumSource, "CLUB");
                        AddAttribute(club, "ID", clubID);
                        AddTextTag(club, "NAME", subject);
                    }
                    else if (type == 6)
                    {
                        AddAttribute(forumSource, "TYPE", "clubforum");

                        XmlElement club = AddElementTag(forumSource, "CLUB");
                        AddAttribute(club, "ID", clubID);
                        AddTextTag(club, "NAME", subject);
                    }
                    else if (type == 7)
                    {
                        AddAttribute(forumSource, "TYPE", "clubjournal");

                        XmlElement club = AddElementTag(forumSource, "CLUB");
                        AddAttribute(club, "ID", clubID);
                        AddTextTag(club, "NAME", subject);
                    }*/
                    else if (type == 4)
                    {
                        AddAttribute(forumSource, "TYPE", "privateuser");
                        XmlElement userPage = AddElementTag(forumSource, "USERPAGE");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userID, userPage);
                    }
                    else if (type == 8)
                    {
                        AddAttribute(forumSource, "TYPE", "noticeboard");
                    }
                    else
                    {
                        AddAttribute(forumSource, "TYPE", "userpage");
                        XmlElement userPage = AddElementTag(forumSource, "USERPAGE");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userID, userPage);
                    }

                    if (ID > 0)
                    {
                        if (includeArticle)
                        {
                            GuideEntrySetup guideEntrySetup = new GuideEntrySetup(ID);
                            guideEntrySetup.ShowEntryData = true;
                            guideEntrySetup.ShowPageAuthors = true;
                            guideEntrySetup.ShowReferences = true;
                            guideEntrySetup.SafeToCache = true;

                            GuideEntry guideEntry = new GuideEntry(InputContext, guideEntrySetup);
                            if (!guideEntry.Initialise())
                            {
                                throw new DnaException("The article doesn't exist. " + ID.ToString());
                            }

                            if (!guideEntry.IsDeleted)
                            {
                                AddInside(guideEntry, "FORUMSOURCE");
                                XmlElement article = (XmlElement)forumSource.SelectSingleNode("ARTICLE");
                                AddIntElement(article, "H2G2ID", ID);
                            }
                            else
                            {
                                XmlElement deletedArticle = AddElementTag(forumSource, "ARTICLE");
                                AddIntElement(deletedArticle, "H2G2ID", ID);
                                AddTextTag(deletedArticle, "SUBJECT", "Deleted");
                                AddIntElement(deletedArticle, "HIDDEN", hiddenStatus);
                                XmlNode statusNode = AddTextTag(deletedArticle, "STATUS", GuideEntry.GetDescriptionForStatusValue(articleStatus));
                                AddAttribute(statusNode, "TYPE", articleStatus);
                            }
                        }
                        else
                        {
                            XmlElement defaultArticle = AddElementTag(forumSource, "ARTICLE");
                            AddIntElement(defaultArticle, "H2G2ID", ID);
                            AddTextTag(defaultArticle, "SUBJECT", subject);
                            AddIntElement(defaultArticle, "HIDDEN", hiddenStatus);
                            XmlNode statusNode = AddTextTag(defaultArticle, "STATUS", GuideEntry.GetDescriptionForStatusValue(articleStatus));
                            AddAttribute(statusNode, "TYPE", articleStatus);
                        }

                        AddIntElement(forumSource, "ALERTINSTANTLY", alertInstantly);
                    }
                }
            }
        }

        /// <summary>
        /// posts a new entry to the user's journal
        /// </summary>
        /// <param name="userID">ID of user posting</param>
        /// <param name="journalID">Forum ID of the user's journal</param>
        /// <param name="userName">username (not used, I think)</param>
        /// <param name="subject">Subject line of posting</param>
        /// <param name="body">body of journal posting</param>
        /// <param name="siteID"></param>
        /// <param name="postStyle"></param>
        /// <param name="profanityFound">if profanites are found</param>
        /// <param name="nonAllowedURLsFound">if non allowed urls are found</param>
        /// <param name="emailAddressFound">Indicates an email address was found.</param>
        public void PostToJournal(int userID, int journalID, string userName, string subject, string body, int siteID, int postStyle, ref bool profanityFound, ref bool nonAllowedURLsFound, ref bool emailAddressFound)
        {
            string textToCheck = subject + " " + body;

            string matchedProfanity = String.Empty;

            bool forceModerate = false;
            profanityFound = false;
            nonAllowedURLsFound = false;
            emailAddressFound = false;

            ProfanityFilter.FilterState filterState = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, textToCheck, out matchedProfanity);

            if (filterState == ProfanityFilter.FilterState.FailBlock)
            {
                //represent the submission first time only
                //need to keep track of this
                profanityFound = true;
                //return immediately - these don't get submitted
                return;
            }
            else if (filterState == ProfanityFilter.FilterState.FailRefer)
            {
                forceModerate = true;
                profanityFound = true;
            }

            if (InputContext.GetSiteOptionValueBool("General", "IsURLFiltered") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
            {
                URLFilter URLFilter = new URLFilter(InputContext);
                List<string> nonAllowedURLs = new List<string>();
                URLFilter.FilterState URLFilterState = URLFilter.CheckForURLs(textToCheck, nonAllowedURLs);
                if (URLFilterState == URLFilter.FilterState.Fail)
                {
                    nonAllowedURLsFound = true;
                    //return immediately - these don't get submitted
                    return;
                }
            }

            //Filter for email addresses.
            if (InputContext.GetSiteOptionValueBool("Forum", "EmailAddressFilter") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
            {
                if (EmailAddressFilter.CheckForEmailAddresses(textToCheck))
                {
                    emailAddressFound = true;
                    //return immediately - these don't get submitted
                    return;
                }
            }

            //SuperUsers / Editors are not moderated.
            bool ignoreModeration = false;
            if (InputContext.ViewingUser.UserLoggedIn && (InputContext.ViewingUser.IsSuperUser || InputContext.ViewingUser.IsEditor))
            {
                ignoreModeration = true;
            }

            string hash = String.Empty;
            string hashString = subject + "<:>" + body + "<:>" + userID + "<:>" + journalID + "<:>" + postStyle + "<:>ToJournal";

            // Setup the stored procedure object
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("posttojournal"))
            {
                reader.AddParameter("userID", userID);
                reader.AddParameter("journal", journalID);
                reader.AddParameter("subject", subject);
                reader.AddParameter("nickname", userName);
                reader.AddParameter("content", body);
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("poststyle", postStyle);
                reader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));
                reader.AddParameter("forcemoderation", forceModerate);
                reader.AddParameter("ignoremoderation", ignoreModeration);
                reader.AddParameter("ipaddress", InputContext.IpAddress);
                reader.AddParameter("bbcuid", InputContext.BBCUid);
                // Now call the procedure
                reader.Execute();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="postId"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="hide"></param>
        /// <param name="ignoreModeration"></param>
        public void EditPost( int userId, int postId, String subject, String body, bool hide, bool ignoreModeration)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatepostdetails"))
            {
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("subject", subject);
                dataReader.AddParameter("text", body);
                dataReader.AddParameter("setlastupdated", true);
                dataReader.AddParameter("forcemoderateandhide", hide);
                dataReader.AddParameter("ignoremoderation", ignoreModeration);

                dataReader.Execute();
            }

        }

        /// <summary>
        /// Prepares all the pre-requisites for a post.
        /// </summary>
        /// <param name="userId"> Post using the specified user.</param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="replyTo"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="postStyle">Th estyle of the post</param>
        /// <param name="ignoreModeration"> Allow automated posts.</param>
        /// <param name="postId"> New postId</param>
        /// <param name="isQueued"> Indicates whether post was Queued</param>
        /// <param name="isPreModPosting"></param>
        /// <param name="isPreModerated"></param>
        public void PostToForum(int userId, int forumId, ref int threadId, int replyTo, String subject, String body, int postStyle, bool ignoreModeration, out int postId, out bool isQueued, out bool isPreModPosting, out bool isPreModerated)
        {
            bool forcePreModerate = false;
            bool forceModeration = false;
            bool isNotable = InputContext.ViewingUser.IsNotable;
            String ipAddress = InputContext.IpAddress;
            Guid bbcUID = InputContext.BBCUid;
            bool allowQueuing = true;

            String source = subject + "<:>" + body + "<:>" + Convert.ToString(userId) + "<:>" +  Convert.ToString(forumId) + "<:>" + Convert.ToString(threadId) + "<:>" + Convert.ToString(replyTo);
            Guid hash = DnaHasher.GenerateHash(source);

            PostToForum(userId, forumId, ref threadId, replyTo, subject, body, postStyle, hash, forcePreModerate, forceModeration, ignoreModeration, ipAddress, bbcUID, allowQueuing, isNotable, out postId, out isQueued, out isPreModPosting, out isPreModerated);

        }

        /// <summary>
        /// A barebones PostToForum Method.
        /// </summary>
        private void PostToForum(int userId, int forumId, ref int threadId, int replyTo, String subject, String body, int postStyle, Guid hash, bool forcePreModerate, bool forceModerate, bool ignoreModeration, String ipAddress, Guid bbcUID, bool allowQueuing, bool isNotable, out int postId, out bool isQueued, out bool isPreModPosting, out bool isPreModerated  )
        {
            postId = 0;
            isPreModPosting = false;
            isPreModerated = false;
            isQueued = false;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("posttoforum"))
            {
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("forumid", forumId);
                dataReader.AddParameter("inreplyto", replyTo);
                dataReader.AddParameter("threadid", threadId);
                dataReader.AddParameter("subject", subject);
                dataReader.AddParameter("content", body);
                dataReader.AddParameter("poststyle", postStyle);
                dataReader.AddParameter("hash", hash);
                dataReader.AddParameter("forcemoderate", forceModerate);
                dataReader.AddParameter("forcepremoderation", forcePreModerate);
                dataReader.AddParameter("ignoremoderation", ignoreModeration );
                dataReader.AddParameter("ipaddress", ipAddress);
                dataReader.AddParameter("bbcuid", bbcUID);
                dataReader.AddParameter("allowqueuing", allowQueuing);
                dataReader.AddParameter("isnotable", isNotable);
                dataReader.AddParameter("iscomment", false);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    postId = dataReader.GetInt32NullAsZero("postid");
                    threadId = dataReader.GetInt32NullAsZero("threadid");
                    isPreModPosting = dataReader.GetBoolean("ispremodposting");
                    isPreModerated = dataReader.GetBoolean("ispremoderated");
                    isQueued = dataReader.GetBoolean("wasqueued");
                }
            }
        }
    }
}
