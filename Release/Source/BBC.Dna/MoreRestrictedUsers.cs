using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More Restricted Users Page object, holds the list of Restricted Users for a given site
    /// </summary>
    public class MoreRestrictedUsers : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of Restricted Users to skip.";
        private const string _docDnaShow = @"The number of Restricted Users to show.";
        private const string _docDnaSiteID = @"Site ID of the list of Restricted Users to look at.";
        private const string _docDnaUserTypes = @"Type of Restricted Users to look for Banned or Premoderated.";
        

        /// <summary>
        /// Default constructor for the MoreRestrictedUsers component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreRestrictedUsers(IInputContext context)
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

            int siteID = 0;
            int skip = 0;
            int show = 0;
            int userTypes = 0;
            int searchType = 0;
            string letter = String.Empty;

            TryGetPageParams(ref siteID, ref skip, ref show, ref userTypes, ref searchType, ref letter);

            GenerateMoreRestrictedUsersPageXml(siteID, skip, show, userTypes, searchType, letter);
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="siteID">The site ID to get the restricted user list for</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="userTypes">The type of restricted users to bring back Banned and/or Premoderated</param>
        /// <param name="searchType">The type of search to perform</param>
        /// <param name="letter">The beginning letter of the restricted users email to restrict to</param>
        private void TryGetPageParams(ref int siteID, ref int skip, ref int show, ref int userTypes, ref int searchType, ref string letter)
        {
            siteID = InputContext.GetParamIntOrZero("siteid", _docDnaSiteID);

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

            userTypes = InputContext.GetParamIntOrZero("usertypes", _docDnaUserTypes);
        }

        /// <summary>
        /// Calls the Restricted Users list class to generate the Restricted Users
        /// </summary>
        /// <param name="siteID">The site id to get the restricted user list for 0 is all sites</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="userTypes">The type of restricted users to bring back Banned and/or Premoderated</param>
        /// <param name="searchType">The type of search to perform</param>
        /// <param name="letter">The beginning letter of the restricted users email to restrict to</param>
        private void GenerateMoreRestrictedUsersPageXml(int siteID, int skip, int show, int userTypes, int searchType, string letter)
        {
            // all the XML objects we need to build the page
            RestrictedUserList restrictedUserList = new RestrictedUserList(InputContext);

	        // get the recent Restricted Users list
            restrictedUserList.CreateRestrictedUserList(siteID, skip, show, userTypes, searchType, letter);

	        // Put in the wrapping <MoreRestrictedUsers> tag which has the user ID in it
            XmlElement moreRestrictedUsers = AddElementTag(RootElement, "MoreRestrictedUsers");

            AddInside(moreRestrictedUsers, restrictedUserList);

        }

    }
}