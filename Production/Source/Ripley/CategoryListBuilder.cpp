#include "stdafx.h"
#include ".\categorylistbuilder.h"
#include ".\CategoryList.h"
#include ".\TDVAssert.h"
#include "User.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CCategoryListBuilder::CCategoryListBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CCategoryListBuilder::~CCategoryListBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CCategoryListBuilder::Build(void)

		Author:		Mark Howitt
        Created:	05/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	A Pointer to a new Category List page
        Purpose:	Creates the Category List page

		URL :		id=####			- #### = the GUID for a specified list.
					userid=####		- #### = the id of the user which lists belong to.
					nodeid=####		- #### = the id of the node(s) you want to add / remove.
					description=#	- # = the name of a list
					cmd=####		- #### = create, delete, add, remove or rename

					cmd=create		- this requires a description (50 chars max!).
					cmd=delete		- this requires an id.
					cmd=add			- this requires a nodeid and id.
					cmd=remove		- this requires a nodeid and id.
					cmd=rename		- this requires an id and description.

					If no cmd and no id are used, then the list of lists for the given userid is displayed.
					If no cmd, but a valid id are used, then this displays the list info for the given id.

					Users can only see lists they have produced.
					Editors can view any users list using the userid param.

*********************************************************************************/
bool CCategoryListBuilder::Build(CWholePage* pWholePage)
{
	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(pWholePage, "CATEGORYLIST",false);
	if (!bPageOk)
	{
		TDVASSERT(false,"CCategoryListBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Check to make sure we have a logged in user or editor
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		// We need a userid!
		return pWholePage->SetError("UserNotLoggedIn");
	}

	// Get the UserID From the input
	int iUserID = m_InputContext.GetParamInt("userid");
	if (iUserID == 0)
	{
		// Get the UserID from the User object
		iUserID = pUser->GetUserID();
	}

	// Get the editor status, and check to make sure the current user matches the input or they are an editor!
	bool bIsEditor = pUser->GetIsEditor();
	if (!bIsEditor && pUser->GetUserID() != iUserID)
	{
		return pWholePage->SetError("UserNotAuthorised");
	}

	// Get the site id 
	int iSiteID = m_InputContext.GetSiteID();

	// Setup some locals
	CCategoryList CatList(m_InputContext);
	bool bCatOk = true;

	// Have we been given a list GUID?
	CTDVString sGUID;
	m_InputContext.GetParamString("id",sGUID);

	// Get the User who owns this list
	int iListOwner;
	if (!(sGUID.IsEmpty()))
	{
		iListOwner = CatList.GetCategoryListOwner(sGUID);
	}

	// Default to showing all the lists for the userid, unless we've been given a list id
	eCatListViewMode ViewMode = CLVM_LISTS;
	if (!sGUID.IsEmpty())
	{
		ViewMode = CLVM_NODES;
	}

	// Have we been given a node id?
	int iNodeID = m_InputContext.GetParamInt("nodeid");

	// Check to see what opperation we're doing
	CTDVString sDescription;
	CTDVString sCmd;
	if (m_InputContext.GetParamString("cmd",sCmd))
	{
		// Set up a quick check flag
		bool bCommandOK = true;

		// Check what command we want to do!
		if (sCmd.CompareText("create"))
		{
			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","CREATE");

			// Get the catlist object to create a new list for us!
			bCatOk = bCatOk && CatList.ProcessNewCategoryList(iUserID,iSiteID,sGUID);

			// Default to showing all the lists for the user
			ViewMode = CLVM_LISTS;

			// Check to see if we've been given a list of nodes to populate the new list?
			for (int i = 0; bCatOk && i < m_InputContext.GetParamCount("nodeid"); i++)
			{
				// Add the nodes to the new list
				iNodeID = m_InputContext.GetParamInt("nodeid",i);
				bCatOk = bCatOk && CatList.AddNodeToCategoryList(iNodeID,sGUID);
			}
		}
		else if (sCmd.CompareText("delete"))
		{
			// Delete a list
			ViewMode = CLVM_LISTS;
			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","DELETE");
			if (iListOwner != iUserID && !bIsEditor)
			{
				// The user does not own the list!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>UserDoesNotOwnList</ERROR>");
			}
			else if (sGUID.IsEmpty())
			{
				// We need a GUID to delete!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>InvalidGUID</ERROR>");
			}
			else
			{
				// Get the catlist object to create a new list for us!
				bCatOk = bCatOk && CatList.DeleteCategoryList(sGUID);
			}
		}
		else if (sCmd.CompareText("add"))
		{
			// Add a node to a list
			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","ADD");
			
			if (iListOwner != iUserID && !bIsEditor)
			{
				// The user does not own the list!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>UserDoesNotOwnList</ERROR>");
			}
			else if (sGUID.IsEmpty() || iNodeID == 0)
			{
				// We valid GUIDs and NodeIDs!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>InvalidGUIDOrNode</ERROR>");
			}
			else
			{
				// Get the catlist object to add the new node!
				bCatOk = bCatOk && CatList.AddNodeToCategoryList(iNodeID,sGUID);
			}

			// Put us in the right view mode depending on a valid GUID
			if (!sGUID.IsEmpty())
			{
				ViewMode = CLVM_NODES;
			}
		}
		else if (sCmd.CompareText("remove"))
		{
			// Have we been given a node id?
			int iMemberID = m_InputContext.GetParamInt("nodeid");

			// Remove a node from a list
			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","REMOVE");
			if (iListOwner != iUserID && !bIsEditor)
			{
				// The user does not own the list!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>UserDoesNotOwnList</ERROR>");
			}
			else if (sGUID.IsEmpty() || iMemberID == 0)
			{
				// We valid GUIDs and NodeIDs!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>InvalidGUIDOrNode</ERROR>");
			}
			else
			{
				// Get the catlist object to add the new node!
				bCatOk = bCatOk && CatList.RemoveNodeFromCategoryList(iMemberID,sGUID);
			}

			// Put us in the right view mode depending on a valid GUID
			if (!sGUID.IsEmpty())
			{
				ViewMode = CLVM_NODES;
			}
		}
		else if (sCmd.CompareText("rename"))
		{
			// Remove a node from a list
			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","RENAME");

			// Get the new Description for the list
			m_InputContext.GetParamString("description",sDescription);

			if (iListOwner != iUserID && !bIsEditor)
			{
				// The user does not own the list!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>UserDoesNotOwnList</ERROR>");
			}
			else if (sGUID.IsEmpty() || sDescription.IsEmpty())
			{
				// We valid GUIDs and NodeIDs!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>ListIDORNameEmpty</ERROR>");
			}
			else
			{
				// Get the catlist object to rename the cat list
				bCatOk = bCatOk && CatList.RenameCategoryList(sGUID,sDescription);
			}

			// Put us in the right view mode depending on a valid GUID
			if (!sGUID.IsEmpty() || !bCatOk)
			{
				ViewMode = CLVM_NODES;
			}
		}
		else if (sCmd.CompareText("setlistwidth"))
		{
			int iListWidth = m_InputContext.GetParamInt("listwidth");

			bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","SETLISTWIDTH");

			if (iListOwner != iUserID && !bIsEditor)
			{
				// The user does not own the list!
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>UserDoesNotOwnList</ERROR>");
			}
			else if (sGUID.IsEmpty())
			{
				// No valid GUIDs
				bPageOk = bPageOk && pWholePage->AddInside("H2G2","<ERROR>ListIDEmpty</ERROR>");
			}
			else
			{
				// Get the catlist object to rename the cat list
				bCatOk = bCatOk && CatList.SetListWidth(sGUID,iListWidth);
			}

			// Put us in the right view mode depending on a valid GUID
			if (!sGUID.IsEmpty() || !bCatOk)
			{
				ViewMode = CLVM_NODES;
			}
		}
		else
		{
			// Don't know what they want to do!
			TDVASSERT(false,"Unknow Command Given!");
			bCommandOK = false;
		}

		// Check to see if the Category checking worked and that we got a valid command!
		if (bCatOk && bCommandOK)
		{
			// Add the results to the Page
			bPageOk = bPageOk && pWholePage->AddInside("H2G2",&CatList);
		}
		else if (!bCatOk)
		{
			// Get the error from the CatList Object
			bPageOk = bPageOk && pWholePage->AddInside("H2G2",CatList.GetLastErrorAsXMLString());
		}
	}
	else
	{
		// We're just viewing the lists and nodes
		bPageOk = bPageOk && pWholePage->SetAttribute("H2G2","MODE","VIEW");
	}

	// Check to see if we're looking at a list or wanting to see all lists
	if (ViewMode == CLVM_LISTS)
	{
		// Get the basic XML given the current user
		bCatOk = CatList.GetUserCategoryLists(iUserID,iSiteID,bIsEditor);
	}
	else
	{
		// Get the nodes for the given list GUID
		bCatOk = CatList.GetCategoryListForGUID(sGUID);
	}

	// Check make sure everything went ok!
	if (bCatOk)
	{
		// Add the results to the Page
		bPageOk = bPageOk && pWholePage->AddInside("H2G2",&CatList);
	}
	else
	{
		// Get the error from the CatList Object
		bPageOk = bPageOk && pWholePage->AddInside("H2G2",CatList.GetLastErrorAsXMLString());
	}

	if (!bCatOk)
	{
		// If some thing went wrong, we need to get the error from the catlist object!
		bPageOk = bPageOk && pWholePage->SetError(CatList.GetLastErrorCode());		
	}

	// Check for the redirect param
	if (bCatOk && bPageOk && m_InputContext.ParamExists("redirect"))
	{
		// Get the redirect
		CTDVString sRedirect;
		m_InputContext.GetParamString("redirect",sRedirect);

		if(m_InputContext.ParamExists("includelistid"))
		{
			CTDVString slistIDParam;
			slistIDParam = "%26catlistid=";
			slistIDParam += sGUID;
			sRedirect += slistIDParam;
		}
		// Make sure we unescape it!
		sRedirect.Replace("%26","&");
		sRedirect.Replace("%3F","?");

		// Add the redirect to the page
		bPageOk = pWholePage->Redirect(sRedirect);
	}

	return bPageOk;
}