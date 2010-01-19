using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the ManageRoute Page object
    /// </summary>
    public class ManageRoute : DnaInputComponent
    {
        private const string _docDnaRouteID = @"Route ID of the route to manage.";

        private const string _docDnaLocationID = @"Location ID of the route location to manage.";
        private const string _docDnaLatitude = @"Latitude of the way point on the route.";
        private const string _docDnaLongitude = @"Longitude of the way point on the route.";
        private const string _docDnaAction = @"Action to take on this request on the Route page. 'create', 'update' and 'delete' are the only actions currently recognised";
 
        private const string _docDnaRouteTitle = @"Title of the route.";
        private const string _docDnaRouteDescription = @"Description of the route.";

        private const string _docDnaTitle = @"Title of the way point on the route.";
        private const string _docDnaDescription = @"Description of the way point on the route.";
        private const string _docDnaLinkH2G2ID = @"H2G2 ID of the route describing article.";
       
        /// <summary>
        /// Default constructor for the ManageRoute component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ManageRoute(IInputContext context)
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

            Route route = new Route(InputContext);
            string action = String.Empty;

            TryGetPageParams(ref action, ref route);

            TryCreateUpdateViewRoute(action, route);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="action">The action to apply to the route.</param>
        /// <param name="route">Route object containg a list of locations</param>
        private void TryGetPageParams(ref string action, ref Route route)
        {
            int routeID = InputContext.GetParamIntOrZero("routeid", _docDnaRouteID);

            route.RouteID = routeID;
            route.Title = InputContext.GetParamStringOrEmpty("routetitle", _docDnaRouteTitle);
            route.Description = InputContext.GetParamStringOrEmpty("routedescription", _docDnaRouteDescription);
            route.LocationCount = InputContext.GetParamCountOrZero("latitude", _docDnaLatitude);
            route.DescribingArticleID = InputContext.GetParamIntOrZero("linkh2g2id", _docDnaLinkH2G2ID);

            for (int i = 0; i < route.LocationCount; i++)
            {
                //Will be 0 if new locations
                int locationID = InputContext.GetParamIntOrZero("locationID", i, _docDnaLocationID);

                double latitude = InputContext.GetParamDoubleOrZero("latitude", i, _docDnaLatitude);
                double longitude = InputContext.GetParamDoubleOrZero("longitude", i, _docDnaLongitude);
                string title = InputContext.GetParamStringOrEmpty("title", i, _docDnaTitle);
                string description = InputContext.GetParamStringOrEmpty("description", i, _docDnaDescription);

                Location location = new Location();
                location.LocationID = locationID;
                location.Latitude = latitude;
                location.Longitude = longitude;
                location.Title = title;
                location.Description = description;

                route.Locations.Add(location);
            }

            action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
        }

        /// <summary>
        /// Method called to create / update or just view the route. 
        /// </summary>
        /// <param name="action">The action to apply to the route.</param>
        /// <param name="route">Route object containg a list of locations</param>
        private bool TryCreateUpdateViewRoute(string action, Route route)
        {
            //If we actually have a known action then do something
            if (action != String.Empty && (action == "update" || action == "create" || action == "delete" || action == "link" || action == "uploadgpsdata"))
            {
                XmlDocument routeDoc = new XmlDocument();
                routeDoc.LoadXml(@"<ROUTE/>");
                XmlElement routeElement = (XmlElement)ImportNode(routeDoc.FirstChild);

                AddTextTag(routeElement, "ROUTETITLE", route.Title);
                AddTextTag(routeElement, "ROUTEDESCRIPTION", route.Description);
                AddTextTag(routeElement, "DESCRIBINGARTICLEID", route.DescribingArticleID.ToString());

                XmlElement locations = AddElementTag(routeElement, "LOCATIONS");
                int order = 1;
                foreach (Location location in route.Locations)
                {
                    XmlElement locationElement = AddElementTag(locations, "LOCATION");
                    locationElement.SetAttribute("LOCATIONID", location.LocationID.ToString());
                    locationElement.SetAttribute("ORDER", order.ToString());

                    AddTextTag(locationElement, "LAT", location.Latitude.ToString());
                    AddTextTag(locationElement, "LONG", location.Longitude.ToString());
                    AddTextTag(locationElement, "TITLE", location.Title);
                    AddTextTag(locationElement, "DESCRIPTION", location.Description);
                    AddTextTag(locationElement, "ZOOMLEVEL", location.ZoomLevel.ToString());
                    order++;
                }

                if (action == "update")
                {
                    if (route.RouteID > 0)
                    {
                        //Formulate the simple XML structure to pass to the Storedprocedure
                        string storedProcedureName = "updateroute";

                        using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                        {
                            dataReader.AddParameter("routeid", route.RouteID);
                            dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                            dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                            dataReader.AddParameter("iseditor", InputContext.ViewingUser.IsEditor);
                            dataReader.AddParameter("routexml", routeElement.OuterXml);
                            dataReader.Execute();
                            if (dataReader.HasRows)
                            {
                                GenerateMangeRouteXml(dataReader, action);
                            }
                            else
                            {
                                AddErrorXml("TryCreateUpdateRoute", "Failed to Update a Route no Route data returned", null);
                                return false;
                            }
                        }
                    }
                    else
                    {
                        AddErrorXml("TryCreateUpdateRoute", "Trying to update invalid route id", null);
                        return false;
                    }
                }
                else if (action == "create")
                {
                    //Formulate the simple XML structure to pass to the Storedprocedure
                    string storedProcedureName = "createroute";

                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                    {
                        dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                        dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                        dataReader.AddParameter("iseditor", InputContext.ViewingUser.IsEditor);
                        dataReader.AddParameter("routexml", routeElement.OuterXml);
                        dataReader.Execute();
                        if (dataReader.HasRows)
                        {
                            GenerateMangeRouteXml(dataReader, action);
                        }
                        else
                        {
                            AddErrorXml("TryCreateUpdateRoute", "Failed to Create a Route no Route data returned", null);
                            return false;
                        }
                    }
                }
                else if (action == "delete")
                {
                    string storedProcedureName = "deleteroute";

                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                    {
                        dataReader.AddParameter("routeid", route.RouteID);
                        dataReader.Execute();
                    }
                }
                else if (action == "link")
                {
                    string storedProcedureName = "linkguideentrytoroute";

                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                    {
                        dataReader.AddParameter("routeid", route.RouteID);
                        dataReader.AddParameter("h2g2id", route.DescribingArticleID);
                        dataReader.Execute();
                    }
                }
                else if (action == "uploadgpsdata")
                {
                    string storedProcedureName = "addgpsdata";

                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
                    {
                        dataReader.AddParameter("routeid", route.RouteID);
                        dataReader.AddParameter("gpsdata", route.GPSData);
                        dataReader.Execute();
                    }
                }
            }
            else
            {
                GetRoutePageXml(action, route);
            }

            return true;
        }

        /// <summary>
        /// Calls the stored procedure to get the Route
        /// </summary>
        /// <param name="action">The action to apply to the route.</param>
        /// <param name="routeData">Route object containg a list of locations</param>
        private void GetRoutePageXml(string action, Route routeData)
        {
            string storedProcedureName = "getroute";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("routeid", routeData.RouteID);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();
                GenerateMangeRouteXml(dataReader, action);
            }
        }    

        /// <summary>
        /// Generates the XML for the Route
        /// </summary>
        /// <param name="dataReader">The recordset of location data</param>
        /// <param name="action">The action to apply to the route.</param>
        private void GenerateMangeRouteXml(IDnaDataReader dataReader, string action)
        {
            XmlElement routePageXML = AddElementTag(RootElement, "ROUTEPAGE");

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    Route route = new Route(InputContext);
                    route.CreateRouteXML(dataReader, true);
                    AddInside(routePageXML, route);
                }
            }
        }
    }
}