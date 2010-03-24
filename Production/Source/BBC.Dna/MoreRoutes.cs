using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More Routes Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class MoreRoutes : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of Routes to skip.";
        private const string _docDnaShow = @"The number of Routes to show.";
        private const string _docDnaUserID = @"User ID of the More Routes to look at.";

        private const string _docDnaRouteID = @"Route ID of the route that needs to be removed.";
        private const string _docDnaAction = @"Action to take on this request on the More Routes page. 'delete' is the only action currently recognised";

        string _cacheName = String.Empty;

        XmlElement _actionResult = null;

        /// <summary>
        /// Default constructor for the MoreRoutes component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreRoutes(IInputContext context)
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
            int routeID = 0;

            TryGetPageParams(ref userID, ref skip, ref show, ref action, ref routeID);

            TryUpdateRoute(action, userID, routeID);

            TryCreateMoreRoutesXML(userID, skip, show, action, routeID);
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="userID">The user of the routes to get</param>
        /// <param name="skip">number of routes to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the routes.</param>
        /// <param name="routeID">ID of the route for the action.</param>
        private void TryGetPageParams(ref int userID, ref int skip, ref int show, ref string action, ref int routeID)
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
            routeID = InputContext.GetParamIntOrZero("routeID", _docDnaRouteID);
        }

        /// <summary>
        /// Method called to delete the routes. 
        /// </summary>
        /// <param name="action">The action to apply to the routes.</param>
        /// <param name="userID">The user of the routes to get</param>
        /// <param name="routeID">ID of the route for the action.</param>
        private bool TryUpdateRoute(string action, int userID, int routeID)
        {
            if (action != String.Empty)
            {
                if (userID != InputContext.ViewingUser.UserID)
                {
                    return AddErrorXml("invalidparameters", "You can only update your own routes.", null);
                }

                if (routeID == 0)
                {
                    return AddErrorXml("invalidparameters", "Blank or No Route ID provided.", null);
                }

                if (action == "delete")
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("deleteroute"))
                    {
                        dataReader.AddParameter("routeid", routeID);
                        dataReader.AddParameter("userid", userID);
                        dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                        dataReader.Execute();
                        _actionResult = CreateElement("ACTIONRESULT");
                        AddAttribute(_actionResult, "ACTION", "delete");
                        AddIntElement(_actionResult, "ROUTEID", routeID);
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Method called to try to create the TryCreateMoreRoutes XML from the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="userID">The user of the routes to get</param>
        /// <param name="skip">number of routes to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the routes.</param>
        /// <param name="routeID">ID of the route for the action.</param>
        /// <returns>Whether the search has suceeded with out error.</returns>
        private bool TryCreateMoreRoutesXML(int userID, int skip, int show, string action, int routeID)
        {
            GenerateMoreRoutesPageXml(userID, skip, show, action, routeID);

            return true;
        }

        /// <summary>
        /// Calls the RoutesList class to generate the most recent Routes
        /// </summary>
        /// <param name="userID">The user of the routes to get</param>
        /// <param name="skip">number of routes to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the route.</param>
        /// <param name="routeID">ID of the route for the action.</param>
        private void GenerateMoreRoutesPageXml(int userID, int skip, int show, string action, int routeID)
        {
            // all the XML objects we need to build the page
            RoutesList routesList = new RoutesList(InputContext);

            // get the users Routes list
            routesList.CreateRoutesList(userID, InputContext.CurrentSite.SiteID, skip, show, true);

            // Put in the wrapping <MoreRoutes> tag which has the user ID in it
            XmlElement moreRoutes = AddElementTag(RootElement, "MoreRoutes");
            AddAttribute(moreRoutes, "USERID", userID);

            if (_actionResult != null)
            {
                moreRoutes.AppendChild(_actionResult);
            }

            AddInside(moreRoutes, routesList);
        }
    }
}
