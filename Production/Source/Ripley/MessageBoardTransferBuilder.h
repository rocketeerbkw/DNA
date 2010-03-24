#pragma once
#include "xmlbuilder.h"

class CMessageBoardTransferBuilder : public CXMLBuilder
{
public:
	CMessageBoardTransferBuilder(CInputContext& InputContext);
	virtual ~CMessageBoardTransferBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

protected:
	bool BackupToXML(CWholePage* pPage, int iSiteID);
	bool RestoreFromXML(CWholePage* pPage);
};
