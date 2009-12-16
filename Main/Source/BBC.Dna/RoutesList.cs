using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// RoutesList.
    /// List of user routes/clippings/bookmarks created by the user.
    /// </summary>
    public class RoutesList : DnaInputComponent
    {

        /// <summary>
        /// Default Constructor for the RoutesList object
        /// </summary>
        public RoutesList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Accesses DB and creates Routes List.
        /// Routes created by users.
        /// </summary>
        /// <param name="userID">The user of the routes to get</param>
        /// <param name="siteID">Site of the routes</param>
        /// <param name="skip">number of routes to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="showPrivate">Indicates whether private routes should be included.</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRoutesList(int userID, int siteID, int skip, int show, bool showPrivate)
        {
            // check object is not already initialised
            if (userID <= 0 || show <= 0)
            {
                return false;
            }

            XmlElement list = AddElementTag(RootElement, "ROUTES-LIST");
            AddAttribute(list, "SKIP", skip);
            AddAttribute(list, "SHOW", show);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoreroutes"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);

                // Get +1 so we know if there are more left
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show + 1);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //1st Result set gets user details.
                    if (dataReader.Read())
                    {
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userID, list);
                        dataReader.NextResult();
                    }

                    //Paged List of Routes.
                    int count = 0;
                    if (dataReader.HasRows)
                    {
                        while (dataReader.Read() && count < show)
                        {
                            Route route = new Route(InputContext);
                            //Delegate creation of XML to Route class.
                            route.CreateRouteXML(dataReader, false);
                            AddInside(list, route);
                            ++count;
                        }
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (dataReader.Read() && count > 0)
                    {
                        AddAttribute(list, "MORE", 1);
                    }
                }
            }
            return true;
        }
    }
}