#pragma once
#include "xmlbuilder.h"
#include "Topic.h"

class CTopicBuilder :	public CXMLBuilder
{
public:
	CTopicBuilder(CInputContext& inputContext);
	virtual ~CTopicBuilder(void);
public:
	virtual bool Build(CWholePage* pPage);
protected:
	bool AddJustDoneAction ( CTDVString sAction, CTDVString sObject/*, bool bResult */ );

	bool BuildEditPage();
private:
	int m_iSiteID;
	CWholePage* m_pWholePage;
	CTopic m_Topic;
public:
	bool AddTopicListToPage(void);
};
