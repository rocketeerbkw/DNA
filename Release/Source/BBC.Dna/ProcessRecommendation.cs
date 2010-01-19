using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ProcessRecommendation Page object
    /// </summary>
    public class ProcessRecommendation : DnaInputComponent
    {
        private const string _docDnaRecommendationID = @"The Recommendation ID.";
        private const string _docDnaH2G2ID = @"The H2G2 ID.";
        
        private const string _docDnaComments = @"Comments to go with the recommendation.";
        private const string _docDnaCommand = @"Command for the page.";
        private const string _docDnaScoutEmail= @"Scouts email address.";
        private const string _docDnaScoutEmailSubject= @"Scouts email subject.";
        private const string _docDnaScoutEmailText= @"Scouts email text.";
        private const string _docDnaAuthorEmail= @"Author email address.";
        private const string _docDnaAuthorEmailSubject= @"Author email subject.";
        private const string _docDnaAuthorEmailText= @"Author email text.";

        private const string _docDnaAccept = @"The accept param.";
        private const string _docDnaReject = @"The reject param.";
        private const string _docDnaCancel = @"The cancel param.";
        private const string _docDnaFetch = @"The fetch param.";
        private const string _docDnaMode = @"The mode.";

        private string _processRecommendationMode = "FETCH";

        /// <summary>
        /// Accessor for ProcessRecommendationMode
        /// </summary>
        public string ProcessRecommendationMode
        {
            get { return _processRecommendationMode; }
            set { _processRecommendationMode = value; }
        }

        /// <summary>
        /// Default constructor for the ProcessRecommendation component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ProcessRecommendation(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int recommendationID = 0;
            int h2g2ID = 0;
            string comments = String.Empty;
            string command = String.Empty;

            string scoutEmail = String.Empty;
            string scoutEmailSubject = String.Empty;
            string scoutEmailText = String.Empty;
            string authorEmail = String.Empty;
            string authorEmailSubject = String.Empty;
            string authorEmailText = String.Empty;

            bool accept = true;
            bool reject = true;
            bool cancel = true;
            bool fetch = true;
            int fetchID = 0;


            TryGetPageParams(
                ref recommendationID,
                ref h2g2ID,
                ref comments, 
                ref command,
                ref scoutEmail, 
                ref scoutEmailSubject,
                ref scoutEmailText,
                ref authorEmail, 
                ref authorEmailSubject,
                ref authorEmailText,
                ref accept,
                ref reject,
                ref cancel,
                ref fetch,
                ref fetchID);

            TryCreateProcessRecommendationXML(
                recommendationID,
                h2g2ID, 
                comments, 
                command,
                scoutEmail, 
                scoutEmailSubject,
                scoutEmailText,
                authorEmail, 
                authorEmailSubject,
                authorEmailText,
                accept,
                reject,
                cancel,
                fetch,
                fetchID);
        }


        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="recommendationID"></param>
        /// <param name="h2g2ID"></param>
        /// <param name="comments"></param>
        /// <param name="command"></param>
        /// <param name="scoutEmail"></param>
        /// <param name="scoutEmailSubject"></param>
        /// <param name="scoutEmailText"></param>
        /// <param name="authorEmail"></param>
        /// <param name="authorEmailSubject"></param>
        /// <param name="authorEmailText"></param>
        /// <param name="accept"></param>
        /// <param name="reject"></param>
        /// <param name="cancel"></param>
        /// <param name="fetch"></param>
        /// <param name="fetchID"></param>
        private void TryGetPageParams(ref int recommendationID, 
                                        ref int h2g2ID, 
                                        ref string comments, 
                                        ref string command, 
                                        ref string scoutEmail, 
                                        ref string scoutEmailSubject, 
                                        ref string scoutEmailText, 
                                        ref string authorEmail, 
                                        ref string authorEmailSubject, 
                                        ref string authorEmailText, 
                                        ref bool accept, 
                                        ref bool reject, 
                                        ref bool cancel, 
                                        ref bool fetch,
                                        ref int fetchID)
        {
            // if there are recommendationID, h2g2ID and comments parameters then get them
            recommendationID = InputContext.GetParamIntOrZero("recommendationID", _docDnaRecommendationID);
            h2g2ID = InputContext.GetParamIntOrZero("h2g2ID", _docDnaH2G2ID);
            comments = InputContext.GetParamStringOrEmpty("comments", _docDnaComments);

            // check if we are submitting a decision or just fetching the details
            // is there a cmd parameter and if so what is it?
            command = InputContext.GetParamStringOrEmpty("cmd", _docDnaCommand);

		    // also get any parameters saying which functionality should be present
		    if (InputContext.DoesParamExist("Accept", _docDnaAccept))
		    {
			    accept = (InputContext.GetParamIntOrZero("Accept", _docDnaAccept) != 0);
		    }
		    if (InputContext.DoesParamExist("Reject", _docDnaReject))
		    {
			    reject = (InputContext.GetParamIntOrZero("Reject", _docDnaReject) != 0);
		    }
		    if (InputContext.DoesParamExist("Cancel", _docDnaCancel))
		    {
			    cancel = (InputContext.GetParamIntOrZero("Cancel", _docDnaCancel) != 0);
		    }
		    if (InputContext.DoesParamExist("Fetch", _docDnaFetch))
		    {
			    fetch = (InputContext.GetParamIntOrZero("Fetch", _docDnaFetch) != 0);
		    }

            _processRecommendationMode = InputContext.GetParamStringOrEmpty("mode", _docDnaMode);
        }

        /// <summary>
		///		Constructs the XML for the recommendation processing page, and processes
		///		requests to accept or reject scout recommendations.
        /// </summary>
        /// <param name="recommendationID"></param>
        /// <param name="h2g2ID"></param>
        /// <param name="comments"></param>
        /// <param name="command"></param>
        /// <param name="scoutEmail"></param>
        /// <param name="scoutEmailSubject"></param>
        /// <param name="scoutEmailText"></param>
        /// <param name="authorEmail"></param>
        /// <param name="authorEmailSubject"></param>
        /// <param name="authorEmailText"></param>
        /// <param name="accept"></param>
        /// <param name="reject"></param>
        /// <param name="cancel"></param>
        /// <param name="fetch"></param>
        /// <param name="fetchID"></param>
        private void TryCreateProcessRecommendationXML(int recommendationID, 
                                                        int h2g2ID,
                                                        string comments, 
                                                        string command, 
                                                        string scoutEmail,
                                                        string scoutEmailSubject,
                                                        string scoutEmailText,
                                                        string authorEmail,
                                                        string authorEmailSubject,
                                                        string authorEmailText,
                                                        bool accept,
                                                        bool reject,
                                                        bool cancel,
                                                        bool fetch,
                                                        int fetchID)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            // do an error page if non-registered user, or a user who is neither
            // a scout nor an editor
            // otherwise proceed with the recommendation page
            if (!InputContext.ViewingUser.UserLoggedIn || InputContext.ViewingUser.UserID <= 0 || (!InputContext.ViewingUser.IsEditor))
            {
                AddErrorXml("NOT-EDITOR", "You cannot process a recommendation unless you are logged in as an Editor.", RootElement);
                return;
            }
            ProcessRecommendationForm processRecommendationForm = new ProcessRecommendationForm(InputContext);

            //for sending email
            string editorsEmail = InputContext.CurrentSite.EditorsEmail;
            string siteShortName = InputContext.CurrentSite.ShortName;

            string tempScoutEmail = String.Empty;
            string tempScoutEmailSubject = String.Empty;
            string tempScoutEmailText = String.Empty;
            string tempAuthorEmail = String.Empty;
            string tempAuthorEmailSubject = String.Empty;
            string tempAuthorEmailText = String.Empty;

            // either accept or reject recommendation, or cancel the operation
            // or fetch another recommendation to decide
            if (command == "Accept")
            {

                // if submit successful then this also returns the default email address, 
                // subject and text for the email to send to the scout
                processRecommendationForm.SubmitAccept(InputContext.ViewingUser,
                                                        h2g2ID,
                                                        recommendationID,
                                                        comments,
                                                        ref tempScoutEmail,
                                                        ref tempScoutEmailSubject,
                                                        ref tempScoutEmailText,
                                                        ref tempAuthorEmail,
                                                        ref tempAuthorEmailSubject,
                                                        ref tempAuthorEmailText);
                // send emails to the scout and author
                // only use the default values if not overidden already by request parameters
                if (scoutEmail == String.Empty)
                {
                    scoutEmail = tempScoutEmail;
                }
                if (scoutEmailSubject == String.Empty)
                {
                    scoutEmailSubject = tempScoutEmailSubject;
                }
                if (scoutEmailText == String.Empty)
                {
                    scoutEmailText = tempScoutEmailText;
                }

                InputContext.SendMailOrSystemMessage(scoutEmail, scoutEmailSubject, scoutEmailText,
                    editorsEmail, siteShortName, false, 0, InputContext.CurrentSite.SiteID);

                // now do the authors email
                if (authorEmail == String.Empty)
                {
                    authorEmail = tempAuthorEmail;
                }
                if (authorEmailSubject == String.Empty)
                {
                    authorEmailSubject = tempAuthorEmailSubject;
                }
                if (authorEmailText == String.Empty)
                {
                    authorEmailText = tempAuthorEmailText;
                }
                InputContext.SendMailOrSystemMessage(authorEmail, authorEmailSubject, authorEmailText,
                    editorsEmail, siteShortName, false, 0, InputContext.CurrentSite.SiteID);
            }
            else if (command == "Reject")
            {
                processRecommendationForm.SubmitReject(InputContext.ViewingUser, 
                                                        recommendationID, 
                                                        comments, 
                                                        ref tempScoutEmail,
                                                        ref tempScoutEmailSubject,
                                                        ref tempScoutEmailText);

                // send emails to the scout
                // only use the default values if not overidden already by request parameters
                if (scoutEmail == String.Empty)
                {
                    scoutEmail = tempScoutEmail;
                }
                if (scoutEmailSubject == String.Empty)
                {
                    scoutEmailSubject = tempScoutEmailSubject;
                }
                if (scoutEmailText == String.Empty)
                {
                    scoutEmailText = tempScoutEmailText;
                }

                InputContext.SendMailOrSystemMessage(scoutEmail, scoutEmailSubject, scoutEmailText,
                    editorsEmail, siteShortName, false, 0, InputContext.CurrentSite.SiteID);
            }
            else if (command == "Cancel")
            {
                AddErrorXml("Invalid Decision", "Cancel request received", RootElement);
            }
            else if (command == "Fetch")
            {
                int entryID = fetchID / 10; 
                // get the entry id from the request and try to create the form for the
                // recommendation associated with this entry
                processRecommendationForm.CreateFromEntryID(InputContext.ViewingUser, 
                                                            entryID, 
                                                            comments, 
                                                            true, 
                                                            true, 
                                                            true, 
                                                            true);
            }
            else
            {
                // assume command is a view command otherwise
                if (recommendationID > 0)
                {
                    // CreateFromRecommendationID will return an error code in the XML if required
                    processRecommendationForm.CreateFromRecommendationID(InputContext.ViewingUser, 
                                                                            recommendationID, 
                                                                            comments, 
                                                                            accept, 
                                                                            reject, 
                                                                            cancel, 
                                                                            fetch);
                }
                else
                {
                    // TODO: blank form only makes sense if it has a fetch method
                    processRecommendationForm.CreateBlankForm();
                }
            }
            AddInside(processRecommendationForm);
        }
    }
}