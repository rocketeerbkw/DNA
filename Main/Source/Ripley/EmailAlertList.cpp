#include "stdafx.h"
#include ".\emailalertlist.h"
#include ".\tdvassert.h"
#include ".\user.h"
#include ".\StoredProcedure.h"

CEmailAlertList::CEmailAlertList(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CEmailAlertList::~CEmailAlertList(void)
{
}

/*********************************************************************************

	bool CEmailAlertList::GetListGUIDForUserID(eEMailListType EMailListType, int iUserID, int iSiteID, bool bCreateList, CTDVString& sGUID)

		Author:		Mark Howitt
        Created:	13/08/2004
        Inputs:		iUserID - the id of the user you want to get the list for.
					iSiteID - the id of the site the list belongs to.
        Outputs:	sGUID - The actual ID for the list
        Returns:	true if ok, false if not
        Purpose:	Gets the users email alert list GUID for a given site

*********************************************************************************/
bool CEmailAlertList::GetListGUIDForUserID(eEMailListType EMailListType, int iUserID, int iSiteID, bool bCreateList, CTDVString& sGUID)
{
	// Check for a valid List Type param
	if (EMailListType != LT_EMAILALERT && EMailListType != LT_INSTANTEMAILALERT)
	{
		// Invalid list type!
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","InvalidListType","Invalid EMail list type given!!!!");
	}

	// Make sure we've been given a valid user
	if (iUserID == 0)
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","NoUserIDGiven","No User ID Given");
	}

	// Setup a stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","FailedToInitStoredProcedure","Failed to intialise Stored Procedure");
	}

	// Now get the list for the given list id
	if (!SP.GetEMailListsForUser(iUserID,iSiteID,(int)EMailListType))
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","GetUserListsFailed","Failed getting lists for user");
	}

	// Check to see if we got it?
	if (SP.IsEOF())
	{
		// Check to see if we want to create a new list?
		if (bCreateList)
		{
			// Try to create the new list
			if (!CreateEMailAlertList(EMailListType,iUserID,iSiteID,sGUID))
			{
				// We had a problem!
				return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","FailedToCreateUsersEMailList","Failed to create the users email list!");
			}
		}

		// Didn't find a list! Not a problem, so return true!
		return true;
	}

	// Get the Id from the results
	if (EMailListType == LT_EMAILALERT)
	{
		SP.GetField("emailalertlistid",sGUID);
	}
	else
	{
		SP.GetField("instantemailalertlistid",sGUID);
	}

	// Remove the dashes from the GUID as this will be used to form the URL later.
	sGUID.Replace("-","");

	return true;
}

/*********************************************************************************

	bool CEmailAlertList::GetEmailListForUser(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sGUID, bool bShowUserInfo, bool bGUIDOnly)

		Author:		Mark Howitt
        Created:	12/08/2004
        Inputs:		iUserID - The id of the user you want to get the list for
					iSiteID - The site that the list should be got for
					bShowUserInfo - A Flag that when set will insert the user details for the list
        Outputs:	sGUID - The GUID for the list
        Returns:	true if ok, false if not
        Purpose:	Finds the GUID of the list that the user owns on a given site.

*********************************************************************************/
bool CEmailAlertList::GetEmailListForUser(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sGUID, bool bShowUserInfo)
{
	// Check for a valid List Type param
	if (EMailListType != LT_EMAILALERT && EMailListType != LT_INSTANTEMAILALERT)
	{
		// Invalid list type!
		return SetDNALastError("CEmailAlertList::GetEmailListForUser","InvalidListType","Invalid EMail list type given!!!!");
	}

	// Make sure we've been given a valid user
	if (iUserID == 0)
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","NoUserIDGiven","No User ID Given");
	}

	// Setup a stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","FailedToInitStoredProcedure","Failed to intialise Stored Procedure");
	}

	// Now get the list for the given list id
	if (!SP.GetEMailListsForUser(iUserID,iSiteID,(int)EMailListType))
	{
		return SetDNALastError("CEmailAlertList::GetListGUIDForUserID","GetUserListsFailed","Failed getting lists for user");
	}

	// Ok, Lets display the list if we have one!
	// Now get all the info from the results
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	bool bOk = XML.OpenTag("EMAILALERTLIST");
	bOk = bOk && XML.AddIntTag("EMailListType",EMailListType);
	bOk = bOk && XML.AddIntTag("SHOWUSERINFO",bShowUserInfo);
	bOk = bOk && XML.AddIntTag("LISTSUSERID",iUserID);
	if (!SP.IsEOF() && bOk)
	{
		bOk = bOk && XML.OpenTag("LIST");
		if (EMailListType == LT_EMAILALERT)
		{
			bOk = bOk && SP.GetField("emailalertlistid",sGUID);
		}
		else
		{
			bOk = bOk && SP.GetField("instantemailalertlistid",sGUID);
		}
		// Remove the dashes from the GUID as this will be used to form the URL later.
		sGUID.Replace("-","");
		bOk = bOk && XML.AddTag("GUID",sGUID);
		bOk = bOk && XML.OpenTag("OWNER");
		if (bShowUserInfo)
		{
			bOk = bOk && XML.DBAddTag("UserID");
			bOk = bOk && XML.DBAddTag("UserName");
			bOk = bOk && XML.DBAddTag("FirstNames",NULL,false);
			bOk = bOk && XML.DBAddTag("LastName",NULL,false);
			bOk = bOk && XML.DBAddTag("Title",NULL,false);
			bOk = bOk && XML.DBAddTag("SiteSuffix",NULL,false);
		}
		bOk = bOk && XML.CloseTag("OWNER");
		bOk = bOk && XML.DBAddDateTag("CreatedDate",NULL,true,true);
		bOk = bOk && XML.DBAddDateTag("LastUpdated",NULL,true,true);

		// Now get all the items that the user has tagged to be alerted on
		bOk = bOk && GetAllItemsForAlertList(sGUID,sXML,EMailListType);
        bOk = bOk && XML.CloseTag("LIST");
	}

	// Close the TAG
	bOk = bOk && XML.CloseTag("EMAILALERTLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CEmailAlertList::GetEmailListForUser","FailedToGetLists","Failed creating XML");
	}

	// Create the page a return
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CEmailAlertList::GetAllItemsForAlertList(CTDVString& sGUID, CTDVString& sXML)

		Author:		Mark Howitt
        Created:	12/08/2004
        Inputs:		sGUID - The guid of the list you want to get the items for.
        Outputs:	sXML - A String that will take the result XML
        Returns:	true if ok, false if not
        Purpose:	Gets the details for all the items that belong to a given list

