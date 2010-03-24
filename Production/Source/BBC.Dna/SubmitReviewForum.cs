using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the SubmitReviewForum Page object
    /// </summary>
    public class SubmitReviewForum : DnaInputComponent
    {
        private const string _docDnaH2G2ID = @"H2G2 ID of the article to submit.";
        private const string _docDnaAction = @"Action to take.";
        private const string _docDnaResponse = @"Response Comments.";
        private const string _docDnaReviewForumID = @"Review Forum ID.";
        private const string _docDnaRFID = @"Review Forum ID to delete the thread.";
        
        /// <summary>
        /// Default constructor for the SubmitReviewForum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubmitReviewForum(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int H2G2ID = 0; 
            string action = String.Empty;
            string response = String.Empty;

            int reviewForumID = 0;
            int rFID = 0;

            //Clean any existing XML.
            RootElement.RemoveAll();

            TryGetPageParams(ref H2G2ID, ref action, ref response, ref reviewForumID, ref rFID);

            TryCreateSubmitReviewForumXML(H2G2ID, action, response, reviewForumID, rFID);
        }

        /// <summary>
        /// Functions generates the TryCreateSubmitReviewForumXML XML
        /// </summary>
        /// <param name="H2G2ID">H2G2 ID of the article to submit</param>
        /// <param name="action">Action to take</param>
        /// <param name="response">Response Comments</param>
        /// <param name="reviewForumID">Review Forum ID to submit an article </param>
        /// <param name="rFID">rfID ID of the thread to Delete</param>
        public void TryCreateSubmitReviewForumXML(int H2G2ID, string action, string response, int reviewForumID, int rFID)
        {
            ReviewSubmissionForum submitReview = new ReviewSubmissionForum(InputContext);

            if (action == "submitrequest")
            {
                submitReview.RequestSubmitArticle(H2G2ID, InputContext.CurrentSite.SiteID, String.Empty, -1);
            }
	        else if(action == "submitarticle")
            {
                if (response != String.Empty)
                {
                    submitReview.SubmitArticle(InputContext.ViewingUser, H2G2ID, InputContext.CurrentSite.SiteID, response, reviewForumID);
                }
                else
                {
                    submitReview.SubmittedWithEmptyComments(H2G2ID, InputContext.CurrentSite.SiteID, reviewForumID);
                }
            }
	        else if(action == "removethread")
            {
                int threadID = 0;
                int forumID = 0;
                submitReview.RemoveThreadFromForum(InputContext.ViewingUser.UserID, rFID, H2G2ID, ref threadID, ref forumID, false);
            }
            else
            {
                throw new DnaException("Invalid action parameters");
            }
            AddInside(submitReview);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="H2G2ID">H2G2 ID of the article to submit</param>
        /// <param name="action">Action to take</param>
        /// <param name="response">Response Comments</param>
        /// <param name="reviewForumID">Review Forum ID to submit an article </param>
        /// <param name="rFID">rfID ID of the thread to Delete</param>
        private void TryGetPageParams(ref int H2G2ID, ref string action, ref string response, ref int reviewForumID, ref int rFID)
        {
            H2G2ID = InputContext.GetParamIntOrZero("h2g2ID", _docDnaH2G2ID);
            action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
            response = InputContext.GetParamStringOrEmpty("response", _docDnaResponse);
            reviewForumID = InputContext.GetParamIntOrZero("reviewforumid", _docDnaReviewForumID);
            rFID = InputContext.GetParamIntOrZero("rfid", _docDnaRFID);
        }
    }
}