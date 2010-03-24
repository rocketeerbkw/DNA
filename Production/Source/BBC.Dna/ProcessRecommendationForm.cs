using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Globalization;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// ProcessRecommendationForm object
    /// </summary>
    public class ProcessRecommendationForm : DnaInputComponent
    {
        XmlElement _processRecommendationForm = null;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ProcessRecommendationForm(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Creates the XML for a blank process recommendation form.
        /// </summary>
        public void CreateBlankForm()
        {
            RootElement.RemoveAll();
            _processRecommendationForm = AddElementTag(RootElement, "PROCESS-RECOMMENDATION-FORM");
            XmlElement functions = AddElementTag(_processRecommendationForm, "FUNCTIONS");
            AddTextTag(functions, "FETCH", "");
        }

        /// <summary>
        /// Creates the decision form for this particular recommendation.
        /// </summary>
        /// <param name="user"></param>
        /// <param name="recommendationID"></param>
        /// <param name="comments"></param>
        /// <param name="acceptButton">should the accept button be present?</param>
        /// <param name="rejectButton">should the reject button be present?</param>
        /// <param name="cancelButton">should the cancel button be present?</param>
        /// <param name="fetchButton">should the fetch button be present?</param>
        public void CreateFromRecommendationID(IUser user, int recommendationID, string comments, bool acceptButton, bool rejectButton, bool cancelButton, bool fetchButton)
        {
            RootElement.RemoveAll();

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchRecommendationDetails"))
            {
                dataReader.AddParameter("RecommendationID", recommendationID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    CreateFormXml(dataReader, comments, acceptButton, rejectButton, cancelButton, fetchButton, true);
                }
            }
        }

        /// <summary>
        /// Creates the decision form for this particular recommendation.
        /// </summary>
        /// <param name="user"></param>
        /// <param name="entryID"></param>
        /// <param name="comments"></param>
        /// <param name="acceptButton">should the accept button be present?</param>
        /// <param name="rejectButton">should the reject button be present?</param>
        /// <param name="cancelButton">should the cancel button be present?</param>
        /// <param name="fetchButton">should the fetch button be present?</param>
        public void CreateFromEntryID(IUser user, int entryID, string comments, bool acceptButton, bool rejectButton, bool cancelButton, bool fetchButton)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchRecommendationDetailsFromEntryID"))
            {
                dataReader.AddParameter("EntryID", entryID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    CreateFormXml(dataReader, comments, acceptButton, rejectButton, cancelButton, fetchButton, false);
                }
                else
                {
                    // otherwise create a blank form with an error message
                    CreateBlankForm();
                    AddErrorXml("RECOMMENDATION-NOT-FOUND", "No recommendation for this Entry was found", _processRecommendationForm);
                }
            }
        }

        private void CreateFormXml(IDnaDataReader dataReader, string comments, bool acceptButton, bool rejectButton, bool cancelButton, bool fetchButton, bool byRecommendationID)
        {
            RootElement.RemoveAll();
            _processRecommendationForm = AddElementTag(RootElement, "PROCESS-RECOMMENDATION-FORM");

            int recommendationID = dataReader.GetInt32NullAsZero("recommendationID");
            int h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
            int entryID = dataReader.GetInt32NullAsZero("entryID");
            string entrySubject = dataReader.GetStringNullAsEmpty("Subject");

            int editorID = dataReader.GetInt32NullAsZero("EditorID");
            string editorName = dataReader.GetStringNullAsEmpty("EditorName");
            User editor = new User(InputContext);

            int scoutID = dataReader.GetInt32NullAsZero("ScoutID");
            string scoutName = dataReader.GetStringNullAsEmpty("ScoutName");
            User scout = new User(InputContext);

            DateTime dateRecommended = dataReader.GetDateTime("DateRecommended");
            string retrievedComments = dataReader.GetStringNullAsEmpty("Comments");

            AddIntElement(_processRecommendationForm, "RECOMMENDATION-ID", recommendationID);
            AddIntElement(_processRecommendationForm, "H2G2-ID", h2g2ID);
            AddTextTag(_processRecommendationForm, "SUBJECT", entrySubject);
            AddTextTag(_processRecommendationForm, "COMMENTS", retrievedComments);

            XmlElement editorElement = AddElementTag(_processRecommendationForm, "EDITOR");
            editor.AddPrefixedUserXMLBlock(dataReader, editorID, "editor", editorElement);

            XmlElement scoutElement = AddElementTag(_processRecommendationForm, "SCOUT");
            scout.AddPrefixedUserXMLBlock(dataReader, scoutID, "scout", scoutElement);

            AddDateXml(dateRecommended, _processRecommendationForm, "DATE-RECOMMENDED");

            // if we know what the decision is going to be then create an appropriate
            // default email to send
            string scoutEmailSubject = String.Empty;
            string scoutEmailText = String.Empty;
            string authorEmailSubject = String.Empty;
            string authorEmailText = String.Empty;

            if (acceptButton && !rejectButton)
            {
                CreateScoutAcceptanceEmail(scoutName, entrySubject, h2g2ID, dateRecommended, ref scoutEmailSubject, ref scoutEmailText);
                if (byRecommendationID)
                {
                    CreateAuthorAcceptanceEmail(editorName, entrySubject, h2g2ID, dateRecommended, ref authorEmailSubject, ref authorEmailText);
                }
            }
            else if (rejectButton && !acceptButton)
            {
                CreateScoutRejectionEmail(scoutName, entrySubject, h2g2ID, dateRecommended, ref scoutEmailSubject, ref scoutEmailText);
            }

            if (byRecommendationID)
            {
                XmlElement scoutEmail = AddElementTag(_processRecommendationForm, "SCOUT-EMAIL");
                AddTextTag(scoutEmail, "SUBJECT", scoutEmailSubject);
                AddTextTag(scoutEmail, "TEXT", scoutEmailText);

                XmlElement authorEmail = AddElementTag(_processRecommendationForm, "AUTHOR-EMAIL");
                AddTextTag(authorEmail, "SUBJECT", authorEmailSubject);
                AddTextTag(authorEmail, "TEXT", authorEmailText);
            }
            else
            {
                AddTextTag(_processRecommendationForm, "EMAIL-SUBJECT", scoutEmailSubject);
                AddTextTag(_processRecommendationForm, "EMAIL-TEXT", scoutEmailText);
            }

            XmlElement functions = AddElementTag(_processRecommendationForm, "FUNCTIONS");
            if (acceptButton)
            {
                AddElementTag(functions, "ACCEPT");
            }
            if (rejectButton)
            {
                AddElementTag(functions, "REJECT");
            }
            if (cancelButton)
            {
                AddElementTag(functions, "CANCEL");
            }
            if (fetchButton)
            {
                AddElementTag(functions, "FETCH");
            }
        }

        /// <summary>
        /// Builds the default personalised email message for this recommendation
		///		being rejected.
        /// </summary>
        /// <param name="scoutName">scouts username</param>
        /// <param name="entrySubject">subject of the entry recommended</param>
        /// <param name="h2g2ID">ID of the entry</param>
        /// <param name="dateRecommended">date that entry was recommended</param>
        /// <param name="scoutEmailSubject">the subject line for the email</param>
        /// <param name="scoutEmailText">the body of the email</param>
        private void CreateScoutRejectionEmail(string scoutName, string entrySubject, int h2g2ID, DateTime dateRecommended, ref string scoutEmailSubject, ref string scoutEmailText)
        {
            CreateEmail(scoutName, "scout", false, entrySubject, h2g2ID, dateRecommended, ref scoutEmailSubject, ref scoutEmailText);
        }
        /// <summary>
        /// Builds the default personalised email message to the author
		///		for this recommendation being accepted.
        /// </summary>
        /// <param name="authorName">authors username</param>
        /// <param name="entrySubject">subject of the entry recommended</param>
        /// <param name="h2g2ID">ID of the entry</param>
        /// <param name="dateRecommended">date that entry was recommended</param>
        /// <param name="authorEmailSubject">the subject line for the email</param>
        /// <param name="authorEmailText">the body of the email</param>
        private void CreateAuthorAcceptanceEmail(string authorName, string entrySubject, int h2g2ID, DateTime dateRecommended, ref string authorEmailSubject, ref string authorEmailText)
        {
            CreateEmail(authorName, "author", true, entrySubject, h2g2ID, dateRecommended, ref authorEmailSubject, ref authorEmailText);
        }
        /// <summary>
        /// Builds the default personalised email message for this recommendation
		///		being accepted.
        /// </summary>
        /// <param name="scoutName">scouts username</param>
        /// <param name="entrySubject">subject of the entry recommended</param>
        /// <param name="h2g2ID">ID of the entry</param>
        /// <param name="dateRecommended">date that entry was recommended</param>
        /// <param name="scoutEmailSubject">the subject line for the email</param>
        /// <param name="scoutEmailText">the body of the email</param>
        private void CreateScoutAcceptanceEmail(string scoutName, string entrySubject, int h2g2ID, DateTime dateRecommended, ref string scoutEmailSubject, ref string scoutEmailText)
        {
            CreateEmail(scoutName, "scout", true, entrySubject, h2g2ID, dateRecommended, ref scoutEmailSubject, ref scoutEmailText);
        }

        /// <summary>
        /// Builds the default personalised email message to the author or scout
		///		for this recommendation being accepted/rejected.
        /// </summary>
        /// <param name="name">username for the email</param>
        /// <param name="nameType">Whether this is a scout or author email</param>
        /// <param name="accept">Whether this is an accept or reject email</param>
        /// <param name="entrySubject">subject of the entry recommended</param>
        /// <param name="h2g2ID">ID of the entry</param>
        /// <param name="dateRecommended">date that entry was recommended</param>
        /// <param name="emailSubject">the subject line for the email</param>
        /// <param name="emailText">the body of the email</param>
        private void CreateEmail(string name, string nameType, bool accept, string entrySubject, int h2g2ID, DateTime dateRecommended, ref string emailSubject, ref string emailText)
        {
            // fetch the text for the email
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchemailtext"))
            {
                dataReader.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                if (nameType == "scout")
                {
                    if (accept)
                    {
                        dataReader.AddParameter("emailname", "AcceptRecEmail");
                    }
                    else
                    {
                        dataReader.AddParameter("emailname", "RejectRecEmail");
                    }
                }
                else
                {
                    dataReader.AddParameter("emailname", "AuthorRecEmail");
                }
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    // fetch the text for the email
                    emailSubject = dataReader.GetStringNullAsEmpty("Subject");
                    emailText = dataReader.GetStringNullAsEmpty("text");

                    // get the date in a simple format
                    CultureInfo culture = new CultureInfo("en-GB");      
                    string date = dateRecommended.ToString("d MMM yyyy", culture);

                    // do any transformations necessary
                    emailSubject = emailSubject.Replace("++**entry_subject**++", entrySubject);
                    emailSubject = emailSubject.Replace("++**" + nameType + "_name**++", name);
                    emailSubject = emailSubject.Replace("++**date_recommended**++", date);
                    emailSubject = emailSubject.Replace("++**h2g2id**++", h2g2ID.ToString());
                    emailText = emailText.Replace("++**entry_subject**++", entrySubject);
                    emailText = emailText.Replace("++**" + nameType + "_name**++", name);
                    emailText = emailText.Replace("++**date_recommended**++", date);
                    emailText = emailText.Replace("++**h2g2id**++", h2g2ID.ToString());
                }
            }
        }

        /// <summary>
        /// Updates the recommendations status in the DB to show that it has
		///		been accepted by a member of staff. Also returns the details to
		///		allow an acceptance email to be sent to the scout.
        /// </summary>
        /// <param name="user">user doing the acceptance</param>
        /// <param name="h2g2ID_Old"></param>
        /// <param name="recommendationID">ID of the scout recommendation to accept</param>
        /// <param name="comments">any comments to attached to the recommendation</param>
        /// <param name="scoutEmail">email address to send the scouts acceptance email to</param>
        /// <param name="scoutEmailSubject">subject line for the email to scout</param>
        /// <param name="scoutEmailText">text of the acceptance email to scout</param>
        /// <param name="authorEmail">email address to send the authors acceptance email to</param>
        /// <param name="authorEmailSubject">subject line for the email to author</param>
        /// <param name="authorEmailText">text of the acceptance email to author</param>
        public void SubmitAccept(IUser user, int h2g2ID_Old, int recommendationID, string comments, ref string scoutEmail, ref string scoutEmailSubject, ref string scoutEmailText, ref string authorEmail, ref string authorEmailSubject, ref string authorEmailText)
        {
            // if daft h2g2ID_Old value given or user not editorthen fail
            if (h2g2ID_Old <= 0 || user.UserID == 0 || !user.IsEditor)
            {
                return;
            }
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("AcceptScoutRecommendation"))
            {
                dataReader.AddParameter("RecommendationID", recommendationID);
                dataReader.AddParameter("AcceptorID", user.UserID);
                dataReader.AddParameter("Comments", comments);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    CreateBlankForm();
                    XmlElement submission = AddElementTag(_processRecommendationForm, "SUBMISSION");
                    AddAttribute(submission, "SUCCESS", 1);

                    // get the email address of the scout that recommended this entry
                    scoutEmail = dataReader.GetStringNullAsEmpty("ScoutEmail");
                    // get the authors email address
                    authorEmail = dataReader.GetStringNullAsEmpty("AuthorEmail");

                    string scoutName = dataReader.GetStringNullAsEmpty("ScoutName");
                    string authorName = dataReader.GetStringNullAsEmpty("AuthorName");

                    int h2g2ID_New = dataReader.GetInt32NullAsZero("h2g2ID");
                    string entrySubject = dataReader.GetStringNullAsEmpty("Subject");
                    DateTime dateRecommended = dataReader.GetDateTime("DateRecommended");

                    CreateScoutAcceptanceEmail(scoutName, entrySubject, h2g2ID_New, dateRecommended, ref scoutEmailSubject, ref scoutEmailText);
                    CreateAuthorAcceptanceEmail(authorEmail, entrySubject, h2g2ID_New, dateRecommended, ref authorEmailSubject, ref authorEmailText);

                    //remove the article from the review forum, this also updates the article
                    int reviewForumID = FetchReviewForumMemberDetails(h2g2ID_Old);

                    ReviewSubmissionForum reviewSubmissionForum = new ReviewSubmissionForum(InputContext);

                    int threadID = 0;
                    int forumID = 0;

                    reviewSubmissionForum.RemoveThreadFromForum(user.UserID, reviewForumID, h2g2ID_Old, ref threadID, ref forumID, true);
                    PostThreadRemovedMessage(threadID);
                }
                else
                {
                    // add some XML to show failed submission
                    XmlElement submission = AddElementTag(_processRecommendationForm, "SUBMISSION");
                    AddAttribute(submission, "SUCCESS", 0);
                }
            }
        }

        private void PostThreadRemovedMessage(int threadID)
        {
			string	subject = String.Empty;
			string	body = String.Empty;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchemailtext"))
            {
                dataReader.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("emailname", "AcceptRecPost");
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    subject = dataReader.GetStringNullAsEmpty("Subject");
                    body = dataReader.GetStringNullAsEmpty("text");
                }
                else
                {

				    //if the text doesn't exist for this site then use this as default.
				    subject = "Congratulations - Your Entry has been Recommended for the Edited Guide!";
				    body = "Your Guide Entry has just been picked from Peer Review by one of our Scouts," +
						    " and is now heading off into the Editorial Process, which ends with publication" +
						    " in the Edited Guide. We've moved this Review Conversation out of Peer Review" +
						    " and to the entry itself.\n\n" +
						    "If you'd like to know what happens now, check out the page on" +
                            " 'What Happens after your Entry has been Recommended?' at <./>EditedGuide-Process</.>. " +
						    "We hope this explains everything.\n\nThanks for contributing to the Edited Guide!";
			    }
            }
			
			int autoMessageUserID = 294;
			autoMessageUserID = InputContext.CurrentSite.AutoMessageUserID;
			//do this even if the emails are not sent out
			PostToEndOfThread(autoMessageUserID, threadID, subject, body);
        }

        private void PostToEndOfThread(int autoMessageUserID, int threadID, string subject, string body)
        {
            string hashString = subject + "<:>" + body + "<:>" + autoMessageUserID + "<:>0<:>" + threadID + "<:>0";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("PostToEndOfThread"))
            {
                dataReader.AddParameter("userid", autoMessageUserID);
                dataReader.AddParameter("threadid", threadID);
                dataReader.AddParameter("subject", subject);
                dataReader.AddParameter("content", body);
                dataReader.AddParameter("hash", DnaHasher.GenerateHash(hashString));
                dataReader.AddParameter("keywords", DBNull.Value);

                dataReader.Execute();
            }
        }

        private int FetchReviewForumMemberDetails(int H2G2ID)
        {
            int reviewForumID = 0;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchreviewforummemberdetails"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                }
            }
            return reviewForumID;
        }

        /// <summary>
        /// Updates the recommendations status in the DB to show that it has
		///		been rejected by a member of staff.
        /// </summary>
        /// <param name="user">user doing the rejecting</param>
        /// <param name="recommendationID">ID of the scout recommendation to reject</param>
        /// <param name="comments">any comments to attached to the recommendation</param>
        /// <param name="scoutEmail"> email address to send the scouts rejection email to</param>
        /// <param name="emailSubject">subject line for the email</param>
        /// <param name="emailText">text of the automatic rejection email</param>
        public void SubmitReject(IUser user, int recommendationID, string comments, ref string scoutEmail, ref string emailSubject, ref string emailText)
        {
            // if user not editor then fail
            if (user.UserID == 0 || !user.IsEditor)
            {
                return;
            }
	        // do the update in the DB - this will also fetch the relevant fields to the email
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("RejectScoutRecommendation"))
            {
                dataReader.AddParameter("RecommendationID", recommendationID);
                dataReader.AddParameter("Comments", comments);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    CreateBlankForm();
                    // add some XML to show successful submission
                    XmlElement submission = AddElementTag(_processRecommendationForm, "SUBMISSION");
                    AddAttribute(submission, "SUCCESS", 1);

                    // get the email address of the scout that recommended this entry
                    scoutEmail = dataReader.GetStringNullAsEmpty("ScoutEmail");

                    // also get the scout name, entry subject, h2g2ID and date recommended
                    // so that the email can be customised
                    string scoutName = dataReader.GetStringNullAsEmpty("ScoutName");
                    string entrySubject = dataReader.GetStringNullAsEmpty("Subject");
                    int h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                    DateTime dateRecommended = dataReader.GetDateTime("DateRecommended");

                    CreateScoutRejectionEmail(scoutName, entrySubject, h2g2ID, dateRecommended, ref emailSubject, ref emailText);
                }
                else
                {
                    // add some XML to show failed submission
                    XmlElement submission = AddElementTag(_processRecommendationForm, "SUBMISSION");
                    AddAttribute(submission, "SUCCESS", 0);
                }
            }
        } 
    }
}