*********************************************************************************/
bool CEmailAlertList::GetAllItemsForAlertList(CTDVString& sGUID, CTDVString& sXML, eEMailListType EMailListType)
{
	// Check to make sure we we're given a valid pointer and it initialises ok
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::GetAllItemsForAlertList","FailedToInitStoredProcedure","NULL Pointer or Failed to intialise Stored Procedure");
	}

	// Get the current details for the given List
	if (!SP.GetEMailListForEmailAlertListID(EMailListType,sGUID))
	{
		return SetDNALastError("CEmailAlertList::GetAllItemsForAlertList","GetListDetailsFailed","Failed getting list details");
	}

	// Setup the cached file name from the guid
	CTDVString sCachedXML;
	CTDVString sCachedListName = sGUID + "-0.txt";

	// Check to make sure we actually have some results. If we don't, then there are no items in the list!
	if (!SP.IsEOF())
	{
		// Get the last updated date and add an hour. This will be the expiry date!
		CTDVDateTime dExpires = SP.GetDateField("ItemListLastUpdated");

		// See if we're going to use the cached version?
		if (CacheGetItem("List", sCachedListName, &dExpires, &sCachedXML))
		{
			// CreateFromCacheText might fail if e.g. the cached text
			// is garbled somehow, in which case proceed with getting
			// the entry from the DB
			if (CreateFromCacheText(sCachedXML))
			{
				// Update the relative dates and insert it into the XML
				UpdateRelativeDates();
				sXML << sCachedXML;
				return true;
			}

			// Make sure there's nothing bad left in the string!
			sCachedXML.Empty();
		}
	}

	// Setup the XML Builder and open the alertLists tag
	CDBXMLBuilder XML;
	XML.Initialise(&sCachedXML,&SP);
	bool bOk = XML.OpenTag("ALERTLIST");
	
	// Go through the results getting all the entries
	int iItemType = 0;
	while (bOk && !SP.IsEOF())
	{
		// Get the Item Info
		bOk = bOk && XML.OpenTag("ALERTITEM");
		bOk = bOk && XML.DBAddIntTag("MEMBERID");
		bOk = bOk && XML.DBAddIntTag("NOTIFYTYPE");
		bOk = bOk && XML.DBAddIntTag("ITEMID");
		bOk = bOk && XML.DBAddIntTag("ITEMTYPE",NULL,true,&iItemType);
		bOk = bOk && XML.DBAddTag("ITEMDESCRIPTION");
		if (iItemType == IT_POST || iItemType == IT_THREAD)
		{
			bOk = bOk && XML.DBAddTag("ITEMEXTRAINFO","FORUMID",false);
		}
		bOk = bOk && XML.CloseTag("ALERTITEM");
		SP.MoveNext();
	}

	// Close the Category Lists tag
	bOk = bOk && XML.CloseTag("ALERTLIST");

	// If we're ok, put the list XML into the output XML
	if (bOk)
	{
		sXML << sCachedXML;
	}

	// Check for errors!
	if (!bOk || !CreateFromXMLText(sCachedXML,NULL,true))
	{
		return SetDNALastError("CEmailAlertList","FailedToGetLists","Failed creating XML");
	}

	// Cache the list to file and insert the XML into the provided string!
	// Create a cached version of this object
	if (!CachePutItem("List", sCachedListName, sCachedXML))
	{
		TDVASSERT(false,"Failed to create cached version of XML");
	}
	return bOk;
}

/*********************************************************************************

	bool CEmailAlertList::CreateEMailAlertList(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sNewGUID)

		Author:		Mark Howitt
        Created:	12/08/2004
        Inputs:		iUserID - The user who will own the new list.
					iSiteID - The site on which the list lives.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates a new EMail alert list for the user on the given site.

*********************************************************************************/
bool CEmailAlertList::CreateEMailAlertList(eEMailListType EMailListType, int iUserID, int iSiteID, CTDVString& sNewGUID)
{
	// First check to see if the user already ahs a list! Users can only have one list!
	if (!GetListGUIDForUserID(EMailListType, iUserID, iSiteID, false, sNewGUID))
	{
		// We had a problem!
		return false;
	}

	// Check to see if the GUID is empty?
	if (!sNewGUID.IsEmpty())
	{
		// Already got list! return false!
		return SetDNALastError("CEmailAlertList::CreateEMailAlertList","UserAlreadyHasList","User already has a list");
	}

	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::CreateEMailAlertList","FailedToInitStoredProcedure","NULL Pointer or Failed to intialise Stored Procedure");
	}

	// Now create the list
	if (!SP.CreateEmailAlertList(iUserID,iSiteID,(int)EMailListType))
	{
		return SetDNALastError("CEmailAlertList::CreateEMailAlertList","CreateNewListFailed","Failed creating new list");
	}

	// Now get the details
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("CREATEDEMAILALERTLIST",true);
	bOk = bOk && AddXMLIntAttribute("EMailListType",(int)EMailListType);
	bOk = bOk && SP.GetField("EMailListID",sNewGUID);
	// Remove the dashes from the GUID as this will be used to form the URL later.
	sNewGUID.Replace("-","");
	bOk = bOk && AddXMLAttribute("GUID",sNewGUID,true);
	bOk = bOk && CloseXMLTag("CREATEDEMAILALERTLIST");

	// Check for errors!
	if (!bOk)
	{
		return SetDNALastError("CEmailAlertList::CreateEMailAlertList","CreateNewEMailAlertListFailed","Failed creating XML");
	}

	// Create the new tree
	return CreateFromXMLText(sXML,NULL,true);
}

