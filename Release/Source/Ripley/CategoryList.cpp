#include "stdafx.h"
#include ".\categorylist.h"
#include ".\StoredProcedure.h"
#include ".\Category.h"
#include ".\TDVAssert.h"
#include "MultiStep.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CCategoryList::CCategoryList(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CCategoryList::~CCategoryList(void)
{
}

/*********************************************************************************

	bool CCategoryList::GetCategoryListForGUID(CTDVString& sGUID)

		Author:		Mark Howitt
        Created:	05/04/2004
        Inputs:		sGUID - The GUID for the list you want to look at
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Gets all the information to do with a given list.
					This is mainly called by the FastCategoryList Builder

*********************************************************************************/
bool CCategoryList::GetCategoryListForGUID(CTDVString& sGUID)
{
	// Setup some local variables and call the base class Get List function
	CTDVString sXML;
	CStoredProcedure SP;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::GetCategoryListForGUID","FailedToInitialiseProcedure","Failed to intialise Stored Procedure");
	}

	if (!SP.GetCategoryListLastUpdated(sGUID))
	{
		return SetDNALastError("CCategoryList::GetCategoryListForGUID","FailedToGetLastUpdatedDate","Failed getting last updated details");
	}

	// Now see if we've got a cached version?
	CTDVString sCachedListName = "categorylist";
	sCachedListName << sGUID << ".txt";

	// Check to make sure we actually have some results. If we don't, then there are no items in the list!
	if (!SP.IsEOF())
	{
		// Get the last updated date for the category list. 
		CTDVDateTime dCategoryListLastUpdated = SP.GetDateField("LastUpdated");

		// Set the cache expiry time default to 5 mins ago. 
		CTDVDateTime dExpires(5*60);
		if (dCategoryListLastUpdated > dExpires )
		{
			dExpires = dCategoryListLastUpdated;
		}

		// See if we're going to use the cached version?
		if (CacheGetItem("List", sCachedListName, &dExpires, &sXML))
		{
			// CreateFromCacheText might fail if e.g. the cached text
			// is garbled somehow, in which case proceed with getting
			// the entry from the DB
			if (CreateFromCacheText(sXML))
			{
				UpdateRelativeDates();
				return true;
			}

			// Make sure there's nothing bad left in the string!
			sXML.Empty();
		}
	}

	// Get the category list details from the database
	if (!SP.GetCategoryListForGUID(sGUID))
	{
		return SetDNALastError("CCategoryList::GetCategoryListForGUID","FailedToGetListDetails","Failed getting list details");
	}

	// Now get the details
	int iNodeID = 0;
	bool bIsRoot = false;
	CCategory Cat(m_InputContext);

	// Setup the XML Builder and open the CategoeyLists tag
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	
	bool bOk; 

	if (SP.IsEOF())
	{
		// not got a results set.
		bOk = XML.OpenTag("CATEGORYLIST");
	}
	else 
	{
		bOk = XML.OpenTag("CATEGORYLIST", true);
		bOk = bOk && XML.DBAddIntAttribute("LISTWIDTH",NULL,true,true);
	}
	bOk = bOk && XML.AddTag("GUID",sGUID);
	
	// Go through the results getting all the entries
	while (bOk && !SP.IsEOF())
	{
		// Get the Node Info
		bOk = bOk && XML.OpenTag("HIERARCHYDETAILS",true);
		bOk = bOk && XML.DBAddIntAttribute("NODEID",NULL,true,false,&iNodeID);
		bIsRoot = (SP.GetIntField("PARENTID") == 0);
		bOk = bOk && XML.AddIntAttribute("ISROOT",bIsRoot);
		bOk = bOk && XML.DBAddIntAttribute("USERADD");
		bOk = bOk && XML.DBAddIntAttribute("TYPE",NULL,true,true);
		bOk = bOk && XML.DBAddTag("DISPLAYNAME");
		if (iNodeID > 0)
		{
			bOk = bOk && XML.DBAddTag("DESCRIPTION",NULL,false);
			bOk = bOk && XML.DBAddTag("SYNONYMS",NULL,false);
			bOk = bOk && XML.DBAddIntTag("H2G2ID");
		}

		// Open the members tag and add all the members for the hierarchy node
		bOk = bOk && XML.OpenTag("MEMBERS");

		// Get the Subject Members for the Node
		bOk = bOk && Cat.GetSubjectMembersForNodeID(iNodeID, sXML);

		// Get the Article Members for this node
		bOk = bOk && Cat.GetArticleMembersForNodeID(iNodeID,sXML);

		// Get the Club Members for this node
		bOk = bOk && Cat.GetClubMembersForNodeID(iNodeID,sXML);

		// Get the NodeAliases for this node
		bOk = bOk && Cat.GetNodeAliasMembersForNodeID(iNodeID,sXML);

		// Get the Notices for this node
		bOk = bOk && Cat.GetNoticesForNodeID(iNodeID,sXML);

		// Close the Member and Hiearchy Tags and get the next result
		bOk = bOk && XML.CloseTag("MEMBERS");
		bOk = bOk && XML.CloseTag("HIERARCHYDETAILS");
		SP.MoveNext();
	}

	// Close the Category Lists tag
	bOk = bOk && XML.CloseTag("CATEGORYLIST");

	// Check for errors!
	if (!bOk || !CreateFromXMLText(sXML,NULL,true))
	{
		return SetDNALastError("CCategoryList::GetCategoryListForGUID","FailedToCreateXML","Failed creating XML");
	}

	// We now need to set the sort order for the member of each node
	CXMLTree* pHierarchyNode = m_pTree->FindFirstTagName("HIERARCHYDETAILS");
	while (pHierarchyNode != NULL)
	{
		bOk = bOk && Cat.SetSortOrderForNodeMembers(pHierarchyNode,"MEMBERS");
		pHierarchyNode = pHierarchyNode->GetNextSibling();
	}

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::GetCategoryListForGUID","FailedToSortMembers","Failed sorting members");
	}

	// Create a cached version of this object
	CTDVString sStringToCache;
	if (!CreateCacheText(&sStringToCache) || !CachePutItem("List", sCachedListName, sStringToCache))
	{
		TDVASSERT(false,"Failed to create cached version of XML");
	}

	return bOk;
}

