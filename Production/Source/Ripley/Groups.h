#pragma once
#include "xmlobject.h"

class CGroups : public CXMLObject
{
public:
	CGroups(CInputContext& inputContext);
	virtual ~CGroups(void);

public:
	bool GetGroupMembers(const TDVCHAR* psGroupName, int iSiteID, bool bCheckCache = true);

	bool GetGroups();

private:
	bool CreateNewCachePage(int iSiteID, const TDVCHAR* psGroupName);
	bool CheckAndCreateFromCachedPage(int iSiteID, const TDVCHAR* psGroupName);
};