// Purpose:	Wrapper function for creating normal email lists
bool CEmailAlertList::CreateNormalEMailAlertList(int iUserID, int iSiteID)
{
	CTDVString sNewGUID;
	return CreateEMailAlertList(LT_EMAILALERT,iUserID,iSiteID,sNewGUID);
}

// Purpose:	Wrapper function for creating instant email lists
bool CEmailAlertList::CreateInstantEMailAlertList(int iUserID, int iSiteID)
{
	CTDVString sNewGUID;
	return CreateEMailAlertList(LT_INSTANTEMAILALERT,iUserID,iSiteID,sNewGUID);
}

/*********************************************************************************

	bool CEmailAlertList::CheckForumPermissionsForUser(int iItemID, eItemType ItemType, int iUserID, bool& bIsUsersPrivateForum, bool bCheckInstantAlerts)

		Author:		Mark Howitt
        Created:	17/11/2004
        Inputs:		iItemID - The id of the item you want to check for.
					ItemType - the type of item you want to check the permissions of. FORUM, THREAD or POST
					iUserID - The Id of the user you want to check for.
					bCheckInstantAlerts - If set true, then we also check the AlertInstantly flag along with the permissions.
        Outputs:	-
        Returns:	true if the user is authorised, false if not.
        Purpose:	Checks that the given user can subscribe to a given forum.

*********************************************************************************/
bool CEmailAlertList::CheckForumPermissionsForUser(int iItemID, eItemType ItemType, int iUserID, bool& bIsUsersPrivateForum, bool bCheckInstantAlerts)
{
	// Initialise the stored procecdure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","FailedToInitialiseSP","Failed to intialise the stored procedure");
	}

	// Get the details for the given forum
	if (!SP.GetForumDetails(iItemID,ItemType,iUserID) || SP.IsEOF())
	{
		return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","FailedToGetForumPermissions","Failed getting forum details!");
	}

	// Now check the alert status
	if (bCheckInstantAlerts && SP.GetIntField("AlertInstantly") == 0)
	{
		return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","ForumDoesNotSupportInstantAlerts","Forum Does Not Support Instant Alerts!");
	}

	// Now check to see if it's the users private forum
	bIsUsersPrivateForum = (SP.GetIntField("UsersPrivateForum") != 0);

	// Get the forum id
	int iForumID = SP.GetIntField("forumid");
	int iThreadID = (ItemType == IT_THREAD) ? iItemID : SP.GetIntField("threadid");

	// Reinitialise the storedprocedure and check the permissions for the forum in relation to the current user.
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","FailedToInitialiseSP","Failed to intialise the stored procedure");
	}
	bool bCanRead = false;
	bool bCanWrite = false;
	if (ItemType == IT_FORUM)
	{
		if (!SP.GetForumPermissions(iUserID, iForumID, bCanRead, bCanWrite))
		{
			return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","FailedCheckingUserPermissions","Failed to get users permissions");
		}
	}
	else
	{
		if (!SP.GetThreadPermissions(iUserID, iThreadID, bCanRead, bCanWrite))
		{
			return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","FailedCheckingUserPermissions","Failed to get users permissions");
		}
	}

	// If the user cannot read the forum, then they cannot subscribe to it!
	if (!bCanRead)
	{
		return SetDNALastError("CEmailAlertList::CheckForumPermissionsForUser","UserNotAuthorised","User does not have the correct permissions");
	}

	// The user is able to subscribe to this forum!
	return true;
}

/*********************************************************************************

	bool CEmailAlertList::AddItemToEmailList(eEMailListType EMailListType, eItemType ItemType, int iItemID, int iUserID, int iSiteID, eNotifyType NotifyType, bool bCreateList)

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		EMailLIstType - The type of email list you want to add the item to.
					ItemType - The type of item you want to add to the list.
					iItemID - The ID of the item you want to add.
					iUserID - the ID of the user who owns the list.
					iSiteID - The ID of the site the list belongs to.
					bCreateList - A flag that when set to 1 will create the list if it not already created.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Adds a given item to a given list. Private function with wrapper functions.

*********************************************************************************/
bool CEmailAlertList::AddItemToEmailList(eEMailListType EMailListType, eItemType ItemType, int iItemID, int iUserID, int iSiteID, eNotifyType NotifyType, bool bCreateList)
{
	// Check to make sure the users email is validated
	CUser CurrentUser(m_InputContext);
	bool bValidEMail = false;
	if (!CurrentUser.IsUsersEMailVerified(bValidEMail))
	{
		// Failed to get the users details!!!!
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToAddItem","Failed getting User details!");
	}

	// Check the valid email flag
	if (!bValidEMail)
	{
		// Users email is invalid!
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToAddItem","Users EMail Address is not validated!");
	}

	// Make sure we've been given a valid id!
	if (iItemID == 0)
	{
		// Invalid Item ID!
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","InvalidItemID","Invalid Item ID Given!");
	}

	// Get the id for the users list
	CTDVString sGUID;
	if (!GetListGUIDForUserID(EMailListType,iUserID,iSiteID,bCreateList,sGUID))
	{
		// Something went wrong!
		return false;
	}

	// Check to see if we're trying to add a forum, Thread or Post.
	// Check that the forum can be used in instant emails. Also check to see if the current user has permissions to 
	// subscribe to the forum!
	bool bIsUsersPrivateForum = false;
	if ((ItemType == IT_FORUM || ItemType == IT_THREAD || ItemType == IT_POST) && (EMailListType == LT_INSTANTEMAILALERT || NotifyType == NT_PRIVATEMESSAGE))
	{
		// Check the forum permissions for the user
		if (!CheckForumPermissionsForUser(iItemID,ItemType,iUserID,bIsUsersPrivateForum))
		{
			// User not authorised or a problem occured!!
			return false;
		}
	}

	// Check to see if they are trying to put a private message notification on there own private forum!
	if (bIsUsersPrivateForum && NotifyType == NT_PRIVATEMESSAGE)
	{
		// Cannot put an instant private alert on a private forum!
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","CannotPvtMsgAlertOnUsersPvtMessages","Cannot Set Pvt Msg Alerts on Users Private Forums!");
	}

	// Initialise the stored procecdure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToInitialiseSP","Failed to intialise the stored procedure");
	}

	// Now get the list for the given list id
	if (!SP.AddItemToEmailAlertList(iItemID,(int)ItemType,(int)NotifyType,sGUID,(int)EMailListType) || SP.IsNULL("Result") || SP.GetIntField("Result") == 0)
	{
		return SetDNALastError("CEmailAlertList::AddItemToEmailList","AddItemToListFailed","Failed adding item to list");
	}

	// Get the new memberid from the result set
	int iMemberID = SP.GetIntField("MemberID");

	// Now create the XML for the action
	return CreateAddItemXML(ItemType,EMailListType,sGUID,iUserID,iItemID,iSiteID,bCreateList,NotifyType,iMemberID);
}

