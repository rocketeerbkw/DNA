#pragma once
#include ".\xmlobject.h"

class CCategoryList : public CXMLObject
{
public:
	CCategoryList(CInputContext& inputContext);
	virtual ~CCategoryList(void);

public:
	bool GetCategoryListForGUID(CTDVString& sGUID);
	bool GetUserCategoryLists(int iUserID, int iSiteID, bool bShowUserInfo);
	bool GetCategoryListsNodes(CTDVString& sGUID, CTDVString* pXML = NULL);
	bool ProcessNewCategoryList(int iUserID, int iSiteID, CTDVString& sGUID);
	bool CreateNewCategoryList(int iUserID, int iSiteID, CTDVString& sDestinationUrl, CTDVString& sWebSiteURL, int iOwnerFlag, CTDVString& sXML, CTDVString& sGUID);
	bool DeleteCategoryList(CTDVString& sGUID);
	bool AddNodeToCategoryList(int iNodeID, CTDVString& sGUID, int* piNewMemberID = NULL);
	bool RemoveNodeFromCategoryList(int iNodeID, CTDVString& sGUID);
	bool RenameCategoryList(CTDVString& sGUID, CTDVString& sDescription);
	bool SetListWidth(CTDVString& sGUID, int piListWidth);
	int GetCategoryListOwner(CTDVString& sCategoryListID);
};
