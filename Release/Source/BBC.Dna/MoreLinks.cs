using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More User Subscriptions Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class MoreLinks : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of Links to skip.";
        private const string _docDnaShow = @"The number of Links to show.";
        private const string _docDnaUserID = @"User ID of the More Links to look at.";

        private const string _docDnaLinkID = @"Link ID of the link that needs to be removed.";
        private const string _docDnaAction = @"Action to take on this request on the More Links page. 'delete' is the only action currently recognised";

        string _cacheName = String.Empty;

        XmlElement _actionResult = null;

        /// <summary>
        /// Default constructor for the MoreLinks component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreLinks(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            int userID = 0;
            int skip = 0;
            int show = 0;
            string action = String.Empty;
            int linkID = 0;

            TryGetPageParams(ref userID, ref skip, ref show, ref action, ref linkID);

            TryUpdateLink(action, userID, linkID);

            TryCreateMoreLinksXML(userID, skip, show, action, linkID);
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="userID">The user of the links to get</param>
        /// <param name="skip">number of links to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the links.</param>
        /// <param name="linkID">ID of the link for the action.</param>
        private void TryGetPageParams(ref int userID, ref int skip, ref int show, ref string action, ref int linkID)
        {
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }

            InputContext.TryGetParamString("dnaaction", ref action, _docDnaAction);
            linkID = InputContext.GetParamIntOrZero("linkID", _docDnaLinkID);
        }

        /// <summary>
        /// Method called to delete the links. 
        /// </summary>
        /// <param name="action">The action to apply to the links.</param>
        /// <param name="userID">The user of the links to get</param>
        /// <param name="linkID">ID of the link for the action.</param>
        private bool TryUpdateLink(string action, int userID, int linkID)
        {
            if (action != String.Empty)
            {
                if (userID != InputContext.ViewingUser.UserID)
                {
                    return AddErrorXml("invalidparameters", "You can only update your own links.", null);
                }

                if (linkID == 0)
                {
                    return AddErrorXml("invalidparameters", "Blank or No Link ID provided.", null);
                }

                if (action == "delete")
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("deletelink"))
                    {
                        dataReader.AddParameter("linkid", linkID);
                        dataReader.AddParameter("userid", userID);
                        dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                        dataReader.Execute();
                        _actionResult = CreateElement("ACTIONRESULT");
                        AddAttribute(_actionResult, "ACTION", "delete");
                        AddIntElement(_actionResult, "LINKID", linkID);
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Method called to try to create the TryCreateMoreLinks XML from the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="userID">The user of the links to get</param>
        /// <param name="skip">number of links to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the links.</param>
        /// <param name="linkID">ID of the link for the action.</param>
        /// <returns>Whether the search has suceeded with out error.</returns>
        private bool TryCreateMoreLinksXML(int userID, int skip, int show, string action, int linkID)
        {
            GenerateMoreLinksPageXml(userID, skip, show, action, linkID);

            return true;
        }

        /// <summary>
        /// Calls the LinksList class to generate the most recent Links
        /// </summary>
        /// <param name="userID">The user of the links to get</param>
        /// <param name="skip">number of links to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the links.</param>
        /// <param name="linkID">ID of the link for the action.</param>
        private void GenerateMoreLinksPageXml(int userID, int skip, int show, string action, int linkID)
        {
            // all the XML objects we need to build the page
            LinksList linksList = new LinksList(InputContext);

            // get the users Links list
            linksList.CreateLinksList(userID, InputContext.CurrentSite.SiteID, skip, show, true);

            // Put in the wrapping <MoreLinks> tag which has the user ID in it
            XmlElement moreLinks = AddElementTag(RootElement, "MoreLinks");
            AddAttribute(moreLinks, "USERID", userID);

            if (_actionResult != null)
            {
                moreLinks.AppendChild(_actionResult);
            }

            AddInside(moreLinks, linksList);
        }
    }
}