/*********************************************************************************

	bool CEmailAlertList::CreateAddItemXML(eItemType ItemType, eEMailListType EMailListType, const TDVCHAR* psGUID,
										   int iUserID,	int iItemID, int iSiteID, bool bCreatedList, eNotifyType NotifyType, int iMemberID)

		Author:		Mark Howitt
        Created:	19/10/2004
        Inputs:		ItemType - The type of item that has been added.
					EMailListType - The type of list the item was added to.
					psGUID - A pointer to the string that holds the GUID for the list.
					iUserID - The ID of the user that added the item.
					iItemID - The ID of the item that was added.
					iSiteID - The ID of the site that the list belongs to.
					bCreatedList - A flag that states whether the list had to be created to add the item to.
					NotifyType - The type of notification this item uses.
					iMemberID - The new MemberID of the Item.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates the xml and then the tree for the add action for the given item.

*********************************************************************************/
bool CEmailAlertList::CreateAddItemXML(eItemType ItemType, eEMailListType EMailListType, const TDVCHAR* psGUID,
									   int iUserID, int iItemID, int iSiteID, bool bCreatedList, eNotifyType NotifyType, int iMemberID)
{
	// Write a bit of XML Result
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	bool bOk = true;

	// Now add the xml for the given action and item type
	bOk = bOk && XML.OpenTag("ADDEDITEM");
	bOk = bOk && XML.AddTag("GUID",psGUID);
	bOk = bOk && XML.AddIntTag("MEMBERID",iMemberID);
	bOk = bOk && XML.AddIntTag("EMailListType",(int)EMailListType);
	bOk = bOk && XML.AddIntTag("USERID",iUserID);
	bOk = bOk && XML.AddIntTag("ITEMID",iItemID);
	bOk = bOk && XML.AddIntTag("ITEMTYPE",(int)ItemType);
	bOk = bOk && XML.AddIntTag("SITEID",iSiteID);
	bOk = bOk && XML.AddIntTag("CREATEDLIST",bCreatedList);
	bOk = bOk && XML.CloseTag("ADDEDITEM");

	// Create the XML and Check to make sure everything went ok
	bOk = bOk && CreateFromXMLText(sXML,NULL,true);
	if (!bOk)
	{
		// Set the error string
		SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToCreateXML","Failed creating XML!");
	}

	// Return the verdict!
	return bOk;
}

// Purpose:	Wrapper function for adding nodes to the normal email lists
bool CEmailAlertList::AddCategoryToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iNodeID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_NODE,iNodeID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding nodes to the instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddCategoryToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iNodeID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_NODE,iNodeID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding articles to email lists. Ensures correct enums are used.
bool CEmailAlertList::AddArticleToUsersNormalEmailAlertList(int iUserID, int iSiteID, int ih2g2ID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_H2G2,ih2g2ID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding articles to instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddArticleToUsersInstantEmailAlertList(int iUserID, int iSiteID, int ih2g2ID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_H2G2,ih2g2ID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Forums to email lists. Ensures correct enums are used.
bool CEmailAlertList::AddForumToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iForumID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_FORUM,iForumID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Forums to instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddForumToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iForumID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_FORUM,iForumID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Clubs to email lists. Ensures correct enums are used.
bool CEmailAlertList::AddClubToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iClubID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_CLUB,iClubID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Clubs to instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddClubToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iClubID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_CLUB,iClubID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Post to email lists. Ensures correct enums are used.
bool CEmailAlertList::AddPostToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iPostID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_POST,iPostID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Post to instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddPostToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iPostID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_POST,iPostID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Thread to email lists. Ensures correct enums are used.
bool CEmailAlertList::AddThreadToUsersNormalEmailAlertList(int iUserID, int iSiteID, int iThreadID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_EMAILALERT,IT_THREAD,iThreadID,iUserID,iSiteID,NotifyType,bCreateList);
}

// Purpose:	Wrapper function for adding Thread to instant email lists. Ensures correct enums are used.
bool CEmailAlertList::AddThreadToUsersInstantEmailAlertList(int iUserID, int iSiteID, int iThreadID, eNotifyType NotifyType, bool bCreateList)
{
	return AddItemToEmailList(LT_INSTANTEMAILALERT,IT_THREAD,iThreadID,iUserID,iSiteID,NotifyType,bCreateList);
}


/*********************************************************************************

	bool CEmailAlertList::RemoveItemFromEmailList(eEMailListType EMailListType, eItemType ItemType, int iItemID, int iUserID, int iSiteID, eNotifyType NotifyType)

		Author:		Mark Howitt
        Created:	16/09/2004
        Inputs:		EMailLIstType - The type of email list you want to remove the item to.
					ItemType - The type of item you want to remove to the list.
					iItemID - The ID of the item you want to remove.
					iUserID - the ID of the user who owns the list.
					iSiteID - The ID of the site the list belongs to.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Removes a given item from a given list. Private function with wrapper functions.

*********************************************************************************/
bool CEmailAlertList::RemoveItemFromEmailList(eEMailListType EMailListType, int iMemberID, int iUserID, int iSiteID)
{
	// Get the id for the users list
	CTDVString sGUID;
	if (!GetListGUIDForUserID(EMailListType,iUserID,iSiteID,false,sGUID))
	{
		// Something went wrong!
		return false;
	}

	// Setup the StoredProcedure
	// Initialise the procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::RemoveItemFromEmailList","FailedToInitStoredProcedure","NULL Pointer or Failed to intialise Stored Procedure");
	}

	// Now get the list for the given list id
	if (!SP.RemoveItemFromEmailList(iMemberID,sGUID,(int)EMailListType))
	{
		return SetDNALastError("CEmailAlertList::RemoveItemFromEmailList","RemoveItemFromListFailed","Failed removing item from list");
	}

	// Check to see if we deleted anything!
	if (SP.IsNULL("Deleted") || SP.GetIntField("Deleted") == 0)
	{
		// We had a problem!
		return SetDNALastError("CEmailAlertList::RemoveItemFromEmailList","FailedToRemoveItem","Requested Item to delete does not exsist!");
	}

	// Now create the XML for the action
	return CreateRemoveItemXML(&SP,EMailListType,sGUID,iUserID,iSiteID);
}