/*********************************************************************************

	bool CCategoryList::GetUserCategoryLists(int iUserID, int iSiteID, bool bShowUserInfo)

		Author:		Mark Howitt
        Created:	06/04/2004
        Inputs:		iUserID - The Id of the user you want to get the list for.
					iSiteID - the id of the site you want to get the lists for
					bShowUserInfo - If this is true, the information on the owner
							of the list is also included in the XML.
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Gets all the Category lists for a given user.

*********************************************************************************/
bool CCategoryList::GetUserCategoryLists(int iUserID, int iSiteID, bool bShowUserInfo)
{
	// Make sure we've been given a valid user
	if (iUserID == 0)
	{
		return SetDNALastError("CCategoryList::GetUserCategoryLists","NoUserIDGiven","No User ID Given");
	}

	// Set up a local procedure object and call the base class to Get the users lists.
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::GetUserCategoryLists","FailedToInitialiseProcedure","Failed To Init StoredProcedure");
	}

	// Now call the procedure to get the lists
	if (!SP.GetCategoryListsForUser(iUserID,iSiteID))
	{
		// We had a problem
		return SetDNALastError("CCategoryList::GetUserCategoryLists","FailedToGetUsersLists","Failed to get the users category lists");
	}

	// Now get all the info from the results
	CTDVString sXML, sGUID;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("USERCATEGORYLISTS");
	bOk = bOk && XML.AddIntTag("CATEGORYLISTSOWNERID",iUserID);
	while (!SP.IsEOF() && bOk)
	{
		bOk = bOk && XML.OpenTag("LIST");
		bOk = bOk && SP.GetField("CategoryListID",sGUID);
		// Remove the dashes from the GUID as this will be used to form the URL later.
		sGUID.Replace("-","");
		bOk = bOk && XML.AddTag("GUID",sGUID);
		bOk = bOk && XML.DBAddTag("Description");
		bOk = bOk && XML.OpenTag("OWNER");
		bOk = bOk && XML.DBAddIntTag("UserID");
		bOk = bOk && XML.DBAddTag("UserName");
		bOk = bOk && XML.DBAddTag("FirstNames",NULL,false);
		bOk = bOk && XML.DBAddTag("LastName",NULL,false);
		bOk = bOk && XML.DBAddTag("Title",NULL,false);
		bOk = bOk && XML.DBAddTag("SiteSuffix",NULL,false);
		bOk = bOk && XML.DBAddIntTag("Status",NULL,false);
		bOk = bOk && XML.DBAddIntTag("Active",NULL,false);
		bOk = bOk && XML.DBAddIntTag("Journal",NULL,false);
		bOk = bOk && XML.CloseTag("OWNER");
		bOk = bOk && XML.DBAddDateTag("CreatedDate",NULL,true,true);
		bOk = bOk && XML.DBAddDateTag("LastUpdated",NULL,true,true);

		// Get the nodes that belong to this list
		bOk = bOk && GetCategoryListsNodes(sGUID,&sXML);
		bOk = bOk && XML.CloseTag("LIST");

		// Get the next result
		SP.MoveNext();
	}

	// Close the TAG
	bOk = bOk && XML.CloseTag("USERCATEGORYLISTS");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::GetUserCategoryLists","FailedToCreateXML","Failed creating XML");
	}

	// Create the page a return
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::GetCategoryListsNodes(CTDVString& sGUID, CTDVString* pXML)

		Author:		Mark Howitt
        Created:	07/04/2004
        Inputs:		sGUID - The ID of the list you want to get the node info for.
					pXML - A pointer to a string. If you don't want the function to
							create the tree at the end, pass a string that will take the
							XML produced.
        Outputs:	-
        Returns:	true if ok, false otherwise.
        Purpose:	Gets all the info for a given list. This function has two
					different modes in which it works. If you don't pass a pointer to
					a string, it will create the tree before returning. If you do pass
					in a string, then this takes the XML produced and the function
					dosn't create the tree!

