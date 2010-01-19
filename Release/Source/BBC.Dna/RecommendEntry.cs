using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the RecommendEntry Page object
    /// </summary>
    public class RecommendEntry : DnaInputComponent
    {
        private const string _docDnaH2G2ID = @"The H2G2 ID of the article to recommend.";
        private const string _docDnaComments = @"Comments to go with the recommend.";
        private const string _docDnaSubmit = @"The submit param.";
        private const string _docDnaMode = @"The mode.";

        private string _recommendEntryMode = "FETCH";

        /// <summary>
        /// Accessor for RecommendEntryMode
        /// </summary>
        public string RecommendEntryMode
        {
            get { return _recommendEntryMode; }
            set { _recommendEntryMode = value; }
        }

        /// <summary>
        /// Default constructor for the RecommendEntry component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public RecommendEntry(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int h2g2ID = 0;
            string comments = String.Empty;
            string command = String.Empty;

            TryGetPageParams(ref h2g2ID, ref comments, ref command);

            TryCreateRecommendEntryXML(h2g2ID, comments, command);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="h2g2ID"></param>
        /// <param name="comments"></param>
        /// <param name="command"></param>
        private void TryGetPageParams(ref int h2g2ID, ref string comments, ref string command)
        {
            // if there are h2g2ID and comments parameters then get them
            h2g2ID = InputContext.GetParamIntOrZero("h2g2ID", _docDnaH2G2ID);
            comments = InputContext.GetParamStringOrEmpty("comments", _docDnaComments);
            // is there a cmd parameter and if so what is it?
            bool submit = InputContext.DoesParamExist("Submit", _docDnaSubmit);

            if (submit)
            {
                command = "Submit";
            }
            else
            {
                // if not a submit then default to 'Fetch'
                command = "Fetch";
            }

            _recommendEntryMode = InputContext.GetParamStringOrEmpty("mode", _docDnaMode);
        }

        /// <summary>
        /// Constructs the XML for the Recommend An Entry page for Scouts.
		///		This is a simple page allowing a scout to suggest and entry for
		///		inclusion in the edited guide, along with their comments as to
		///		why it should be included.
        /// </summary>
        /// <param name="h2g2ID"></param>
        /// <param name="comments"></param>
        /// <param name="command"></param>
        public void TryCreateRecommendEntryXML(int h2g2ID, string comments, string command)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            // do an error page if non-registered user, or a user who is neither
            // a scout nor an editor
            // otherwise proceed with the recommendation page
            if (!InputContext.ViewingUser.UserLoggedIn || InputContext.ViewingUser.UserID <= 0 || (!InputContext.ViewingUser.IsEditor && !InputContext.ViewingUser.IsScout))
            {
                AddErrorXml("NOT-ABLE-TO-RECOMMEND", "You cannot recommend Guide Entries unless you are registered and either an Editor or a Scout.", RootElement);
                return;
            }
            RecommendEntryForm recommendEntryForm = new RecommendEntryForm(InputContext);

            if (command == "Submit")
            {
                // this will submit the recommendation if it is a valid one, or
                // return some error XML if not
                recommendEntryForm.SubmitRecommendation(InputContext.ViewingUser, h2g2ID, comments);
            }
            else
            {
                // assume command is a view command otherwise
                if (h2g2ID > 0)
                {
                    // CreateFromh2g2ID will return an error code in the XML if the h2g2ID
                    // is not a valid one
                    recommendEntryForm.CreateFromh2g2ID(InputContext.ViewingUser, h2g2ID, comments);
                }
                else
                {
                    recommendEntryForm.CreateBlankForm();
                }
            }
            AddInside(recommendEntryForm);
        }
    }
}