/*********************************************************************************

	bool CEmailAlertList::CreateRemoveItemXML(CStoredProcedure* pSP, eEMailListType EMailListType, const TDVCHAR* psGUID, int iUserID, int iSiteID)

		Author:		Mark Howitt
        Created:	19/10/2004
        Inputs:		pSP - A pointer to a stored procedure object that preformed the remove item.
					EMailListType - the type of list the item belongs to.
					psGUID - The GUID for the list that the item belonged to0.
					iUserID - the id of the user who owns the list.
					iSiteID - The site on which the item list belongs.
		Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates the xml and then the tree for the remove item action for the given item.

*********************************************************************************/
bool CEmailAlertList::CreateRemoveItemXML(CStoredProcedure* pSP, eEMailListType EMailListType, const TDVCHAR* psGUID, int iUserID, int iSiteID)
{
	// Check the pointer!
	if (pSP == NULL)
	{
		// Set the error string
		SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToCreateXML","Failed creating XML!");
	}

	// Write a bit of XML Result
	CTDVString sXML, sActionType, sItemName;
	InitialiseXMLBuilder(&sXML,pSP);
	bool bOk = true;

	// Get the values from the Stored Procedure
	int iItemType = pSP->GetIntField("ItemType");

	// Check to see what Item type we are dealing with
	if (iItemType == IT_NODE)
	{
		sActionType = "REMOVEDNODE";
		sItemName = "NODEID";
	}
	else if (iItemType == IT_H2G2)
	{
		sActionType = "REMOVEDARTICLE";
		sItemName = "H2G2ID";
	}
	else if (iItemType == IT_FORUM)
	{
		sActionType = "REMOVEDFORUM";
		sItemName = "FORUMID";
	}
	else if (iItemType == IT_CLUB)
	{
		sActionType = "REMOVEDCLUB";
		sItemName = "CLUBID";
	}
	else if (iItemType == IT_THREAD)
	{
		sActionType = "REMOVEDTHREAD";
		sItemName = "THREADID";
	}
	else if (iItemType == IT_POST)
	{
		sActionType = "REMOVEDPOST";
		sItemName = "POSTID";
	}

	// Now add the xml for the given action and item type
	bOk = bOk && OpenXMLTag(sActionType);
	bOk = bOk && AddXMLTag("GUID",psGUID);
	bOk = bOk && AddXMLIntTag("EMailListType",(int)EMailListType);
	bOk = bOk && AddXMLIntTag("USERID",iUserID);
	bOk = bOk && AddDBXMLIntTag("ITEMID",sItemName);
	bOk = bOk && AddXMLIntTag("SITEID",iSiteID);
	bOk = bOk && CloseXMLTag(sActionType);

	// Create the XML and Check to make sure everything went ok
	bOk = bOk && CreateFromXMLText(sXML);
	if (!bOk)
	{
		// Set the error string
		SetDNALastError("CEmailAlertList::AddItemToEmailList","FailedToCreateXML","Failed creating XML!");
	}

	// Return the verdict!
	return bOk;
}

// Purpose:	wrapper function to remove nodes from email lists. Ensures correct enums are used.
bool CEmailAlertList::RemoveItemFromNormalEmailList(int iMemberID, int iUserID, int iSiteID)
{
	return RemoveItemFromEmailList(LT_EMAILALERT,iMemberID,iUserID,iSiteID);
}

// Purpose:	wrapper function to remove nodes from email lists. Ensures correct enums are used.
bool CEmailAlertList::RemoveItemFromInstantEmailList(int iMemberID, int iUserID, int iSiteID)
{
	return RemoveItemFromEmailList(LT_INSTANTEMAILALERT,iMemberID,iUserID,iSiteID);
}

