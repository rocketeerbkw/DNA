#pragma once
#include "xmlbuilder.h"

class CThreadSearchPhraseBuilder : public CXMLBuilder
{
public:
	CThreadSearchPhraseBuilder(CInputContext& InputContext);
	virtual ~CThreadSearchPhraseBuilder(void);
	virtual bool Build(CWholePage* pPage);

private:
	int GetForumFromSite();
	bool CanUserCanPreformAction(CWholePage* pPage, CUser* pUser, bool bEditorAction = true);
};
