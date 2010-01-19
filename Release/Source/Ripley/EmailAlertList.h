#pragma once
#include ".\XMLObject.h"

class CEmailAlertList :	public CXMLObject
{
public:
	CEmailAlertList(CInputContext& inputContext);
	virtual ~CEmailAlertList(void);

	enum eItemType
	{
		// DO NOT CHANGE THE ORDER OF THE TYPES!!! AS THEY MATCH DATABASE VALUES!!!
		// ONLY ADD TO THE END OF THE ENUMS
		// IF YOU DO ADD A TYPE, UPDATE THE STOREDPROCEDURE 'sp_SetItemTypeValInternal'
		IT_ALL = 0,
		IT_NODE,
		IT_H2G2,
		IT_CLUB,
		IT_FORUM,
		IT_THREAD,
		IT_POST,
		IT_USER,
		IT_VOTE,
		IT_LINK,
		IT_TEAM,
		IT_PRIVATEFORUM,
		IT_CLUB_MEMBERS,
		IT_URL
	};

	enum eNotifyType
	{
		// DO NOT CHANGE THE ORDER OF THE TYPES!!! AS THEY MATCH DATABASE VALUES!!!
		// ONLY ADD TO THE END OF THE ENUMS
		NT_NONE = 0,
		NT_EMAIL,
		NT_PRIVATEMESSAGE,
		NT_DISABLED
	};

	enum eEMailListType
	{
		LT_NONE = 0,
		LT_EMAILALERT,
		LT_INSTANTEMAILALERT
	};

protected:
	bool GetAllItemsForAlertList(CTDVString& sGUID, CTDVString& sXML, eEMailListType EMailListType);
	bool GetListGUIDForUserID(eEMailListType EMailListType, int iUserID, int iSiteID, bool bCreateList, CTDVString& sGUID);

	bool CreateEMailAlertList(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sNewGUID);

	bool AddItemToEmailList(eEMailListType EMailListType, eItemType ItemType, int iItemID, int iUserID, int iSiteID, eNotifyType NotifyType, bool bCreateList = true);
	bool CreateAddItemXML(eItemType ItemType, eEMailListType ListType, const TDVCHAR* psGUID, int iUserID, int iItemID, int iSiteID, bool bCreatedList, eNotifyType NotifyType, int iMemberID);

	bool CreateRemoveItemXML(CStoredProcedure* pSP, eEMailListType EMailListType, const TDVCHAR* psGUID, int iUserID, int iSiteID);
	bool RemoveItemFromEmailList(eEMailListType EMailListType, int iMemberID, int iUserID, int iSiteID);

	bool GetEMailAlertSubscriptionStatusForUser(int iUserID, int iItemID, eItemType ItemType);

	bool GetItemDetailsFromEMailAlertMemberID(eEMailListType EMailListType, int iMemberID, CTDVString* psGUID, eItemType* pItemType, int* piItemID, eNotifyType* pNotifyType);

public:
	bool CreateNormalEMailAlertList(int iUserID, int iSiteID);
	bool CreateInstantEMailAlertList(int iUserID, int iSiteID);
	
	bool GetEmailListForUser(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sGUID, bool bShowUserInfo = false);

	bool AddCategoryToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iNodeID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddCategoryToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iNodeID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddArticleToUsersNormalEmailAlertList(int iUserID, int iSiteID, int ih2g2ID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddArticleToUsersInstantEmailAlertList(int iUserID, int iSiteID, int ih2g2ID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddForumToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iForumID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddForumToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iForumID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddClubToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iClubID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddClubToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iClubID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddPostToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iPostID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddPostToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iPostID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddThreadToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iThreadID, eNotifyType NotifyType, bool bCreateList = false);
	bool AddThreadToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iThreadID, eNotifyType NotifyType, bool bCreateList = false);

	bool RemoveItemFromNormalEmailList(int iMemberID, int iUserID, int iSiteID);
	bool RemoveItemFromInstantEmailList(int iMemberID, int iUserID, int iSiteID);

	bool ChangeItemsNotificationType(eEMailListType EMailListType, int iMemberID, int iUserID, int iSiteID, eNotifyType NotifyType);
	bool ChangeItemMembersListType(int iUserID, int iSiteID, int iMemberID, eEMailListType CurrentListType, eEMailListType NewListType);

	bool GetUserEMailAlertSubscriptionForCategory(int iUserID, int iNodeID);
	bool GetUserEMailAlertSubscriptionForArticleAndForum(int iUserID, int iArticleID);
	bool GetUserEMailAlertSubscriptionForClubArticleAndForum(int iUserID, int iClubID);
	bool GetUserEMailAlertSubscriptionForForumAndThreads(int iUserID, int iForumID);
	bool GetUserEMailAlertSubscriptionForThread(int iUserID, int iThreadID);
	bool GetUserEMailAlertSubscriptionForPost(int iUserID, int iPostID);

	int GetItemTypeFromEnum(eItemType ItemType);
	int GetListTypeFromEnum(eEMailListType ListType);

	bool CheckForumPermissionsForUser(int iItemID, eItemType ItemType, int iUserID, bool& bIsUsersPrivateForum, bool bCheckInstantAlerts = true);

	bool GetEmailStats(int iSiteID);

	bool DisableUserAlerts(int iUserID, CTDVString sGUID);
};