/*********************************************************************************

	bool CEmailAlertList::ChangeItemsNotificationType(eEMailListType EMailListType, int iMemberID, int iUserID, int iSiteID, eNotifyType NotifyType)

		Author:		Mark Howitt
        Created:	11/11/2004
        Inputs:		EmailListType - the type of list the member belongs to.
					iMemberID - the id of the items memberid.
					iUserID - The ID of the user who owns the list.
					iSiteID - the site on which the list resides.
					NotifyType - the type of notification you want to change the item to.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the notifytype for a given member of a list.

*********************************************************************************/
bool CEmailAlertList::ChangeItemsNotificationType(eEMailListType EMailListType, int iMemberID, int iUserID, int iSiteID, eNotifyType NotifyType)
{
	// Get the id for the users list
	CTDVString sGUID;
	if (!GetListGUIDForUserID(EMailListType,iUserID,iSiteID,false,sGUID))
	{
		// Something went wrong!
		return false;
	}

	// Get the type and id for the item member
	eItemType ItemType = IT_NODE;
	int iItemID = 0;
	if (!GetItemDetailsFromEMailAlertMemberID(EMailListType,iMemberID,NULL,&ItemType,&iItemID,NULL))
	{
		return false;
	}

	// Check to see if we're trying to add a forum, Thread or Post.
	// Check that the forum can be used in instant emails. Also check to see if the current user has permissions to 
	// subscribe to the forum!
	bool bIsUsersPrivateForum = false;
	if ((ItemType == IT_FORUM || ItemType == IT_THREAD || ItemType == IT_POST) && (EMailListType == LT_INSTANTEMAILALERT || NotifyType == NT_PRIVATEMESSAGE))
	{
		// Check the forum permissions for the user
		if (!CheckForumPermissionsForUser(iItemID,ItemType,iUserID,bIsUsersPrivateForum))
		{
			// User not authorised or a problem occured!!
			return false;
		}
	}

	// Check to see if they are trying to put a private message notification on there own private forum!
	if (bIsUsersPrivateForum && NotifyType == NT_PRIVATEMESSAGE)
	{
		// Cannot put an instant private alert on a private forum!
		return SetDNALastError("CEmailAlertList::ChangeItemsNotificationType","CannotInstantPvtMsgAlertOnPvtMessages","Cannot Set Instant Pvt Msg Alerts on Private Forums!");
	}

	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::ChangeItemsNotificationType","FailedToInitStoredProcedure","Failed to intialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.SetNotificationTypeForEmailAlertItem(iMemberID,(int)NotifyType,(int)EMailListType,sGUID))
	{
		return SetDNALastError("CEmailAlertList::ChangeItemsNotificationType","FailedToSetMembersNotifyType","Failed to set the notify type for item");
	}

	// Now create the action result tag
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("ACTION",true);
	bOk = bOk && AddXMLAttribute("TYPE","SetNotifyType");
	bOk = bOk && AddDBXMLIntAttribute("Result",NULL,true,true);
	bOk = bOk && CloseXMLTag("ACTION");

	// Create the XML Tree
	bOk = bOk && CreateFromXMLText(sXML,NULL,true);
	if (!bOk)
	{
		// Set the error string
		SetDNALastError("CEmailAlertList::ChangeItemsNotificationType","FailedToCreateXML","Failed creating XML!");
	}
	return bOk;
}

/*********************************************************************************

	bool CEmailAlertList::ChangeItemMembersListType(int iUserID, int iSiteID, int iMemberID, eEMailListType CurrentListType, eEMailListType NewListType)

		Author:		Mark Howitt
        Created:	16/11/2004
        Inputs:		iUserID - the id of the user who wants to change the EMailListType for the item.
					iSiteID - the id of the site that the item belongs to.
					iMemberID - the member id of the item you want to change the list type for.
					CurrentListType - the current type of list that the item belongs to. Used for checking.
					NewListType - the new type of list you want to change the item to.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Changes the list type that a given item belongs to.

*********************************************************************************/
bool CEmailAlertList::ChangeItemMembersListType(int iUserID, int iSiteID, int iMemberID, eEMailListType CurrentListType, eEMailListType NewListType)
{
	// Get the type and id for the item member
	eItemType ItemType = IT_NODE;
	int iItemID = 0;
	eNotifyType NotifyType = NT_EMAIL;
	if (!GetItemDetailsFromEMailAlertMemberID(CurrentListType,iMemberID,NULL,&ItemType,&iItemID,&NotifyType))
	{
		return false;
	}

	// Check to see if we're trying to add a forum, Thread or Post.
	// Check that the forum can be used in instant emails. Also check to see if the current user has permissions to 
	// subscribe to the forum!
	bool bIsUsersPrivateForum = false;
	if ((ItemType == IT_FORUM || ItemType == IT_THREAD || ItemType == IT_POST) && (NewListType == LT_INSTANTEMAILALERT || NotifyType == NT_PRIVATEMESSAGE))
	{
		// Check the forum permissions for the user
		if (!CheckForumPermissionsForUser(iItemID,ItemType,iUserID,bIsUsersPrivateForum))
		{
			// User not authorised or a problem occured!!
			return false;
		}
	}

	// Check to see if they are trying to put a private message notification on there own private forum!
	if (bIsUsersPrivateForum && NotifyType == NT_PRIVATEMESSAGE)
	{
		// Cannot put an instant private alert on a private forum!
		return SetDNALastError("CEmailAlertList::ChangeItemMembersListType","CannotInstantPvtMsgAlertOnPvtMessages","Cannot Set Instant Pvt Msg Alerts on Private Forums!");
	}

	// Setup the StoredProcedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::ChangeItemMembersListType","FailedToInitStoredProcedure","Failed to intialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.ChangeEMailListTypeForItemMember(iUserID,iSiteID,iMemberID,(int)CurrentListType,(int)NewListType))
	{
		return SetDNALastError("CEmailAlertList::ChangeItemMembersListType","FailedToSetMembersNotifyType","Failed to set the notify type for item");
	}

	// Now create the action result tag
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("ACTION",true);
	bOk = bOk && AddXMLAttribute("TYPE","ChangeEMailListType");
	bOk = bOk && AddDBXMLIntAttribute("Result",NULL,true,true);
	bOk = bOk && CloseXMLTag("ACTION");

	// Create the XML Tree
	bOk = bOk && CreateFromXMLText(sXML,NULL,true);
	if (!bOk)
	{
		// Set the error string
		SetDNALastError("CEmailAlertList::ChangeItemMembersListType","FailedToCreateXML","Failed creating XML!");
	}
	return bOk;
}

