using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Component
{
    class PostList : DnaInputComponent
    {

        /// <summary>
        /// Default Constructor for the PostList object
        /// </summary>
        public PostList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Functions generates the Recent Posts List
        /// </summary>
        /// <param name="userID">The user of the posts to get</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="postType">Type of posts to look for</param>
        /// <param name="siteID">Site of the posts</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRecentPostsList(int userID, int skip, int show, int postType, int siteID)
        {
	        //TDVASSERT(userID > 0, "CreateRecentPostsList(...) called with non-positive ID");
	        //TDVASSERT(iMaxNumber > 0, "CreateRecentPostsList(...) called with non-positive max number of posts");
        	
	        // check object is not already initialised
	        if (userID <= 0 || show <= 0)
	        {
		        return false;
	        }

	        bool showPrivate = false;
            if (InputContext.ViewingUser != null && (userID == InputContext.ViewingUser.UserID || InputContext.ViewingUser.IsEditor))
	        {
		        showPrivate = true;
	        }

	        //Allow post authors to see their user-deleted notices and events.
	        bool showUserHidden = showPrivate && (postType == 1 || postType == 2);
            int count = 0;
            int rows = 0;

            XmlElement postList = AddElementTag(RootElement, "POST-LIST");
            AddAttribute(postList, "SHOW", show);
            AddAttribute(postList, "SKIPTO", skip);
            //AddAttribute(postList, "COUNT", show);

            using (IDnaDataReader dataReader = GetUsersMostRecentPosts(userID, skip, show, postType, siteID, showUserHidden))
            {         
		        // Check to see if we found anything
		        string userName = String.Empty;
		        if (dataReader.HasRows && dataReader.Read())
		        {
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, userID, postList);
       		
                    string threadPostType = String.Empty;
                    string threadSubject = String.Empty;
		            ArrayList noticeThreadIDArray = new ArrayList();
		            int threadID = 0;
		            int postSiteID = 0;		
		            int IsPostingFromVisibleSite = 0;

                    if (skip > 0)
                    {
                        //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                        //the one required
                        for (int i = 0; i < skip; i++)
                        {
                            dataReader.Read();
                        }
                    }
                    //TODO think i will need to check if the reads fail above ie you skip past the end
		            Forum Forum = new Forum(InputContext);

		            do
		            {
			            IsPostingFromVisibleSite = dataReader.GetInt32NullAsZero("IsPostingFromVisibleSite"); 
			            if (IsPostingFromVisibleSite == 1)
			            {
 				            // Setup the Post Tag and Attributes
                            XmlElement post = CreateElement("POST");

				            AddAttribute(post, "COUNTPOSTS", dataReader.GetInt32NullAsZero("CountPosts"));

				            if (showPrivate)
				            {
                                AddAttribute(post, "LASTPOSTCOUNTREAD", dataReader.GetInt32NullAsZero("LastPostCountRead"));
				            }

				            // Add User-Hidden Status.
				            if ( showUserHidden && dataReader.DoesFieldExist("Hidden") && dataReader.GetInt32NullAsZero("Hidden") > 0 )
                            {
                                AddAttribute(post, "HIDDEN", dataReader.GetInt32NullAsZero("HIDDEN"));
				            }

				            int yourLastPost = dataReader.GetInt32NullAsZero("YourLastPost");			
            		
				            //add the editable attribute
                            if (InputContext.ViewingUser != null)
				            {
					            int editable = 0;
                                if (InputContext.ViewingUser.UserID != userID)
					            {
						            editable = 0;
					            }
					            else
					            {
						            if (yourLastPost > 0 )
						            {
							            DateTime dateMostRecent = dataReader.GetDateTime("MostRecent");		
                                        editable = Forum.GetPostEditableAttribute(userID, dateMostRecent);
						            }
						            else
						            {
							            editable = 0;
						            }
					            }
                                AddAttribute(post, "EDITABLE", editable);
				            }

                            AddAttribute(post, "PRIVATE", dataReader.GetInt32NullAsZero("Private"));

				            // Add the siteid and reply details
                            postSiteID = dataReader.GetInt32NullAsZero("SiteID");
                            AddIntElement(post, "SITEID", postSiteID);
                            AddIntElement(post, "HAS-REPLY", dataReader.GetInt32NullAsZero("Replies"));


				            // Setup a Thread Tag and Attributes
                            XmlElement thread = CreateElement("Thread");
                            AddAttribute(thread, "FORUMID", dataReader.GetInt32NullAsZero("ForumID"));
                           
                            threadID = dataReader.GetInt32NullAsZero("ThreadID");
                            AddAttribute(thread, "THREADID", threadID);

				            // Add the first post id if it exists in the result set
				            if (dataReader.DoesFieldExist("FirstPostID"))
				            {
                                AddAttribute(thread, "FIRSTPOSTID", dataReader.GetInt32NullAsZero("FirstPostID"));
				            }

                            threadPostType = dataReader.GetStringNullAsEmpty("Type");
                            AddAttribute(thread, "TYPE", threadPostType);

                            AddDateXml(dataReader, thread, "EVENTDATE", "EventDate");
                            AddDateXml(dataReader, thread, "DATEFIRSTPOSTED", "DateFirstPosted");

				            // See if we've got an notice or event, if so then get the taginfo for the post
                            if (threadPostType == "notice" || threadPostType == "event")
				            {
					            // Add the threadid to the array so we can get the tag details later
					            noticeThreadIDArray.Add(threadID);
				            }

				            // Add the Subject 
                            threadSubject = ThreadPost.FormatSubject(dataReader.GetStringNullAsEmpty("FirstSubject"), CommentStatus.Hidden.NotHidden);
                            AddTextTag(thread, "SUBJECT", threadSubject);
                            
                            AddDateXml(dataReader, thread, "LastReply", "REPLYDATE");

				            // If we have a journal user then put the following in...
				            if (dataReader.GetInt32NullAsZero("Journal") > 0)
				            {
                                XmlElement journal = CreateElement("JOURNAL");
                                AddAttribute(journal, "USERID", dataReader.GetInt32NullAsZero("Journal"));

                                AddTextTag(journal, "UserName", dataReader.GetStringNullAsEmpty("JournalName"));
                                AddTextTag(journal, "Area", dataReader.GetStringNullAsEmpty("JournalArea"));
                                AddTextTag(journal, "FirstNames", dataReader.GetStringNullAsEmpty("JournalFirstNames"));
                                AddTextTag(journal, "LastName", dataReader.GetStringNullAsEmpty("JournalLastName"));
                                AddTextTag(journal, "Title", dataReader.GetStringNullAsEmpty("JournalTitle"));
                                AddTextTag(journal, "SiteSuffix", dataReader.GetStringNullAsEmpty("JournalSiteSuffix"));

                                thread.AppendChild(journal);
				            }

				            // Get the ForumInfo and Last post details
                            //AddTextTag(thread, "ForumTitle", dataReader.GetStringNullAsEmpty("ForumTitle"));
                            string forumTitle = dataReader.GetStringNullAsEmpty("ForumTitle");
                            XmlElement forumTitleElement = AddTextElement(thread, "ForumTitle", "");
                            try
                            {
                                forumTitleElement.InnerXml = forumTitle;
                            }
                            catch (System.Xml.XmlException ex)
                            {
                                AppContext.TheAppContext.Diagnostics.WriteWarningToLog("PostList", "Escaping character in Forum Title" + ex.Message);
                                forumTitleElement.InnerXml = StringUtils.EscapeAllXml(forumTitle);
                            }

                            if (yourLastPost > 0)
				            {
                                XmlElement lastUserPost = CreateElement("LASTUSERPOST");
                                AddAttribute(lastUserPost, "POSTID", yourLastPost );
                                AddDateXml(dataReader, lastUserPost, "MostRecent", "DATEPOSTED");
                                thread.AppendChild(lastUserPost);
				            }

				            // Close the ThreadTag
                            post.AppendChild(thread);

				            // Add the first poster info
				            int firstPostUserID = 0;
                            XmlElement firstPoster = CreateElement("FIRSTPOSTER");
                            firstPostUserID = dataReader.GetInt32NullAsZero("FirstPosterUserID");
                            user.AddPrefixedUserXMLBlock(dataReader, firstPostUserID, "FirstPoster", firstPoster);
                            post.AppendChild(firstPoster);

				            // Finally close the POST tag
                            postList.AppendChild(post);
                            count++;
			            }
                        rows++;
                    } while (rows < show && dataReader.Read());
                    if (dataReader.Read())
                    {
                        AddAttribute(postList, "MORE", 1);
                    }

		            // Now insert the tag info for any notices or events found
		            if (noticeThreadIDArray.Count > 0)
		            {
			            // Set up some locals
			            string taggedNodeInfo;
			            int noticeThreadID = 0;
			            TagItem tagItem = new TagItem(InputContext);

			            // Now go through the list adding the taginfo into the XML
			            for (int i = 0; i < noticeThreadIDArray.Count; i++)
			            {
				            // Get the ThreadId for the current Index
				            noticeThreadID = (int) noticeThreadIDArray[i];
				            taggedNodeInfo = String.Empty;

				            // Get the Tagging locations!
				            if (tagItem.InitialiseFromThreadId(noticeThreadID, siteID, userID, threadSubject, false) && tagItem.GetAllNodesTaggedForItem())
				            {
					            // Get the taginfo from the tagitem object and insert it into the page
					            //tagItem.GetAsString(taggedNodeInfo);
					            //AddInsideWhereIntAttributeEquals("THREAD", "THREADID", noticeThreadID, taggedNodeInfo, 1);

                                string xpath = "/THREAD[@THREADID=" + noticeThreadID.ToString() + "]";
                                XmlNodeList threads = postList.SelectNodes(xpath);
                                if (threads.Count > 0)
                                {
                                    foreach (XmlNode thread in threads)
                                    {
                                        SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
                                        thread.AppendChild(ImportNode(siteXml.GenerateAllSitesXml(InputContext.TheSiteList).FirstChild));
                                    }
                                }
				            }
				            else
				            {
					            // Setup an error for this post!
					            throw new DnaException("CreateRecentPostsList : FailedToGetTagInfo - Failed to get Tagging Info for post");
				            }
			            }
		            }
                }
            }
            AddAttribute(postList, "COUNT", count);

	        RemovePrivatePosts(showPrivate);

	        return true;
        }

        /// <summary>
        /// Removes the Private posts from the list
        /// </summary>
        /// <param name="showPrivate">Whether to show the private posts</param>
        /// <returns></returns>
        void RemovePrivatePosts(bool showPrivate)
        {
            if (!showPrivate)
            {
                XmlNodeList postList = RootElement.SelectNodes("POST");
                foreach (XmlElement post in postList)
                {
                    if (post.GetAttribute("PRIVATE") == "1")
                    {
                        post.ParentNode.RemoveChild(post);
                    }
                }
            }
        }

        /// <summary>
        /// Marks all the posts as read
        /// </summary>
        /// <param name="userID">The user id</param>
        public void MarkAllRead(int userID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("markallthreadsread"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.Execute();
            }
        }

        /// <summary>
        /// Does the correct call to the database to get the most recent posts
        /// </summary>
        /// <param name="userID">The user id to look for</param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="postType">The types of posts</param>
        /// <param name="siteId"></param>
        /// <param name="showUserHidden"></param>
        /// <returns></returns>
        IDnaDataReader GetUsersMostRecentPosts(int userID, int skip, int show, int postType, int siteId, bool showUserHidden)
        {
            IDnaDataReader dataReader;

            // Check to see what type of post we're looking for!
            if (postType == 1)
            {
                // We want all the users notices
                dataReader = InputContext.CreateDnaDataReader("getallusernoticepostings");
                dataReader.AddParameter("showuserhidden", showUserHidden);
            }
            else if (postType == 2)
            {
                // We want all the users events
                dataReader = InputContext.CreateDnaDataReader("getallusereventpostings");
                dataReader.AddParameter("showuserhidden", showUserHidden);
            }
            /*else if (postType == 3) //New Comments
            {
                // We want all the users events
                dataReader = InputContext.CreateDnaDataReader("getallusercommentpostings");
                dataReader.AddParameter("showuserhidden", showUserHidden);
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show);
            }*/
            else
            {
                // Just get all the posts in order
                if (InputContext.IsCurrentSiteMessageboard)
                {
                    dataReader = InputContext.CreateDnaDataReader("getalluserpostingstatsbasic");
                }
                else
                {
                    dataReader = InputContext.CreateDnaDataReader("getalluserpostingstats3");
                }
                //+1 for MORE is done in the SP
                dataReader.AddParameter("maxresults", skip + show);
            }

            dataReader.AddParameter("siteid", siteId);
            dataReader.AddParameter("userid", userID);

            dataReader.Execute();

            return dataReader;
        }
    }
}
