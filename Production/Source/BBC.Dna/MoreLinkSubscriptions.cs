using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More User Subscriptions Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class MoreLinkSubscriptions : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of UserSubscriptionBookMarks to skip.";
        private const string _docDnaShow = @"The number of UserSubscriptionBookMarks to show.";
        private const string _docDnaUserID = @"User ID of the More User Subscription BookMarks to look at.";

        string _cacheName = String.Empty;

        /// <summary>
        /// Default constructor for the MoreUserSubscriptions component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreLinkSubscriptions(IInputContext context)
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

            TryCreateMoreLinkSubscriptionsXML(userID, skip, show );
        }

        /// <summary>
        /// Method called to try to create the TryCreateMoreUserSubscriptions, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="userID">The user of the subscription links to get</param>
        /// <param name="skip">number of links to skip</param>
        /// <param name="show">number to show</param>
        /// <returns>False on Error.</returns>
        private bool TryCreateMoreLinkSubscriptionsXML( int userID, int skip, int show )
        {
            LinkSubscriptionList bookmarkList = new LinkSubscriptionList(InputContext);
            bool showPrivate = ( InputContext.ViewingUser != null && userID == InputContext.ViewingUser.UserID );
            bookmarkList.CreateLinkSubscriptionList(userID, InputContext.CurrentSite.SiteID, skip, show, showPrivate );

            // Put in the wrapping <MoreUserSubscriptions> tag which has the user ID in it
            XmlElement bookmarkSubscriptions = AddElementTag(RootElement, "MoreLinkSubscriptions");
            AddAttribute(bookmarkSubscriptions, "USERID", userID);

            AddInside(bookmarkSubscriptions, bookmarkList);
            return true;
        }
    }
}

