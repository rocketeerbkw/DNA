using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The Category List component
    /// </summary>
    public class CategoryList : DnaInputComponent
    {
        string _cachedFileName = String.Empty;

        /// <summary>
        /// Default Constructor for the CategoryList object
        /// </summary>
        public CategoryList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Gets all the information to do with a given list.
        /// This is mainly called by the FastCategoryList Builder
        /// </summary>
        /// <param name="GUID">The GUID for the list you want to look at</param>
        public void GetCategoryListForGUID(string GUID)
        {
            RootElement.RemoveAll();
            // Get the cache Category list date
            DateTime lastUpdated = CacheGetCategoryListDate(GUID);

            // Set the cache expiry time default to 5 mins ago. 
            DateTime expiryDate = DateTime.Now.AddMinutes(-5);
            if (lastUpdated > expiryDate)
		    {
                expiryDate = lastUpdated;
		    }

            // Check to see if the Category list is cached
            _cachedFileName = "categorylist" + GUID + ".txt";
            string cachedCategoryList = String.Empty;
            /*if (InputContext.FileCacheGetItem("List", _cachedFileName, ref expiryDate, ref cachedCategoryList) && cachedCategoryList.Length > 0)
            {
                // Create the object from the cache
                CreateAndInsertCachedXML(cachedCategoryList, "CATEGORYLIST", true);

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return;
            }
            */
            XmlElement categoryList = AddElementTag(RootElement, "CATEGORYLIST");
            AddTextTag(categoryList, "GUID", GUID);

            // Get the category list details from the database
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcategorylistforguid"))
            {
                Guid categoryListID = new Guid(GUID);
                dataReader.AddParameter("categorylistid", categoryListID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    AddAttribute(categoryList, "LISTWIDTH", dataReader.GetInt32NullAsZero("LISTWIDTH"));
                    do
                    {
                        // Now get the details
                        int nodeID = 0;
                        bool isRoot = false;
                        Category category = new Category(InputContext);

                        // Get the Node Info
                        XmlElement hierarchyDetails = AddElementTag(categoryList, "HIERARCHYDETAILS");
                        nodeID = dataReader.GetInt32NullAsZero("NODEID");
                        AddAttribute(hierarchyDetails, "NODEID", nodeID);

                        isRoot = (dataReader.GetInt32NullAsZero("PARENTID") == 0);

                        AddAttribute(hierarchyDetails, "ISROOT", isRoot);
                        AddAttribute(hierarchyDetails, "USERADD", dataReader.GetTinyIntAsInt("USERADD"));
                        AddAttribute(hierarchyDetails, "TYPE", dataReader.GetInt32NullAsZero("TYPE"));

                        AddTextTag(hierarchyDetails, "DISPLAYNAME", dataReader.GetStringNullAsEmpty("DISPLAYNAME"));
                        if (nodeID > 0)
                        {
                            AddTextTag(hierarchyDetails, "DESCRIPTION", dataReader.GetStringNullAsEmpty("DESCRIPTION"));
                            AddTextTag(hierarchyDetails, "SYNONYMS", dataReader.GetStringNullAsEmpty("SYNONYMS"));
                            AddIntElement(hierarchyDetails, "H2G2ID", dataReader.GetInt32NullAsZero("H2G2ID"));
                        }

                        // Open the members tag and add all the members for the hierarchy node
                        XmlElement members = AddElementTag(hierarchyDetails, "MEMBERS");

                        // Get the Subject Members for the Node
                        members.AppendChild(ImportNode(category.GetSubjectMembersForNodeID(nodeID)));

                        // Get the Article Members for this node
                        //members.AppendChild(ImportNode(category.GetArticleMembersForNodeID(nodeID)));

                        // Get the Club Members for this node
                        //members.AppendChild(ImportNode(category.GetClubMembersForNodeID(nodeID)));

                        // Get the NodeAliases for this node
                        members.AppendChild(ImportNode(category.GetNodeAliasMembersForNodeID(nodeID)));

                        // Get the Notices for this node
                        //members.AppendChild(ImportNode(category.GetNoticesForNodeID(nodeID)));
                    } while (dataReader.Read());

                    // We now need to set the sort order for the member of each node
                    XmlNodeList hierarchyNodes = categoryList.SelectNodes("HIERARCHYDETAILS");
                    foreach (XmlElement hierarchyNode in hierarchyNodes)
                    {
                        Category category = new Category(InputContext);
                        //category.SetSortOrderForNodeMembers(hierarchyNode, "MEMBERS");
                    }
                }
                FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "List", _cachedFileName, categoryList.OuterXml);
            }
        }

        /// <summary>
        /// Gets the last updated time of the category list 
        /// </summary>
        /// <param name="GUID">The category list GUID</param>
        /// <returns>Last Updated</returns>
        private DateTime CacheGetCategoryListDate(string GUID)
        {
            // Get the date from the database
            DateTime lastUpdated = DateTime.MinValue;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcategorylistlastupdated"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.Execute();

                // If we found the info, set the number of seconds
                if (reader.HasRows && reader.Read())
                {
                    lastUpdated = reader.GetDateTime("LastUpdated");
                }
            }
            return lastUpdated;
        }

        /// <summary>
        /// Gets all the Category lists for a given user.
        /// </summary>
        /// <param name="userID">The Id of the user you want to get the list for.</param>
        /// <param name="siteID">the id of the site you want to get the lists for</param>
        /// <param name="showUserInfo"> If this is true, the information on the owner of the list is also included in the XML.</param>
        public void GetUserCategoryLists(int userID, int siteID, bool showUserInfo)
        {
            RootElement.RemoveAll();
            // Make sure we've been given a valid user
            if (userID == 0)
            {
                throw new DnaException("GetUserCategoryLists - No User ID Given");
            }

            XmlElement userCategoryLists = AddElementTag(RootElement, "USERCATEGORYLISTS");
            AddIntElement(userCategoryLists, "CATEGORYLISTSOWNERID", userID);

            // Now call the procedure to get the lists
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcategorylistsforuser"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", siteID);
                reader.Execute();

                // If we found the info, set the number of seconds
                if (reader.HasRows && reader.Read())
                {
                    do
                    {
                        XmlElement list = AddElementTag(userCategoryLists, "LIST");
                        string GUID = reader.GetGuidAsStringOrEmpty("CategoryListID");
                        // Remove the dashes from the GUID as this will be used to form the URL later.
                        GUID = GUID.Replace("-", "");
                        AddTextTag(list, "GUID", GUID);
                        AddTextTag(list, "DESCRIPTION", reader.GetStringNullAsEmpty("Description"));

                        User owner = new User(InputContext);
                        int ownerID = reader.GetInt32NullAsZero("UserID");
                        XmlElement ownerTag = AddElementTag(list, "OWNER");
                        owner.AddUserXMLBlock(reader, ownerID, ownerTag);

                        if (reader.DoesFieldExist("CreatedDate") && !reader.IsDBNull("CreatedDate"))
                        {
                            AddDateXml(reader, list, "CreatedDate", "CREATEDDATE");
                        }
                        if (reader.DoesFieldExist("LastUpdated") && !reader.IsDBNull("LastUpdated"))
                        {
                            AddDateXml(reader, list, "LastUpdated", "LASTUPDATED");
                        }

                        // Get the nodes that belong to this list
                        list.AppendChild(GetCategoryListsNodes(GUID));

                    } while (reader.Read());
                }
            }
        }

        /// <summary>
        /// Gets all the info for a given list.
        /// </summary>
        /// <param name="GUID">The ID of the list you want to get the node info for.</param>
        /// <returns>Elemnt contain all the category list nodes</returns>
        public XmlElement GetCategoryListsNodes(string GUID)
        {
            XmlElement categoryListNodes = null;
            // Now get the nodes for the given category list
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcategorylistnodes"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    categoryListNodes = CreateElement("CATEGORYLISTNODES");
                    AddTextTag(categoryListNodes, "GUID", GUID);
                    AddIntElement(categoryListNodes, "NODECOUNT", reader.GetInt32NullAsZero("ItemCount"));
                    AddTextTag(categoryListNodes, "DESCRIPTION", reader.GetStringNullAsEmpty("DESCRIPTION"));
                    AddIntElement(categoryListNodes, "LISTWIDTH", reader.GetInt32NullAsZero("LISTWIDTH"));

                    // Go through the results getting all the entries
                    do
                    {
                        // Get the Node Info
                        XmlElement category = AddElementTag(categoryListNodes, "CATEGORY");
                        int nodeID = reader.GetInt32NullAsZero("NODEID");
                        if (nodeID > 0)
                        {
                            AddAttribute(category, "NODEID", nodeID);
                            AddIntElement(category, "TYPE", reader.GetInt32NullAsZero("TYPE"));
                            AddTextTag(category, "DISPLAYNAME", reader.GetStringNullAsEmpty("DISPLAYNAME"));
                        }
                    } while (reader.Read());
                }
            }
            return categoryListNodes;
        }
 
        /// <summary>
        /// Creates a new list for the given user.
        /// </summary>
        /// <param name="userID">The ID of the user who is creating the list.</param>
        /// <param name="siteID">The site that the list is reside in.</param>
        /// <param name="GUID">The new GUID for the list</param>
        /// <returns>New category List Xml Element</returns>
        public void ProcessNewCategoryList(int userID, int siteID, string GUID)
        {
            //TODO Create the new category list function
            throw new DnaException("Not Implemented Yet");

                   //TODO
            /*            
             * RootElement.RemoveAll();

             * string sXML;

            CMultiStep Multi(m_InputContext, "CATEGORYLIST");
            Multi.AddRequiredParam("readdisclaimer", "0");
            Multi.AddRequiredParam("websiteurl");
            Multi.AddRequiredParam("ownerflag");
            Multi.AddRequiredParam("destinationurl");

            if (!Multi.ProcessInput())
            {
                return SetDNALastError("CFailMessage","Process","Failed to process input");
            }

            if (Multi.ErrorReported())
            {
                CopyDNALastError("CFailMessage",Multi);
            }

            if (Multi.ReadyToUse())
            {
                // Get parameters
                bool bGotParams = true;
                int iReadDisclaimer, iOwnerFlag; 
                string sWebSiteURL, sDestinationUrl; 

                bGotParams = bGotParams && Multi.GetRequiredValue("readdisclaimer",iReadDisclaimer);
                bGotParams = bGotParams && Multi.GetRequiredValue("websiteurl",sWebSiteURL);
                bGotParams = bGotParams && Multi.GetRequiredValue("ownerflag",iOwnerFlag);
                bGotParams = bGotParams && Multi.GetRequiredValue("destinationurl",sDestinationUrl);

                if (bGotParams)
                {
                    CreateNewCategoryList(userID, siteID, sDestinationUrl, sWebSiteURL, iOwnerFlag, sXML, GUID);
                }
                else 
                {
                    return SetDNALastError("CreateNewCategoryList","FailedToGetMultistep","Failed To Initialise StoredProcedure");
                }
            }
            else
            {
                // Create the new tree
                Multi.GetAsXML(sXML);
            }

            return CreateFromXMLText(sXML);
         */
        }



        /// <summary>
        /// Creates a new list for the given user.
        /// </summary>
        /// <param name="userID">The ID of the user who is creating the list</param>
        /// <param name="siteID">the site that the list is reside in.</param>
        /// <param name="destinationUrl">The destination URL</param>
        /// <param name="webSiteURL">The website URL</param>
        /// <param name="ownerFlag">The owner Flag</param>
        /// <param name="GUID">THe new GUID for the list</param>
        /// <returns>Created Category List element</returns>     
        public XmlElement CreateNewCategoryList(int userID, int siteID, string destinationUrl, string webSiteURL, int ownerFlag, string GUID)
        {
            XmlElement createdCategoryList = null;

            // Now get the nodes for the given category list
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createcategorylist"))
            {
                reader.AddParameter("UserID", userID);
                reader.AddParameter("SiteID", siteID);
                reader.AddParameter("description", destinationUrl);
                reader.AddParameter("website", webSiteURL);
                reader.AddParameter("isowner", ownerFlag);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    createdCategoryList = CreateElement("CREATEDCATEGORYLIST");

                    GUID = reader.GetGuidAsStringOrEmpty("CategoryListID");
                    // Remove the dashes from the GUID as this will be used to form the URL later.
                    GUID.Replace("-", "");
                    AddAttribute(createdCategoryList, "GUID", GUID);
                    AddAttribute(createdCategoryList, "Description", reader.GetStringNullAsEmpty("Description"));
                }
            }
            return createdCategoryList;
        }


        /// <summary>
        /// Deletes the given list
        /// </summary>
        /// <param name="GUID">The ID of the list you want to delete.</param>
        public void DeleteCategoryList(string GUID)
        {
            RootElement.RemoveAll();
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("deletecategorylist"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    XmlElement deletedCategoryList = AddElementTag(RootElement, "DELETEDCATEGORYLIST");
                    AddAttribute(deletedCategoryList, "GUID", GUID);
                    AddAttribute(deletedCategoryList, "DESCRIPTION", StringUtils.EscapeAllXmlForAttribute(reader.GetStringNullAsEmpty("Description")));
                    AddAttribute(deletedCategoryList, "DELETED", reader.GetInt32NullAsZero("DELETED"));
                }
            }
        }

        /// <summary>
        /// Adds a given node to a given list
        /// </summary>
        /// <param name="nodeID">the ID of the node you want to add</param>
        /// <param name="GUID">the ID of the list you want to add the node to.</param>
        /// <returns>New member ID</returns>
        public int AddNodeToCategoryList(int nodeID, string GUID)
        {
            int newNodeID = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addnodetocategorylist"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.AddParameter("nodeid", nodeID);
                reader.Execute();

                XmlElement addedCategoryList = AddElementTag(RootElement, "ADDEDNODE");
                AddAttribute(addedCategoryList, "GUID", GUID);
                AddAttribute(addedCategoryList, "NODEID", nodeID);
            }
            return newNodeID;
        }

        /// <summary>
        /// Removes a given node from a given list
        /// </summary>
        /// <param name="nodeID">The id of the node you want to remove</param>
        /// <param name="GUID">the ID of the list you want to remove the node from.</param>
        public void RemoveNodeFromCategoryList(int nodeID, string GUID)
        {
            RootElement.RemoveAll();
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("deletecategorylistmember"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.AddParameter("nodeid", nodeID);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    XmlElement removedNode = AddElementTag(RootElement, "REMOVEDNODE");
                    AddAttribute(removedNode, "GUID", GUID);
                    AddAttribute(removedNode, "NODEID", nodeID);
                }
            }
        }

        /// <summary>
        /// Renames a given list.
        /// </summary>
        /// <param name="GUID">The ID of the list you want to rename</param>
        /// <param name="newDescription">The new name for the given list</param>
        public void RenameCategoryList(string GUID, string newDescription)
        {
            RootElement.RemoveAll();
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("renamecategorylist"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.AddParameter("description", newDescription);
                reader.Execute();

                XmlElement renamedCategoryList = AddElementTag(RootElement, "RENAMEDCATEGORYLIST");
                AddAttribute(renamedCategoryList, "GUID", GUID);
                AddAttribute(renamedCategoryList, "DESCRIPTION", StringUtils.EscapeAllXmlForAttribute(newDescription));
            }
        }

        /// <summary>
        /// Updates width of category list.
        /// </summary>
        /// <param name="GUID">The ID of the list you want to rename</param>
        /// <param name="listWidth">The width of the list (in pixels)</param>
        public void SetListWidth(string GUID, int listWidth)
        {
            RootElement.RemoveAll();
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("setcategorylistwidth"))
            {
                reader.AddParameter("categorylistid", new Guid(GUID));
                reader.AddParameter("listwidth", listWidth);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    XmlElement resizedCategoryList = AddElementTag(RootElement, "RESIZEDCATEGORYLIST");
                    AddAttribute(resizedCategoryList, "GUID", GUID);
                    AddAttribute(resizedCategoryList, "DESCRIPTION", StringUtils.EscapeAllXmlForAttribute(reader.GetStringNullAsEmpty("Description")));
                    AddAttribute(resizedCategoryList, "LISTWIDTH", listWidth);
                }
            }
        }

        /// <summary>
        /// Gets the category list owner id
        /// </summary>
        /// <param name="categoryListID">The id of the list you want to get the owner for.</param>
        /// <returns>The id of the owner for the given categorylist</returns>       
        public int GetCategoryListOwner(string categoryListID)
        {
            int userID = 0;
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcategorylistowner"))
            {
                reader.AddParameter("categorylistid", new Guid(categoryListID));
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    userID = reader.GetInt32NullAsZero("USERID");
                }
            }
            return userID;
        }
    }
}