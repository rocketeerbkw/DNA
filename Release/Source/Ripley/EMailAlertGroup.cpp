#include "stdafx.h"
#include ".\EMailAlertGroup.h"
#include ".\StoredProcedure.h"
#include ".\EmailAlertList.h"
#include "tdvassert.h"
#include "emailalertlist.h"

CEMailAlertGroup::CEMailAlertGroup(CInputContext& InputContext) : CXMLObject(InputContext)
{
}

CEMailAlertGroup::~CEMailAlertGroup(void)
{
}

/*********************************************************************************

	bool CEMailAlertGroup::AddItemGroupAlert(int iUserID, int iSiteID, int iItemID, CEmailAlertList::eItemType ItemType, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType)

		Author:		Mark Howitt
        Created:	09/08/2005
        Inputs:		iUserID - the id of the user adding the item
					iSIteID - the id of the site the alert is for
					iItemID - the id of the item that's being added
					ItemType - the type of item being added
					NotifyType - The notification type for this alert
					AlertType - the alert list type that this item wilol be added to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds items to given users alert lists

*********************************************************************************/
bool CEMailAlertGroup::AddItemGroupAlert(int iUserID, int iSiteID, int iItemID, CEmailAlertList::eItemType ItemType/*, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType*/)
{
	// Check to see if we're trying to add a forum, Thread or Post.
	// Check that the forum can be used in instant emails. Also check to see if the current user has permissions to 
	// subscribe to the forum!
	bool bIsUsersPrivateForum = false;
	if (ItemType == CEmailAlertList::IT_FORUM || ItemType == CEmailAlertList::IT_THREAD || ItemType == CEmailAlertList::IT_POST)
	{
		// Check the forum permissions for the user
		CEmailAlertList AlertItem(m_InputContext);
		if (!AlertItem.CheckForumPermissionsForUser(iItemID,ItemType,iUserID,bIsUsersPrivateForum,false))
		{
			// User not authorised or a problem occured!!
			return SetDNALastError("CEMailAlertGroup::AddItemGroupAlert","NoPermissionsToForThisItem","User not authorised to set alerts for this item!!!");
		}
	}

	// Setup some locals
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEMailAlertGroup::AddItemGroupAlert","FailedToInitialiseStoredProcedure","Failed to initialise stored procedure!!!");
	}

	// Setup some locals
	int iResult = 0, iGroupID = 0;
	bool bOk = true;

	// Make sure we call the correct procedure
	if (ItemType == CEmailAlertList::IT_CLUB)
	{
		bOk = SP.AddClubAlertGroup(iUserID,iSiteID,iItemID,/*(int)NotifyType,(int)AlertType,*/iGroupID,iResult);
	}
	else if (ItemType == CEmailAlertList::IT_NODE)
	{
		bOk = SP.AddNodeAlertGroup(iUserID,iSiteID,iItemID,/*(int)NotifyType,(int)AlertType,*/iGroupID,iResult);
	}
	else if (ItemType == CEmailAlertList::IT_H2G2)
	{
		bOk = SP.AddArticleAlertGroup(iUserID,iSiteID,iItemID,/*(int)NotifyType,(int)AlertType,*/iGroupID,iResult);
	}
	else if (ItemType == CEmailAlertList::IT_FORUM)
	{
		bOk = SP.AddForumAlertGroup(iUserID,iSiteID,iItemID,/*(int)NotifyType,(int)AlertType,*/iGroupID,iResult);
	}
	else if (ItemType == CEmailAlertList::IT_THREAD)
	{
		bOk = SP.AddThreadAlertGroup(iUserID,iSiteID,iItemID,/*(int)NotifyType,(int)AlertType,*/iGroupID,iResult);
	}
	else
	{
		return SetDNALastError("CEMailAlertGroup::AddItemGroupAlert","AlertGroupNotSupportedForThisItemType","Alert groups not supported for this item type!!!");
	}

	// See if we had any problems
	if (!bOk)
	{
		return SetDNALastError("CEMailAlertGroup::AddItemGroupAlert","FailedToAddAlertGroup","Failed to add an alert group!!!");
	}

	// Now check to see what happened? As this procedure is using output params, we need to make sure we've
	// reached the end of the file. Only then will the output param be set to the correct value!
	while (!SP.IsEOF())
	{
		SP.MoveNext();
	}

	// Create the XML result
	CDBXMLBuilder XML;
	XML.OpenTag("ALERTACTION",true);
	XML.AddAttribute("ACTION","ADD",true);
	XML.AddIntTag("RESULT",iResult);
	XML.AddIntTag("ITEMTYPE",(int)ItemType);
	XML.AddIntTag("ITEMID",iItemID);
	XML.AddIntTag("NEWGROUPID",iGroupID);
	XML.CloseTag("ALERTACTION");

	// Now create the tree and return
	return CreateFromXMLText(XML.GetXML(),NULL,true);
}