/*********************************************************************************

	bool CEmailAlertList::GetItemDetailsFromEMailAlertMemberID(eEMailListType EMailListType, int iMemberID, CTDVString* psGUID, eItemList* pItemType, int* piItemID, eNotyfyType* pNotifyType)

		Author:		Mark Howitt
        Created:	17/11/2004
        Inputs:		EMAilListType - the type of email list the member belongs to.
					iMemberID - The member id of the item you want to get the details for
        Outputs:	psGUID - the guid for the items list.
					pItemType - the type of the item.
					piItemID - The id of the item.
					pNotifyType - the notification type for the item.
        Returns:	true if ok, false if not.
        Purpose:	Gets the details for an item from the memberid

*********************************************************************************/
bool CEmailAlertList::GetItemDetailsFromEMailAlertMemberID(eEMailListType EMailListType, int iMemberID, CTDVString* psGUID, eItemType* pItemType, int* piItemID, eNotifyType* pNotifyType)
{
	// Setup the stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CEmailAlertList::GetItemDetailsFromMemberID","FailedToInitiliseStoredProcedure","Failed to initialise SP!");
	}
	
	// Now call the procedure
	if (!SP.GetItemDetailsFromEMailALertMemberID((int)EMailListType,iMemberID))
	{
		// Problems!!!
		return SetDNALastError("CEmailAlertList::GetItemDetailsFromMemberID","FailedToGetMemberDetails","Failed to get member details");
	}

	// Get the ListID if valid pointer
	if (psGUID != NULL)
	{
		SP.GetField("emailalertlistid",*psGUID);
		psGUID->Replace("-","");
	}

	// Get the ItemType if valid pointer
	if (pItemType != NULL)
	{
        int iItemType = SP.GetIntField("ItemType");
		if (iItemType == (int)IT_NODE)
		{
			*pItemType = IT_NODE;
		}
		else if (iItemType == (int)IT_H2G2)
		{
			*pItemType = IT_H2G2;
		}
		else if (iItemType == (int)IT_CLUB)
		{
			*pItemType = IT_CLUB;
		}
		else if (iItemType == (int)IT_FORUM)
		{
			*pItemType = IT_FORUM;
		}
		else if (iItemType == (int)IT_THREAD)
		{
			*pItemType = IT_THREAD;
		}
		else if (iItemType == (int)IT_POST)
		{
			*pItemType = IT_POST;
		}
		else
		{
			return SetDNALastError("CEmailAlertList::GetItemDetailsFromMemberID","InvalidItemTypeFound","Invalid Item Type Found");
		}
	}

	// Get the ItemID if valid pointer
	if (piItemID != NULL)
	{
		*piItemID = SP.GetIntField("ItemID");
	}

	// Get the NotifyType if valid pointer
	if (pNotifyType != NULL)
	{
		int iNotifyType = SP.GetIntField("NotifyType");
		if (iNotifyType == (int)NT_NONE)
		{
			*pNotifyType = NT_NONE;
		}
		else if (iNotifyType == (int)NT_EMAIL)
		{
			*pNotifyType = NT_EMAIL;
		}
		else if (iNotifyType == (int)NT_PRIVATEMESSAGE)
		{
			*pNotifyType = NT_PRIVATEMESSAGE;
		}
		else 
		{
			return SetDNALastError("CEmailAlertList::GetItemDetailsFromMemberID","InvalidNotificationTypeFound","Invalid Notification Type Found");
		}
	}

	return true;
}

/*********************************************************************************

	bool CEmailAlertList::GetEMailAlertSubscriptionStatusForUser(int iUserID, int iItemID, eItemType ItemType)

		Author:		Mark Howitt
		Created:	27/09/2004
		Inputs:		iUserID - The Id of the user you want to get the status for.
					iItemID - The Item ID you want to check the status for.
		Outputs:	Subscriptions - A list of subscription values.
		Returns:	true if ok, false if not
		Purpose:	Gets the status of the user subscription to a given forum.
					1 = Category List.
					2 = Normal EMail List.
					3 = Instant EMail List.

					NOTE!!! The user might be subscribed for both instant and normal.
							This system is generic and extendable for new types of subscriptions.
		
*********************************************************************************/
bool CEmailAlertList::GetEMailAlertSubscriptionStatusForUser(int iUserID, int iItemID, eItemType ItemType)
{
	// Check the input params
	if (iUserID == 0 || iItemID == 0)
	{
		// Not really a problem, might be called with no user logged in or for a new forum.
		TDVASSERT(false,"CForum::GetEMailAlertSubscriptionStatusForUser - UserID OR ForumID is NULL!");
		return true;
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetUsersEmailAlertSubscriptionForItem(iUserID,iItemID,(int)ItemType))
	{
		TDVASSERT(false,"Stored Procedure failed in CForum::GetEMailAlertSubscriptionStatusForUser!!!");
		return false;
	}

	// Setup the XML Builder
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("EMAIL-SUBSCRIPTION");

	// Get the subscription values
	while (!SP.IsEOF())
	{
		// Get the status value
		bOk = bOk && OpenXMLTag("SUBSCRIPTION",true);
		bOk = bOk && AddDBXMLIntAttribute("EMailListType");
		bOk = bOk && AddDBXMLIntAttribute("ItemID");
		bOk = bOk && AddDBXMLIntAttribute("MemberID");
		bOk = bOk && AddDBXMLIntAttribute("ItemType");
		bOk = bOk && AddDBXMLIntAttribute("NotifyType",NULL,true,true);
		bOk = bOk && CloseXMLTag("SUBSCRIPTION");
		SP.MoveNext();
	}

	// Close the tag
	CloseXMLTag("EMAIL-SUBSCRIPTION");

	// return the verdict!!!
	return bOk && CreateFromXMLText(sXML,NULL,true);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given category
bool CEmailAlertList::GetUserEMailAlertSubscriptionForCategory(int iUserID, int iNodeID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,iNodeID,IT_NODE);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given article
bool CEmailAlertList::GetUserEMailAlertSubscriptionForArticleAndForum(int iUserID, int ih2g2ID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,ih2g2ID,IT_H2G2);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given club
bool CEmailAlertList::GetUserEMailAlertSubscriptionForClubArticleAndForum(int iUserID, int iClubID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,iClubID,IT_CLUB);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given forum
bool CEmailAlertList::GetUserEMailAlertSubscriptionForForumAndThreads(int iUserID, int iForumID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,iForumID,IT_FORUM);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given thread
bool CEmailAlertList::GetUserEMailAlertSubscriptionForThread(int iUserID, int iThreadID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,iThreadID,IT_THREAD);
}

