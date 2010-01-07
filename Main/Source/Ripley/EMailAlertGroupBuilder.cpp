#include "stdafx.h"
#include ".\EMailAlertGroupBuilder.h"
#include ".\User.h"
#include ".\TDVAssert.h"
#include ".\EMailAlertList.h"

CEMailAlertGroupBuilder::CEMailAlertGroupBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext), m_pPage(NULL)
{
}

CEMailAlertGroupBuilder::~CEMailAlertGroupBuilder(void)
{
}

/*********************************************************************************

	bool CEMailAlertGroupBuilder::Build(CWholePage* pPage)

		Author:		Mark Howitt
        Created:	08/08/2005
        Inputs:		pPage - The Page object that will take the XML
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates the Alert Groups page.

*********************************************************************************/
bool CEMailAlertGroupBuilder::Build(CWholePage* pPage)
{
	// Setup the members
	m_pPage = pPage;

	// Start by initialising the page
	bool bPageOk = InitPage(pPage,"EMAILALERTGROUPS",true);
	if (!bPageOk)
	{
		TDVASSERT(false,"CEMailAlertGroupBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Now get the users details
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		// User must be logged in to use this page!
		SetDNALastError("CEMailAlertGroupBuilder::Build","UserNotLoggedIn","User must be logged in to use this page");
		return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	// Now get the viewing userid
	int iUserID = pViewingUser->GetUserID();

	/*
		// Commands?
			'add'		- Add new groups
			'remove'	- Remove existing groups
			'editgroup'	- Edit existing group

		// Extras
			'itemid'		- The id of the item in question
			'itemtype'		- The Type of item in question
			'notifytype'	- The groups new notification type
			'alerttype'		- The groups new alert list type
			'groupsuserid'	- The userid who owns a group. This needs to match the viewing user OR in editor mode the id of a user you want to modify their groups.
	*/

	// Check to see if we've been given a userid.
	int iGroupsUserID = m_InputContext.GetParamInt("groupsuserid");
	if (iGroupsUserID > 0)
	{
		// Make sure the viewing user is an editor or superuser
		if (iUserID != iGroupsUserID && !pViewingUser->GetIsEditor())
		{
			// The userid doesn't match the the viewing user AND the viewing user is NOT an editor!!!!
			SetDNALastError("CEMailAlertGroupBuilder::Build","UserNotAuthorised","User is not authorised!!!");
			return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}

		// Now set the UserID to the GroupsUserID
		iUserID = iGroupsUserID;
	}

	// Now get the Command from the input and check to see if we've been given anything?
	CTDVString sCmd;
	m_InputContext.GetParamString("cmd",sCmd);
	if (!sCmd.IsEmpty())
	{
		// Get the GroupID from the params
		int iGroupID = m_InputContext.GetParamInt("groupid");

		// Now test to see what command we've been given
		if (sCmd.CompareText("add") || sCmd.CompareText("editgroup"))
		{
			// Then the Alert Type. This will be normal or instant
			CTDVString sAlertType;
			m_InputContext.GetParamString("alerttype",sAlertType);

			// Then the Notification Type. This should be email or private
			CTDVString sNotifyType;
			m_InputContext.GetParamString("Notifytype",sNotifyType);

			if (sCmd.CompareText("add"))
			{
				// Get the required params from the input
				// First the ItemID
				int iItemID = m_InputContext.GetParamInt("itemid");

				// Now the ItemType. This will be either club, h2g2, thread or node
				int iItemType = m_InputContext.GetParamInt("itemtype");

				// Call the add function
				if (!AddItemToAlertList(iUserID, iItemID, iItemType/*, sAlertType, sNotifyType*/, bPageOk))
				{
					// Add the last error to the page
					bPageOk = bPageOk && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				}
			}
			else if (sCmd.CompareText("editgroup"))
			{
				if (iGroupID != 0)	// Edit single group if we're given a group id
				{
					// Call the edit function
					if (!EditItemInAlertList(iUserID, iGroupID, sAlertType, sNotifyType, bPageOk))
					{
						// Add the last error to the page
						bPageOk = bPageOk && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					}
				}
				else // Edit all groups of user
				{
					bool bOwnedItems = (m_InputContext.GetParamInt("OwnedItems") > 0);
					if (!EditUserItemsInAlertList(iUserID, bOwnedItems, sAlertType, sNotifyType, bPageOk))
					{
						// Add the last error to the page
						bPageOk = bPageOk && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					}
				}
			}
		}
		else if (sCmd.CompareText("remove"))
		{
			// Call the add function
			if (!RemoveItemFromAlertList(iUserID, iGroupID, bPageOk))
			{
				// Add the last error to the page
				bPageOk = bPageOk && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
		}
		else
		{
			// Don't know what they want! Invalid command
			SetDNALastError("CEMailAlertGroupBuilder::Build","InvalidCommandGiven","Invalid Command Given!!!");
			bPageOk = bPageOk && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	// NOw get all the users alert groups for this site
	CEMailAlertGroup AlertGroup(m_InputContext);
	if (AlertGroup.GetAlertGroupsForUser(iUserID,m_InputContext.GetSiteID()))
	{
		// Put the XML into the tree
		bPageOk = bPageOk && pPage->AddInside("H2G2",&AlertGroup);
	}
	else
	{
		// Get the last error from the alert group object
		bPageOk = bPageOk && pPage->AddInside("H2G2",AlertGroup.GetLastErrorAsXMLString());
	}

	// return the verdict
	return bPageOk;
}

/*********************************************************************************

	bool CEMailAlertGroupBuilder::AddItemToAlertList(int iUserID, int iItemID, CTDVString& sItemType, CTDVString& sAlertType, CTDVString& sNotifyType)

		Author:		Mark Howitt
        Created:	08/08/2005
        Inputs:		iUserID - The id of the user who's making the changes
					iItemID - the id of the item you want to add
					iItemType - the type of item you're trying to add an alert for. see CEmailAlertList::eEMailListType
					sAlertType - The new Alert type for the group
					sNotifyType - The new type of notification for the group
        Outputs:	bPageOK - A flag to state whether the add inside page worked or not
        Returns:	true if ok, false if not
        Purpose:	Adds the given item to the the users alert list

*********************************************************************************/
bool CEMailAlertGroupBuilder::AddItemToAlertList(int iUserID, int iItemID, int iItemType/*, CTDVString& sAlertType, CTDVString& sNotifyType*/, bool& bPageOk)
{
/*
	// Check the NotifyType
	CEmailAlertList::eNotifyType NotifyType = CEmailAlertList::NT_NONE;
	if (sNotifyType.CompareText("email"))
	{
		NotifyType = CEmailAlertList::NT_EMAIL;
	}
	else if (sNotifyType.CompareText("private"))
	{
		NotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
	}
	else if (sNotifyType.CompareText("disabled"))
	{
		NotifyType = CEmailAlertList::NT_DISABLED;
	}
	else
	{
		// Invalid Notification given!
		SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList","InvalidNotifyType","Invalid Notification Type Given!!!");
		return false;
	}
	
	// Check the Alert Type
	CEmailAlertList::eEMailListType AlertType = CEmailAlertList::LT_NONE;
	if (sAlertType.CompareText("normal"))
	{
		AlertType = CEmailAlertList::LT_EMAILALERT;
	}
	else if (sAlertType.CompareText("instant"))
	{
		AlertType = CEmailAlertList::LT_INSTANTEMAILALERT;
	}
	else
	{
		// Invalid Notification given!
		SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList","InvalidAlertType","Invalid Alert Type Given!!!");
		return false;
	}
*/
	// Now check the item type
	CEmailAlertList::eItemType ItemType = CEmailAlertList::IT_NODE;
	if (iItemType == (int)CEmailAlertList::IT_CLUB)
	{
		ItemType = CEmailAlertList::IT_CLUB;
	}
	else if (iItemType == (int)CEmailAlertList::IT_H2G2)
	{
		ItemType = CEmailAlertList::IT_H2G2;
	}
	else if (iItemType == (int)CEmailAlertList::IT_THREAD)
	{
		ItemType = CEmailAlertList::IT_THREAD;
	}
	else if (iItemType == (int)CEmailAlertList::IT_FORUM)
	{
		ItemType = CEmailAlertList::IT_FORUM;
	}
	else if (iItemType == (int)CEmailAlertList::IT_NODE)
	{
		ItemType = CEmailAlertList::IT_NODE;
	}
	else
	{
		// Invalid type given!
		return SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList","InvalidItemTypeGiven","Invalid Item Type Given!!!");
	}

	// Add the item as a new alert group
	CEMailAlertGroup AlertGroup(m_InputContext);
	if (AlertGroup.AddItemGroupAlert(iUserID,m_InputContext.GetSiteID(),iItemID,ItemType/*,NotifyType,AlertType*/))
	{
		// Add the result to the page
		bPageOk = bPageOk && m_pPage->AddInside("H2G2",&AlertGroup);
	}
	else
	{
		// We've had problems. Get the last error
		return SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList",AlertGroup.GetLastErrorCode(),AlertGroup.GetLastErrorMessage());
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CEMailAlertGroupBuilder::RemoveItemFromAlertList(int iUserID, int iGroupID, bool& bPageOk)

		Author:		Mark Howitt
        Created:	09/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iGroupID - The id of the group to remove
        Outputs:	bPageOK - A flag to state whether the add inside page worked or not
        Returns:	true if ok, false if not
        Purpose:	Removes a given alert for a given user

*********************************************************************************/
bool CEMailAlertGroupBuilder::RemoveItemFromAlertList(int iUserID, int iGroupID, bool& bPageOk)
{
	// Try to add the remove the given item
	CEMailAlertGroup AlertGroup(m_InputContext);
	if (AlertGroup.RemoveGroupAlert(iUserID,iGroupID))
	{
		// Add the result to the page
		bPageOk = bPageOk && m_pPage->AddInside("H2G2",&AlertGroup);
	}
	else
	{
		// We've had problems. Get the last error
		return SetDNALastError("CEMailAlertGroupBuilder::RemoveItemFromAlertList",AlertGroup.GetLastErrorCode(),AlertGroup.GetLastErrorMessage());
	}

	return true;
}

/*********************************************************************************

	bool CEMailAlertGroupBuilder::EditItemInAlertList(int iUserID, int iGroupID, CTDVString& sAlertType, CTDVString& sNotifyType, bool& bPageOk)

		Author:		Mark Howitt
        Created:	09/08/2005
        Inputs:		iUserID - The id of the user who's making the changes
					iGroupID - the id of the group to apply the changes to
					sAlertType - The new Alert type for the group
					sNotifyType - The new type of notification for the group
        Outputs:	bPageOK - A flag to state whether the add inside page worked or not
        Returns:	true if ok, false if not
        Purpose:	Changes the alert type and notification for a given group alert

*********************************************************************************/
bool CEMailAlertGroupBuilder::EditItemInAlertList(int iUserID, int iGroupID, CTDVString& sAlertType, CTDVString& sNotifyType, bool& bPageOk)
{
	// Check the NotifyType
	CEmailAlertList::eNotifyType NotifyType = CEmailAlertList::NT_NONE;
	if (sNotifyType.CompareText("email"))
	{
		NotifyType = CEmailAlertList::NT_EMAIL;
	}
	else if (sNotifyType.CompareText("private"))
	{
		NotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
	}
	else if (sNotifyType.CompareText("disabled"))
	{
		NotifyType = CEmailAlertList::NT_DISABLED;
	}
	else
	{
		// Invalid Notification given!
		return SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList","InvalidNotifyType","Invalid Notification Type Given!!!");
	}
	
	// Check the Alert Type
	CEmailAlertList::eEMailListType AlertType = CEmailAlertList::LT_NONE;
	if (sAlertType.CompareText("normal"))
	{
		AlertType = CEmailAlertList::LT_EMAILALERT;
	}
	else if (sAlertType.CompareText("instant"))
	{
		AlertType = CEmailAlertList::LT_INSTANTEMAILALERT;
	}
	else
	{
		// Invalid Notification given!
		return SetDNALastError("CEMailAlertGroupBuilder::AddItemToAlertList","InvalidAlertType","Invalid Alert Type Given!!!");
	}

	// Now apply the changes
	CEMailAlertGroup AlertGroup(m_InputContext);
	if (!AlertGroup.EditGroupAlert(iUserID,iGroupID,NotifyType,AlertType))
	{
		// Add the result to the page
		bPageOk = bPageOk && m_pPage->AddInside("H2G2",&AlertGroup);
	}
	else
	{
		// We've had problems. Get the last error
		return SetDNALastError("CEMailAlertGroupBuilder::EditItemInAlertList",AlertGroup.GetLastErrorCode(),AlertGroup.GetLastErrorMessage());
	}

	return true;
}

/*********************************************************************************

	bool CEMailAlertGroupBuilder::EditUserItemsInAlertList(int iUserID, bool bIsOwner, const CTDVString& sAlertType, const CTDVString& sNotifyType, bool &bPageOk)

		Author:		Mark Howitt
        Created:	18/08/2005
        Inputs:		iUserID - The id of the user who's wanting to edit the groups
					bOwnedItems - A flag to state which groups need to be edited. Items that the user owns or not
					sAlertType - the new type of alert they want for the groups
					sNotifyType - the new notification type for the groups
        Outputs:	bPageOk - A flag that will take the result of the insertion into the xml
        Returns:	true if ok, false if not
        Purpose:	Edits all the groups alert and notification types depending on whether the user
					owns the items or not. This can be stated using the OwnedItems flag

*********************************************************************************/
bool CEMailAlertGroupBuilder::EditUserItemsInAlertList(int iUserID, bool bOwnedItems, const CTDVString& sAlertType, const CTDVString& sNotifyType, bool &bPageOk)
{
	// Check the NotifyType
	CEmailAlertList::eNotifyType NotifyType = CEmailAlertList::NT_NONE;
	if (sNotifyType.CompareText("email"))
	{
		NotifyType = CEmailAlertList::NT_EMAIL;
	}
	else if (sNotifyType.CompareText("private"))
	{
		NotifyType = CEmailAlertList::NT_PRIVATEMESSAGE;
	}
	else if (sNotifyType.CompareText("disabled"))
	{
		NotifyType = CEmailAlertList::NT_DISABLED;
	}
	else
	{
		// Invalid Notification given!
		return SetDNALastError("CEMailAlertGroupBuilder::EditUserItemsInAlertList","InvalidNotifyType","Invalid Notification Type Given.");
	}

	// Check the Alert Type
	CEmailAlertList::eEMailListType AlertType = CEmailAlertList::LT_NONE;
	if (sAlertType.CompareText("normal"))
	{
		AlertType = CEmailAlertList::LT_EMAILALERT;
	}
	else if (sAlertType.CompareText("instant"))
	{
		AlertType = CEmailAlertList::LT_INSTANTEMAILALERT;
	}
	else
	{
		// Invalid Notification given!
		return SetDNALastError("CEMailAlertGroupBuilder::EditUserItemsInAlertList","InvalidAlertType","Invalid Alert Type Given.");
	}

	// Now apply the changes
	CEMailAlertGroup AlertGroup(m_InputContext);
	if (AlertGroup.EditGroupAlertsForUser(iUserID,m_InputContext.GetSiteID(),bOwnedItems,NotifyType,AlertType))
	{
		// Add the result to the page
		bPageOk = bPageOk && m_pPage->AddInside("H2G2",&AlertGroup);
	}
	else
	{
		// We've had problems. Get the last error
		return SetDNALastError("CEMailAlertGroupBuilder::EditUserItemsInAlertList",AlertGroup.GetLastErrorCode(),AlertGroup.GetLastErrorMessage());
	}

	return true;
}
