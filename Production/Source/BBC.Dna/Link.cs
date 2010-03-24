using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Class to encapsulate Link functionality.
    /// Creates strandardised Link XML from a resultset.
    /// Shoul dbe extended to add / edit / delete links .
    /// </summary>
    public class Link : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public Link(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// CreateLinkXML from a dataReader.
        /// Allows standard Link XML to be generated from different resultsets.
        /// </summary>
        /// <param name="dataReader"></param>
        /// <param name="parent"></param>
        /// <param name="createAuthorXML"></param>
        /// <param name="createSubmitterXML"></param>
        /// <returns></returns>
        public void CreateLinkXML(IDnaDataReader dataReader, XmlNode parent, bool createSubmitterXML, bool createAuthorXML )
        {
            RootElement.RemoveAll();
            String type = dataReader.GetStringNullAsEmpty("destinationtype");
            XmlNode link = CreateElementNode("LINK");
            AddAttribute(link, "TYPE", type);
            AddAttribute(link, "LINKID", dataReader.GetInt32NullAsZero("linkid"));
            AddAttribute(link, "TEAMID", dataReader.GetInt32NullAsZero("teamid"));
            AddAttribute(link, "RELATIONSHIP", dataReader.GetStringNullAsEmpty("relationship"));
            AddAttribute(link, "PRIVATE", dataReader.GetTinyIntAsInt("private"));

            //Create appropriate URL from link type. 
            int destinationId = dataReader.GetInt32NullAsZero("DestinationID");
            switch (type)
            {
                case "article"  :
                {
                    AddAttribute(link, "DNAUID", "A" + destinationId );
                    break;
                }
                case "userpage" :
                {
                    AddAttribute(link, "DNAUID", "U" + destinationId);
                    break;
                }
                case "category" :
                {
                    AddAttribute(link, "DNAUID", "C" + destinationId);
                    break;
                }
                case "forum" :
                {
                    AddAttribute(link, "DNAUID", "F" + destinationId);
                    break;
                }
                case "thread" :
                {
                     AddAttribute(link, "DNAUID", "T" + destinationId);
                    break;
                }
                case "posting" :
                {
                    AddAttribute(link, "DNAUID", "TP" + destinationId);
                    break;
                }
                default : // "club" )
                {
                    AddAttribute(link, "DNAUID", "G" + destinationId);
                    break;
                }
            }

            //AddTextTag(link, "TITLE", dataReader.GetStringNullAsEmpty("title"));
            AddTextTag(link, "DESCRIPTION", dataReader.GetStringNullAsEmpty("linkdescription"));
            
            //Create Submitter XML if required .
            if ( createSubmitterXML )
            {
                int submitterId = dataReader.GetInt32NullAsZero("submitterid");
                if (submitterId > 0)
                {
                    XmlNode submitterXML = AddElementTag(link, "SUBMITTER");
                    User submitter = new User(InputContext);
                    submitter.AddPrefixedUserXMLBlock(dataReader, submitterId, "submitter", submitterXML);
                }
            }

            //Create author XML if required.
            if (createAuthorXML)
            {
                int authorId = dataReader.GetInt32NullAsZero("authorid");
                if (authorId > 0)
                {
                    XmlNode authorXML = AddElementTag(link, "AUTHOR");
                    User author = new User(InputContext);
                    author.AddPrefixedUserXMLBlock(dataReader, authorId, "author", authorXML);
                }
            }

            if (!dataReader.IsDBNull("datelinked"))
                AddDateXml(dataReader.GetDateTime("datelinked"),link,"DATELINKED");
            if ( !dataReader.IsDBNull("lastupdated") )
                AddDateXml(dataReader.GetDateTime("lastupdated"),link,"LASTUPDATED");

            XmlNode importXml = parent.OwnerDocument.ImportNode(link, true);
            parent.AppendChild(importXml);
        }

        /// <summary>
        /// Gets the links for a user
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="linkGroup"></param>
        /// <param name="showPrivate"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        public void GetUserLinks(int userID, string linkGroup, bool showPrivate, int skip, int show)
        {
            RootElement.RemoveAll();
            if (show <= 0)
	        {
		        show = 1000;
	        }
	        if (show > 5000)
	        {
		        show = 5000;
	        }
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getuserlinks"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("linkgroup", linkGroup);
                dataReader.AddParameter("showprivate", Convert.ToInt32(showPrivate));
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    int linkCount = 0;
                    if (dataReader.Read())
                    {
                        linkCount = dataReader.GetInt32NullAsZero("LinkCount");

                        if (skip > 0)
                        {
                            //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                            //the one required
                            for (int i = 0; i < skip; i++)
                            {
                                dataReader.Read();
                            }
                        }
                    }

                    // Now create the xml tree
                    XmlElement links = AddElementTag(RootElement, "LINKS");

                    // Add all the attributes for the JournalPosts node
                    AddAttribute(links, "TOTALLINKS", linkCount);
                    AddAttribute(links, "SKIPTO", skip);
                    AddAttribute(links, "COUNT", show);

                    GetGroupedLinks(dataReader, links, show);
                }
            }
        }

        private void GetGroupedLinks(IDnaDataReader dataReader, XmlElement parent, int show)
        {
            string currentGroup = String.Empty;
            string newGroup = String.Empty;
            int count = show;
            bool groupOpen = false;
            XmlElement group = null;
            do
            {
                newGroup = dataReader.GetStringNullAsEmpty("Type");
                if (newGroup != currentGroup)
                {
                    groupOpen = false;
                }
                if (!groupOpen)
                {
                    groupOpen = true;
                    currentGroup = dataReader.GetStringNullAsEmpty("Type");

                    group = AddElementTag(parent, "GROUP");
                    AddAttribute(group, "CURRENT", dataReader.GetInt32NullAsZero("selected"));
                    AddTextTag(group, "NAME", currentGroup);
                }

	            string type = dataReader.GetStringNullAsEmpty("DestinationType");
	            int objectID = dataReader.GetInt32NullAsZero("DestinationID");

                XmlElement link = AddElementTag(group, "LINK");
                AddAttribute(link, "TYPE", type);
                AddAttribute(link, "LINKID", dataReader.GetInt32NullAsZero("linkID"));
                AddAttribute(link, "TEAMID", dataReader.GetInt32NullAsZero("TeamID"));
                AddAttribute(link, "RELATIONSHIP", StringUtils.EscapeAllXmlForAttribute(dataReader.GetStringNullAsEmpty("Relationship")));

                switch (type)
                {
                    case "article" :
	                {
		                AddAttribute(link, "DNAID", "A" + objectID.ToString());
                        break;
	                }
	                case "userpage" : 
	                {
		                AddAttribute(link, "BIO", "U" + objectID.ToString());
                        break;
	                }
	                case "category" : 
	                {
		                AddAttribute(link, "DNAID", "C" + objectID.ToString());
                        break;
	                }
	                case "forum" : 
	                {
		                AddAttribute(link, "DNAID", "F" + objectID.ToString());
                        break;
	                }
	                case "thread" : 
	                {
		                AddAttribute(link, "DNAID", "T" + objectID.ToString());
                        break;
	                }
	                case "posting" : 
	                {
		                AddAttribute(link, "DNAID", "TP" + objectID.ToString());
                        break;
	                }
	                case "club" :
	                {
		                AddAttribute(link, "DNAID", "G" + objectID.ToString());
                        break;
	                }
                    default : // "external" : 
	                {
                        AddAttribute(link, "URL", StringUtils.EscapeAllXmlForAttribute(dataReader.GetStringNullAsEmpty("URL")));
                        break;
	                }
                }
                AddAttribute(link, "PRIVATE", dataReader.GetTinyIntAsInt("Private"));

                AddTextTag(link, "TITLE", dataReader.GetStringNullAsEmpty("Title"));
                AddTextTag(link, "DESCRIPTION", dataReader.GetStringNullAsEmpty("LinkDescription"));


	            // Submitter, if we have one
	            if(dataReader.DoesFieldExist("SubmitterID"))
	            {
                    int submitterID = dataReader.GetInt32NullAsZero("SubmitterID");
                    XmlElement submitterTag = AddElementTag(link, "SUBMITTER");
                    AddIntElement(submitterTag, "USERID", submitterID);
                    //TODO Add all Submitter User fields to SP
                    //User submitter = new User(InputContext);
                    //submitter.AddPrefixedUserXMLBlock(dataReader, submitterID, "Submitter", submitterTag);
	            }
        			
                /*
	            //add information about a team which added the link:
	            CTeam team(m_InputContext);
	            if (team.GetAllTeamMembers(iTeamID))
	            {
		            CTDVString sTeam;
		            team.GetAsString(sTeam);
		            sXML << sTeam;
	            }
                */

	            // Add author block if we have one
                if (dataReader.DoesFieldExist("AuthorID"))
                {
                    int authorID = dataReader.GetInt32NullAsZero("AuthorID");
                    XmlElement authorTag = AddElementTag(link, "AUTHOR");
                    AddIntElement(authorTag, "USERID", authorID);
                    //TODO Add all Author User fields to SP
                    //User author = new User(InputContext);
                    //author.AddPrefixedUserXMLBlock(dataReader, authorID, "Author", authorTag);
                }

                // Add LastUpdated
                if (dataReader.DoesFieldExist("LastUpdated") && !dataReader.IsDBNull("LastUpdated"))
                {
                    AddDateXml(dataReader, link, "LastUpdated", "LASTUPDATED");
                }
                count--;

            } while (dataReader.Read() && count > 0);
        }

        /// <summary>
        /// Adds User Link Groups
        /// </summary>
        /// <param name="userID"></param>
        public void GetUserLinkGroups(int userID)
        {
            RootElement.RemoveAll();
            // Now create the xml tree
            XmlElement linkgroups = AddElementTag(RootElement, "LINKGROUPS");
		    AddAttribute(linkgroups, "USERID", userID);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getlinkgroups"))
            {
                dataReader.AddParameter("sourcetype", "userpage");
                dataReader.AddParameter("sourceid", userID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        string group = dataReader.GetStringNullAsEmpty("Type");
                        XmlElement groupTag = AddElementTag(linkgroups, "GROUP");
                        groupTag.InnerText = group;
                        AddAttribute(groupTag, "COUNT", dataReader.GetInt32NullAsZero("TotalLinks"));
                    }
                }
            }
        }

        /// <summary>
        /// Clips the given page to the Users user page
        /// </summary>
        /// <param name="pageType"> textual type of page we're clipping</param>
        /// <param name="objectID">ID of page we're clipping</param>
        /// <param name="linkDescription">Textual description (link text)</param>
        /// <param name="linkGroup">textual (optional) group containing link (user defined)</param>
        /// <param name="user">User who's clipping</param>
        /// <param name="isPrivate">Whether the link is private</param>
        public void ClipPageToUserPage(string pageType, int objectID, string linkDescription, string linkGroup, IUser user, bool isPrivate)
        {
            RootElement.RemoveAll();
            // Now create the xml tree
            XmlElement clip = AddElementTag(RootElement, "CLIP");
		    AddAttribute(clip, "ACTION", "clippage");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("addlinks"))
            {
                dataReader.AddParameter("sourcetype", "userpage");
                dataReader.AddParameter("sourceid", user.UserID);
                dataReader.AddParameter("desttype", pageType);
                dataReader.AddParameter("destid", objectID);
                dataReader.AddParameter("submitterid", user.UserID);
                dataReader.AddParameter("description", linkDescription);
                dataReader.AddParameter("group", linkGroup);
                dataReader.AddParameter("ishidden", isPrivate);
                dataReader.AddParameter("teamid", user.TeamID);
                dataReader.AddParameter("url", String.Empty);
                dataReader.AddParameter("title", DBNull.Value);
                dataReader.AddParameter("relationship", "Bookmark");
                dataReader.AddParameter("destsiteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        string result = dataReader.GetStringNullAsEmpty("result");
                        AddAttribute(clip, "RESULT", result);
                    }
                }
            }
        }

        /// <summary>
        /// Moves the list of links
        /// </summary>
        /// <param name="moveLinkList">list of links to move</param>
        public void MoveLinks(List<KeyValuePair<int, string>> moveLinkList)
        {
            RootElement.RemoveAll();
            // Now create the xml tree
            XmlElement movedLinks = AddElementTag(RootElement, "MOVEDLINKS");
            foreach (KeyValuePair<int, string> link in moveLinkList)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("movelink"))
                {
                    dataReader.AddParameter("linkid", link.Key);
                    dataReader.AddParameter("newgroup", link.Value);
                    dataReader.Execute();
                    XmlElement linkTag = AddElementTag(movedLinks, "LINK");
                    AddAttribute(linkTag, "ID", link.Key);
                    AddAttribute(movedLinks, "NEWGROUP", link.Value);
                }
            }
        }

        /// <summary>
        /// Changes the privacy option of a link
        /// </summary>
        /// <param name="linksPrivacyList">List of links to change the privacy of</param>
        public void ChangeLinksPrivacy(List<KeyValuePair<int, bool>> linksPrivacyList)
        {
            RootElement.RemoveAll();
            // Now create the xml tree
            XmlElement changedLinksPrivacy = AddElementTag(RootElement, "CHANGEDLINKPRIVACY");
            foreach (KeyValuePair<int, bool> link in linksPrivacyList)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("changelinkprivacy"))
                {
                    dataReader.AddParameter("linkid", link.Key);
                    if (link.Value)
                    {
                        dataReader.AddParameter("private", 1);
                    }
                    else
                    {
                        dataReader.AddParameter("private", 0);
                    }
                    dataReader.Execute();
                    XmlElement linkTag = AddElementTag(changedLinksPrivacy, "LINK");
                    AddAttribute(linkTag, "ID", link.Key);
                    if (link.Value)
                    {
                        AddAttribute(linkTag, "PRIVATE", 1);
                    }
                    else
                    {
                        AddAttribute(linkTag, "PRIVATE", 0);
                    }
                }
            }
        }

       /// <summary>
       /// Delete the list of links
       /// </summary>
       /// <param name="deleteLinksList">List of links to delete</param>
       /// <param name="userID">User ID involved</param>
       /// <param name="siteID">Site ID involved</param>
        public void DeleteLinks(List<int> deleteLinksList, int userID, int siteID)
        {
            RootElement.RemoveAll();
            // Now create the xml tree
            XmlElement deletedLinks = AddElementTag(RootElement, "DELETEDLINKS");
            foreach (int linkID in deleteLinksList)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("deletelink"))
                {
                    dataReader.AddParameter("linkid", linkID);
                    dataReader.AddParameter("userID", userID);
                    dataReader.AddParameter("siteID", siteID);
                    dataReader.Execute();
                    XmlElement linkTag = AddElementTag(deletedLinks, "LINK");
                    AddAttribute(linkTag, "ID", linkID);
                    AddAttribute(linkTag, "DELETED", dataReader.HasRows.ToString());
                }
            }
        }
    }
}