// Purpose:	Wrapper function for Getting the subscription status for the user for a given post
bool CEmailAlertList::GetUserEMailAlertSubscriptionForPost(int iUserID, int iPostID)
{
	return GetEMailAlertSubscriptionStatusForUser(iUserID,iPostID,IT_POST);
}

/*********************************************************************************

	int CEmailAlertList::GetItemTypeFromEnum(eItemType ItemType)

		Author:		Mark Howitt
        Created:	14/09/2004
        Inputs:		ItemType - The enum you want the value for.
        Outputs:	-
        Returns:	The value for the enum.
        Purpose:	Helper function to localise ItemType evaluation
					This function only allowes known enum types, therefore
					ensuring the correct types are only used!

*********************************************************************************/
int CEmailAlertList::GetItemTypeFromEnum(eItemType ItemType)
{
	// Convert the enum into an int
	return ItemType;
}

/*********************************************************************************

	int CEmailAlertList::GetListTypeFromEnum(eEMailListType ListType)

		Author:		Mark Howitt
        Created:	14/09/2004
        Inputs:		ItemList - The enum of the list you want the value for.
        Outputs:	-
        Returns:	The value for the enum.
        Purpose:	Helper function to localise ListType evaluation.
					This function only allowes known enum types, therefore
					ensuring the correct types are only used!

*********************************************************************************/
int CEmailAlertList::GetListTypeFromEnum(eEMailListType ListType)
{
	// Convert the Enum onto an int
	return ListType;
}

/*********************************************************************************

	bool CEmailAlertList::GetEmailStats(int iSiteID)

		Author:		Mark Howitt
		Created:	19/06/2006
		Inputs:		iSiteID - The id of the site you want to get the emailalert stats for.
						If this is 0, then it gets all the sites stats
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Gets the email alert stats for a given site OR all sites

*********************************************************************************/
bool CEmailAlertList::GetEmailStats(int iSiteID)
{
	// Setup and call the GetEmailAlertstats procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP) || !SP.GetEmailAlertStats(iSiteID))
	{
		// Problems!!!
		return SetDNALastError("CEmailAlertList::GetEmailStats","FailedToEmailAlertStats","Failed to email alert stats");
	}

	// Setup the XML for the results
	bool bOk = true;
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);
	XML.OpenTag("EMAILALERTSTATS",true);
	XML.AddIntAttribute("SITEID",iSiteID,true);
	
	// Now see if we've got some thing to report
	int iCount = 0;
	CTDVString sItemType;
	while (!SP.IsEOF())
	{
		// Now get the stats for each type of content
		SP.GetField("ItemType",sItemType);
		iCount = SP.GetIntField("count");
		XML.OpenTag("STATSITEM",true);
		XML.DBAddAttribute("ItemType");
		XML.DBAddIntAttribute("count",NULL,true,true);
		XML.CloseTag("STATSITEM");

		// Get the next entry
		SP.MoveNext();
	}
	
	// Finish by closing the XML tag
	XML.CloseTag("EMAILALERTSTATS");

	// Ok, create the XML and return
	return bOk && CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CEmailAlertList::DisableUserAlerts(iUserID,sGUID)

		Author:		Mark Howitt
		Created:	10/07/2006
		Inputs:		iUserID - The Id of the user you want to disable the alerts for.
					sGUID - The Id of the list you want to disable the alerts for.
		Outputs:	-
		Returns:	true if ok, false if not.
		Purpose:	Disables all alerts for a user.

*********************************************************************************/
bool CEmailAlertList::DisableUserAlerts(int iUserID, CTDVString sGUID)
{
	// Make sure we've been given valid params
	if (iUserID <= 0 || sGUID.IsEmpty())
	{
		// Report the error.
		return SetDNALastError("CEmailAlertList::DisableUserAlerts","InvalidParamsGiven","Invalid params given!!!");
	}

	// Setup a stored procedure and call the disable alerts
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		// Report the error.
		return SetDNALastError("CEmailAlertList::DisableUserAlerts","FailedToInitialiseStoredProcedure","Failed to initialise storedprocdure!!!");
	}

	// Call the function
	if (!SP.DisableUsersEmailAlerts(iUserID,sGUID))
	{
		// Report the error.
		return SetDNALastError("CEmailAlertList::DisableUserAlerts","FailedToDisableUsersAlerts","Failed to disable users alerts!!!");
	}

	// Create some result XML and return
	CTDVString sXML = "<DISABLE-ALERTS>";
	sXML << "<RESULT>OK</RESULT><USERID>" << iUserID << "</USERID><LISTID>" << sGUID << "</LISTID></DISABLE-ALERTS>";
	return CreateFromXMLText(sXML,NULL,true);
}