/*********************************************************************************

	bool CEMailAlertGroup::EditGroupAlert(int iUserID, int iGroupID, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType)

		Author:		Mark Howitt
        Created:	09/08/2005
        Inputs:		iUserID - The Id of the user who owns the alert
					iGroupID - The Id of the group the user wants to change the details for
					NotifyType - The new notification type for the alert. email, private or disabled
					AlertType - The new alert type for the group. normal or instant
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Changes the groups notification and alert types.

*********************************************************************************/
bool CEMailAlertGroup::EditGroupAlert(int iUserID, int iGroupID, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType)
{
	// Setup some locals
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEMailAlertGroup::EditGroupAlert","FailedToInitialiseStoredProcedure","Failed to initialise stored procedure!!!");
	}

	// Now call the procedure
	int iResult = 0;
	if (!SP.EditGroupAlert(iUserID,iGroupID,(int)NotifyType,(int)AlertType,iResult))
	{
		return SetDNALastError("CEMailAlertGroup::EditGroupAlert","FailedToEdotGroupAlert","Failed to edit group alert!!!");
	}

	// Now check to see what happened? As this procedure is using output params, we need to make sure we've
	// reached the end of the file. Only then will the output param be set to the correct value!
	while (!SP.IsEOF())
	{
		SP.MoveNext();
	}

	// Create the XML result
	CDBXMLBuilder XML;
	XML.OpenTag("ALERTACTION",true);
	XML.AddAttribute("ACTION","EDIT", true);
	XML.AddIntTag("RESULT",iResult);
	XML.AddIntTag("NOTIFYTYPE",(int)NotifyType);
	XML.AddIntTag("ALERTTYPE",(int)AlertType);
	XML.AddIntTag("GROUPEDITED",iGroupID);
	XML.CloseTag("ALERTACTION");

	// Now create the tree and return
	return CreateFromXMLText(XML.GetXML(),NULL,true);
}

/*********************************************************************************

	bool CEMailAlertGroup::RemoveGroupAlert(int iUserID, int iGroupID)

		Author:		Mark Howitt
        Created:	09/08/2005
        Inputs:		iUserID - The id of the user who owns the group
					iGroupID - The Id of the group you want to remove
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes a group alert for a given user

*********************************************************************************/
bool CEMailAlertGroup::RemoveGroupAlert(int iUserID, int iGroupID)
{
	// Setup some locals
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEMailAlertGroup::RemoveGroupAlert","FailedToInitialiseStoredProcedure","Failed to initialise stored procedure!!!");
	}

	// Now call the procedure
	if (!SP.RemoveGroupAlert(iUserID,iGroupID))
	{
		return SetDNALastError("CEMailAlertGroup::RemoveGroupAlert","FailedToRmoveAlertGroup","Failed to remove an alert group!!!");
	}

	// Create the XML result
	CDBXMLBuilder XML;
	XML.Initialise(NULL,&SP);
	XML.OpenTag("ALERTACTION",true);
	XML.AddAttribute("ACTION","REMOVE", true);

	// Did we actually succeed. Check to see if we've got results!
	if (!SP.IsEOF())
	{
		// It worked!
		XML.AddIntTag("RESULT",1);
		XML.DBAddIntTag("ITEMTYPE");
		XML.DBAddIntTag("ITEMID");
		XML.DBAddTag("ITEMNAME");
	}
	else
	{
		// We had a problem!
		XML.AddIntTag("RESULT",0);
		XML.AddIntTag("ITEMTYPE",0);
		XML.AddIntTag("ITEMID",0);
		XML.AddTag("ITEMNAME","Get it from the groupid!");
	}

	XML.AddIntTag("GROUPREMOVED",iGroupID);
	XML.CloseTag("ALERTACTION");

	// Now create the tree and return
	return CreateFromXMLText(XML.GetXML(),NULL,true);
}

/*********************************************************************************

	bool CEMailAlertGroup::GetAlertGroupsForUser(int iUserID, int iSiteID)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user to get the list for
					iSIteID - the id of the site that the groups should belong to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the alert groups for a user for a given site.

*********************************************************************************/
bool CEMailAlertGroup::GetAlertGroupsForUser(int iUserID, int iSiteID)
{
	// Setup some locals
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEMailAlertGroup::GetAlertGroupsForUser","FailedToInitialiseStoredProcedure","Failed to initialise stored procedure!!!");
	}

	// Now call the procedure
	if (!SP.GetGroupAlertsForUser(iUserID,iSiteID))
	{
		return SetDNALastError("CEMailAlertGroup::GetAlertGroupsForUser","FailedToGetGroupAlertsForUser","Failed to get all group alerts for user!!!");
	}

	// Create the XML result
	CDBXMLBuilder XML;
	XML.Initialise(NULL,&SP);
	XML.OpenTag("ALERTGROUPS",true);
	XML.AddIntAttribute("USERID",iUserID,true);

	// Put all the alerts into the xml
	while (!SP.IsEOF())
	{
		// Open the groups tag
		XML.OpenTag("GROUPALERT");
		XML.DBAddIntTag("GROUPID");
		XML.DBAddIntTag("ITEMID");
		XML.DBAddIntTag("ITEMTYPE");
		XML.DBAddTag("NAME");
		XML.DBAddIntTag("ISOWNER");
		XML.DBAddIntTag("NOTIFYTYPE");
		XML.DBAddIntTag("ALERTTYPE");
		XML.CloseTag("GROUPALERT");

		// Get the next result
		SP.MoveNext();
	}

	XML.CloseTag("ALERTGROUPS");

	// Now create the tree and return
	return CreateFromXMLText(XML.GetXML(),NULL,true);
}

