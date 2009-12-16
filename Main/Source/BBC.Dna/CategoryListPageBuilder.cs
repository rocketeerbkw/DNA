using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// CategoryListBuilder class
    /// </summary>
    public class CategoryListPageBuilder : DnaInputComponent
    {
        private const string _docDnaUserID = @"User ID of user whose category list is to be shown.";
        private const string _docDnaGUID = @"GUID of the category list that is to be shown.";
        private const string _docDnaNodeID = @"Node ID of the category list that is to be shown.";
        private const string _docDnaCommand = @"Command to action on the category list.";
        private const string _docDnaDescription = @"Description of renamed or added.";
        private const string _docDnaListWidth = @"New List Width value.";

        private string _categoryListMode = "VIEW";

        /// <summary>
        /// CategoryListBuilder constructor
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public CategoryListPageBuilder(IInputContext context)
            : base(context)
        {

        }

        /// <summary>
        /// Accessor for CategoryListMode
        /// </summary>
        public string CategoryListMode
        {
            get { return _categoryListMode; }
            set { _categoryListMode = value; }
        }

        /// <summary>
        /// Process the request
        /// </summary>
        /// <remarks>
        /// URL :	id=####			- #### = the GUID for a specified list.
        ///			userid=####		- #### = the id of the user which lists belong to.
        ///			nodeid=####		- #### = the id of the node(s) you want to add / remove.
        ///			description=#	- # = the name of a list
        ///			cmd=####		- #### = create, delete, add, remove or rename
        ///
        ///			cmd=create		- this requires a description (50 chars max!).
        ///			cmd=delete		- this requires an id.
        ///			cmd=add			- this requires a nodeid and id.
        ///			cmd=remove		- this requires a nodeid and id.
        ///			cmd=rename		- this requires an id and description.
        ///
        ///			If no cmd and no id are used, then the list of lists for the given userid is displayed.
        ///			If no cmd, but a valid id are used, then this displays the list info for the given id.
        ///
        ///			Users can only see lists they have produced.
        ///			Editors can view any users list using the userid param.
        ///
        /// </remarks>
        public override void ProcessRequest()
        {
            CategoryListPageParameters parameters = new CategoryListPageParameters();
            TryGetPageParams(ref parameters);

            TryCreateCategoryListPageXML(parameters);
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="parameters">Class containing all the Category List Page parameters.</param>
        private void TryGetPageParams(ref CategoryListPageParameters parameters)
        {
            parameters.UserID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            parameters.GUID = InputContext.GetParamStringOrEmpty("id", _docDnaGUID);
            parameters.NodeID = InputContext.GetParamIntOrZero("nodeid", _docDnaNodeID);
            parameters.Command = InputContext.GetParamStringOrEmpty("cmd", _docDnaCommand);
            parameters.Description = InputContext.GetParamStringOrEmpty("description", _docDnaDescription);
            parameters.ListWidth = InputContext.GetParamIntOrZero("listwidth", _docDnaListWidth);

            if (parameters.GUID.Length != 0)
            {
                parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_NODES;
            }

            for (int i = 0; i < InputContext.GetParamCountOrZero("nodeid", _docDnaNodeID); i++)
            {
                parameters.NodeList.Add(InputContext.GetParamIntOrZero("nodeid", i, _docDnaNodeID));
            }
        }
        /// <summary>
        /// Creates the Category List page
        /// </summary>
        /// <param name="parameters">Class containing all the Category List Page parameters.</param>
        public void TryCreateCategoryListPageXML(CategoryListPageParameters parameters)
        {
            // Check to make sure we have a logged in user or editor
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                throw new DnaException("CategoryListPage - User Not Logged In");
            }
            // Get the UserID From the input
            int userID = parameters.UserID;

            // Get the UserID from the User object
            if (userID == 0)
            {
                userID = InputContext.ViewingUser.UserID;
            }
            // Get the editor status, and check to make sure the current user matches the input or they are an editor!
            bool isEditorOrSuperUser = InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser;
            if (!isEditorOrSuperUser && userID != InputContext.ViewingUser.UserID)
            {
                throw new DnaException("CategoryListPage - User Not Authorised");
            }

            //All ok to proceed
            CategoryList categoryList = new CategoryList(InputContext);

            int listOwner = 0;
            if (parameters.GUID != String.Empty)
            {
                listOwner = categoryList.GetCategoryListOwner(parameters.GUID);
            }
            int siteID = InputContext.CurrentSite.SiteID;

            XmlElement h2g2Element = base.RootElement;

            if (parameters.Command != String.Empty)
            {
                switch (parameters.Command)
                {
                    case "create":
                        CategoryListMode = "CREATE";
                        // Get the catlist object to create a new list for us!
                        categoryList.ProcessNewCategoryList(userID, siteID, parameters.GUID);
                        // Default to showing all the lists for the user
                        parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_LISTS;

                        // Check to see if we've been given a list of nodes to populate the new list?
                        foreach(int nodeID in parameters.NodeList)
                        {
                            // Add the nodes to the new list
                            int newNodeID = categoryList.AddNodeToCategoryList(nodeID, parameters.GUID);
                        }
                    break;
                    case "delete":
                        CategoryListMode = "DELETE";
                        if (listOwner != userID && !isEditorOrSuperUser)
                        {
                            AddErrorXml("UserDoesNotOwnList", "User Does Not Own the Category List.", h2g2Element);
                        }
                        else if (parameters.GUID == String.Empty)
                        {
                            AddErrorXml("InvalidGUID", "Invalid Category List GUID supplied.", h2g2Element);
                        }
                        else
                        {
                            // Get the catlist object to delete the list for us!
                            categoryList.DeleteCategoryList(parameters.GUID);
                        }
                        // Default to showing all the lists for the user
                        parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_LISTS;
                    break;
                    case "add":
                        CategoryListMode = "ADD";
                        if (listOwner != userID && !isEditorOrSuperUser)
                        {
                            AddErrorXml("UserDoesNotOwnList", "User Does Not Own the Category List.", h2g2Element);
                        }
                        else if (parameters.GUID == String.Empty || parameters.NodeID == 0)
                        {
                            AddErrorXml("InvalidGUIDOrNode", "Invalid Category List GUID or Node ID supplied.", h2g2Element);
                        }
                        else
                        {
                            // Get the catlist object to add the new node!
                            categoryList.AddNodeToCategoryList(parameters.NodeID, parameters.GUID);
                        }
                        // Put us in the right view mode depending on a valid GUID
                        if (parameters.GUID != String.Empty)
                        {
                            parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_NODES;
                        }
                    break;
                    case "remove":
                        CategoryListMode = "REMOVE";
                        if (listOwner != userID && !isEditorOrSuperUser)
                        {
                            AddErrorXml("UserDoesNotOwnList", "User Does Not Own the Category List.", h2g2Element);
                        }
                        else if (parameters.GUID == String.Empty || parameters.NodeID == 0)
                        {
                            AddErrorXml("InvalidGUIDOrNode", "Invalid Category List GUID or Node ID supplied.", h2g2Element);
                        }
                        else
                        {
                            // Get the catlist object to remove the given node!
                            categoryList.RemoveNodeFromCategoryList(parameters.NodeID, parameters.GUID);
                        }
                        // Put us in the right view mode depending on a valid GUID
                        if (parameters.GUID != String.Empty)
                        {
                            parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_NODES;
                        }
                    break;
                    case "rename":
                        CategoryListMode = "RENAME";
                        if (listOwner != userID && !isEditorOrSuperUser)
                        {
                            AddErrorXml("UserDoesNotOwnList", "User Does Not Own the Category List.", h2g2Element);
                        }
                        else if (parameters.GUID == String.Empty || parameters.Description == String.Empty)
                        {
                            AddErrorXml("InvalidGUIDOrNode", "Invalid Category List GUID or Node ID supplied.", h2g2Element);
                        }
                        else
                        {
                            // Get the catlist object to rename the cat list
                            categoryList.RenameCategoryList(parameters.GUID, parameters.Description);
                        }
                        // Put us in the right view mode depending on a valid GUID
                        if (parameters.GUID != String.Empty)
                        {
                            parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_NODES;
                        }
                    break;
                    case "setlistwidth":
                        CategoryListMode = "SETLISTWIDTH";
                        if (listOwner != userID && !isEditorOrSuperUser)
                        {
                            AddErrorXml("UserDoesNotOwnList", "User Does Not Own the Category List.", h2g2Element);
                        }
                        else if (parameters.GUID == String.Empty)
                        {
                            AddErrorXml("InvalidGUIDOrNode", "Invalid Category List GUID supplied.", h2g2Element);
                        }
                        else
                        {
                            // Get the catlist object to set the list width
                            categoryList.SetListWidth(parameters.GUID, parameters.ListWidth);
                        }
                        // Put us in the right view mode depending on a valid GUID
                        if (parameters.GUID != String.Empty)
                        {
                            parameters.ViewMode = CategoryListPageParameters.eCatListViewMode.CLVM_NODES;
                        }
                    break;
                    default:
                        throw new DnaException("CatergoryListPageBuilder - Unknown Command Given!");
                }
            }
            else
            {
                CategoryListMode = "VIEW";
            }
            AddInside(categoryList);

            // Check to see if we're looking at a list or wanting to see all lists
            if (parameters.ViewMode == CategoryListPageParameters.eCatListViewMode.CLVM_LISTS)
            {
                // Get the basic XML given the current user
                categoryList.GetUserCategoryLists(userID, siteID, isEditorOrSuperUser);
            }
            else
            {
                // Get the nodes for the given list GUID
                categoryList.GetCategoryListForGUID(parameters.GUID);
            }
            AddInside(categoryList);
        }
    }
}