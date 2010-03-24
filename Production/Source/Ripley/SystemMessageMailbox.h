#pragma once
#include "xmlobject.h"

class CSystemMessageMailbox : public CXMLObject
{
public:
	CSystemMessageMailbox(CInputContext& inputContext);
	virtual ~CSystemMessageMailbox(void);

public:
	bool GetUsersSystemMessageMailbox(int iUserID, int iSiteID, int iSkip, int iShow);
	bool ProcessParams();
	bool DeleteDNASystemMessage(int iMsgID); 
};