*********************************************************************************/
bool CCategoryList::GetCategoryListsNodes(CTDVString& sGUID, CTDVString* pXML)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::GetCategoryListsNodes","FailedToInitialiseProcedure","Failed To Init StoredProcedure");
	}

	// Now get the nodes for the given category list
	if (!SP.GetCategoryListNodes(sGUID))
	{
		return SetDNALastError("CCategoryList::GetCategoryListsNodes","FailedToGetListDetails","Failed getting list details");
	}

	// Now get the details
	int iNodeID = 0;
	bool bCreatePage = false;
	CTDVString sXML;

	// If we've been given a NULL pXML pointer, set it to the local string
	if (pXML == NULL)
	{
		bCreatePage = true;
		pXML = &sXML;
	}

	// Initialise the XML Builder
	CDBXMLBuilder XML;
	XML.Initialise(pXML,&SP);
	bool bOk = XML.OpenTag("CATEGORYLISTNODES");
	bOk = bOk && XML.AddTag("GUID",sGUID);
	bOk = bOk && XML.DBAddIntTag("ItemCount","NODECOUNT",false);
	bOk = bOk && XML.DBAddTag("DESCRIPTION",NULL,false);
	bOk = bOk && XML.DBAddIntTag("LISTWIDTH","LISTWIDTH",false);
		
	// Go through the results getting all the entries
	while (!SP.IsEOF() && bOk)
	{
		// Get the Node Info
		bOk = bOk && XML.OpenTag("CATEGORY",true);
		bOk = bOk && XML.DBAddIntAttribute("NodeID",NULL,false,true);
		bOk = bOk && XML.DBAddIntTag("Type",NULL,false);
		bOk = bOk && XML.DBAddTag("DisplayName",NULL,false);
		bOk = bOk && XML.CloseTag("CATEGORY");
		SP.MoveNext();
	}

	// Finally close the XML
	bOk = bOk && XML.CloseTag("CATEGORYLISTNODES");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::GetCategoryListNodesFailed","FailedToCreateXML","Failed creating XML");
	}

	// If we didn't get a string pointer passed in, create the tree
	if (bCreatePage)
	{
		// Create the new tree
		return CreateFromXMLText(sXML,NULL,true);
	}

	// Return the verdict
	return bOk;
}
/*********************************************************************************

	bool CCategoryList::ProcessNewCategoryList(int iUserID, int iSiteID, CTDVString& sGUID)

		Author:		James Conway
        Created:	11/10/2005
        Inputs:		iUserID - The ID of the user who is creating the list
					iSiteID - the site that the list is reside in.
        Outputs:	sGUID - THe new GUID for the list
        Returns:	true if ok, false otherwise.
        Purpose:	Creates a new list for the given user.

*********************************************************************************/
bool CCategoryList::ProcessNewCategoryList(int iUserID, int iSiteID, CTDVString& sGUID)
{
	CTDVString sXML;

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
		CTDVString sWebSiteURL, sDestinationUrl; 

		bGotParams = bGotParams && Multi.GetRequiredValue("readdisclaimer",iReadDisclaimer);
		bGotParams = bGotParams && Multi.GetRequiredValue("websiteurl",sWebSiteURL);
		bGotParams = bGotParams && Multi.GetRequiredValue("ownerflag",iOwnerFlag);
		bGotParams = bGotParams && Multi.GetRequiredValue("destinationurl",sDestinationUrl);

		if (bGotParams)
		{
			CreateNewCategoryList(iUserID, iSiteID, sDestinationUrl, sWebSiteURL, iOwnerFlag, sXML, sGUID);
		}
		else 
		{
			return SetDNALastError("CCategoryList::CreateNewCategoryList","FailedToGetMultistep","Failed To Initialise StoredProcedure");
		}
	}
	else
	{
		// Create the new tree
		Multi.GetAsXML(sXML);
	}

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CCategoryList::CreateNewCategoryList(int iUserID, CTDVString& sDescription, int iSiteID, CTDVString& sXML, CTDVString& sGUID)

		Author:		Mark Howitt
        Created:	07/04/2004
        Inputs:		iUserID - The ID of the user who is creating the list
					iSiteID - the site that the list is reside in.
        Outputs:	sGUID - THe new GUID for the list
        Returns:	true if ok, false otherwise.
        Purpose:	Creates a new list for the given user.

