using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.DNA.Moderation.Utils;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Class to store the ReviewSubmissionForum Details
    /// </summary>
    public class ReviewSubmissionForum : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the ReviewSubmissionForum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ReviewSubmissionForum(IInputContext context)
            : base(context)
        {
        }
        /// <summary>
        /// Given the id, generates an xmlobject that contains information
		///		about valid forums that it can go into.
        /// </summary>
        /// <param name="H2G2ID">Id of article that we want to submit</param>
        /// <param name="siteID">SiteID that it came from</param>
        /// <param name="submitterComments">text that is in the form - leave empty if no text</param>
        /// <param name="selectedReviewForumID">the reviewForum that should be selected</param>
        public void RequestSubmitArticle(int H2G2ID, int siteID, string submitterComments, int selectedReviewForumID)
        {
            XmlElement submitReviewForum = AddElementTag(RootElement, "SUBMIT-REVIEW-FORUM");
            string subjectName = String.Empty;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getsubjectfromh2g2id"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    subjectName = dataReader.GetStringNullAsEmpty("Subject");
                }
                else
                {
                    AddGracefulErrorXml("NO-ARTICLE", "The entry doesn't exist", "FRONTPAGE", "Back to the frontpage", submitReviewForum);
                    return;
                }
            }
            int reviewForumID = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("isarticleinreviewforum"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                }
            }
            if (reviewForumID == 0)
            {
                string aNumber = "A" + H2G2ID.ToString();
                AddGracefulErrorXml("IN_FORUM", "The entry is already in a Review Forum", aNumber, aNumber, submitReviewForum);
                return;
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getreviewforums"))
            {
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    XmlElement article = AddTextTag(submitReviewForum, "ARTICLE", subjectName);
                    AddAttribute(article, "H2G2ID", H2G2ID);
                    XmlElement reviewForums = AddElementTag(article, "REVIEWFORUMS");
                    do
                    {
                        string reviewForumName = dataReader.GetStringNullAsEmpty("ForumName");
                        reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                        XmlElement forumName = AddTextTag(reviewForums, "FORUMNAME", reviewForumName);
                        AddAttribute(forumName, "ID", reviewForumID);
                        if (reviewForumID == selectedReviewForumID)
                        {
                            AddAttribute(forumName, "SELECTED", "selected");
                        }

                    } while (dataReader.Read());

                    if (submitterComments != String.Empty)
                    {
                        AddTextTag(reviewForums, "COMMENTS", submitterComments);
                    }
                    else
                    {
                        AddErrorXml("NO-COMMENT", "Please enter your comments in the text box", reviewForums);
                    }
                }
                else
                {
                    string aNumber = "A" + H2G2ID.ToString();
                    AddGracefulErrorXml("NO_FORUM", "There are no review forums for this site", aNumber, "Back to article");
                    return; 
                }
            }
        }

        /// <summary>
        /// Submits an article to a review forum
        /// </summary>
        /// <param name="user"></param>
        /// <param name="H2G2ID"></param>
        /// <param name="siteID"></param>
        /// <param name="response"></param>
        /// <param name="reviewForumID"></param>
        public void SubmitArticle(IUser user, int H2G2ID, int siteID, string response, int reviewForumID)
        {
            XmlElement submitReviewForum = AddElementTag(RootElement, "SUBMIT-REVIEW-FORUM");
            if (user.UserID == 0)
            {
                AddGracefulErrorXml("NO_USERID", "You have not logged in!", "Login", "Login", submitReviewForum);
            }

            if (response == String.Empty)
            {
                AddErrorXml("NO_COMMENT", "There should be comments with this click back to back", submitReviewForum);
            }

            GuideEntrySetup guideSetup = new GuideEntrySetup(H2G2ID);
            guideSetup.ShowEntryData = true;
            guideSetup.ShowPageAuthors = true;
            guideSetup.ShowReferences = false;

            GuideEntry guideEntry = new GuideEntry(InputContext, guideSetup);
            guideEntry.Initialise();

            if (guideEntry.IsSubmittable && !user.IsEditor)
            {
                AddGracefulErrorXml("NO_SUBMIT", "This article is not for review", "FRONTPAGE", "Back to frontpage", submitReviewForum);
            }

            string subjectName = String.Empty;
            XmlElement subjectNameElement = (XmlElement) guideEntry.RootElement.SelectSingleNode("ARTICLE/SUBJECT");
            if (subjectNameElement != null)
            {
                subjectName = subjectNameElement.InnerText;
            }
            int editorID = 0;
            XmlElement editorIDElement = (XmlElement)guideEntry.RootElement.SelectSingleNode("PAGEAUTHOR/EDITOR/USERID");
            if (editorIDElement != null)
            {
                Int32.TryParse(editorIDElement.InnerText, out editorID);
            }

            string subject = "A" + H2G2ID.ToString() + " - " + subjectName;
            string aNumber = "A" + H2G2ID.ToString();

            User editor = new User(InputContext);
            editor.CreateUser(editorID);

            string editedComments = "Entry: " + subjectName + " - A" + H2G2ID + "\n";
            editedComments += "Author: " + editor.UserName + " - U" + editorID + "\n\n";
            editedComments += response;

            string hash = String.Empty;
            string hashString = subject + "<:>" + editedComments + "<:>" + user.UserID + "<:>0<:>0<:>0<:>ToReviewForum";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("addarticletoreviewforummembers"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.AddParameter("reviewforumid", reviewForumID);
                dataReader.AddParameter("submitterid", user.UserID);
                dataReader.AddParameter("subject", subject);
                dataReader.AddParameter("content", editedComments);
                dataReader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));

                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    XmlElement article = AddTextTag(submitReviewForum, "ARTICLE", subjectName);
                    AddAttribute(article, "H2G2ID", H2G2ID);
                    XmlElement newThread = AddElementTag(submitReviewForum, "NEW-THREAD");
                    AddAttribute(newThread, "postid", dataReader.GetInt32NullAsZero("PostID"));
                    AddAttribute(newThread, "threadid", dataReader.GetInt32NullAsZero("ThreadID"));
                    AddAttribute(newThread, "forumid", dataReader.GetInt32NullAsZero("ForumID"));

                    ReviewForum reviewForum = new ReviewForum(InputContext);
                    reviewForum.InitialiseViaReviewForumID(reviewForumID, false);
                    AddInside(newThread, reviewForum);
                }
            }
        }
        /// <summary>
        /// Creates the form and adds the no comment error message
        /// </summary>
        /// <param name="H2G2ID"></param>
        /// <param name="siteID"></param>
        /// <param name="reviewForumID"></param>
        public void SubmittedWithEmptyComments(int H2G2ID, int siteID, int reviewForumID)
        {
            RequestSubmitArticle(H2G2ID, siteID, String.Empty, reviewForumID);
        }

        /// <summary>
        /// Remove the thread from the Forum
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="rFID"></param>
        /// <param name="H2G2ID"></param>
        /// <param name="threadID"></param>
        /// <param name="forumID"></param>
        /// <param name="hasPermission"></param>
        public void RemoveThreadFromForum(int userID, int rFID, int H2G2ID, ref int threadID, ref int forumID, bool hasPermission)
        {
            XmlElement submitReviewForum = AddElementTag(RootElement, "SUBMIT-REVIEW-FORUM");
            if (rFID <= 0 || H2G2ID <= 0)
            {
                AddErrorXml("RMBADID", "Bad arguments for this action", submitReviewForum);
                return;
            }

            //Initialise the article
            GuideEntrySetup guideSetup = new GuideEntrySetup(H2G2ID);
            guideSetup.ShowEntryData = true;
            guideSetup.ShowPageAuthors = false;
            guideSetup.ShowReferences = false;

            GuideEntry guideEntry = new GuideEntry(InputContext, guideSetup);
            guideEntry.Initialise();

            int postID = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchreviewforummemberdetails"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int submitterID = dataReader.GetInt32NullAsZero("SubmitterID");
                    postID = dataReader.GetInt32NullAsZero("PostID");
                    threadID = dataReader.GetInt32NullAsZero("ThreadID");
                    forumID = dataReader.GetInt32NullAsZero("ForumID");
                    int actualReviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");

	                //make sure that we are in the right review forum for the article
                    if (rFID != actualReviewForumID)
                    {
                        AddErrorXml("BADRFID", "The article is in a different review forum.", submitReviewForum);
                        return;
                    }

                	//Permission has been verified by the caller so don't check
                    if (!hasPermission)
                    {
 		                //ok if you're an editor
                        if (!InputContext.ViewingUser.IsEditor)
                        {
                            //ok if you are the author
                            if (!(guideEntry.AuthorsUserID == InputContext.ViewingUser.UserID))
                            {
                                //ok if you are the submitter
                                if (!(InputContext.ViewingUser.UserID == submitterID))
                                {
                                    AddErrorXml("BADUSER", "You do not have permission to move the thread", submitReviewForum);
                                }
                            }
                        }
                   }
                }
                else
                {
                    AddErrorXml("BADH2G2ID", "The article is not in a review forum.", submitReviewForum);
                    return;
                }
            }

            ReviewForum reviewForum = new ReviewForum(InputContext);
            reviewForum.InitialiseViaReviewForumID(rFID, false);
            if (!reviewForum.IsInitialised)
            {
                AddErrorXml("NOREVIEW", "Invalid Review Forum ID", submitReviewForum);
                return;
            }

            bool movedThread = false;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("MoveThread2"))
            {
                dataReader.AddParameter("ThreadID", threadID);
                dataReader.AddParameter("ForumID", guideEntry.ForumID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    movedThread = dataReader.GetBoolean("Success");
                }
            }
            if(!movedThread)
            {
                AddErrorXml("NOMOVE", "Failed to move thread to article", submitReviewForum);
                return;
            }

            int removedFromPeerReview = 0;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("removearticlefrompeerreview"))
            {
                dataReader.AddParameter("H2G2ID", H2G2ID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    removedFromPeerReview = dataReader.GetInt32NullAsZero("Success");
                }
            }

            bool undoneThread = false;
            if (removedFromPeerReview == 0)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("UndoThreadMove"))
                {
                    dataReader.AddParameter("ThreadID", threadID);
                    dataReader.AddParameter("PostID", 0);
                    dataReader.Execute();
                    // Check to see if we found anything
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        undoneThread = dataReader.GetBoolean("Success");
                    }
                }
                if (!undoneThread)
                {
                    AddErrorXml("HALFMOVE", "The thread has been moved, but not from review", submitReviewForum);
                    return;
                }
                else
                {
                    AddErrorXml("NOMOVE", "Failed to move thread to article", submitReviewForum);
                    return;
                }
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("ForceUpdateEntry"))
            {
                dataReader.AddParameter("H2G2ID", H2G2ID);
                dataReader.Execute();
            }

            string postSubject = String.Empty;
            string postText = String.Empty;
            string newSubject = String.Empty;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchPostDetails"))
            {
                dataReader.AddParameter("PostID", postID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    postSubject = dataReader.GetStringNullAsEmpty("Subject");
                    postText = dataReader.GetStringNullAsEmpty("Text");

                    newSubject = reviewForum.ReviewForumName + ": " + postSubject;
                }
            }
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("UpdatePostDetails"))
            {
                dataReader.AddParameter("UserID", 0);
                dataReader.AddParameter("PostID", postID);
                dataReader.AddParameter("Subject", newSubject);
                dataReader.AddParameter("Text", postText);
                dataReader.AddParameter("SetLastUpdated", false);
                dataReader.AddParameter("ForceModerateAndHide", false);
                dataReader.AddParameter("IgnoreModeration", true);
                dataReader.Execute();
            }
            //update the thread first subject details
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatethreadfirstsubject"))
            {
                dataReader.AddParameter("ThreadID", threadID);
                dataReader.AddParameter("firstsubject", newSubject);
                dataReader.Execute();
            }
            //post the success story
            XmlElement movedThreadXml = AddElementTag(submitReviewForum, "MOVEDTHREAD");
            AddIntElement(movedThreadXml, "H2G2ID", H2G2ID);
            AddTextTag(movedThreadXml, "SUBJECT", guideEntry.Subject);
            XmlElement reviewForumXml = AddElementTag(movedThreadXml, "REVIEWFORUM");
            AddAttribute(reviewForumXml, "ID", rFID);
            AddTextTag(reviewForumXml, "REVIEWFORUMNAME", reviewForum.ReviewForumName);
            AddTextTag(reviewForumXml, "URLFRIENDLYNAME", reviewForum.UrlFriendlyName);

        }

        /// <summary>
        /// Helper function to format Error Xml.
        /// </summary>
        /// <param name="errortype">A categorisation of error</param>
        /// <param name="errormessage">Error description.</param>
        /// <param name="linkHREF">link HREF</param>
        /// <param name="linkBody">link description.</param>
        public void AddGracefulErrorXml(string errortype, string errormessage, string linkHREF, string linkBody)
        {
            AddGracefulErrorXml(errortype, errormessage, linkHREF, linkBody, RootElement);
        }

        /// <summary>
        /// Helper function to format Error Xml.
        /// </summary>
        /// <param name="errortype">A categorisation of error</param>
        /// <param name="errormessage">Error description.</param>
        /// <param name="linkHREF">link HREF</param>
        /// <param name="linkBody">link description.</param>
        /// <param name="parent">Optional node to insert error into.</param>
        public void AddGracefulErrorXml(string errortype, string errormessage, string linkHREF, string linkBody, XmlNode parent)
        {
            XmlNode error = CreateElementNode("ERROR");
            AddAttribute(error, "TYPE", errortype);
            AddTextTag(error, "ERRORMESSAGE", errormessage);
            XmlNode link = AddTextTag(error, "LINK", linkBody);
            AddAttribute(link, "HREF", linkHREF);

            parent.AppendChild(error);
        }


        /// <summary>
        /// Posts a message to the editor of an article that it has been submitted to a review forum
        /// </summary>
        /// <param name="submitterID"></param>
        /// <param name="editorID"></param>
        /// <param name="userName"></param>
        /// <param name="H2G2ID"></param>
        /// <param name="siteID"></param>
        /// <param name="reviewForumID"></param>
        /// <param name="forumID"></param>
        /// <param name="threadID"></param>
        /// <param name="postID"></param>
        /// <param name="subject"></param>
        /// <param name="comments"></param>
        public void NotifyAuthorOnPersonalSpace(int submitterID, int editorID, string userName, int H2G2ID,
                                            int siteID, int reviewForumID, int forumID, int threadID, int postID, 
                                            string subject, string comments)
        {	        
            XmlElement submitReviewForum = AddElementTag(RootElement, "SUBMIT-REVIEW-FORUM");
	        int userForumID = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchpersonalspaceforum"))
            {
                dataReader.AddParameter("userid", editorID);
                dataReader.AddParameter("siteid", siteID);

                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    userForumID = dataReader.GetInt32NullAsZero("ForumID");
                }
            }
            if (userForumID == 0)
            {
                throw new DnaException("No Personal Space Forum - Failed to send message to Personal Space");
            }

            if (submitterID == 0)
            {
                AddErrorXml("NO-USER","Failed to get User details", submitReviewForum);
            }
            
            User submitter = new User(InputContext);
            submitter.CreateUser(submitterID);                 

	        string submitterName = submitter.UserName; 

	        ReviewForum reviewForum = new ReviewForum(InputContext);
	        reviewForum.InitialiseViaReviewForumID(reviewForumID, false);

	        string generatedSubject = "Your entry has been submitted to '" +  reviewForum.ReviewForumName + "'";

	        string generatedBody = "Entry: " + subject + " - A" + H2G2ID + " \n";
	        generatedBody += "Author: " + userName + " - U" + editorID + " \n";
	        generatedBody += "Submitter: " + submitterName + " - U" + submitterID + "\n\n";

	        generatedBody += "This is an automated message.\n\n";

	        generatedBody += "Your entry above has been submitted to the Review Forum '" +  reviewForum.ReviewForumName + "'" 
				           + " by the Researcher named above. For more information about what happens next check out <./>ReviewForums-Next</.>.\n\n";
        	
	        generatedBody += "You can see the discussion about your entry at " + "F" + forumID + "?thread=" + threadID + "\n\n";

	        generatedBody += "If you'd rather your entry wasn't in this Review Forum then you can remove it by visiting "
				           + "<./>" + reviewForum.UrlFriendlyName + "</.> and clicking on the relevant 'Remove' link."
				           + " To prevent it being put into a Review Forum in the future, please click on the 'Edit Entry' button and tick the 'Not for Review' box.\n\n";

	        if (forumID > 0)
	        {
		        // Check the user input for profanities!
		        //ProfanityFilter profanityFilter = new ProfanityFilter(InputContext);
                string matchingProfanity = String.Empty;
                List<Term> terms = null;
		        ProfanityFilter.FilterState filterState = ProfanityFilter.CheckForProfanities(InputContext.CurrentSite.ModClassID, generatedSubject + " " + generatedBody, out matchingProfanity, out terms, forumID);

		        bool forceModeration = false;
		        if (filterState == ProfanityFilter.FilterState.FailBlock)
		        {
					AddErrorXml("profanityblocked", matchingProfanity, submitReviewForum);
			        return;
		        }
		        else if (filterState == ProfanityFilter.FilterState.FailRefer)
		        {
			        forceModeration = true;
		        }

                if(InputContext.GetSiteOptionValueBool("General", "IsURLFiltered") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
	            {
		            URLFilter URLFilter = new URLFilter(InputContext);
                    List<string> nonAllowedURLs = new List<string>();
		            URLFilter.FilterState URLFilterState = URLFilter.CheckForURLs(generatedSubject + " " + generatedBody, nonAllowedURLs);
		            if (URLFilterState == URLFilter.FilterState.Fail)
		            {
			            //return immediately - these don't get submitted
					    AddErrorXml("nonAllowedURLsFound", "For example " + nonAllowedURLs[0], submitReviewForum);
			            return;
		            }
		        }
                //Filter for email addresses.
                if (InputContext.GetSiteOptionValueBool("Forum", "EmailAddressFilter") && !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsNotable))
                {
                    if (EmailAddressFilter.CheckForEmailAddresses(generatedSubject + " " + generatedBody))
                    {
                        //return immediately - these don't get submitted
                        AddErrorXml("EmailAddressFilter", "Email Address Found.", submitReviewForum);
                        return;
                    }
                }

                string hash = String.Empty;
                string hashString = generatedSubject + "<:>" + generatedBody + "<:>" + submitterID + "<:>" + userForumID + "<:>0";

                // Setup the stored procedure object
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("posttoforum"))
                {
                    reader.AddParameter("userID", submitterID);
                    reader.AddParameter("forumid", userForumID);
                    reader.AddParameter("inreplyto", DBNull.Value);
                    reader.AddParameter("threadid", DBNull.Value);
                    reader.AddParameter("subject", generatedSubject);
                    reader.AddParameter("content", generatedBody);
                    reader.AddParameter("poststyle", 2);
                    reader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));
                    reader.AddParameter("forcemoderation", forceModeration);
                    // Now call the procedure
                    reader.Execute();
                }
	        }
        }
    }
}