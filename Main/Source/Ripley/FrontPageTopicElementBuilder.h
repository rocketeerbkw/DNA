#pragma once
#include "xmlbuilder.h"
#include ".\FrontPageTopicElement.h"

class CFrontPageTopicElementBuilder :	public CXMLBuilder
{
public:
	CFrontPageTopicElementBuilder(CInputContext& inputContext);
	virtual ~CFrontPageTopicElementBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

private:
	CWholePage* m_pWholePage;
	CFrontPageTopicElement m_FrontPageTopicElement;
};
