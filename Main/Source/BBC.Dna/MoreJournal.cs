using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the MoreJournal Page object
    /// </summary>
    public class MoreJournal : DnaInputComponent
    {
        private const string _docDnaJournal = @"The journalID for the page.";
        private const string _docDnaUserID = @"The userID for the page.";
        private const string _docDnaSkip = @"The number of pages to skip.";
        private const string _docDnaShow = @"The number of pages to show.";

        private int _journalID = 0;

        /// <summary>
        /// Default constructor for the MoreJournal component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreJournal(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            int userID = 0;
            int skip = 0;
            int show = 0;

            TryGetPageParams(ref _journalID, ref userID, ref skip, ref show);

            TryCreateMoreJournalXML(_journalID, userID, skip, show);
        }

        /// <summary>
        /// Implements generating the XML for the More Journal page
        /// </summary>
        /// <param name="journalID">Journal ID of the page to return</param>
        /// <param name="userID">User ID of the page to return</param>
        /// <param name="skip">Number of articles to skip</param>
        /// <param name="show">Number of articles to show</param>
        private void TryCreateMoreJournalXML(int journalID, int userID, int skip, int show)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            XmlElement journal = AddElementTag(RootElement, "JOURNAL");
            AddAttribute(journal, "USERID", userID);

            Forum forum = new Forum(InputContext);
            forum.GetJournal(_journalID, show, skip, false);

            AddInside(forum, "JOURNAL");
        }

        /// <summary>
        /// Adds in the ForumTitle XML to the given parent (the H2G2 node)
        /// </summary>
        /// <param name="parent"></param>
        public void AddJournalGetTitle(XmlElement parent)
        {
            Forum journal = new Forum(InputContext);
            journal.GetTitle(_journalID, 0, false);
            AddInside(parent, journal);
        }

       /// <summary>
        /// Implements getting the params for the page
        /// </summary>
        /// <param name="journalID">Journal ID of the page to return</param>
        /// <param name="userID">User ID of the page to return</param>
        /// <param name="skip">Number of articles to skip</param>
        /// <param name="show">Number of articles to show</param>
        private void TryGetPageParams(ref int journalID, ref int userID, ref int skip, ref int show)
        {
            journalID = InputContext.GetParamIntOrZero("journal", _docDnaJournal);
            userID = InputContext.GetParamIntOrZero("userID", _docDnaUserID);

            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show > 25)
            {
                show = 25;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }
        }
    }
}