/*********************************************************************************

	bool CEMailAlertGroup::EditGroupAlertsForUser(int iUserID, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType)

		Author:		James Pullicino
        Created:	18/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Changes settings for all groups of a user

*********************************************************************************/
bool CEMailAlertGroup::EditGroupAlertsForUser(int iUserID, int iSiteID, bool bOwned, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType)
{
	// Setup some locals
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEMailAlertGroup::EditGroupAlertsForUser","FailedToInitialiseStoredProcedure","Failed to initialise stored procedure!!!");
	}

	// Now call the procedure
	int iResult = 0;
	if (!SP.EditGroupAlerts(iUserID,iSiteID,(int)bOwned,(int)NotifyType,(int)AlertType,iResult))
	{
		return SetDNALastError("CEMailAlertGroup::EditGroupAlertsForUser","FailedToEditGroups","Failed to edit the users groups alerts!!!");
	}

	// Now check to see what happened? As this procedure is using output params, we need to make sure we've
	// reached the end of the file. Only then will the output param be set to the correct value!
	while (!SP.IsEOF())
	{
		SP.MoveNext();
	}

	// Create the XML result
	CDBXMLBuilder XML;
	XML.OpenTag("ALERTACTION",true);
	XML.AddAttribute("ACTION","EDIT", true);
	XML.AddIntTag("RESULT",iResult);
	XML.AddIntTag("NOTIFYTYPE",(int)NotifyType);
	XML.AddIntTag("ALERTTYPE",(int)AlertType);
	if (bOwned)
	{
		XML.AddTag("ITEMSEDITED","OWNED");
	}
	else
	{
		XML.AddTag("ITEMSEDITED","NONOWNED");
	}
	XML.CloseTag("ALERTACTION");

	// Now create the tree and return
	return CreateFromXMLText(XML.GetXML(),NULL,true);
}

/*********************************************************************************

	bool CEMailAlertGroup::HasGroupAlertOnItem(int iUserID, int iSiteID, CEmailAlertList::eItemType ItemType, int iItemID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	iGroupID - ID of group alert, or zero if no groupalerts.
        Returns:	false on fail
        Purpose:	Get whether user has a group alert set on an item

*********************************************************************************/

bool CEMailAlertGroup::HasGroupAlertOnItem(int & iGroupID, int iUserID, int iSiteID, CEmailAlertList::eItemType ItemType, int iItemID)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(SP))
	{
		TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() m_InputContext.InitialiseStoredProcedureObject() failed");
		return false;
	}

	switch(ItemType) {

	case CEmailAlertList::IT_H2G2:
		
		if(!SP.GetArticleGroupAlertID(iUserID, iSiteID, iItemID))
		{
			TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() SP.GetArticleGroupAlertID() failed");
			return false;
		}

		break;

	case CEmailAlertList::IT_CLUB:
		
		if(!SP.GetClubGroupAlertID(iUserID, iSiteID, iItemID))
		{
			TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() SP.GetClubGroupAlertID() failed");
			return false;
		}

		break;

	case CEmailAlertList::IT_NODE:

		if(!SP.GetNodeGroupAlertID(iUserID, iSiteID, iItemID))
		{
			TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() SP.GetNodeGroupAlertID() failed");
			return false;
		}

		break;

	case CEmailAlertList::IT_FORUM:

		if(!SP.GetForumGroupAlertID(iUserID, iSiteID, iItemID))
		{
			TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() SP.GetForumGroupAlertID() failed");
			return false;
		}

		break;

	case CEmailAlertList::IT_THREAD:

		if(!SP.GetThreadGroupAlertID(iUserID, iSiteID, iItemID))
		{
			TDVASSERT(false, "CEMailAlertGroup::HasGroupAlertOnItem() SP.GetThreadGroupAlertID() failed");
			return false;
		}

		break;

	default:
		TDVASSERT(false, "CEMailAlertGroup::HasGroupAlert invalid ItemType");
		return false;
	}
	
	iGroupID = 0;
	if(!SP.IsEOF())
	{
		iGroupID = SP.GetIntField("GroupID");
	}

	return true;
}