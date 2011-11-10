using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Linq;

namespace BBC.Dna
{
    //define some aliases
	//using GroupMembers = ArrayList;
	//using GroupEntry = KeyValuePair<string, ArrayList>;
	//using GroupMap = Dictionary<int, KeyValuePair<string, ArrayList>>;
	//using SiteGroupMap = Dictionary<int, Dictionary<int, KeyValuePair<string, ArrayList>>>;

	// New storage mechanism
	// UsersData[userid][siteid][0-n]
	// Dictionary<int, Dictionary<int, List<int>>>
	//            userid          siteid    groupid
	// The list is a list of group IDs
	// We also have a Dictionary<int,string> to mape GroupID to groupname

	using UsersData = Dictionary<int, Dictionary<int, List<int>>>;
	using SiteGroupMembership = Dictionary<int, List<int>>;
    using BBC.Dna.Sites;
    using BBC.Dna.Users;
	

    /// <summary>
    /// UserGroups class
    /// </summary>
    public class UserGroupsHelper
    {

        /// <summary>
        /// Get the xml representation of the groups a user is in for a specific site.
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns></returns>
        public static string GetUserGroupsAsXml(int userID, int siteID, IInputContext context)
        {
            string result = String.Empty;
            var usersGroups = UserGroups.GetObject().GetUsersGroupsForSite(userID, siteID);
			result = "<GROUPS>";
            foreach (var group in usersGroups)
			{
				result += "<GROUP><NAME>";
                result += group.Name.ToUpper();
				result += "</NAME></GROUP>";
			}
			result += "</GROUPS>";
            return result;
        }

        /// <summary>
        /// Get the xml element of the groups a user is in for a specific site.
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns></returns>
        public static XmlElement GetUserGroupsElement(int userID, int siteID, IInputContext context)
        {
            string result = String.Empty;

            XmlDocument groupsdoc = new XmlDocument();
			XmlElement groups = groupsdoc.CreateElement("GROUPS");

			var usersGroups = UserGroups.GetObject().GetUsersGroupsForSite(userID, siteID);
            foreach (var groupObj in usersGroups)
			{
				XmlElement group = groupsdoc.CreateElement("GROUP");
				XmlElement name = groupsdoc.CreateElement("NAME");
                name.AppendChild(groupsdoc.CreateTextNode(groupObj.Name));
				group.AppendChild(name);
				groups.AppendChild(group);
			}

			return groups;
        }

        /// <summary>
        /// Retuns all groups for the given site.
        /// </summary>
        /// <param name="siteID"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static XmlElement GetSiteGroupsElement(int siteID, IInputContext context )
        {
            var groupList = UserGroups.GetObject().GetAllGroups();

            XmlDocument groupsdoc = new XmlDocument();
            XmlElement groups = groupsdoc.CreateElement("GROUPS");

            foreach (var groupObj in groupList)
			{
				XmlElement group = groupsdoc.CreateElement("GROUP");
				XmlElement name = groupsdoc.CreateElement("NAME");
				name.AppendChild(groupsdoc.CreateTextNode(groupObj.Name.ToUpper()));
				group.AppendChild(name);
				groups.AppendChild(group);

			}
			return groups;

        }



        /// <summary>
        /// Returns whether a given user is an editor for the given site
        /// </summary>
        /// <param name="userID">users id</param>
        /// <param name="siteID">site id</param>
        /// <param name="context">input context</param>
        /// <returns>whether a given user is an editor for the given site</returns>
        public static bool IsUserEditorForSite(int userID, int siteID, IInputContext context)
        {
            var usersGroups = UserGroups.GetObject().GetUsersGroupsForSite(userID, siteID);
            return usersGroups.Exists(x => x.Name.ToUpper() =="EDITOR");           
        }


        
        /// <summary>
        /// Create an Xml representation of the site list that the given user is an editor for
        /// </summary>
        /// <param name="userID">User to get groups for</param>
        /// <param name="isSuperUser">Whether the user is a superuser or not</param>
        /// <param name="context">The context it's called in</param>
        /// <returns>XmlElement pointing to the sites the user is editor of.</returns>
        public static XmlElement GetSitesUserIsEditorOfXML(int userID, bool isSuperUser, IInputContext context)
        {
            /*
             * <EDITOR-SITE-LIST>
             *  <SITE-LIST>
                    <SITE ID="17">
                        <NAME>1xtra</NAME>
                        <DESCRIPTION>1xtra messageboard</DESCRIPTION>
                        <SHORTNAME>1xtra</SHORTNAME>
                    </SITE>
                    <SITE ID="3">
                        <NAME>360</NAME>
                        <DESCRIPTION>360</DESCRIPTION>
                        <SHORTNAME>360</SHORTNAME>
                    </SITE>
             *  </SITE-LIST>
             * </EDITOR-SITE-LIST>
             */

            XmlDocument editorGroupsDoc = new XmlDocument();
            XmlElement root = editorGroupsDoc.CreateElement("EDITOR-SITE-LIST");

            if (isSuperUser)
            {
                SiteXmlBuilder siteXml = new SiteXmlBuilder(context);
                root.AppendChild(ImportNode(editorGroupsDoc, siteXml.GenerateAllSitesXml(context.TheSiteList).FirstChild));
            }
            else
            {
				XmlElement siteList = editorGroupsDoc.CreateElement("SITE-LIST");
               
                var siteIds = UserGroups.GetObject().GetSitesUserIsMemberOf(userID, "editor");


                foreach (int siteID in siteIds)
				{
						XmlElement siteXml = editorGroupsDoc.CreateElement("SITE");

						ISite site = context.TheSiteList.GetSite(siteID);

						siteXml.SetAttribute("ID", siteID.ToString());

						AddTextElement(siteXml, "NAME", site.SiteName);
						AddTextElement(siteXml, "DESCRIPTION", site.Description);
						AddTextElement(siteXml, "SHORTNAME", site.ShortName);
						AddTextElement(siteXml, "SSOSERVICE", site.SSOService);

						siteList.AppendChild(siteXml);

				}
                root.AppendChild(siteList);
            }
            return root;
        }

        /// <summary>
        /// Static function to add a text element to a given parent element with the given name containing
        /// the given value
        /// </summary>
        /// <param name="parent">Parent node</param>
        /// <param name="name">Name of the element</param>
        /// <param name="value">Value of the text element</param>
        /// <returns>the new element</returns>
        private static XmlElement AddTextElement(XmlElement parent, string name, string value)
        {
            // Create the new element with the text
            XmlElement text = parent.OwnerDocument.CreateElement(name.ToUpper());
            text.AppendChild(parent.OwnerDocument.CreateTextNode(value));
            parent.AppendChild(text);

            // Return the new element
            return text;
        }

        /// <summary>
        /// Static Helper function to import a node from another document.
        /// </summary>
        /// <param name="newOwner">The new owner document to import into</param>
        /// <param name="source">The node you want to import</param>
        /// <returns>The new node or null if it failed</returns>
        public static XmlNode ImportNode(XmlDocument newOwner, XmlNode source)
        {
            return newOwner.ImportNode(source, true);
        }
        
    }
}