*********************************************************************************/
bool CCategoryList::CreateNewCategoryList(int iUserID, int iSiteID, CTDVString& sDestinationUrl, CTDVString& sWebSiteURL, int iOwnerFlag, CTDVString& sXML, CTDVString& sGUID)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::CreateNewCategoryList","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.CreateCategoryList(iUserID, iSiteID, sDestinationUrl, sWebSiteURL, iOwnerFlag))
	{
		return SetDNALastError("CCategoryList::CreateNewCategoryList","FailedToCreateNewList","Failed to create new Category List");
	}

	// Now get the details
	bool bOk = true;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bOk = XML.OpenTag("CREATEDCATEGORYLIST",true);
	bOk = bOk && SP.GetField("CategoryListID",sGUID);
	// Remove the dashes from the GUID as this will be used to form the URL later.
	sGUID.Replace("-","");
	bOk = bOk && XML.AddAttribute("GUID",sGUID);
	bOk = bOk && XML.DBAddAttribute("Description","Description",false,true,true);
	bOk = bOk && XML.CloseTag("CREATEDCATEGORYLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::CreateNewCategoryList","FailedToCreateXML","Failed creating XML");
	}

	return bOk;
	//return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::DeleteCategoryList(CTDVString& sGUID, int iUserID)

		Author:		Mark Howitt
        Created:	07/04/2004
        Inputs:		sGUID - The ID of the list you want to delete.
					iUserID - The ID of the user trying to delete the list.
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Deletes the given list

*********************************************************************************/
bool CCategoryList::DeleteCategoryList(CTDVString& sGUID)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::DeleteCategoryList","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.DeleteCategoryList(sGUID))
	{
		return SetDNALastError("CCategoryList::DeleteCategoryList","FailedToDeleteList","Failed to delete Category List");
	}

    // Now get the details
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("DELETEDCATEGORYLIST",true);
	bOk = bOk && XML.AddAttribute("GUID",sGUID,false);
	bOk = bOk && XML.DBAddAttribute("DESCRIPTION",NULL,false);
	bOk = bOk && XML.DBAddIntAttribute("DELETED",NULL,true,true);
	bOk = bOk && XML.CloseTag("DELETEDCATEGORYLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::DeleteCategoryList","FailedToCreateXML","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::AddNodeToCategoryList(int iNodeID, CTDVString& sGUID, int* piNewMemberID)

		Author:		Mark Howitt
        Created:	07/04/2004
        Inputs:		iNodeID - the ID of the node you want to add
					SGUID - the ID of the list you want to add the node to.
        Outputs:	piNewMemberID - A pointer to an int that will take the memberid of the new item.
        Returns:	true if ok, false otherwise.
        Purpose:	Adds a given node to a given list

*********************************************************************************/
bool CCategoryList::AddNodeToCategoryList(int iNodeID, CTDVString& sGUID, int* piNewMemberID)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::AddNodeToCategoryList","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.AddNodeToCategoryList(sGUID,iNodeID))
	{
		return SetDNALastError("CCategoryList::AddNodeToCategoryList","FailedToAddNode","Failed to Add Node to Category List");
	}

	// Now get the details
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("ADDEDNODE",true);
	bOk = bOk && XML.AddAttribute("GUID",sGUID);
	bOk = bOk && XML.AddIntAttribute("NodeID",iNodeID,true);
	bOk = bOk && XML.CloseTag("ADDEDNODE");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::AddNodeToCategoryList","FailedToCreateXML","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::RemoveNodeFromCategoryList(int iNodeID, CTDVString& sGUID)

		Author:		Mark Howitt
        Created:	07/04/2004
        Inputs:		iNodeID - The id of the node you want to remove
					sGUID - the ID of the list you want to remove the node from.
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Removes a given node from a given list

