#pragma once
#include "xmlbuilder.h"

class CFastCategoryListBuilder : public CXMLBuilder
{
public:
	CFastCategoryListBuilder(CInputContext& inputContext);
	virtual ~CFastCategoryListBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);
};
