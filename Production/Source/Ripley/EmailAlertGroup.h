#pragma once
#include "xmlobject.h"
#include ".\EmailAlertList.h"

class CEMailAlertGroup :	public CXMLObject
{
public:
	CEMailAlertGroup(CInputContext& InputContext);
	virtual ~CEMailAlertGroup(void);

public:
	// Add alert functions
	bool AddItemGroupAlert(int iUserID, int iSiteID, int iItemID, CEmailAlertList::eItemType ItemType/*, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType*/);

	// Edit alert function
	bool EditGroupAlert(int iUserID, int iGroupID, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType);

	// Edit multiple alerts function
	bool EditGroupAlertsForUser(int iUserID, int iSiteID, bool bOwned, CEmailAlertList::eNotifyType NotifyType, CEmailAlertList::eEMailListType AlertType);

	// Remove alert function
	bool RemoveGroupAlert(int iUserID, int iGroupID);

	// Get the groups details
	bool GetAlertGroupsForUser(int iUserID, int iSiteID);

	// Get whether user has a group alert set on an item
	bool HasGroupAlertOnItem(int & iGroupID, int iUserID, int iSiteID, CEmailAlertList::eItemType ItemType, int iItemID);
};