*********************************************************************************/
bool CCategoryList::RemoveNodeFromCategoryList(int iNodeID, CTDVString& sGUID)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::RemoveNodeFromCategoryList","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.RemoveNodeFromCategoryList(sGUID,iNodeID))
	{
		return SetDNALastError("CCategoryList::RemoveNodeFromCategoryList","FailedToRemoveNode","Failed to Remove Node From Category List");
	}

	// Now get the details
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("REMOVEDNODE",true);
	bOk = bOk && XML.AddAttribute("GUID",sGUID);
	bOk = bOk && XML.AddAttribute("NodeID",CTDVString(iNodeID),true);
	bOk = bOk && XML.CloseTag("REMOVEDNODE");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::RemoveNodeFromCategoryList","FailedToCreateXML","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::RenameCategoryList(CTDVString& sGUID, CTDVString& sDescription)

		Author:		Mark Howitt
        Created:	15/04/2004
        Inputs:		sGUID - The ID of the list you want to rename
					sDescrition - The new name for the given list
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Renames a given list.

*********************************************************************************/
bool CCategoryList::RenameCategoryList(CTDVString& sGUID, CTDVString& sDescription)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::RenameCategoryList","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.RenameCategoryList(sGUID,sDescription))
	{
		return SetDNALastError("CCategoryList::RenameCategoryList","FailedToRenameList","Failed to Rename Category List");
	}

	// Now get the details
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("RENAMEDCATEGORYLIST",true);
	bOk = bOk && XML.AddAttribute("GUID",sGUID);
	bOk = bOk && XML.AddAttribute("DESCRIPTION",sDescription,true);
	bOk = bOk && XML.CloseTag("RENAMEDCATEGORYLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::RenameCategoryList","FailedToCreateXML","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CCategoryList::SetListWidth(CTDVString& sGUID, int int piListWidth)

		Author:		James Conway
        Created:	06/10/2005
        Inputs:		sGUID - The ID of the list you want to rename
					iListWidth - The width of the list (in pixels)
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Updates width of category list.

*********************************************************************************/
bool CCategoryList::SetListWidth(CTDVString& sGUID, int iListWidth)
{
	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::SetListWidth","FailedToInitialiseProcedure","Failed To Initialise StoredProcedure");
	}

	// Now Call the procedure
	if (!SP.SetListWidth(sGUID,iListWidth))
	{
		return SetDNALastError("CCategoryList::SetListWidth","FailedToSetListWidth","Failed to set width of category list");
	}

	// Now get the details
	CTDVString sXML, sDescription;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("RESIZEDCATEGORYLIST",true);
	bOk = bOk && XML.AddAttribute("GUID",sGUID);
	bOk = bOk && XML.DBAddAttribute("DESCRIPTION","DESCRIPTION",false,true,false);
	bOk = bOk && XML.DBAddIntAttribute("LISTWIDTH",NULL,true,true);
	bOk = bOk && XML.CloseTag("RESIZEDCATEGORYLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CCategoryList::SetListWidth","FailedToCreateXML","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	int CCategoryList::GetCategoryListOwner(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	05/04/2005
        Inputs:		sCategoryListID - The id of the list you want to get the owner for.
        Outputs:	-
        Returns:	the id of the owner for the given categorylist
        Purpose:	Gets the category list owner id

*********************************************************************************/
int CCategoryList::GetCategoryListOwner(CTDVString& sCategoryListID)
{
	// Create and Initialise the procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList::GetCategoryListOwner","FailedToinitialiseProcedure","Failed to intialise Stored Procedure");
	}

	// Now do the check
	if (!SP.GetCategoryListOwner(sCategoryListID))
	{
		return SetDNALastError("CCategoryList::GetCategoryListOwner","FailedToGetListOwner","Failed to get the owner for the list");
	}

	// Now get the user id
	int iUserID = 0;
	if (!SP.IsEOF())
	{
		// Get the id
		iUserID = SP.GetIntField("UserID");
	}

	// return the verdict
	return iUserID;
}
