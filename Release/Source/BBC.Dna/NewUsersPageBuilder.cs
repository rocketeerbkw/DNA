using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;

namespace BBC.Dna.Component
{

    /// <summary>
    /// Builds the sub-article details and builds them into the page XML
    /// </summary>
    public class NewUsersPageBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubArticleStatusBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public NewUsersPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //if not an editor then return an error
            /*if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsEditor)
            {
                AddErrorXml("NOT-EDITOR", "You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.", RootElement);
                return;
            }*/

            //prepare XML Doc
            RootElement.RemoveAll();
            XmlElement newUsers = AddElementTag(RootElement, "NEWUSERS-LISTING");

            //get parameters out
            int skip = InputContext.GetParamIntOrZero("skip", "the number to skip");
            int show = InputContext.GetParamIntOrZero("Show", "the number to Show");
            if (show <= 0)
                show = 20;
           
            //get unit type and unit number of the date range
            int timeUnitsSinceRegistration = InputContext.GetParamIntOrZero("TimeUnits", "the number to units of time");
            string unitType = InputContext.GetParamStringOrEmpty("UnitType", "the unit type");
            if(unitType.ToUpper() != "MINUTE" && unitType.ToUpper() != "HOUR" && unitType.ToUpper() != "DAY" 
                && unitType.ToUpper() != "WEEK" && unitType.ToUpper() != "MONTH" )
            {
                unitType = "week";
                timeUnitsSinceRegistration = 1;
            }
            string filterType = InputContext.GetParamStringOrEmpty("filter", "Whether to filter or not");
            bool filterUsers = (filterType.ToUpper() != "OFF" && filterType != String.Empty);
            int showUpdatingUsers = InputContext.GetParamIntOrZero("whoupdatedpersonalspace", "users who updated home page");
            
            //add the attributes to the base element
            AddAttribute(newUsers, "UNITTYPE", unitType);
            AddAttribute(newUsers, "TIMEUNITS", timeUnitsSinceRegistration);
            AddAttribute(newUsers, "SITEID", InputContext.CurrentSite.SiteID);

            UserList userList = new UserList(InputContext);
            // Now check to see which type of list we require
            if (InputContext.DoesParamExist("JoinedUserList", "the type of the list required"))
            {
                //get user list
                if (userList.CreateNewUsersList(timeUnitsSinceRegistration, unitType, show, skip, false, "", InputContext.CurrentSite.SiteID, 0))
                {// append the list to the element
                    ImportAndAppend(userList.RootElement.FirstChild, "/DNAROOT/NEWUSERS-LISTING");
                }
            }
            else
            {
                //add elements back to base XML
                if (filterUsers)
                {
                    AddAttribute(newUsers, "FILTER-USERS", filterUsers);
                    AddAttribute(newUsers, "FILTER-TYPE", filterType.ToString());
                }
                if (showUpdatingUsers != 0)
                {
                    AddAttribute(newUsers, "UPDATINGUSERS", showUpdatingUsers.ToString());
                }
                if (userList.CreateNewUsersList(timeUnitsSinceRegistration, unitType, show, skip, filterUsers, filterType, InputContext.CurrentSite.SiteID, showUpdatingUsers))
                {// append the list to the element
                    ImportAndAppend(userList.RootElement.FirstChild, "/DNAROOT/NEWUSERS-LISTING");
                }
            }
        }

    }
}
