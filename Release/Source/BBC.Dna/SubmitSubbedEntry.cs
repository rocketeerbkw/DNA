using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the SubmitSubbedEntry object
    /// </summary>
    public class SubmitSubbedEntry : DnaInputComponent
    {
        private const string _docDnaH2G2ID = @"The H2G2 ID of the article to submit.";
        private const string _docDnaComments = @"Comments to go with the submit.";
        private const string _docDnaSubmit = @"The submit param.";
        private const string _docDnaMode = @"The mode.";


        private string _submitSubbedEntryMode = "FETCH";

        /// <summary>
        /// Accessor for SubmitSubbedEntryMode
        /// </summary>
        public string SubmitSubbedEntryMode
        {
            get { return _submitSubbedEntryMode; }
            set { _submitSubbedEntryMode = value; }
        }

        /// <summary>
        /// Default constructor for the SubmitSubbedEntry component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubmitSubbedEntry(IInputContext context)
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

            TryCreateSubmitSubbedEntryXML(h2g2ID, comments, command);
        }

        /// <summary>
        /// Functions generates the TryCreateSubmitSubbedEntryXML XML
        /// </summary>
        /// <param name="H2G2ID">H2G2 ID of the article to submit</param>
        /// <param name="comments">Comments</param>
        /// <param name="command">Command to action</param>
        public void TryCreateSubmitSubbedEntryXML(int H2G2ID, string comments, string command)
        {
            // do an error page if non-registered user, or a user who is neither
            // a sub nor an editor
            // otherwise proceed with the recommendation page
            if (InputContext.ViewingUser.UserID == 0 || !(InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSubEditor))
            {
                AddErrorXml("NOT-SUBEDITOR", "You cannot return an Entry as subbed unless you are registered and either an Editor or a Sub Editor.", RootElement);
                return;
            }

            RootElement.RemoveAll();

            SubmitSubbedEntryForm submitSubbedEntryForm = new SubmitSubbedEntryForm(InputContext);

            if (command == "Submit")
            {
                // this will submit the entry if it is a valid one, or
                // return some error XML if not
                submitSubbedEntryForm.SubmitSubbedEntry(InputContext.ViewingUser, H2G2ID, comments);
            }
            else
            {
                // assume command is a view command otherwise
                if (H2G2ID > 0)
                {
                    // CreateFromh2g2ID will return an error code in the XML if the h2g2ID
                    // is not a valid one
                    submitSubbedEntryForm.CreateFromh2g2ID(InputContext.ViewingUser, H2G2ID, comments);
                }
                else
                {
                    submitSubbedEntryForm.CreateBlankForm();
                }
            }
            AddInside(submitSubbedEntryForm);
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

            _submitSubbedEntryMode = InputContext.GetParamStringOrEmpty("mode", _docDnaMode);
        }

    }
}